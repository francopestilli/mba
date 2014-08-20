function mbaCreate(mba,)
%
% Create an empty MBA structure.
%
% Copyright (2014) Franco Pestilli, Stanford University,
% pestillifranco@gmail.com

if mbaNotDefined('mba'), mbaError('Please initialize an mba structure. See mbaCreate.m');       end
%% Data
mba.data.set           = [];
mba.data.im            = [];

% Cliping
mba.data.clip.set      = [];
mba.data.clip.x        = [];
mba.data.clip.y        = [];
mba.data.clip.z        = [];

% smoothing
mba.data.smooth.set    = [];
mba.data.smooth.type   = [];
mba.data.smooth.filter = [];

mba.data.reduceby      = [];

%% Patch
mba.patch.set               = [];
mba.patch.smooth.set        = [];
mba.patch.smooth.data       = [];
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
mba.patch.isocaps.data   = [];
mba.patch.isocaps.handle = [];

%% Axis
mba.axis.set    = [];
mba.axis.handle = [];
mba.axis.dataaspectratio = [];
mba.axis.view     = [];
mba.axis.colormap = [];

%% Light
mba.light.set    = [];
mba.light.handle = [];


