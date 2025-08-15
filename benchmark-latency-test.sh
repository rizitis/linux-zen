#!/bin/bash
# Latency/responsiveness test
# Auto-detects CPU threads and logs results
# Compatible with most Linux systems and UNIX like (a.k.a Slackware) ;)

# --- HOWTO --- #
# Ran script (current stock kernel) ones all apps must be stopped.
# Ran script for second time but load a modern Game or an llm or both.
# Compare results.

# After install zen kernel boot system and repeat test and compare ...
#
# If you system on heavy background CPU tasks (video encoding, compiling, llm) stuck you might also need BORE patch on top of PREEMPT_FULL that this zen kernel provide.
# I havent use it because I dont need it.

# Here’s the distinction:

# PREEMPT_FULL:
# Controls when the kernel lets user tasks interrupt kernel code.
# Reduces scheduling latency from kernel-to-user space.
# Main effect: snappier responsiveness, less input lag, better audio/video stability.
#
# BORE CPU scheduler:
# Changes how the scheduler decides which task runs next.
# Aims to favor short, interactive tasks over long CPU-hogs.
# Main effect: foreground apps stay smooth even under heavy background load.
#
# Think of it like this:
# PREEMPT_FULL is like giving traffic lights a “green for emergency vehicles” mode — faster reaction.
# BORE is like reorganizing the whole traffic flow to prioritize small cars and buses over giant trucks.

set -e

# Detect number of logical CPUs
NUM_THREADS=$(nproc)
echo "Detected $NUM_THREADS logical CPUs/threads."

# Create log directory
LOG_DIR="./latency_logs"
mkdir -p "$LOG_DIR"

# Helper function to measure latency
measure_latency() {
    local output_file="$1"
    local duration="$2"
    local end_time=$((SECONDS + duration))
    > "$output_file"

    while [ $SECONDS -lt $end_time ]; do
        start=$(date +%s%6N) # microseconds
        end=$(date +%s%6N)
        latency=$((end - start))
        echo "$latency" >> "$output_file"
    done
}

# Run baseline test (no load)
echo "Measuring baseline latency..."
measure_latency "$LOG_DIR/baseline.log" 5

# Run CPU load test
echo "Starting CPU load test with $NUM_THREADS threads..."
# Spawn CPU stress in background
for ((i=0; i<NUM_THREADS; i++)); do
    yes > /dev/null &
    PIDS[i]=$!
done

echo "Measuring cpu_load latency..."
measure_latency "$LOG_DIR/cpu_load.log" 5

# Kill CPU load
for pid in "${PIDS[@]}"; do
    kill "$pid" 2>/dev/null || true
done
wait 2>/dev/null

# Function to calculate stats
calculate_stats() {
    local file="$1"
    awk 'BEGIN{min=1e12; max=0; sum=0; count=0}
    {sum+=$1; count++; if($1<min){min=$1} if($1>max){max=$1}}
    END{if(count>0){printf "Avg=%d µs  Min=%d µs  Max=%d µs\n", sum/count, min, max}}' "$file"
}

# Print summary
echo "=== Test Summary ==="
for file in "$LOG_DIR"/*.log; do
    echo "File: $file"
    calculate_stats "$file"
done

echo "Done. Logs saved in $LOG_DIR/"
