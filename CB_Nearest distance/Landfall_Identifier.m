function [Landfall_Id] = Landfall_Identifier(Cyc_TrackFinal)

Land_Tag = zeros(length(Cyc_TrackFinal),1);

for i=1:1:length(Cyc_TrackFinal)
    Land_Tag(i) = land_or_ocean(Cyc_TrackFinal(i,3),Cyc_TrackFinal(i,4),100);
    
end

i= 0;
X = 0;
while X == 0
    X = Land_Tag(length(Land_Tag)-i,1);
    i = i+1;
end

Landfall_Id = length(Land_Tag)-i+1;

end

