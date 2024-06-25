import os, sys, subprocess, ants, antspynet

def run_brain_extraction(input_file, output_file):
    """ Perform brain extraction on a T1-weighted MRI image. """
    t1 = ants.image_read(input_file)
    brain_extraction = antspynet.brain_extraction(t1, modality="t1", verbose=True)
    ants.image_write(brain_extraction, output_file)

def run_deep_atropos(input_file, output_file):
    """ Perform deep atropos segmentation on a T1-weighted MRI image. """
    t1 = ants.image_read(input_file)
    segmentation = antspynet.deep_atropos(t1, verbose=True)
    segmented_image = segmentation['segmentation_image']
    ants.image_write(segmented_image, output_file)

def main(base_path, subject_prefix, subject_numbers, subfolder):
    for subject in subject_numbers:
        input_file = f"{base_path}/patients/{subject_prefix}{subject}/{subfolder}/t1.nii.gz"
        output_brain_extraction = f"{base_path}/patients/{subject_prefix}{subject}/{subfolder}/ants_brain_extraction.nii.gz"
        output_deep_atropos = f"{base_path}/patients/{subject_prefix}{subject}/{subfolder}/deep_atropos.nii.gz"

        # Run brain extraction
        run_brain_extraction(input_file, output_brain_extraction)

        # Run deep atropos
        run_deep_atropos(input_file, output_deep_atropos)

        # Apply mask using FSL's fslmaths
        subprocess.run(["fslmaths", input_file, "-mas", output_brain_extraction, f"{base_path}/patients/{subject_prefix}{subject}/{subfolder}/t1_brain.nii.gz"])

        # Threshold and save deep atropos output using fslmaths
        subprocess.run(["fslmaths", output_deep_atropos, "-thr", "3", "-uthr", "3", f"{base_path}/patients/{subject_prefix}{subject}/{subfolder}/deep_atropos_wm.nii.gz"])

if __name__ == "__main__":
    base_path = '/media/nas/SPP2041/SPP/Patients'
    patient_numbers = ['21_1', '023_1', '39_1', '46_1', '72_1', '73_1', '74_1', '115_1', '217_1', '227_1', '251_1', '253_1', '274_1', '298_1', '369_1']
    subfolder = '2_nifti'
    main(base_path, 'SPP_P_', patient_numbers, subfolder)