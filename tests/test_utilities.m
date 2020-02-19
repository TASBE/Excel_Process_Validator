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


function test_json_output

expected_json = sprintf(['{\n' ...
'	"bead_model": [\n' ...
'		"SpheroTech RCP-30-5A"\n' ...
'	],\n' ...
'	"bead_lot": [\n' ...
'		"Lot AD04, AE01, AF01, AF02, AH01, AH02, AJ01"\n' ...
'	],\n' ...
'	"bead_units": [\n' ...
'		"MEFL"\n' ...
'	],\n' ...
'	"peak_au": [10299,4936,1732,618,242,"_NaN_","_NaN_","_NaN_"],\n' ...
'	"peak_MEFL": [271771.1895,136680.1428,47575.31353,16530.73814,6561.882626,2083.012349,791.2197976,90.70868864],\n' ...
'	"peak_MEFL_per_au": [26.38811433,27.69046653,27.46842582,26.74876722,27.11521746,"_NaN_","_NaN_","_NaN_"],\n' ...
'	"MEFL_per_au": 27.08219827\n' ...
'}\n']);

result = savejson('',ValidationCatalog.iGEM_2019_flow_cytometer_fluorescence('tests/samples/iGEM 2019 Flow Cytometry Fluorescence Calibration - Example.xlsx'));
assertEqual(expected_json,result);
