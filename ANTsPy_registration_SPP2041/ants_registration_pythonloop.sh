#!/bin/bash

# Loop through patient folders
for patient_folder in */; do
    patient=${patient_folder%%/}
    echo "Processing patient: $patient"

    # Create output directory within 6_mpm/results
    output_dir="$patient/6_mpm/results/ants_registration"
    mkdir -p "$output_dir"

    # Load images
    t1=$(ants.image_read "$patient/2_nifti/t1.nii.gz")
    b0=$(ants.image_read "$patient/2_nifti/b0.nii.gz")
    r1=$(ants.image_read "$patient/6_mpm/results/mpm/R1.nii")
    r2s=$(ants.image_read "$patient/6_mpm/results/mpm/R2s.nii")
    pd=$(ants.image_read "$patient/6_mpm/results/mpm/PD.nii")
    mtsat=$(ants.image_read "$patient/6_mpm/results/mpm/MTsat.nii")

    # Register T1 to b0
    transform_list_t1=$(ants.registration(fixed="$b0", moving="$t1", 
type_of_transform='Affine'))
    transformed_t1=$(ants.apply_transforms(fixed="$b0", moving="$t1", 
transformlist="$transform_list_t1"))
    ants.image_write(transformed_t1, "$output_dir/transformed_t1.nii.gz")

    # Register MPM to b0
    transform_list_mpm=$(ants.registration(fixed="$b0", moving="$r1", 
type_of_transform='Affine'))
    transformed_r1=$(ants.apply_transforms(fixed="$b0", moving="$r1", 
transformlist="$transform_list_mpm"))
    transformed_r2s=$(ants.apply_transforms(fixed="$b0", moving="$r2s", 
transformlist="$transform_list_mpm"))
    transformed_pd=$(ants.apply_transforms(fixed="$b0", moving="$pd", 
transformlist="$transform_list_mpm"))
    transformed_mtsat=$(ants.apply_transforms(fixed="$b0", 
moving="$mtsat", transformlist="$transform_list_mpm"))

    # Write transformed MPM images
    ants.image_write(transformed_r1, "$output_dir/R1_to_dwi.nii.gz")
    ants.image_write(transformed_r2s, "$output_dir/R2s_to_dwi.nii.gz")
    ants.image_write(transformed_pd, "$output_dir/PD_to_dwi.nii.gz")
    ants.image_write(transformed_mtsat, "$output_dir/MTsat_to_dwi.nii.gz")

    echo "Registration completed for patient: $patient"
done
