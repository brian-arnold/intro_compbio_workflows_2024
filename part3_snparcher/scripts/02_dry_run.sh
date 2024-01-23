# let compute node know where conda is installed
source ~/miniforge3/etc/profile.d/conda.sh
conda activate bioinformatics

# dry run
snakemake --directory ../ \
--snakefile ../snpArcher/workflow/Snakefile \
--configfile ../config/config.yaml \
--use-conda \
--dry-run > dry_run.out
