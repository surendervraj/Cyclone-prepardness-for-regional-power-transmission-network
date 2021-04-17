% The following program is written to form damage data sets
% Dataset 
% Col-1 Node Number
% Col-2 3-sec peak gust speed
% Col-3 Failure Tag (1 - failed , 0 - not failed)

clear all
clc
%% Inputs

WS = xlsread('WS_All_locations.xlsx');
PDS = xlsread('PDS.xlsx');

%% Forming failure tag array
F_Tag = zeros(length(WS),1);

for i = 1:1:length(PDS)
    Node = PDS(i,2);
    F_Tag(Node) = 1;
    ws(i,1) = WS(Node,2);
end

%% Forming data set
DS_P(:,1) = [1:1:42035];
DS_P(:,2) = WS(:,2);
DS_P(:,3) = F_Tag;

%% Forming data set neglecting the substations
DS_P = DS_P([218:1:42031],:);

save('DS_P','DS_P')

