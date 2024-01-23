#!/bin/bash
#SBATCH -J snparcher
#SBATCH -o out
#SBATCH -e err
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=4G         # memory per cpu-core (4G is default)
#SBATCH --time 6-00:00:00        # DAYS-HOURS:MINUTES:SECONDS

# let compute node know where conda is installed
source ~/miniforge3/etc/profile.d/conda.sh
conda activate bioinformatics

# the base directory where we installed all code and data for this workshop
# I had some troble previously with relative paths, so I'm using absolute paths here, 
# storing the base directory in a variable to make things shorter downstream
BASE_DIR=/scratch/gpfs/bjarnold/intro_compbio_workflows_2024

snakemake \
--directory ${BASE_DIR}/part3_snparcher \
--snakefile ${BASE_DIR}/part3_snparcher/snpArcher/workflow/Snakefile \
--configfile ${BASE_DIR}/part3_snparcher/config/config.yaml \
--use-conda \
--profile ${BASE_DIR}/snakemake_profiles/slurm