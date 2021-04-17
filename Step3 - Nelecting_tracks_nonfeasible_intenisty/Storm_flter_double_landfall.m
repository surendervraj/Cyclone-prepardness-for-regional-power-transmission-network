clear all
clc

% The following program is written to filter the storms which makes double
% landfall and makes the non feasible for intensity scales


load Track_Set_1000

Neg_track = [];

for i = 1:1:length(Track_Set_Final(1,1,:))
    
    Track = Track_Set_Final(:,:,i);
    [Track] = Track_interpol(Track);
    
    
    [isOcean] = land_or_ocean(Track(:,3),Track(:,4),100);
    
    B_Land = isOcean([1:1:13]);
    y = sum(B_Land);
    
    if y <= 11
        Neg_track = [Neg_track i ];
    end
    
    
    fprintf('Scenario%d\n',i)
    
    geoplot(Track(:,3),Track(:,4),'k')
    hold on
    geoscatter(Track(7,3),Track(7,4),'x','r','LineWidth',2)
    geobasemap topographic
    
end
save('Neg_track','Neg_track')




