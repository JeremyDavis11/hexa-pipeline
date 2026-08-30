process fastpTrim {
    container 'quay.io/biocontainers/fastp:0.23.4--h5f740d0_0'
    publishDir 'results/fastp_trimmed', mode: 'copy'

    input:
    val sample_id
    path r1_hexa
    path r2_hexa

    output:
    path "*.HEXA.trimmed.R1.fastq.gz", emit: r1_trimmed
    path "*.HEXA.trimmed.R2.fastq.gz", emit: r2_trimmed
    path "*.HEXA.fastp.html", emit: html
    path "*.HEXA.fastp.json", emit: json

    script:
    """
    fastp -i ${r1_hexa} -I ${r2_hexa} -o ${sample_id}.HEXA.trimmed.R1.fastq.gz -O ${sample_id}.HEXA.trimmed.R2.fastq.gz --cut_tail --html ${sample_id}.HEXA.fastp.html --json ${sample_id}.HEXA.fastp.json
    """
}