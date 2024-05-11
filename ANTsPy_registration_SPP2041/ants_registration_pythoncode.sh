#!/bin/bash

# mean b0 extraction from PE & reverse PE direction
for_each * : dwiextract IN/5_dwi/dwi_all.mif -bzero - | mrmath -axis 3 - 
mean IN/2_nifti/b0.nii
for_each * : gzip IN/2_nifti/b0.nii

# Python code for registration
for_each * : python -c "
import os
import ants

# MPM registration: load T1 and b0 images, create output directory
t1 = ants.image_read('IN/2_nifti/t1.nii.gz')
b0 = ants.image_read('IN/2_nifti/b0.nii.gz')

output_dir = 'ants_registration'
os.makedirs(output_dir)

# register moving T1 to fixed b0
transform_list = ants.registration(fixed=b0, moving=t1, 
type_of_transform='Affine')
transformed_t1 = ants.apply_transforms(fixed=b0, moving=t1, 
transformlist=transform_list['fwdtransforms'])

ants.image_write(transformed_t1, output_dir + '/transformed_t1.nii.gz')

# load R1, R2, PD, MT images
r1 = ants.image_read('IN/6_mpm/results/mpm/R1.nii')
r2s = ants.image_read('IN/6_mpm/results/mpm/R2s.nii')
pd = ants.image_read('IN/6_mpm/results/mpm/PD.nii')
mtsat = ants.image_read('IN/6_mpm/results/mpm/MTsat.nii')

# register MPM to b0 image
transform_list = ants.registration(fixed=b0, moving=r1, 
type_of_transform='Affine')
transformed_r1 = ants.apply_transforms(fixed=b0, moving=r1, 
transformlist=transform_list['fwdtransforms'])
transformed_r2s = ants.apply_transforms(fixed=b0, moving=r2s, 
transformlist=transform_list['fwdtransforms'])
transformed_pd = ants.apply_transforms(fixed=b0, moving=pd, 
transformlist=transform_list['fwdtransforms'])
transformed_mtsat = ants.apply_transforms(fixed=b0, moving=mtsat, 
transformlist=transform_list['fwdtransforms'])

ants.image_write(transformed_r1, output_dir + '/R1_to_dwi.nii.gz')
ants.image_write(transformed_r2s, output_dir + '/R2s_to_dwi.nii.gz')
ants.image_write(transformed_pd, output_dir + '/PD_to_dwi.nii.gz')
ants.image_write(transformed_mtsat, output_dir + '/MTsat_to_dwi.nii.gz')
"
