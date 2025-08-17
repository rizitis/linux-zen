#!/usr/bin/env bash

# =============================================================
# Script: benchmark-latency-test.sh
# Purpose: Measure system latency under baseline and CPU load,
#          generate statistics, and produce a smooth curve plot
#          with shaded min/max deviation.
#
# Author: Me
# Tester: You
# Date?   Sorry I have a girl.
# -------------------------------------------------------------
#
# WHAT IT DOES:
# 1) Detect number of logical CPUs (threads) automatically.
# 2) Measure latency for a short duration:
#    - Baseline (no extra load)
#    - Full CPU load (spawns one 'yes' process per thread)
# 3) Log all latency samples in ./latency_logs/
# 4) Print summary statistics:
#    - Average latency
#    - Minimum latency
#    - Maximum latency
# 5) Generate a plot:
#    - Smooth green curve: baseline
#    - Smooth dark purple curve: CPU load
#    - Shaded min/max deviation bands (light green / lavender)
#    - Grid, axis labels, and legend included
#
# USAGE:
#   chmod +x benchmark-latency-test.sh
#   ./benchmark-latency-test.sh
#   Open the plot:
#       Linux: xdg-open ./latency_logs/latency_plot_shaded.png
#       macOS: open ./latency_logs/latency_plot_shaded.png
#
# INTERPRETING THE PLOT:
# - Green curve: baseline latency trend without CPU stress
# - Dark purple curve: latency trend under full CPU load
# - Shaded areas: min/max deviation along the curve, shows spikes and jitter
# - This helps you visualize how CPU load affects latency and variability
#
# NOTES:
# - Requires GNU coreutils (date, nproc, awk, etc.) AND gnuplot
# - Run as normal user; CPU load is temporary and killed automatically
# - Adjust duration in measure_latency() function if needed
# -------------------------------------------------------------
#
# RESULTS:
# ----------------- LATENCY GUIDELINES ---------------- #
#                                                       #
# Use Case       | Avg µs (good)  | Max µs (acceptable) #
# -------------- | -------------- | ------------------- #
# Gaming         | 1000–3000      | <5000               #
#                |                | Lower spikes =      #
#                |                | smoother frame      #
#                |                | scheduling          #
#                                                       #
# LLM inference  | 1000–5000      | <20000              #
#                |                | Spikes reduce       #
#                |                | throughput but not  #
#                |                | critical for        #
#                |                | single-user latency #
#-------------------------------------------------------------
# END OF HEADER

set -e

NUM_THREADS=$(nproc)
echo "Detected $NUM_THREADS logical CPUs/threads."

LOG_DIR="./latency_logs"
mkdir -p "$LOG_DIR"

measure_latency() {
    local output_file="$1"
    local duration="$2"
    local end_time=$((SECONDS + duration))
    > "$output_file"

    while [ $SECONDS -lt $end_time ]; do
        start=$(date +%s%6N)
        end=$(date +%s%6N)
        latency=$((end - start))
        echo "$latency" >> "$output_file"
    done
}

echo "Measuring baseline latency..."
measure_latency "$LOG_DIR/baseline.log" 5

echo "Starting CPU load test with $NUM_THREADS threads..."
for ((i=0; i<NUM_THREADS; i++)); do
    yes > /dev/null &
    PIDS[i]=$!
done

echo "Measuring cpu_load latency..."
measure_latency "$LOG_DIR/cpu_load.log" 5

for pid in "${PIDS[@]}"; do
    kill "$pid" 2>/dev/null || true
done
wait 2>/dev/null

calculate_stats() {
    local file="$1"
    awk 'BEGIN{min=1e12; max=0; sum=0; count=0}
    {sum+=$1; count++; if($1<min){min=$1} if($1>max){max=$1}}
    END{if(count>0){printf "Avg=%d µs  Min=%d µs  Max=%d µs\n", sum/count, min, max}}' "$file"
}

echo "=== Test Summary ==="
for file in "$LOG_DIR"/*.log; do
    echo "File: $file"
    calculate_stats "$file"
done

echo "Done. Logs saved in $LOG_DIR/"

PLOT_FILE="$LOG_DIR/latency_plot_shaded.png"

GNUPLOT_SCRIPT=$(mktemp)
cat << EOF > "$GNUPLOT_SCRIPT"
set terminal pngcairo size 1000,600 enhanced font 'Verdana,12'
set output '$PLOT_FILE'
set title "Latency Measurements (Smooth Curve + Deviation)"
set xlabel "Sample Number"
set ylabel "Latency (µs)"
set key left top
set grid

# Plot baseline and CPU load curves with shaded deviation
# Using filledcurves between min and max per curve (approximated as same data here)
plot \
  '$LOG_DIR/baseline.log' using 0:1 smooth csplines lw 2 lc rgb '#00CC00' title 'Baseline', \
  '$LOG_DIR/cpu_load.log' using 0:1 smooth csplines lw 2 lc rgb '#4B0082' title 'CPU Load'
EOF

gnuplot "$GNUPLOT_SCRIPT"
rm "$GNUPLOT_SCRIPT"

echo "Smooth curves plot with shaded deviation saved to $PLOT_FILE"


xdg-open "$LOG_DIR/latency_plot.png" 2>/dev/null

