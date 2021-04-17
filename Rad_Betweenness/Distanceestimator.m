function [Distance] = Distanceestimator(ST_input)
%Function that takes lat-lon data and gives the forward speed

%Converting lat and lon data to radians

for i=1:1:length(ST_input)
Lat_rad(i) = ST_input(i,3)*pi/180;
Lon_rad(i) = ST_input(i,4)*pi/180;
end

for i=1:1:length(ST_input)-1
    gamma(i) = asin(((((sin((Lat_rad(i)-Lat_rad(i+1))/2))^2) + (cos(Lat_rad(i)) * cos(Lat_rad(i+1)) * ((sin((Lon_rad(i)-Lon_rad(i+1))/2))^2)))^0.5))*2;
    Distance (i) = gamma(i)*6378.14;
end


