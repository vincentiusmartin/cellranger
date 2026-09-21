library(tidyverse)
library(data.table)

datadir <- "/research_jude/rgs01_jude/groups/northcgrp/projects/northcgrp_hartwell/common/illumina/northcgrp_874000_10XsNucRNAseq-1"
allfiles <- list.files(datadir, pattern = "\\.gz$", recursive=TRUE, full.names=TRUE)

df <- data.frame(fastq_file = allfiles) %>%
  mutate(
    sample = sub("_S\\d+.*", "", basename(fastq_file)),
    type = case_when(
      grepl("_R1_", fastq_file) ~ "fastq1", 
      grepl("_R2_", fastq_file) ~ "fastq2", 
      grepl("_I1_", fastq_file) ~ "index1", 
      grepl("_I2_", fastq_file) ~ "index2", 
      TRUE ~ "other"
    )
  ) %>%
  pivot_wider(names_from = type, values_from = fastq_file,values_fn = list) %>%
  unnest(cols = -sample) %>%
  dplyr::select(sample, starts_with("fastq"), starts_with("index"), everything())
fwrite(df,"/home/vmartin/projects/pipeline/sc_workflow/cellranger/samplesheet.csv")

