# Repository Guidelines

## Project Structure and Organization

- `us_macroeconomic_outlook.mlx` is the supplied historical Live Script.
  Preserve it unchanged.
- `us_macroeconomic_outlook.m` is the plain-text copy for report maintenance.
  Make report edits here and keep the original `.mlx` as the supplied artifact.
- `us_macroeconomic_outlook.prj` is the MATLAB project. Maintain its membership
  and keep `data/`, `src/`, and `tests/` on its project path.
- `buildfile.m` defines the repository build. Its default `codeIssues` and
  `test` tasks analyze maintained code and run the complete regression suite;
  its `report` task runs the maintained plain-text report.
- `data/load_us_macro_data.m` loads and validates the historical macroeconomic
  dataset. Reusable data-access logic belongs in this folder.
- `src/estimateVarModel.m` estimates VAR models with supplied presample data.
- `src/calculateRealGdpProjection.m` calculates the report's stochastic
  real-GDP projection and long-term trend benchmark.
- `tests/testEstimateVarModel.m` and
  `tests/testCalculateRealGdpProjection.m` provide fixed-snapshot regression
  coverage for the full-sample VAR(2) and real-GDP projection, respectively.
- `data/us_macro_original_1947_2009.mat` is the supplied model input; do not
  alter it during analysis.
- `data/model17b.mat` contains fixed R2017b reference results for validation,
  not a runtime input to the report.

Use repository-relative paths such as
`data/us_macro_original_1947_2009.mat`; do not hard-code local machine paths.

## Running and Validation

Use the default build from the repository root after changes:

```matlab
buildtool
```

It fails on Code Analyzer errors and runs the complete test suite on every
invocation. Warnings and informational Code Analyzer results are nonfatal.

Run the maintained report through the build task:

```matlab
buildtool report
```

The task opens the project without prompting, executes
`us_macroeconomic_outlook.m` from the repository root, and closes the project
through cleanup logic even when report execution fails. It intentionally leaves
the report's figures and normal outputs visible.

For interactive report maintenance, open the project from the repository root:

```matlab
openProject('us_macroeconomic_outlook.prj')
open('us_macroeconomic_outlook.m')
```

Run the maintained plain-text Live Script in the Live Editor. It requires
Econometrics Toolbox and Financial Toolbox and is runnable in R2026b. The
supplied `.mlx` remains the unmodified historical R2017b artifact.

Validate loader changes with a focused smoke test:

```matlab
d = load_us_macro_data;
assert(isequal(size(d.Data),[249 14]))
```

To run just the regression tests while developing model utilities or report
calculations:

```matlab
runtests("tests")
```

`data/model17b.mat` is a deferred validation reference, not a runtime report
dependency. When resuming numerical validation, compare relevant estimates and
forecasts against its reference variables. The real-GDP tests intentionally
replay the 34 preceding report simulations to match the historical random
stream before comparing `FGDP`, `FGDPSigma`, and `trendFGDP`. Do not refresh,
download, replace, or edit supplied data or the original `.mlx`.

## MATLAB Style and Naming

Follow the existing four-space indentation and use descriptive lower camelCase
for local variables and function names (for example, `datasetFile` and
`repositoryRoot`). Use `UPPERCASE` only for supplied economic-series names
such as `GDP` and `UNRATE`. Keep validation failures explicit, with stable,
namespaced identifiers such as `usmacro:InvalidDataset`. Prefer `fullfile`,
`isfile`, and repository-relative paths for portable file handling.

## Changes and Review

Keep changes narrowly scoped and preserve the report's historical vintage and
attribution. Keep this guide and `README.md` current when report, project,
data-path, or validation behavior changes. When adding files or folders, add
them to the MATLAB project; add every resolvable artifact folder to the project
path and rerun project checks.

Git metadata is not present in this checkout, so no established commit-message
convention can be inferred. Use concise imperative commit subjects when Git is
available (for example, `Validate macro dataset dimensions`). Pull requests
should explain the analytical impact, list validation performed, link relevant
issues, and include figure screenshots when report visuals change.
