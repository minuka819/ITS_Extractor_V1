import os
import re
from Bio import SeqIO
from Bio.SeqFeature import SeqFeature, FeatureLocation


PROJECT_DIR="/home/minuka819/Projects/its_id_project/ITS_Extractor_V1"
INPUT_FASTA_DIR=PROJECT_DIR+"results/corrected_regions"
ITSX_DIR=PROJECT_DIR+"/results/itsx"
OUT_DIR=PROJECT_DIR+"/results/genbank"

os.makedirs(OUT_DIR, exist_ok=True)

def parse_positions(file_path):
    with open(file_path) as f:
        line = f.readline()

    # Extract regions using regex
    regions = {}
    matches = re.findall(r'(SSU|ITS1|5\.8S|ITS2|LSU):\s*(\d+)-(\d+)', line)

    for name, start, end in matches:
        start = int(start) - 1  # convert to 0-based
        end = int(end)          # end is already correct for Biopython
        regions[name] = (start, end)

    return regions

for fasta_file in os.listdir(INPUT_FASTA_DIR):
    if not fasta_file.endswith(".fasta"):
        continue

    species = fasta_file.replace("_rDNA_rc.fasta", "")
    fasta_path = os.path.join(INPUT_FASTA_DIR, fasta_file)
    pos_path = os.path.join(ITSX_DIR, f"{species}.positions.txt")

    if not os.path.exists(pos_path):
        print(f"Skipping {species}: no ITSx positions file found")
        continue

    print(f"Processing {species}")

    # Load sequence
    record = SeqIO.read(fasta_path, "fasta")

    # Required for GenBank
    record.annotations["molecule_type"] = "DNA"
    record.id = species
    record.name = species
    record.description = f"{species} SSU-ITS1-5.8S-ITS2-LSU region"

    # Parse ITSx positions
    regions = parse_positions(pos_path)

    features = []

    if "SSU" in regions:
        features.append(SeqFeature(
            FeatureLocation(*regions["SSU"]),
            type="rRNA",
            qualifiers={"gene": "18S", "label": "SSU / 18S rRNA"}
        ))

    if "ITS1" in regions:
        features.append(SeqFeature(
            FeatureLocation(*regions["ITS1"]),
            type="misc_feature",
            qualifiers={"label": "ITS1"}
        ))

    if "5.8S" in regions:
        features.append(SeqFeature(
            FeatureLocation(*regions["5.8S"]),
            type="rRNA",
            qualifiers={"gene": "5.8S", "label": "5.8S rRNA"}
        ))

    if "ITS2" in regions:
        features.append(SeqFeature(
            FeatureLocation(*regions["ITS2"]),
            type="misc_feature",
            qualifiers={"label": "ITS2"}
        ))

    if "LSU" in regions:
        features.append(SeqFeature(
            FeatureLocation(*regions["LSU"]),
            type="rRNA",
            qualifiers={"gene": "28S", "label": "LSU / 28S rRNA"}
        ))

    record.features = features

    out_path = os.path.join(OUT_DIR, f"{species}_rDNA_annotated.gbk")
    SeqIO.write(record, out_path, "genbank")

    print(f"Saved: {out_path}")
    print("----------------------------------------")

print("All GenBank files created.")