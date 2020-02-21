function template = iGEM_2019_plate_reader_fluorescence_v2_texas_red()

template = struct();

template.parameters = struct();
template.parameters.fluorescence_unit = 'METR';

template.variables = {...
    % Particle calibration sheet
    {'Abs600_raw',                  'Particle standard curve', 'B2:M5'};
    {'Abs600_mean',                 'Particle standard curve', 'B6:M6'};
    {'Abs600_std',                  'Particle standard curve', 'B7:M7'};
    {'Abs600_net_mean',             'Particle standard curve', 'B8:L8'};
    {'num_particles',               'Particle standard curve', 'B28:L28'};
    {'particles_per_Abs600',        'Particle standard curve', 'B29:L29'};
    {'mean_particles_per_Abs600',   'Particle standard curve', 'C30'};
    % Fluorescein calibration sheet
    {'au_raw',                      'Fluorescein standard curve', 'B2:M5'};
    {'au_mean',                     'Fluorescein standard curve', 'B6:M6'};
    {'au_std',                      'Fluorescein standard curve', 'B7:M7'};
    {'au_net_mean',                 'Fluorescein standard curve', 'B8:L8'};
    {'uM_fluorescein',              'Fluorescein standard curve', 'B28:L28'};
    {'uM_per_au',                   'Fluorescein standard curve', 'B29:L29'};
    {'mean_uM_per_au',              'Fluorescein standard curve', 'C30'};
    {'MEx_per_au',                  'Fluorescein standard curve', 'C31'};
    % Raw plate data
    {'experiment_Abs600',           'Raw Experimental Measurements', 'B12:M19'};
    {'experiment_au',               'Raw Experimental Measurements', 'B24:M31'};
    {'experiment_blank_wells',      'Raw Experimental Measurements', 'D5:D8', 'string'};
    % Calibrated plate data
    {'experiment_MEx_per_particle', 'Expt. Fluorescence per Particle', 'B12:M19'};
    {'experiment_particles',        'Expt. Fluorescence per Particle', 'B23:M30'};
    {'experiment_net_Abs600',       'Expt. Fluorescence per Particle', 'B34:M41'};
    {'experiment_MEx',              'Expt. Fluorescence per Particle', 'B45:M52'};
    };

template.blank_file = 'iGEM 2019 Plate Reader Fluorescence Calibration v2_Texas Red.xlsx';

template.fixed_values = {...
    % Particle calibration sheet
    {'Particle standard curve', 'A1:N1','A2:A8','M8','A9:N9','N2:N8'};
    {'Particle standard curve', 'A28:M28','A29','M29','A30:B30','D30:M30','A31:M31'};
    {'Particle standard curve', 'R20:T30'};
    % Fluorescein calibration sheet
    {'Fluorescein standard curve', 'A1:N1','A2:A8','M8','A9:N9','N2:N8'};
    {'Fluorescein standard curve', 'A28:M28','A29','M29','A30:B31','D30:M31','A32:M32'};
    {'Fluorescein standard curve', 'R21:T26'};
    % Raw plate data
    {'Raw Experimental Measurements', 'A4:I4','A5:C8','E5:G8','I5:I8','A9:I9'};
    {'Raw Experimental Measurements', 'A11:N11','A12:A19','N12:N19','A20:N20'};
    {'Raw Experimental Measurements', 'A23:N23','A24:A31','N24:N31','A32:N32'};
    % Calibrated plate data
    {'Expt. Fluorescence per Particle', 'A1:E1','A2:C7','E2:E7','A8:E8'};
    {'Expt. Fluorescence per Particle', 'A11:A53','N11:N53','B11:M11','B20:M22','B31:M33','B42:M44','B53:M53'};
    };

