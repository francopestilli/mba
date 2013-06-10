function [img, clip] = mbaImageHistogramClip(img, clip, normalize)
%
% Clips the input array values (img) so that the range of values will be
% between the pixel-count proportions specified by clip.min and clip.max.
%
% After clipping the pixel values in img will be contained within the
% interval [clip.min, clip.max]. clip.min and clip.max are percentiles of
% the distribution of pixel values in the input img.
%
%   [img, clip] = mrAnatHistogramClip(img, [clip],[normalize])
%
% INPUTS:
%   img  - a 2D image.
%   clip - is a strucure containing two fields:
%          clip.min: the minimum proportion of pixels vlues that we will keep in the image.
%                    e.g., 0.01. 
%          clip.max: the max proportion of pixel values that we will keep in the image.
%                    e.g., 0.99.
%   normalize - If true,  the pixel values in the output img will be scaled to 0-1. 
%               If false, the pixel values will preserve the input img pixel units.
%               Default normalize is false.
%
% OUTPUT:
%   img  - A new image of the same sixe as the input image but with pixel
%          values clipped between clip.min and clip.max.
%   clip - A structure containing the original percentiles used for clipping 
%          and the clipped values in pixel intensity.
%
% Written by Franco Pestilli (c) Vistasoft, Stanford University 2013

if notDefined('normalize'),normalize = true;end
if notDefined('clip'),      
    clip.min = 0;
    clip.max = 1;
end

% Make sure the input image is of the proper class.
if(~isfloat(img)), img = double(img);end

if (clip.max>1)
  % Here we allow for passing pixel-intensity clip values
  clip.minVal = clip.min;
  clip.maxVal = clip.max;
else
  % We treat the values as percentiles
  %
  % Let's count the pixel occurrences in 255 bins (the standard length of a 
  % Color look-up-table)
  [count,value] = hist(double(img(:)),1024);
  
  % Transform in percentiles
  p = cumsum(count)./sum(count);
  
  % Let's the pixel values to clip.
  %clip.maxVal = value(find(p >= clip.max, 1, 'last' ));
  %clip.minVal = value(find(p <= clip.min, 1, 'first' ));
  clip.maxVal  = value(min(find(p>=clip.max)));
  clip.minVal = value(max(find(p<=clip.min)));
  
  if (isempty(clip.minVal))
      clip.minVal = value(1); 
  end
end

% Clip the pixel values. Everything above clip.max and below clip.min will
% be set to clip.max and clip.min respectively.
img(img > clip.maxVal) = clip.maxVal;
img(img < clip.minVal) = clip.minVal;

% Normalized the output image values to the intrval [0,1]
if (normalize)
  img = img - clip.minVal;
  img = img./(clip.maxVal - clip.minVal);
end

end
