clear all
clc

load Neg_track
load Track_Set_1000
load Lat_rand 
load Lon_rand
load theta
load Vmax_Mat

% Removing the non feasible tracks from all the results
Track_Set_Final(:,:,Neg_track) = [];
Lat_rand(Neg_track) = [];
Lon_rand(Neg_track) = [];
theta(Neg_track) = [];
Vmax_Mat(:,Neg_track) = [];

Tracks = Track_Set_Final;
LF_Lat = Lat_rand;
LF_Lon = Lon_rand;
LF_theta = theta;
Vmax = Vmax_Mat;


save('Tracks','Tracks')
save('LF_Lat','LF_Lat')
save('LF_Lon','LF_Lon')
save('LF_theta','LF_theta')
save('Vmax','Vmax')