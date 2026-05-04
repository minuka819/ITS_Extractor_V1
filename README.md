# ITS Extractor Pipeline (V1 - WIP)
## Overview

This project provides a simple pipeline to extract and annotate fungal rDNA regions
(SSU – ITS1 – 5.8S – ITS2 – LSU) from whole genome assemblies.

### Problem
ITS regions are widely used for fungal identification
Whole genomes are not pre-annotated for ITS regions
ITS-only sequences lack surrounding SSU/LSU context
Manual extraction and annotation is time-consuming
Solution

This pipeline automates:

BLAST ITS sequences against whole genomes
Extract rDNA regions surrounding ITS hits
Correct strand orientation (reverse complement if needed)
Use ITSx to identify SSU / ITS / LSU boundaries
Generate annotated GenBank files
Workflow

ITS query → BLAST → extract region → orientation fix → ITSx → GenBank

Output

For each genome:

Annotated .gbk file containing:
18S (SSU)
ITS1
5.8S
ITS2
28S (LSU)
Usage
Setup environment

conda env create -f environment.yml
conda activate ITS_Extractor_V1

Run pipeline

bash scripts/01_make_blast_dbs.sh
bash scripts/02_blast_its_to_genomes.sh
bash scripts/03_extract_rdna.sh
bash scripts/04_run_ITSx.sh
python scripts/05_make_genbank.py

Notes
Input genomes are not included due to size
Paths are currently hardcoded (will be improved in future versions)
Pipeline tested on fungal mock genomes
Status

## 🚧 Work in Progress (V1)

Future Improvements
Remove hardcoded paths
Automate ITS query matching per species
Single-command pipeline execution
Primer
