function [X,Y,Z] = mbaBuildFascicleFrame(fibers,varargin)
%
%	function [X,Y,Z] = mbaBuildFascicleFrame(fibers,varargin)
%
% INPUTS:
%     fibers         - A fiber group.
%
% OUTPUTS:
%     X, Y and X - Coordinates of the frames (tubular) representing the fibers at each node.
%
%	USAGE:
%      mbaDisplayConnectome(fg,figure);
%
% Copyright 2014-2015 Franco Pestilli, Stanford University.

tic
fprintf('[%s] Building fascicle frames... ',mfilename);

% Choose the resolution at which the fiber section s samples
% Low when many fibers are passed in, high otherwise.
if notDefined('numSurfaceFaces'), numSurfaceFaces = 6; end
if notDefined('fiberRadius'),fiberRadius = .35;end
if notDefined('minNodesNum'), minNodesNum = 3; end

% This is the number of edges eac surface has
surfaceCorners = numSurfaceFaces + 1;

% Reorganize the fibers.
if (size(fibers{1},1) == 3) 
   fibers =  cellfun(@transpose,fibers,'UniformOutput',0);
end
numFibers = length(fibers);
X = cell(numFibers,1);
Y = X; Z = X;  segs = X;
numNodes = zeros(numFibers,1);

% We remove the first and last nodes from each fiber and colelct the number
% of nodes per fiber:
parfor i_fiber = 1:numFibers
 
  % Get the number of nodes, it is made of,
  % the number of segments the nodes define,
  % the length of each segment
  numNodes(i_fiber) = size(fibers{i_fiber},1);
  segs{i_fiber}     = fibers{i_fiber}(2: numNodes(i_fiber),:) - fibers{i_fiber}(1: numNodes(i_fiber)-1,:);  
end

% Find the fibers that have more that a min number fo nodes
% We will plot only those
showme  = find(numNodes >= minNodesNum);

%t = cell(length(showme));n=t;b=t;
parfor i_fiber = 1:length(showme)
    % Make a variable fiber radius:
    fr = fiberRadius + (fiberRadius/8) .* randn(size(fibers{showme(i_fiber)}));
    
    % Calculate the frame for tube representing the fiber.
    [t,n,b] = mbaBuild3Dframe(fibers{showme(i_fiber)});
    
    % Build x,y,z coordinates for each node in the fibers and the
    % angle between them.
    [X{i_fiber},Y{i_fiber},Z{i_fiber}] =                   ...
        mbaBuildSurfaceFromFrame(fibers{showme(i_fiber)},     ...
        fr, ...
        numNodes(showme(i_fiber)),   ...
        surfaceCorners,              ...
        segs{showme(i_fiber)},       ...
        t,n,b);
end
clear t n b

return
