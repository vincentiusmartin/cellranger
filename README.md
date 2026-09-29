

# Cellranger single cell RNA and ATAC Nextflow pipeline

This Nextflow workflow provides an automated pipeline for processing 10X Genomics single-cell RNA and ATAC data. For scRNA, it integrates several tools for complementary processing and quality-control steps:

- <b>Cell Ranger</b> for read alignment and gene-expression quantification
- <b>CellBender</b> for removal of ambient RNA contamination
- <b>Velocyto</b> for quantification of spliced and unspliced transcripts for RNA velocity analysis
- <b>DropletQC</b> for estimating nuclear fraction and identifying empty droplets

<center><img src="images/workflow.png" width=100% /></center>

<details><summary><b>Table of content</b></summary>

- [Prerequisite](#prerequisite)
- [Running the pipeline](#running-the-pipeline)
    - [Step-1: Generate the config file](#step1)
    - [Step-2: Running cellranger pipeline](#step2)
    - [Step-3: Interpreting results](#step3)
- [Other useful scripts](#utilities)
</details>

## Directory structure
    .
    ├── modules            # script for nextflow module
    ├── examples           # Currently contain template for downstream analysis
    ├── bin                # contains executable for the nextflow pipeline
    ├── scripts            # utility scripts
    └── README.md

## Running the pipeline

### Step-1: Generate the config file <a name="step1"></a>
Directory: `scripts`



