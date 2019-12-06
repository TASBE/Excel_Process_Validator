function test_suite = test_strateos_plate_reader
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

testfile = './tests/samples/Strateos Platereader Fluorescence v1.csv';
template = Strateos_plate_reader_fluorescence_v1();
result = CSVTemplateExtraction.extract(testfile,template);
validate_plate_fluorescence(result);

assertElementsAlmostEqual(result.MEFL_per_au,1.5750e+12,'relative',0.01);

log = EPVSession.list();
% check that the right success messages have been created
assertEqual(log{end-1}.contents{end}.classname, 'CSVTemplateExtraction');
assertEqual(log{end-1}.contents{end-1}.name, 'Extraction');
assertEqual(log{end-1}.contents{end-1}.type, 'success');
assertEqual(log{end-1}.contents{end}.name, 'Postprocessing');
assertEqual(log{end-1}.contents{end}.type, 'success');

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

