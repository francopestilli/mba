function [fg, keep] = mbaComputeFibersOutliers(fg,maxDist,maxLenStd,numNodes,centralTendency,count,maxIter)
%
% Remove fibers from a fiber group that differ substantially from the
% mean fiber in the group.
%
%    [fg keep]=mbaComputeFibersOutliers(fibers,maxDist,maxLenStd,numNodes, ...
%                                       [centralTendency = 'mean'],[count = 0],[maxIter = 5])
%
% INPUTS:
% fg       = input fiber group structure to be cleaned
% maxDist  = the maximum gaussian distance a fiber can be from the core of
%            the tract and be retained in the fiber group
% maxLenStd   = The maximum length of a fiber (in stadard deviations from the
%            mean length)
% numNodes = Each fiber will be resampled to have numNodes points
% centralTendency        = median or mean to represent the center of the tract
% count    = whether or not to print pruning results to screen
% maxIter  = The maximum number of iterations for the algorithm
% show     = whether or not to show which fibers are being removed in each
%            iteration. If show == 1 then the the fibers that are being 
%            kept and removed will be rendered in 3-D and the user will be 
%            prompted to decide whether continue with the cleaning
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

% whether to compute fiber core with mean or median
if notDefined('centralTendency'), centralTendency='mean';end

% display the number of fibers that were removed in each iteration
if notDefined('count'), count = 0;end

% maximum number of iterations
if notDefined('maxIter'),maxIter = 3;end

% initialize a vector defining the fibers to keep
keep      = ones(length(fg.fibers),1);
keep_prev = keep;
idx0      = find(keep);

% compute the amount of outliers expected given a normal distribution
if exist('normpdf','file')
    maxoutDist  = normpdf(maxDist);   % Requires statistics toolbox
    maxoutLen  = normpdf(maxLenStd);
else
end

% Create a variable to save the origional fiber group before starting to
% clean it
fg_orig = fg;

% Continue cleaning fibers until there are no outliers
iter=0; cont=1;
while cont ==1 && iter<=maxIter
    % display the number of fibers in the fiber group
    if count==1
        fprintf('\n%s number of fibers: %.0f ',fg.name,length(fg.fibers))
    end
    % keep track of the number of iterations
    iter = iter+1;
    
    % Remove fibers that are too shoort or long from the distribution of
    % fibers. We do this by transfroming the fibers length into a gaussian
    % distribution.
    Lnorm     = mbaComputeFiberLengthDistribution(fg);
    keep1     = abs(Lnorm) < maxLenStd;
    idx1      = find(keep1);
    fg.fibers = fg.fibers(keep1);
    
    % Represent each node as a 3d gaussian where the covariance matrix is the
    % gaussian distance of each fibers node from the mean fiber
    if length(fg.fibers) > 20
        
        % Transform the fiber group coordinates in a a gaussian distribution
%        [~, weights] = mbaComputeFibersCoordsDistribution(fg, numNodes, centralTendency);
        [SuperFiber, weights] = AFQ_FiberTractGaussian(fg, numNodes, 'mean');

        % Check if any fibers are farther than maxDist from any node.
        keep2 = weights < maxDist;
        keep2 = sum(keep2) == numNodes;
        %idx2  = find(keep2);
        
        % If there are more fibers that are farther than max dist then would be
        % expected in a gaussian distribution then continue iterating
        cont = sum(~keep2) > length(fg.fibers)*maxoutDist;
        
        % Remove fibers that are more than maxDist from any node
        fg.fibers = fg.fibers(keep2);
        
        % Keep track of which fibers in the orgional fiber group are being
        % removed
        keep1(idx1) = keep2;
        keep(idx0)  = keep1;
        idx0        = find(keep);
    else
        % If there are more fibers that are farther than max length then would be
        % expected in a gaussian distribution then continue iterating
        cont = sum(~keep1) > length(fg.fibers)*maxoutLen;
    end
   
    % Save the keep variable from the current iteration before updating it
    % in the next iteration
    keep_prev = keep;
end
keep = logical(keep);

return