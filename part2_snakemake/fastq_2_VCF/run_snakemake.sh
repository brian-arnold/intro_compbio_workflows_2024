#!/bin/bash
#SBATCH -J snakemake
#SBATCH -o out
#SBATCH -e err
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=20        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=5G         # memory per cpu-core (4G is default)
#SBATCH --time 1-00:00:00        # DAYS-HOURS:MINUTES:SECONDS

source /Genomics/argo/users/bjarnold/miniforge3/etc/profile.d/conda.sh

conda activate bioinformatics

# before submitting the job, I typically do the following on the command line:
# snakemake -n
# where -n specifies a 'dry run' that shows you all the commands that will be run. If there are any errors in the code, 
# this won't work and will print an error message specifying where in the code the error is.

# after you do this, the following command will run snakemake on the cluster:
snakemake --cores 20