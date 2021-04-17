function [Si] = NewtonRaphson(NR)
%Function that solves 9 degree polynomial to get Si value
%NewtonRaphsonmethod
Si = 0.6;
error =1;
while error>=0.01
    fsi  = (126*Si^5)-(420*Si^6)+(540*Si^7)-(315*Si^8)+(70*Si^9)-NR;
    fdsi = (5*126*Si^4)-(6*420*Si^5)+(7*540*Si^6)-(8*315*Si^7)+(9*70*Si^8);
    Sii = Si -(fsi/fdsi);
    error = (Sii-Si)^2;
    Si = Sii;
end

