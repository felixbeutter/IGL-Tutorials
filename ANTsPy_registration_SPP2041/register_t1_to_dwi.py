import os, sys, ants
 
 
input_dir = sys.argv[0]
output_dir = sys.argv[1]
 
for entry in os.listdir(input_dir):
    entry_path = os.path.join(input_dir, entry)
 
    if os.path.isdir(entry_path):
 
        t1 = ants.image_read(entry_path + '/2_nifti/t1.nii.gz')
        b0 = ants.image_read(entry_path + '/2_nifti/b0.nii.gz')
 
        os.makedirs(output_dir, exist_ok=True)
 
        transform_list = ants.registration(fixed=b0, moving=t1, type_of_transform='Affine')
        transformed_t1 = ants.apply_transforms(fixed=b0, moving=t1, transformlist=transform_list['fwdtransforms'])
 
        ants.image_write(transformed_t1, output_dir + '/t1_to_dwi.nii.gz')