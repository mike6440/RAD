function [dt,xout] = FillTimeSeries(t, x, delt, ta, tb)%function [dt,xout] = FillTimeSeries(t, x,delt, ta, tb)%====================================================%Fill in the time series (t,x) so all times are completely%represented and any missing data are nans.%% 1. Set up a regular time base, even minutes of the day.% 2. Set x_out all NaNs.% 3. Fill x_out with the points in x_in closest to the time.%%input%  t,x = original time series%  delt (optional) is the sample interval (minutes),%  ta (optional) is the starting time in final series%  tb (optional) is the final time%The final time series (dt,xout) are complete for the time %range of ta <= dt < tb.%=======================================================%reynolds 001211% rmr 040502% rmr 050609 -- fix endp% rmr 061112 -- add to the above help%NOTE:  050609 -- I screwed around with this.  Be sure it works for you.% DEFAULT FILL TIME = 2 MINfprintf('nargin = %d\n',nargin);if nargin <= 2, delt = 2; end;   % minutes delta time% DEFAULT TIME INTERVALS DEFINED BY TIME SERIESif nargin <= 3, t1 = t(1); t2 = t(end); else, t1 = ta; t2 = tb; end% START AND END AT EVEN MINUTES TO DESIRED TIMES[y,jdf] = dt2jdf(t1);          % f.p. year daysdy = rem(jdf,1)*1440;         % minute of the dats1 = fix(sdy/delt)*delt/1440; % nearest second for an even samplet1 = jdf2dt(y, fix(jdf)+s1);     % in datenum formatdisp('test'); return% % [y,M,d,h,m,s] = datevec(t1);% m = fix((m+s/60)/delt)*delt; % nearest even minute% t1 = datenum(y,M,d,h,m,0);[y,jdf] = dt2jdf(t2);          % f.p. year daysdy = rem(jdf,1)*1440;         % minute of the days1 = fix(sdy/delt)*delt/1440; % nearest second for an even samplet2 = jdf2dt(y, fix(jdf)+s1);     % in datenum format% [y,M,d,h,m,s] = datevec(t2);% m = fix((m+s/60)/delt)*delt; % nearest even minute% t2 = datenum(y,M,d,h,m,0);%fprintf('FillTimeSeries: Make full time series from %s to %s\n',dtstr(t1), dtstr(t2));% NUMBER OF POINTS IN THE SERIESPtsPerDay = round(1440 / delt);Npts = round((t2-t1)*PtsPerDay)+1;%fprintf('FillTimeSeries: Npts = %.0f\n',Npts);% TIMES OF THE OUTPUT SERIESix = [1:Npts]';dt = t1 + (ix-1) .* delt/1440;xout = nan * ones(size(dt));% INDEXES IN OUT SERIES FOR INPUT DATA% length(it) = length(x);it = round( ( t-t1 ) * PtsPerDay ) + 1;% ONLY USE INPUT DATA THAT IS IN THE DESIRED OUT SERIESix = find( it >= 1 & it <= length(dt) );xout(it(ix)) = x(ix);return