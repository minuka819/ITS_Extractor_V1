#!/bin/bash

set -euo pipefail

PROJECT_DIR="/home/minuka819/Projects/its_id_project/ITS_Extractor_V1"
INPUT_FASTA="$PROJECT_DIR/inputs/its_queries/ITS_Only_Sequences_From_NCBI.fasta"
OUT_DIR="$PROJECT_DIR/inputs/its_queries/split"

mkdir -p "$OUT_DIR"

awk -v outdir="$OUT_DIR" '
    /^>/ {
        if (out) close(out)

        header=$0
        gsub(/^>/, "", header)

        # Make filename from first two species words after accession
        split(header, parts, " ")
        genus=parts[2]
        species=parts[3]

        filename=genus "_" species ".fasta"
        gsub(/[^A-Za-z0-9_.-]/, "_", filename)

        out=outdir "/" filename
        print $0 > out
        next
    }

    {
        print $0 >> out
    }
' "$INPUT_FASTA"

echo "Split ITS queries into: $OUT_DIR"
ls "$OUT_DIR"