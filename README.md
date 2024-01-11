# Introduction to computational workflows in biology

If you'd like to actively participate, please follow the steps below. If any of the following looks scary, or you have any questions, please email me and we can go through it together!

1. See [this page](https://researchcomputing.princeton.edu/systems/della) about getting access to Princeton's Della computing cluster if you dont already have an account.

2. Install conda and mamba from the miniforge github repository. These two tools are further explained in [part1](/part1_basics/) of this workshop. All of the following steps are done on the command line using a terminal window (e.g. MAC computers have a 'Terminal' app you can open).
    - Once you've opened the Terminal app and see the command line, log into the Della cluster using `ssh <YourNetID>@della.princeton.edu`, where you'd replace `<YourNetID>` with the appropriate string
    - Type `cd` to go to your home directory, if you aren't there already
    - Type `wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh` to download a bash script
        - If you have any previous installation of conda that isn't from miniforge, I personally suggest removing all of them and starting from scratch. Reinstalling programs should go very quickly, especially if we use mamba.
            - e.g. I removed my previous conda installation via `rm -r /home/bjarnold/miniconda3`
    - to install conda/mamba, on the command line type `bash Miniforge3-Linux-x86_64.sh` and follow the instructions
        - when it asks 'Do you wish the installer to initialize Miniforge3 by running conda init?', type 'yes'
    - you may need to log back into the cluster before everything works as expected
        - type `conda --help` and `mamba --help` to ensure they're installed, you should see an lengthy explanation of how to use the programs

3. Download code and example data
    - using the `cd` command, move into a directory on the cluster in which you have more than XXX GB of space.
    - clone this repository: `git clone https://github.com/brian-arnold/intro_compbio_workflows_2024`
    - move into the repository: `cd intro_compbio_workflows_2024`
    - download African elephant WGS data (~6GB): `wget -O data.tar.gz https://zenodo.org/records/10452771/files/data.tar.gz?download=1`
    - unpack the tarball we just downloaded: `tar zxvf data.tar.gz`
    - you should now see a directory called `data` that has two subdirectories: `fastq` and `genome`

4. (Advanced) VS Code installation
    - I now use VS Code for all computational work that I do. You can download it [here](https://code.visualstudio.com/download).
    - VS Code is very simple, and the user makes it more complex by installing plugins. My two favorite are:
        - `GitHub Copilot` so that AI helps me code everytime I open a text editor in VS Code.
        - `Remote - SSH` to use VS code to log into a remote server (e.g. the Della cluster)

