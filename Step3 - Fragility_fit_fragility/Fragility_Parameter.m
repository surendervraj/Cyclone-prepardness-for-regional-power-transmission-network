function [Xm,Bm,x,y,a] = Fragility_Parameter(DS)
% Dividing DS into bins

        N = 30;
        EDP_min = min(DS(:,2));
        EDP_max = max(DS(:,2));
        Spacing = (EDP_max - EDP_min)/(N);
        a = [EDP_min:Spacing:EDP_max];
        
        for i =1:1:N
            if i < N
                M(i) = 0;
                x(i) = 0;
                m(i) = 0;
                
        for j =1:1:length(DS)
            X = DS(j,2) - a(i);
            Y = DS(j,2) - a(i+1);
            
            if X < 0 
                X1 = 0;
            else
                X1 = 1;
            end
            
            if Y < 0 
                Y1 = 0;
            else
                Y1 = 1;
            end
            M(i) = M(i) + (X1-Y1);
            x(i) = (DS(j,2) * (X1 - Y1)) + x(i);
            m(i) = (DS(j,3) * (X1 - Y1)) + m(i);
        end
            else
                 M(i) = 0;
                x(i) = 0;
                m(i) = 0;
                        for j =1:1:length(DS)
                    X = DS(j,2) - a(i);
         
                if X < 0 
                X1 = 0;
                else
                X1 = 1;
                end
            
                M(i) = M(i) + X1;
                x(i) = (DS(j,2) * (X1)) + x(i);
                m(i) = (DS(j,3) * (X1)) + m(i);
                        end
        end
        end

for i=1:1:N
    x(i) = x(i)/M(i); 
end


%Removing the bins tat donot have any members in it
for mk=1:1:length(M)
    if M(mk) == 0
        row_id(mk) =1;
   
    else
        row_id(mk) =0;
    end
end
        

%Forming new x,m,M Vectors
for mk = 1:1:length(row_id)

    if row_id(mk) == 0
        x(mk) = x(mk);
        M(mk) = M(mk);
        m(mk) = m(mk);
    else
        x(mk) = 0;
        M(mk) = 0;
        m(mk) = 10000;
    end
    
end

 x(x==0) = [];
 M(M==0) = [];
 m(m==10000) = [];

 
 for z = 1:1:length(x)
     y(z) = m(z)/M(z);
 end
 
 set(0,'DefaultFigureWindowStyle','docked')
[fitresult] = Fit_fun(x, y, M);

coef_val= coeffvalues(fitresult);
 
 Bm = 1/ coef_val(2);
 Xm = exp(-coef_val(1)*Bm);

 
end

