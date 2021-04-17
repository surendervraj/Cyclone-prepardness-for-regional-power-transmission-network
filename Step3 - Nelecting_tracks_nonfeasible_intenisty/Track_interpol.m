function [Cyc_TrackFinal] = Track_interpol(Cyc_Track)

%Interpolates the given cyclone track to 30 minutes interval

a = min(Cyc_Track(:,2));
b = max(Cyc_Track(:,2));

%TI - Timeinterval
TI = 1.5;  % 30 minutes

Time_A = [a:TI:b];

for i=1:1:length(Time_A)
    T = Time_A(i);
    Lat(i) = interp1(Cyc_Track(:,2),Cyc_Track(:,3),T);
    Lon(i) = interp1(Cyc_Track(:,2),Cyc_Track(:,4),T);
    Vmax(i) = interp1(Cyc_Track(:,2),Cyc_Track(:,5),T);
end

Cyc_TrackFinal(:,1) = [1:1:length(Time_A)];
Cyc_TrackFinal(:,2) = Time_A;
Cyc_TrackFinal(:,3) = Lat;
Cyc_TrackFinal(:,4) = Lon;
Cyc_TrackFinal(:,5) = Vmax;

end

