#!/bin/tcsh
## Set up the sge queue required defaults
#$ -r n
#$ -l h_vmem=10G
#$ -V 
#$ -j y
#$ -cwd
#$ -q global

module load fsl
module load matlab
set brainageR_dir=/local/path_to/brainageR/software
setenv PATH $PATH\:/local/path_to/brainageR/software
set spm_path=/local/path_to/spm12
setenv MATLABPATH ${spm_path}

bash brainageR -f input.nii -o input_brain_predicted_age.csv

