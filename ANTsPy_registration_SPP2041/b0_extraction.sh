#!/bin/bash

# extract mean b0 from dMRI
for_each * : dwiextract IN/5_dwi/dwi_den_unr_pre_unbia.mif -bzero - | mrmath 
-axis 3 - mean IN/2_nifti/b0.nii.gz

