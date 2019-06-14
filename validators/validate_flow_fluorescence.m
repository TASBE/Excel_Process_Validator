function valid = validate_flow_fluorescence(fluorescence_experiment)

valid = true;

% ignoring bead_model, bead_lot, bead_units, peak_MEFL as created from catalog
    {'peak_MEFL',           'Bead Calibration', 'B9:I9'};
    {'peak_MEFL_per_au',    'Bead Calibration', 'B10:I10'};
    {'MEFL_per_au',         'Bead Calibration', 'C11'};

%%% Check that the max / min non-NaN fluorescein calibration values are at least a reasonable minimum range
au_range = max(fluorescence_experiment.peak_au(:)) / min(fluorescence_experiment.peak_au(:));
MIN_FLUORESCEIN_RANGE = 20;
if au_range < MIN_FLUORESCEIN_RANGE || isnan(au_range)
    EPVSession.warn('FlowFluorescence','DynamicRange','Dynamic range of bead calibration values %.2f is not at least %i-fold',au_range,MIN_FLUORESCEIN_RANGE);
    valid = false;
else
    EPVSession.succeed('FlowFluorescence','DynamicRange','Sufficient dynamic range of bead calibration values: %.2f',au_range);
end

% make sure that non-NAN peak_MEFL_per_au values are similar

MAXIMUM_MEFL_VARIATION = 1.5;
max_MEFL_per_au = max(fluorescence_experiment.peak_MEFL_per_au(:));
min_MEFL_per_au = min(fluorescence_experiment.peak_MEFL_per_au(:));
MEFL_per_au_range = max_MEFL_per_au / min_MEFL_per_au;
if MEFL_per_au_range > MAXIMUM_MEFL_VARIATION || isnan(MEFL_per_au_range)
    EPVSession.warn('FlowFluorescence','ConversionRange','Range of peak conversion ratios not less than %.1f-fold (range: %.2f to %.2f)',MAXIMUM_MEFL_VARIATION,min_MEFL_per_au,max_MEFL_per_au);
    valid = false;
else
    EPVSession.succeed('FlowFluorescence','ConversionRange','Peak conversion ratios are sufficiently close, range: %.2f to %.2f',min_MEFL_per_au,max_MEFL_per_au);
end

%%% Check that some positive value was obtained for conversion
if ~(fluorescence_experiment.MEFL_per_au > 0)
    EPVSession.warn('FlowFluorescence','PositiveScalingFactor','Computed mean MEFL / a.u. is not positive');
    valid = false;
else
    EPVSession.succeed('FlowFluorescence','PositiveScalingFactor','Computed mean MEFL / a.u. is positive');
end

% Final report on validity:
if ~valid
    EPVSession.warn('FlowFluorescence','Validation',' Validation failed for fluorescence');
else
    EPVSession.succeed('FlowFluorescence','Validation','All validation checks passed for fluorescence');
end

end

