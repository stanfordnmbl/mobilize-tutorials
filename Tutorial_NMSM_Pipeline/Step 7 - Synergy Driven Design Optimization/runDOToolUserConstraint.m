%% Run DO with user-defined constraint

close all
tic
DesignOptimizationTool("DOSettingsUserConstraint.xml")
toc

%% Analyze results
plotTreatmentOptimizationResultsFromSettingsFile("DOSettingsUserConstraint.xml")
