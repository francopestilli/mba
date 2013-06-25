function [img, x, y, z, plane] = mbaGetResizedSliceImage(nifti,slice)
%
%  Extract a slice from a nifti file and resizes it to 1mm isotropic. 
%  Nifti and slice should be oriented within the same reference system, 
%  generally ACPCP. 
% 
%  [img, x, y, z] = mbaGetResizedSliceImage(nifti,slice)
%
% INPUTS:
%    nifti - a nifti structure, see niftiCreate.m
%    slice  - Identifies the ACPC coordinates (in millimeter) 
%             of the brain slice and the index of the data (4th dimension 
%             of a volume). Slice is either:
%              - a 1x3 [X,Y,Z] vecotor of ACPC coordinates (Coronal,
%                Sagittal, Axial), OR
%              - a 1x4 [X,Y,Z,d] vector of ACPC coordinates (Coronal,
%                Sagittal, Axial) plus the index into the data dimension, d
%                in data indices. 
%             All entries must be all 0 except the coordinate of the
%             slice to be rendered an the 4th dimension (if passed in). 
%
% OUTPUTS:
%    img - The slice of data extracted from the nifti.data field.
%    x,y,z - contain the min and max index of the slice in ACPC coordinates
%
%
% Written by Franco Pestilli (c) Vistasoft, Stanford University 2013

%disp('mbaGetResizedSliceImage -- This function is OBSOLETE...')
%return

% Make sure only one plane was designated for plotting
[slice, plane] = mbaCheckSlice(slice);

% Get the requested slice out of the nifti
[img, x, y, z] = mbaGetSliceFromNifti(nifti,slice);

% Resample the img to 1mm resolution. The necessary scale factor is
% stored in the img xform.
scale = diag(nifti.qto_xyz); 
scale = scale(1:3);

% The new dimensions will be the old dimensions multiplied by the scale
% factors for the plane
oldDim = size(img);
newDim = oldDim .* scale(plane == 0)';

% Resize the img
img = double(imresize(img,newDim));

end