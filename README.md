

# Cellranger single cell RNA and ATAC Nextflow pipeline

This Nextflow workflow provides an automated pipeline for processing 10X Genomics single-cell RNA and ATAC data. For scRNA, it integrates several tools for complementary processing and quality-control steps:

- <b>Cell Ranger</b> for read alignment and gene-expression quantification
- <b>CellBender</b> for removal of ambient RNA contamination
- <b>Velocyto</b> for quantification of spliced and unspliced transcripts for RNA velocity analysis
- <b>DropletQC</b> for estimating nuclear fraction and identifying empty droplets

<center><img src="images/workflow.png" width=100% /></center>

<details><summary><b>Table of content</b></summary>

- [Directory structure](#directory)
- [Running the pipeline](#running-the-pipeline)
    - [Step-1: Generate the config file](#step1)
    - [Step-2: Running Cell Ranger pipeline](#step2)
    - [Step-3: Interpreting results](#step3)
</details>

## Directory structure <a name="directory"></a>
    .
    ├── modules            # script for nextflow module
    ├── examples           # Currently contain template for downstream analysis
    ├── bin                # contains executable for the nextflow pipeline
    ├── scripts            # utility scripts
    └── README.md

## Running the pipeline

### Step-1: Generate the config file <a name="step1"></a>

The pipeline accepts a samplesheet containing paths to the input files. An example samplesheet is shown below. 
An example script for generating the samplesheet is provided in the `scripts` directory.

| sample | fastq1 | fastq2 | index1 | 
| --- | --- | --- | --- | 
| sample1 | /path/to/sample1_L001_R1.fastq.gz | /path/to/sample1_L001_R2.fastq.gz | /path/to/sample1_L001_I1.fastq.gz | 
| sample1 | /path/to/sample1_L002_R1.fastq.gz | /path/to/sample1_L002_R2.fastq.gz | /path/to/sample1_L002_I1.fastq.gz | 
| sample2 | /path/to/sample2_L001_R1.fastq.gz | /path/to/sample2_L001_R2.fastq.gz | /path/to/sample2_L001_I1.fastq.gz | 
| sample2 | /path/to/sample2_L002_R1.fastq.gz | /path/to/sample2_L002_R2.fastq.gz | /path/to/sample2_L002_I1.fastq.gz | 

### Step-2: Running Cell Ranger pipeline <a name="step2"></a>

1. Edit `nextflow.config` file. Parameter definition for now is defined in the config file
to simplify running the pipeline.
2. Run the nextflow pipeline: `nextflow run main.nf`

### Step-3: Interpreting results <a name="step3"></a>

An example of script to perform downstream analysis is in the `downstream` folder.
Example of filtering based on the pipeline output from `cellbender` and `DropletQC`,
along with filtering using other metrics is provided.



