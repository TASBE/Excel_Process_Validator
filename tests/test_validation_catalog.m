function test_suite = test_validation_catalog
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

function test_catalog_listings

listings = ValidationCatalog.list();
m = methods(ValidationCatalog);

assertEqual(numel(m)-2,size(listings,1)); % one method per catalog row, plus listings method and constructor
assertEqual(size(listings,2), 2); % two columns

% every method is in the catalog
for i=1:size(listings,2)
    assertEqual(numel(find(cellfun(@(x)(strcmp(x,listings{i,2})),m))),1);
end


function test_sampler_of_catalog_runs

filename = 'tests/samples/iGEM 2019 Plate Reader Fluorescence Calibration - Example.xlsx';
ValidationCatalog.iGEM_2019_plate_reader_fluorescence(filename);

filename = 'tests/samples/iGEM 2019 Flow Cytometry Fluorescence Calibration - Example.xlsx';
ValidationCatalog.iGEM_2019_flow_cytometer_fluorescence(filename);

filename = 'tests/samples/iGEM 2019 Plate Reader Abs600 Calibration - Example.xlsx';
ValidationCatalog.iGEM_2019_plate_reader_abs600(filename);

