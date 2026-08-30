process runFastqcTrimmed {
    container 'quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0'
    publishDir 'results/fastqc_trimmed', mode: 'copy'

    input:
    path r1_hexa_trimmed
    path r2_hexa_trimmed

    output:
    path "*_fastqc.html", emit: html
    path "*_fastqc.zip", emit: zip

    script:
    """
    fastqc ${r1_hexa_trimmed} ${r2_hexa_trimmed} -o .
    """
}