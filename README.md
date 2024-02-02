# Introduction to computational workflows in biology

If you'd like to actively participate, **please follow the steps below**. If you have any questions, please email me and we can go through it together. Setting all of this up will be useful for your own research, whether it's on the cluster or your laptop.

#### 1. See [this page](https://researchcomputing.princeton.edu/systems/della) about getting access to Princeton's Della computing cluster if you dont already have an account.

You can also follow along on any other computing cluster you have access to or your personal computer. Just open a terminal window to access the command line (e.g. Mac computers have a 'Terminal' app, which opens a terminal window). However, on your personal computer you won't be able to 'submit jobs' to a computing cluster, which has many CPUs that allow you to potentially run your code much faster!

#### 2. **We will use conda and mamba -- further explained in [part 1](/part1_basics/) of this workshop -- to install and manage software**. 

If you have either one of these already installed, you can feel free to ignore this step. However, I suggest installing it the way I have done here. Up to you! If you don't, everything we do in the workshop *should* still work, but you may have to use the conda command instead of the mamba command (which is much faster; but more of this in [part 1](/part1_basics/)).

You can install conda/mamba by following the steps below on the command line using a terminal window. The instructions are for installing them on the Della cluster, but you can also do this on your personal computer by skipping step 1. When I get a new work laptop or access to a new computing cluster, the *first* thing I do is install conda/mamba.

1. Once you've opened a Terminal window, log into the Della cluster using `ssh <YourNetID>@della.princeton.edu`, where you'd replace `<YourNetID>` with the appropriate string, mine is `bjarnold`.
2. Type `cd` to go to your home directory on the cluster, if you aren't there already.
3. Copy/paste this highlighted text to the command line: `wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh`. Press Enter. This will download a script that will automate the installation of conda and mamba.
    - If you have any previous installation of conda that isn't from the miniforge repository, I personally suggest removing all of them and starting from scratch. Reinstalling programs should go *very quickly*.
        - e.g. I removed my old conda installation, from [miniconda](https://docs.conda.io/projects/miniconda/en/latest/), via `rm -r /home/bjarnold/miniconda3`
4. To install conda/mamba, type `bash Miniforge3-Linux-x86_64.sh`, where the second part is the `.sh` file you just downloaded in the previous step. Follow the instructions on the screen:
    - Press ENTER to "read" the license agreement, keep pressing spacebar until you reach the end, type 'yes' to accept the terms.
    - By default, it will install miniforge3 in your home directory but asks for confirmation. I just press ENTER to confirm, but feel free to specify another location.
    - When it asks 'Do you wish the installer to initialize Miniforge3 by running conda init?', type 'yes'.
    - You should see a directory `miniforge3` that was just created. This is where all software we install will be located.
5. You may need to log back into the cluster before everything works as expected.
    - Type `conda --help` and `mamba --help` to ensure they're installed, you should see a lengthy explanation of how to use the programs.

#### 3. Download code and (optional) example data

- Using the `cd` command, move into a directory on the cluster in which you have more than **~30** GB of space.
    - E.g. I'm going to do `cd /scratch/gpfs/bjarnold/` on the Della cluster. You can get a similar directory in the scratch space on Della.
- Clone this repository: `git clone https://github.com/brian-arnold/intro_compbio_workflows_2024`.
- Move into the repository: `cd intro_compbio_workflows_2024`.
- Download African elephant WGS data (~6GB): `wget -O data.tar.gz https://zenodo.org/records/10452771/files/data.tar.gz?download=1`.
- Unpack the tarball we just downloaded: `tar zxvf data.tar.gz`.
- You should now see a directory called `data` that has two subdirectories: `fastq` and `genome`.

#### 4. OPTIONAL: VS Code installation 
- If you skip this step, you can follow along during the workshop using a terminal window. I'll use a terminal window within VS code. I kept details here a little sparse because I don't know how many will be interested in using it.
- I now use VS Code for all computational work that I do. It's amazing and extremely popular. You can download it [here](https://code.visualstudio.com/download).
- VS Code is very simple, and the user makes it more complex by installing plugins. My two favorite are:
    - `Remote - SSH` to log into a remote server (e.g. the Della cluster)
    - `GitHub Copilot` so that AI helps me code everytime I open a text editor in VS Code. This plugin has been *life changing*. Coding in python is much faster and cleaner. You can use it with R, but you have to use a Jupyterlab notebook, not R Studio :(.
    

