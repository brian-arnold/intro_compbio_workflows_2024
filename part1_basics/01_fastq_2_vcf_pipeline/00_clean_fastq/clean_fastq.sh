#!/bin/bash
#SBATCH -J clean_reads
#SBATCH -o out
#SBATCH -e err
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=6        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=4G         # memory per cpu-core (4G is default)
#SBATCH --time 1-00:00:00        # DAYS-HOURS:MINUTES:SECONDS

# let the compute node know where conda is installed
source ~/bjarnold/miniforge3/etc/profile.d/conda.sh
# activate the environment where you've installed the programs you need
conda activate bioinformatics

# Let's first store important information in variables, to make it easier to change later and to make the code more readable/organized

# directory containing the fastq files
FASTQ_DIR=../../../data/fastq

# store the name of read1 and read2 in variables, to make it easier to change them later and make the code more readable/organized
R1=${FASTQ_DIR}/2982B_1.fastq.gz
R2=${FASTQ_DIR}/2982B_2.fastq.gz

# these will be the names of the output files, the cleaned/trimmed reads
OUT_R1=./2982B_trim_1.fastq.gz
OUT_R2=./2982B_trim_2.fastq.gz

# finally, run fastp program!
# here I add the --detect_adapter_for_pe flag to have the program automatically detect Illumina adapter sequences and remove them
# adapter sequences do not reflect the DNA sequence of the organism, but are added during the sequencing process
# we will use 6 threads with --threads to speed things up. Note that this matches how many CPUs we request from the scheduler above
# Often we need to tell programs how many threads they have available to use, they won't automatically recognize this
fastp --in1 ${R1} --in2 ${R2} \
--out1 ${OUT_R1} --out2 ${OUT_R2} \
--thread 6 \
--detect_adapter_for_pe 

