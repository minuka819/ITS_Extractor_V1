#!/bin/bash

set -euo pipefail

PROJECT_DIR="/home/minuka819/Projects/its_id_project/ITS_Extractor_V1"

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