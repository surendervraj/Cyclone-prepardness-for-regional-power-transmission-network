function [X1,n,A] = WilloughbyParameters(Vmax_G,ST_input)
%Function that returns all the Willoughby parameters

Vmax_GM = (5/18)*Vmax_G;

%Calculation of X1
for i=1:1:length(Vmax_GM)
    X1(i) = 317.1 - 2.026*Vmax_GM(i) + 1.915*ST_input(i,3);
end

%Calculation of n
for i=1:1:length(Vmax_GM)
    n(i) = 0.4067 + 0.0144*Vmax_GM(i) - 0.0038*ST_input(i,3);
end

%Calculation of A
for i=1:1:length(Vmax_GM)
    A(i) = 0.0696 + 0.0049*Vmax_GM(i) - 0.0064*ST_input(i,3);
    if A(i)<0
        A(i)=0;
    else
        A(i)= A(i);
    end
end

end

