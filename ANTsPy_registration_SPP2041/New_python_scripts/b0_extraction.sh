#!/bin/bash

# extract mean b0 from dMRI
for_each * : dwiextract IN/5_dwi/dwi_den_unr_pre_unbia.mif -bzero IN/5_dwi/b0.nii.gz -fo;
for_each * : mrmath IN/5_dwi/b0.nii.gz mean IN/2_nifti/b0.nii.gz -axis 3 -fo;

# delete file b0.nii.gz in 5_dwi
# continue to work with b0.nii.gz in 2_nifti