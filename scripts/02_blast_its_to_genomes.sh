#!/bin/bash

set -euo pipefail

PROJECT_DIR="/home/minuka819/Projects/its_id_project/ITS_Extractor_V1"
QUERY_DIR="$PROJECT_DIR/inputs/its_queries/split"
DB_DIR="$PROJECT_DIR/results/blast_dbs"
OUT_DIR="$PROJECT_DIR/results/blast_hits"

mkdir -p "$OUT_DIR"

for query in "$QUERY_DIR"/*.fasta
do
    species=$(basename "$query" .fasta)

    db=$(ls "$DB_DIR"/*"$species"*"_db.nsq" | sed 's/.nsq$//' | head -n 1)

    echo "Running BLAST for: $species"
    echo "Query: $query"
    echo "DB: $db"

    blastn \
      -query "$query" \
      -db "$db" \
      -out "$OUT_DIR/${species}_hits.tsv" \
      -outfmt 6

    echo "Done: $species"
    echo "----------------------------------------"
done

echo "All ITS BLAST searches complete."
