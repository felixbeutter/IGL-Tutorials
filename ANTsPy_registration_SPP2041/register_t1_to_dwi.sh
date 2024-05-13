#!/bin/bash


for_each * : python -c "

import os
import ants

# load t1 and b0 images
t1 = ants.image_read('IN/2_nifti/t1.nii.gz')
b0 = ants.image_read('IN/2_nifti/b0.nii.gz')

# create output directory
output_dir = 'ants_registration'
os.makedirs(output_dir, exist_ok=True)

# register t1 to b0 image
transform_list = ants.registration(fixed=b0, moving=t1, 
type_of_transform='Affine')
transformed_t1 = ants.apply_transforms(fixed=b0, moving=t1, 
transformlist=transform_list['fwdtransforms'])

# write output file
ants.image_write(transformed_t1, os.path.join(output_dir, 
't1_to_dwi.nii.gz'))

"
