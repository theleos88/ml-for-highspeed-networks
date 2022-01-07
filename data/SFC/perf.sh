#!/bin/bash

##Perf on a collocated core with varied frequencies
pid=$(pidof l2fwd | sed 's/ /,/g')
sfc=${1:-1}
time_out="5m"
mkdir -p "${sfc}-vnf"

for interval in 1000 500 100
do
freq=$((1000/interval))
sudo timeout ${time_out} taskset -c 1 perf stat -e instructions,branches,branch-misses,branch-load-misses,cache-misses,cache-references,cycles,context-switches,cpu-clock,minor-faults,page-faults,task-clock,bus-cycles,ref-cycles,L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses,LLC-load-misses,LLC-store-misses,LLC-stores,LLC-loads,dTLB-stores,dTLB-load-misses,dTLB-store-misses,iTLB-loads,iTLB-load-misses,node-load-misses,node-loads,node-store-misses,node-stores \
	 -x, -o "${sfc}-vnf/${sfc}-vnf-collocated-core-freq-${freq}.txt" -r 1 -p ${pid} -I ${interval}
done


##Perf on an independent core (freq=10)
pid=$(pidof l2fwd | sed 's/ /,/g')
sudo timeout ${time_out} taskset -c 22 perf stat -e instructions,branches,branch-misses,branch-load-misses,cache-misses,cache-references,cycles,context-switches,cpu-clock,minor-faults,page-faults,task-clock,bus-cycles,ref-cycles,L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses,LLC-load-misses,LLC-store-misses,LLC-stores,LLC-loads,dTLB-stores,dTLB-load-misses,dTLB-store-misses,iTLB-loads,iTLB-load-misses,node-load-misses,node-loads,node-store-misses,node-stores \
         -x, -o "${sfc}-vnf/${sfc}-vnf-independent-core-freq-10.txt" -r 1 -p ${pid} -I 100
