clear variables;
clc;

s=1;
t=0;

Tmax = 10000;
trace = [t,s];

Ts1=0;
Ts2=0;
Ts3=0;

while t < Tmax
    if s==1
        dt = -(log(rand()) + log(rand()) + log(rand())) / 0.1; 
        Ts1 = Ts1 + dt;
        if rand() < 0.8
			ns = 2;
        else
            if rand() < 0.5
                ns = 3;
            else
            	ns = 1;
            end 
        end 
    end
    if s==2
        dt= -log(rand())/(0.01);
        Ts2 = Ts2 + dt;
        if rand() < 0.5
            ns = 3;
        else
            ns = 1;
        end 
    end
    if s==3
        ns=1;
        dt= -log(rand())/(0.005);
        Ts3 = Ts3 + dt;
    end
    
    s = ns;
    t = t + dt;
    % The below command is useful to draw the plot of the stage over time
    % trace(end + 1, :) = [t,s];
end

%% Probability of every stage
Ps1= Ts1/t;
fprintf("Probability of being in First stage: %f\n", Ps1);
Ps2= Ts2/t;
fprintf("Probability of being in Second stage: %f\n", Ps2);
Ps3= Ts3/t;
fprintf("Probability of being in Third stage: %f\n", Ps3);

% stairs(trace(:,1),trace(:,2));

%% Utilization of the system
fprintf("Utilization of the system: %f\n", Ps1+Ps2);
