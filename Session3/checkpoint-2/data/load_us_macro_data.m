function dataset = load_us_macro_data(datasetFile)
    %load_us_macro_data - Load a saved U.S. macroeconomic dataset
    %   DATASET = load_us_macro_data loads the historical U.S. macro data
    %   for 1947 Q1 through 2009 Q1, with serial dates for the outlook script.
    %
    %   DATASET = load_us_macro_data(datasetFile) loads a MAT-file. Relative
    %   paths resolve against the repository folder. Absolute paths are
    %   also accepted. No network access occurs.
    %   See also LOAD

    if nargin == 0
        datasetFile = 'data/us_macro_original_1947_2009.mat';
    end
    datasetFile = char(datasetFile);
    repositoryRoot = fileparts(fileparts(mfilename('fullpath')));
    if ~isAbsolutePath(datasetFile)
        datasetFile = fullfile(repositoryRoot,datasetFile);
    end
    if ~isfile(datasetFile)
        error('usmacro:MissingDataset','Dataset not found: %s',datasetFile);
    end
    dataset = load(datasetFile);
    expectedSeries = {'COE','CPIAUCSL','FEDFUNDS','GCE','GDP','GDPDEF', ...
        'GPDI','GS10','HOANBS','M1SL','M2SL','PCEC','TB3MS','UNRATE'};
    required = {'series','dates','Data','DataTable','Provenance'};
    if ~all(isfield(dataset,required))
        error('usmacro:InvalidDataset','The file lacks required dataset fields.');
    end
    if ~isequal(dataset.series,expectedSeries) || ...
            ~isnumeric(dataset.dates) || ~iscolumn(dataset.dates) || ...
            any(~isfinite(dataset.dates)) || any(diff(dataset.dates)<=0) || ...
            ~isnumeric(dataset.Data) || ...
            ~isequal(size(dataset.Data),[numel(dataset.dates),14]) || ...
            ~istable(dataset.DataTable) || ...
            ~isequal(dataset.DataTable.Properties.VariableNames,expectedSeries) || ...
            ~isequaln(dataset.Data,dataset.DataTable{:,:})
        error('usmacro:InvalidDataset','Dataset dates, columns, or values are inconsistent.');
    end
end

function result = isAbsolutePath(path)
    result = startsWith(path,'/') || startsWith(path,'\') || ...
        ~isempty(regexp(char(path),'^[A-Za-z]:[\\/]','once'));
end