% Model for fitting the two expected sources of error in a serial dilution:
% 1. Pipetting bias - beta (consistent +/- of volume)
% 2. Pipetting variability - epsilon (random +/- of volume)
%
% Pipettes are expected to comply with ISO8655.
% This is typically around beta = 0.01, epsilon = 0.005
% though the exact value vary by pipette size: bigger pipettes are tighter.
% Moreover, if you're using a large pipette to move small volume, you can
% end up with significantly higher error.
% Human error, of course, can significantly amplify this.
% For volumes in this study, we'd likely expect a rate of:
%    beta = 0.005 - 0.03, epsilon = 0.002 - 0.01
% and maybe several times that depending on the humans involved

classdef SerialDilution
    properties
        beta = []; % beta = pipetting bias [-1 .. 1] - fraction of extra volume pipetted
        epsilon = []; % epsilon = std.dev. of normal random variability in pipetting [0 .. 1]
        dose = [] % dose = initial dose (which is expected_first_well/(1-alpha)
        n = 10; % n = number of halvings (default 10); n+1 values in total
        alpha = 0.5 % alpha = fraction intended to pipette [0 .. 1]
    end
    methods(Static)
        % Fit a serial dilution model
        %    unbiased random error (epsilon) is omitted to allow convergence
        % Inputs:
        %  data = observed values
        %  which = ignore error from all values where "which" is false
        %  dose = initial dose
        %  alpha (optional) = fraction intended to pipette (default 0.5)
        % Outputs:
        %  beta = titration bias
        %  scale = conversion factor between data and true concentration
        function [beta, scaling, residual, SD] = fit(data,which,dose,alpha)
            if nargin<4, alpha = 0.5; end;
            fn = @(param)(SerialDilution.titration_error(param(1),10.^param(2),data,which,dose,alpha));
            [beta_scaling, residual] = fminsearch(fn,[0,2]);
            beta = beta_scaling(1); scaling = 10.^beta_scaling(2);
            SD = SerialDilution(beta,0,dose,numel(data)-1,alpha);
        end
        
        % err = titration_error(beta,epsilon,scale,data,which)
        function err = titration_error(beta,scale,data,which,dose,alpha)
            %fprintf('Checking: %.2e %.2e\n',beta,scale);
            SD = SerialDilution(beta,0,dose,numel(data)-1,alpha);
            model = SD.sample();
            % sum squared error on log scale for selected data points only
            err = sum(abs(log10(model(which) ./ (data(which)'*scale))).^2);
        end
    end
    methods
        function SD = SerialDilution(beta, epsilon, dose, n, alpha)
            SD.beta = beta;
            SD.epsilon = epsilon;
            SD.dose = dose;
            if nargin>=3, SD.n = n; end
            if nargin>=4, SD.alpha = alpha; end
        end
        
        % Tale random samples of the error distribution of this serial dilution model
        function [obtained,expected] = sample(SD,k)
            if nargin<2, k=1; end
            
            steps = 1:(SD.n+1);
            expected = SD.dose * SD.alpha.^steps;

            obtained = zeros(numel(expected),1);
            for i=steps
                fraction = SD.alpha + SD.beta + SD.epsilon*randn(k,1);
                obtained(i) = SD.dose * (1 - fraction);
                SD.dose = SD.dose*fraction;
            end
        end
    end
end
