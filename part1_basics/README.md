
# Part 1: linux commands, installing software, and submitting jobs on Princeton's Della computing cluster.

## Linux commands to navigate through directories

In order to explore files and directories on Princeton's computing cluster, it is very helpful to use a terminal window and use Linux commands. These commands should also work on your personal computer!

Here are some Linux commands I use a majority of the time:

- **cd** ("change directories", to move around the file system)
- **wc -l** ("word count", to count the number of lines (-l) in a file)
- **cat** and **zcat** ("concatenate", to combine files or just display the contents of a file to the screen, zcat is for compressed files)
- **mv** ("move", to rename files and folders)
- **rm** ("remove", use carefully)
- **mkdir** ("make directory", cretes a new folder)
- **ls** ("list", to list all the files in a directory or folder, I like also using with -ltr)
- **head** and **tail** (to display the "head" or "tail" of a file, using with -n 5 only shows the first/last 5 lines)
- **cp** and **scp** ("copy", to copy files in one directory to another; scp is "secure" copy to transfer files from your personal computer onto the cluster)
- **ssh** ("secure shell", to log into a remote server)
- **grep '<pattern>'** (grab all lines from a file that contain <pattern>)
- **gzip** and **gunzip**
- **tar** 
- **nano** and **vim** (text editors for the terminal, but editing files with Vscode is easier)
- there are other useful commands, but I use them < 1% of the time. For anything else you need, just ask chatGPT

### Examples

As an example, we will navigate through the subdirectories in the 'data' directory.

Many of these commands (cat/zcat, grep, head/tail, wc -l, ls) can be chained together using the pipe symbol '|'.
- `cd data`
- `cd fastq`
- `ls` or `ls -ltrh`
- `head 2981B_1.fastq.gz`
- `zcat 2981B_1.fastq.gz | head`
- `zcat 2981B_1.fastq.gz | wc -l`
- `cd ../genome`
- `head Loxodonta_africana.loxAfr3.dna.toplevel.fa`
- `grep '>' Loxodonta_africana.loxAfr3.dna.toplevel.fa | wc -l` 
- `grep '>' Loxodonta_africana.loxAfr3.dna.toplevel.fa > scaffold_names.txt`
- `nano Loxodonta_africana.loxAfr3.dna.toplevel.dict`
- `scp ./some_file bjarnold@della.princeton.edu:/home/bjarnold`
    - this command would be run on your local computer to copy a file to the cluster, in my home directory (so change this destination directory if you want to try it out :))

## Using conda (and mamba) to install and manage software

Much research involves analyzing data using software developed by others. Conda is extremely useful for installing and managing this software. Most program I’ve wanted to use are installable via conda, and you can even manage R packages with conda.

### Why should you use conda?

#### Software installation
Software engineers typically build upon previously-existing software to make a new program (or package). Thus, when you install their new program, you also need to install this previously-existing software they used, which are called dependencies. Conda takes care of all of this for you automatically!

#### Software management
If you want to simultaneously use several software packages, you may run into conflicts in which several of them have conflicting dependencies; i.e. the software packages require different versions of the same dependency. If you run into this issue, you can get strange error messages that take a while to solve. When you install software via conda, it tries to install software in such a way that everything is compatible, saving you a lot of time and frustration.

Software is also separated into 'environments', allowing you to install and seamlessly switch between different version of software. If two programs require difference versions of the same dependency (which is rare but does happen), you can just create different environments for each program so that they can each have their own separate version of the depencency.

#### What is mamba?
An updated version of conda that installs software ***much*** faster, making conda feel painfully slow by comparison.

### Conda tutorial

Let's start by finding out exactly where miniforge3 was installed on the cluster (or your personal comupter). Mine is here:

`/home/bjarnold/miniforge3`


Before we start submitting jobs to run software on the cluster, let's install this software in our first conda environment. To see if software exists on anaconda and how to we might install it, I always quick google the name of the program along with anaconda.

Let's make our conda environment:
- `conda create --name bioinformatics`
- `conda activate bioinformatics`
- `mamba install --channel bioconda fastp bwa sambamba freebayes`
    - check anaconda.org to see what channel to use with `-c`
- `bwa --help` to see that it successfully installed
- `conda deactivate`
- `conda env list` to see the new environment we just created, i use this to remind myself of environment names!

In addition to these conda commands, I also use the following to remove an environment:
- `conda remove -n env_name --all`
    - where your replace `env_name` with the name of your environment



### Submitting jobs

SLURM commands I frequently use to submit jobs and monitor their progress
- `sbatch`
- `sacct`
- `sacct --format="jobid,jobname,maxrss,reqmem,ncpu,elapsed,timelimit,state"`
    - i refuse to memorize this, so I put the following in my `.bashrc` file in my home directory: `alias sstats='sacct --format="jobid,jobname,maxrss,reqmem,ncpu,elapsed,timelimit,state"'`
    - then I just type `sstats` instead!
- `checkquota`

View script in 00_simple_job_submission dir
- submit as job using 'sbatch'
- run as bash script using 'bash'

View scripts in 01_fastq_2_vcf_pipeline