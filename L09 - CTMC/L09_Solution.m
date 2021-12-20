clear variables;
clc;

MTTF = 100;
MTTR = 5;
MTTbackup = 15;

f = 1/MTTF;
r = 1/MTTR;
b = 1/MTTbackup;

% From the graph for each row write the output arrows
% Diagonal = sum with opposite sign
%       s1    s2     s3     s4
Q = [ -f-f,   f  ,   f  ,   0;       %s1
        r ,  -f-r,   0  ,   f;       %s2
        r ,   0  , -r-f ,   f;       %s3
        b ,   0  ,  0   ,   -b];     %s4

% System starts in a state where both disks are working
%    s1 s2  s3 s4
p0 = [1, 0, 0, 0];

%Probability of each stage for each time instant
[t, Sol] = ode45(@(t,x) Q'*x, [0 10000], p0');

fprintf("Steady state probabilities:\n WW: %f\n FW: %f\n WF: %f\n FF: %f\n", Sol(end,1), Sol(end,2), Sol(end,3), Sol(end,4));

figure('Name', 'Probability of the states in the total range','NumberTitle','off');
plot(t, Sol, "-");
legend("WW", "FW", "WF", "FF");
xlabel('Days') ;
ylabel('Probability') ;

figure('Name', 'Probability of the states in the [0,10] range - log scale','NumberTitle','off');
semilogy(t, Sol, "-");
legend("WW", "FW", "WF", "FF");
xlim([0 10]);
xlabel('Time') ;
ylabel('Probability') ;