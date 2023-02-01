#!/bin/bash

ONVM_HOME="/home/tzhang/openNetVM"
PROJECT_HOME="/home/tzhang/rca-nfv"
CURR_DIR="$(pwd)"

# clear the output files of the past experiments
sudo rm -f "${ONVM_HOME}/nf_out.csv"

# start ONVM manager
#../start_onvm_mgr.sh &
#cd "${ONVM_HOME}"
#./onvm/go.sh -m 0,1,2 -k 3 -n 0x3F8 -s stdout &
#sleep 5
#cd "${CURR_DIR}"

# start service function chain configuration
#./start_sfc.sh &
#sleep 1

sudo ./run_moongen.sh onvm_global.lua

sleep 1

#sudo killall onvm_mgr
#sudo killall MoonGen

sleep 1

cp "${ONVM_HOME}/nf_out.csv" .
