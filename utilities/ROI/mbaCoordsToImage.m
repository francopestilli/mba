function roiImg = mbaCoordsToImage(coords, imgXform, boundingbox)
% Transform a set of coordinates in a image mask of logical values. One
% inside the coordinates zero outsize.
% 
%   roiImg = mbaCoordsToImage(roi, [imgXform], [boundingbox])
%
% Copyright (2014) Franco Pestilli, Stanford University,
% pestillifranco@gmail.com

if (~exist('boundingbox','var') || isempty(boundingbox))
    boundingbox = [min(coords)-1; ...
                   max(coords)+1];
    if (~exist('imgXform','var') || isempty(imgXform))
        imgXform = eye(4);
        imgXform(1:3,4) = boundingbox(1,:)'-1;
    end
end
if (~exist('imgXform','var') || isempty(imgXform)), imgXform = eye(4);end

sz = diff(ceil(mrAnatXformCoords(inv(imgXform), boundingbox)))+1;
roiImg = false(sz);

% Remove coords outside the bounding box
badCoords = coords(:,1) < boundingbox(1,1) | coords(:,1) > boundingbox(2,1) ...
          | coords(:,2) < boundingbox(1,2) | coords(:,2) > boundingbox(2,2) ...
          | coords(:,3) < boundingbox(1,3) | coords(:,3) > boundingbox(2,3);
coords    = coords(~badCoords,:);
coords    = round(mrAnatXformCoords(inv(imgXform), coords));
roiImg(sub2ind(size(roiImg), coords(:,1), coords(:,2), coords(:,3))) = true;

return;


