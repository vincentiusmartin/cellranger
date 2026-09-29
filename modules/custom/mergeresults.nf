process MERGE_RESULTS {
    tag "merged_samples"
    label 'process_high'
    publishDir "${params.outdir}/merged/${sample}", mode: 'copy'

    module 'mamba'
    conda '/research/groups/northcgrp/home/common/Vincentius/envs/scmerge'

    input:
    tuple val(sample), path(cb_h5), path(velo_loom), path(qc_csv)

    output:
    path "merged_adata.h5ad", emit: merged_adata

    script:
    """
    mergeresults.py ${sample} ${cb_h5} ${velo_loom} ${qc_csv}
    """
}