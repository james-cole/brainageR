#!/usr/bin/env Rscript
## kernlab regression using nifti files
## James Cole 07/08/2018
rm(list = ls())
args <- commandArgs(trailingOnly = TRUE)
## test if there are two argument: if not, return an error
if (length(args) < 5) {
  stop("Four arguments must be supplied (brainageR directory full path; list of GM nifti files; list of WM nifti files; kernlab model; output filename).n", call. = FALSE)
}
## set remote or local for testing. Uncomment accordingly
brainage_dir <- args[1]

## libraries
library(kernlab)
library(RNifti)
library(stringr)
## get new data and load masks
# setwd(paste(brainage_dir, "brain_age/BRAIN_AGE_T1/brainageR", sep = ""))
gm.list <- read.table(file = args[2], header = FALSE, colClasses = "character")$V1
wm.list <- read.table(file = args[3], header = FALSE, colClasses = "character")$V1
## read in mask file and convert to vectors
gm_mask <- as.vector(readNifti(paste(brainage_dir, "/software/masks/gm_mask02.nii", sep = "")))
wm_mask <- as.vector(readNifti(paste(brainage_dir, "/software/masks/wm_mask02.nii", sep = "")))

## create nifti vector matrices
read_mask_nii <- function(arg1){
  gm <- as.vector(readNifti(gm.list[arg1]))
  gm <- gm[gm_mask == 1]
  wm <- as.vector(readNifti(wm.list[arg1]))
  wm <- wm[wm_mask == 1]
  gm.wm <- c(gm, wm)
  return(gm.wm)
}
paste("loading nifti data", date(),sep = " ")
new_data_mat <- matrix(unlist(lapply(1:length(gm.list), function(x) read_mask_nii(x))), nrow = length(gm.list), byrow = TRUE)
dim(new_data_mat)
## load previously trained regression model
paste("loading regression model", date(),sep = " ")
load(args[4])
## generate predictions
pred <- predict(model, new_data_mat)
pred <- (pred - 3.33)/0.91
## save predictions to text file
paste("saving new results", date(),sep = " ")
str_sub(gm.list, 1, str_locate(gm.list, "smwc1")[,2]) <- ""
str_sub(gm.list, str_locate(gm.list, ".nii")[,1], str_length(gm.list)) <- ""
write.table(cbind(gm.list, round(pred,4)), 
            file = args[5],
            row.names = F,
            quote = F,
            col.names = c("File", "brain.predicted_age"), sep = ",")
