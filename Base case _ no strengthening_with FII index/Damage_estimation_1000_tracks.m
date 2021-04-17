clear all
clc


% The following program evaluates the damage to power transmission network
% for the simulated 1000 scenarios like Fani.

% Outputs recorded
% 1. Windspeed for all 1000 scenarios at transmission tower locations
% 2. Failure probabilities (Collapse and PDS) of all transmission towers for all scenarios
% 3. Number of transmission towers damaged (Collapsed, Partially damaged,
% Total)

% Inputs
load Network_Node
[Nodes,Nodes_text,Nodes_raw] = xlsread('Network_details.xlsx','Nodes');
Edges = xlsread('Network_details.xlsx','Unique_Edges');
Edges_wred = xlsread('Network_details.xlsx','Edges');
load Adj_Matrix
load Tracks_1
load Vmax_1
Tracks = Tracks_1;
Vmax = Vmax_1;
load NN_Copy


No_of_scenarios = length(Tracks(1,1,:));
Damaged_tower_recorder_1 = zeros(length(Network_Node),length(Tracks));

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
        P_Collapse(i) = normcdf((log(Vmax_Tower(i)) - log(295.1382))/0.1017);
    else
        P_Collapse(i) = 0;

    end
    end

    % Estimating partial damage probabilities at tower locatios
    for i = 1:1:length(Vmax_Tower)
    if Network_Node(i,4) == 0
        P_PDS(i) = max(P_Collapse(i) , normcdf((log(Vmax_Tower(i)) - log(282.8939))/0.0847));
    else
        P_PDS(i) = 0;

    end
    end
	
    
            No_of_runs = 1000;
            
            for mk = 1:1:No_of_runs
                %Estimating the damaged towers using random number
                %generation and functionality loss
                
%                 Damage_random1 = Damage_random(:,mk);
                [Damaged_Towers] = Damaged_Nodes(P_PDS,Network_Node);
                [Damage_Number] = Numberofdamage(Damaged_Towers,Network_Node,Edges_wred,P_Collapse,P_PDS);
                [Damage_Matrix_Scenario] = Damaged_Edges(Damaged_Towers,NN_Copy,Edges,Edges_wred);
                [LOF(mk)] = loss_of_functionality(Damage_Matrix_Scenario,Adj_Matrix,Nodes,Edges);         
     
               
                  
                % Estimating the hardening coefficicient
                Hard_Coeff = ones(length(Edges),1)*100;
                
                for i=1:1:length(Damage_Matrix_Scenario)
                Edge2 = Damage_Matrix_Scenario(i);
                if Edge2 >= 1
                    New_Damage_Matrix = Damage_Matrix_Scenario;

                    if length(New_Damage_Matrix) > 1
                    New_Damage_Matrix(i) = [];
                    else
                        New_Damage_Matrix(i) = 0;
                    end


                    [LOF_hard] = loss_of_functionality(New_Damage_Matrix,Adj_Matrix,Nodes,Edges);
                   
                    
                    Hard1 = ((LOF_hard - LOF(mk))/LOF(mk))*100;
                    Hard_Coeff(Edge2,1) = max(100,(Hard1 + Hard_Coeff(Edge2,1)));
                 
                    New_Damage_Matrix = [];
                    
                end
                
                end
                
                
                
                C_scenario(mk) = Damage_Number(1,1);
                P_scenario(mk) = Damage_Number(1,2);
                T_scenario(mk) = Damage_Number(1,1) + Damage_Number(1,2);
                Hard_Mat(:,mk) = Hard_Coeff;
           
               for pj = 1:1:length(Damaged_Towers)
                    if Damaged_Towers(pj) >= 1
                    Node_Id = Damaged_Towers(pj);
                    Damaged_tower_recorder_1(Node_Id,z) = 1; 
                    end
               end
                
               
             
                Damaged_Towers = [];
                Damage_Number = [];
                Damage_Matrix_Scenario = [];
                
                fprintf('Scenario%d\n',z)
                fprintf('Run%d\n',mk)
            end 
            Damage_Matrix_1(z,1) = mean(C_scenario);
            Damage_Matrix_1(z,2) = mean(P_scenario);
            Damage_Matrix_1(z,3) = mean(T_scenario);
            
            LOF_array_1(z,1) = mean(LOF(mk));
            Hard_coeff_mat_1(:,z) = mean(Hard_Mat,2);
end


save('Damage_Matrix_1','Damage_Matrix_1')
save('LOF_array_1','LOF_array_1')
save('Damaged_tower_recorder_1','Damaged_tower_recorder_1')
save('Hard_coeff_mat_1','Hard_coeff_mat_1')
