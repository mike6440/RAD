%function [outf] = FillTimeSeriesArray(ary, deltsec, dta, dtb)
%-------------------------------------------------------
%function [arraynamef] = FillTimeSeriesArray(arrayname, daa, dtb)
% I define a time series array as follows: Let a = arrayname.
% a.dt = the epoch (datenum) times
% a.vars = a str2mat list of the variables in the array.
% a.yyyy, a.MM, a.dd, a.hh, a.mm, a.ss is the utc time corresponding t a.dt.
% Each of the data variables is filled from dta to dtb.
%
%example: [outf]=FillTimeSeriesArray('nav',1,dta,dtb);
 

 
fprintf('FILL VARIABLES FOR ARRAYS\n');
outf.vars=str2mat('yyyy','MM','dd','hh','mm','ss');
cmd=sprintf('nvars=length(%s.vars(:,1));',arrayname);
eval(cmd);

for i=1:nvars,
	eval(sprintf('var=deblank(%s.vars(i,:)); disp(var);',arrayname));
	if(strcmp(var,'yyyy') | strcmp(var,'MM') | strcmp(var,'dd') | strcmp(var,'hh') | strcmp(var,'mm') | strcmp(var,'ss') | strcmp(var,'nrec')),
	else
		cmd=sprintf('[outf.dt,outf.%s]=FillTimeSeries1sec(%s.dt,%s.%s,deltsec,dt1,dt2);',var,arrayname,arrayname,var);
		disp(cmd);
		eval(cmd);
	end
end

[outf.yyyy,outf.MM,outf.dd,outf.hh,outf.mm,outf.ss]=datevec(outf.dt);
eval(sprintf('outf.vars=%s.vars;',arrayname))


return;


%[dtx,px]=FillTimeSeries1sec(nav.dt,nav.pitch,1,dt1,dt2);