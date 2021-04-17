function [LOF_array,Damage_Matrix,Damaged_tower_recorder] = Final_parameters(Hard_nodes,Hard_ratio,Damage_random1)


% Inputs
load Network_Node
[Nodes,Nodes_text,Nodes_raw] = xlsread('Network_details.xlsx','Nodes');
Edges = xlsread('Network_details.xlsx','Unique_Edges');
Edges_wred = xlsread('Network_details.xlsx','Edges');
load Adj_Matrix
load Tracks
load Vmax
Damaged_tower_recorder = zeros(length(Network_Node),length(Tracks));


No_of_scenarios = length(Tracks(1,1,:));

for z = 1:1:No_of_scenarios
    
%     Cyc_TrackFinal = Track_Set_Final(:,:,z);
% 
%     % Estimating the 3-sec peak gust speed at all locations
%     [Landfall_Id] = Landfall_Identifier(Cyc_TrackFinal);
%     % Wiloughby double exponential model is used to estimate the wind speed
%     % Gust factor used  = 1.58
% 
%     [Vmax_C] = WilloughbyDE(Cyc_TrackFinal(:,3),Cyc_TrackFinal(:,4),Cyc_TrackFinal(:,5),Network_Node(:,[2 3]),Cyc_TrackFinal(:,2),Landfall_Id);
%     Vmax_Tower = max(Vmax_C);
%     Vmax_Tower = Vmax_Tower';
    Vmax_Tower = Vmax(:,z);
    
    % Estimating collapse probabilities at tower locatios
    for i = 1:1:length(Vmax_Tower)
    if Network_Node(i,4) == 0
        
        if Hard_nodes(i) == 0
        P_Collapse(i) = normcdf((log(Vmax_Tower(i)) - log(295.1382))/0.1017);
        else
        P_Collapse(i) = normcdf((log(Vmax_Tower(i)) - log(295.1382 + (295.1382*Hard_ratio/100)))/0.1017);
        end
        
        
    else
        P_Collapse(i) = 0;

    end
    end

    % Estimating partial damage probabilities at tower locatios
    for i = 1:1:length(Vmax_Tower)
    if Network_Node(i,4) == 0
        
        if Hard_nodes(i) == 0
        P_PDS(i) = max(P_Collapse(i) , normcdf((log(Vmax_Tower(i)) - log(282.8939))/0.0847));
        else
        P_PDS(i) = max(P_Collapse(i) , normcdf((log(Vmax_Tower(i)) - log(282.8939 + (282.8939*Hard_ratio/100)))/0.0847));
        end
        
        
    else
        P_PDS(i) = 0;

    end
    end
	
            No_of_runs = 20;
            for mk = 1:1:No_of_runs
                %Estimating the damaged towers using random number
                %generation and functionality loss
                
                Damage_random = Damage_random1(:,mk);
                [Damaged_Towers] = Damaged_Nodes(P_PDS,Damage_random);
                [Damage_Number] = Numberofdamage(Damaged_Towers,Network_Node,Edges_wred,P_Collapse,P_PDS);
                [Damage_Matrix_Scenario] = Damaged_Edges(Damaged_Towers,Network_Node,Edges,Edges_wred);
                [LOF(mk)] = loss_of_functionality(Damage_Matrix_Scenario,Adj_Matrix,Nodes,Edges);
               
                
                
                
               
                C_scenario(mk) = Damage_Number(1,1);
                P_scenario(mk) = Damage_Number(1,2);
                T_scenario(mk) = Damage_Number(1,1) + Damage_Number(1,2);
                
                for pj = 1:1:length(Damaged_Towers)
                    if Damaged_Towers(pj) >= 1
                    Node_Id = Damaged_Towers(pj);
                    Damaged_tower_recorder(Node_Id,z) = 1; 
                    end
                end
                
                Damaged_Towers = [];
                Damage_Number = [];
                Damage_Matrix_Scenario = [];
                
                
                fprintf('Scenario%d\n',z)
                fprintf('Run%d\n',mk)
            end
            
            Damage_Matrix(z,1) = mean(C_scenario);
            Damage_Matrix(z,2) = mean(P_scenario);
            Damage_Matrix(z,3) = mean(T_scenario);
            
            LOF_array(z,1) = mean(LOF(mk));
            
end

end

