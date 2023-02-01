#!/bin/bash

# Select the intended lua script in the lua/ directory
config="varied_imix_rate.lua"

if [ $# -gt 0 ]; then
	config=$1
fi

sudo ../../data_collection/run_moongen.sh "lua/${config}"
