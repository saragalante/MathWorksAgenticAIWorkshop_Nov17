function plan = buildfile
%BUILDFILE Define build tasks for the U.S. macroeconomic outlook report.

    plan = buildplan(localfunctions);

    plan("codeIssues") = matlab.buildtool.tasks.CodeIssuesTask( ...
        ["buildfile.m", "us_macroeconomic_outlook.m", "data", "src", "tests"], ...
        ErrorThreshold=0);

    testTask = matlab.buildtool.tasks.TestTask("tests", ...
        SourceFiles=["data", "src"], ...
        SupportingFiles="data");
    testTask.DisableIncremental = true;
    plan("test") = testTask;

    plan("report") = matlab.buildtool.Task( ...
        Description="Run the maintained macroeconomic outlook report", ...
        Actions=@runReport);

    plan.DefaultTasks = ["codeIssues", "test"];
end

function runReport(~)
    repositoryRoot = fileparts(mfilename("fullpath"));
    project = openProject(fullfile(repositoryRoot, "us_macroeconomic_outlook.prj"), ...
        Prompt=false);
    projectCleanup = onCleanup(@() close(project));

    originalFolder = pwd;
    folderCleanup = onCleanup(@() cd(originalFolder));
    cd(repositoryRoot);
    reportFile = fullfile(repositoryRoot, "us_macroeconomic_outlook.m");
    eval(fileread(reportFile));
end
