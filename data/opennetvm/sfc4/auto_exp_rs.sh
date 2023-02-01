#!/bin/bash

mkdir -p "resource_stimulus"

for i in {3..9}
do
	for j in 1 3
	do
		for k in {1..5}
		do
			./resource_stimulus.sh "${i}" "${j}" 20
			mkdir -p resource_stimulus/exp-"${i}-${j}-${k}"
			sudo mv *csv "resource_stimulus/exp-${i}-${j}-${k}/"
			sleep 5
		done
	done
done
