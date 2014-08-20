function val = mbaSet(mba,params,vals)
%
% Set the values of the field of an MBA structure.
%
% Copyright (2014) Franco Pestilli, Stanford University,
% pestillifranco@gmail.com



% Clipping
val = mba.fdata.clip.set;
val = mba.fdata.clip.x;
val = mba.fdata.clip.y;
val = mba.fdata.clip.z;

%% Slice Data
val = mba.sdata.set;
val = mba.sdata.im;

% Clipping
val = mba.sdata.clip.set;
val = mba.sdata.clip.x;
val = mba.sdata.clip.y;
val = mba.sdata.clip.z;


%% Volume image Data
val = mba.vdata.set;
val = mba.vdata.im;

% Clipping
val = mba.vdata.clip.set;
val = mba.vdata.clip.x;
val = mba.vdata.clip.y;
val = mba.vdata.clip.z;

% smoothing
val = mba.vdata.smooth.set;
val = mba.vdata.smooth.type;
val = mba.vdata.smooth.filter;

mba.vdata.reduceby;

%% Patch
val = mba.patch.set;
val = mba.patch.smooth.set;
val = mba.patch.smooth.vdata;
val = mba.patch.smooth.algorithm;
val = mba.patch.smooth.iterations;
val = mba.patch.smooth.handle;
val = mba.patch.smooth.facecolor;
val = mba.patch.smooth.edgecolor;

% isonormals
val = mba.patch.isonormals.set;
val = mba.patch.isonormals.handle;

% Isocaps
val = mba.patch.isocaps.set;
val = mba.patch.isocaps.vdata;
val = mba.patch.isocaps.handle;

%% Axis
val = mba.axis.set;
val = mba.axis.handle;
val = mba.axis.vdataaspectratio;
val = mba.axis.view;
val = mba.axis.colormap;

%% Light
val = mba.light.set;
val = mba.light.handle ;

end
