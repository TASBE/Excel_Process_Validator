% Copyright (C) 2020, Raytheon BBN Technologies and contributors listed
% in the AUTHORS file in EPV distribution's top directory.
%
% This file is part of the Excel Process Validator package, and is distributed
% under the terms of the GNU General Public License, with a linking
% exception, as described in the file LICENSE in the BBN Flow Cytometry
% package distribution's top directory.

classdef ValidationCatalog
    methods(Static)
        function l = list()
            l = {
                'iGEM Plate Reader Fluorescence v2 - Green/Yellow',       'iGEM_2019_plate_reader_fluorescence_v2';
                'iGEM Plate Reader Fluorescence v2 - Red',       'iGEM_2019_plate_reader_fluorescence_v2_texas_red';
                'iGEM Plate Reader Abs600'                 'iGEM_2019_plate_reader_abs600';
                'iGEM Flow Cytometer Fluorescence'         'iGEM_2019_flow_cytometer_fluorescence';
                'iGEM Plate Reader Fluorescence v1',       'iGEM_2019_plate_reader_fluorescence';
                'iGEM 2018 Plate Reader Fluorescence'      'iGEM_2018_plate_reader_fluorescence';
            };
        end
        
        function result = iGEM_2019_plate_reader_fluorescence_v2(datafile)
            template = iGEM_2019_plate_reader_fluorescence_v2();
            result = ExcelTemplateExtraction.extract(datafile,template);
            validate_plate_Abs600(result);
            validate_plate_fluorescence(result);
        end
        
        function result = iGEM_2019_plate_reader_fluorescence_v2_texas_red(datafile)
            template = iGEM_2019_plate_reader_fluorescence_v2_texas_red();
            result = ExcelTemplateExtraction.extract(datafile,template);
            validate_plate_Abs600(result);
            validate_plate_fluorescence(result);
        end
        
        function result = iGEM_2019_plate_reader_fluorescence(datafile)
            template = iGEM_2019_plate_reader_fluorescence();
            result = ExcelTemplateExtraction.extract(datafile,template);
            validate_plate_Abs600(result);
            validate_plate_fluorescence(result);
        end
        
        function result = iGEM_2019_plate_reader_abs600(datafile)
            template = iGEM_2019_plate_reader_abs600();
            result = ExcelTemplateExtraction.extract(datafile,template);
            validate_plate_Abs600(result);
        end
        
        function result = iGEM_2019_flow_cytometer_fluorescence(datafile)
            template = iGEM_2019_flow_cytometer_fluorescence();
            result = ExcelTemplateExtraction.extract(datafile,template);
            validate_flow_fluorescence(result);
        end

        function result = iGEM_2018_plate_reader_fluorescence(datafile)
            template = iGEM_2018_plate_reader_fluorescence();
            result = ExcelTemplateExtraction.extract(datafile,template);
            validate_plate_Abs600(result);
            validate_plate_fluorescence(result);
        end

    end
end
