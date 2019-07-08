function valid = validate_plate_Abs600(abs600_experiment)

valid = true;

%%% Check that the max / min non-NaN particle calibration values are at least a reasonable minimum range
abs600_range = max(abs600_experiment.Abs600_raw(:)) / abs(min(abs600_experiment.Abs600_raw(:)));
MIN_PARTICLE_RANGE = 20;
if abs600_range < MIN_PARTICLE_RANGE || isnan(abs600_range)
    EPVSession.warn('Abs600','DynamicRange','Dynamic range of Abs600 calibration values %.2f is not at least %i-fold',abs600_range,MIN_PARTICLE_RANGE);
    valid = false;
else
    EPVSession.succeed('Abs600','DynamicRange','Sufficient dynamic range of Abs600 calibration values: %.2f',abs600_range);
end

%%% make sure there is a long-enough portion of close-to-2x slope

% use Abs600_net_mean to determine slope and high saturation
MINIMUM_VALID_SLOPE = 1.5;
strong_dilution_slope = abs600_experiment.Abs600_net_mean(1:10)./abs600_experiment.Abs600_net_mean(2:11) > MINIMUM_VALID_SLOPE;

% use Abs600_mean, Abs600_std to determine low saturation
STD_DEV_ABOVE_BLANK = 2;
min_usable_mean = abs600_experiment.Abs600_mean(12) + abs600_experiment.Abs600_std(12) * STD_DEV_ABOVE_BLANK;
distinguished_from_blank = abs600_experiment.Abs600_mean(1:11) >= min_usable_mean;

% look for slope between high and low saturation issues
locally_valid_particle_dilution = [strong_dilution_slope 1] & distinguished_from_blank;
if sum(locally_valid_particle_dilution)==0
    EPVSession.warn('Abs600','ValidDilutions','Particle values are all too close to blank or adjacent values');
    valid = false;
else
    first_valid_dilution = find(locally_valid_particle_dilution,1);
    last_valid_dilution = find(~locally_valid_particle_dilution(first_valid_dilution:end),1)-1;
    if isempty(last_valid_dilution), last_valid_dilution = 11; end; % if there's no zero, all are good
    num_valid_dilutions = last_valid_dilution - first_valid_dilution + 1;
    MINIMUM_VALID_DILUTIONS = 5;
    if num_valid_dilutions < MINIMUM_VALID_DILUTIONS
        EPVSession.warn('Abs600','ValidDilutions','Dilution slope found from column %i to %i is less than %i levels',first_valid_dilution,last_valid_dilution,MINIMUM_VALID_DILUTIONS);
        valid = false;
    else
        EPVSession.succeed('Abs600','ValidDilutions','Found a sufficiently long particle dilution slope from column %i to %i',first_valid_dilution,last_valid_dilution);
    end
end

% ignore num_particles, particles_per_Abs600 as just intermediate computation values

%%% Check that some positive value was obtained for conversion
if ~(abs600_experiment.mean_particles_per_Abs600 > 0)
    EPVSession.warn('Abs600','PositiveScalingFactor','Computed mean particles / Abs600 is not positive');
    valid = false;
else
    EPVSession.succeed('Abs600','PositiveScalingFactor','Computed mean particles / Abs600 is positive');
end

%%%
% make sure cells have grown sufficiently by comparing with experiment blank wells
% TODO: restrict this to only the control wells
%
% use experiment_blank_wells to exclude values for checking from experiment_particles
rownames = [abs600_experiment.experiment_blank_wells{1} abs600_experiment.experiment_blank_wells{3}];
if is_octave()
    Brow = unicode2utf8(rownames)-64;
else
    Brow = unicode2native(rownames)-64;
end    
Bcol = cellfun(@str2num,{abs600_experiment.experiment_blank_wells{2} abs600_experiment.experiment_blank_wells{4}});
blanks = abs600_experiment.experiment_particles(min(Brow):max(Brow),min(Bcol):max(Bcol));
sans_blanks = abs600_experiment.experiment_particles;
sans_blanks(min(Brow):max(Brow),min(Bcol):max(Bcol)) = NaN;

blank_noise_floor = std(blanks(:))*STD_DEV_ABOVE_BLANK;
MIN_GROWTH_OVER_BLANK = 10;
poorly_grown_wells = sans_blanks < MIN_GROWTH_OVER_BLANK*blank_noise_floor;
num_poorly_grown_wells = sum(poorly_grown_wells(:));

if num_poorly_grown_wells > 0
    EPVSession.warn('Abs600','CellGrowth','Found %i wells with apparently low cell counts',num_poorly_grown_wells);
    valid = false;
else
    EPVSession.succeed('Abs600','CellGrowth','All non-blank wells show significant cell counts');
end

% we will ignore as raw or intermediate the experiment_Abs600 and experiment_net_Abs600

% Final report on validity:
if ~valid
    EPVSession.warn('Abs600','Validation',' Validation failed for Abs600');
else
    EPVSession.succeed('Abs600','Validation','All validation checks passed for Abs600');
end

end
