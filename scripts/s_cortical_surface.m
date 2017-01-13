function s_cortical_surface(niiAnat,niiMap)
% Example of how to make a fider density map fr om a faccile, and render it
% on a a surface.

% Prepare the path for the nifti to the0 segemntation file
%
% Make this here. 

baseanatdir = '/N/dc2/projects/lifebid/2t1/anatomy';
subject = '110411';
cortex  = fullfile(baseanatdir,subject,'wm_mask.nii.gz');

close all
overlay{1} = fullfile(baseanatdir,subject,'label', ...
    'lh_parstriangularis_label_smooth3mm.nii.gz');
overlay{2} = fullfile(baseanatdir,subject,'label', ...
    'lh_parsopercularis_label_smooth3mm.nii.gz');
overlay{3} = fullfile(baseanatdir,subject, 'label', ...
    'lh_S_temporal_sup_label_smooth3mm.nii.gz');
overlay{4} = fullfile(baseanatdir,subject, 'label', ...
'lh_G_temp_sup-Lateral_label_smooth3mm.nii.gz');
%'rh_G_temp_sup-Plan_polar_label_smooth3mm.nii.gz');
%'rh_G_temp_sup-Plan_tempo_label_smooth3mm.nii.gz');

% Combine all rois
niiA  = niftiRead(overlay{1});
niiAt = niftiRead(overlay{2});
niiA.data = double(or(niiAt.data,niiA.data));

niiB = niftiRead(overlay{3});
niiBt = niftiRead(overlay{4});
niiB.data = 2*double(or(niiBt.data,niiB.data));

% Pick two colors
a = niiA.data;
b = niiB.data;
a(a==0)=b(a==0);
nii=niiA;
nii.data = a;
clear a b niiA niiB

overlay2use = fullfile(tempdir,'overlay.nii.gz');
nii.fname = overlay2use;
niftiWrite(nii);
alpha_val = 1;

figure
msh = AFQ_meshCreate(cortex,'color',[.78 .8 .89]);
msh = AFQ_meshColor(msh, ...
                   'overlay', overlay2use,  ...
                   'thresh', [1 2], ...
                   'crange', [0 4], ...
                   'cmap', colormap([.8 .3 0; .4 .8 0]), ...
                   'interp','nearest', ...
                   'smooth',[100], ...
                    'boxfilter', [100]);
tr  = AFQ_meshGet(msh, 'triangles');
p   = patch(tr);
shading('interp'); 
lighting('gouraud');
alpha(p,alpha_val);
axis('image');
axis('vis3d');
set(p,'specularstrength',.5,'diffusestrength',.7);
set(gcf,'color','w')
axis off
view(-90,0);
lightH = camlight('right');
% [p, msh, lightH] = AFQ_RenderCorticalSurface(cortex, 'overlay' , overlay, 'crange', crange, 'thresh', thresh)
