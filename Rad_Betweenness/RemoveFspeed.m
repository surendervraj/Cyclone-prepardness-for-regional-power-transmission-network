function [Vmax_FR] = RemoveFspeed(Vmax,Fspeed)
%Function that removes the forward component of speed from Vmax

for i=1:1:length(Fspeed)
    if Fspeed(i)>=Vmax(i)
        Vmax_FR(i) = 0;
    else
        Vmax_FR(i) = Vmax(i)-(0.5*Fspeed(i));
end
end

