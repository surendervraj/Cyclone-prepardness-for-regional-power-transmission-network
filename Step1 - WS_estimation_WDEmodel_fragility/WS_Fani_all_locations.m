% The following program is written to estimate the wind speed at all tower
% locations using Willoughby double exponentila model

clear all
clc


%% 1. Inputs 
% Cyclone track

Cyc_TrackFinal = xlsread('FANI.xlsx');
[Landfall_Id] = Landfall_Identifier(Cyc_TrackFinal);

% Network data - grid locations of all nodes
load Network_Node


%% 2. Estimation of wind speed at tower sites
% Wiloughby double exponential model is used to estimate the wind speed
% Gust factor used  = 1.58

[Vmax_C] = WilloughbyDE(Cyc_TrackFinal(:,3),Cyc_TrackFinal(:,4),Cyc_TrackFinal(:,5),Network_Node(:,[2 3]),Cyc_TrackFinal(:,2),Landfall_Id);
Vmax_Tower = max(Vmax_C);
Vmax_Tower = Vmax_Tower';
Vmax = Vmax_Tower;

save('Vmax','Vmax')