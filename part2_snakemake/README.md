Content for this part of the workshop can be in the powerpoint slides.

## Simple workflow

- Move into the simple directory with `cd simple`
- There are 3 RNA sequences we'll use as input data in `rna_sequences.txt`
- There is a `Snakefile` that contains snakemake code to convert these RNA sequences to DNA, and then make the reverse complement sequence
    - This is a meaningless workflow but will help explain how snakemake works in simple terms! We'll discuss meaningful workflows soon!
- Inspect `Snakefile`
- Ensure the code isn't bugged and get an idea of what it will do using `snakemake --dryrun`
    - By default, snakemake will automaticallyrecognize the `Snakefile` as the source code. If you name it something else, you need to use `snakemake --dryrun --snakefile Some_other_name`
- Looks good! Now run the workflow by simple typing `snakemake`.
- We now have out output file `reverse_complement.txt`.
- I also provide a script `run_snakemake_as_job.sh` to submit the workflow as a job, but this example is so simple we can just run it directly on the login node! You may run this using `sbatch run_snakemake_as_job.sh`.


## Simple workflow with 'wildcards'

- Move into the `simple_wildcards` directory.
- There are again 3 RNA sequences, but they're separated into different files to illustrate how snakemake can automate data processing across a collection of files.
- The `Snakefile` again contains the snakemake code.
- Doing a dry run with `snakemake --dryrun` shows that snakemake is now applying rules more times than the previous, simpler workflow: it's applying the rules to convert RNA to DNA and then take the reverse complement to each file.
- Run the snakemake workflow using `snakemake`. This workflow takes longer because I introduced a `sleep` command to simulate software taking a bit of time to do computation. It should finish in ~30 seconds.

### Using snakemake for parallel computing

- Remove the output files we just created using `rm sample*` and `rm all_samples_reverse_complement.txt`.
- Snakemake identifies which rules are independent of each other, and if you give it additional cores, it will run these rules in parallel and finish sooner.
- Run snakemake again with `snakemake --cores 3`. It finishes much faster!
- Move into the directory `job_submission_scripts`. You'll find a script `01_run_snakemake_as_single_job.sh` that submits this as a job in which we request 3 cores. Note we use `--snakefile ../Snakefile` to let snakemake know where the Snakefile is because it isn't in the directory in which we run snakemake, and we also use the `--directory` option since the data are stored elsewhere.
- This is nice, but what if we are running snakemake on hundreds or thousands of files? We cannot request hundreds of cores in a single job due to how the computing cluster is designed. Instead, snakemake can ***communicate with the cluster to submit each independent task as a separate job***
- See `02_run_snakemake_as_multi_jobs.sh` for how to do this, and run it using the `sbatch` command. We're using the `--profile` option to give snakemake a bunch of information, all within the `snakemake_profiles/slurm` directory.
