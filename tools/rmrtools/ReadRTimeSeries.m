% THIS IS NOT A FUNCTION-- BUT A SCRIPT TO EXTRACT TIME SERIES
% VARIABLES AND TIME, dt, FROM RMR TIME SERIES FORMAT.
%
% BEFORE CALLING enter
%    filename = 'path/filename';
% OPTION ENTER 
%   nskip if there are more than one header lines before the variable record.
%   arrayname = the name of the output array, 
%
%	ReadRTimeSeries
%
% First line = var list of nvar variables AND includes yyyy MM dd hh mm ss
% nrec next lines are nvar columns of nrec data points.
%input
%  file name
%output
%  nvars = the number of variables in the header line
%  array.var = each variable as a n x 1 vector;
%  array.dt = dt = datenum(yyyy,MM,dd,hh,mm,ss);

%clear
%filename = 'avg_raw_2therm.txt';

if exist('nskip','var'), c = ReadRText(filename, nskip);
else c = ReadRText(filename);
end


%====================================
% SEPARATE OUT EACH VARIABLE
%====================================
nvars = length(c{1});
if exist('arrayname','var'), 
	eval(sprintf('%s.vars='''';',arrayname));
else
	vars='';
end

for i=1:nvars,
	%fprintf('%2d %s\n',i, c{1}{i});
	cmd = sprintf('a = c{2}(:,%d);', i);
	eval(cmd);
	%==============
	% CONVERT 'MISSING' TO NAN
	%==============
	if exist('arrayname','var'), 
		cmd=sprintf('%s.%s = CleanSeries(a,[-998,inf]);',arrayname,c{1}{i});
		eval(sprintf('%s.vars=str2mat(%s.vars,''%s'');',arrayname,arrayname,c{1}{i}));
	else cmd=sprintf('%s = CleanSeries(a,[-998,inf]);',c{1}{i});
	end
	%disp(cmd);
	eval(cmd);
end

if exist('arrayname','var'), 
	eval(sprintf('if %s.yyyy < 1900, %s.yyyy = %s.yyyy + 2000; end',arrayname,arrayname,arrayname));
	cmd=sprintf('%s.dt = datenum(%s.yyyy,%s.MM,%s.dd,%s.hh,%s.mm,%s.ss);',arrayname,arrayname,arrayname,arrayname,arrayname,arrayname,arrayname);
	eval(cmd);
	fprintf('ARRAY NAME = %s\n',arrayname);
	eval(sprintf('tsdefine(%s.dt)',arrayname));
else
	if yyyy < 1900, yyyy = yyyy + 2000; end
	dt = datenum(yyyy,MM,dd,hh,mm,ss);
	disp('arrayname is not defined');
	tsdefine(dt);
end	

if exist('arrayname','var'), 
	eval([arrayname,'.vars(1,:)=[];']);
else
	vars(1,:)=[];
end

return;

