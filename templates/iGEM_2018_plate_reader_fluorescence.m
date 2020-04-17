function template = iGEM_2018_plate_reader_fluorescence()

template = struct();

template.parameters = struct();
template.parameters.fluorescence_unit = 'MEFL';

template.variables = {...
    % LUDOX calibration sheet
    {'LUDOX_Abs600',                'OD600 reference point', 'B2:B5'};
    {'water_Abs600',                'OD600 reference point', 'C2:C5'};
    {'LUDOX_mean',                  'OD600 reference point', 'B6'};
    {'water_mean',                  'OD600 reference point', 'C6'};
    {'net_Abs600',                  'OD600 reference point', 'B7'};
    {'reference_OD600',             'OD600 reference point', 'B8'};
    {'OD600_per_Abs600',            'OD600 reference point', 'B9'};
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
    {'MEx_per_au',                 'Fluorescein standard curve', 'C31'};
    % Raw plate data
    {'experiment_Abs600',           'Raw Plate Reader Measurements', 'M17:U24'};
    {'experiment_au',               'Raw Plate Reader Measurements', 'B17:J24'};
    % Calibrated plate data
    {'experiment_uM_per_OD',        'Fluorescence per OD', 'B20:I27'};
    {'experiment_MEx_per_particle','Fluorescence per Particle', 'B20:I27'};
    {'experiment_net_au',           'Fluorescence per Particle', 'K20:R27'};
    {'experiment_net_Abs600',       'Fluorescence per Particle', 'T20:AA27'};
    };

template.blank_file = 'InterLab_2018_PlateReader.xlsx';

template.fixed_values = {...
    % LUDOX calibration sheet
    {'OD600 reference point', 'A1:D1','A2:A9','A10:D10','C7:C9','D2:D9'};
    % Particle calibration sheet
    %{'Particle standard curve', 'A1:N1'};
    {'Particle standard curve', 'A2:A8','M8','A9:N9','N2:N8'};
    %{'Particle standard curve', 'A28:M28'};
    {'Particle standard curve', 'A29','M29','A30:B30','D30:M30','A31:M31'};
    %{'Particle standard curve', 'R20:T30'};
    % Fluorescein calibration sheet
    %{'Fluorescein standard curve', 'A1:N1'};
    {'Fluorescein standard curve', 'A2:A8','M8','A9:N9','N2:N8'};
    %{'Fluorescein standard curve', 'A28:M28'};
    {'Fluorescein standard curve', 'A29','M29','A30:B31','D30:M31','A32:M32'};
    %{'Fluorescein standard curve', 'R21:T26'};
    % Raw plate data
    {'Raw Plate Reader Measurements', 'A16:V16','A17:A24','K17:L24','V17:V24','A25:V25'};
    % Calibrated plate data
    {'Fluorescence per Particle', 'A19:AB19','A20:A27','J20:J27','S20:S27','AB20:AB27','A28:AB28'};
    {'Fluorescence per OD', 'A19:AB19','A20:A27','J20:J27','S20:S27','AB20:AB27','A28:AB28'};
    };

