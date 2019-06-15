function test_suite = test_plate_reader
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

testfile = './tests/samples/iGEM 2019 Plate Reader Fluorescence Calibration - Example.xlsx';
template = iGEM_2019_plate_reader_fluorescence();
result = TemplateExtraction.extract(testfile,template);
validate_plate_Abs600(result);
validate_plate_fluorescence(result);

log = EPVSession.list();
% check that the right success messages have been created
assertEqual(log{end-2}.contents{end}.classname, 'TemplateExtraction');
assertEqual(log{end-2}.contents{end}.name, 'Extraction');
assertEqual(log{end-2}.contents{end}.type, 'success');

assertEqual(numel(log{end-1}.contents),5);
assertEqual(log{end-1}.contents{end-4}.classname, 'Abs600');
assertEqual(log{end-1}.contents{end-4}.name, 'DynamicRange');
assertEqual(log{end-1}.contents{end-4}.type, 'success');
assertEqual(log{end-1}.contents{end-3}.name, 'ValidDilutions');
assertEqual(log{end-1}.contents{end-3}.type, 'success');
assertEqual(log{end-1}.contents{end-2}.name, 'PositiveScalingFactor');
assertEqual(log{end-1}.contents{end-2}.type, 'success');
assertEqual(log{end-1}.contents{end-1}.name, 'CellGrowth');
assertEqual(log{end-1}.contents{end-1}.type, 'success');
assertEqual(log{end-1}.contents{end-0}.name, 'Validation');
assertEqual(log{end-1}.contents{end-0}.type, 'success');

assertEqual(numel(log{end}.contents),4);
assertEqual(log{end}.contents{end-3}.classname, 'Fluorescence');
assertEqual(log{end}.contents{end-3}.name, 'DynamicRange');
assertEqual(log{end}.contents{end-3}.type, 'success');
assertEqual(log{end}.contents{end-2}.name, 'ValidDilutions');
assertEqual(log{end}.contents{end-2}.type, 'success');
assertEqual(log{end}.contents{end-1}.name, 'PositiveScalingFactor');
assertEqual(log{end}.contents{end-1}.type, 'success');
assertEqual(log{end}.contents{end-0}.name, 'Validation');
assertEqual(log{end}.contents{end-0}.type, 'success');


function test_good_abs600_data

testfile = './tests/samples/iGEM 2019 Plate Reader Abs600 Calibration - Example.xlsx';
template = iGEM_2019_plate_reader_abs600();
result = TemplateExtraction.extract(testfile,template);
validate_plate_Abs600(result);

log = EPVSession.list();
% check that the right six success messages have been created
assertEqual(log{end-1}.contents{end}.classname, 'TemplateExtraction');
assertEqual(log{end-1}.contents{end}.name, 'Extraction');
assertEqual(log{end-1}.contents{end}.type, 'success');
assertEqual(numel(log{end}.contents),5);
assertEqual(log{end}.contents{end-4}.classname, 'Abs600');
assertEqual(log{end}.contents{end-4}.name, 'DynamicRange');
assertEqual(log{end}.contents{end-4}.type, 'success');
assertEqual(log{end}.contents{end-3}.name, 'ValidDilutions');
assertEqual(log{end}.contents{end-3}.type, 'success');
assertEqual(log{end}.contents{end-2}.name, 'PositiveScalingFactor');
assertEqual(log{end}.contents{end-2}.type, 'success');
assertEqual(log{end}.contents{end-1}.name, 'CellGrowth');
assertEqual(log{end}.contents{end-1}.type, 'success');
assertEqual(log{end}.contents{end-0}.name, 'Validation');
assertEqual(log{end}.contents{end-0}.type, 'success');


function test_bad_abs600_data

testfile = './tests/samples/Plate-Fluorescence-Bad3.xlsx';
template = iGEM_2019_plate_reader_fluorescence();
result = TemplateExtraction.extract(testfile,template);
validate_plate_Abs600(result); % should fail
validate_plate_fluorescence(result); % should succeed

log = EPVSession.list();
% check that the right set of failure and success messages have been created
assertEqual(log{end-2}.contents{end}.classname, 'TemplateExtraction');
assertEqual(log{end-2}.contents{end}.name, 'Extraction');
assertEqual(log{end-2}.contents{end}.type, 'success');

assertEqual(numel(log{end-1}.contents),5);
assertEqual(log{end-1}.contents{end-4}.classname, 'Abs600');
assertEqual(log{end-1}.contents{end-4}.name, 'DynamicRange');
assertEqual(log{end-1}.contents{end-4}.type, 'failure');
assertEqual(log{end-1}.contents{end-3}.name, 'ValidDilutions');
assertEqual(log{end-1}.contents{end-3}.type, 'failure');
assertEqual(log{end-1}.contents{end-2}.name, 'PositiveScalingFactor');
assertEqual(log{end-1}.contents{end-2}.type, 'success');
assertEqual(log{end-1}.contents{end-1}.name, 'CellGrowth');
assertEqual(log{end-1}.contents{end-1}.type, 'failure');
assertEqual(log{end-1}.contents{end-0}.name, 'Validation');
assertEqual(log{end-1}.contents{end-0}.type, 'failure');

assertEqual(numel(log{end}.contents),4);
assertEqual(log{end}.contents{end-3}.classname, 'Fluorescence');
assertEqual(log{end}.contents{end-3}.name, 'DynamicRange');
assertEqual(log{end}.contents{end-3}.type, 'success');
assertEqual(log{end}.contents{end-2}.name, 'ValidDilutions');
assertEqual(log{end}.contents{end-2}.type, 'success');
assertEqual(log{end}.contents{end-1}.name, 'PositiveScalingFactor');
assertEqual(log{end}.contents{end-1}.type, 'success');
assertEqual(log{end}.contents{end-0}.name, 'Validation');
assertEqual(log{end}.contents{end-0}.type, 'success');


function test_missing_fluorescence_data

testfile = './tests/samples/Plate-Fluorescence-Bad5.xlsx';
template = iGEM_2019_plate_reader_fluorescence();
result = TemplateExtraction.extract(testfile,template); % should be valid
validate_plate_Abs600(result); % should be valid
validate_plate_fluorescence(result); % should fail

log = EPVSession.list();
% check that the right set of failure and success messages have been created
assertEqual(log{end-2}.contents{end}.classname, 'TemplateExtraction');
assertEqual(log{end-2}.contents{end}.name, 'Extraction');
assertEqual(log{end-2}.contents{end}.type, 'success');
assertEqual(log{end-1}.contents{end}.classname, 'Abs600');
assertEqual(log{end-1}.contents{end}.name, 'Validation');
assertEqual(log{end-1}.contents{end}.type, 'success');

assertEqual(numel(log{end}.contents),4);
assertEqual(log{end}.contents{end-3}.classname, 'Fluorescence');
assertEqual(log{end}.contents{end-3}.name, 'DynamicRange');
assertEqual(log{end}.contents{end-3}.type, 'failure');
assertEqual(log{end}.contents{end-2}.name, 'ValidDilutions');
assertEqual(log{end}.contents{end-2}.type, 'failure');
assertEqual(log{end}.contents{end-1}.name, 'PositiveScalingFactor');
assertEqual(log{end}.contents{end-1}.type, 'failure');
assertEqual(log{end}.contents{end-0}.name, 'Validation');
assertEqual(log{end}.contents{end-0}.type, 'failure');
