function [Damage_Matrix_LB] = Damaged_Edges(Damaged_Towers_LB,Network_Node,Edges,Edges_wred)

% Damaged edges Lower bound 

for i = 1:1:length(Damaged_Towers_LB)
    if Damaged_Towers_LB(i) == 0
        Edge_damage_LB(i) = 0;
    else
    Node = Damaged_Towers_LB(i);
    Edge_damage_LB(i) = Network_Node(Node,5);
    end
end

Damaged_edges_LB = unique(Edge_damage_LB);



% Damage matrix start and end node lower bound
Damage_Matrix_LB = zeros(length(Damaged_edges_LB),4);


for i = 1:1:length(Damaged_edges_LB)
    if Damaged_edges_LB(i) == 0
        Damage_Matrix_LB(i,1) = 0;
        Damage_Matrix_LB(i,2) = 0;
        Damage_Matrix_LB(i,3) = 0;
        Damage_Matrix_LB(i,4) = 0;
    else 
    Damage_Matrix_LB(i,1) = Damaged_edges_LB(i);
    Damage_Matrix_LB(i,2) = Edges_wred(Damaged_edges_LB(i),2);
    Damage_Matrix_LB(i,3) = Edges_wred(Damaged_edges_LB(i),3);
    
    for j = 1:1:length(Edges)
        Node1 = Damage_Matrix_LB(i,2);
        Node2 = Damage_Matrix_LB(i,3);
        
        if Edges(j,2) == Node1 && Edges(j,3) == Node2
            Damage_Matrix_LB(i,4) = j;
        end
        
        if Edges(j,2) == Node2 && Edges(j,3) == Node1
            Damage_Matrix_LB(i,4) = j;
        end
        
    end
   
    end
end

end