#!/bin/bash

for i in {1..10}
do
	./run_moongen.sh
	sudo mv *csv "load_stimulus/exp${i}/"
done
