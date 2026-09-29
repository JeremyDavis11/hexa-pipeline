#!/usr/bin/env bash

set -euo pipefail

# Subset ClinVar VCF to HEXA region, then rename chromosome column from 15 to Chr15 to match reference

# Subset ClinVar VCF to HEXA region
docker run --rm --platform linux/amd64 -v $(pwd)/data/clinvar:/data quay.io/biocontainers/bcftools:1.17--haef29d1_0 bcftools view -r 15:72335000-72382000 /data/clinvar_20260923.vcf.gz -Oz -o /data/hexa_clinvar.vcf.gz

# Create mapping file
printf '15\tchr15\n' > data/clinvar/chr_map.txt

# Rename 15 to Chr15
docker run --rm --platform linux/amd64 -v $(pwd)/data/clinvar:/data quay.io/biocontainers/bcftools:1.17--haef29d1_0 bcftools annotate --rename-chrs /data/chr_map.txt /data/hexa_clinvar.vcf.gz -Oz -o /data/hexa_clinvar_chr15.vcf.gz

# Check number of variants
docker run --rm --platform linux/amd64 -v $(pwd)/data/clinvar:/data quay.io/biocontainers/bcftools:1.17--haef29d1_0 bcftools view -H /data/hexa_clinvar_chr15.vcf.gz | wc -l