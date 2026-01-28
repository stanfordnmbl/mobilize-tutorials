%% Run NCP

close all
tic
GroundContactPersonalizationTool("GCPSettings.xml")
toc

%% Analyze results

plotGcpResultsFromSettingsFile("GCPSettings.xml")
