function [img_rgb, x, y, z, plane, clip, img]  = mbaMakeImageFromNiftiSlice(nifti, slice,cmap,clip)
%
% Generate an RGB image of a slice in a nifti file.
%
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
%   clip   - is a strucure containing two fields:
%            clip.min: the minimum proportion of pixels vlues that we will 
%                      keep in the image (e.g., 0.01). 
%            clip.max: the max proportion of pixel values that we will keep
%                      in the image (e.g., 0.99).
%   cmap   - Define a colormap for the values in the img.  The defualt is
%           cmap = 'gray'; Other options: cmap = 'jet'; cmap = 'hot'; etc.
%
% OUTPUTS:
%    img   - The slice of data extracted from the nifti.data field.
%    x,y,z - Contain the min and max index of the slice in ACPC coordinates
%    clip  - See INPUTS. Plus normalization option (alwasy true) for the
%            image.
%
% Written by Franco Pestilli (c) Vistasoft, Stanford University 2013

if notDefined('cmap'), cmap = gray(128);end
if notDefined('clip'),
    clip.min = 0.25;
    clip.max = 0.95;
end

% Get the slice requested from the nifti and resize it to 1mm isotropic.
[img, x, y, z, plane] = mbaGetResizedSliceImage(nifti,slice);

% Clip the img values so that the lowest 5% and the top 5% are eliminated.
% Rescale the rage of pixel values for the image between 0 and 255, to
% display properly with a colormap.

clip.normalize = 1;
img  = uint8(mbaImageHistogramClip(img,clip,clip.normalize).* size(cmap,1));

% Convert the scalar img to an RGB img based on the chosen colormap
img_rgb = ind2rgb(img,cmap);
img = double(img);

end
