function mba = mbaDisplayBrainInit(mba,nii,params,vals)
%
% Set the values of the field of an MBA structure. TO initialize a brain
% surface plot.
%
% Copyright (2014) Franco Pestilli, Stanford University,
% pestillifranco@gmail.com

if mbaNotDefined('mba'), mba = mbaCreate;end
if mbaNotDefined('nii'), mbaError('A NIFTI-1 image is required for initializing a brain.');end

%% Volume image Data
mba.vdata.set           = [];
mba.vdata.im            = single(nii.data);
mba.vdata.xform.toacpc  = nii.qto_xyz;
mba.vdata.xform.toimg   = nii.qto_ijk;

% Clipping
mba.vdata.clip.set      = 0;
mba.vdata.clip.x        = [];
mba.vdata.clip.y        = [];
mba.vdata.clip.z        = [];

% smoothing
mba.vdata.smooth.set    = 1;
mba.vdata.smooth.type   = 'box';
mba.vdata.smooth.filter = 3;

mba.vdata.reduceby      = [1 1 1];

%% Patch
mba.patch.set               = 1;
mba.patch.smooth.set        = 1;
mba.patch.smooth.vdata       = [];
mba.patch.smooth.algorithm  = 1;
mba.patch.smooth.iterations = 24;
mba.patch.smooth.handle     = [];
mba.patch.smooth.facecolor  = 'r';
mba.patch.smooth.edgecolor  = 'none';

% isonormals
mba.patch.isonormals.set    = 1;
mba.patch.isonormals.handle = [];

% Isocaps
mba.patch.isocaps.set     = 1;
mba.patch.isocaps.vdata   = [];
mba.patch.isocaps.handle  = [];

%% Axis
mba.axis.set    = 1;
mba.axis.handle = [];
mba.axis.vdataaspectratio = [1 1 1];
mba.axis.view     = view(3);
mba.axis.colormap = 'gray';

%% Light
mba.light.set    = 1;
mba.light.handle = [];
end
