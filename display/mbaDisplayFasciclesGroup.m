function [fig,ph,roth] = mbaDisplayFasciclesGroup(fibers,fig)
color = .1;

tic
fprintf('[%s] Building fascicle group... ',mfilename);

% Choose the resolution at which the fiber section s samples
% Low when many fibers are passed in, high otherwise.
if notDefined('numSurfaceFaces'), numSurfaceFaces = 16; end
if notDefined('fiberRadius'),fiberRadius = .35;end
if notDefined('minNodesNum'), minNodesNum = 3; end

% This is the number of edges eac surface has
surfaceCorners = numSurfaceFaces + 1;

% Reorganize the fibers.
if (size(fibers{1},1) == 3) 
   fibers =  cellfun(@transpose,fibers,'UniformOutput',0);
end
numFibers = length(fibers);

% Build a patch from the frame
vertices = [];
faces    = [];
indices  = [];
colordata = [];
nTotalVertices = 0;

% We remove the first and last nodes from each fiber and colelct the number
% of nodes per fiber:
for i_fiber = 1:numFibers
    % Get the number of nodes, it is made of,
    % the number of segments the nodes define,
    % the length of each segment
    numNodes = size(fibers{i_fiber},1);
    segs     = fibers{i_fiber}(2: numNodes,:) - fibers{i_fiber}(1: numNodes-1,:);
    
    % Make a variable fiber radius:
    fr = fiberRadius + (fiberRadius/8) .* randn(size(fibers{i_fiber}));
    
    % Calculate the frame for tube representing the fiber.
    [t,n,b] = mbaBuild3Dframe(fibers{i_fiber});
    
    % Build x,y,z coordinates for each node in the fibers and the
    % angle between them.
    [X,Y,Z] = mbaBuildSurfaceFromFrame(fibers{i_fiber}, ...
        fr,             ...
        numNodes,       ...
        surfaceCorners, ...
        segs,           ...
        t,n,b);
    
    fasciclePatch = surf2patch(X,Y,Z,'triangles');
    nVertices = size(fasciclePatch.vertices,1);
    
    % these are the display vertices which are the same as the coords
    vertices = [vertices ; fasciclePatch.vertices];
    faces = [faces ; (fasciclePatch.faces + nTotalVertices)];
    colordata = [colordata; color*ones(nVertices,1)];

    % update nTotalVertices
    nTotalVertices = nTotalVertices + nVertices;
end
clear X Y Z

fascicles.vertices = vertices;
fascicles.faces    = faces;
fascicles.indices  = indices;

set(fig,'Renderer','OpenGL')
ph = patch('vertices', fascicles.vertices, 'faces', fascicles.faces, ...
    'FaceVertexCData', squeeze(colordata), ...
     'facecolor','interp','edgecolor','interp','EdgeLighting','gouraud');
roth = rotate3d(fig,'on');
toc

end
                
