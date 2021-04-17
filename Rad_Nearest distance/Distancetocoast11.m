function [Radialdistancetocoast] = Distancetocoast11(ST_input,Gridpoint)
%This function is employed to calculate the radial distance between storm
%eye and coastal districts at each and every timme  instance

%Converting Lat-Long to radians
for i=1:1:length(ST_input)
Lat_rad(i) = ST_input(i,1)*pi/180;
Lon_rad(i) = ST_input(i,2)*pi/180;
end

for i=1:1:1
GLat_rad(i) = Gridpoint(i,1)*pi/180;
GLon_rad(i) = Gridpoint(i,2)*pi/180;
end

for i=1:1:1
    for j=1:1:length(ST_input)
        gamma(i,j) = asin(((((sin((GLat_rad(i)-Lat_rad(j))/2))^2) + (cos(GLat_rad(i)) * cos(Lat_rad(j)) * ((sin((GLon_rad(i)-Lon_rad(j))/2))^2)))^0.5))*2;
        Radialdistancetocoast(i,j) = gamma(i,j)*6378.14;
    end
end
