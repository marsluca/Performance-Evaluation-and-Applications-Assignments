clear variables;
clc;

s=1;
t=0;

Tmax = 3600;
trace = [t,s];
R_counter=0;

% Report state
Ts1=0;
% Working state
Ts2=0;
% Maintenance state
Ts3=0;

while t < Tmax
    if s==1
        R_counter = R_counter + 1;
        % Exp distribution for Maintenance
        dtM = -log(rand())/(0.001);
        % Exp distribution for Working
        dtW = -log(rand())/(1);
        
        dt = min([dtM, dtW]);
        Ts1 = Ts1 + dt;
        if(dt == dtM)
			ns = 3;
        end
        if(dt == dtW)
			ns = 2;
        end
    end
    if s==2
        % Exp distribution for Manitance
        dtM = -log(rand())/(0.001);
        % Exp distribution for Report
        dtR = -log(rand())/(0.05);
        
        dt = min([dtM, dtR]);
        Ts2 = Ts2 + dt;
        if(dt == dtM)
			ns = 3;
        end
        if(dt == dtR)
			ns = 1;
        end
    end
    if s==3
        ns=2;
        dt= -log(rand())/(0.05);
        Ts3 = Ts3 + dt;
    end
    
    s = ns;
    t = t + dt;
    %trace(end + 1, :) = [t,s];
end

%% Probability of every stage
Ps1= Ts1/t;
fprintf("Probability of being in Report stage: %f\n", Ps1);
Ps2= Ts2/t;
fprintf("Probability of being in Working stage: %f\n", Ps2);
Ps3= Ts3/t;
fprintf("Probability of being in Maintenance stage: %f\n", Ps3);

%stairs(trace(:,1),trace(:,2));

%% Reporting frequency
fprintf("Reporting frequency: %f\n", R_counter/t);
