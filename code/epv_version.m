% function VERSION = epv_version()
%   returns a cell array of {major minor patch}
%   major and minor are numbers, patch is a string
%
% Copyright (C) 2019, Raytheon BBN Technologies and contributors listed
% in the AUTHORS file in EPV distribution's top directory.
%
% This file is part of the Excel Process Validator package, and is distributed
% under the terms of the GNU General Public License, with a linking
% exception, as described in the file LICENSE in the BBN Flow Cytometry
% package distribution's top directory.

function version = epv_version()

try 
    file = fopen([fileparts(mfilename('fullpath')) '/../version.txt'],'r');
    raw_version = textscan(file,'%s');
    if(numel(raw_version) ~= 1), EPVSession.error('EPV:Version','NotSingleVersion','Could not read single version number from version file.'); return; end;
    raw_version = char(raw_version{1});
    fclose(file);
catch e
    EPVSession.error('EPV:Version','CannotReadVersionFile','Could not read version information from EPV distribution version.txt');
    throw e;
end

strs = strsplit(raw_version,'.');
if(numel(strs) ~= 3), EPVSession.error('EPV:Version','VersionNotSemVer','Version does not follow SemVer convention: %s',raw_version); end;

version = {str2double(strs{1}) str2double(strs{2}) strs{3}};

if(numel(version{1})+numel(version{2}) ~= 2), EPVSession.error('EPV:Version','VersionNotSemVer','Version does not follow SemVer convention: %s',raw_version); end;
