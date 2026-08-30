#!/usr/bin/env bash
set -euo pipefail

# summarize_results.sh <annotated_vcf>
# Post-hoc analysis of an annotated VCF — NOT part of the pipeline.
# Generates the summary statistics reported in the README results section.
#
# Usage: bash summarize_results.sh results/vep/HG00096.chr15.vep.vcf

VCF="${1:?Usage: bash summarize_results.sh <annotated_vcf>}"

BCFTOOLS="quay.io/biocontainers/bcftools:1.17--haef29d1_0"
VEP="ensemblorg/ensembl-vep:release_115.0"
DOCKER="docker run --rm --platform linux/amd64 -v $PWD:/work -w /work"

echo "=== Total variants called ==="
$DOCKER $BCFTOOLS bcftools view -H "$VCF" | wc -l

echo "=== Variants overlapping HEXA ==="
$DOCKER $VEP filter_vep -i "$VCF" --filter "SYMBOL match HEXA" 2>/dev/null | grep -vc "^#"

echo "=== High-impact variants (nonsense/frameshift/splice) ==="
$DOCKER $VEP filter_vep -i "$VCF" --filter "IMPACT is HIGH" 2>/dev/null | grep -vc "^#"

echo "=== Known/novel split & consequence breakdown ==="
echo "See the VEP-generated *_summary.html alongside the input VCF"