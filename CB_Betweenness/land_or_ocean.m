function [isOcean] = land_or_ocean(lat,lon,coastal_res,make_plot)
% tic
switch nargin
    case 2
        coastal_res = 1;
        make_plot = 0;
    case 3
        make_plot = 0;
end
if(sum(lon>180)>0)
    lon(lon>180) = lon(lon>180) - 360;  %adjust if using [0,360) lon values
    sprintf('Adjusting lon values from [0,360) to (-180,180]')
end
%% Load coastal data
coast = load('coast.mat');
%% Define search region (want as small as possible to minimize computation)
lat_search_min = max([min(lat)-2 -90]); %deg N (-90,90]
lat_search_max = min([max(lat)+2 90]);  %deg N (-90,90]
lon_search_min = max([min(lon)-2 -180]);    %deg W (-180,180]
lon_search_max = min([max(lon)+2 180]); %deg W (-180,180]
%% Define land inside of coast
[Z, R] = vec2mtx(coast.lat, coast.long, ...
    coastal_res, [lat_search_min lat_search_max], [lon_search_min lon_search_max], 'filled');
%% Return land/ocean for each input point
val = ltln2val(Z, R, lat, lon);
isOcean = val == 2;
%isLand = ~isOcean;
%% Plot the points on geographic map
if(make_plot)
    figure; worldmap(Z, R)
    geoshow(Z, R, 'DisplayType', 'texturemap')
    colormap([0 1 0;0 0 0;0 1 0;0 0 1])
    plotm(lat,lon,'ro')
end
% toc
end

