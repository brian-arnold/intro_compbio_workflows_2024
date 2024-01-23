# let compute node know where conda/mamba is installed, following miniforge instructions
source ~/miniforge3/etc/profile.d/conda.sh
# activate conda environment
conda activate bioinformatics

# run the following command to install all conda environments on the login node, which has internet access
snakemake --directory ../ \
--snakefile ../snpArcher/workflow/Snakefile \
--cores 1 \
--use-conda \
--conda-frontend mamba \
--conda-create-envs-only
