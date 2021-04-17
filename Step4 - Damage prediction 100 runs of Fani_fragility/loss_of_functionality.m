function [LOF_Pop_Median,SS_NGC_Median] = loss_of_functionality(Damage_Matrix_Median,Adj_Matrix,Nodes,Edges)
% Modifying the adjacency matrix by removing the damaged edges



% Median
S2 = sum( Damage_Matrix_Median , 'all' );

if S2 > 0
Adj_Median_Copy = Adj_Matrix;
for i = 1:1:length(Damage_Matrix_Median(:,4))
    EdgeId = Damage_Matrix_Median(i,4);
    S_Node = Edges(EdgeId,2);
    E_Node = Edges(EdgeId,3);
    
    Adj_Median_Copy(S_Node,E_Node) = Adj_Median_Copy(S_Node,E_Node) - 1;
    Adj_Median_Copy(E_Node,S_Node) = Adj_Median_Copy(E_Node,S_Node) - 1;
end

[SS_GC_Median] = largestcomponent(Adj_Median_Copy);
SS_NGC_Median = Nodes(:,1);

for  i = 1:1:length(SS_GC_Median)
SS_NGC_Median = SS_NGC_Median(SS_NGC_Median~=SS_GC_Median(i));
end

if length(SS_NGC_Median) >= 1
% Functionality loss - size of giant component
LOF_SGC_Median = length(SS_GC_Median)/length(Nodes(:,1));

% Functionality loss based on population
for i = 1:1:length(SS_NGC_Median)
    Node = SS_NGC_Median(i);
    Pop_Node(i) = Nodes(Node,5);
end

LOF_Pop_Median = (sum(Nodes(:,5)) - sum(Pop_Node))/sum(Nodes(:,5));
else
    LOF_SGC_Median = 1;
    LOF_Pop_Median = 1;
    Adj_Median_Copy = Adj_Matrix;
    SS_NGC_Median = 0;
    
end
    

else
     LOF_SGC_Median = 1;
     LOF_Pop_Median = 1;
     Adj_Median_Copy = Adj_Matrix;
     SS_NGC_Median = 0;
end


end

