clear variables;
clc;

% Choice probability
pW = 0.3;
pM = 0.7;
% HyperExp - Computing constants
Cl1 = 5;
Cl2 = 10;
Cp = 0.4;
% HyperExp - Wifi constants
Wl1 = 1;
Wl2 = 20;
Wp = 0.75;
% Erlang - 4G constants
Ml = 8;
Ms = 3;

%      s1   s2  s3  s4  s5  s6  s7
Q = [  -Cl1*pW*Wp-Cl1*pW*(1-Wp)-Cl1*pM,    0, Cl1*pW*Wp, Cl1*pW*(1-Wp),Cl1*pM,  0,  0;             %s1
       0,-Cl2*pW*Wp-Cl2*pW*(1-Wp)-Cl2*pM, Cl2*pW*Wp, Cl2*pW*(1-Wp),Cl2*pM,  0,  0;             %s2
     Wl1*Cp,  Wl1*(1-Cp),-Wl1*Cp-Wl1*(1-Cp),      0,     0,  0,  0;             %s3
     Wl2*Cp,  Wl2*(1-Cp),      0,-Wl2*Cp-Wl2*(1-Cp),     0,  0,  0;             %s4
       0,    0,      0,      0,   -Ml, Ml,  0;             %s5
       0,    0,      0,      0,     0, -Ml, Ml;             %s6
      Ml*Cp,   Ml*(1-Cp),      0,      0,     0,  0,  -Ml*Cp-Ml*(1-Cp);];           %s7
  
%                   s1  s2 s3 s4 s5 s6 s7
p0 =             [0.5, 0.5, 0, 0, 0, 0, 0];
alphaComputing =    [1, 1, 0, 0, 0, 0, 0];
alphaWiFi =         [0, 0, 1, 1, 0, 0, 0];
alpha4G =           [0, 0, 0, 0, 1, 1, 1];

%      s1 s2 s3 s4 s5 s6 s7
Ex = [ 0, 0, 0, 0, 0, 0, 0;
       0, 0, 0, 0, 0, 0, 0;
       1, 1, 0, 0, 0, 0, 0;
       1, 1, 0, 0, 0, 0, 0;
       0, 0, 0, 0, 0, 0, 0;
       0, 0, 0, 0, 0, 0, 0;
       1, 1, 0, 0, 0, 0, 0;];

[t, Sol] = ode45(@(t,x) Q'*x, [0 10], p0');

%% Compute the system throughput
X = 0;
for i=1:length(Sol(end,:))
    multiplier = 0;
    for j=1:length(Ex(:,end))
        % In Mathlab "~=" means "!="
        if j ~= i
            multiplier = multiplier + Q(i,j)*Ex(i,j);
        end
    end
    if multiplier ~= 0
        X = X + Sol(end,i)*multiplier;
    end
end
fprintf("Throughput: %f\n", X);

%% Compute the probability of being Computing, WiFi or 4G
fprintf("Steady state probabilities:\n Computing: %f\n WiFi: %f\n 4G: %f\n", Sol(end,1)+Sol(end,2), Sol(end,4)+Sol(end,3), Sol(end,5)+Sol(end,6)+Sol(end,7));

figure('Name', 'Probability of the states','NumberTitle','off');
plot(t, Sol(:,1)+Sol(:,2), t, Sol(:,4)+Sol(:,3), t, Sol(:,5)+Sol(:,6)+Sol(:,7), "-");
legend("Computing", "WiFi", "4G");
xlabel('Seconds') ;
ylabel('Probability') ;

figure('Name', 'Probability of the stages','NumberTitle','off');
plot(t, Sol, "-");
legend("Computing stage 1", "Computing stage 2", "Wifi stage 1", "Wifi stage 2", "4G stage 1", "4G stage 2", "4G stage 3");
xlabel('Seconds') ;
ylabel('Probability') ;
