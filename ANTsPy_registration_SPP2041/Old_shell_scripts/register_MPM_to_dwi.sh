#!/bin/bash


for_each * : python -c "

import os
import ants

# specify or create output directory
output_dir = 'IN/6_mpm/results/mpm/ants_registration'
os.makedirs(output_dir, exist_ok=True)

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

# write output files
ants.image_write(transformed_r1, os.path.join(output_dir, 
'R1_to_dwi.nii.gz'))
ants.image_write(transformed_r2s, os.path.join(output_dir, 
'R2s_to_dwi.nii.gz'))
ants.image_write(transformed_pd, os.path.join(output_dir, 
'PD_to_dwi.nii.gz'))
ants.image_write(transformed_mtsat, os.path.join(output_dir, 
'MTsat_to_dwi.nii.gz'))

"
