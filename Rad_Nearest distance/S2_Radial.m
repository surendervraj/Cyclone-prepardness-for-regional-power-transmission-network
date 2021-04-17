% The following program is written with the objective to return the
% following two sets of results
clear all
clc

load Adj_Matrix
load Tracks_1
load Vmax_1
Tracks = Tracks_1;
Vmax = Vmax_1;
load Hard_nodes_radial

% 1. Matrix of dim 5 (various tower units i.e., 1000,2000) x 5 (various
% hardening ratio 1% 2% 5%)

load CDF_Landfall_Final
load NN_Copy
[Nodes,Nodes_text,Nodes_raw] = xlsread('Network_details.xlsx','Nodes');
Edges = xlsread('Network_details.xlsx','Unique_Edges');
Edges_wred = xlsread('Network_details.xlsx','Edges');


% Identifying the towers inside the polygon
Rows = find(Hard_nodes_radial == 1);


% Filtering the substations
H_nodes = [];
for i = 1:1:length(Rows)
    Node_Id = Rows(i);
    if NN_Copy(Node_Id,4) == 0
        H_nodes = [H_nodes; Node_Id];
    end
end


random_no = [0:0.001:1];
for i = 1:1:length(random_no)
    id_1 = random_no(i);
    Lat11(i) = interp1(CDF_Landfall_Final(:,3),CDF_Landfall_Final(:,1),id_1);
    Lon11(i) = interp1(CDF_Landfall_Final(:,3),CDF_Landfall_Final(:,2),id_1);
end

% Finding minimum distance from the coast of towers in the hardened zone


for i = 1:1:length(H_nodes)
    Node_Id = H_nodes(i);
    Lat_Node = NN_Copy(Node_Id,2);
    Lon_Node = NN_Copy(Node_Id,3);
    Input = [Lat11;Lon11];
    Input = Input';
    [Radialdistancetocoast] = Distancetocoast11(Input,[Lat_Node Lon_Node]);
     Min_distance(i) = min(Radialdistancetocoast);
end
H_nodes(:,2) = Min_distance;
H_nodes = sortrows(H_nodes,2);

no_of_towers = [1500,3000];
Hard_ratio = [10,20,100];

% Simulating Random numbers for damage simulation
no_of_simul = 1000;
            
 for p = 1:1:length(no_of_towers)
    
     for q = 1:1:length(Hard_ratio)

             
        nt = no_of_towers(p);
        hr = Hard_ratio(q);
        
        Hard_towers = H_nodes([1:1:nt],1);
        Hard_nodes1 = zeros(42035,1);
        Hard_nodes1(Hard_towers) = 1;
        [LOF_array,Damage_Matrix,Damaged_tower_recorder] = Final_parameters(Hard_nodes1,hr,Tracks,Vmax);
        LOF_Rad_ND_1(p,q) = (1- mean(LOF_array))*100;
        Damage_Rad_ND_1(p,q) = mean(Damage_Matrix(:,3));
        fprintf('towers%d\n',nt)
        fprintf('hard%d\n',hr)
           
        filename = ['DT', int2str(nt),int2str(hr),'.mat'];
        save(filename, 'Damaged_tower_recorder');
        
        filename = ['LOF', int2str(nt),int2str(hr),'.mat'];
        save(filename, 'LOF_array');
        
        filename = ['Damage_Mat', int2str(nt),int2str(hr),'.mat'];
        save(filename, 'Damage_Matrix');
        
        
    end
end
    
save('LOF_Rad_ND_1','LOF_Rad_ND_1')
save('Damage_Rad_ND_1','Damage_Rad_ND_1')

        
