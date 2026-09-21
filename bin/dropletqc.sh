#BSUB -J "dropletqc"
#BSUB -R "rusage[mem=16G]"
#BSUB -R "span[hosts=1]"
#BSUB -n 4
#BSUB -q priority

module load mamba
source activate /research/groups/northcgrp/home/common/Rachel/envs/R_nf_4.3.1

Rscript dropletqc.R


