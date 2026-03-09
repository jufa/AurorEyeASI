#!/bin/bash

# Function to get CPU temperature using vcgencmd
get_cpu_temp() {
    vcgencmd measure_temp | awk -F "=" '{print $2}' | tr -d "'C"
}

# Start stress test on 2 CPU cores
stress --cpu 2 &
STRESS_PID=$!

echo "$(date) - Started stress test with PID: $STRESS_PID" >> heater_log.txt

# Monitor CPU temperature
while true; do
    TEMP=$(get_cpu_temp)
    echo "$(date) - Current CPU Temp: $TEMP°C" >> heater_log.txt
    
    if (( $(echo "$TEMP >= 69" | bc -l) )); then
        echo "$(date) - Temperature reached 69°C. Stopping stress test." >> heater_log.txt
        pkill -f stress
        STRESS_PID=""
    elif [[ -z "$STRESS_PID" && $(echo "$TEMP < 65" | bc -l) -eq 1 ]]; then
        echo "$(date) - Temperature dropped below 65°C. Starting stress test." >> heater_log.txt
        stress --cpu 2 &
        STRESS_PID=$!
    fi
    sleep 10
done
