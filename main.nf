params.sample_id = 'HG00096'
params.cram_url  = 'http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000_genomes_project/data/GBR/HG00096/high_cov_alignment/HG00096.alt_bwamem_GRCh38DH.20150917.GBR.high_coverage.cram'
params.region    = 'chr15:72335000-72382000'
params.reference = 'data/reference/chr15.fa'
params.vep_cache = "$projectDir/data/vep_cache"

include { getFastqs } from './modules/getFastqs.nf'
include { runFastqc } from './modules/runFastqc.nf'
include { fastpTrim } from './modules/fastpTrim.nf'
include { runFastqcTrimmed } from './modules/runFastqcTrimmed.nf'
include { bwaAlign } from './modules/bwaAlign.nf'
include { sortAndIndex } from './modules/sortAndIndex.nf'
include { markDuplicates } from './modules/markDuplicates.nf'
include { indexMarkDup } from './modules/indexMarkDup.nf'
include { callVariants } from './modules/callVariants.nf'
include { vepAnnotate } from './modules/vepAnnotate.nf'

workflow {
    // channels
    ref_ch = channel.fromPath("${params.reference}*").collect()

    // processes
    getFastqs(params.sample_id, params.cram_url, params.region)
    runFastqc(getFastqs.out.r1, getFastqs.out.r2)
    fastpTrim(params.sample_id, getFastqs.out.r1, getFastqs.out.r2)
    runFastqcTrimmed(fastpTrim.out.r1_trimmed, fastpTrim.out.r2_trimmed)
    bwaAlign(params.sample_id, fastpTrim.out.r1_trimmed, fastpTrim.out.r2_trimmed, ref_ch)
    sortAndIndex(params.sample_id, bwaAlign.out.sam)
    markDuplicates(params.sample_id, sortAndIndex.out.bam)
    indexMarkDup(markDuplicates.out.bam)
    callVariants(params.sample_id, ref_ch, indexMarkDup.out.bam)
    vepAnnotate(params.sample_id, ref_ch, callVariants.out.vcf)

}
