process CELLRANGER_RNA_COUNT {
    tag "$meta.id"
    label 'process_high'
    publishDir "${params.outdir}/scrna", mode: 'copy'
    //disk '100 GB' // or export MRO_DISK_SPACE_CHECK=disabl; to prevent inode issue

    module 'cellranger/8.0.1'

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("**/outs/**")

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    mkdir fastq_all
    mv *.fastq.gz fastq_all
    cellranger count \
      --id ${prefix} \
      --sample ${prefix} \
      --fastqs fastq_all \
      --transcriptome ${params.genome_ref} \
      --localcores ${task.cpus} \
      --localmem ${task.memory.toGiga()} \
      --create-bam true \
      --disable-ui 
    """
}