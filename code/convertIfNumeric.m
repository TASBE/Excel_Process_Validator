function out = convertIfNumeric(str)

out = str2num(str);
if isempty(out), out = str; end;
