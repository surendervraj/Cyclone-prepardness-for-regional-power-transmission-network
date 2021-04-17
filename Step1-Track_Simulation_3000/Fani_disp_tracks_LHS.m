clear all
clc

load Cyc_Track
load CDF_Landfall_Final
CDF_Landfall = CDF_Landfall_Final;


Cyc_TrackFinal = Cyc_Track;
[Landfall_Id] = Landfall_Identifier(Cyc_TrackFinal);
scenario = 3000;

% Generating random number using LHS
Rand = lhsdesign(scenario,2);

% Finding a new landfall loaction in th coast of Odisha
for mk =1:1:scenario
% Chosing a landfall latitude

Lat_rand(mk) = interp1(CDF_Landfall(:,3),CDF_Landfall(:,1),Rand(mk,1));
Lon_rand(mk) = interp1(CDF_Landfall(:,3),CDF_Landfall(:,2),Rand(mk,1));

% Displacement of actual track

x_disp = Cyc_TrackFinal(Landfall_Id,4) - Lon_rand(mk);
y_disp = Cyc_TrackFinal(Landfall_Id,3) - Lat_rand(mk);

for i = 1:1:length(Cyc_TrackFinal)
    x(i) = Cyc_TrackFinal(i,4) - x_disp;
    y(i) = Cyc_TrackFinal(i,3) - y_disp;
end

% Rotation of displaced track
x_center = x(Landfall_Id);
y_center = y(Landfall_Id);


theta(mk) = Rand(mk,2)*90*pi/180;

[x_rotated,y_rotated] = Rot_XY(x,y,theta(mk),x_center,y_center);

% Track Set Matrix

Track_Set_Matrix(:,1) = Cyc_TrackFinal(:,1);
Track_Set_Matrix(:,2) = Cyc_TrackFinal(:,2);
Track_Set_Matrix(:,3) = y_rotated;
Track_Set_Matrix(:,4) = x_rotated;
Track_Set_Matrix(:,5) = Cyc_TrackFinal(:,5);
Track_Set_Final(:,:,mk) = Track_Set_Matrix;
fprintf('TrackNo%d\n',mk)
end

for i = 1:1:scenario
    geoplot(Track_Set_Final(:,3,i),Track_Set_Final(:,4,i),'k')
    hold on
end

save('Track_Set_1000','Track_Set_Final')
save('Lat_rand','Lat_rand')
save('Lon_rand','Lon_rand')
save('theta','theta')