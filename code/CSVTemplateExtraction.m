% Class for building a struct from data extracted from a CSV template spreadsheet
%
% Copyright (C) 2019, Raytheon BBN Technologies and contributors listed
% in the AUTHORS file in EPV distribution's top directory.
%
% This file is part of the Excel Process Validator package, and is distributed
% under the terms of the GNU General Public License, with a linking
% exception, as described in the file LICENSE in the BBN Flow Cytometry
% package distribution's top directory.

classdef CSVTemplateExtraction
    methods(Static)
        % Constuctor with filepath of template and optional coordinates
        % property as inputs
        function extracted = extract(file, template)
            % Make sure the file exists
            if ~exist(file,'file')
                EPVSession.error('CSVTemplateExtraction','MissingFile','Could not find CSV file %s',file);
            end
            EPVSession.succeed('CSVTemplateExtraction','FoundFile','Found CSV file %s',file);
            
            % validate that template is intact
            cache = CSVTemplateExtraction.checkTemplateIntegrity(file, template);
            
            % read the variables of the template
            extracted = CSVTemplateExtraction.retrieveVariables(file, template, cache);
            
            % postprocess if needed
            if isfield(template,'postprocessing')
                try
                    extracted = template.postprocessing(extracted);
                    EPVSession.succeed('CSVTemplateExtraction','Postprocessing','CSV file postprocessing succeeded');
                catch e
                    EPVSession.error('CSVTemplateExtraction','FailedPostprocessing','CSV file postprocessing error');
                end
            end
        end
        
    end
    
    methods(Static,Hidden)
        function extracted = retrieveVariables(file, template, cache)
            extracted = struct();
            failed = false;
            for i=1:numel(template.variables)
                try 
                    var = template.variables{i};
                    % get the type of the variable
                    if numel(var)<3, type = 'number'; else type = var{3}; end;
                    % TODO: figure out how to deal with the fact that octave strips blank rows on read, thus shrinking the size of the range being read
                    raw = CSVTemplateExtraction.readCSVFromCache(cache,var{2});
                    % check what size the raw should be, and expand if needed (for octave, which strips blank rows)
                    block_size = CSVTemplateExtraction.excelRangeSize(var{2});
                    read_size = size(raw);
                    %fprintf('Range %s is %i by %i\n',var{3},block_size(1),block_size(2));
                    if numel(raw) < prod(block_size)
                        %fprintf('Resizing %s from %ix%i to %ix%i\n',var{1},size(raw,1),size(raw,2),block_size(1),block_size(2));
                        for r = (read_size(1)+1):block_size(1),
                            for c = 1:block_size(2),
                                raw{r,c} = nan;
                            end
                        end
                        for r = 1:block_size(1),
                            for c = (read_size(2)+1):block_size(2),
                                raw{r,c} = nan;
                            end
                        end
                    end
                    % turn empty cells into NaNs (for octave)
                    for j=1:numel(raw), if isempty(raw{j}), raw{j} = NaN; end; end;
                    switch type
                        case 'number'
                            converted = zeros(size(raw));
                            for j=1:numel(raw), 
                                if isnumeric(raw{j}), converted(j)=raw{j}; 
                                % check for the various non-numeric placeholders
                                elseif strcmp(raw{j},'---'), converted(j)=NaN;
                                elseif strcmp(raw{j},'#VALUE!'), converted(j)=NaN;
                                elseif strcmp(raw{j},'#DIV/0!'), converted(j)=NaN;
                                elseif strcmp(raw{j},'Overflow'), converted(j)=NaN;
                                else
                                    EPVSession.warn('CSVTemplateExtraction','NonNumericValue','Numeric variable %s from range %s contains non-numeric value ''%s'' (permitted non-numeric values are: ---, #VALUE!, #DIV/0!, Overflow)',var{1},var{2},raw{j});
                                    failed = true;
                                end;
                            end
                        case 'string'
                            converted = cell(size(raw));
                            for j=1:numel(raw), 
                                if isnumeric(raw{j}), converted{j}=num2str(raw{j}); 
                                else converted{j}=raw{j};  
                                end;
                            end
                        otherwise
                            EPVSession.error('CSVTemplateExtraction','BadRangeType','Variable %s from range %s has unknown type ''%s''',var{1},var{2},type);
                    end
                    extracted.(var{1}) = converted;
                catch e
                    EPVSession.warn('CSVTemplateExtraction','FailedRangeRead','Unable to read %s variable %s from range %s',type,var{1},var{2});
                    failed = true;
                end
            end
            if failed,
                EPVSession.error('CSVTemplateExtraction','FailedExtraction','Some variables were unable to be read');
            end
            EPVSession.succeed('CSVTemplateExtraction','Extraction','All variables were extracted');
        end
        
        function cache = checkTemplateIntegrity(file, template)
            % CSV has only one sheet, so we can just read it directly
            cache = CSVTemplateExtraction.readCSVlikeExcel(file);
            
            %%% confirm that all expected fixed sections of the sheets match the blank template file
            % first, load the blank
            if ~exist(template.blank_file,'file')
                EPVSession.error('CSVTemplateExtraction','MissingTemplateFile','Internal error: missing blank template file %s',template.blank_file);
            else
                if is_octave()
                    effective_blank = file_in_loadpath(template.blank_file);
                else
                    effective_blank = template.blank_file;
                end
                blank_cache = CSVTemplateExtraction.readCSVlikeExcel(effective_blank);
            end
            
            failed = false;
            for i=1:numel(template.fixed_values)
                ranges = template.fixed_values{i}(1:end);
                for j=1:numel(ranges)
                    blank_raw = CSVTemplateExtraction.readCSVFromCache(blank_cache,ranges{j});
                    raw = CSVTemplateExtraction.readCSVFromCache(cache,ranges{j});
                    if ~CSVTemplateExtraction.excelRangeEqual(raw,blank_raw)
                        failed = true;
                        EPVSession.warn('CSVTemplateExtraction','ModifiedTemplateRange','Template appears to have been modified: range %s does not match blank',ranges{j});
                    end
                end
            end
            if failed,
                EPVSession.error('CSVTemplateExtraction','ModifiedTemplate','Template appears to have been modified - some ranges that are expected to be fixed do not match');
            end
            EPVSession.succeed('CSVTemplateExtraction','ValidTemplate','Template appears to be intact');
        end
        
        % Internal check to see if two number/string regions are identical
        function same = excelRangeEqual(raw1,raw2)
            same = false;
            % sizes must be the same
            if ~isempty(find(size(raw1)~=size(raw2),1)), return; end;
            % every element must be the same
            for i=1:numel(raw1)
                if isempty(raw1{i}) || isempty(raw2{i}) % handle emptiness separately, since tests don't work right 
                    if ~isempty(raw1{i}) && isempty(raw2{i}), return; end;
                elseif isnumeric(raw1{i}) && isnumeric(raw2{i})
                    if isnan(raw1{i}) && isnan(raw2{i}), continue; end; % nan's aren't ==, but match
                    if raw1{i} ~= raw2{i}, return; end;
                elseif ischar(raw1{i}) && ischar(raw2{i})
                    if ~strcmp(raw1{i},raw2{i}), return; end;
                else % mismatched types
                    return;
                end
            end
            % if we passed everything, they are the same
            same = true;
        end
        
        % turn an Excel range string into dimensions
        function dim = excelRangeSize(range)
            separators = find(range==':'); % find the colon separators
            if numel(separators) == 0 % no separator --> single cell
                dim = [1 1];
            elseif numel(separators) == 1
                r1 = range(1:(separators-1));
                c1 = CSVTemplateExtraction.excelCoordToPoint(r1);
                r2 = range((separators+1):end);
                c2 = CSVTemplateExtraction.excelCoordToPoint(r2);
                dim = [abs(c2(1)-c1(1))+1, abs(c2(2)-c1(2))+1];
            else % can't have more than 1 separator
                EPVSession.error('CSVTemplateExtraction','BadRange','Found more than one '':'' separator in range ''%s''',range);
            end
        end
        
        % Turn an excel coordinate into [[row col] [row col]]
        % Note: this requires the range to be in LT:RB format or a singleton
        function points = excelRangeToPoints(range)
            separators = find(range==':'); % find the colon separators
            if numel(separators) == 0 % no separator --> single cell
                c = CSVTemplateExtraction.excelCoordToPoint(range);
                points = [c c];
            elseif numel(separators) == 1
                r1 = range(1:(separators-1));
                c1 = CSVTemplateExtraction.excelCoordToPoint(r1);
                r2 = range((separators+1):end);
                c2 = CSVTemplateExtraction.excelCoordToPoint(r2);
                points = [c1 c2];
            else % can't have more than 1 separator
                EPVSession.error('CSVTemplateExtraction','BadRange','Found more than one '':'' separator in range ''%s''',range);
            end
        end

        
        % Turn an excel coordinate into [row col]
        function point = excelCoordToPoint(coord)
            try 
                % try a 1-character column name
                components = sscanf(coord,'%c%i');
                % if it fails, try a 2-character column name
                if numel(components)~=2, 
                    components = sscanf(coord,'%c%c%i'); 
                    assert(numel(components)==3);
                    % Assume column is ASCII upcase
                    char1 = components(1)-64; 
                    char2 = components(2)-64;
                    assert(char1>0 && char1<=26 && char2>0 && char2<=26);
                else
                    char1 = 0;
                    char2 = components(1)-64; % Assume column is ASCII upcase
                    assert(char2>0 && char2<=26);
                end;
                point(1) = components(end); % number is the row
                point(2) = char1*26 + char2;
            catch
                EPVSession.error('CSVTemplateExtraction','BadRange','Could not interpret CSV coordinate ''%s''',coord);
            end
        end
        
        function raw = readCSVFromCache(cache,range)
            sheet_raw = cache;
            points = CSVTemplateExtraction.excelRangeToPoints(range);
            % expand sheet if needed
            sheet_size = size(sheet_raw);
            if sheet_size(1)<points(3), sheet_raw((sheet_size(1)+1):points(3),:) = {nan}; end;
            if sheet_size(2)<points(4), sheet_raw(:,(sheet_size(2)+1):points(4)) = {nan}; end;
            raw = sheet_raw(points(1):points(3),points(2):points(4));
        end
        
        function raw = readCSVlikeExcel(filename)
            % output is a cell array
            raw = {};
            % open the file
            fid = fopen(filename,'r');
            % read and process one line at a time
            line = fgetl(fid);
            while ischar(line)
                % split line and convert numeric values
                linecells = strsplit(line,',','CollapseDelimiters',false);
                rawcells = cellfun(@convertIfNumeric,linecells,'UniformOutput',false);
                raw(end+1,1:numel(rawcells)) = rawcells;
                % proceed to next line
                line = fgetl(fid);
            end
            fclose(fid);
        end
    end
end
