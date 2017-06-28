function [dt,xout] = FillTimeSeries1sec(t, x, delt, ta, tb)%function [dt,xout] = FillTimeSeries(t, x,delt, ta, tb)%====================================================%Fill in the time series (t,x) so all times are completely%represented and any missing data are nans.%% 1. Set up a regular time base, even minutes of the day.% 2. Set x_out all NaNs.% 3. Fill x_out with the points in x_in closest to the time.%%input%  t,x = original time series%  delt (optional) is the sample interval (seconds),%  ta (optional) is the starting time in final series%  tb (optional) is the final time%The final time series (dt,xout) are complete for the time %range of ta <= dt < tb.%=======================================================%reynolds 001211% rmr 040502% rmr 050609 -- fix endp% rmr 061112 -- add to the above helpdt=NaN;  xout=NaN;% START AND END AT EVEN MINUTES TO DESIRED TIMES%t1=fix(ta*86400)/86400;%t2=round(tb*86400)/86400;t1=ta; t2=tb;% NUMBER OF POINTS IN THE SERIESPtsPerDay = round(86400 / delt);Npts = round((t2-t1)*PtsPerDay);% TIMES OF THE OUTPUT SERIESix = [1:Npts]';dt = t1 + (ix-1) .* delt/86400;xout = nan * ones(size(dt));% INDEXES IN OUT SERIES FOR INPUT DATA% length(it) = length(x);it = round( ( t-t1 ) * PtsPerDay ) + 1;% ONLY USE INPUT DATA THAT IS IN THE DESIRED OUT SERIESix = find( it >= 1 & it <= length(dt) );xout(it(ix)) = x(ix);return