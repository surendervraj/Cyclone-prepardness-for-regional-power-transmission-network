% The following rogram is written to identify the fragility function
% parameters Xm and Bm using method of weighted least square fit

clear all
clc

%% Inputs
load DS_C
load DS_P

%% Fragility fit
% Collapse
[Xm_C,Bm_C,x_c,y_c,a] = Fragility_Parameter(DS_C);

% Partial damage
[Xm_P,Bm_P,x_p,y_p] = Fragility_Parameter(DS_P);


