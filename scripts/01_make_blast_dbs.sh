#!/bin/bash

set -euo pipefail

PROJECT_DIR="/home/minuka819/Projects/its_id_project/ITS_Extractor_V1"
GENOME_DIR="$PROJECT_DIR/inputs/genomes/ATCC_mock_genomes"
DB_DIR="$PROJECT_DIR/results/blast_dbs"
LOG_DIR="$PROJECT_DIR/results/logs"

mkdir -p "$DB_DIR" "$LOG_DIR"

for fasta in "$GENOME_DIR"/*/assembly/*.fasta
do
    species_dir=$(basename "$(dirname "$(dirname "$fasta")")")
    db_out="$DB_DIR/${species_dir}_db"

    echo "Building BLAST DB for: $species_dir"
    echo "Genome FASTA: $fasta"
    echo "DB output: $db_out"

    makeblastdb \
        -in "$fasta" \
        -dbtype nucl \
        -out "$db_out" \
        > "$LOG_DIR/${species_dir}_makeblastdb.log" 2>&1

    echo "Done: $species_dir"
    echo "----------------------------------------"
done

echo "All BLAST databases created."