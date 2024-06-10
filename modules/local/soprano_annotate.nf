process SOPRANO_ANNOTATE {
    input:
    tuple val(meta), path(vcf)

    output:
    tuple val(meta), path("${vcf.baseName}.vcf.anno"), emit: annotated

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${vcf.baseName}"
    """
    Rscript ${params.soprano_R_dir}/parse_vcf.R \\
        -v ${vcf} \\
        -t ${params.translator_dir} \\
        -a ${params.genome_assembly} \\
        -w ${params.soprano_R_dir} \\
        -o ${prefix}.vcf.anno \\
        $args
    """

    stub:
    def prefix = task.ext.prefix ?: "${vcf.baseName}"
    """
    touch ${prefix}.vcf.anno
    """
}