function h = mbaDisplayBrainSlice(nifti, slice, cmap, rescale,alpha)
% 
% Add a slice from a nifti image to a matlab plot
%
%   h = mbaDisplayBrainSlice(nifti, slice, [cmap], [rescale],alpha)
%
% INPUTS:
%    nifti   - A 3D nifti img. 
%    slice  - Identifies the ACPC coordinates (in millimeter) 
%             of the brain slice and the index of the data (4th dimension 
%             of a volume). Slice is either:
%              - a 1x3 [X,Y,Z] vecotor of ACPC coordinates (Coronal,
%                Sagittal, Axial), OR
%              - a 1x4 [X,Y,Z,d] vector of ACPC coordinates (Coronal,
%                Sagittal, Axial) plus the index into the data dimension, d
%                in data indices. 
%             All entries must be all 0 except the coordinate of the
%             slice to be rendered an the 4th dimension (if passed in). 
%    cmap    - Define a colormap for the values in the img.  The defualt is
%              cmap = 'gray'; Other options: cmap = 'jet'; cmap = 'hot'; etc.
%    rescale - If the img is being added to an existing axis the default is
%              to rescale the axis so the full img can be seen 
%              [rescale = 1]. To preserve the current axis properties: 
%             rescale = 0
%
% OUTOPUT:
%     h   - Handle for the image (a matlab surface) appeared in the current axis. 
%           You can remove the image from the figure with: delete(h). Or
%           get all its image properties with set(h,'PropertyName',PropertiVal)
%
% EXAMPLE: h = feDisplayBrainSlice(nifti, [-20 0 0 10])
%
% Written by Franco Pestilli (C) Vistasoft Stanford University, 2013

% Check arguments
if notDefined('cmap'), cmap = gray(128);
else    cmap = eval(sprintf('%s(128)',cmap));
end
if notDefined('rescale'), rescale = 0;end
if notDefined('alpha'),   alpha   = 1;end

% Get the slice requested from the nifti and preprocess it for display.
[image_rgb, x, y, z, plane]  = mbaMakeImageFromNiftiSlice(nifti, slice,cmap);

% Plot the image
%
% The call to surface will be slightly different depending on whether it is
% an axial, sagittal or coronal img.
if find(plane) == 1
    % Add the img to the current 3D plot
    z_dims = [z.min z.max; z.min z.max];
    h = surf([x.min x.max],[y.min y.max],z_dims,...
        image_rgb,'facecolor','texture','faceAlpha',alpha);
elseif find(plane) == 2
    % The img dimensions must be permuted to match what is expected in
    % surf
    image_rgb = permute(image_rgb,[2 1 3]);
    % Add the img to the current 3D plot
    z_dims = [z.min z.min;   z.max z.max];
    h = surf([x.min x.max],[y.min y.max],z_dims,...
        image_rgb,'facecolor','texture','FaceAlpha',alpha);
elseif find(plane) == 3
    % The img dimensions must be permuted to match what is expected in
    % surf
    image_rgb = permute(image_rgb,[2 1 3]);
    % Add the img to the current 3D plot
    h = surf([x.min x.max],[y.min y.max],repmat(z.min, [2 2]),...
        image_rgb,'facecolor','texture','FaceAlpha',alpha);
end

% Rescale the axis to fit the img
if rescale == 1
    % Old axis values
    ax = axis;
    % New axis scaling
    ax2 = [x.min x.max y.min y.max z.min z.max];
    % Only change the dimensions that are needed to see the full img
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