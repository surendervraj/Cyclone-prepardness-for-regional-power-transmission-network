function [LOF_Pop_LB] = loss_of_functionality(Damage_Matrix_LB,Adj_Matrix,Nodes,Edges)
% Modifying the adjacency matrix by removing the damaged edges

% Lower Bound

S1 = sum( Damage_Matrix_LB , 'all' );

if S1 > 0
Adj_LB_Copy = Adj_Matrix;
for i = 1:1:length(Damage_Matrix_LB)
    EdgeId = Damage_Matrix_LB(i);
    S_Node = Edges(EdgeId,2);
    E_Node = Edges(EdgeId,3);
    
    Adj_LB_Copy(S_Node,E_Node) = Adj_LB_Copy(S_Node,E_Node) - 1;
    Adj_LB_Copy(E_Node,S_Node) = Adj_LB_Copy(E_Node,S_Node) - 1;
end

[SS_GC_LB] = largestcomponent(Adj_LB_Copy);
SS_NGC_LB = Nodes(:,1);

for  i = 1:1:length(SS_GC_LB)
SS_NGC_LB = SS_NGC_LB(SS_NGC_LB~=SS_GC_LB(i));
end

if length(SS_NGC_LB) >= 1
% Functionality loss - size of giant component
LOF_SGC_LB = length(SS_GC_LB)/length(Nodes(:,1));

% Functionality loss based on population
for i = 1:1:length(SS_NGC_LB)
    Node = SS_NGC_LB(i);
    Pop_Node(i) = Nodes(Node,5);
end

LOF_Pop_LB = (sum(Nodes(:,5)) - sum(Pop_Node))/sum(Nodes(:,5));
else
    LOF_SGC_LB = 1;
    LOF_Pop_LB = 1;
    Adj_LB_Copy = Adj_Matrix;
    SS_NGC_LB = 0;
end
    

else
     LOF_SGC_LB = 1;
     LOF_Pop_LB = 1;
     Adj_LB_Copy = Adj_Matrix;
     SS_NGC_LB = 0;
end
    

end

