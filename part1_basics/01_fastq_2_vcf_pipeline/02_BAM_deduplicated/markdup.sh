#!/bin/bash
#SBATCH -J align_reads
#SBATCH -o out
#SBATCH -e err
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=5        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=4G         # memory per cpu-core (4G is default)
#SBATCH --time 0-06:00:00        # DAYS-HOURS:MINUTES:SECONDS

# let the compute node know where conda is installed
source /Genomics/argo/users/bjarnold/miniforge3/etc/profile.d/conda.sh
# activate the environment where you've installed the programs you need
conda activate bioinformatics

# location of BAM file
BAM_DIR='../01_BAM'

# sample name
NAME=2982B

# run sambamba! We will use 5 threads with -t to speed things up.
sambamba markdup -t 5 ${BAM_DIR}/${NAME}.bam ${NAME}_dedup.bam 2> log