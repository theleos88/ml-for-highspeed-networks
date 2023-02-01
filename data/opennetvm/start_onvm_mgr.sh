#!/bin/bash

onvm="/home/tzhang/openNetVM"

cd "${onvm}"

./onvm/go.sh -m 0,1,2 -k 3 -n 0x3F8 -s stdout
