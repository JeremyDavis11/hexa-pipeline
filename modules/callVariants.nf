process callVariants {
    container 'quay.io/biocontainers/bcftools:1.17--haef29d1_0'
    publishDir 'results/variants', mode: 'copy'

    input:
    val sample_id
    path reference
    tuple path(bam), path(bai)

    output:
    path "*.chr15.vcf.gz", emit: vcf

    script:
    """
    bcftools mpileup -f chr15.fa ${bam} | bcftools call -mv -Oz -o ${sample_id}.chr15.vcf.gz
    """
}