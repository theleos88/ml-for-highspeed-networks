#!/bin/bash
cpu=3
load=1
timeout=20

if [ $# -gt 0 ]; then
	cpu=$1
	load=$2
	timeout=$3
fi

./run_moongen.sh imix.lua &

sleep 25

sudo taskset -c "${cpu}" stress --cpu "${load}" --timeout "${timeout}s"

sleep 10

sudo killall MoonGen
