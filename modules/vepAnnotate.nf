process vepAnnotate {
    container 'ensemblorg/ensembl-vep:release_115.0'
    containerOptions "-v ${params.vep_cache}:/vep_cache"
    publishDir 'results/vep', mode: 'copy'

    input:
    val sample_id
    path reference
    path vcf

    output:
    path "*.vep.vcf", emit: vcf
    path "*.vep.vcf_summary.html", emit: vcf_summary

    script:
    """
    vep -i ${vcf} -o ${sample_id}.chr15.vep.vcf --cache --offline --dir_cache /vep_cache --fasta chr15.fa --vcf --everything --flag_pick --force_overwrite
    """
}