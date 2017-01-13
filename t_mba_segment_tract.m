% Tutorial Tract Segmentation using mba
% 
% This tutorial will show how to load a series of ROI's, a whole brain
% fiber group, and perform a series of logical operations between the
% fibers in the connectome group and the ROI's, with the aim to segment a
% white matter tract. The tutorial will also show how to clean the fiber
% tract, AKA how to remove the outliers and isolate the core of the tract.
% 
% Copyright Franco Pestilli, Sam Faber, Dan Bullock, and Julian Moehlen, 
% Indiana University 2015 

% First, we will load from disk some ROI's.
roipath = '/N/dc2/projects/lifebid/HCP/Julian/105115/dt6_b2000trilin/ROIs/Julian_ROIs';
roinames = {'inferior_horizontal_baseline_plane_LH_ACPC_z=-5.8.mat', ...
            'Superior_horizontal_LH_ACPC_Z=44.mat','midsagittal_slice.mat', ...
            'vertical_NOT_plane_ACPC_y=-33.mat'}; 
roioperands = {'and','and','not','not'};
fgpath = '/N/dc2/projects/lifebid/HCP/Julian/105115/fibers';
fgname = 'dwi_data_b2000_aligned_trilin_csd_lmax10_dwi_data_b2000_aligned_trilin_brainmask_dwi_data_b2000_aligned_trilin_wm_prob-500000.pdb';
% Next, we will build the full path to the files and load them.
fp = fullfile(roipath,roinames);

for iroi = 1:length(fp);
    rois{iroi} = dtiReadRoi(fp{iroi});
end

% Next, we load the whole brain fiber group from file.
fg = fullfile(fgpath,fgname);
wbfg = fgRead(fg);

tic, fprintf('\n[%s] Segmenting tract from connectome... \n',mfilename)
[verticalParietalTract, ~] = feSegmentFascicleFromConnectome(wbfg, rois, roioperands, 'vertical_parietal');
toc

tic
% Clean the fibers by length, fibers that too long are likely to go far
% frontal and not just touch MT+ and parietal.
[~, keep]        = mbaComputeFibersOutliers(verticalParietalTract,3,3);
fprintf('\n[%s] Found a tract with %i fibers... \n',mfilename,sum(keep))
verticalParietalTract = fgExtract(verticalParietalTract,find(keep),'keep');
toc

% Visualize the fiber group
anatomypath = '/N/dc2/projects/lifebid/HCP/Julian/105115/anatomy/';
anatomyname = 'T1w_acpc_dc_restore_1p25.nii.gz';
t1     = niftiRead(fullfile(anatomypath,anatomyname));
slices     = {[18 0 0],[0 -40 0],[0 0 -14]};

fh = figure('name','vertical parietal tract','color','k'); hold on
h  = mbaDisplayBrainSlice(t1, slices{1});
h  = mbaDisplayBrainSlice(t1, slices{2});
h  = mbaDisplayBrainSlice(t1, slices{3});
[fh, lh] = mbaDisplayConnectome(verticalParietalTract.fibers,fh);   
view(-80,30)
delete(lh)
lh = camlight('left');
 
axis off
