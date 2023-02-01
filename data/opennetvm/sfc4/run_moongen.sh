#!/bin/bash

load="varied_imix_rate.lua" #or imix.lua

if [ $# -gt 0 ]; then
	load=$1
fi

sudo ../../data_collection/run_moongen.sh "${load}"
