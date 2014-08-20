function mba = mbaSet(mba,params,vals)
%
% Set the values of the field of an MBA structure.
%
% Copyright (2014) Franco Pestilli, Stanford University,
% pestillifranco@gmail.com



% Clipping
mba.fdata.clip.set      = [];
mba.fdata.clip.x        = [];
mba.fdata.clip.y        = [];
mba.fdata.clip.z        = [];

%% Slice Data
mba.sdata.set           = [];
mba.sdata.im            = [];

% Clipping
mba.sdata.clip.set      = [];
mba.sdata.clip.x        = [];
mba.sdata.clip.y        = [];
mba.sdata.clip.z        = [];


%% Volume image Data
mba.vdata.set           = [];
mba.vdata.im            = [];

% Clipping
mba.vdata.clip.set      = [];
mba.vdata.clip.x        = [];
mba.vdata.clip.y        = [];
mba.vdata.clip.z        = [];

% smoothing
mba.vdata.smooth.set    = [];
mba.vdata.smooth.type   = [];
mba.vdata.smooth.filter = [];

mba.vdata.reduceby      = [];

%% Patch
mba.patch.set               = [];
mba.patch.smooth.set        = [];
mba.patch.smooth.vdata       = [];
mba.patch.smooth.algorithm  = [];
mba.patch.smooth.iterations = [];
mba.patch.smooth.handle     = [];
mba.patch.smooth.facecolor  = [];
mba.patch.smooth.edgecolor  = [];

% isonormals
mba.patch.isonormals.set    = [];
mba.patch.isonormals.handle = [];

% Isocaps
mba.patch.isocaps.set    = [];
mba.patch.isocaps.vdata   = [];
mba.patch.isocaps.handle = [];

%% Axis
mba.axis.set    = [];
mba.axis.handle = [];
mba.axis.vdataaspectratio = [];
mba.axis.view     = [];
mba.axis.colormap = [];

%% Light
mba.light.set    = [];
mba.light.handle = [];

end
