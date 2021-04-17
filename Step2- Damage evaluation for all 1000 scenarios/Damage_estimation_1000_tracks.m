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
load Track_Set_1000

No_of_scenarios = 3000;

for z = 1:1:No_of_scenarios
    
    Cyc_TrackFinal = Track_Set_Final(:,:,z);

    % Estimating the 3-sec peak gust speed at all locations
    [Landfall_Id] = Landfall_Identifier(Cyc_TrackFinal);
    % Wiloughby double exponential model is used to estimate the wind speed
    % Gust factor used  = 1.58

    [Vmax_C] = WilloughbyDE(Cyc_TrackFinal(:,3),Cyc_TrackFinal(:,4),Cyc_TrackFinal(:,5),Network_Node(:,[2 3]),Cyc_TrackFinal(:,2),Landfall_Id);
    Vmax_Tower = max(Vmax_C);
    Vmax_Tower = Vmax_Tower';
    
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
	
            No_of_runs = 1;
            for mk = 1:1:No_of_runs
                %Estimating the damaged towers using random number geeration
                 Damage_random = rand(42035,1);
                [Damaged_Towers] = Damaged_Nodes(P_PDS,Network_Node);
                [Damage_Number] = Numberofdamage(Damaged_Towers,Network_Node,Edges_wred,P_Collapse,P_PDS);
                C_scenario(mk) = Damage_Number(1,1);
                P_scenario(mk) = Damage_Number(1,2);
                T_scenario(mk) = Damage_Number(1,1) + Damage_Number(1,2);
                Damaged_Towers = [];
                Damage_Number = [];
                fprintf('Scenario%d\n',z)
                fprintf('Run%d\n',mk)
            end
            
            Damage_Matrix(z,1) = mean(C_scenario);
            Damage_Matrix(z,2) = mean(P_scenario);
            Damage_Matrix(z,3) = mean(T_scenario);
            
            Vmax_Mat(:,z) = Vmax_Tower;
            P_Col_Mat(:,z) = P_Collapse;
            P_PDS_Mat(:,z) = P_PDS;
            
end


save('Damage_Matrix','Damage_Matrix')
save('Vmax_Mat','Vmax_Mat')


