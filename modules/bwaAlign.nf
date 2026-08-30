process bwaAlign {
    container 'quay.io/biocontainers/bwa:0.7.17--hed695b0_7'
    publishDir 'results/bwa-mem', mode: 'copy'

    input:
    val sample_id
    path reads_r1
    path reads_r2
    path reference

    output:
    path "*.chr15.sam", emit: sam

    script:
    """
    bwa mem -R "@RG\\tID:${sample_id}.L1\\tSM:${sample_id}\\tPL:ILLUMINA\\tLB:${sample_id}.lib1" chr15.fa ${reads_r1} ${reads_r2} > ${sample_id}.chr15.sam
    """
}