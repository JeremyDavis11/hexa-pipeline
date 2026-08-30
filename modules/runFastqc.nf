process runFastqc {
    container 'quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0'
    publishDir 'results/fastqc', mode: 'copy'

    input:
    path r1_hexa
    path r2_hexa

    output:
    path "*_fastqc.html", emit: html
    path "*_fastqc.zip", emit: zip

    script:
    """
    fastqc ${r1_hexa} ${r2_hexa} -o .
    """
}