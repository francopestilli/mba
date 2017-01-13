function fibers = mbaFiberSplitLoops(fibers)
%
% function fibers = mbaFiberSplitLoops(fibers)
%
% Splits fibers in a fiber group that are discontinuous.
% 
% These fibers are probably entering and existing a volume ROI. This type
% of fibers are often the result of a a clipping process (feClipFibersTovolume.m)
%
% See also: feClipFibersToVolume.m
%
% Example:
%
% Written by Franco Pestilli (c) Stanford VISTA Team 2013

fprintf('\n[%s] Splitting fibers that are discontinuous.\n',mfilename)

% Check whether the nodes are consecutives. If they are not
% it means that they went out of the ROI then back in the ROI.
% Compute the distance between nodes, this is generally a small number (0.5).
% But for fibers that exitedna dnre-entered the ROI it will be large.
dx = cellfun(@getNodeDistance,fibers, 'UniformOutput', false);

% Compute the median distance. This is rounds up and then used as a
% thresholds for detecting the fibers and the nodes that exited and
% reentered.
md = floor(100*median(cell2mat(dx')))/100;

% Now we arbitrarily decide that we keep spli only the fibers that have
% nodes with double this median distnce, this is because if we have fibers
% that exit and reenter quickly they will show up OK on display.
% This small hack speeds up the code and the visualization si faster
maxDistance = 2*md - 0.02;

% If a fiber only has one node in the ROI dx will be emtpy for that
% fiber. We set the fiber to 1.
dx = cellfun(@oneifempty,dx, 'UniformOutput', false);

% Precompute the final number of fibers, the ones we had plus the new ones
% that we will create by splitting the fibers that are discontinuos.
c = 1;
parfor iif = 1:length(fibers)
  % Find the nodes that are continous within the ROI
  isone = dx{iif} <= maxDistance;
  if all(isone), c = c + 1;
  else           c = c + length(find(~isone));
  end
end

% Now we deal with cases in which the fibers go out of the roi and then go
% back in into the ROI in these cases we split the fibers into separated
% fibers.
c = 1; % This is the counter that keeps track of the new fibers. 
       % The fiber number will increase after the following operations
for iif = 1:length(fibers)
  % Find the nodes that are continous within the ROI
  isone = dx{iif} <= maxDistance;
  
  % If all the nodes in this fiber were in the ROI just copy the fiber
  if all(isone)
    tmpfibers{c} = fibers{iif};    
    c = c + 1;
    
  % If the fiber exits the ROI and then re-enters it, ctu the fibers into
  % segements and save the segments as separate fibers.
  else
    indx = find(~isone);
    for iin = 1:length(indx)
      if iin == 1
        tmpfibers{c} = fibers{iif}(:, (1:indx(iin)));
      else
        tmpfibers{c} = fibers{iif}(:, (indx(iin - 1) + 1:indx(iin)));
      end
      c = c + 1;
    end
  end
end

fibers = tmpfibers;

%-------------------------%
function stepSize = getNodeDistance(fiber)
% Computes the distance between nodes in a ifber.
stepSize = sqrt(sum(diff(fiber,1,2).^2));


%-------------------------%
function x = oneifempty(x)
%
% This function is used to substitute empty matrices in a cell with 1.
%
if isempty(x), x = 1;end