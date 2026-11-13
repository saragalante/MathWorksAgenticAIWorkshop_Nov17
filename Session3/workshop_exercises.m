%[text] # Modeling the U.S. Economy Workshop
%%
%[text] ## Exercise 1: Prepare the Live Script and Project (5–13 minutes)
%[text] **Instructions**
%[text] - Remember to use Plan Mode!
%[text] - Create a copy of the .mlx report, run it, and note the first error. Keep the supplied report and data unchanged.
%[text] - Run /init. Review the generated AGENTS.md. Update it to preserve the supplied report and data.
%[text] - Keep the AGENTS.md and README.md updated.
%[text] - Create a plain-text live script copy and a MATLAB project. Work with the copy going forward.
%[text] - Verify that the project opens with data/ on the project path.
%[text] - Run the plain-text copy and confirm it loads the data before reaching the same error. \
%[text] **Copyable prompt**
%[text] ```text
%[text] In Plan Mode, run `/init` and review the generated `AGENTS.md`. Update it to preserve the supplied report and data, and keep `AGENTS.md` and `README.md` current. Create a plain-text copy of the supplied `.mlx` file and a MATLAB project. Use the copy going forward. Verify that the project opens with `data/` on the path, the loader loads the supplied data, and the plain-text copy reaches the expected undefined `vgxset` error in R2026b after loading the data.
%[text] ```
%%
%[text] ## Exercise 2: Migrate the Report (13–42 minutes)
%[text] **Instructions**
%[text] - Remember to use Plan Mode!
%[text] - Ask the agent to inspect the report, runtime failure, and Code Analyzer findings, then explain a migration plan before editing. Check whether it identifies relevant MATLAB skills.
%[text] - Review the plan. Ask about unfamiliar terms or decisions that could affect the economic interpretation. Prioritize a runnable report and defer numerical testing.
%[text] - Ask the agent to implement the plan. Run the complete report and review which sections ran. Resolve Code Analyzer findings.
%[text] - Check that the common sample (1959 Q1 through 2009 Q1), variable order, transformations, lag choices, forecast horizons, historical narrative, and supplied inputs remain preserved. \
%[text] **Copyable prompt**
%[text] ```text
%[text] In Plan Mode, inspect the complete report, its R2026b runtime failure, and Code Analyzer findings. Identify the legacy APIs to migrate and compatibility questions to resolve. Check for relevant MATLAB skills and propose a migration plan before editing. Preserve the original narrative and analysis. After reviewing the plan, migrate the report, run it completely, and resolve Code Analyzer findings. Defer numerical regression testing.
%[text] ```
%%
%[text] ## Exercise 3: Test Numerical Behavior (42–72 minutes)
%[text] **Instructions**
%[text] - Keep data/model17b.mat as fixed expected behavior, separate from historical model input.
%[text] - Extract VAR estimation into a testable function under src/. Add matlab.unittest checks for the intercept, lag coefficients, and innovation covariance against Spec.
%[text] - Run the fit tests with VAR(2). Temporarily change the lag order to VAR(1), confirm that the tests fail, then restore VAR(2) and rerun the tests.
%[text] - Extract the real GDP projection calculation into a testable function under src/. Add matlab.unittest checks for the mean, uncertainty, and trend. Inspect the report's random-seed setup and account for earlier simulation calls.
%[text] - Make sure the README.md and AGENTS.md are updated. \
%[text] **Copyable prompt**
%[text] ```text
%[text] Extract VAR estimation into a testable function under `src/`. Add `matlab.unittest` checks for its fitted intercept, lag coefficients, and innovation covariance against the R2017b `Spec` in `data/model17b.mat`. Run the tests with VAR(2), temporarily change the lag order to VAR(1) to confirm they fail, then restore VAR(2) and rerun. Extract the real GDP projection into a testable function under `src/` and add tests for its mean, uncertainty, and trend against `data/model17b.mat`. Inspect the report's random-seed setup and account for earlier simulations. Update `README.md` and `AGENTS.md`.
%[text] ```
%%
%[text] ## Exercise 4: Inspect Coverage (72–80 minutes)
%[text] **Instructions**
%[text] - Use MATLAB's coverage tools to review which code in the src/ functions the regression tests exercise.
%[text] - If coverage is below 100%, identify an uncovered path, add a relevant test, rerun the tests, and measure coverage again. \
%[text] **Copyable prompt**
%[text] ```text
%[text] Add tests that exercise the error messages in `estimateVarModel.m`.
%[text] ```
%%
%[text] ## Exercise 5: Create a Build File (80–89 minutes)
%[text] **Instructions**
%[text] - Create a MATLAB build file with a default task that runs Code Analyzer and then runs the tests.
%[text] - Treat analyzer errors as blockers and suggestions as review findings.
%[text] - Ensure failed or incomplete tests fail the check task.
%[text] - Add a separate task for running the main report.
%[text] - Run `buildtool` from the folder containing the Exercise 5 buildfile (`checkpoint-5/` in the supplied example), then inspect the results and show what happens when a test fails. \
%[text] **Copyable prompt**
%[text] ```text
%[text] Create a MATLAB build file with a default task that runs the Code Analyzer and test suite. Make Code Analyzer errors fail the build. Make failed or incomplete tests fail the build. Add a separate task for running the main report. Run `buildtool` from the folder containing this exercise buildfile; in the supplied example, use `checkpoint-5/`. Update `README.md` and `AGENTS.md`.
%[text] ```
%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
