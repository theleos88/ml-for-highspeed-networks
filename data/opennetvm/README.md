This directory contains our explorative experiments of the state-of-the-art OpenNetVM (ONVM) on a commodity off-the-shelf server. Our experiments focus on the performance diagnoses of ONVM. Please refer to the [main website]((https://github.com/sdnfv/openNetVM)) for further information. The general architecture of ONVM is illustrated below: 

![fishy](netvm-arch.png)


The experiments include 3 different Service Function Chaining (SFC) configurations, namely:

1. Linear 
2. DAG 
3. DAG-2

We conduct three types of experiments:

1. Load stimulus: Perturbing the input traffic with different input rates and patterns. 

2. Resource stimulus: Perturbing the allocated resource to individual VNFs. Currently, we assign collocated parasite processes to each VNF to perturb its CPU share.

3. The combination of the previous two experiments. 

Please refer to each SFC directory for further details. 

# nf_out.csv column names:
nfs[i].tag, nfs[i].instance_id, nfs[i].service_id, nfs[i].thread_info.core, rx_pps, tx_pps, rx, tx, act_out, act_tonf, act_drop, nfs[i].thread_info.parent, state, rte_atomic16_read(&nfs[i].thread_info.children_cnt), rx_drop_rate, tx_drop_rate, rx_drop, tx_drop, act_next, act_buffer, act_returned 
