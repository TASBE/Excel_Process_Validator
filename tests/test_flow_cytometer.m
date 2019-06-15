function test_suite = test_flow_cytometer
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

function test_good_fluorescence_data

testfile = './tests/samples/iGEM 2019 Flow Cytometry Fluorescence Calibration - Example.xlsx';
template = iGEM_2019_flow_cytometer_fluorescence();
result = TemplateExtraction.extract(testfile,template);
validate_flow_fluorescence(result);

log = EPVSession.list();
% check that the right success messages have been created
assertEqual(log{end-1}.contents{end}.classname, 'TemplateExtraction');
assertEqual(log{end-1}.contents{end}.name, 'Extraction');
assertEqual(log{end-1}.contents{end}.type, 'success');

assertEqual(numel(log{end}.contents),4);
assertEqual(log{end}.contents{end-3}.classname, 'FlowFluorescence');
assertEqual(log{end}.contents{end-3}.name, 'DynamicRange');
assertEqual(log{end}.contents{end-3}.type, 'success');
assertEqual(log{end}.contents{end-2}.name, 'ConversionRange');
assertEqual(log{end}.contents{end-2}.type, 'success');
assertEqual(log{end}.contents{end-1}.name, 'PositiveScalingFactor');
assertEqual(log{end}.contents{end-1}.type, 'success');
assertEqual(log{end}.contents{end-0}.name, 'Validation');
assertEqual(log{end}.contents{end-0}.type, 'success');


function test_bad_fluorescence_data

testfile = './tests/samples/Flow-Fluorescence-Bad.xlsx';
template = iGEM_2019_flow_cytometer_fluorescence();
result = TemplateExtraction.extract(testfile,template);
validate_flow_fluorescence(result);

log = EPVSession.list();
% check that the right success messages have been created
assertEqual(log{end-1}.contents{end}.classname, 'TemplateExtraction');
assertEqual(log{end-1}.contents{end}.name, 'Extraction');
assertEqual(log{end-1}.contents{end}.type, 'success');

assertEqual(numel(log{end}.contents),4);
assertEqual(log{end}.contents{end-3}.classname, 'FlowFluorescence');
assertEqual(log{end}.contents{end-3}.name, 'DynamicRange');
assertEqual(log{end}.contents{end-3}.type, 'failure');
assertEqual(log{end}.contents{end-2}.name, 'ConversionRange');
assertEqual(log{end}.contents{end-2}.type, 'failure');
assertEqual(log{end}.contents{end-1}.name, 'PositiveScalingFactor');
assertEqual(log{end}.contents{end-1}.type, 'success');
assertEqual(log{end}.contents{end-0}.name, 'Validation');
assertEqual(log{end}.contents{end-0}.type, 'failure');
