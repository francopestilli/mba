function p = mbaDisplayParams()
%
%	function [figureHandle, lightHandle, sHandle] = mbaDisplayFascicles(fibers,mbaDisplayParams)
%
% INPUTS:
%     fibers            - A fiber group.
%     'figureHandle'    - figure handle. Optional.
%     'p.color'         - A Nx3 matrix containing the colours in which the
%                         different bundles will be displayed.
% 	  'p.colorType'     - 'map' or 'single'. Optional.
% 	  'p.colorMap'      - A matlab colormap (e.g., 'hsv')
% 	  'p.radius'        - The thicknes of each fiber.
%     'p.nSurfaceFaces' - The number of divisions around the diameter of
%                         the fiber. Default = 10.
%
% OUTPUTS:
%     fig.h - Handle to the figure with the Connectome.
% 	  fig.l - Handle to the current ligth used on the connectome.
%     fig.s - Handle to the surfaces of the fibers
%
%	USAGE:
%      mbaDisplayFascicles(fg,p);
%
% Copyright (2013-2014) Franco Pestilli Stanford University.

% Set the alpha for the surfaces.
if notDefined('p.faceAlpha'),     p.faceAlpha = 1;end
if notDefined('p.nSurfaceFaces'), p.nSurfaceFaces = 100; end
if notDefined('p.color'),  
    p.color = [.84,.83,.99];
    p.colorType = 'single';
end
if notDefined('p.colorMap'), p.colorMap = 'hot';end
if notDefined('p.radius'),p.radius = .35;end
if notDefined('p.nNodesMin'), p.nNodesMin = 3; end

% Format figure.
p.fig.name     = 'mba';
p.fig.h        = figure('name',p.fig.name); 
p.fig.units    = 'normalized';
p.fig.position = [.2 .1 .2 .2];
p.fig.color    = [0,0,0];

% Format axis
p.fig.axis.h = gca;
p.fig.axis.color = [0,0,0];
p.fig.axis.box = 'off';
p.fig.axis.hold = 'on';
p.fig.axis.aspectratio = [1,1,1];

% Format labels
p.fig.label.color   = [1,1,1];
p.fig.label.xh      = get(p.fig.axis.h,'xlabel');
p.fig.label.xstring = 'Left/Right';
p.fig.label.yh      = get(gca,'ylabel');
p.fig.label.ystring = 'Top/Bottom';
p.fig.label.zh      = get(gca,'zlabel');
p.fig.label.zstring = 'Anterior/Posterior';

% Format camera and tools
p.fig.camera.visibility = 'Show';
p.fig.camera.mode       = 'orbit';

% Format light
p.fig.light.type = 'phong';

end