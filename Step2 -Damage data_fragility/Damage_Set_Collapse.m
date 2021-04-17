% The following program is written to form damage data sets
% Dataset 
% Col-1 Node Number
% Col-2 3-sec peak gust speed
% Col-3 Failure Tag (1 - failed , 0 - not failed)
clear all
clc
%% Inputs

WS = xlsread('WS_All_locations.xlsx');
Col = xlsread('Collapsed.xlsx');

%% Forming failure tag array
F_Tag = zeros(length(WS),1);

for i = 1:1:length(Col)
    Node = Col(i,2);
    F_Tag(Node) = 1;
    ws(i,1) = WS(Node,2);
end

%% Forming data set
DS_C(:,1) = [1:1:42035];
DS_C(:,2) = WS(:,2);
DS_C(:,3) = F_Tag;

%% Forming data set neglecting the substations
DS_C = DS_C([218:1:42031],:);

save('DS_C','DS_C')


