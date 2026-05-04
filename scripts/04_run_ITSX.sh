#!/bin/bash

set -euo pipefail

source config.sh

INPUT_DIR="$PROJECT_DIR/results/corrected_regions"
OUT_DIR="$PROJECT_DIR/results/itsx"

mkdir -p "$OUT_DIR"

for fasta in "$INPUT_DIR"/*_rDNA_rc.fasta
do
    species=$(basename "$fasta" _rDNA_rc.fasta)

    echo "Running ITSx for: $species"

    ITSx \
      -i "$fasta" \
      -o "$OUT_DIR/${species}" \
      --cpu 4

    echo "Done: $species"
    echo "----------------------------------------"
done

echo "All ITSx runs complete."