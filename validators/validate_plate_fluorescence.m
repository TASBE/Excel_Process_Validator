function valid = validate_plate_fluorescence(fluorescence_experiment)

valid = true;

%%% Check that the max / min non-NaN fluorescein calibration values are at least a reasonable minimum range
au_range = max(fluorescence_experiment.au_raw(:)) / abs(min(fluorescence_experiment.au_raw(:)));
MIN_FLUORESCEIN_RANGE = 20;
if au_range < MIN_FLUORESCEIN_RANGE || isnan(au_range)
    EPVSession.warn('Fluorescence','DynamicRange','Dynamic range of fluorescein calibration values %.2f is not at least %i-fold',au_range,MIN_FLUORESCEIN_RANGE);
    valid = false;
else
    EPVSession.succeed('Fluorescence','DynamicRange','Sufficient dynamic range of fluorescein calibration values: %.2f',au_range);
end

%%% make sure there is a long-enough portion of close-to-2x slope

% use au_net_mean to determine slope and high saturation
MINIMUM_VALID_SLOPE = 1.5;
strong_dilution_slope = fluorescence_experiment.au_net_mean(1:10)./fluorescence_experiment.au_net_mean(2:11) > MINIMUM_VALID_SLOPE;

% use au_mean, au_std to determine low saturation
STD_DEV_ABOVE_BLANK = 2;
min_usable_mean = fluorescence_experiment.au_mean(12) + fluorescence_experiment.au_std(12) * STD_DEV_ABOVE_BLANK;
distinguished_from_blank = fluorescence_experiment.au_mean(1:11) >= min_usable_mean;

% look for slope between high and low saturation issues
locally_valid_au_dilution = [strong_dilution_slope 1] & distinguished_from_blank;
if sum(locally_valid_au_dilution)==0
    EPVSession.warn('Fluorescence','ValidDilutions','Fluorescein values are all too close to blank or adjacent values');
    valid = false;
else
    first_valid_dilution = find(locally_valid_au_dilution,1);
    last_valid_dilution = find(~locally_valid_au_dilution(first_valid_dilution:end),1)-1;
    if isempty(last_valid_dilution), last_valid_dilution = 11; end; % if there's no zero, all are good
    num_valid_dilutions = last_valid_dilution - first_valid_dilution + 1;
    MINIMUM_VALID_DILUTIONS = 5;
    if num_valid_dilutions < MINIMUM_VALID_DILUTIONS
        EPVSession.warn('Fluorescence','ValidDilutions','Dilution slope found from column %i to %i is less than %i levels',first_valid_dilution,last_valid_dilution,MINIMUM_VALID_DILUTIONS);
        valid = false;
    else
        EPVSession.succeed('Fluorescence','ValidDilutions','Found a sufficiently long fluorescein dilution slope from column %i to %i',first_valid_dilution,last_valid_dilution);
    end
end

% ignore uM_fluorescein, uM_per_au, mean_uM_per_au as just intermediate computation values

%%% Check that some positive value was obtained for conversion
if ~(fluorescence_experiment.MEFL_per_au > 0)
    EPVSession.warn('Fluorescence','PositiveScalingFactor','Computed mean MEFL / a.u. is not positive');
    valid = false;
else
    EPVSession.succeed('Fluorescence','PositiveScalingFactor','Computed mean MEFL / a.u. is positive');
end

% we will ignore as raw or intermediate the experiment_au and experiment_MEFL
% We will also ignore the final experiment_MEFL_per_particle as having no defined range
% TODO: identify positive and negative controls, and make sure their values are reasonable

% Final report on validity:
if ~valid
    EPVSession.warn('Fluorescence','Validation',' Validation failed for fluorescence');
else
    EPVSession.succeed('Fluorescence','Validation','All validation checks passed for fluorescence');
end

end

