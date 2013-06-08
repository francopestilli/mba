function [slice, plane] = mbaCheckSlice(slice)
%
% Check the consistency of a slice passed in for visualization and computes 
% the plane identified by the slice.
%
% INPUTS:
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
% EXAMPLE
%  - Coronal  slice 10mm from the AC:                   slice = [10 0 0]. 
%  - Axial    slice 10mm below the axial ACPC plane:    slice = [0 0 -10]. 
%  - Sagittal slice 10mm right the sagittal ACPC plane: slice = [0 10 0]
%  - Coronal slice 20mm from AC with first data value: slice = [20 0 0 1]
%
% See also: mbaDisplayBrainSlice.m, mbaDisplayOverlay.m 
%
% Written by Franco Pestilli (c) Vistasoft Stanford University 2013

% A plane identifies all the dimensions in the 3D volume that are used from
% the slice.
plane = ~isnan(slice(1:3));
if (sum(plane) > 1), plane = slice(1:3) ~= 0;end
if (sum(plane) > 1), 
    sprintf('[%s] Only one slice can be plotted. Other values should be nan or 0', mfilename)
end

% Replace nans with zeros
slice(1:3) = slice(1:3) .* plane;

% Make sure slice is a row vector
if size(slice,1) ~= 1
    slice = slice';
end

end
