
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
- **grep 'pattern'** (grab all lines from a file that contain 'pattern', this command is extremely useful for probing very large files)
- **gzip** and **gunzip** (compress and decompress, respectively, files that have a `.gz` suffix)
- **tar** (this essentially does the same as gzip/gunzip above, but it acts on entire directories and subdirectories)
- **nano** and **vim** (text editors for the terminal, but editing files with VS Code is easier :) )
- there are other useful commands, but I use them < 1% of the time. For anything else you need, just ask chatGPT

### Examples

As an example, we will navigate through the subdirectories in the 'data' directory.

Many of these commands (cat/zcat, grep, head/tail, wc -l, ls) can be chained together using the pipe symbol '|'.
- `cd data`
- `cd fastq`
- `ls` or `ls -ltrh`
- `head 2981B_1.fastq.gz`
- `zcat 2981B_1.fastq.gz | head`
- `cd ../genome`
- `head Loxodonta_africana.loxAfr3.dna.toplevel.fa`
- `grep '>' Loxodonta_africana.loxAfr3.dna.toplevel.fa | wc -l` 
- `grep '>' Loxodonta_africana.loxAfr3.dna.toplevel.fa > scaffold_names.txt`
- `nano Loxodonta_africana.loxAfr3.dna.toplevel.dict`
- `scp ./some_file bjarnold@della.princeton.edu:/home/bjarnold`
    - this command would be run on your local computer to copy a file to the cluster, in my home directory (so change this destination directory if you want to try it out :))

#### Exercise
We sent our DNA samples to a sequencing facility, and they later sent us some FASTQ files, 2 for each sample (the forward and reverse read; the ends of each DNA molecule are sequenced separately). In these FASTQ files, each sequencing read has 4 lines of text, one of which is the actual sequencing read. The sequencing facility promised us *at least* 30 million reads for each sample. How many reads did we get for sample `2981B`? Did they deliver on their promise?


## Using Conda or Mamba to install and manage software

Much research involves analyzing data using software developed by others. Conda, and it's recently upgraded successor Mamba, are extremely useful for installing and managing this software. Most program I’ve wanted to use are installable via conda, and you can even manage R packages with conda.

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
- `mamba create --name bioinformatics`
- `mamba activate bioinformatics`
- `mamba install --channel conda-forge --channel bioconda snakemake=7.32.4 -y`
    - taken from the [snakemake webpage](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html#:~:text=mamba%20create%20%2Dc%20conda%2Dforge%20%2Dc%20bioconda%20%2Dn%20snakemake%20snakemake)
    - this is the latest version of snakemake before version 8, which made dramatic changes that broke code, so we'll use an older version for now.
- `mamba install --channel bioconda fastp bwa sambamba freebayes samtools -y`
    - check anaconda.org to see what channel to use with `--channel`, or `-c` or for other specific instructions
- tpe `bwa` to see that it successfully installed
- `mamba deactivate`
- `mamba env list` to see the new environment we just created, i use this to remind myself of environment names!

In addition to these conda commands, I also use the following to remove an environment:
- `mamba remove -n env_name --all`
    - where your replace `env_name` with the name of your environment

#### Exercise

We have many sequences of unknown origin, and we want to use BLAST on the command line to automate the process of finding which species each sequence belongs to. Follow these steps that I typically do when trying to use new software:
1. Is BLAST available on Anaconda? Search 'BLAST' on [Anaconda.org](https://anaconda.org/), or google search 'anaconda blast'
2. If so, use mamba to create a new environment called 'blast', and install the program.
3. Confirm that BLAST was successfully installed.

Additional info for part 3: in the context of computing, 'bin' is short for 'binary', and folders on computers called 'bin' typically contain files that are directly executable by the computer (i.e. can be run as a program). All of the executable files/programs we just installed in this environment should be located in `~miniforge3/envs/blast/bin`, assuming you've installed conda/mamba in your home directory. Check this location for all the programs you just installed. Sometimes I install a program via anaconda, but the name of the command line executable file differs from the name of the program! I find what I need in this `bin` directory :). You can also figure this out by reading the BLAST manual online.

After you spent weeks using BLAST, you read some papers and found out there is a much better approach to solve your problem. Remove the 'blast' environment using `mamba remove` briefly described above.

### Submitting jobs on Princeton's Della cluster

When you log into Princeton's Della cluster using a terminal, you get put on a 'login' node that you can use to browse files and do work that doesn't require much computing power, such as installing programs using mamba, or maybe using python to quick divide a number by 4. 

When you want to do heavy computational work, you need to write out all the comamnds you want to use in a file, and submit this file as a 'job'. This file then gets sent to a compute node that's actually meant to do lots of computation.

Della, like computing clusters at other universities, uses software called 'Slurm' to schedule jobs. When you submit your job, it will be put in a queue, where it could sit for some period of time in a `PENDING` state, depending on how much you've been using the cluster lately. It will eventually start `RUNNING`, and after some time it will have then have one of the following statuses: `COMPLETED`, `FAILED`, or `TIMEOUT`. The first one is good, second one is bad, and the third one can be easily fixed by changing the time limit you request (more on this soon).

Before we start talking more about submitting jobs to the cluster, let's just look at an example

#### View shell script script in 00_simple_job_submission dir

The script `clean_fastq.sh` is an example of a shell script (it has the `.sh` file extension) used to submit a job to run a program. Here, we are running the program 'fastp' to clean up the raw FASTQ files for elephant sample `2982B`. If you scroll all the way to the bottom, this is the command we're actually trying to run, and the stuff above just prepares everything in an organized way, and makes a request to the computing cluster for a specific amount of resources, such as CPUs, memory, and time.

Let's go through the `clean_fastq.sh` script.

We can submit this command as a job using `sbatch clean_fastq.sh`.

Alternatively, if we want to run this code on the spot, we can use `bash clean_fastq.sh`. Unless the code is very simple, I would not do this on Della as you'd be running a program on a login node. However, if you're running programs on your own computer, e.g. using the Terminal app on your Mac, you would use the `bash` command.

Here are some commands I frequently use on the cluster:
- `sbatch`: to submit jobs
- `sacct`: to see the status of of all your jobs since last midnight
- `sacct --format="jobid,jobname,maxrss,reqmem,ncpu,elapsed,timelimit,state"`: more info about jobs
    - I refuse to memorize this, so I put the following in my `.bashrc` file in my home directory: `alias sstats='sacct --format="jobid,jobname,maxrss,reqmem,ncpu,elapsed,timelimit,state"'`
    - then I just type `sstats` instead!
- `squeue -u $USER --start` to see when your job will start running
    - again, I just put `alias jobstart='squeue -u $USER --start'` in my `.bashrc` file and type `jobstart` instead of the longer, uglier command
- `checkquota`: to see how much space I have left!

#### View scripts in 01_fastq_2_vcf_workflow

- see `slides/part1_basics.pptx` for intro to this workflow
- go through scripts for each step, where steps are in directories labelled by the output file type
- for simplicity, this workflow only processes a single sample even though we have two
- you can change the `NAME` variable to process the other sample