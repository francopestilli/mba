function mba = mbaDisplayBrain(mba,nii)
% Render an ROI as a 3D surface
%
% h = mbaDisplayBrainRegion(mba)
%
% INPUTS:
%   mba    - an mba structure containign information regarding, image vdata,
%   surfaces, colors etc. See mbaCreate.m
%
% Copyright (2014) Franco Pestilli, Stanford University,
% pestillifranco@gmail.com

if mbaNotDefined('mba'), mbaError('Please initialize an mba structure. See mbaCreate.m');       end
mba = mbaDisplayBrainInit(mba,nii);

if mba.vdata.clip.set
    mba.vdata.im = mba.vdata.im(mba.clip.x(1):mba.clip.x(2), ...
                              mba.clip.y(1):mba.clip.y(2), ...
                              mba.clip.z(1):mba.clip.z(2));
end
if mba.vdata.smooth.set
    mba.vdata.im = smooth3(mba.vdata.im,mba.vdata.smooth.type,mba.vdata.smooth.filter);
end

[X,Y,Z,V]    = reducevolume(mba.vdata.im, ...
                            mba.vdata.reduceby);
mba.patch.vdata = isosurface(X,Y,Z,V);
mba.patch.smooth.vdata = smoothpatch(mba.patch.vdata,...
                                    mba.patch.smooth.algorithm, ...
                                    mba.patch.smooth.iterations);
mba.patch.smooth.handle = patch(mba.patch.smooth.vdata, ...
                   'FaceColor', mba.patch.smooth.facecolor, ...
                   'EdgeColor', mba.patch.smooth.edgecolor);
mba.patch.isonormals.handle = isonormals(mba.patch.smooth.vdata, ...
                                         mba.patch.smooth.handle);

if mba.axis.format.set
   mba.view   = view(3);
   set(mba.axis.handle,'dataaspectratio',mba.axis.dataaspectratio);
end

if mba.light.set
    if ~isempty(mba.light.handle)
        delete(mba.ligth.handle)
    end
    mba.light.handle = camlight('right');
end

if (mba.isocaps.set && mba.clip.set)
    mba.isocaps.vdata  = isocaps(X,Y,Z,V);
    mba.isocaps.handle = patch(mba.patch.isocaps.vdata, ...
                  'FaceColor', mba.patch.smooth.facecolor, ...
                  'EdgeColor', mba.patch.smooth.edgecolor);
    colormap(mba.isocaps.colormap)
end

end
