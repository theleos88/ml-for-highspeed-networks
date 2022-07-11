-- This test does the following:
--	1. Send UDP packets from NIC 1 to NIC 2
-- 	2. Read the statistics from the recieving device
-- This script demonstrates how to access device specific statistics ("normal" stats and xstats) via DPDK

local mg     = require "moongen"
local memory = require "memory"
local device = require "device"
local ts     = require "timestamping"
local filter = require "filter"
local hist   = require "histogram"
local stats  = require "stats"
local timer  = require "timer"
local arp    = require "proto.arp"
local log    = require "log"

local ffi = require "ffi"

-- set addresses and ports here
local DST_MAC     = "5c:b9:01:88:ea:60"
local SRC_IP_BASE = "10.0.0.10"
local DST_IP      = "10.1.0.10"
local SRC_PORT    = 1234
local DST_PORT    = 319

local C = ffi.C

function configure(parser)
	parser:description("Generates UDP traffic and prints out device statistics. Edit the source to modify constants like IPs.")
	parser:argument("txDev", "Device to transmit from."):convert(tonumber)
	parser:argument("rxDev", "Device to receive from."):convert(tonumber)
end

function master(args)
	txDev = device.config{port = args.txDev, rxQueues = 4, txQueues = 4}
	rxDev = device.config{port = args.rxDev, rxQueues = 4, txQueues = 4}
	device.waitForLinks()

	mg.startTask("loadSlave", txDev:getTxQueue(0), rxDev, 60)
	mg.waitForTasks()
end

local function fillUdpPacket(buf, len)
		buf:getUdpPacket():fill{
		ethSrc = queue,
		ethDst = DST_MAC,
		ip4Src = SRC_IP,
		ip4Dst = DST_IP,
		udpSrc = SRC_PORT,
		udpDst = DST_PORT,
		pktLength = len
	}
end

--- Runs on the sending NIC
--- Generates UDP traffic and also fetches the stats
function loadSlave(queue, rxDev, size)
	log:info(green("Starting up: LoadSlave"))

	-- retrieve the number of xstats on the recieving NIC
	-- xstats related C definitions are in device.lua
	local numxstats = 0
        local xstats = ffi.new("struct rte_eth_xstat[?]", numxstats)

	-- because there is no easy function which returns the number of xstats we try to retrieve
	-- the xstats with a zero sized array
	-- if result > numxstats (0 in our case), then result equals the real number of xstats
	local result = C.rte_eth_xstats_get(rxDev.id, xstats, numxstats)
	numxstats = tonumber(result)

	local mempool = memory.createMemPool(function(buf)
		fillUdpPacket(buf, size)
	end)
	local bufs = mempool:bufArray()

	if queue.qid == 0
	then
		txCtr = stats:newDevTxCounter(queue, "CSV", "tx_stats.csv")
		rxCtr = stats:newDevRxCounter(rxDev, "plain")
	end

	local baseIP = parseIPAddress(SRC_IP_BASE)

	-- Standard IMIX packet sizes 
	local sizes = {60, 60, 60, 60, 60, 60, 60, 566, 566, 566, 566, 1510}
        local limiter = timer:new(10)

        local rates = {500, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 9464, 9464, 7000, 6000, 5000, 4000, 3000, 2000, 1000, 500} 
        local r = 2
        local rate=rates[1]

	-- send out UDP packets until the user stops the script
	while mg.running() do
		bufs:alloc(size)

        	if limiter:expired()
        	then
            		print( "10s expired")
            		limiter:reset()

            		if r <= #rates
            		then 
                        	rate = rates[r]
				print("Packet rate adjusted to " .. rate .. " Mbps")
            		else
                		break
            		end
			r = r + 1
        	end

		queue:setRate(rate)
	
		for i, buf in ipairs(bufs) do
			local newSize = sizes[math.random(#sizes)]
			buf:setSize(newSize)
		end

		-- UDP checksums are optional, so using just IPv4 checksums would be sufficient here
		bufs:offloadUdpChecksums()
		queue:sendWithDelay(bufs)

		txCtr:update()
		rxCtr:update()
	end

	--txCtr:finalize()
	--rxCtr:finalize()
end
