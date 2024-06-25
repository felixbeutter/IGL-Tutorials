import os, sys, ants
 
 
input_dir = sys.argv[1]

modalities=['MTsat','PD','R1','R2s']

for mod in modalities:
    print(mod)
    for entry_path in os.listdir(input_dir):
        print(entry_path)
        if os.path.isdir(entry_path) and entry_path.startswith('SPP'):
            if os.path.isfile(entry_path + '/2_nifti/b0.nii.gz') and os.path.isfile(entry_path + '/6_mpm/results/mpm/'+mod+'.nii'):

# load MPM images and lesion mask
                mpm = ants.image_read(entry_path + '/6_mpm/results/mpm/'+mod+'.nii')
                b0 = ants.image_read(entry_path + '/2_nifti/b0.nii.gz')
                lesion = ants.image_read(entry_path + '/2_nifti/lesion.nii.gz')

# specify and/or create output directory
                output_dir=entry_path+'/7_cor'
                os.makedirs(output_dir, exist_ok=True) 

# perform Affine registration guided by lesion mask
                transform_list = ants.registration(fixed=b0, moving=mpm, type_of_transform='Affine', masks=(None, lesion))
                transformed_mpm = ants.apply_transforms(fixed=b0, moving=mpm, transformlist=transform_list['fwdtransforms']) 

 # save results as nifti files
                ants.image_write(transformed_mpm, output_dir + '/'+mod+'_to_dwi.nii.gz')