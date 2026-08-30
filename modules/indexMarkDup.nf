process indexMarkDup {
    container 'quay.io/biocontainers/samtools:1.19.2--h50ea8bc_1'
    publishDir 'results/markDuplicates', mode: 'copy'

    input:
    path dup_bam

    output:
    tuple path("*.markdup.bam", includeInputs: true), path("*.markdup.bam.bai"), emit: bam

    script:
    """
    samtools index ${dup_bam}
    """
}