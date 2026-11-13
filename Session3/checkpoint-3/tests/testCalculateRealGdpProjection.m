classdef testCalculateRealGdpProjection < matlab.unittest.TestCase
    %testCalculateRealGdpProjection Regression tests for real-GDP projections.

    methods (TestClassSetup)
        function addRepositoryFoldersToPath(testCase)
            repositoryRoot = fileparts(fileparts(mfilename('fullpath')));
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
                fullfile(repositoryRoot, 'data')));
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
                fullfile(repositoryRoot, 'src')));
        end
    end

    methods (TestMethodSetup)
        function restoreRandomState(testCase)
            originalState = rng;
            testCase.addTeardown(@() rng(originalState));
        end
    end

    methods (Test)
        function testMeanForecastMatchesReference(testCase)
            [meanForecast, ~, ~, reference] = calculateReferenceProjection;

            testCase.verifyEqual(meanForecast, reference.FGDP, AbsTol=1e-12);
        end

        function testUncertaintyForecastMatchesReference(testCase)
            [~, uncertaintyForecast, ~, reference] = calculateReferenceProjection;

            testCase.verifyEqual(uncertaintyForecast, reference.FGDPSigma, ...
                AbsTol=1e-12);
        end

        function testTrendForecastMatchesReference(testCase)
            [~, ~, trendForecast, reference] = calculateReferenceProjection;

            testCase.verifyEqual(trendForecast, reference.trendFGDP, AbsTol=1e-12);
        end
    end
end

function [meanForecast, uncertaintyForecast, trendForecast, reference] = ...
        calculateReferenceProjection
    rng(0, 'twister');
    [model, responseHistory, integratedHistory, logGdp, logDeflator] = ...
        buildFullSampleModel;
    replayBacktestSimulations(model, responseHistory);

    [meanForecast, uncertaintyForecast, trendForecast] = ...
        calculateRealGdpProjection(model, responseHistory, integratedHistory, ...
        logGdp, logDeflator, 2, 20, 1000, 120);

    repositoryRoot = fileparts(fileparts(mfilename('fullpath')));
    reference = load(fullfile(repositoryRoot, 'data', 'model17b.mat'), ...
        'FGDP', 'FGDPSigma', 'trendFGDP');
end

function [model, responseHistory, integratedHistory, logGdp, logDeflator] = ...
        buildFullSampleModel
    repositoryRoot = fileparts(fileparts(mfilename('fullpath')));
    macroDataset = load_us_macro_data( ...
        fullfile(repositoryRoot, 'data', 'us_macro_original_1947_2009.mat'));
    dataTable = macroDataset.DataTable;
    dataTable(any(isnan(macroDataset.Data), 2), :) = [];

    logGdp = log(dataTable.GDP);
    logDeflator = log(dataTable.GDPDEF);
    logWages = log(dataTable.COE);
    logHours = log(dataTable.HOANBS);
    logConsumption = log(dataTable.PCEC);
    logInvestment = log(dataTable.GPDI);

    rGdp = [4 * mean(diff(logGdp(1:5))); 4 * diff(logGdp)];
    rDeflator = [4 * mean(diff(logDeflator(1:5))); 4 * diff(logDeflator)];
    rWages = [4 * mean(diff(logWages(1:5))); 4 * diff(logWages)];
    rHours = [4 * mean(diff(logHours(1:5))); 4 * diff(logHours)];
    rTreasuryBill = 0.01 * dataTable.TB3MS;
    rConsumption = [4 * mean(diff(logConsumption(1:5))); 4 * diff(logConsumption)];
    rInvestment = [4 * mean(diff(logInvestment(1:5))); 4 * diff(logInvestment)];
    rUnemployment = 0.01 * dataTable.UNRATE;

    responseHistory = [rGdp, rDeflator, rWages, rHours, rTreasuryBill, ...
        rConsumption, rInvestment, rUnemployment];
    integratedHistory = [logGdp, logDeflator, logWages, logHours, ...
        log(dataTable.TB3MS), logConsumption, logInvestment, ...
        log(dataTable.UNRATE)];
    seriesNames = {'Output (GDP)', 'Prices', 'Total Wages', 'Hours Worked', ...
        'Cash Rate', 'Consumption', 'Private Investment', 'Unemployment'};
    model = estimateVarModel(responseHistory, 2, zeros(2, 8), seriesNames, ...
        'U.S. Macroeconomic Model');
end

function replayBacktestSimulations(model, responseHistory)
    for year = 1975:2008
        simulate(model, 4, Y0=responseHistory(end-1:end, :), NumPaths=500);
    end
end
