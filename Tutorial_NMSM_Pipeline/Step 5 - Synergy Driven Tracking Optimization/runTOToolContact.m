%% Run TO with foot-ground contact for left foot

close all
tic
TrackingOptimizationTool("TOSettingsContact.xml")
toc

%% Analyze results
plotTreatmentOptimizationResultsFromSettingsFile("TOSettingsContact.xml")
