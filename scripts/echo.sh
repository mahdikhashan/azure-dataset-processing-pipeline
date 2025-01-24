#!/bin/bash

tasks=(
    "echo 'Hello from Node 1'"
    "echo 'Greetings from Node 2'"
    "echo 'Welcome to Azure Batch'"
)

for i in "${!tasks[@]}"; do
    task_command="${tasks[i]}"
    az batch task create \
        --job-id "echo-job" \
        --task-id "task-$i" \
        --command-line "$task_command"
done

az batch job wait \
    --job-id "echo-job" \
    --timeout 5m
