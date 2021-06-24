# Repository

This repository contains the data, the tables and the scripts used for our ITC2021 paper.

The measurements are specific for our system, which consists of a COTS server with two **Intel Xeon E5-2690 v3 CPUs @ 2.60 GHz** (each with 12 cores and 32k/256k/30720K L1-3 caches) and two **Intel 82599ES dual-port 10 Gbps NICs**.


## Dataset
**data/**: Contains all the original captures from perf

- fulldataset.csv: for fastClick
- fulldataset-all.csv: for all routers

### Features
**normalized_features.csv**: Contains the difference, measured in ratios of the standard deviation, between the average of the single experiment to the global average.

**feature_ids**: Contains the ids of the features used in the heatmap plot


### Similarity
**similarity_matrix**: For each experiment, we plot the cosine similarities w.r.t. other experiments

**examples.tlv**: For three sample experiments, we plot the cosine similarities w.r.t. other experiments

## Contributing

If you want to follow our methodology, you can also do a pull request. It would be nice to have at least the configuration of the system from which the data come from.
