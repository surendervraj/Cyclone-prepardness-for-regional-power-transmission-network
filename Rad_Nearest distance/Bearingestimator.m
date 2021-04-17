function [Bearing] = Bearingestimator(ST_input)
%Function that takes lat-lon data and gives the bearing

%Converting lat and lon data to radians

for i=1:1:length(ST_input)
Lat_rad(i) = ST_input(i,3)*pi/180;
Lon_rad(i) = ST_input(i,4)*pi/180;
end

for i=1:1:length(ST_input)-1
    S(i) = cos(Lat_rad(i+1))*sin(Lon_rad(i)-Lon_rad(i+1));
    C(i) = (cos(Lat_rad(i))*sin(Lat_rad(i+1)))-(sin(Lat_rad(i))*cos(Lat_rad(i+1))*cos(Lon_rad(i)-Lon_rad(i+1)));
    Bearing(i) = atan2(S(i),C(i))*(180/pi)+(90);
    
end

%Bearing with respect to north
for i=1:1:length(ST_input)-1
    
    if Bearing(i) >= 90
        Bearing(i) = 360-(Bearing(i)-90);
    else
        Bearing(i)= 90-Bearing(i);
    end
end

