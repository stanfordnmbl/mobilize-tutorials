%% Run DO

close all
tic
DesignOptimizationTool("DOSettings.xml")
toc

%% Analyze results
plotTreatmentOptimizationResultsFromSettingsFile("DOSettings.xml")
