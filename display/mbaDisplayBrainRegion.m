function [h, lightHandle] = mbaDisplayBrainRegion(roi, color)
% Render an ROI as a 3D surface
%
% h = mbaDisplayBrainRegion(roi, color , [type = 'trimesh'], [render = 'surface'])
%
% Inputs:
%
% roi    = Roi structure or an Nx3 matrix of X,Y,Z coordinates
% color  = The color to render the roi. Default is red: color = [1 0 0]
% metnod = There are many ways to build a surface mesh from coordinates.
%          type = 'isosurface' converts the coordinates to an image than
%          uses isosurface to build a mesh. type = 'trimesh' builds a
%          triangle mesh out of the coordinates and redners that as a
%          surface mesh.
% render = What to render. Either the roi surface: render = 'surface' or a
% wire frame: render = 'wire' 
%
% Copyright (2014) Franco Pestilli, Stanford University,
% pestillifranco@gmail.com

if mbaNotDefined('color'), color = [1 0 0];       end
coords  = mbaRoiGet(roi,'coords');

% Compute the range of the coordinates in the roi
roi_min = min(coords);
roi_max = max(coords);

% Create a binary image from the ROI
im = mbaCoordsToImage(coords);
[X,Y,Z,V] = reducevolume(im,[ 1 1 1 ]);
m = isosurface(X,Y,Z,V);
h = patch(m,'FaceColor',color,'EdgeColor','none');

keyboard
h = isonormals(im,h);
view(3); axis tight; daspect([1,1,1])
% Add a light
lightHandle = camlight('right');

end
