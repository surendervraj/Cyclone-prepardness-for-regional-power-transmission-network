function [Damaged_Towers_Median] = Damaged_Nodes(P_PDS,Network_Node)



Prob_Ranges = [0.0155,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1];

for j = 1:1:length(Prob_Ranges)-1
     for i=1:1:length(Network_Node)
    
        if P_PDS(i) >= Prob_Ranges(j) &&  P_PDS(i) < Prob_Ranges(j+1)
        
         Failed_NodeId_PDS(i) = Network_Node(i,1);
        
        else
         Failed_NodeId_PDS(i) = 0;
        end
     end
     
         Failed_Node_Matrix_PDS(:,j) = Failed_NodeId_PDS;
    
end

% Section 9 : Finding the total number of nodes to be removed

for i=1:1:length(Prob_Ranges)-1
    Failed_NodeId_PDS = Failed_Node_Matrix_PDS(:,i);
    Failed_NodeId_PDS(Failed_NodeId_PDS == 0) = [];
    No_of_PDS_nodes(i) = length(Failed_NodeId_PDS);
    Damaged_nodes(i) = floor(No_of_PDS_nodes(i)*(Prob_Ranges(i)+Prob_Ranges(i+1))*0.5);
end

Total_Damaged_Nodes = sum(Damaged_nodes);

% Section 10 : Selecting the nodes to be removed from each probability category

Nodes_removed_PDS = [];

for i=1:1:length(Prob_Ranges)-1
    Failed_NodeId_PDS = Failed_Node_Matrix_PDS(:,i);
    Failed_NodeId_PDS(Failed_NodeId_PDS == 0) = [];
    
    Total_Nodes_Range = length(Failed_NodeId_PDS);
    
    
    
    Node_removal_Random = randperm(Total_Nodes_Range,Damaged_nodes(i));
    
    Node_removal_ID = [];
    for j=1:1:Damaged_nodes(i)
        Node_removal_ID(j) = Failed_NodeId_PDS(Node_removal_Random(j));
    end
    
    Nodes_removed_PDS = [Nodes_removed_PDS Node_removal_ID];
    Node_removal_ID = [];
    
end

Damaged_Towers_Median = Nodes_removed_PDS;
TF2 = isempty(Damaged_Towers_Median);

if TF2 == 1
    Damaged_Towers_Median = 0;
end


end

