%[text] # Modeling the U.S. Economy Workshop
%%
%[text] ## Exercise 1: Prepare the Live Script and Project
%[text] **Instructions**
%[text] - Remember to use Plan Mode!
%[text] - Create a copy of the .mlx report, run it, and note the first error. Keep the supplied report and data unchanged.
%[text] - Run /init. Review the generated AGENTS.md. Update it to preserve the supplied report and data.
%[text] - Keep the AGENTS.md and README.md updated.
%[text] - Create a plain-text live script copy and a MATLAB project. Work with the copy going forward.
%[text] - Verify that the project opens with data/ on the project path.
%[text] - Run the plain-text copy and confirm it loads the data before reaching the same error. \
%[text] **Copyable prompt**
%[text] - **/init**
%[text] - **Update** **`AGENTS.md`** **to preserve the supplied report and data. Keep the** **`AGENTS.md`** **and** **`README.md`** **updated. Create a plain-text copy of the supplied** **`.mlx`** **file and a MATLAB project. Update** **`AGENTS.md`** **to work with the copy and maintain the project. Verify that the project opens,** **`data/`** **is on the path, and the loader loads the supplied data. Run the plain-text copy and confirm it reaches the expected undefined** **`vgxset`** **error in R2026b.** \
%%
%[text] ## Exercise 2: Migrate the Report
%[text] **Instructions**
%[text] - Remember to use Plan Mode!
%[text] - Ask the agent to inspect the report, runtime failure, and Code Analyzer findings, then explain a migration plan before editing. Check whether it identifies relevant MATLAB skills.
%[text] - Review the plan. Ask about unfamiliar terms or decisions that could affect the economic interpretation. Prioritize a runnable report and defer numerical testing.
%[text] - Ask the agent to implement the plan. Run the complete report and review which sections ran. Resolve Code Analyzer findings.
%[text] - Check that the common sample (1959 Q1 through 2009 Q1), variable order, transformations, lag choices, forecast horizons, historical narrative, and supplied inputs remain preserved. \
%[text] **Copyable prompt**
%[text] - **Plan the migration of the complete report to MATLAB R2026b. Identify the legacy APIs to migrate and compatibility questions to resolve. Address Code Analyzer findings. Preserve the original narrative and analysis.** \
%%
%[text] ## Exercise 3: Test Numerical Behavior
%[text] **Instructions**
%[text] - Keep data/model17b.mat as fixed expected behavior, separate from historical model input.
%[text] - Extract VAR estimation into a testable function under src/. Add matlab.unittest checks for the intercept, lag coefficients, and innovation covariance against Spec.
%[text] - Run the fit tests with VAR(2). Temporarily change the lag order to VAR(1), confirm that the tests fail, then restore VAR(2) and rerun the tests.
%[text] - Extract the real GDP projection calculation into a testable function under src/. Add matlab.unittest checks for the mean, uncertainty, and trend. Inspect the report's random-seed setup and account for earlier simulation calls.
%[text] - Make sure the README.md and AGENTS.md are updated. \
%[text] **Copyable prompt**
%[text] - **Extract VAR estimation into a testable function under** **`src`****. Add tests comparing its fitted intercept, lag coefficients, and innovation covariance with the R2017b** **`Spec`** **in** **`data/model17b.mat`****.** \
%[text] - **Extract the real GDP projection calculation into a testable function under** **`src`****. Add tests for the mean, uncertainty, and trend against** **`data/model17b.mat`****. Inspect the report's random-seed setup to account for prior simulations.** \
%[text] - **Update the** **`README.md`** **and** **`AGENTS.md`****.** \
%%
%[text] ## Exercise 4: Inspect Coverage
%[text] **Instructions**
%[text] - Use MATLAB's coverage tools to review which code in the src/ functions the regression tests exercise.
%[text] - If coverage is below 100%, identify an uncovered path, add a relevant test, rerun the tests, and measure coverage again. \
%[text] **Copyable prompt**
%[text] **Add tests that exercise the error messages in** **`estimateVarModel.m`****.**
%%
%[text] ## Exercise 5: Create a Build File
%[text] **Instructions**
%[text] - Create a MATLAB build file with a default task that runs Code Analyzer and then runs the tests.
%[text] - Treat analyzer errors as blockers and suggestions as review findings.
%[text] - Ensure failed or incomplete tests fail the check task.
%[text] - Add a separate task for running the main report.
%[text] - Run the build from the project and inspect the results. Show what happens when a test fails. \
%[text] **Copyable prompt**
%[text] - **Create a MATLAB build file. The default task should run the Code Analyzer and the tests. Code Analyzer errors should cause the build to fail. Failed or incomplete tests should cause the build to fail. Add a separate task for running the main report.** \
%[text] - **Update the** **`README.md`** **and** **`AGENTS.md`****.** \

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
