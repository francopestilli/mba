function [fg,coordsDistribution] = mbaRemoveFibersCoordsDistributionOutlier(fg,numberOfNodes,M,maxSD)
% 
% Remove fibers from a fiber group whose x,y,z position differs more than a certain
% standard deviation from the core of the fiber group.
% 
% A fiber group is here conceptualized as a white-matter tract. A spatially defined and compact
% fascicle that can be conveniently represented as a 3D gaussian in space.
%
% % INPUTS:
%        fg           - fiber group structure
%        numberofNodes- sample the fiber group into this many points
%        M            - represent central tendency with 'mean' or 'median'
% OUTOPUTS:
%       fg                  -  The fibe group s returned with outliers removed
%       coordsDistribution  -  numberOfNodes by numberOfFibers array of weights
%                              denoting, the mahalanobis distance of each node in 
%                              each fiber from the fiber tract core(Super fiber)
% 
% See also 
%     mbaComputeFibersCoordsDistribution.m
%     mbaComputeFiberLengthDistribution.m
%     mbaRemoveFiberLengthOutliers.m 
%
%  EXAMPLE:
% 
%  Copyright Franco Pestilli (c) Stanford University 2013.


% Generate a distribution of x,y,z coordinates for each fiber at a
% resolution of 200 nodes per fiber
if notDefined('numberOfNodes'), numberOfNodes=100; end
if notDefined('M'), M = 'mean'; end
if notDefined('MaxSD'), maxSD = 2; end

% Trasform the fibers into a 3D gaussian of x,y,x coordinates.
% CoordsDistribution contains the zscore (standard deviation) of each
% node of a fiber as it compares to the eman of the fiber group. Fibers
% with large z-scores are away from the core of the fiber group.
[~, coordsDistribution] = mbaComputeFibersCoordsDistribution(fg, numberOfNodes, M);

% Check wich fibers are within a certain standard deviation from the mean
% of the distribution.
keepFibers = coordsDistribution < maxSD;

% Find the fibers that where within the maxSD for the whole length of their
% path. We keep fibers that never go too far away from the core of the
% fiber group (the fiber group being a white-matter) tract.
keepMe = sum(keepFibers) == numberOfNodes;

% Extract the fibers that are within the criteria. Fibers with nodes x,y,z 
% outside maxSD will will be elimiated.
fg = fgExtract(fg,keepMe,'keep');

end

