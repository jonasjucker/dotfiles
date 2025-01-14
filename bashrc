# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#

test -s ~/.alias && . ~/.alias || true

# determine hostname for later use in all dotfiles
if [[ "${HOSTNAME}" == tsa* ]]; then
    BASHRC_HOST='tsa'
elif [[ "${HOSTNAME}" == daint* ]]; then 
    BASHRC_HOST='daint'
elif [[ "${HOSTNAME}" == dom* ]]; then 
    BASHRC_HOST='dom'
elif [[ "${HOSTNAME}" == todi* ]]; then 
    BASHRC_HOST='todi'
elif [[ "${HOSTNAME}" == santis* ]]; then 
    BASHRC_HOST='santis'
elif [[ "${HOSTNAME}" == balfrin* ]]; then 
    BASHRC_HOST='balfrin'
elif [[ "${HOSTNAME}" == eu* ]]; then 
    if tty -s; then
        BASHRC_HOST='euler'

    # Source global definitions as Jenkins user
    else
        if [ -f /etc/bashrc ]; then
            . /etc/bashrc
            module load stack openjdk
        fi
        return
    fi
elif [[ "${HOSTNAME}" == *levante* ]]; then 
    if tty -s; then
        BASHRC_HOST='levante'

    # load java and git as Jenkins user
    else
        source /sw/etc/profile.levante
        module load openjdk/17.0.0_35-gcc-11.2.0
        module load git
        return
    fi
fi
export BASHRC_HOST

# ls colors
export LS_COLORS='di=1:fi=0:ln=100;93:pi=5:so=5:bd=5:cd=5:or=101:mi=0:ex=1;31'

