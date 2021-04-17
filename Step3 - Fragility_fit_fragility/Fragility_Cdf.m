function [EDP,CDF] = Fragility_Cdf(Xm,Bm)

%Lognormal distribution - log(X) is normally distributed
mu = log (Xm);
EDP = [1:1:800];

for i = 1:1:length(EDP)
    ln_EDP(i) = log(EDP(i));
end

%Normal distribution function
for i = 1:1:length(EDP)
    PDF(i) = normpdf(ln_EDP(i),mu,Bm);
end

CDF = zeros(length(EDP),1);
CDF(1) = PDF(1);

for i = 1:1:length(EDP)-1
    CDF(i+1) = CDF(i) + (0.5 * (ln_EDP(i+1) - ln_EDP(i)) * (PDF (i) + PDF (i+1)));
end
