process CELLBENDER_REMOVEBG {
    tag "$meta.id"
    label 'process_gpu_high'
    publishDir "${params.outdir}/cellbender/${meta.id}", mode: 'copy'

    module 'mamba'
    conda '/research/groups/northcgrp/home/common/Rachel/envs/cellbender'

    input:
    tuple val(meta), path(raw_h5)

    output:
    tuple val(meta), path("cellbender_output.h5"), emit: cb_h5

    script:
    """
    mkdir -p ${meta.id}_cb

    cellbender remove-background \
        --cuda \
        --input ${raw_h5} \
        --output cellbender_output.h5
    """
}