#!/usr/bin/env bash
set -euo pipefail

mkdir -p data/reference

# Download GRCh38 reference (~3GB) and its index from 1000 genomes
curl -o data/reference/GRCh38_full_analysis_set_plus_decoy_hla.fa "https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa"
curl -o data/reference/GRCh38_full_analysis_set_plus_decoy_hla.fa.fai "https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa.fai"

# Extract fell chr15 (not HEXA sub-region)
# aligning against a renamed subslice produces local coordinates which this avoids
# variant coordinates at true genomic positions (~72.3M bp) which VEP annotation needs
docker run --rm --platform linux/amd64 -u $(id -u):$(id -g) -v "$PWD":/work -w /work quay.io/biocontainers/samtools:1.19.2--h50ea8bc_1 samtools faidx data/reference/GRCh38_full_analysis_set_plus_decoy_hla.fa chr15 -o data/reference/chr15.fa

# Index chr15 for random access (samtools .fai)
docker run --rm --platform linux/amd64 -u $(id -u):$(id -g) -v "$PWD":/work -w /work quay.io/biocontainers/samtools:1.19.2--h50ea8bc_1 samtools faidx data/reference/chr15.fa

# Build the BWA index of chr15 for the alignment step
docker run --rm --platform linux/amd64 -u $(id -u):$(id -g) -v "$PWD":/work -w /work quay.io/biocontainers/bwa:0.7.17--hed695b0_7 bwa index data/reference/chr15.fa

