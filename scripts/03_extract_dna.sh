#!/bin/bash

set -euo pipefail


source config.sh
BLAST_DIR="$PROJECT_DIR/results/blast_hits"
GENOME_DIR="$PROJECT_DIR/inputs/genomes/ATCC_mock_genomes"
OUT_DIR="$PROJECT_DIR/results/extracted_regions"
RC_DIR="$PROJECT_DIR/results/corrected_regions"

mkdir -p "$OUT_DIR" "$RC_DIR"

BUFFER=2500

for blast_file in "$BLAST_DIR"/*_hits.tsv
do
    species=$(basename "$blast_file" _hits.tsv)

    echo "Processing: $species"

    # Get top hit (first line)
    line=$(head -n 1 "$blast_file")

    contig=$(echo "$line" | awk '{print $2}')
    sstart=$(echo "$line" | awk '{print $9}')
    send=$(echo "$line" | awk '{print $10}')

    echo "Contig: $contig"
    echo "sstart: $sstart"
    echo "send: $send"

    # Find genome fasta
    genome=$(ls "$GENOME_DIR"/*"$species"*"/assembly/"*.fasta)

    # Determine region
    if (( sstart < send )); then
        start=$((sstart - BUFFER))
        end=$((send + BUFFER))
        strand="forward"
    else
        start=$((send - BUFFER))
        end=$((sstart + BUFFER))
        strand="reverse"
    fi

    # Prevent negative coordinates
    if (( start < 1 )); then
        start=1
    fi

    region="${contig}:${start}-${end}"

    echo "Extracting: $region"

    # Index genome if needed
    samtools faidx "$genome"

    samtools faidx "$genome" "$region" > "$OUT_DIR/${species}_rDNA.fasta"

    # Fix orientation
    if [[ "$strand" == "reverse" ]]; then
        echo "Reverse complementing..."
        seqtk seq -r "$OUT_DIR/${species}_rDNA.fasta" > "$RC_DIR/${species}_rDNA_rc.fasta"
    else
        cp "$OUT_DIR/${species}_rDNA.fasta" "$RC_DIR/${species}_rDNA_rc.fasta"
    fi

    echo "Done: $species"
    echo "----------------------------------------"

done

echo "All regions extracted and corrected."