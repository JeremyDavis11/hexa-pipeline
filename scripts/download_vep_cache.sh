#!/usr/bin/env bash
set -euo pipefail

# NOTE: This cache is Ensembl release 115 and must match the VEP container
# Version in the pipeline (ensemblorg/ensembl-vep:release_115.0).
# If you update one, remember to update the other in the VEP annotation script or VEP will error on a version mismatch

mkdir -p data/vep_cache

# download VEP cache (~15GB compressed) -C resumes if interrupted, -L follows redirects
curl -L -C - -o data/vep_cache/homo_sapiens_vep_115_GRCh38.tar.gz https://ftp.ensembl.org/pub/release-115/variation/indexed_vep_cache/homo_sapiens_vep_115_GRCh38.tar.gz

# unpack VEP cache tarball (~20GB extracted) to produce data/vep_cahce/homo_sapiens/115_GRCh38/
tar -xzf data/vep_cache/homo_sapiens_vep_115_GRCh38.tar.gz -C data/vep_cache/

# Remove the tarball now that extraction succeeded (set -e ensures we only reach here upon successful extraction)
rm data/vep_cache/homo_sapiens_vep_115_GRCh38.tar.gz