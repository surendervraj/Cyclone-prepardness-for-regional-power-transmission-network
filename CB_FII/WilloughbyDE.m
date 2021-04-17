function [Vmax_C] = WilloughbyDE(X_Lat,Y_Lon,Vmax_ST,Gridpoint,Time,Landfall_TimeId)

ST_input(:,1) = [1:1:length(X_Lat)];
ST_input(:,2) = Time;
ST_input(:,3) = X_Lat;
ST_input(:,4) = Y_Lon;
ST_input(:,5) = Vmax_ST;

ST_input_Sea = ST_input([1:1:Landfall_TimeId],:);
ST_input_Land = ST_input([Landfall_TimeId+1:1:length(X_Lat)],:);

%Given the lat-lon data compute distance by Haversine's method
%Distance divided by the time interval  ----> Forward speed


Distance = Distanceestimator(ST_input);

%Forward speed in kmph
for i=1:1:length(ST_input)-1
Fspeed(i) = Distance(i)/(ST_input(i+1,2)-ST_input(i,2));
end

%Calculating the direction of motion of storm
Bearing = Bearingestimator(ST_input);

%Calculating the forward components of velocity
%U - component along east
%V - component along north
for i=1:1:length(Fspeed)
    if Bearing(i) <=  90
        Teta(i) = (90-Bearing(i))*pi/180;
        Fspeed_u(i) = Fspeed(i)*cos(Teta(i));
        Fspeed_v(i) = Fspeed(i)*sin(Teta(i));
    else
        Teta(i) = (Bearing(i)-270)*pi/180;
        Fspeed_u(i) = Fspeed(i)*cos(Teta(i))*(-1);
        Fspeed_v(i) = Fspeed(i)*sin(Teta(i));
    end
end

%Removing the forward component of V from Vmax
 Vmax = ST_input(:,5);       
 Vmax_FR = RemoveFspeed(Vmax,Fspeed);
 
 %Converting 10m sustained wind speed to gradient wind speed
%Knaff et all 2011
%Reduction factor = 0.9 (over water) and 0.72 (over land)
%Reduction factor at interface = 0.72 (assumed)


for i=1:1:length(ST_input_Sea)
    Vmax_G(i) = Vmax_FR(i)/0.9;
end

for i = (length(ST_input_Sea)+1):1:(length(ST_input)-1)
    Vmax_G(i) = Vmax_FR(i)/0.72;
end

%Calculating radius of maximum wind speed
%Willoughby et al model depends on Vmax_G and latitude
Rmax = RadiusMaxSpeed(Vmax_G,ST_input);

%Calculating Willoughby Parameters
[X1,n,A] = WilloughbyParameters(Vmax_G,ST_input);

%Estimating the radius of transition zones R1 and R2
%R1 and R2 are functions of si and si is estimated using a 9 degree
%polynomial

for i=1:1:length(X1)
NR(i) = ((25*A(i)+((1-A(i))*X1(i)))*n(i))/(((25*A(i)+((1-A(i))*X1(i)))*n(i))+Rmax(i));
end

for i=1:1:length(X1)
Si(i) = NewtonRaphson(NR(i));
end

for i=1:1:length(Si)
    if Rmax(i)>20
        R1(i) = Rmax(i) - Si(i)*25;
        R2(i) = R1(i)+25;
    else
        R1(i) = Rmax(i) - Si(i)*15;
        R2(i) = R1(i)+15;
    end
end

%As of now not getting any input from user
%A radius vector will be defined and wind profile is to be estimated

r = [0:1:3000];
%Calculating Azimuthal wind speed at each radius and at each time instant
for i=1:1:length(X1)
    AV_R(i,:) = AzimuthalWindspeed(Vmax_G(i),Rmax(i),n(i),R1(i),R2(i),r,X1(i),A(i));
end

%Calculating surface level wind speed - from gradient wind speed
%Calculating reduction factors - Ocean
for i=1:1:length(r)
if r(i)<=100
    RF_Sea(i) = 0.9;
else
    if r (i)>= 700
        RF_Sea(i) = 0.75;
    else
        RF_Sea(i) = ((0.15/-600)*r(i)) + (0.925);
    end
end
end

%Calculating reduction factors - Ocean
for i=1:1:length(r)
if r(i)<=100
    RF_Land(i) = 0.9*0.8;
else
    if r (i)>= 700
        RF_Land(i) = 0.75*0.8;
    else
        RF_Land(i) = (((0.15/-600)*r(i)) + (0.925))*0.8;
    end
end
end



%Calculating reduction factors - Land
for i=1:1:length(ST_input_Sea)
    for j = 1:1:length(r)
    AV_Surface(i,j)= RF_Sea(j)*AV_R(i,j);
    end
end
for i = (length(ST_input_Sea)+1):1:(length(ST_input)-1)
    for j = 1:1:length(r)
    AV_Surface(i,j)= RF_Land(j)*AV_R(i,j);
    end
end

%Calculating the correction factor 'U' to add forward speed
for i=1:1:length(ST_input)-1
    for j=1:1:length(r)
        U(i,j) = (Rmax(i)*r(j)/(Rmax(i)^2 + r(j)^2));
        Fspeedadd(i,j) = U(i,j)*Fspeed(i);
        WSS(i,j) = AV_Surface(i,j) + Fspeedadd(i,j);
    end
end



for mj = 1:1:length(Gridpoint)
%Radius to coast
RC = Distancetocoast1(ST_input,Gridpoint(mj,:));

for i=1:1:length(RC)-1
    j=1;
while r(j+1) < RC(i)
    if WSS(i,j) < WSS(i,j+1)
                V(i) = (((WSS(i,j+1)-WSS(i,j))/(r(j+1)-r(j)))*(RC(i)-r(j)))+WSS(i,j);
    else
                V(i) = (((WSS(i,j+1)-WSS(i,j))/(r(j+1)-r(j)))*(RC(i)-r(j)))+WSS(i,j+1);
    end
    j = j+1;
end
end

Vmax_Contour(:,mj) = V;
end

Vmax_C = Vmax_Contour*1.58;
