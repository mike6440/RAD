function [tgood,ibad] = TimeBaseJump(tx),
%=========================================
%
% function [tgood,ibad] = TimeBaseJump(tx),
%
% The program checks through the time base and finds any points that
% should be removed because time is non-monotonic.
% Points are marked for removal if diff(dt) <= 0.  Also,
% if diff(tx) < 0, all times are tagged until the time exceeds
% the first point where it was negative.
%
% Points are removed. 
% The time base does not have to be equally spaced.
%
% The first time point must be good.
%
%input
%  tx = datenum time series, nx1, n time points
%
%output
% tgood = monotonic series (ngood x 1)
% ibad = indexes of points that need removal.
%      returns [empty] if all is okay.
%===========================================
% v01 20061112 rmr -- create
tgood=tx; ibad=[];


ix = find(diff(tgood) <= 0);
while length(ix) > 0, 	
	%% THE LAST SLOPE <= 0
	j = ix(end)+1;  
	ibad=[ibad; j];
	tgood(j)=[];
	%fprintf('test remove %d\n',j);
	%ii=input('test quit?', 's');
	%if strcmp(ii,'y'), return; end
	ix = find(diff(tgood)<=0);
end

return
