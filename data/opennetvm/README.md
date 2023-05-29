This directory contains some explorative experimental results related to the high-speed [OpenNetVM platform](https://github.com/sdnfv/openNetVM) on a COTS server. 

![fishy](netvm-arch.png)


The experiments include 4 different Service Function Chaining (SFC) settings:

1. Linear 
2. DAG 
3. DAG-2
4. Tree

We conduct two types of experiments:

1. Load stimulus: Perturbing the input traffic with different input rates and traffic patterns. 

2. Resource stimulus: Perturbing the allocated resource to individual VNFs. Currently, we assign collocated parasite processes to each VNF to purturb its CPU share. 

Please refer to each directory for further details. 

# nf_out.csv column names:
nfs[i].tag, nfs[i].instance_id, nfs[i].service_id, nfs[i].thread_info.core, rx_pps, tx_pps, rx, tx, act_out, act_tonf, act_drop, nfs[i].thread_info.parent, state, rte_atomic16_read(&nfs[i].thread_info.children_cnt), rx_drop_rate, tx_drop_rate, rx_drop, tx_drop, act_next, act_buffer, act_returned 
