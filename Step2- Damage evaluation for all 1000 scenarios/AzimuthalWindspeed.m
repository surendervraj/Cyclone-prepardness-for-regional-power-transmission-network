function [AV_R] = AzimuthalWindspeed(Vmax_G,Rmax,n,R1,R2,r,X1,A)
%Function which calculates azimuthal wind speed 

for i=1:1:length(r)
    if r(i)<R1
       AV_R(i) = Vmax_G*(r(i)/Rmax)^n ;
       
    else
        if  r(i)>R2
            AV_R(i) = Vmax_G*((1-A)*exp(-(r(i)-Rmax)/X1)+(A*exp(-(r(i)-Rmax)/25)));
        else
            Si = (r(i)-R1)/(R2-R1);
            w = (126*Si^5)-(420*Si^6)+(540*Si^7)-(315*Si^8)+(70*Si^9);
            VI = Vmax_G*(r(i)/Rmax)^n ;
            VO = Vmax_G*((1-A)*exp(-(r(i)-Rmax)/X1)+(A*exp(-(r(i)-Rmax)/25)));
            AV_R(i) = (VO*w)+(VI*(1-w));
        end
    end
end
        


end

