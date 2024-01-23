#!/bin/bash
#SBATCH -J freebayes
#SBATCH -o out
#SBATCH -e err
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=40G         # memory per cpu-core (4G is default)
#SBATCH --time 0-12:00:00        # DAYS-HOURS:MINUTES:SECONDS

# let the compute node know where conda is installed
source ~/miniforge3/etc/profile.d/conda.sh
# activate the environment where you've installed the programs you need
# NOTE, the latest version of freebayes 1.3.7 is broken, I went to the github repo, opened up the issues, and the first comment confirmed it was broken and said to use 1.3.6
conda activate bioinformatics

# location of reference genome
REF='../../../data/genome/Loxodonta_africana.loxAfr3.dna.toplevel.fa'
# location of BAM file
BAM_DIR='../02_BAM_deduplicated'
# sample name
NAME=2982B

BAM=${BAM_DIR}/${NAME}_dedup.bam

# run freebayes! I copied this command directly from their website on github
# you can find many more useful examples of how to run the program here: https://github.com/freebayes/freebayes
freebayes -f ${REF} ${BAM} >results.vcf

