%% Run VO

close all
tic
VerificationOptimizationTool("VOSettings.xml")
toc

%% Analyze results
plotTreatmentOptimizationResultsFromSettingsFile("VOSettings.xml")
