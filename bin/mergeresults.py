#!/usr/bin/env python3


import sys
import anndata as ad
import pandas as pd
import scanpy as sc
import scvelo as scv
from cellbender.remove_background.downstream import anndata_from_h5

samplename = sys.argv[1]
cb_h5 = sys.argv[2]
velo_loom = sys.argv[3]
qc_csv = sys.argv[4]

if __name__ == "__main__":
    batchdict = {}
    # read all metadata and merge
    cellbender_filtered = anndata_from_h5(cb_h5)
    dropletqcdf = pd.read_csv(qc_csv, index_col=0)
    vadata = sc.read(velo_loom)
    cellbender_filtered.obs = cellbender_filtered.obs.merge(dropletqcdf, left_index=True, right_index=True, how="left")
    cellbender_filtered = cellbender_filtered[~pd.isna(cellbender_filtered.obs['nf'])].copy()
    cellbender_filtered = scv.utils.merge(cellbender_filtered, vadata)
    # add sample information to cell names
    cellbender_filtered.obs.index = cellbender_filtered.obs.index + "_" + samplename
    cellbender_filtered.var_names_make_unique()
    batchdict[samplename] = cellbender_filtered
    merged_adata = ad.concat(batchdict, join='outer', label="batch_names")
    merged_adata.obs_names_make_unique()
    merged_adata.var_names_make_unique()
    merged_adata.write(f"merged_adata.h5ad")
