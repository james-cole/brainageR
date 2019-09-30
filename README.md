# brainageR
Software for generating a brain-predicted age value from a raw T1-weighted MRI scan. This uses a Gaussian Processes regression, implemented in R, using the kernlab package.

The software takes raw T1-weighted MRI scans, then uses **SPM12** for segmentation and normalisation. A slightly customised version **FSL** *slicesdir* is then used to generate a directory of PNGs and corresponding index.html file for quality controlling in a web browser. Finally, the normalised images and loaded into R using the **RNfiti** package, vectorised and grey matter, white matter and CSF vectors masked and combined. The mask is mean image derived from the registration template for each tissue class, thresholded at 0.2 and binarised. This final long vector (632065 voxels long) is then used to predict an age value with the trained model with **kernlab**.

### Changes for version 2.0
PCA (435 PCs)
CSF
All on github


### The Model 
The brainageR model for v2.0 was trained on n = 3377 healthy individuals from seven publicly-available datasets, and tested on n = 857.

* AIBL
* DLBS
* GSP
* IXI
* NKI-RS
* OASIS
* SALD

The model performance on the held-out test data (with random assignment to training and test) is as follows: Pearson's correlation between chronological age and brain-predicted age: r = 0.973, mean absolute error = 3.933 years, R^2 = 0.946. While a bias has been reported in terms of a correlation between chronological age and the brain-age difference, in this GPR model the correlation in the test set was r = -0.005. Hence, the model DOES NOT automatically correct predictions for a statistical dependency on chronological age. It is still recommend to use age as a covariate in future analysis that used brain-prediced age difference (brain-PAD) as the outcome measure.

### Citations
This model has yet to be used in a publication as of 30/09/2019, however some of the training dataset and general approach have been used before. So if you use this software, please consider citing one or more of the following papers:
* Cole JH, Ritchie SJ, Bastin ME, Valdes Hernandez MC, Munoz Maniega S, Royle N et al. Brain age predicts mortality. Molecular psychiatry 2018; 23: 1385-1392.
* Cole JH, Poudel RPK, Tsagkrasoulis D, Caan MWA, Steves C, Spector TD et al. Predicting brain age with deep learning from raw imaging data results in a reliable and heritable biomarker. NeuroImage 2017; 163C: 115-124.
* Cole JH, Leech R, Sharp DJ, for the Alzheimer's Disease Neuroimaging Initiative. Prediction of brain age suggests accelerated atrophy after traumatic brain injury. Ann Neurol 2015; 77(4): 571-581.

I am also hosting this package on [Zenodo](https://zenodo.org/) and it has it's own [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1346266.svg)](https://doi.org/10.5281/zenodo.1346266). You'll need to visit Zenodo to get the missing big file - see Installation below.

Since kernlab does most of the heavy lifting, please consider citing this excellent package:
https://cran.r-project.org/web/packages/kernlab/citation.html

## Prerequisites
* SPM12 (and thus MATLAB)
* R (tested on v3.4)
* R packages:
 * kernlab
 * RNifti
 * stringr

### Optional (but recommended) software
* FSL (for running slicesdir to generate images for quality checking the SPM segmentation)
* Lmod (for loading software modules - though if R, Matlab and SPM are all available without Lmod, the script should work) 
## Usage
```
brainageR software version 2.0 24 Sep 2019

Required arguments: 
	-f: input Nifti file
	-o: output csv filename

Optional arguments:
	-d: debug mode - turns off clean-up
	-h: displays this help message

For example:
brainageR -f subj01_T1.nii -o subj01_brain_predicted.age.csv
```

## Installation
Currently this Github repo is missing a crucial file, the rotation matrix created by running PCA on the training data (and necessary for applying to new data). This file is 2GB in size, over the limit for non-premium Github LFS. You can either get this file directly from me (james.cole@kcl.ac.uk) or from [Zenodo](https://doi.org/10.5281/zenodo.1346266).
Once you have that file, you should be able to clone this repo and save it in a directory call `brainage`, with a subdirectory called `software`.
Once you have the software files, you need to edit the `brainageR` script to set the `brainageR_dir` to the directory where the software files are and add the full pathway to your local installation of SPM12. This is what is currently in there, so please edit accordingly:
```
brainageR_dir=/home/jcole/brain_age/BRAIN_AGE_T1/brainageR/
spm_dir=/apps/matlab_toolboxes/spm12/
matlab_path=/Applications/MATLAB_R2017b.app/bin/matlab
FSLDIR=/usr/local/fsl/
```
For ease, you might then want to add the brainageR software directory to your path environmental variable.

## Notes
The software works on a single T1-weighted MRI scan in uncompressed Nifti format (e.g., subj01\_T1.nii). It can run locally or using an HPC cluster environment. To submit to an HPC queue manager (e.g., SGE, SLURM) you can use one the supplied templates (e.g., submit\_template.sh). Simply edit this script to fit your local environment, which will depend on how your sysadmin has configured MATLAB and R to run on your grid. You can then use the **generate_submit_scripts.sh** utility to create multiple versions of your tailored submit script, one per nifti file. Then use a for loop to submit these multiple scripts to the queue manager.

Since the software is designed to run on single Nifti files, an output file is created for each Nifti. You can use the **collate_brain_ages.sh** utility to combine multiple output.csv files from within a single director.

Example usage for single Nifti:
brainageR -f subj01\_T1.nii -o subj01_brain.predicted_age.csv

Example usage for multiple Niftis in one directory:
```css
ls T1_dir/
```
```
subj01_T1.nii
subj02_T1.nii
subj03_T1.nii
```
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
```
subj01_T1_submit_template.sh
subj02_T1_submit_template.sh
subj03_T1_submit_template.sh
```
```
for i in *submit_script.sh; do
	qsub $i
done
```
