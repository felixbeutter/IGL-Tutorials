#!/bin/bash

# extract mean b0 from dMRI
for_each * : dwiextract IN/5_dwi/dwi_den_unr_pre_unbia.mif - -bzero | mrmath -mean IN/2_nifti/b0.mif -axis 3

for_each * : mrconvert IN/2_nifti/b0.mif IN/2_nifti/b0.nii.gz