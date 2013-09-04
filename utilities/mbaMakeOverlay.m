function [awo,x,y,z,xform,xAxes] = mbaMakeOverlay(niAnatomy,niOverlay,slice,overlayThresh,overlayAlpha,cmap,interpType,mmPerVox)
% Determine current slices and return them (and potentially a lot of other info)
%
%  [awo,x,y,z,xform,xAxesm] = mbaMakeOverlay(niAnatomy,niOverlay,slice,overlayThresh,overlayAlpha,cmap,interpType)
%
%
% Written by Franco PEstilli (c) Vistasoft Stanford university 2013

if notDefined('interpType'),interpType = 'n';end

if notDefined('cmap'),cmap = [hot(256); 0 0 0];
else cmap = [cmap;0 0 0];end

% Overlay information
if notDefined('overlayThresh'),
    overlayThresh = minmax(single(niftiGet(niOverlay,'data')));
end
if notDefined('overlayAlpha')
   overlayAlpha  = .8;
end
if notDefined('mmPerVox')
    mmPerVox  = niftiGet(niAnatomy,'pix dim');
    mmPerVox  = mmPerVox(1:3);
    %mmPerVox  = [.25 .25 .25];
end

% Ideally we should be able to set the max and min fo the images to be
% dispalyed usign this parameter. I ahev not loked into it yet. FP.
dispRange = [];

% Get key parameters
anatXform = niftiGet(niAnatomy,'qto_xyz');
dims      = niftiGet(niAnatomy,'dim');
dims      = dims(1:3);

% Build the bounding box for the final image.
%
% First we build a bounding box in pixels (image space) containing the full
% volume of the second input image. Second, we convert the bounding box
% from image space to mm space.
bbimg = [1 1 1; dims];
bbmm = mrAnatXformCoords(anatXform,bbimg);

% Get the anatomy (background) image data
anat = niftiGet(niAnatomy,'data');

% Here we get the anatomical slices transformed into image space
[aImg,x,y,z] = dtiGetSlice(anatXform, anat, find(slice), slice(slice~=0), bbmm, interpType, mmPerVox, dispRange);
xAxes = [y(1), y(end); z(1), z(end)]+0.5;

% Force the background image to be between 0 and 1
aClip.min = min(aImg(:));
aClip.max = max(aImg(:));
[aImg, aClip]    = mbaImageHistogramClip(aImg, aClip, true);
  
% Turn the images into RGB
aRgb = repmat(aImg,[1 1 3]);

% Set up the return transform from acpc
%
% The xform that we return is from acpc to the space that we put the slices
% in, which is ac-pc aligned on the specific sample grid (mmPerVox,
% typically 1mm isotropic) and filling the bounding box. The xform is
% returned and used in say, dtiRefreshFigure.
xform = [[diag(mmPerVox) bbmm(1,:)'-1];[0 0 0 1]];

% ----------- UP to HERE we are done with the image ------------ % 
% ----------- Perhaps the code below is a different function --- %
if (overlayAlpha > 0)
    % Get the overlay data and xform
    overlayImg   = niftiGet(niOverlay,'data');
    oXform       = niftiGet(niOverlay,'qto_xyz');
    
    % Overlay needs to be between 0-1.
    % Hereafter we normalize it unless it has been already normalized to be
    % between 0-1.
    mm = minmax(single(overlayImg(:)));
    clip.min = nanmin(single(overlayImg(:)));
    clip.max = nanmax(single(overlayImg(:)));
%     if (mm(1) ~= 0) && (mm(2) >= 1)
        fprintf('[%s] Normalizing the overlay using: mbaImageHistogramClip.m ...\n',mfilename)
        [overlayImg, clip]= mbaImageHistogramClip(overlayImg, clip, true);
% else
%     clip.minVal = nanmin(single(overlayImg(:)));
%     clip.maxVal = nanmax(single(overlayImg(:)));
% end
    
    % Get the transformed overlay slices and combine them with the
    % background slices.
    % The disp range we send in is used to return an image between 0
    % and 1.  We need to remember the display range, somehow. The
    % spatial interpolation type is set somewhere.  Not sure where. It
    % is a string, by default n, which I think means nearest neighbor.
    oImg = dtiGetSlice(oXform, overlayImg, find(slice), slice(slice~=0), bbmm, interpType, mmPerVox, []);

    % Find the voxels that pass the requested thresholds for values.
    %
    % Values above threshold(2) and below threshold(1) will not be
    % displayed. threshold(1) > val > thresdhold(2) will be displayed at
    % the requested alpha value.
    
    % Threshold are expected in units of overaly intensity (e.g., [20 40] 
    % for root-mean-squared error). But the image at this point has been
    % normalized between 0-1. Here we normalize the threshold values
    % between 0 and 1.
    overlayThresh(1) = (overlayThresh(1) - clip.minVal) / clip.maxVal;
    overlayThresh(2) =  overlayThresh(2) / clip.maxVal;

    % Now we create a logical mask indicating whch voxel will have a
    % combination of anatomy and overlay
    oVox2Show = false(size(aRgb));
    oVox2Show(repmat(oImg > overlayThresh(1),[1,1,3])) = true;  
    oVox2Show(repmat(oImg > overlayThresh(2),[1,1,3])) = false;

    % Here we merge the overlay image (which is colorful) with the
    % background image created above, which is gray scale.
    % We do this by taking every value in the overlay image and
    % assigning it an index into the color map, cmap.
    %
    % The cmap rows are 1:size(cmap,1).  We require the overlay to be between 0
    % and 1. That way the entries of the overlay map into each cmap row.  
    %
    % We set the NaNs to the last+1 entry of the table, which is als=ways set to 0 0 0.
    oImg(isnan(oImg)) = (size(cmap,1) / (size(cmap,1) - 1));
    
    % This makes a list of cmap values that is a vector, and we reshape
    % it to an RGB image.
    oRgb = reshape(cmap(ceil(oImg*(size(cmap,1)-2)+1),:), [size(oImg),3]);
     
    % Now, we mix the background gray image with the overlay image at
    % the locations specified by oMask.
    aRgb(oVox2Show) = (1-overlayAlpha).*aRgb(oVox2Show) + overlayAlpha.*oRgb(oVox2Show);
   
end

% Prepare the output (anatomy-with-overaly)
awo = aRgb;

return;
