classdef testEstimateVarModel < matlab.unittest.TestCase
    %testEstimateVarModel Regression tests for the macroeconomic VAR utility.

    methods (TestClassSetup)
        function addRepositoryFoldersToPath(testCase)
            repositoryRoot = fileparts(fileparts(mfilename('fullpath')));
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
                fullfile(repositoryRoot, 'data')));
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
                fullfile(repositoryRoot, 'src')));
        end
    end

    methods (Test)
        function testConstantMatchesReference(testCase)
            [model, reference] = estimateReferenceModel;

            testCase.verifyEqual(model.Constant, reference.Spec.Constant, AbsTol=1e-12);
        end

        function testAutoregressionMatchesReference(testCase)
            [model, reference] = estimateReferenceModel;

            testCase.verifyEqual(cat(3, model.AR{:}), reference.Spec.AR, AbsTol=1e-12);
        end

        function testCovarianceMatchesReference(testCase)
            [model, reference] = estimateReferenceModel;

            testCase.verifyEqual(model.Covariance, reference.Spec.Covariance, AbsTol=1e-12);
        end
    end
end

function [model, reference] = estimateReferenceModel
    repositoryRoot = fileparts(fileparts(mfilename('fullpath')));
    macroDataset = load_us_macro_data( ...
        fullfile(repositoryRoot, 'data', 'us_macro_original_1947_2009.mat'));
    dataTable = macroDataset.DataTable;
    dataTable(any(isnan(macroDataset.Data), 2), :) = [];

    GDP = log(dataTable.GDP);
    DEF = log(dataTable.GDPDEF);
    WAGES = log(dataTable.COE);
    HOURS = log(dataTable.HOANBS);
    CONS = log(dataTable.PCEC);
    INV = log(dataTable.GPDI);

    rGDP = [4 * mean(diff(GDP(1:5))); 4 * diff(GDP)];
    rDEF = [4 * mean(diff(DEF(1:5))); 4 * diff(DEF)];
    rWAGES = [4 * mean(diff(WAGES(1:5))); 4 * diff(WAGES)];
    rHOURS = [4 * mean(diff(HOURS(1:5))); 4 * diff(HOURS)];
    rTB3 = 0.01 * dataTable.TB3MS;
    rCONS = [4 * mean(diff(CONS(1:5))); 4 * diff(CONS)];
    rINV = [4 * mean(diff(INV(1:5))); 4 * diff(INV)];
    rUNEMP = 0.01 * dataTable.UNRATE;

    Y = [rGDP, rDEF, rWAGES, rHOURS, rTB3, rCONS, rINV, rUNEMP];
    seriesNames = {'Output (GDP)', 'Prices', 'Total Wages', 'Hours Worked', ...
        'Cash Rate', 'Consumption', 'Private Investment', 'Unemployment'};
    model = estimateVarModel(Y, 2, zeros(2, 8), seriesNames, ...
        'U.S. Macroeconomic Model');
    reference = load(fullfile(repositoryRoot, 'data', 'model17b.mat'), 'Spec');
end
