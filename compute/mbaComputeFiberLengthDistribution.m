function [Lnorm, Lmm, Mu, Sigma] = mbaComputeFiberLengthDistribution(fg, displayDist)
% Calculate the distribution of fiber lengths for a fiber group
%
% [Lnorm, Lmm, Mu, Sigma]=mbaComputeFiberLengthDistribution(fibers, displayDist)
%
% INPUTS:
% fibers   = A fiber group.
% displayDist = 0 
%
% Outputs:
% Lnorm    = Normalized length of each fiber, in units of z-score.
% Lmm      = The length of each fiber in mm.
%
% Written by Franco Pestilli (c) Stanford University 2013

if notDefined('fg'),
    fprintf('[%s] No input ''fibers'' provided.',mfilename)
    Lnorm=[]; Lmm=[]; 
    meanFiberLen = []; 
    stdFiberLen  = [];
    return
end

% Wehther to display the distribution of fiber lengths
if notDefined('displayDist')
    displayDist = 0; % Default to not showing a figure
end

% Calculate the length in mm of each fiber in the fiber group
Lmm = cellfun('length',fg.fibers);

% Z-score the length
% Here we take the log first so that the distribution of Lmm is 'more'
% gaussian and because it it not clipped at 0.
[Lnorm, Mu, Sigma] = zscore(log10(Lmm));

% Show a histagram
if displayDist==1
    mrvNewGraphWin(sprintf('[%s] Distibutions of fiber lengths',mfilename));
    hold on;
    [y, x] = hist(Lmm,round(length(fg.fibers)*0.1));
    bar(x,y,'FaceColor','k','EdgeColor','k');
    axis([min(x) max(x) 0 max(y)]);
    xlabel('Fiber Length (mm)');
    plot(10.^[Mu Mu],[0 max(y)],'r','linewidth',2);
    plot(10.^[Mu-Sigma   Mu-Sigma],[0 max(y)],'--r');
    plot(10.^[Mu+Sigma   Mu+Sigma],[0 max(y)],'--r');
    plot(10.^[Mu-2*Sigma Mu-2*Sigma],[0 max(y)],'--r');
    plot(10.^[Mu+2*Sigma Mu+2*Sigma],[0 max(y)],'--r');
end

return