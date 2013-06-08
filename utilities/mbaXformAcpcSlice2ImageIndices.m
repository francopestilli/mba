function [imIndx, fourDindx, xform] = mbaXformAcpcSlice2ImageIndices(nifti,slice)
%
% Finds the image indices in the data field of a nifti structure 
% for a brain slice. Both the nifti qto_ijk and the slice must be within 
% the same coorinate frame (generally ACPC).
%
%    [imIndx, fourDindx, xform] = mbaXformAcpcSlice2ImageIndices(nifti,slice)
%
% INPUTS:
%   nifti - is a 3D or 4D ACPC aligned nifti structure
%   slice - Identifies the ACPC coordinates (in millimeter) 
%           of the brain slice and the index of the data (4th dimension 
%           of a volume). Slice is either:
%              - a 1x3 [X,Y,Z] vecotor of ACPC coordinates (Coronal,
%                Sagittal, Axial), OR
%              - a 1x4 [X,Y,Z,d] vector of ACPC coordinates (Coronal,
%                Sagittal, Axial) plus the index into the data dimension, d
%                in data indices. 
%           All entries must be all 0 except the coordinate of the
%           slice to be rendered an the 4th dimension (if passed in). 
%           (see also mbaCheckSlice.m)
%
% OUTPUTS:
%   imIdx     - is the set of x,y,z indices in the data field of the input
%               nifti structure that correspond to the ACPC location in slice.
%   fourDindx - if the input slice contains a the index into the 4th
%               dimesion fo the input nifti image the index is returned as 
%               fourDindx.
%
% Written by Franco Pestilli (c) Vistasoft Stanford University 2013

% The variable slice is given in acpc coordinates.  
% We transform from acpc to image coordinates.
xform    = nifti.qto_ijk;
ImCoords = floor(xform * [slice(1:3) 1]');
imIndx   = ImCoords(slice(1:3)~=0);

% If the index for the 4th dimension is provided in slice we return the
% index in a separate variable.
if length(slice) == 4, fourDindx = slice(4);
else                   fourDindx = 1;    end

end