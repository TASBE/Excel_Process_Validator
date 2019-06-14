% Excel class for building a struct from data extracted from a template spreadsheet
%
% Copyright (C) 2019, Raytheon BBN Technologies and contributors listed
% in the AUTHORS file in EPV distribution's top directory.
%
% This file is part of the Excel Process Validator package, and is distributed
% under the terms of the GNU General Public License, with a linking
% exception, as described in the file LICENSE in the BBN Flow Cytometry
% package distribution's top directory.

classdef TemplateExtraction
    methods(Static)
        % Constuctor with filepath of template and optional coordinates
        % property as inputs
        function extracted = extract(file, template)
            % Make sure the file exists
            if ~exist(file,'file')
                EPVSession.error('TemplateExtraction','MissingFile','Could not find Excel file %s',file);
            end
            EPVSession.succeed('TemplateExtraction','FoundFile','Found excel file %s',file);
            
            % validate that template is intact
            TemplateExtraction.checkTemplateIntegrity(file, template);
            
            % read the variables of the template
            extracted = TemplateExtraction.retrieveVariables(file, template);
        end
        
    end
    
    methods(Static,Hidden)
        function extracted = retrieveVariables(file, template)
            extracted = struct();
            failed = false;
            for i=1:numel(template.variables)
                try 
                    var = template.variables{i};
                    % get the type of the variable
                    if numel(var)<4, type = 'number'; else type = var{4}; end;
                    [~,~,raw] = xlsread(file,var{2},var{3});
                    switch type
                        case 'number'
                            converted = zeros(size(raw));
                            for j=1:numel(raw), 
                                if isnumeric(raw{j}), converted(j)=raw{j}; 
                                elseif strcmp(raw{j},'---'), converted(j)=NaN;
                                else
                                    EPVSession.warn('TemplateExtraction','NonNumericValue','Numeric variable %s from sheet ''%s'' range %s contains non-numeric value ''%s''',var{1},var{2},var{3},raw{j});
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
                            EPVSession.error('TemplateExtraction','BadRangeType','Variable %s from sheet ''%s'' range %s has unknown type ''%s''',var{1},var{2},var{3},type);
                    end
                    extracted.(var{1}) = converted;
                catch
                    EPVSession.warn('TemplateExtraction','FailedRangeRead','Unable to read %s variable %s from sheet ''%s'' range %s',type,var{1},var{2},var{3});
                    failed = true;
                end
            end
            if failed,
                EPVSession.error('TemplateExtraction','FailedExtraction','Some variables were unable to be read');
            end
            EPVSession.succeed('TemplateExtraction','Extraction','All variables were extracted');
        end
        
        function sheets = checkTemplateIntegrity(file, template)
            % confirm all sheets are present
            var_sheets = cellfun(@(x)(x{2}),template.variables,'UniformOutput',0);
            fix_sheets = cellfun(@(x)(x{1}),template.fixed_values,'UniformOutput',0);
            sheets = unique([var_sheets; fix_sheets]);
            
            missing_sheets = '';
            for i=1:numel(sheets),
                try
                    xlsread(file, sheets{i}); % no use for answer, just want to see what comes out
                catch
                    if isempty(missing_sheets), connector = ''; else connector = ', '; end;
                    missing_sheets = sprintf('%s%s''%s''',missing_sheets,connector,sheets{i});
                end
            end
            if ~isempty(missing_sheets)
                EPVSession.error('TemplateExtraction','MissingSheets','In %s, could not find expected sheet(s): %s',file, missing_sheets);
            end
            EPVSession.succeed('TemplateExtraction','ValidSheets','All expected sheets are present');
            
            % confirm that all expected fixed sections of the sheets match the blank template file
            if ~exist(template.blank_file,'file')
                EPVSession.error('TemplateExtraction','MissingTemplateFile','Internal error: missing blank template file %s',template.blank_file);
            end
            
            failed = false;
            for i=1:numel(template.fixed_values)
                sheet = template.fixed_values{i}{1};
                ranges = template.fixed_values{i}(2:end);
                for j=1:numel(ranges)
                    [~,~,blank_raw] = xlsread(template.blank_file,sheet,ranges{j});
                    [~,~,raw] = xlsread(file,sheet,ranges{j});
                    if ~TemplateExtraction.excelRangeEqual(raw,blank_raw)
                        failed = true;
                        EPVSession.warn('TemplateExtraction','ModifiedTemplateRange','Template appears to have been modified: sheet ''%s'' range %s does not match blank',sheet,ranges{j});
                    end
                end
            end
            if failed,
                EPVSession.error('TemplateExtraction','ModifiedTemplate','Template appears to have been modified - some ranges that are expected to be fixed do no match');
            end
            EPVSession.succeed('TemplateExtraction','ValidTemplate','Template appears to be intact');
        end
        
        % Internal check to see if two number/string regions are identical
        function same = excelRangeEqual(raw1,raw2)
            same = false;
            % sizes must be the same
            if ~isempty(find(size(raw1)~=size(raw2),1)), return; end;
            % every element must be the same
            for i=1:numel(raw1)
                if isnumeric(raw1{i}) && isnumeric(raw2{i})
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
    end
end
