function C = ReadRText(filename, nskip);
% READ R TEXT FILE
% First line = var list of nvar variables
% nrec next lines are nvar columns of nrec data points.
%input
%  file name
%  nskip = number of header lines to skip. 
%    default nskip=1.
%	 if nskip > 1 we assume the nskip_th line has the variable names
%output
%  C{1} is the cell array of variable names
%  C{2} is the nrec x nvar array.
%TYPICAL USE
%c=ReadRText(fl1);
%nvars = length(c{1});
%for i=1:nvars,
%	fprintf('%2d %s\n',i, c{1}{i});
%	cmd = sprintf('%s = c{2}(:,%d);', c{1}{i}, i);
%	eval(cmd);
%end


%clear
%filename = 'isar_raw_soes_flat.txt';

missing = -999;

cmd=sprintf('F=fopen(''%s'');',filename);
disp(cmd); eval(cmd);

if nargin > 1,
	fprintf('SKIP FIRST %d LINES\n', nskip);
	for i = 1:nskip, str=fgetl(F); disp(str); end
end
str = fgetl(F);
disp(str);

str=strtrim(str);
disp(str);
vars = regexp(str,'\s+','split');
nvars = length(vars);
for i=1:nvars
	fprintf('%3d %s\n', i, vars{i});
end

a = fscanf(F, '%f', [nvars,inf]);
a=a';

C = { vars, a };

fprintf('ReadRText returns %d variables and %d points\n', length(vars), length(a(:,1)));

return;

