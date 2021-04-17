function [Rmax] = RadiusMaxSpeed(Vmax_G,ST_input)
%Function to calculate radius of maximum wind speed
Vmax_GM = (5/18)*Vmax_G;

for i=1:1:length(Vmax_GM)
    Rmax(i) = 46.9*exp((-0.0155*Vmax_GM(i))+0.0169*ST_input(i,3));
end

