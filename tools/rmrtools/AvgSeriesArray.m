function [arraynameav] = AvgSeriesArray(arrayname, deltin, avgsecs)
%-------------------------------------------------------
%function [outav] = FillTimeSeriesArray(arrayname, daa, dtb)
% I define a time series array as follows: Let a = arrayname.
% a.dt = the epoch (datenum) times
% a.vars = a str2mat list of the variables in the array.
% a.yyyy, a.MM, a.dd, a.hh, a.mm, a.ss is the utc time corresponding t a.dt.
% Each of the data variables is filled from dta to dtb.
%input
%   arrayname
%   deltin = input sample spacing, secs
%   avgsecs = output sample spacing, secs
% output
%   arraynameav - has averages and std's.

fprintf('AVERAGE VARIABLES FOR ARRAYS\n');

eval(sprintf('%sav.vars=str2mat(''yyyy'',''MM'',''dd'',''hh'',''mm'',''ss'');',arrayname));

eval(sprintf('nvars=length(%s.vars(:,1));',arrayname));
for i=1:nvars,
	eval(sprintf('var=deblank(%s.vars(i,:)); disp(var);',arrayname));
	if(strcmp(var,'yyyy') | strcmp(var,'MM') | strcmp(var,'dd') | strcmp(var,'hh') | strcmp(var,'mm') | strcmp(var,'ss') | strcmp(var,'nrec')),
	else
		cmd=sprintf('[%sav.dt,%sav.%s,%sav.%sstd]=AvgSeries(%s.dt,%s.%s,deltin,avgsecs);',arrayname,arrayname,var,arrayname,var,arrayname,arrayname,var);
		disp(cmd);
		eval(cmd);
		cmd=sprintf('%sav.vars=str2mat(%sav.vars,''%s'',''%sstd'');',arrayname,arrayname,var,var);
		eval(cmd);
	end
end

eval(sprintf('[%sav.yyyy,%sav.MM,%sav.dd,%sav.hh,%sav.mm,%sav.ss]=datevec(%sav.dt);',arrayname,arrayname,arrayname,arrayname,arrayname,arrayname,arrayname));

cmd=sprintf('outav = %sav;', arrayname);
disp(cmd);
eval(cmd);

return;


