%% Run DO with free final time

close all
tic
DesignOptimizationTool("DOSettingsFree.xml")
toc

%% Analyze results
plotTreatmentOptimizationResultsFromSettingsFile("DOSettingsFree.xml")
