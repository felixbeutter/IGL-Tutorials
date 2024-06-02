import os
import sys
import ants

input_dir = sys.argv[1]

for entry in os.listdir(input_dir):
    entry_path = os.path.join(input_dir, entry)

    if os.path.isdir(entry_path):
        mpm_dir = os.path.join(entry_path, '6_mpm', 'results', 'mpm')
        output_dir = os.path.join(mpm_dir, 'antsreg_output')
        os.makedirs(output_dir, exist_ok=True)

        r1 = ants.image_read(os.path.join(mpm_dir, 'R1.nii'))
        r2s = ants.image_read(os.path.join(mpm_dir, 'R2s.nii'))
        pd = ants.image_read(os.path.join(mpm_dir, 'PD.nii'))
        mtsat = ants.image_read(os.path.join(mpm_dir, 'MTsat.nii'))
        b0 = ants.image_read(os.path.join(entry_path, '2_nifti', 'b0.nii.gz'))

        transform_list = ants.registration(fixed=b0, moving=r1, type_of_transform='Affine')
        transformed_r1 = ants.apply_transforms(fixed=b0, moving=r1, transformlist=transform_list['fwdtransforms'])
        transformed_r2s = ants.apply_transforms(fixed=b0, moving=r2s, transformlist=transform_list['fwdtransforms'])
        transformed_pd = ants.apply_transforms(fixed=b0, moving=pd, transformlist=transform_list['fwdtransforms'])
        transformed_mtsat = ants.apply_transforms(fixed=b0, moving=mtsat, transformlist=transform_list['fwdtransforms'])

        ants.image_write(transformed_r1, os.path.join(output_dir, 'R1_to_dwi.nii.gz'))
        ants.image_write(transformed_r2s, os.path.join(output_dir, 'R2s_to_dwi.nii.gz'))
        ants.image_write(transformed_pd, os.path.join(output_dir, 'PD_to_dwi.nii.gz'))
        ants.image_write(transformed_mtsat, os.path.join(output_dir, 'MTsat_to_dwi.nii.gz'))
