dcm2niix -o ./ -f dMRI_AP -z y ./assets/dMRI/dMRI_AP
dcm2niix -o ./ -f dMRI_PA -z y ./assets/dMRI/dMRI_PA

mrconvert dMRI_AP.nii.gz -json_import dMRI_AP.json -fslgrad dMRI_AP.bvec dMRI_AP.bval dMRI_AP.mif
mrconvert dMRI_PA.nii.gz -json_import dMRI_PA.json -fslgrad dMRI_PA.bvec dMRI_PA.bval dMRI_PA.mif

mrcat dMRI_AP.mif dMRI_PA.mif –axis 3 b0.mif
dwiextract b0.mif -bzero - | mrmath -axis 3 - mean b0.nii

rm dMRI_AP.nii.gz
rm dMRI_PA.nii.gz

rm dMRI_AP.json
rm dMRI_PA.json
rm dMRI_AP.bvec
rm dMRI_PA.bvec
rm dMRI_AP.bval
rm dMRI_PA.bval

rm dMRI_AP.mif
rm dMRI_PA.mif

rm b0.mif

gzip b0.nii
mv b0.nii.gz ./assets/b0.nii.gz