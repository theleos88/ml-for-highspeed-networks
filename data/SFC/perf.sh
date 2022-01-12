#!/bin/bash

## Initialization step
pid=$(pidof l2fwd | sed 's/ /,/g')
single_pid=${pid%% *}

click_all_pid=$(pidof click | sed 's/ /,/g')
click_single_pid=${click_all_pid%% *}

sfc=${1:-1}
time_out="5m"
mkdir -p "${sfc}-vnf"

for interval in 1000 500 100
do
freq=$((1000/interval))

# Perf deployed on the same core as the first FastClick process
# Perf stats for all the l2fwd vnfs
#sudo timeout ${time_out} taskset -c 1 perf stat -e instructions,branches,branch-misses,branch-load-misses,cache-misses,cache-references,cycles,context-switches,cpu-clock,minor-faults,page-faults,task-clock,bus-cycles,ref-cycles,L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses,LLC-load-misses,LLC-store-misses,LLC-stores,LLC-loads,dTLB-stores,dTLB-load-misses,dTLB-store-misses,iTLB-loads,iTLB-load-misses,node-load-misses,node-loads,node-store-misses,node-stores \
#	 -x, -o "${sfc}-vnf/${sfc}-vnf-collocated-core-freq-${freq}-all-vnfs.txt" -r 1 -p ${pid} -I ${interval}

# Perf stats for the first l2fwd vnf
#sudo timeout ${time_out} taskset -c 1 perf stat -e instructions,branches,branch-misses,branch-load-misses,cache-misses,cache-references,cycles,context-switches,cpu-clock,minor-faults,page-faults,task-clock,bus-cycles,ref-cycles,L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses,LLC-load-misses,LLC-store-misses,LLC-stores,LLC-loads,dTLB-stores,dTLB-load-misses,dTLB-store-misses,iTLB-loads,iTLB-load-misses,node-load-misses,node-loads,node-store-misses,node-stores \
#	 -x, -o "${sfc}-vnf/${sfc}-vnf-collocated-core-freq-${freq}-single-vnf.txt" -r 1 -p ${single_pid} -I ${interval}

# Perf stats for all fastclick processes
#sudo timeout ${time_out} taskset -c 1 perf stat -e instructions,branches,branch-misses,branch-load-misses,cache-misses,cache-references,cycles,context-switches,cpu-clock,minor-faults,page-faults,task-clock,bus-cycles,ref-cycles,L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses,LLC-load-misses,LLC-store-misses,LLC-stores,LLC-loads,dTLB-stores,dTLB-load-misses,dTLB-store-misses,iTLB-loads,iTLB-load-misses,node-load-misses,node-loads,node-store-misses,node-stores \
#         -x, -o "${sfc}-vnf/${sfc}-vnf-collocated-core-freq-${freq}-all-fastclick.txt" -r 1 -p ${click_all_pid} -I ${interval}

# Perf stats for the first fastclick process
#sudo timeout ${time_out} taskset -c 1 perf stat -e instructions,branches,branch-misses,branch-load-misses,cache-misses,cache-references,cycles,context-switches,cpu-clock,minor-faults,page-faults,task-clock,bus-cycles,ref-cycles,L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses,LLC-load-misses,LLC-store-misses,LLC-stores,LLC-loads,dTLB-stores,dTLB-load-misses,dTLB-store-misses,iTLB-loads,iTLB-load-misses,node-load-misses,node-loads,node-store-misses,node-stores \
#         -x, -o "${sfc}-vnf/${sfc}-vnf-collocated-core-freq-${freq}-single-fastclick.txt" -r 1 -p ${click_single_pid} -I ${interval}

## Perf deployed on an independent core
# Perf stats for all the l2fwd vnfs
sudo timeout ${time_out} taskset -c 22 perf stat -e instructions,branches,branch-misses,branch-load-misses,cache-misses,cache-references,cycles,context-switches,cpu-clock,minor-faults,page-faults,task-clock,bus-cycles,ref-cycles,L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses,LLC-load-misses,LLC-store-misses,LLC-stores,LLC-loads,dTLB-stores,dTLB-load-misses,dTLB-store-misses,iTLB-loads,iTLB-load-misses,node-load-misses,node-loads,node-store-misses,node-stores \
         -x, -o "${sfc}-vnf/${sfc}-vnf-independent-core-freq-${freq}-all-vnfs.txt" -r 1 -p ${pid} -I ${interval}

# Perf stats for the first l2fwd vnf
sudo timeout ${time_out} taskset -c 22 perf stat -e instructions,branches,branch-misses,branch-load-misses,cache-misses,cache-references,cycles,context-switches,cpu-clock,minor-faults,page-faults,task-clock,bus-cycles,ref-cycles,L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses,LLC-load-misses,LLC-store-misses,LLC-stores,LLC-loads,dTLB-stores,dTLB-load-misses,dTLB-store-misses,iTLB-loads,iTLB-load-misses,node-load-misses,node-loads,node-store-misses,node-stores \
         -x, -o "${sfc}-vnf/${sfc}-vnf-independent-core-freq-${freq}-single-vnf.txt" -r 1 -p ${single_pid} -I ${interval}

sudo timeout ${time_out} taskset -c 22 perf stat -e instructions,branches,branch-misses,branch-load-misses,cache-misses,cache-references,cycles,context-switches,cpu-clock,minor-faults,page-faults,task-clock,bus-cycles,ref-cycles,L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses,LLC-load-misses,LLC-store-misses,LLC-stores,LLC-loads,dTLB-stores,dTLB-load-misses,dTLB-store-misses,iTLB-loads,iTLB-load-misses,node-load-misses,node-loads,node-store-misses,node-stores \
         -x, -o "${sfc}-vnf/${sfc}-vnf-independent-core-freq-${freq}-all-fastclick.txt" -r 1 -p ${click_all_pid} -I ${interval}

#sudo timeout ${time_out} taskset -c 22 perf stat -e instructions,branches,branch-misses,branch-load-misses,cache-misses,cache-references,cycles,context-switches,cpu-clock,minor-faults,page-faults,task-clock,bus-cycles,ref-cycles,L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses,LLC-load-misses,LLC-store-misses,LLC-stores,LLC-loads,dTLB-stores,dTLB-load-misses,dTLB-store-misses,iTLB-loads,iTLB-load-misses,node-load-misses,node-loads,node-store-misses,node-stores \
#         -x, -o "${sfc}-vnf/${sfc}-vnf-independent-core-freq-${freq}-single-fastclick.txt" -r 1 -p ${click_single_pid} -I ${interval}

done
