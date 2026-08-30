process markDuplicates {
    container 'quay.io/biocontainers/picard:3.1.1--hdfd78af_0'
    containerOptions '-e HOME=/tmp'
    publishDir 'results/markDuplicates', mode: 'copy'

    input:
    val sample_id
    tuple path(bam), path(bai)

    output:
    path "*.chr15.markdup.bam", emit: bam
    path "*.chr15.markdup.metrics.txt", emit: metrics

    script:
    """
    picard MarkDuplicates I=${bam} O=${sample_id}.chr15.markdup.bam M=${sample_id}.chr15.markdup.metrics.txt
    """ 
}