function test_suite = test_utilities
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions=localfunctions();
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    % make the warnings less verbose for easier debugging
    save_warning_state = warning('off','backtrace');
    try
        initTestSuite;
    end
    warning(save_warning_state);

    
function test_longest_true_stretch

assertEqual(logical([0 0 1 1 1 0 0 0]),longest_true_stretch([0 0 1 1 1 0 0 0]));
assertEqual(logical([0 0 0 0 0 0 0 0]),longest_true_stretch([0 0 0 0 0 0 0 0]));
assertEqual(logical([1 1 1 1 1 1 1 1]),longest_true_stretch([1 1 1 1 1 1 1 1]));
assertEqual(logical([0 0 1 1 1 0 0 0]),longest_true_stretch([1 0 1 1 1 0 0 0]));
assertEqual(logical([0 0 1 1 1 0 0 0]),longest_true_stretch([0 0 1 1 1 0 1 0]));
assertEqual(logical([0 0 0 1 1 0 0 0]),longest_true_stretch([0 1 0 1 1 0 1 1]));
assertEqual(logical([0 1 1 1 0 0 0 0]),longest_true_stretch([0 1 1 1 0 1 1 0]));
assertEqual(logical([0 0 0 0 1 1 1 0]),longest_true_stretch([0 1 1 0 1 1 1 0]));
assertEqual(logical([0 1 0 0 0 0 0 0]),longest_true_stretch([0 1 0 1 0 1 0 1]));
assertEqual(logical([0 0 0 0 0 1 1 0]),longest_true_stretch([0 1 0 1 0 1 1 0]));
assertEqual(logical([0 0 1 1 1 1 1 1]),longest_true_stretch([0 0 1 1 1 1 1 1]));
assertEqual(logical([1 1 1 1 1 0 0 0]),longest_true_stretch([1 1 1 1 1 0 0 0]));
