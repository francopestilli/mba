function p = mbaDisplaySet(p,parameter,value)
%
%	function [figureHandle, lightHandle, sHandle] = mbaDisplaySet(p,param, value)
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


% Format figure.
set(p.fig.h, 'Units','normalized', ...
    'Position', p.fig.position, ...
    'DoubleBuffer', 'on', ...
    'Color',p.fig.color);

% Format axis
set(p.fig.axis.h,'color',p.fig.axis.color)
box(p.fig.axis.box); % off or on;
hold(p.fig.axis.hold);
daspect(p.fig.axis.aspectratio);

% Format labels
p.fig.label.h = get(p.fig.axis.h,'xlabel');
set(p.fig.label.h, 'string', ...
    p.fig.label.xstring, 'color', ...
    p.fig.label.color);

p.fig.label.h = get(gca,'ylabel');
set(p.fig.label.h, 'string', ...
    p.fig.label.ystring, 'color', ...
    p.fig.label.color);

p.fig.label.h = get(gca,'zlabel');
set(p.fig.label.h, 'string', ...
    p.fig.label.zstring, 'color', ...
    p.fig.label.color);

% Format camera and tools
cameratoolbar(p.fig.camera.visibility); % 'Show'
cameratoolbar('SetMode',p.fig.axis.mode); % 'orbit'

% Format light
lighting(p.fig.light.type);

end % end function


