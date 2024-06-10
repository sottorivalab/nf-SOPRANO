include { SOPRANO_ANNOTATE } from "./modules/local/soprano_annotate.nf"

def create_sample_channel(LinkedHashMap row) {
    def meta = [
        id: row.id
    ]
    return [meta, file(row.vcf)]
}

workflow {
    /////////////////////////////////////////////////
    // PIPELINE INFO
    /////////////////////////////////////////////////
    log.info """\
        ===================================
        SOPRANO PIPELINE
        ===================================
        stubRun         : ${workflow.stubRun}
        genome assembly : ${params.genome_assembly}
        soprano_src_dir : ${params.soprano_src_dir}
        translator_dir  : ${params.translator_dir}
        soprano_R_dir   : ${params.soprano_R_dir}
        ===================================
        """
        .stripIndent()
    
    // input is a samplesheet.csv (see example)with
    // Sample amd vcf file for now
    sample_ch = Channel.fromPath(params.input)
        .splitCsv(header:true, sep:',')
        .map{ create_sample_channel(it) }
        .dump(tag: 'samples')
    
    SOPRANO_ANNOTATE(sample_ch)
}