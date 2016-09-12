function [fg, keep] = mbaRemoveFiberLengthOutliers(fg,maxLenStd,fiberType,dispDistribution)
%
% Remove fibers from a fiber group whose length differs more than a certain
% standard deviation from the distribution of lengths in the initial fiber
% groups.
%
%    [fg keep]=mbaComputeFibersOutliers(fibers, maxLenStd,dispDistribution)
%
% INPUTS:
% fg        - input fiber group structure to be cleaned
% maxLenStd - The maximum length of a fiber (in stadard deviations from the
%             mean length)
% fiberType - 1. 'long'  remove the long fibers
%             2. 'short' remove the short fibers
%             3. 'both'  remove short and long fibers
% dispDistribution - displays the distribution of fibers deleted on top of the original. 
%
% OUTPUT:
% fibers   = Fibers with outliers removed
% keep     = A 1xN vector where n is the number of fibers in the origional
%            fiber group.  Each entry in keep denotes whether that fiber
%            was kept (1) or removed (0).
%
%  EXAMPLE:
%
% Written by Franco Pestilli (c) Stanford University 2013

if notDefined('dispDistribution'), dispDistribution=0;end
if notDefined('fiberType'), fiberType='both';end

% initialize a vector defining the fibers to keep
keep      = false(length(fg.fibers),1);

% Remove fibers that are too shoort or long from the distribution of
% fibers. We do this by transfroming the fibers length into a gaussian
% distribution.
[Lnorm, Lmm] = mbaComputeFiberLengthDistribution(fg);

% Choose what kind of fibers we want to remove.
switch fiberType
    case {'long'}
        % Remove long fibers
        keep         = Lnorm < maxLenStd;
    case {'short'}
        % Remove short fibers
        keep         = Lnorm > -maxLenStd;
    case {'both', 'shortandlong'}
        % Remove fieber that are too long or too short
        keep = abs(Lnorm) < maxLenStd;
    otherwise
        erro('[%s] Could not recoginze the type of fibers to remove',mfilename)
end

% Remove the fibers.
fg    = fgExtract(fg,keep,'keep');

% Dispaly the distribution of fibers.
if dispDistribution
    mM = minmax(Lmm);
    [y,x]= hist(Lmm(keep),linspace(mM(1),mM(2),100));
    bar(x,y,'FaceColor','b','EdgeColor','b')
    hold on;
    y= hist(Lmm(~keep),x);
    bar(x,y,'FaceColor','r','EdgeColor','r')
    ylabel('Mumber of fibers')
    xlabel('Fiber length in mm')
end

return