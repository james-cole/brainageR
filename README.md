# brainageR
Software for generating a brain-predicted age value, using Gaussian Processes regression, implemented in R, using the kernlab package.
Once you have downloaded the software files, you need to edit the brainageR script to set the brainageR_dir to the directory where the software files are and add the full pathway to your local installation of SPM12.
For ease, you might then want to add the brainageR software directory to your path environmental variable.

## Prerequisites

SPM12 (and MATLAB)
Lmod (for loading software modules - though if R, Matlab and SPM are all available without Lmod, the script should work) 

R (tested on v3)
R packages:
kernlab
RNifti
stringr

FSL (for running slicesdir to generate images for quality checking the SPM segmentation)

## Notes
The software works on a single T1-weighted MRI scan in uncompressed Nifti format (e.g., subject_01_T1.nii). It can run locally or using an HPC cluster environment. To submit to an HPC queue manager (e.g., SGE, SLURM) you can use one the supplied templates (e.g., submit_template.sh). Simply edit this script to fit your local environment, which will depend on how your sysadmin has configured MATLAB and R to run on your grid. You can then use the generate_submit_scripts.sh utility to create multiple versions of your tailored submit script, one per nifti file. Then use a for loop to submit these multiple scripts to the queue manager.
Since the software is designed to run on single Nifti files, an output file is created for each Nifti. You can use the collate_brain_ages.sh utility to combine multiple output.csv files from within a single director.

Example usage for single Nifti:
brainageR -f subj01_T1.nii -o subj01_brain.predicted_age.csv

Example usage for multiple Niftis in one directory:

```
ls T1_dir/
```
subj01_T1.nii
subj02_T1.nii
subj03_T1.nii

```
cd T1_dir/
```

```
ls *nii > file_list.txt
```

```
generate_submit_scripts file_list.txt /apps/brainageR/software/sge_submit_template.sh
```

```
ls *sh
```
subj01_T1_submit_template.sh
subj02_T1_submit_template.sh
subj03_T1_submit_template.sh

```
for i in *submit_script.sh; do
	qsub $i
done
```

