% The following program estimates the number of damaged towers and the loss
% of functionality during cyclone Fani


clear all
clc


% Inputs
load Network_Node
[Nodes,Nodes_text,Nodes_raw] = xlsread('Network_details.xlsx','Nodes');
Edges = xlsread('Network_details.xlsx','Unique_Edges');
Edges_wred = xlsread('Network_details.xlsx','Edges');
load Adj_Matrix
[Cyc_TrackFinal] = xlsread('Fani.xlsx');


% Estimating the 3-sec peak gust speed at all locations
[Landfall_Id] = Landfall_Identifier(Cyc_TrackFinal);
% Wiloughby double exponential model is used to estimate the wind speed
% Gust factor used  = 1.58

[Vmax_C] = WilloughbyDE(Cyc_TrackFinal(:,3),Cyc_TrackFinal(:,4),Cyc_TrackFinal(:,5),Network_Node(:,[2 3]),Cyc_TrackFinal(:,2),Landfall_Id);
Vmax_Tower = max(Vmax_C);
Vmax_Tower = Vmax_Tower';

No_of_runs = 100;

for mk = 1:1:No_of_runs
    
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
    
    %Estimating the damaged towers using random number geeration
     Damage_random = rand(42035,1);
    [Damaged_Towers] = Damaged_Nodes(P_PDS,Damage_random);
    [Damage_Number] = Numberofdamage(Damaged_Towers,Network_Node,Edges_wred,P_Collapse,P_PDS);
    
    Collapse_100_runs(mk) = Damage_Number(1,1);
    PDS_100_runs(mk) = Damage_Number(1,2);
    Total_100_runs(mk) = Damage_Number(1,1) + Damage_Number(1,2);
    
    Damaged_Towers = [];
    Damage_Number = [];
    
    fprintf('Run%d\n',mk)
    
end

save('Collapse_100_runs','Collapse_100_runs')
save('PDS_100_runs','PDS_100_runs')
save('Total_100_runs','Total_100_runs')

