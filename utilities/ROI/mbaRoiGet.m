function val = mbaRoiGet(roi,rfield)
% Get properties of a region of interest (ROI).
%
%  val = mbaRoiGet(roi,,parameter)
%
% Copyright (2014) Franco Pestilli Stanford University, pestillifranco@gmail.com 

if mbaNotDefined('roi'),
    mbaError('roi structure necessary. See mbaRoiCreate.m')
    return
end

switch rfield
    case {'name'}
        val = roi.name;
    case {'color'}
        val = roi.color;
    case {'visible'}
        val = roi.visible;
    case {'coords'}
        val = roi.coords;
    case {'mesh'}
        val = roi.mesh;
    case {'dirty'}
        val = roi.dirty;
    case {'query_id'}
        val = roi.query_id;
    case {'type'}
        val = roi.type;
        
    otherwise
        mbaError(sprintf('Cannot find %s',rfield))
end

% roi.name     = '';
% roi.color    = [];
% roi.coords   = [];
% roi.visible  = 1;
% roi.mesh     = [];
% roi.dirty    = 1;
% roi.query_id = -1;
% roi.type     = [];