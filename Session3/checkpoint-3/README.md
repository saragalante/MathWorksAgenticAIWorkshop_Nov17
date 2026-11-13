# Modeling the U.S. Economy

This folder contains an eight-variable macroeconomic VAR analysis of forecast
performance, business-cycle dynamics, and the recovery outlook following the
2008 financial crisis. The report uses a fixed historical data vintage covering
the period through 2009 Q1.

## Files

- `us_macroeconomic_outlook.mlx` is the supplied MATLAB Live Script report.
- `us_macroeconomic_outlook.m` is its maintained, R2026b-runnable plain-text
  copy. Use this copy for inspection and future report maintenance; preserve
  the supplied `.mlx` unchanged as the historical artifact.
- `us_macroeconomic_outlook.prj` is the MATLAB project. Open it before working
  with the report so that `data/` is available on the MATLAB path.
- `data/load_us_macro_data.m` loads the supplied dataset.
- `src/estimateVarModel.m` estimates VAR models with supplied presample data.
- `src/calculateRealGdpProjection.m` simulates the report's real-GDP
  projection and calculates its long-term trend benchmark.
- `tests/testEstimateVarModel.m` verifies the full-sample VAR(2) against the
  fixed R2017b parameter snapshot.
- `tests/testCalculateRealGdpProjection.m` verifies the real-GDP mean,
  Monte Carlo uncertainty, and trend projection against that snapshot.
- `data/us_macro_original_1947_2009.mat` contains the historical model input.
- `data/model17b.mat` contains fixed R2017b model and projection results for
  deferred validation; it is not a runtime dependency.

## Run the report

The maintained plain-text report runs in MATLAB R2026b and requires
Econometrics Toolbox and Financial Toolbox. Open the project, then use the
plain-text copy in Live Editor:

```matlab
openProject('us_macroeconomic_outlook.prj')
open('us_macroeconomic_outlook.m')
```

The supplied `.mlx` remains the unmodified historical R2017b artifact. The
maintained `.m` copy uses R2026b VAR model objects while preserving the
historical data vintage and analysis.

## Validation

Validate the data loader with a focused smoke test:

```matlab
d = load_us_macro_data;
assert(isequal(size(d.Data), [249 14]))
```

Then run all six regression tests from the repository root after opening the
project:

```matlab
runtests("tests")
```

The real-GDP projection tests replay the report's preceding Monte Carlo
simulations to reproduce the historical random-stream state, then compare the
mean forecast, uncertainty, and trend with `data/model17b.mat`.

## Historical data

The supplied MAT-file contains 249 quarterly rows from 1947 Q1 through 2009 Q1.
The complete sample across all 14 source series begins in 1959 Q1. The dataset
is an input to the analysis; no download or refresh is needed to run the report.

The report retains its original attribution. Its saved outputs reflect the
supplied historical sample through 2009 Q1.

## Fixed expected results

`data/model17b.mat` contains expected R2017b results for the VAR(2) estimated
through the latest observation, 2009 Q1. It is a deferred validation reference,
not an input to the report. The historical dataset above remains the model
input and is unchanged.

The file contains:

- `Spec`: a portable numeric snapshot of the fitted R2017b model. `Constant`
  contains its intercept vector, `AR` contains the two lag coefficient
  matrices in the third dimension, and `Covariance` contains the innovation
  covariance matrix.
- `FGDP` and `FGDPSigma`: the projected real GDP mean and standard deviation.
- `trendFGDP`: the long-term real GDP trend projection.
