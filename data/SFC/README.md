## Perf data for SFCs
Data are collected for 1-5 VNF SFC cases. Each file contains 5 min statistics. More details are explained as follows. 

### The key configuration parameters include:
1. SFC length (varialbe ${sfc}): range from 1 to 5.
2. Perf core location: 
   - collocated: Perf is deployed on the same core as the first FastClick thread. 
   - independent: Perf is deployed on an independent core on the same NUMA node.
3. Perf stat collection frequency (${freq}): the inverse of the Perf stat interval, i.e., 1s, 0.5s, and 0.1s. 
4. Target: the target process statistics Perf is configured to collect. 
   - all-vnfs: Perf collects stats for all the running VNFs. 
   - single-vnf: Perf collects stats for the first VNF in the SFC.
   - all-fastclick: Perf collects stats for FastClick. 
     
     Note that Fastclick is a multi-threading program, so it only has a single pid. So we exclude the "single-fastclick" experiments since they are exactly the same as "all-fastclick" experiments.  

### Naming convention for each collected file: 
"${sfc}"-vnf-{collocated, independent}-core-freq-"${freq}"-{all-vnfs, single-vnf, all-fastclick}.txt 

e.g., 1-vnf-collocated-core-freq-1-all-vnfs.txt

All the data are collected using the **perf.sh** script. 
