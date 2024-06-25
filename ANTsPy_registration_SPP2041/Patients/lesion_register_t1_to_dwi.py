import os, sys, ants, antspynet
 
 
input_dir = sys.argv[1]
 
for entry_path in os.listdir(input_dir):
    print(entry_path)
    if os.path.isdir(entry_path) and entry_path.startswith('SPP'):

#   load t1, b0 image and lesion mask    
        t1 = ants.image_read(entry_path + '/2_nifti/t1.nii.gz')
        b0 = ants.image_read(entry_path + '/2_nifti/b0.nii.gz')
        lesion = ants.image_read(entry_path + '/2_nifti/lesion.nii.gz')

#  specify and/or create output directory
        output_dir=entry_path+'/7_cor'
        os.makedirs(output_dir, exist_ok=True)

# brain extraction
#        t1_brain_mask = antspynet.brain_extraction(t1, modality='t1')
#        t1_brain = t1 * t1_brain_mask
#        ants.image_write(t1_brain, output_dir + 't1_brain.nii.gz')
 
 # perform Affine registration guided by lesion mask
        transform_list = ants.registration(fixed=b0, moving=t1, type_of_transform='Affine', masks=(None, lesion))
        transformed_t1 = ants.apply_transforms(fixed=b0, moving=t1, transformlist=transform_list['fwdtransforms'])
        transformed_lesion = ants.apply_transforms(fixed=b0, moving=lesion, transformlist=transform_list['fwdtransforms'])
 
 # save registered t1 image as nifti file
        ants.image_write(transformed_t1, output_dir + '/t1_to_dwi.nii.gz')
#        ants.image_write(transformed_lesion, output_dir + '/lesion_to_dwi.nii.gz')