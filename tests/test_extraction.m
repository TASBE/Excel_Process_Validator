function test_suite = test_extraction
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

function test_good_extraction

testfile = './tests/samples/iGEM 2019 Plate Reader Fluorescence Calibration - Example.xlsx';
template = iGEM_2019_plate_reader_fluorescence();
result = TemplateExtraction.extract(testfile,template);

log = EPVSession.list();
% check that the right four success messages have been created
assertEqual(log{end}.contents{end-3}.name, 'FoundFile');
assertEqual(log{end}.contents{end-3}.type, 'success');
assertEqual(log{end}.contents{end-2}.name, 'ValidSheets');
assertEqual(log{end}.contents{end-2}.type, 'success');
assertEqual(log{end}.contents{end-1}.name, 'ValidTemplate');
assertEqual(log{end}.contents{end-1}.type, 'success');
assertEqual(log{end}.contents{end-0}.name, 'Extraction');
assertEqual(log{end}.contents{end-0}.type, 'success');


function test_missing_sheet

testfile = './tests/samples/Plate-Fluorescence-Bad1.xlsx';
template = iGEM_2019_plate_reader_fluorescence();
assertExceptionThrown(@()TemplateExtraction.extract(testfile,template), 'TemplateExtraction:MissingSheets', 'No error was raised.');

log = EPVSession.list();
% check for one success, then a missing sheet error
assertEqual(log{end}.contents{end-1}.name, 'FoundFile');
assertEqual(log{end}.contents{end-1}.type, 'success');
assertEqual(log{end}.contents{end-0}.name, 'MissingSheets');
assertEqual(log{end}.contents{end-0}.type, 'error');


function test_modified_template

testfile = './tests/samples/Plate-Fluorescence-Bad2.xlsx';
template = iGEM_2019_plate_reader_fluorescence();
assertExceptionThrown(@()TemplateExtraction.extract(testfile,template), 'TemplateExtraction:ModifiedTemplate', 'No error was raised.');

% modifications to catch: 
% Particle Standard Curve: T20 was changed, all shifted down 1 line
%   --> 10 failures for particle standard curve (all except N2:N8, M29)
% Fluorescein standard curve: Notes in N2, N3, D30
%   --> 2 failures: N2:N8, D30:M31
% Fluorescence per particle: deleted the 6th column of wells
%   --> 4 failures: 'B11:M11','B20:M22','B31:M33','B42:M44'
% Total: 16 failures
n_failures = 16;

log = EPVSession.list();
% check for two successes, then a bunch fo modified ranges, then a modified template error
assertEqual(log{end}.contents{end-n_failures-2}.name, 'FoundFile');
assertEqual(log{end}.contents{end-n_failures-2}.type, 'success');
assertEqual(log{end}.contents{end-n_failures-1}.name, 'ValidSheets');
assertEqual(log{end}.contents{end-n_failures-1}.type, 'success');
% modified ranges
for i=1:n_failures
    assertEqual(log{end}.contents{end-i}.name, 'ModifiedTemplateRange');
    assertEqual(log{end}.contents{end-i}.type, 'failure');
end
% final error
assertEqual(log{end}.contents{end-0}.name, 'ModifiedTemplate');
assertEqual(log{end}.contents{end-0}.type, 'error');


function test_bad_abs600_data

testfile = './tests/samples/Plate-Fluorescence-Bad4.xlsx';
template = iGEM_2019_plate_reader_fluorescence();
assertExceptionThrown(@()TemplateExtraction.extract(testfile,template), 'TemplateExtraction:FailedExtraction', 'No error was raised.');

n_failures = 4;

log = EPVSession.list();
% check for two successes, then a bunch fo modified ranges, then a modified template error
assertEqual(log{end}.contents{end-n_failures-3}.name, 'FoundFile');
assertEqual(log{end}.contents{end-n_failures-3}.type, 'success');
assertEqual(log{end}.contents{end-n_failures-2}.name, 'ValidSheets');
assertEqual(log{end}.contents{end-n_failures-2}.type, 'success');
assertEqual(log{end}.contents{end-n_failures-1}.name, 'ValidTemplate');
assertEqual(log{end}.contents{end-n_failures-1}.type, 'success');
% modified ranges
for i=1:n_failures
    assertEqual(log{end}.contents{end-i}.name, 'NonNumericValue');
    assertEqual(log{end}.contents{end-i}.type, 'failure');
end
% final error
assertEqual(log{end}.contents{end-0}.name, 'FailedExtraction');
assertEqual(log{end}.contents{end-0}.type, 'error');
