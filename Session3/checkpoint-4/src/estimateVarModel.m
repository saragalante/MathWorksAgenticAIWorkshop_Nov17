function [model, logLikelihood] = estimateVarModel(Y, lagOrder, Y0, seriesNames, description)
%estimateVarModel Estimate a vector autoregression with supplied presample data.
%   [MODEL, LOGLIKELIHOOD] = estimateVarModel(Y, LAGORDER, Y0, ...
%   SERIESNAMES, DESCRIPTION) estimates a VAR model for the numeric response
%   matrix Y. Y0 supplies presample observations unchanged.

    validateattributes(Y, {'numeric'}, {'2d', 'real', 'finite', 'nonempty'}, ...
        mfilename, 'Y', 1);
    validateattributes(lagOrder, {'numeric'}, ...
        {'scalar', 'integer', 'positive', 'finite'}, mfilename, 'lagOrder', 2);
    validateattributes(Y0, {'numeric'}, {'2d', 'real', 'finite'}, mfilename, 'Y0', 3);

    numSeries = size(Y, 2);
    if size(Y0, 2) ~= numSeries
        error('usmacro:InvalidPresample', ...
            'Y0 must have the same number of columns as Y.');
    end
    if size(Y0, 1) < lagOrder
        error('usmacro:InsufficientPresample', ...
            'Y0 must contain at least lagOrder rows.');
    end
    if isstring(seriesNames)
        seriesNames = cellstr(seriesNames);
    end
    if ~iscellstr(seriesNames) || numel(seriesNames) ~= numSeries
        error('usmacro:InvalidSeriesNames', ...
            'seriesNames must contain one name per column of Y.');
    end
    if ~(ischar(description) || (isstring(description) && isscalar(description)))
        error('usmacro:InvalidDescription', ...
            'description must be a character vector or string scalar.');
    end

    model = varm(numSeries, lagOrder);
    model.SeriesNames = seriesNames;
    model.Description = description;
    [model, ~, logLikelihood] = estimate(model, Y, Y0=Y0);
end
