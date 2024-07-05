import os, sys, ants
 
 
input_dir = sys.argv[1]

modalities=['MTsat','PD','R1','R2s']

for mod in modalities:
    print(mod)
    for entry_path in os.listdir(input_dir):
        print(entry_path)
        if os.path.isdir(entry_path) and entry_path.startswith('SPP'):
            if os.path.isfile(entry_path + '/2_nifti/b0.nii.gz') and os.path.isfile(entry_path + '/6_mpm/results/mpm/'+mod+'.nii'):
                t1 = ants.image_read(entry_path + '/6_mpm/results/mpm/'+mod+'.nii')
                b0 = ants.image_read(entry_path + '/2_nifti/b0.nii.gz')
                output_dir=entry_path+'/7_cor'
                os.makedirs(output_dir, exist_ok=True) 
                transform_list = ants.registration(fixed=b0, moving=t1, type_of_transform='Affine')
                transformed_t1 = ants.apply_transforms(fixed=b0, moving=t1, transformlist=transform_list['fwdtransforms']) 
                ants.image_write(transformed_t1, output_dir + '/'+mod+'_to_dwi.nii.gz')
