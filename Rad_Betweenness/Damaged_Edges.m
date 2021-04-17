function [Damage_Matrix_LB] = Damaged_Edges(Damaged_Towers_LB,NN_Copy,Edges,Edges_wred)

% Damaged edges Lower bound 

for i = 1:1:length(Damaged_Towers_LB)
    if Damaged_Towers_LB(i) == 0
        Edge_damage_LB(i) = 0;
    else
    Node = Damaged_Towers_LB(i);
    Edge_damage_LB(i) = NN_Copy(Node,5);
    end
end

Damage_Matrix_LB = unique(Edge_damage_LB);
Damage_Matrix_LB = Damage_Matrix_LB';

end

