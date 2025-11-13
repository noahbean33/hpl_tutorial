#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Error: Please provide the number of hosts to check"
    echo "Usage: $0 <number_of_hosts>"
    exit 1
fi

NUM_HOSTS=$1

BASE_HOSTNAME="scc135-cpu"
USER="rocky"

for i in $(seq 0 $((NUM_HOSTS))); do
    ssh-keyscan "${BASE_HOSTNAME}${i}" >> ~/.ssh/known_hosts 2>/dev/null
done

for i in $(seq 0 $((NUM_HOSTS-1))); do
    HOSTNAME="${USER}@${BASE_HOSTNAME}${i}"
    echo "${HOSTNAME}: $(ssh "${HOSTNAME}" "hostname -I")"
done