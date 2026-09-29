#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { CAT_FASTQ } from './modules/cat/fastq'
include { FASTQC } from './modules/fastqc/fastqc'
include { MULTIQC } from './modules/fastqc/multiqc'
include { CELLRANGER_RNA_COUNT } from './modules/cellranger/rnacount'
include { CELLRANGER_ATAC_COUNT } from './modules/cellranger/ataccount'
include { CELLBENDER_REMOVEBG } from './modules/cellbender/removebg'
include { VELOCYTO_RUN10X } from './modules/velocyto/run10x'
include { DROPLET_QC } from './modules/dropletqc/dropletqc'
include { MERGE_RESULTS } from './modules/custom/mergeresults'

workflow {
  Channel
    .fromPath(params.input)
    .splitCsv(header: true)
    .map {
      row ->
        def fastq = row.findAll { it.key != 'sample' }
        return [[id:row.sample], [fastq.values()]]
    }
    .groupTuple(by: [0])
    .map {meta, fastq -> [meta, fastq.flatten()] }
    .set { ch_fastq }
    

    if(params.modality == "atac") {
      CELLRANGER_ATAC_COUNT(ch_fastq)
    } else {
      CELLRANGER_RNA_COUNT(ch_fastq)
      CELLBENDER_REMOVEBG(CELLRANGER_RNA_COUNT.out.raw_h5)
      VELOCYTO_RUN10X(CELLRANGER_RNA_COUNT.out.cellranger_dir)
      DROPLET_QC(CELLRANGER_RNA_COUNT.out.cellranger_dir)
      
      CELLBENDER_REMOVEBG.out.cb_h5
        .combine(VELOCYTO_RUN10X.out.velo_loom)
        .combine(DROPLET_QC.out.dropletqc_stats)
        .map { x -> tuple(x[0].id, x[1], x[3], x[5]) }
        .set { ch_tomerge }
      
      MERGE_RESULTS(ch_tomerge)
    }

}
