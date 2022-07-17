-- This test does the following:
--	1. Send UDP packets from NIC 1 and recieve them back from NIC 2
-- 	2. Read the statistics (i.e., throughput, end-to-end latency) from the recieving device
-- This script demonstrates how to access device specific statistics ("normal" stats and xstats) via DPDK

local mg     = require "moongen"
local memory = require "memory"
local device = require "device"
local ts     = require "timestamping"
local filter = require "filter"
local hist   = require "histogram"
local stats  = require "stats"
local timer  = require "timer"
local log    = require "log"
local ts     = require "timestamping"

local ffi = require "ffi"

-- set addresses and ports here
local DST_MAC     = "5c:b9:01:88:ea:60"
local SRC_IP_BASE = "10.1.0.10"
local DST_IP      = "10.0.0.10"
local SRC_PORT    = 1234
local DST_PORT    = 319

local rate = 10000

local C = ffi.C

function configure(parser)
	parser:description("Generates UDP traffic and prints out device statistics. Edit the source to modify constants like IPs.")
	parser:argument("txDev", "Device to transmit from."):convert(tonumber)
	parser:argument("rxDev", "Device to receive from."):convert(tonumber)
	--parser:argument("rate", "Transmission rate."):convert(tonumber)
end

function master(args)
	txDev = device.config{port = args.txDev, rxQueues = 4, txQueues = 4}
	rxDev = device.config{port = args.rxDev, rxQueues = 4, txQueues = 4}
	device.waitForLinks()

	mg.startTask("loadSlave", txDev:getTxQueue(0), rxDev, rate)
	mg.startTask("timerSlave", txDev:getTxQueue(1), rxDev:getRxQueue(1), 124, 1)
	mg.waitForTasks()
end

local function fillUdpPacket(buf, len)
		buf:getUdpPacket():fill{
		ethSrc = queue,
		ethDst = DST_MAC,
		ip4Src = SRC_IP_BASE,
		ip4Dst = DST_IP,
		udpSrc = SRC_PORT,
		udpDst = DST_PORT,
		pktLength = len
	}
end

--- Runs on the sending NIC
--- Generates UDP traffic and also fetches the stats
function loadSlave(queue, rxDev, rate)
	log:info(green("Starting up: LoadSlave"))

	mg.sleepMillis(3000)
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
		txCtr = stats:newDevTxCounter(queue, "plain")--"CSV", "tx_stats.csv")
		rxCtr = stats:newDevRxCounter(rxDev, "plain")--"CSV", "rx_stats.csv")
	end

	local baseIP = parseIPAddress(SRC_IP_BASE)

	-- Standard IMIX packet sizes 
	local sizes = {60, 60, 60, 60, 60, 60, 60, 566, 566, 566, 566, 1510}
        local limiter = timer:new(10)

        --local rates = {500, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 9464, 9464, 7000, 6000, 5000, 4000, 3000, 2000, 1000, 500} 
        local r = 2

	--os.execute("./perf.sh")

	-- send out UDP packets until the user stops the script
	while mg.running() do
		bufs:alloc(512)

        	--[[
		if limiter:expired()
        	then
            		print( "10s expired")
            		limiter:reset()

            		if r <= #rates
            		then 
                        	rate = rates[r]
				print("Packet rate adjusted to " .. rate .. " Mbps")
            		else
				print("Terminating MoonGen...")
                		break
            		end
			r = r + 1
        	end
		--]]

		queue:setRate(rate)
	
		for i, buf in ipairs(bufs) do
			local newSize = sizes[math.random(#sizes)]
			buf:setSize(newSize)
		end

		-- UDP checksums are optional, so using just IPv4 checksums would be sufficient here
		bufs:offloadUdpChecksums()
		queue:send(bufs)

		txCtr:update()
		rxCtr:update()
       end
       --os.execute("sudo killall MoonGen")
end

function timerSlave(txQueue, rxQueue, size, flows)
	log:info(green("Starting up: timerSlave"))
        if size < 84 then
                log:warn("Packet size %d is smaller than minimum timestamp size 84. Timestamped packets will be larger than load packets.", size)
                size = 84
        end
        local timestamper = ts:newUdpTimestamper(txQueue, rxQueue)

        mg.sleepMillis(2000) -- ensure that the load task is running

        local counter = 0
        local rateLimit = timer:new(0.5)
        local baseIP = parseIPAddress(SRC_IP_BASE)
	latency = {}
        local t = 0

	while mg.running() do
		t = timestamper:measureLatency(size, function(buf)
			fillUdpPacket(buf, size)
			local pkt = buf:getUdpPacket()
			pkt.ip4.src:set(baseIP + counter)
			counter = incAndWrap(counter, flows)
		end) 

                table.insert(latency, t)
                rateLimit:wait()
                rateLimit:reset()
        end

	--os.execute("sudo killall perf")
        -- print the latency stats after all the other stuff
        mg.sleepMillis(300)
   
	latency_test = io.open("latency.csv", "w")
	for i = 1, #latency do
        	latency_test:write(latency[i].. "\n")
	end

        latency_test:close(latency_test)
end

