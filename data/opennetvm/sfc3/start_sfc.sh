#!/bin/bash

CURR_DIR=$(pwd)
ONVM_DIR="/home/tzhang/openNetVM"

cd "${ONVM_DIR}/examples"

python3 run_group.py "${CURR_DIR}/config.json"
