function [img, x, y, z, plane] = mbaGetSliceFromNifti(nifti,slice)
%
%  Extract a slice from a nifti file. Nifti and slice should be oriented 
%  within the same reference system, generally ACPCP. 
% 
%  [img, x, y, z, plane] = mbaGetSliceFromNifti(nifti,slice)
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
% Written by Franco Pestilli (c) Vistasoft Stanford University 

disp('mbaGetSliceFromNifti -- this function is obsolete . . . ')
return

% Check the consistency of the slce and return the plane identified by the
% slice.
[slice, plane] = mbaCheckSlice(slice);

% Format the img with proper transforms etc.
[imIndx, fourDindx, xform] = mbaXformAcpcSlice2ImageIndices(nifti,slice);

% Pull the desired slice out of the 3d img volume
if find(plane) == 1
    img = squeeze(nifti.data(imIndx,:,:,fourDindx));
    [ydim,zdim] = size(img);
        
    % Define the minimum and maximum coordinates of the img in each
    % dimension in acpc mm space.
    x.min = slice(1); 
    x.max = x.min;

    max_corner = (xform) \ [imIndx ydim zdim 1]';
    y.max = max_corner(2);
    z.max = max_corner(3);
    
    min_corner = (xform) \ [imIndx 0 0 1]';
    y.min = min_corner(2); 
    z.min = min_corner(3);
    
elseif find(plane) == 2
    img = squeeze(nifti.data(:,imIndx,:,fourDindx));
    [xdim,zdim] = size(img);

    % Define the minimum and maximum coordinates of the img in each
    % dimension in acpc mm space.
    y.min = slice(2);
    y.max = y.min;
    
    max_corner = (xform) \ [xdim imIndx zdim 1]';
    x.max = max_corner(1); 
    z.max = max_corner(3);
    
    min_corner = (xform) \ [0 imIndx 0 1]';
    x.min = min_corner(1); 
    z.min = min_corner(3);
else
    img = squeeze(nifti.data(:,:,imIndx,fourDindx));
    [xdim,ydim] = size(img);
    
    % Define the minimum and maximum coordinates of the img in each
    % dimension in acpc mm space.
    z.min = slice(3); 
    z.max = z.min;

    max_corner = (xform) \ [xdim ydim imIndx 1]';
    x.max = max_corner(1); 
    y.max = max_corner(2);
    
    min_corner = (xform) \ [0 0 imIndx 1]';
    x.min = min_corner(1); 
    y.min = min_corner(2);
end

end
