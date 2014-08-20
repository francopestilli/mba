function roi = mbaRoiSet(roi,rfield,val)
% Set Region of Interest (ROI) parameters.
%
%   fe = mbaRoiSet(roi,rfield,val,varargin)
%
%
% Copyright (2013-2014), Franco Pestilli, Stanford University, pestillifranco@gmail.com.

% Check for input parameters
if mbaNotDefined('roi'),    error('[%s] roi structure required.',mfilename); end
if mbaNotDefined('rfield'), error('[%s] Parameter to set required',mfilename); end
if mbaNotDefined('val'),    error('[%s] Value to set required',mfilename); end
if ~iscell(rfield), rfield = {rfields};end
if ~iscell(val),       val = {val};end

if length(rfield)==length(val)
    for i = 1:length(rfield)
        roi.(rfield{i}) = val{1};
    end
else
    error('[%s] Please pass one value per parameter.',mfilename);
end

end
