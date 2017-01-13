function [outmat, valRange] = mbaNormalize(inmat, lohi)
% function [outmat, valRange]  = mbaNormalize(inmat, lohi)
%
% Normalises the matrix in inmat to between lo (for example 0)
% and hi (for example 1).
%
% Writtn by Franco Pestilli (c) Vistasoft Stanford University 2013
%
% Inspired by normalize.m by RAS

if notDefined('lohi'), lohi = [0,1];end

% Get the min value
minval = min(inmat(:));

% subtract the min: will run from 0 - maxval
inmat = inmat - minval;

% Get the new max value
maxval = max(inmat(:));

% Get the range of values in the original image
valRange = [minval, maxval];

% need a non-zero denominator below
if (valRange(2)==0), valRange(2) = eps;end

% now make it range from 0 to (hi - lo)
inmat = inmat * (lohi(2) - lohi(1)) / valRange(2);

% add offset (=lo), so now it ranges from lo -> hi
outmat = inmat + lohi(1);

end
