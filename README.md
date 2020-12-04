# brainageR
Software for generating a brain-predicted age value from a raw T1-weighted MRI scan. This uses a Gaussian Processes regression, implemented in R, using the kernlab package.

The software takes raw T1-weighted MRI scans, then uses **SPM12** for segmentation and normalisation. A slightly customised version **FSL** *slicesdir* is then used to generate a directory of PNGs and corresponding index.html file for quality controlling in a web browser. Finally, the normalised images and loaded into R using the **RNfiti** package, vectorised and grey matter, white matter and CSF vectors masked (using 0.3 in the average image from the brainageR-specific template, derived from n=200 scans, n=20 from each of the n=10 scanners) and combined. In version 2.0 Principal Components Analysis was run (using R's prcomp), and the top 80% of variance retained. This meant 435 PCs were included. The rotation matrix of the PCA is applied to any new data adn these 435 variables are then used to predict an age value with the trained model with **kernlab**.

### Brain-age Model 
The brainageR model for v2.0 was trained on n = 3377 healthy individuals from seven publicly-available datasets, and tested on n = 857. All participants included were healthy according to local study data. For example OASIS participants were only included if they had a CDR score < 0.5. All data was visually quality control to ensure quality and accuracy of image processing. Demographics were error-checked, and exclusions made if age values were unavailable.

* Australian Imaging, Biomarker & Lifestyle Flagship Study of Ageing ([AIBL](https://aibl.csiro.au/))
* Dallas Lifespan Brain Study ([DLBS](http://fcon_1000.projects.nitrc.org/indi/retro/dlbs.html))
* Brain Genome Superstruct Project ([GSP](https://dataverse.harvard.edu/dataverse/GSP))
* [IXI](https://brain-development.org/ixi-dataset/)
* [Nathan Kline Institute Rocklands Sample Enhanced](http://fcon_1000.projects.nitrc.org/indi/enhanced/)
* Open Acces Series of Imaging Studies-1 ([OASIS-1](https://www.oasis-brains.org/))
* Southwest University Adult Lifespan Dataset ([SALD](http://fcon_1000.projects.nitrc.org/indi/retro/sald.html))

The model performance on the held-out test data (with random assignment to training and test) is as follows: Pearson's correlation between chronological age and brain-predicted age: r = 0.973, mean absolute error = 3.933 years, R^2 = 0.946. While a bias has been reported in terms of a correlation between chronological age and the brain-age difference, in this GPR model the correlation in the test set was r = -0.012. Hence, the model DOES NOT automatically correct predictions for a statistical dependency on chronological age. It is still recommend to use age as a covariate in future analysis that used brain-prediced age difference (brain-PAD) as the outcome measure.

For a plot of brain-predicted age and age please see figshare [here](https://figshare.com/articles/brainageR_test_scatterplot_pdf/9948536)

The model has been tested using an entirely independent data, CamCAN, which was not used for training. These data included n=611 people aged 18-90 years. Performance here was r = 0.947, MAE = 4.90 years. Interestingly, there was still a significant relationship between the brain-predicted age difference (brain-PAD, AKA gap, AKA delta) and chronological age, r = -0.379. This reiterates the importance of correcting for the proportional bias in subsequent analyses.

For a plot of brain-predicted age and age in CamCAN please see figshare [here](https://figshare.com/articles/brainageR_CamCAN_scatterplot_pdf/9948533)

### Citations
This model has yet to be used in a publication as of 30/09/2019, however some of the training dataset and general approach have been used before. So if you use this software, please consider citing one or more of the following papers:
* Cole JH, Ritchie SJ, Bastin ME, Valdes Hernandez MC, Munoz Maniega S, Royle N et al. Brain age predicts mortality. Molecular psychiatry 2018; 23: 1385-1392.
* Cole JH, Poudel RPK, Tsagkrasoulis D, Caan MWA, Steves C, Spector TD et al. Predicting brain age with deep learning from raw imaging data results in a reliable and heritable biomarker. NeuroImage 2017; 163C: 115-124.
* Cole JH, Leech R, Sharp DJ, for the Alzheimer's Disease Neuroimaging Initiative. Prediction of brain age suggests accelerated atrophy after traumatic brain injury. Ann Neurol 2015; 77(4): 571-581.

I am also hosting this package on [Zenodo](https://zenodo.org/) and it has it's own [![DOI](https://zenodo.org/badge/144994886.svg)](https://zenodo.org/badge/latestdoi/144994886) and on [OSF](https://osf.io/azwmg/).

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
Currently this Github repo is missing a crucial file (pca_rotation.rds), the rotation matrix created by running PCA on the training data (and necessary for applying to new data). This file is 2GB in size, over the limit for non-premium Github LFS. However, you can get this from the v2.1 Releases [page](https://github.com/james-cole/brainageR/releases), where it is listed under Binaries, along with two other much smaller binary files that you'll need. It's also availabe on [Zenodo](https://doi.org/10.5281/zenodo.3463212) or [OSF](https://osf.io/azwmg/).
Once you have the .rds files, you should be able to clone this repo and save it in a directory call `brainage`, with a subdirectory called `software`.
Once you have the software files, you need to edit the `brainageR` script to set the `brainageR_dir` to the directory where the software files are and add the full pathway to your local installation of SPM12, your MATLAB binary and your FSL directory. This is what is currently in there, so please edit accordingly:
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
