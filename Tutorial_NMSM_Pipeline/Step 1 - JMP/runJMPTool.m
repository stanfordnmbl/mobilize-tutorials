%% Run JMP

close all
tic
JointModelPersonalizationTool("JMPSettings.xml")
toc

%% Analyze results

plotJmpResultsFromSettingsFile("JMPSettings.xml")

