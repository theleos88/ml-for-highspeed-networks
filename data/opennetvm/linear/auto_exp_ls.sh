#!/bin/bash

mkdir -p "load_stimulus"

for i in {1..10}
do
	./run_moongen.sh
	mkdir -p "load_stimulus/exp${i}/"
	sudo mv *csv "load_stimulus/exp${i}/"
done
