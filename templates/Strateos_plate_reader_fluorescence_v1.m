function template = Strateos_plate_reader_fluorescence_v1()

template = struct();

template.variables = {...
    % Fluorescein calibration sheet
    {'au_raw',                      'C2:C49'};
    };

template.blank_file = 'Strateos plate reader fluorescence v1.csv';

template.fixed_values = {...
    {'A1:K1','A51:K51','B2:B50','F2:K50'};
    };

template.postprocessing = @Strateos_plate_reader_fluorescence_reshaping;

function fluorescence_experiment = Strateos_plate_reader_fluorescence_reshaping(raw_fluorescence_experiment)
% reshape the raw read into the expected 4x12 shape
fluorescence_experiment.au_raw = reshape(raw_fluorescence_experiment.au_raw,[12 4])';

% compute derived statistics
fluorescence_experiment.au_mean = mean(fluorescence_experiment.au_raw);
fluorescence_experiment.au_std = std(fluorescence_experiment.au_raw);
fluorescence_experiment.au_net_mean = fluorescence_experiment.au_mean(1:end-1)-fluorescence_experiment.au_mean(end);

% compute conversion factor
fluorescein_uM = [25.0 12.5 6.25 3.125 1.5625];
MEFL_per_uM = 6.02e13;

fluorescence_experiment.uM_per_au = mean(fluorescein_uM ./ fluorescence_experiment.au_net_mean(2:6));
fluorescence_experiment.MEFL_per_au = fluorescence_experiment.uM_per_au * MEFL_per_uM;