# Git settings
export GIT_EDITOR="vim"
parse_git_branch() {
git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Command prompt
short_host="${HOSTNAME:0:2}-${HOSTNAME:${#HOSTNAME}-1:${#HOSTNAME}}"
export PS1="\u@$short_host:\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\]> "

# Custom modules/paths/envs for each machine

# tsa
if [[ "${BASHRC_HOST}" == "tsa" ]]; then
    source /oprusers/osm/.opr_setup_dir
    export OPR_SETUP_DIR=/oprusers/osm/opr.arolla
    export LM_SETUP_DIR=$HOME
    PATH=${PATH}:${OPR_SETUP_DIR}/bin
    export MODULEPATH=$MODULEPATH:$OPR_SETUP_DIR/modules/modulefiles 

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/users/juckerj/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/users/juckerj/miniconda3/etc/profile.d/conda.sh" ]; then
            . "/users/juckerj/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="/users/juckerj/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<

# daint
elif [[ "${BASHRC_HOST}" == "daint" ]]; then
    test -s /etc/bash_completion.d/git.sh && . /etc/bash_completion.d/git.sh || true
    export PATH=/users/juckerj/fortls/bin:$PATH

elif [[ "${BASHRC_HOST}" == "levante" ]]; then
    module load git
elif [[ "${BASHRC_HOST}" == "euler" ]]; then
    export PATH=${PATH}:~/.local/bin
elif [[ "${BASHRC_HOST}" == "balfrin" ]]; then
    export PATH=${PATH}:~/.local/bin
    export MODULEPATH=/mch-environment/v6/modules:/usr/share/modules:/usr/share/Modules/$MODULE_VERSION/modulefiles:/usr/share/modules/modulefiles
fi

# Machine specific aliases

# tsa
if [[ "${BASHRC_HOST}" == "tsa" ]]; then
    alias sc='cd /scratch/juckerj/'
    alias aall="scancel -u juckerj"
    alias sq='squeue -u juckerj'
    alias squ='squeue'
    alias hh='cd /users/juckerj/'

# daint
elif [[ "${BASHRC_HOST}" == "daint" ]]; then
    alias sc='cd /scratch/snx3000/juckerj/'
    alias aall="scancel -u juckerj"
    alias sq='squeue -u juckerj'
    alias squ='squeue'
    alias hh='cd /users/juckerj/'
    alias jenkins='cd /scratch/snx3000/jenkins/workspace'

elif [[ "${BASHRC_HOST}" == "todi" ]]; then
    alias sc='cd /capstor/scratch/cscs/juckerj'
    alias aall="scancel -u juckerj"
    alias sq='squeue -u juckerj'
    alias squ='squeue'
    alias hh='cd /users/juckerj/'
    alias srcuenv='source ~/.local/bin/activate-uenv'

# santis
elif [[ "${BASHRC_HOST}" == "santis" ]]; then
    alias sc='cd /capstor/scratch/cscs/juckerj'
    alias aall="scancel -u juckerj"
    alias sq='squeue -u juckerj'
    alias squ='squeue'
    alias hh='cd /users/juckerj/'

# balfrin
elif [[ "${BASHRC_HOST}" == "balfrin" ]]; then
    alias sc='cd /scratch/mch/juckerj'
    alias aall="scancel -u juckerj"
    alias sq='squeue -u juckerj'
    alias squ='squeue'
    alias hh='cd /users/juckerj/'
    alias jenkins='cd /scratch/e1000/meteoswiss/scratch/jenkins'

# dom
elif [[ "${BASHRC_HOST}" == "dom" ]]; then
    alias sc='cd /scratch/snx3000tds/juckerj/'
    alias aall="scancel -u juckerj"
    alias sq='squeue -u juckerj'
    alias squ='squeue'
    alias hh='cd /users/juckerj/'

# euler
elif [[ "${BASHRC_HOST}" == "euler" ]]; then
    alias sc='cd /cluster/scratch/juckerj/'
    alias aall="scancel -u juckerj"
    alias hh='cd /cluster/home/juckerj/'
    alias sq='squeue -u juckerj'
    alias squ='squeue'

# levante
elif [[ "${BASHRC_HOST}" == "levante" ]]; then
    alias aall="scancel -u b381001"
    alias sq='squeue -u b381001'
    alias squ='squeue'
    alias hh='cd /home/b/b381001'
    alias sc='cd /scratch/b/b381001/'
fi

# Model specific aliases

# COSMO
alias ct="cat testsuite.out"
alias tt="tail -f testsuite.out"
alias bu='./test/jenkins/build.sh'
alias vo='vim INPUT_ORG'
alias vp='vim INPUT_PHY'
alias vd='vim INPUT_DYN'
alias vio='vim INPUT_IO'

# ICON
alias lsL='ls -ltr LOG*' 
alias tL='tail -f LOG*'


# General aliases
alias m8='make -j 8'
alias m3='make -j 3'

# navigation
alias ls='ls --color'
alias lsl='ls -ltrh --color'
alias la='ls -A'
alias g='grep -i'
alias t='tail -f'
alias ..='cd ..'
alias ....='cd ../..'
alias fp='find "$PWD" -name'
alias lsC='ctags -R'

#environment
alias ml='module load'
alias mll='module load'
alias su='source'
alias srcrc='source ~/.bashrc'
alias rcvim='vim ~/.bashrc'

# git
alias gt='git status'
alias ga='git add'
alias gsi='git submodule init'
alias gsu='git submodule update'
alias gpo='git push origin'

#vim
alias vims='vim -S Session.vim'

#spack
alias spap="spack env activate"
alias clone_spack="git clone --recurse-submodules --shallow-submodules git@github.com:C2SM/spack-c2sm.git"

# helper functions

touch_all() {

# Touch all files in a folder
# Usage:
#       touch_all -> touch all files in current folder
#       touch_all <folder> -> touch all files in <folder>

    if [ $# -eq 0 ]; then
        folder=$(pwd)
    else
        folder=$1
    fi 
    cd $folder

    find -print | while read filename; do
        # do whatever you want with the file
        echo "touch $filename"
        touch "$filename"
    done
    cd -
}

scp_to_daint() {

    scp -r -o ProxyCommand="ssh -W %h:%p juckerj@ela.cscs.ch" $1 juckerj@daint.cscs.ch:$2
}

scp_from_daint() {

    scp -r -o ProxyCommand="ssh -W %h:%p juckerj@ela.cscs.ch" juckerj@daint.cscs.ch:$1 $2
}

use_mods(){
    module use /user-environment/modules
}
