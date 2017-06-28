%THIS IS NOT A FUNCTION
% Before calling: 
% 1. define the R data array. As produced by the ReadRTimeSeries script.
%    use 'arrayname=...' to put the R array into a structure array.
% 2. Are there non-monotonic time poiints? Use tsdefine(arrayname.dt)
% 3. If so then call: [tg,ib]=TimeBaseJump(arrayname.dt);
% 		where
% 		arrayname = the name of the array currently in memory.
%		tg = datenum array that is now monotonic.
%		ibad = the array of points to remove.
% 4. Then call this routine:
%	MakeRMonotonic
%Make the structure array 'arrayname' time monotonic. Return a new array
%named 'aname'.
%INPUT

cmd=sprintf('[tgood,ibad] = TimeBaseJump(%s.dt);',arrayname);
disp(cmd);
eval(cmd);
eval([arrayname,'.dt=tgood;']);
eval(['vars=',arrayname,'.vars;']);
nv=length(vars);
for i=1:nv,
	v=deblank(vars(i,:));
	%fprintf('edit %s\n', v);
	eval([arrayname,'.',v,'(ibad)=[];']);
end

