
library(DropletQC)
library(Matrix)
library(hdf5r)
library(ggplot2)
library(dplyr)

scdir <- "/research/groups/northcgrp/home/common/Vincentius/scbarcode/counts/scrna/3448774_SJNBT3_PT_CB_8470_10xGEMXsnRNA"

# Nuclear fraction
nf1 <- nuclear_fraction_tags( outs = file.path(scdir,"outs"), tiles = 1,  cores = 4, verbose = TRUE)
nf1$cellnames <- rownames(nf1)
message(paste0("Calculated nuclear fraction for ", nrow(nf1), " cells."))

# Read sparse matrix directly from filtered_feature_bc_matrix.h5
h5 <- H5File$new(file.path(scdir,"outs/filtered_feature_bc_matrix.h5"), mode = "r")

# Load data
data <- h5[["matrix"]]
counts <- new("dgCMatrix",
              Dim = as.integer(data[["shape"]][]),
              Dimnames = list(data[["features"]][["name"]][], data[["barcodes"]][]),
              p = as.integer(data[["indptr"]][]),
              i = as.integer(data[["indices"]][]),
              x = as.numeric(data[["data"]][]))
h5$close_all()

# Compute UMI counts per cell
umi_counts <- Matrix::colSums(counts)
nf_umi <- data.frame(
  cellnames = colnames(counts),
  nf = nf1$nuclear_fraction[match(colnames(counts), nf1$cellnames)],
  umi = umi_counts
)

nf_umi <- nf_umi[!is.na(nf_umi$nf), ]
ed <- identify_empty_drops(
  nf_umi = nf_umi[, c("nf", "umi")], 
  include_plot = TRUE, pdf_png = "png", 
  plot_path =file.path(scdir,"dropletqc"),
  plot_name = "empty_droplets_qc.png", 
  nf_rescue = 0.05,  umi_rescue = 1000
)
rownames(ed) <- nf_umi$cellnames

message("# # # Empty droplet output:")
print(head(ed))
print(table(ed$cell_status))
message(paste0("Identified empty cells for ", nrow(ed), " cells."))

write.csv(ed, file.path(scdir,"dropletqc/nf_ed_qc.csv"), row.names = TRUE)
message("Output written to nf_ed_qc.csv")
