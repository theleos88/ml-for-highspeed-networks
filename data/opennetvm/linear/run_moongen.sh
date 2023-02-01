#!/bin/bash

traffic_config="varied_imix_rate.lua"

if [ $# -gt 0 ]; then
	traffic_config=$1
fi

sudo ../../data_collection/run_moongen.sh "${traffic_config}"
