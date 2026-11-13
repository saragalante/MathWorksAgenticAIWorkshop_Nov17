---
name: vgx-migration
description: Migrate legacy MATLAB VAR workflows built with vgxvarx and vgxpred to R2026b model objects and forecast, preserving presample and forecast semantics.
---

# Migrate legacy VAR workflows

Use this skill when replacing legacy `vgxvarx` and `vgxpred` calls with the
R2026b Econometrics Toolbox model-object workflow. Follow the [MathWorks
conversion guide](https://www.mathworks.com/help/econ/converting-from-vgx-functions-to-model-objects.html)
for release-specific syntax and the full API mapping.

## Estimation and presample values

When a legacy `vgxvarx` fit used an empty `Y0`, pass `Y0=zeros(p,n)` to
R2026b `estimate`, where `p` is the VAR lag order and `n` is the number of
response series. This supplies `p` rows of zero-valued presample responses.
Do not omit `Y0` or pass a 0-by-0 array; either can change the estimation
result. Preserve the response variable order, lag order, deterministic terms,
exogenous inputs, and other model settings when moving the fit to a `varm`
model object.

Compare the estimated coefficients, innovation covariance, and log likelihood
with a fixed reference produced by the legacy workflow. Record the dimensions
and values of the presample and exogenous arrays alongside that comparison.

## Forecasting

Replace `vgxpred` with `forecast` on the estimated model object. Map the
forecast horizon, presample responses, and any exogenous inputs explicitly;
check their dimensions and ordering against the model. Compare forecast means
and uncertainty with the legacy reference, accounting for the output shape and
definition used by each API. Do not assume that similarly named outputs have
identical conventions; consult the conversion guide when mapping each argument.

## Monte Carlo comparisons

Before claiming that simulated paths match across MATLAB releases, run a
seeded comparison with the same fitted parameters, random stream and seed,
horizon, and path count in both releases. Compare paths directly and record
whether they match exactly. A common seed alone does not guarantee identical
paths when algorithms consume random values differently. If paths differ,
report comparisons of forecast moments or distributions instead of path
equality.

This skill covers migration semantics only. Participants still inspect and
extract reusable functions and write reference-based tests as separate
workshop exercises.
