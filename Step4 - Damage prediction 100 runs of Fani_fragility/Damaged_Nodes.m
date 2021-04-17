function [Damaged_Towers_Median] = Damaged_Nodes(P_PDS,Damage_random)

% Damaged nodes - Median
Damaged_Towers_Median = [];
for i = 1:1:length(P_PDS)
    if Damage_random(i) <= P_PDS(i)
        Damaged_Towers_Median = [Damaged_Towers_Median; i];
    end
end
TF2 = isempty(Damaged_Towers_Median);


if TF2 == 1
    Damaged_Towers_Median = 0;
end


end

