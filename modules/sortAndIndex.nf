process sortAndIndex {
    container 'quay.io/biocontainers/samtools:1.19.2--h50ea8bc_1'
    publishDir 'results/bam', mode: 'copy'

    input:
    val sample_id
    path chr15_sam

    output:
    tuple path("*.chr15.sorted.bam"), path("*.chr15.sorted.bam.bai"), emit: bam

    script:
    """
    samtools sort ${chr15_sam} -o ${sample_id}.chr15.sorted.bam
    samtools index ${sample_id}.chr15.sorted.bam
    """
}