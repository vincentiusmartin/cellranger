process DROPLET_QC {
    tag "$meta.id"
    label 'process_med'
    publishDir "${params.outdir}/dropletqc/${meta.id}", mode: 'copy'

    module 'mamba'
    conda '/research/groups/northcgrp/home/common/Rachel/envs/R_nf_4.3.1'

    input:
    tuple val(meta), path(cranger_out)

    output:
    tuple val(meta), path("nf_ed_qc.csv"), emit: dropletqc_stats
    tuple val(meta), path("*.pdf"), emit: dropletqc_viz

    script:
    """
    dropletqc.R ${cranger_out} ${task.cpus}
    """
}