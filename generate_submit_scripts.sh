#!/bin/bash
## brainageR script for generating multiple submission scripts for sending jobs to a queue manager (e.g., SGE, SLURM)
## James Cole, King's College London james.cole@kcl.ac.uk
## software version 1.0 09 Aug 2018
file_list=$1
template=$2

if [ "$#" -ne 2 ]; then
    echo "You must specify two arguments, e.g., generate_submit_scripts.sh <file_list> <template_submit_script.sh>"
    exit 1
fi

for i in `cat $file_list`; do sed "s/input/${i%.nii}/g" $template > ${i%.nii}_submit_script.sh;done
