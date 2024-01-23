#!/bin/bash
#SBATCH -J align_reads
#SBATCH -o out
#SBATCH -e err
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=10        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=4G         # memory per cpu-core (4G is default)
#SBATCH --time 0-01:00:00        # DAYS-HOURS:MINUTES:SECONDS

# let the compute node know where conda is installed
source ~/bjarnold/miniforge3/etc/profile.d/conda.sh
# activate the environment where you've installed the programs you need
conda activate bioinformatics

# location of reference genome
REF='../../../data/genome/Loxodonta_africana.loxAfr3.dna.toplevel.fa'

# location of fastq files
FASTQ_DIR=../00_clean_fastq
R1=${FASTQ_DIR}/2982B_trim_1.fastq.gz
R2=${FASTQ_DIR}/2982B_trim_2.fastq.gz


# used for output file name and read group info, required for many downstream algorithms that call variants
# NAME=2981B
NAME=2982B

# Several steps are combined into one line to avoid writing intermediate files to disk
# 1.) aligning reads to reference genome using BWA
#       a.) -M flag isn't necessary but makes the output compatible with other useful programs; if a read is split across multiple alignments, it will be marked as such
#       b.) -t flag specifies number of threads to use
#       c.) -R flag specifies read group info, which is required for many downstream algorithms that call variants
# 2.) sorting the resulting BAM file so that the aligned reads are in order along the genome
# 3.) indexing the BAM file so that it can be efficiently accessed by downstream programs
bwa mem -M -t 10 -R '@RG\tID:${NAME}\tSM:${NAME}' ${REF} ${R1} ${R2} 2> log | samtools sort -o ${NAME}.bam - && samtools index ${NAME}.bam ${NAME}.bai