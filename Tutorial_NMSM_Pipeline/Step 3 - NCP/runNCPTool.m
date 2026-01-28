%% Run NCP

close all
tic
NeuralControlPersonalizationTool("NCPSettings.xml")
toc

%% Analyze results

plotNcpResultsFromSettingsFile("NCPSettings.xml")