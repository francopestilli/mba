function roi = mbaRoiPlot(roi,type,varargin)
% Plot a Region of Interest (ROI).
%
%   fe = mbaRoiPlot(roi,type)
%
% Copyright (2013-2014), Franco Pestilli, Stanford University, pestillifranco@gmail.com.
if mbaNotDefined('roi'),
    mbaError('roi structure necessary. See mbaRoiCreate.m')
    return
end
if isempty(varargin)
    fh = mbaFigure(mfilename);
else
    fh = figure(varargin{1});
end

switch type
    case {'cloud'}
        plot3(roi.coords(:,1),roi.coords(:,2),roi.coords(:,3),'ro','markerfacecolor','r');
        
    otherwise
        warning('[%s] Cannot find ',mafilename)
end

end
