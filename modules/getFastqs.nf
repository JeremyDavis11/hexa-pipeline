/*
* download fastq files
*/

process getFastqs {
    container 'quay.io/biocontainers/samtools:1.19.2--h50ea8bc_1'
    publishDir 'results/fastq/gzipped', mode: 'copy'

    input:
    val sample_id
    val cram_url
    val region

    output:
    path "*.R1.fastq.gz", emit: r1
    path "*.R2.fastq.gz", emit: r2

    script:
    """
    samtools view -u ${cram_url} ${region} | samtools collate -u -O - | samtools fastq -1 ${sample_id}.HEXA.R1.fastq.gz -2 ${sample_id}.HEXA.R2.fastq.gz -0 /dev/null -s /dev/null -n
    """
}