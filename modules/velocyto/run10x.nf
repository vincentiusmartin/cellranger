process VELOCYTO_RUN10X {
    tag "$meta.id"
    label 'process_med'
    publishDir "${params.outdir}/velocyto/${meta.id}", mode: 'copy'

    module 'mamba'
    conda '/research/groups/northcgrp/home/common/Rachel/envs/velocyto'

    input:
    tuple val(meta), path(cranger_out)

    output:
    tuple val(meta), path("${meta.id}.loom"),  emit: velo_loom

    script:
    """
    velocyto run10x ${cranger_out} ${params.gtf_file}
    mv ${cranger_out}/velocyto/*.loom ${meta.id}.loom
    """
}