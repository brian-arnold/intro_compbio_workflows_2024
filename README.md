# Introduction to computational workflows in biology

If you'd like to actively participate, please follow the steps below. If any of the following looks scary, or you have any questions, please email me and we can go through it together! Setting all of this up will be useful for your own research! Whether it's on the cluster or your laptop.

#### 1. See [this page](https://researchcomputing.princeton.edu/systems/della) about getting access to Princeton's Della computing cluster if you dont already have an account.

#### 2. **We will use conda and mamba, two nearly identical programs, to install and manage software**. 

You can install these tools, which are further explained in [part 1](/part1_basics/) of this workshop, from the miniforge github repository. All of the following steps are done on the command line using a terminal window (e.g. MAC computers have a 'Terminal' app, which opens a terminal window).

1. Once you've opened a Terminal window, log into the Della cluster using `ssh <YourNetID>@della.princeton.edu`, where you'd replace `<YourNetID>` with the appropriate string, mine is `bjarnold`
    - you can also skip this step if you want to set everything up on your personal computer! I also have conda/mamba installed on my laptop. It's the first thing I do when I get a new work laptop.
2. Type `cd` to go to your home directory on the cluster, if you aren't there already.
3. Type `wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh` to download a script that will automate the installation of conda and mamba.
    - If you have any previous installation of conda that isn't from miniforge, I personally suggest removing all of them and starting from scratch. Reinstalling programs should go *very quickly*.
        - e.g. I removed my old conda installation, from [miniconda](https://docs.conda.io/projects/miniconda/en/latest/), via `rm -r /home/bjarnold/miniconda3`
4. To install conda/mamba, type `bash Miniforge3-Linux-x86_64.sh` and follow the instructions on the screen.
    - Press ENTER to "read" the license agreement, keep pressing spacebar until you reach the end, type 'yes' to accept the terms.
    - By default, it will install miniforge3 in your home directory but asks for confirmation. I just press ENTER to confirm, but feel free to specify another location.
    - When it asks 'Do you wish the installer to initialize Miniforge3 by running conda init?', type 'yes'.
    - You should see a directory `miniforge3` that was just created. This is where all software we install will be located.
5. You may need to log back into the cluster before everything works as expected.
    - Type `conda --help` and `mamba --help` to ensure they're installed, you should see a lengthy explanation of how to use the programs.

#### 3. Download code and example data
    - Using the `cd` command, move into a directory on the cluster in which you have more than **XX** GB of space.
    - Clone this repository: `git clone https://github.com/brian-arnold/intro_compbio_workflows_2024`.
    - Move into the repository: `cd intro_compbio_workflows_2024`.
    - Download African elephant WGS data (~6GB): `wget -O data.tar.gz https://zenodo.org/records/10452771/files/data.tar.gz?download=1`.
    - Unpack the tarball we just downloaded: `tar zxvf data.tar.gz`.
    - You should now see a directory called `data` that has two subdirectories: `fastq` and `genome`.

#### 4. VS Code installation (Optional; if you skip this step, you can follow along during the workshop using a terminal window) 
    - I now use VS Code for all computational work that I do. It's amazing and extremely popular. You can download it [here](https://code.visualstudio.com/download).
    - VS Code is very simple, and the user makes it more complex by installing plugins. My two favorite are:
        - `GitHub Copilot` so that AI helps me code everytime I open a text editor in VS Code.
        - `Remote - SSH` to use VS code to log into a remote server (e.g. the Della cluster)
    

