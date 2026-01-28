%% Run TO

close all
tic
TrackingOptimizationTool("TOSettings.xml")
toc

%% Analyze results
plotTreatmentOptimizationResultsFromSettingsFile("TOSettings.xml")