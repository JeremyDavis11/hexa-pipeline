#!/usr/bin/env bash
set -euo pipefail

# Download GrCh38 VCF file and it's index

mkdir -p data/clinvar

# Download GrCh38 VCF - pinning the version of the VCF from 09/23/2026. ClinVar updates the VCF regularly so this points to a specific version.
curl -L -C - -o data/clinvar/clinvar_20260923.vcf.gz https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/clinvar_20260923.vcf.gz 

# And Download the VCF's index file to the same location
curl -L -C - -o data/clinvar/clinvar_20260923.vcf.gz.tbi https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/clinvar_20260923.vcf.gz.tbi 
