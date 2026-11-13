function [meanForecast, uncertaintyForecast, trendForecast] = ...
    calculateRealGdpProjection(model, responseHistory, integratedHistory, ...
    logGdp, logDeflator, lagOrder, forecastHorizon, numPaths, trendWindow)
%calculateRealGdpProjection Simulate and trend a real-GDP projection.
%   [MEANFORECAST, UNCERTAINTYFORECAST, TRENDFORECAST] = ...
%   CALCULATEREALGDPPROJECTION(MODEL, RESPONSEHISTORY, INTEGRATEDHISTORY, ...
%   LOGGDP, LOGDEFLATOR, LAGORDER, FORECASTHORIZON, NUMPATHS, TRENDWINDOW)
%   simulates response paths from MODEL, integrates them from the last row
%   of INTEGRATEDHISTORY, and returns the real-GDP path mean and sample
%   standard deviation. Real GDP is defined as output minus GDP deflator,
%   the first two columns of the integrated paths. TRENDFORECAST is the
%   out-of-sample linear trend fitted to the final TRENDWINDOW observations.

    validatePositiveInteger(lagOrder, 'lagOrder');
    validatePositiveInteger(forecastHorizon, 'forecastHorizon');
    validatePositiveInteger(numPaths, 'numPaths');
    validatePositiveInteger(trendWindow, 'trendWindow');
    validateModel(model, lagOrder);
    validateHistory(responseHistory, integratedHistory, lagOrder, model.NumSeries);
    validateLogSeries(logGdp, logDeflator, size(responseHistory, 1));

    if trendWindow > numel(logGdp)
        error('usmacro:InsufficientTrendHistory', ...
            'trendWindow must not exceed the length of logGdp.');
    end

    simulatedResponses = simulate(model, forecastHorizon, ...
        Y0=responseHistory(end-lagOrder+1:end, :), NumPaths=numPaths);
    integratedPaths = repmat(integratedHistory(end, :), ...
        [forecastHorizon, 1, numPaths]) + 0.25 * cumsum(simulatedResponses);
    realGdpPaths = integratedPaths(:, 1, :) - integratedPaths(:, 2, :);

    meanForecast = mean(realGdpPaths, 3);
    uncertaintyForecast = std(realGdpPaths, 0, 3);

    designMatrix = [ones(trendWindow, 1), (1:trendWindow)'];
    trendParameters = designMatrix \ ...
        (logGdp(end-trendWindow+1:end) - logDeflator(end-trendWindow+1:end));
    trendForecast = [ones(forecastHorizon, 1), ...
        trendWindow + (1:forecastHorizon)'] * trendParameters;
end

function validateModel(model, lagOrder)
    if ~isa(model, 'varm')
        error('usmacro:InvalidModel', 'model must be a varm model object.');
    end
    if model.NumSeries < 2
        error('usmacro:InsufficientModelSeries', ...
            'model must contain at least output and GDP deflator series.');
    end
    if model.NumSeries ~= size(model.Covariance, 1) || ...
            size(model.Covariance, 2) ~= model.NumSeries
        error('usmacro:InvalidModel', ...
            'model covariance must be square with one row per series.');
    end
    if model.P ~= lagOrder
        error('usmacro:LagOrderMismatch', ...
            'lagOrder must match the model autoregressive order.');
    end
end

function validateHistory(responseHistory, integratedHistory, lagOrder, numSeries)
    if ~isnumeric(responseHistory) || ~ismatrix(responseHistory) || ...
            isempty(responseHistory) || ~isreal(responseHistory) || ...
            any(~isfinite(responseHistory), 'all')
        error('usmacro:InvalidResponseHistory', ...
            'responseHistory must be a nonempty finite real numeric matrix.');
    end
    if ~isnumeric(integratedHistory) || ~ismatrix(integratedHistory) || ...
            isempty(integratedHistory) || ~isreal(integratedHistory) || ...
            any(~isfinite(integratedHistory), 'all')
        error('usmacro:InvalidIntegratedHistory', ...
            'integratedHistory must be a nonempty finite real numeric matrix.');
    end
    if size(responseHistory, 2) ~= size(integratedHistory, 2)
        error('usmacro:IncompatibleHistory', ...
            'responseHistory and integratedHistory must have the same columns.');
    end
    if size(responseHistory, 1) ~= size(integratedHistory, 1)
        error('usmacro:IncompatibleHistory', ...
            'responseHistory and integratedHistory must have the same rows.');
    end
    if size(responseHistory, 2) ~= numSeries
        error('usmacro:ModelHistoryMismatch', ...
            'history inputs must have one column per model series.');
    end
    if size(responseHistory, 2) < 2
        error('usmacro:InsufficientHistorySeries', ...
            'history inputs must contain output and GDP deflator columns.');
    end
    if size(responseHistory, 1) < lagOrder
        error('usmacro:InsufficientResponseHistory', ...
            'responseHistory must contain at least lagOrder rows.');
    end
end

function validateLogSeries(logGdp, logDeflator, responseLength)
    if ~isnumeric(logGdp) || ~isvector(logGdp) || ~isreal(logGdp) || ...
            any(~isfinite(logGdp))
        error('usmacro:InvalidLogGdp', ...
            'logGdp must be a finite real numeric vector.');
    end
    if ~isnumeric(logDeflator) || ~isvector(logDeflator) || ...
            ~isreal(logDeflator) || any(~isfinite(logDeflator))
        error('usmacro:InvalidLogDeflator', ...
            'logDeflator must be a finite real numeric vector.');
    end
    if numel(logGdp) ~= numel(logDeflator) || numel(logGdp) ~= responseLength
        error('usmacro:IncompatibleLogHistory', ...
            'logGdp and logDeflator must match the response history length.');
    end
end

function validatePositiveInteger(value, name)
    if ~isnumeric(value) || ~isscalar(value) || ~isreal(value) || ...
            ~isfinite(value) || value <= 0 || value ~= fix(value)
        error('usmacro:InvalidProjectionSetting', ...
            '%s must be a positive integer scalar.', name);
    end
end
