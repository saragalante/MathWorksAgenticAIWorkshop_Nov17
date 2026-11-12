function fig = tsReg(confidenceLevel)
%tsReg - Plot regression with confidence limits
%   FIG = tsReg(confidenceLevel) plots observed
%   default rates, fitted means, and pointwise confidence limits.
%   confidenceLevel is a percentage strictly between 0 and 100.
%   FIG is the handle to the new figure.
%
%   Example:
%       tsReg(95);
%
%   See also fitlm, predict
%
%   Note: Requires Statistics and Machine Learning Toolbox and
%   Econometrics Toolbox for Data_CreditDefaults.mat

arguments
    confidenceLevel (1,1) {mustBeNumeric, mustBeReal, mustBeFinite, ...
        mustBeGreaterThan(confidenceLevel, 0), ...
        mustBeLessThan(confidenceLevel, 100)}
end

confidenceLevel = double(confidenceLevel);
alpha = 1 - confidenceLevel/100;

% Data and original example: Copyright 2012-2014 The MathWorks, Inc.
credit = load("Data_CreditDefaults.mat", "DataTable", "dates");
predictorNames = ["AGE", "BBB", "CPF", "SPR"];
predictorYears = datetime(string(credit.dates), Format="yyyy");
observedDefaults = credit.DataTable.IGD;

model = fitlm(credit.DataTable, "linear", ...
    PredictorVars=predictorNames, ResponseVar="IGD", ...
    Intercept=true, RobustOpts="off");

% Pointwise confidence limits for the conditional mean response.
[fittedValues, meanResponseCI] = predict(model, credit.DataTable, ...
    Alpha=alpha, Prediction="curve", Simultaneous=false);

fig = figure(Name="Corporate Default Risk");
fitLayout = tiledlayout(fig, 1, 1);
fitAxes = nexttile(fitLayout);
plot(fitAxes, predictorYears, observedDefaults, ...
    LineWidth=2, DisplayName="Observed default rate");
hold(fitAxes, "on");
plot(fitAxes, predictorYears, fittedValues, ...
    LineWidth=2, DisplayName="Estimated conditional mean");
plot(fitAxes, predictorYears, meanResponseCI(:,1), "--", ...
    LineWidth=1.5, ...
    DisplayName=compose("Lower %.15g%% confidence limit", confidenceLevel));
plot(fitAxes, predictorYears, meanResponseCI(:,2), "--", ...
    LineWidth=1.5, ...
    DisplayName=compose("Upper %.15g%% confidence limit", confidenceLevel));
hold(fitAxes, "off");

title(fitAxes, ["Corporate Defaults: Observed and Estimated"; ...
    compose("%.15g%% confidence limits for the conditional mean", ...
    confidenceLevel)]);
xlabel(fitAxes, "Year of Economic Indicators (Defaults Occur One Year Later)");
ylabel(fitAxes, "Investment-Grade Default Rate (%)");
legend(fitAxes, Location="northwest");
grid(fitAxes, "on");
axis(fitAxes, "tight");
end
