#!/bin/bash

if [[ -z "${PASSWORD}" ]]; then
	echo "Must provide env PASSWORD"
	exit 1
fi

echo "${USERNAME} ${PASSWORD}" > ${RSERVE_HOME}/etc/Rserv.pwd

R -e 'library(Rserve)' -e 'run.Rserve(config.file = "${RSERVE_HOME}/etc/Rserv.conf")'
