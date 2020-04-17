function template = iGEM_2019_flow_cytometer_fluorescence()

template = struct();

template.parameters = struct();

template.variables = {...
    % Particle calibration sheet
    {'bead_model',          'Bead Calibration', 'B2', 'string'};
    {'bead_lot',            'Bead Calibration', 'B3', 'string'};
    {'bead_units',          'Bead Calibration', 'B4', 'string'};
    {'peak_au',             'Bead Calibration', 'B8:I8'};
    {'peak_MEFL',           'Bead Calibration', 'B9:I9'};
    {'peak_MEFL_per_au',    'Bead Calibration', 'B10:I10'};
    {'MEFL_per_au',         'Bead Calibration', 'C11'};
    };

template.blank_file = 'iGEM 2019 Flow Cytometry Fluorescence Calibration.xlsx';

template.fixed_values = {...
    % Bead calibration
    {'Bead Calibration', 'A1:F1','A2:A12','C2:F4','B6:J6','J7:J12','B11','D11:I11','B12:I12'};
    % Bead catalog
    {'Bead Catalog', 'A1:M41'};
    };

