function [Damage_Number] = Numberofdamage(Damaged_Towers_LB,Network_Node,Edges_wred,P_Collapse,P_PDS)

Damage_Number = zeros(1,6);

for i = 1:1:length(Damaged_Towers_LB)
    
    if Damaged_Towers_LB(i)==0
        Damage_Number(1,:) = 0;
    else
    Node = Damaged_Towers_LB(i);
    PCollapse = P_Collapse(Node);
    PPDS = P_PDS(Node);
    Line = Network_Node(Node,5);
    Voltage = Edges_wred(Line,4);
    
    if PCollapse < PPDS
    X_range = [ 0 (PCollapse/PPDS) 1];
    Y_range = [0 1 2];
    Random = rand(1);
    DS = ceil(interp1(X_range,Y_range,Random));
    
    end
    
    if PCollapse == PPDS
    Random = rand(1);
        if Random < 0.5
            DS = 1;
        else
            DS = 2;
        end
    end
    
    
    if DS == 1
        Damage_Number(1,1) = Damage_Number(1,1) + 1;
    end
    if DS == 2
        Damage_Number(1,2) = Damage_Number(1,2) + 1;
    end
    if Voltage == 765
        Damage_Number(1,3) = Damage_Number(1,3) + 1;
    end
    if Voltage == 400
        Damage_Number(1,4) = Damage_Number(1,4) + 1;
    end  
    if Voltage == 220
        Damage_Number(1,5) = Damage_Number(1,5) + 1;
    end  
    if Voltage == 132
        Damage_Number(1,6) = Damage_Number(1,6) + 1;
    end 
    end
end



end