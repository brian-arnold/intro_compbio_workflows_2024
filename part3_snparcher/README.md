# Introduction to snpArcher

## Preamble

1. The [snpArcher](https://snparcher.readthedocs.io/en/latest/index.html) repository has a ton of information. You should definitely look at it if you want to run this workflow, especially the [setup page](https://snparcher.readthedocs.io/en/latest/setup.html). Below I've made some suplementary instructions, along with some specific ones to get everything working on the Della cluster.


2. I do not recommend running this on your end as it requires considerable computational resources. Perhaps try with a *few* of your own samples you intend to use for research to avoid needlessly using computational resources. If this works, you can 
    1. remove or rename the final output file `*_raw.vcf.gz` in the `results` directory to make snpArcher see that the workflow is now incomplete
    2. run snpArcher on the rest of your samples


## My instructions (to supplement original snpArcher repo)

Move into the `intro_compbio_workflows_2024/part3_snparcher` directory and download the snpArcher code using:

`git clone https://github.com/harvardinformatics/snpArcher.git`

While the environment we used in `part1_basics` might work, the SnpArcher [instructions](https://snparcher.readthedocs.io/en/latest/setup.html#:~:text=mamba%20create%20%2Dc%20conda%2Dforge%20%2Dc%20bioconda%20%2Dn%20snparcher%20%22snakemake%3D%3D7.32.4%22%20%22python%3D%3D3.11.4%22) recommend making a new conda environment using:

`mamba create -c conda-forge -c bioconda -n snparcher "snakemake==7.32.4" "python==3.11.4"`

In addition to this, I do the following to help circumvent an error:

`mamba install -n snparcher -c conda-forge mamba`



### Configuration files

Before we move into the `snpArcher` directory we just cloned, I have a separate directory called `config`, copied from the snpArcher repository, in which I already changed files to run the workflow on our samples. 

- The **most important file** is `config/samples.csv` where we need to specify the correct absolute path to the reference genome and fastq files. 
    - There exists a [script](https://snparcher.readthedocs.io/en/latest/setup.html#:~:text=A%20python%20script%20workflow/write_samples.py%20is%20included%20to%20help%20write%20the%20sample%20sheet%20for%20you.) to help make this sample sheet, but I haven't used it.

- The `config/config.yaml` file has many variables which can be kept unchanged, except `final_prefix` could be useful to change across projects.

- The `config/resources.yaml` is where we give specific rules specific amounts of **threads** (or cores; more threads make some progams run faster) and **memory** (specified with **"mem"**).
    - The rule `bam2gvcf` gets inovked *many* times, since a genome is split into many subsegments, where `bam2gvcf` gets run for each subsegment. I used 9000 and the cluster yelled at me for over-requesting resources, so I decreased it to 3000.

- Annoyingly, the only way I have found to change the **time** requested for each job is in the following file in the slurm profile directory given to snakemake: `intro_compbio_workflows_2024/snakemake_profiles/slurm/cluster_config.yml`. 
    - resources specified in `__default__` get applied to all rules by default
    - resources are overwritten if they are explicitly specified (e.g. the `bam2gvcf` rule has a time limit of 1439 minutes, longer than the default 1000)


### Setting up snpArcher on Della

Move into `part3_snparcher/scripts`

Snakemake can create it's own mamba environments, and snpArcher automatically installs all the relevant software specified in `part3_snparcher/snpArcher/workflow/envs`. However, Della has a quirk in that compute nodes *do not* have access to internet, which is needed to download software. Thus, conda environments need to be created on login nodes, which *do* have internet, before we run anything.

1. In case it takes a while and you need to close your computer, let's make a 'screen' using `screen -S smk` that creates a seperate terminal instance

2. Now that we are in this separate screen, install conda environments using `bash 01_install_conda_envs.sh`.

3. Press `ctrl+A` then `D` to 'detatch' from the session, which should run in the background even if you close your terminal window.

4. To go back into the screen to check proress, type `screen -r smk`, where `-r` is to 'resume.

5. When it's finally done, kill the screen by pressing `ctrl+A` then `K`, and respond yes.

If you type `mamba env list`, you should see a bunch of new environments were created in a hidden directory `.snakemake` that you can only see using `ls -a`. These environments don't have names like the ones we created by hand.

NOTE: You could also do this directly on the command line on the login node, but using screen allows you to close your computer and it continues the process.

### Dry run to test snpArcher

Next, let's do a dry run to see if we have everything configured correctly.

`bash 02_dry_run.sh`

If the dry run completes successfully and shows some rules that need to be run, then everything is good to go. However, the number of rules is shows that need to be run isn't the entire story, since some rules are executed only under some conditions that are determined at runtime. In practice, snparcher will likely run thousands of rules and submit thousands of jobs.

### Small run to test snpArcher

SnpArhcer provides a very small test dataset to ensure everything is working properly. See [here](https://snparcher.readthedocs.io/en/latest/executing.html#:~:text=and%20requisite%20files.-,Test%20datasets,-%EF%83%81).

The command to run the test is:

`snakemake -d .test/ecoli --cores 1 --use-conda`

where the hidden .test directory is in the parent directory of the snpArcher github repository.

### Running snpArcher

Lastly, we can submit the last script `03_submit_smk_job.sh` as a job using the `sbatch` command, specifying the longest time interval possible to ensure it doesn't time out. This job that gets submitted will essentially submit many additional jobs, one for each rule that needs to get run. Alternatively, we can create a screen like we did above and run the script using `bash 03_submit_smk_job.sh`.

#### Results

Results should be in `part3_snparcher/results` and are organized into seperate directories according to the reference genomes used, since snpArcher can work with multiple species and different reference genomes at the same time.

- a VCF file named `*_raw.vcf.gz` is the most important 
- the `QC` directory has the output of many useful analyses!
    - `part3_snparcher/snpArcher/workflow/modules/qc/scripts/qc_dashboard_interactive.html`
        - this has many numerous plots!
    - `QC/*.idepth` has information of sequencing depth per sample
    - `QC/*.imiss` has information on missing data, with `*.idepth` can be used to potentially discard samples with low depth and high missing data
    - `QC/*.eigenvec` and `QC/*.eigenval` to plot PCA
    - `QC/*_bam_sumstats.txt` to see mapping percentages


### Debugging

In the script `03_submit_smk_job.sh`, we specified in the SLURM directives `#SBATCH -e err`, so all of the standard error output will be in the file `err`. For instance, here's an example of the rule `fastp` snpArcher submitted to SLURM as a job:



```
[Sun Jan 14 16:11:41 2024]
rule fastp:
    input: /scratch/gpfs/bjarnold/intro_compbio_workflows_2024/data/fastq/2982B_1.fastq.gz, /scratch/gpfs/bjarnold/intro_compbio_workflows_2024/data/fastq/2982B_2.fastq.gz
    output: results/loxAfr3/filtered_fastqs/2982B/2_1.fastq.gz, results/loxAfr3/filtered_fastqs/2982B/2_2.fastq.gz, results/loxAfr3/summary_stats/2982B/2.fastp.out
    log: logs/loxAfr3/fastp/2982B/2.txt
    jobid: 15
    benchmark: benchmarks/loxAfr3/fastp/2982B_2.txt
    reason: Missing output files: results/loxAfr3/summary_stats/2982B/2.fastp.out, results/loxAfr3/filtered_fastqs/2982B/2_1.fastq.gz, results/loxAfr3/filtered_fastqs/2982B/2_2.fastq.gz
    wildcards: refGenome=loxAfr3, sample=2982B, run=2
    threads: 8
    resources: mem_mb=8000, mem_mib=7630, disk_mb=2087, disk_mib=1991, tmpdir=<TBD>

Submitted job 15 with external jobid '53466180'.

```

If snpArcher fails, you'll see "Error" somewhere underneath this rule. However, snakemake won't explain why the rule failed; it just runs the rules you told it to and reports if it worked or not.

To see ***why*** the rule failed, you have to go to the standard error file produced by the SLURM job that actually ran the rule. In the example above, this SLURM job has the jobid '53466180', shown on the last line.

If you look in `part3_snparcher/logs/slurm`, you'll see a bunch of files named `slurm-<jobid>.out`, where `<jobid>` is the same as the jobid showed above in the snakemake `err` file I just described. If the fastp rule above failed, I'd want to check out `slurm-53466180.out` in this `part3_snparcher/logs/slurm` folder to see why.

In practice, jobs from snpArcher typically fail because of memory (although it does resubmit many jobs with 2X then 3X the memory originally requested, but if this still isn't enough then snakemake fails). To change the memory, find the name of the rule in `config.yaml`.