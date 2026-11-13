# Modeling the U.S. Economy

This folder contains an eight-variable macroeconomic VAR analysis of forecast
performance, business-cycle dynamics, and the recovery outlook following the
2008 financial crisis. The report uses a fixed historical data vintage covering
the period through 2009 Q1.

## Files

- `us_macroeconomic_outlook.mlx` is the MATLAB Live Script report.
- `data/load_us_macro_data.m` loads the supplied dataset.
- `data/us_macro_original_1947_2009.mat` contains the historical model input.
- `data/model17b.mat` contains fixed R2017b model and projection results for
  testing.

## Run the report

The report was fully rerun and saved in MATLAB R2017b in October 2026. Running it
requires Econometrics Toolbox and Financial Toolbox. Set MATLAB's current folder
to this directory, open the Live Script, and run it in Live Editor:

```matlab
open('us_macroeconomic_outlook.mlx')
```

The report uses legacy econometric functions from that environment.

## Historical data

The supplied MAT-file contains 249 quarterly rows from 1947 Q1 through 2009 Q1.
The complete sample across all 14 source series begins in 1959 Q1. The dataset
is an input to the analysis; no download or refresh is needed to run the report.

The report retains its original attribution. Its saved outputs reflect the
supplied historical sample through 2009 Q1.

## Fixed expected results

`data/model17b.mat` contains expected results for the VAR(2) estimated through
the latest observation, 2009 Q1. It is a test reference, not an input to the
report. The historical dataset above remains the model input and is unchanged.

The file contains:

- `Spec`: a portable numeric snapshot of the fitted R2017b model. `Constant`
  contains its intercept vector, `AR` contains the two lag coefficient
  matrices in the third dimension, and `Covariance` contains the innovation
  covariance matrix.
- `FGDP` and `FGDPSigma`: the projected real GDP mean and standard deviation.
- `trendFGDP`: the long-term real GDP trend projection.
