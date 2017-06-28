function [str,nline, nposition] = FindTxtLine(FILEID, strin)
%function [str,nline, nposition] = FindTxtLine(FILEID, strin)
%======================================================
% The text file with handle FILEID is read line by line to find the 
% first line that contains the string 'strin'.
% Be sure to rewind first to search the entire file
%
% Returns str = nan if the search fails
%=======================================================
 
nline = 0;
str = NaN;
nposition = [];
nc = [];

while ~feof(FILEID),
    s = fgetl(FILEID);
    nline = nline + 1;
    %fprintf('%s\n',s);
    if length(s) >= length(strin),
        %fprintf('  length okay...\n');
        nposition = findstr(s,strin);

        if ~isempty(nposition),
            %fprintf('   String found on line %d, end search\n',nline);
            str = s;
            break;
        end
    end
end

return

        
