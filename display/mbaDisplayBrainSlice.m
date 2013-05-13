function h = mbaDisplayBrainSlice(nifti, slice, cmap, rescale,alpha)
% Add a slice from a nifti image to a 3D plot
%
% h = mbaDisplayBrainSlice(nifti, slice, [cmap], [rescale],alpha)
%
% Inputs:
%
% nifti   = A 3D nifti image. It is ok if the image has translation
%           information in the header, however there may be problems if
%           there are rotations saved into the header. Typically we do not
%           save rotations into the header so everything should be fine.
%
% slice   = Designate which slice in acpc (millimeter) coordinates should
%           be added to the plot. slice should be a 1x3 vector where each
%           coordinate is either a 0 or nan except the coordinate of the
%           slice to be rendered. For example to render the coronal slice 5
%           mm anterior to the anterior commissure: slice = [5 0 0]. For an
%           axial slice 10mm below the acpc plane: slice = [0 0 -10]. For a
%           sagittal slice 25mm to the left of the mid-sagittal plane:
%           slice = [-25 0 0]
%
% cmap    = Define a colormap for the values in the image.  The defualt is
%           cmap = 'gray'; Other options: cmap = 'jet'; cmap = 'hot'; etc.
%
% rescale = If the image is being added to an existing axis the default is
%           to rescale the axis so the full image can be seen 
%           [rescale = 1]. To preserve the current axis properties: 
%           rescale = 0
%
% Output:
%
% h       = Handle for the object in the figure.  You can remove the slice
%           from the figure window with: delete(h);
%
% Example:
%
% h = feDisplayBrainSlice(nifti, [-20 0 0 10])
%
% Franco (C) 2012 Stanford VISTA team.

% Check arguments
if ~exist('cmap','var') || isempty(cmap)
    cmap = gray(256);
end
if ~exist('rescale','var') || isempty(rescale), 
    rescale = 1;
end
if notDefined('alpha'), alpha=1;end

% Make sure only one plane was designated for plotting
plane = ~isnan(slice(1:3));
if sum(plane) > 1
    plane = slice(1:3) ~= 0;
end
if sum(plane) > 1
    error('Only one slice can be plotted. Other values should be nan or 0')
end

% Replace nans with zeros
slice(1:3) = slice(1:3) .* plane;

% Make sure slice is a row vector
if size(slice,1) ~= 1
    slice = slice';
end


% Format the image with proper transforms etc.
% The variable slice is given in acpc coordinates.  Transform acpc to image
% coordinates
imgXform = nifti.qto_ijk;
ImCoords = floor(imgXform * [slice(1:3) 1]');
imIndx   = ImCoords(slice(1:3)~=0);

if length(slice) == 4
  fourDindx = slice(4);
else
  fourDindx = 1;
end

% Pull the desired slice out of the 3d image volume
if find(plane) == 1
    image = squeeze(nifti.data(imIndx,:,:,fourDindx));
    % Define the minimum and maximum coordinates of the image in each
    % dimension in acpc mm space.
    min_x = slice(1); max_x = min_x;
    [y z] = size(image);
    max_corner = (imgXform) \[imIndx y z 1]';
    max_y = max_corner(2); max_z = max_corner(3);
    min_corner = (imgXform) \ [imIndx 0 0 1]';
    min_y = min_corner(2); min_z = min_corner(3);
elseif find(plane) == 2
    image = squeeze(nifti.data(:,imIndx,:,fourDindx));
    % Define the minimum and maximum coordinates of the image in each
    % dimension in acpc mm space.
    min_y = slice(2); max_y = min_y;
    [x z] = size(image);
    max_corner = (imgXform) \ [x imIndx z 1]';
    max_x = max_corner(1); max_z = max_corner(3);
    min_corner = (imgXform) \ [0 imIndx 0 1]';
    min_x = min_corner(1); min_z = min_corner(3);
else
    image = squeeze(nifti.data(:,:,imIndx,fourDindx));
    % Define the minimum and maximum coordinates of the image in each
    % dimension in acpc mm space.
    min_z = slice(3); max_z = min_z;
    [x y] = size(image);
    max_corner = (imgXform) \ [x y imIndx 1]';
    max_x = max_corner(1); max_y = max_corner(2);
    min_corner = (imgXform) \ [0 0 imIndx 1]';
    min_x = min_corner(1); min_y = min_corner(2);
end

% Resample the image to 1mm resolution. The necessary scale factor is
% stored in the image xform.
scale = diag(nifti.qto_xyz); scale = scale(1:3);
% The new dimensions will be the old dimensions multiplied by the scale
% factors for the plane
oldDim = size(image);
newDim = oldDim .* scale(plane == 0)';
% Resize the image
image = double(imresize(image,newDim));

% Scale and clip the image values so that the lowest 25% of the values are
% zeroed, the top 5% are maxed and the range is 0 to 255
image = uint8(mrAnatHistogramClip(image,.05,.95,1).* 255);

% Convert the scaler image to an RGB image based on the chosen colormap
colorimg = ind2rgb(image,cmap);

% Plot the image
% The call to surface will be slightly different depending on whether it is
% an axial, sagittal or coronal image.
if find(plane) == 1
    % Add the image to the current 3D plot
    z_dims = [min_z max_z; min_z max_z];
    h = surf([min_x max_x],[min_y max_y],z_dims,...
        colorimg,'facecolor','texture','faceAlpha',alpha);
elseif find(plane) == 2
    % The image dimensions must be permuted to match what is expected in
    % surf
    colorimg=permute(colorimg,[2 1 3]);
    % Add the image to the current 3D plot
    z_dims = [min_z min_z;   max_z max_z];
    h = surf([min_x max_x],[min_y max_y],z_dims,...
        colorimg,'facecolor','texture','FaceAlpha',alpha);
elseif find(plane) == 3
    % The image dimensions must be permuted to match what is expected in
    % surf
    colorimg=permute(colorimg,[2 1 3]);
    % Add the image to the current 3D plot
    h =surf([min_x max_x],[min_y max_y],repmat(min_z, [2 2]),...
        colorimg,'facecolor','texture','FaceAlpha',alpha);
end

% Rescale the axis to fit the image
if rescale == 1
    % Old axis values
    ax = axis;
    % New axis scaling
    ax2 = [min_x max_x min_y max_y min_z max_z];
    % Only change the dimensions that are needed to see the full image
    if find(plane) == 1
        ax2(1:2) = ax(1:2);
    elseif find(plane) == 2
        ax2(3:4) = ax(3:4);
    elseif find(plane) == 3;
        ax2(5:6) = ax(3:4);
    end
    % Rescale axis
    axis(ax2);
end

return