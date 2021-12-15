clear variables;
clc;

% Rate of the Poisson stream of request
lambda = 10;

%Demands [ms -> sec]
D1=85/1000;
D2=75/1000;
D3=50/1000;

%% Utilization of the three stations
U1 = lambda*D1;
U2 = lambda*D2;
U3 = lambda*D3;
fprintf('Utilization of the three stations: %f <-> %f <-> %f\n', U1, U2, U3);

%% Average number of jobs in the three stations
fprintf('Average number of jobs in the three stations: %f <-> %f <-> %f\n', U1/(1-U1), U2/(1-U2), U3/(1-U3));

%% Average system response time
R1 = D1/(1-U1);
R2 = D2/(1-U2);
R3 = D3/(1-U3);
R = R1 + R2 + R3;
fprintf('Residence time of the three stations: %f <-> %f <-> %f\n', R1, R2, R3);
fprintf('Average system response time: %f\n', R);
fprintf('Average number of jobs in the system: %f\n', lambda*R);


