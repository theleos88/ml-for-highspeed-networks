#!/bin/bash

# This script is created to measure the throughput and latency of the target NFV data plane

# Default values to some system-level parameters.
MOONGEN_DIR="/home/tzhang/MoonGen/"
CURR_DIR="$(pwd)"
IN_PORT=0
OUT_PORT=1

if [[ "${UID}" -ne 0 ]]
then
	echo "Need root priviledge to execute"
	exit 1
fi

usage(){ echo "Usage: ${0} [-s packet size][-r packet rate]"; exit 1; }

while getopts ":s:r:" arg; do
	case "${arg}" in
		s)
			size="${OPTARG}"
			;;
		r)
			rate="${OPTARG}"
			;;
		h | : | *)
			usage
			;;
	esac
done

sudo "${MOONGEN_DIR}"/build/MoonGen "${1}" "${IN_PORT}" "${OUT_PORT}"
