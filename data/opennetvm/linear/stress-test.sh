#!/bin/bash

sudo taskset -c 3 stress --cpu 9 --timeout 10 &
sudo taskset -c 7 stress --cpu 4 --timeout 10 &

