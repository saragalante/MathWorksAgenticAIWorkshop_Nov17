# Repository Guidelines

## Project Structure and Organization

- `us_macroeconomic_outlook.mlx` is the supplied historical Live Script.
  Preserve it unchanged.
- `us_macroeconomic_outlook.m` is the plain-text copy for report maintenance.
  Make report edits here and keep the original `.mlx` as the supplied artifact.
- `us_macroeconomic_outlook.prj` is the MATLAB project. Maintain its membership
  and keep `data/` on its project path.
- `data/load_us_macro_data.m` loads and validates the historical macroeconomic
  dataset. Reusable data-access logic belongs in this folder.
- `data/us_macro_original_1947_2009.mat` is the supplied model input; do not
  alter it during analysis.
- `data/model17b.mat` contains fixed R2017b reference results for validation,
  not a runtime input to the report.

Use repository-relative paths such as
`data/us_macro_original_1947_2009.mat`; do not hard-code local machine paths.

## Running and Validation

This project has no build system or automated test suite. Open the project from
the repository root before running the maintained report:

```matlab
openProject('us_macroeconomic_outlook.prj')
open('us_macroeconomic_outlook.m')
```

Run the plain-text Live Script in the Live Editor. It requires Econometrics
Toolbox and Financial Toolbox. In R2026b it is expected to stop at undefined
`vgxset`, a legacy function used by the historical R2017b analysis.

Validate loader changes with a focused smoke test:

```matlab
d = load_us_macro_data;
assert(isequal(size(d.Data),[249 14]))
```

When changing analysis logic, compare relevant estimates and forecasts against
the reference variables in `data/model17b.mat`. Do not refresh, download,
replace, or edit supplied data or the original `.mlx`.

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
