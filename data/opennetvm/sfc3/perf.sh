#!/bin/bash

# Declare an array of string with type
declare -a StringArray=( "flow_tracker" "ndpi_stats" "nf_router" "payload_scan" "bridge" )

# Iterate the string array using for loop
for val in ${StringArray[@]}; do
   echo "VNF: " "${val}"
   sudo perf stat -e instructions,branches,branch-misses,branch-load-misses,cache-misses,cache-references,cycles,context-switches,cpu-clock,minor-faults,page-faults,task-clock,bus-cycles,ref-cycles,L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses,LLC-load-misses,LLC-store-misses,LLC-stores,LLC-loads,dTLB-stores,dTLB-load-misses,dTLB-store-misses,iTLB-loads,iTLB-load-misses,node-load-misses,node-loads,node-store-misses,node-stores  \
               -x, -o "${val}.csv" -r 100 -p $(pidof "${val}") -I 1000 &
done
