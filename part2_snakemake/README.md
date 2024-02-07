# Part 2: Intro to Snakemake

## Context

In biology, Snakemake is a very popular "workflow language" that helps automate running command line tools. Automation can be very helpful if you have to process a lot of samples, and/or you want to repeat everything on many other species.

For tasks like detecting mutations from DNA sequencing data, one always has to run a workflow to first process the data. Making this easier and more automated can make you more efficient and leave you more time to spend on interesting analyses!

E.g. I recently worked with Sarah Kocher. We were interested in looking for DNA motifs in enhancer regions in bee genomes. However, we didn't know exactly how to process the data and filter the resutls. By automating everything with Snakemake, I was able to process data for 13 different species in 4 different ways and make plots of the results. This allowed us to use ***data to make decisions*** instead of just going off hunches, which can be sensible and logical but still wrong!

This workshop serves 2 purposes
1. a gentle introduction to Snakemake for the next session of this workshop that explains how to use a published Snakemake workflow to detect mutaitons in WGS data
2. The content here can also be a starting point to make your own analyses in Snakemake!

For more introduction to Snakemake, please see the powerpoint slides `slides/part2_snakemake.pptx`.

## Overview
1. a simple workflow
2. a workflow for *multiple* samples
3. getting snakemake to *parallelize* computation (make it go much faster)
4. an example of a biology workflow

## 1.) Simple workflow

- Move into the simple directory with `cd simple`
- There are 3 RNA sequences we'll use as input data in `rna_sequences.txt`
- There is a `Snakefile` that contains snakemake code to convert these RNA sequences to DNA, and then make the reverse complement sequence
    - This is a meaningless workflow but will help explain how snakemake works in simple terms! We'll discuss meaningful workflows soon!
- Inspect `Snakefile`
- Ensure the code isn't bugged and get an idea of what it will do using `snakemake --dryrun`
    - By default, snakemake will automatically recognize the `Snakefile` as the source code. If you name it something else, you need to use `snakemake --dryrun --snakefile Some_other_name`
- Looks good! Now run the workflow by simple typing `snakemake`.
- We now have out output file `reverse_complement.txt`.
- I also provide a script `run_snakemake_as_job.sh` to submit the workflow as a job, but this example is so simple we can just run it directly on the login node! You may run this using `sbatch run_snakemake_as_job.sh`.


## 2.) Simple workflow with 'wildcards'

- Move into the `simple_wildcards` directory.
- There are again 3 RNA sequences, but they're separated into different files to illustrate how snakemake can automate data processing across a collection of files.
- The `Snakefile` again contains the snakemake code.
- Doing a dry run with `snakemake --dryrun` shows that snakemake is now applying rules more times than the previous, simpler workflow: it's applying the rules to convert RNA to DNA and then take the reverse complement to each file.
- Run the snakemake workflow using `snakemake`. This workflow takes longer because I introduced a `sleep` command to simulate software taking a bit of time to do computation. It should finish in ~30 seconds.

## 3.) Using snakemake for parallel computing

- Remove the output files we just created using `rm sample*` and `rm all_samples_reverse_complement.txt`.
- Snakemake identifies which rules are independent of each other, and if you give it additional cores, it will run these rules in parallel and finish sooner.
- Run snakemake again with `snakemake --cores 3`. It finishes much faster!
- Move into the directory `job_submission_scripts`. You'll find a script `01_run_snakemake_as_single_job.sh` that submits this as a job in which we request 3 cores. Note we use `--snakefile ../Snakefile` to let snakemake know where the Snakefile is because it isn't in the directory in which we run snakemake, and we also use the `--directory` option since the data are stored elsewhere.
- This is nice, but what if we are running snakemake on hundreds or thousands of files? We cannot request hundreds of cores in a single job due to how the computing cluster is designed. Instead, snakemake can ***communicate with the cluster to submit each independent task as a separate job***
- See `02_run_snakemake_as_multi_jobs.sh` for how to do this, and run it using the `sbatch` command. We're using the `--profile` option to give snakemake a bunch of information, all within the `snakemake_profiles/slurm` directory.

## 4.) Exercise: convert a script we used last time into  a 1 step snakemake workflow
- convert script `part1_basics/00_simple_job_submission/clean_fastq.sh` into a snakemake workflow

## 5.) A simple snakemake workflow to detect mutations from WGS data
- For a broad overview of this workflow, see `slides/part2_snakemake.pptx`.
- 95% of this code was written by chatGPT4. I just had to give a program (bwa) an extra argument so that the name of the individual was included in the BAM file header, which is a requirement for some downstream variant callers.