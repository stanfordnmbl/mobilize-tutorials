%% Run DO with user-defined cost function

close all
tic
DesignOptimizationTool("DOSettingsUserCost.xml")
toc

%% Analyze results
plotTreatmentOptimizationResultsFromSettingsFile("DOSettingsUserCost.xml")
