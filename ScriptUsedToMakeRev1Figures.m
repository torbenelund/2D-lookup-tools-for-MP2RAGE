%% Make Figure 1
Figure1Script

%% Prepare data and MP2RAGE structure for Figure 2 in the paper 
Simple2DLUTConversionExample
DisplayConvertedImagesAndExplain2DLUTExample

%% Prepare all sessions for all subjects, without B1 correction, but with multiple B1+-manipulations:
ScriptUsedToCreateFiguresInThePaperRev1_S1_1 % Prepare subject 1 session 1
ScriptUsedToCreateFiguresInThePaperRev1_S1_2 % Prepare subject 1 session 2
ScriptUsedToCreateFiguresInThePaperRev1_S1_3 % Prepare subject 1 session 3
ScriptUsedToCreateFiguresInThePaperRev1_S4_1 % Prepare subject 2 session 1
ScriptUsedToCreateFiguresInThePaperRev1_S4_2 % Prepare subject 2 session 2
ScriptUsedToCreateFiguresInThePaperRev1_S4_3 % Prepare subject 2 session 3
ScriptUsedToCreateFiguresInThePaperRev1_S5_1 % Prepare subject 3 session 1

%% Make Figure 3 and 4 in the paper
MultisubjectSurfaceAndVolumeScript;

%% Analyse data for Figure 5 and make figure
ScriptUsedToCreateFiguresInThePaperRev1_S1_3_mod; %Prepare the data
Figure5Script % Script used to make Figure 5

%% Make density scatterplot Figure S2 in Suppplementary Material (R1-nulling)
ScriptUsedToCompareStdAndMeanInDensityPlot;

%% Script used to evaluate effect of curvature correction in supplementary material
ScriptUsedForCurvatureEvaluation; % to calculate standard deviations
PlotCurvatureCorrectionScript; % to create the figure

%% Script used for comparing UNI and Ratio based Sa2RAGE B1-mapping
ScriptUsedToCompareUNIAndRatioForB1Mapping;

%% Script used to process all subjects with and without B1-correction Multi-session Multi-NSlices etc.
ScriptUSedToPrepareB1CorrectionAllSubjects; % To perform the various analyses 
ScriptUsedToPlotRepetitionDist; % To create the surface-1D&2D histogram figures in the supplementary Material

%% Script used to create tables in the supplementary material:
ScriptUsedToMakeSegVolR1Table;



