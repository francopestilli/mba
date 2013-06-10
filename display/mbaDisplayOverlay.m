function sh = mbaDisplayOverlay(niAnatomy, niOverlay, slice, overlayThresh, cmap, oAlpha,sView)
%
% Add a brain slice from a nifti image to a 3D plot with an overlay from
% another nifti image. The two niftis MUST be aligned.
%
% sh = mbaDisplayOverlay(niAnatomy, niOverlay, slice, overlayThresh, cmap, oAlpha,sView)
%
% Inputs:
%
% niAnatomy- A 3D nifti image to use as base (anatomy) for the plot. 
% slice       - Identifies the ACPC coordinates (in millimeter) 
%               of the brain slice and the index of the data (4th dimension 
%               of a volume). Slice is either:
%                - a 1x3 [X,Y,Z] vecotor of ACPC coordinates (Coronal,
%                  Sagittal, Axial), OR
%                - a 1x4 [X,Y,Z,d] vector of ACPC coordinates (Coronal,
%                  Sagittal, Axial) plus the index into the data dimension, d
%                  in data indices. 
%                All entries must be all 0 except the coordinate of the
%                slice to be rendered an the 4th dimension (if passed in). 
% cmap         - Define a colormap for the values in the image.  The defualt is
%               cmap = 'gray'; Other options: cmap = 'jet'; cmap = 'hot'; etc.
% niOverlay - A 3D nifti image with data to overlay on top of the anatomy. 
% cmap         - Colormap for the overlay image.  The defualt is 'autumn'.
% rescale      - If the image is being added to an existing axis the default is
% alpha        - Alpha of the image. Value from 0 to 1 that sets how 
%                transparent the image is.
%
% OUTPUT:
% h            - Handle for the object in the figure.  You can remove the slice
%                from the figure window with: delete(h);
%
% Example:
%
%
% Written by Franco Pestilli (c) Vistasoft, Stanford University 2013

% Check arguments
if notDefined('slice')
   slice =  [ 0 0 40];
end
if notDefined('cmap')
    cmap = brighten(hot(2000),.1);
else
    cmap = eval(sprintf('%s(256)',cmap));
end
if notDefined('oAlpha'),    oAlpha = .85;  end
if notDefined('sView'), 
    sView = mbaGetSliceView(slice);
elseif isempty(sView)
    % We prserve the current view if the sView is passed empty
    sView = get(gca,'view');
end

% Overlay information
if notDefined('overlayThresh'),
    overlayThresh = minmax(niftiGet(niOverlay,'data'));
end

% Generate an RGB image contaning the brain slice and the overlay on top of
% it.
[awo,x,y,z] = mbaMakeOverlay(niAnatomy,niOverlay,slice,overlayThresh,oAlpha,cmap);

% Plot the slice with the overlay
sh = surf(x,y,z,awo,'facecolor','texture','edgeColor','none');

% Set the view and axis
view(sView)
axis('equal')
axis('tight')

end
