function template = iGEM_2019_plate_reader_abs600()

template = struct();

template.variables = {...
    % Particle calibration sheet
    {'Abs600_raw',                  'Particle standard curve', 'B2:M5'};
    {'Abs600_mean',                 'Particle standard curve', 'B6:M6'};
    {'Abs600_std',                  'Particle standard curve', 'B7:M7'};
    {'Abs600_net_mean',             'Particle standard curve', 'B8:L8'};
    {'num_particles',               'Particle standard curve', 'B28:L28'};
    {'particles_per_Abs600',        'Particle standard curve', 'B29:L29'};
    {'mean_particles_per_Abs600',   'Particle standard curve', 'C30'};
    % Raw plate data
    {'experiment_Abs600',           'Raw Plate Reader Measurements', 'B12:M19'};
    {'experiment_blank_wells',      'Raw Plate Reader Measurements', 'D5:D8', 'string'};
    % Calibrated plate data
    {'experiment_particles',        'Equivalent Particle Count', 'B9:M16'};
    {'experiment_net_Abs600',       'Equivalent Particle Count', 'B20:M27'};
    };

template.blank_file = 'iGEM 2019 Plate Reader Abs600 Calibration.xlsx';

template.fixed_values = {...
    % Particle calibration sheet
    {'Particle standard curve', 'A1:N1','A2:A8','M8','A9:N9','N2:N8'};
    {'Particle standard curve', 'A28:M28','A29','M29','A30:B30','D30:M30','A31:M31'};
    {'Particle standard curve', 'R20:T30'};
    % Raw plate data
    {'Raw Plate Reader Measurements', 'A4:I4','A5:C8','E5:G8','H6','H8','I5:I8','A9:I9'};
    {'Raw Plate Reader Measurements', 'A11:N11','A12:A19','N12:N19','A20:N20'};
    % Calibrated plate data
    {'Equivalent Particle Count', 'A1:E1','A2:C4','E2:E4','A5:E5'};
    {'Equivalent Particle Count', 'A8:A28','N8:N28','B8:M8','B17:M19','B28:M28'};
    };

