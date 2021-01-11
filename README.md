# Repository

This repository contains the data, the tables and the scripts used for our ATC2021 paper.

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

