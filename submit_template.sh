#!/bin/sh
#SBATCH -N 1
#SBATCH --cpus-per-task=2
#SBATCH --mem=1GB
#SBATCH --partition=veryshort
#SBATCH -o input_brainageR.out
#SBATCH -e input_brainageR.err
#SBATCH -J input_brainageR
 
module load R
module load fsl
module load matlab

bash /home/jcole/brain_age/BRAIN_AGE_T1/brainageR/software/brainageR -f input.nii -o input_brain_predicted_age.csv
