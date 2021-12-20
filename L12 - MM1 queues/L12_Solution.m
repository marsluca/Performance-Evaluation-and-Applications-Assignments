clear variables;
clc;

% Kendall's notation
% Poisson arrival, exponential service time, one server, 
% infinite queue and infinite population

% M/M/1 queue
% Poisson process arrival rate [job/s]
lambda = 10;
% Avg Service time, (ms -> seconds)
D = 85/1000;

% Service rate
u = 1/D;

%% Utilization
U = lambda*D;
fprintf("Utilization (equal to the traffic intensity): %f\n", U);

%% Probability of having exactly one job in the system
fprintf("P(J=1): %f\n", (1-lambda/u)*(lambda/u)^1);

%% Probability of having more than 5 jobs in the system
fprintf("P(J>5): %f\n", U^(5+1));
 
%% Average queue length (job not in service)
fprintf("Average queue length: %f\n", (U^2)/(1-U));

%% Average response time
R = D/(1-U);
fprintf("Average response time: %f sec\n", R);

%% Probability that the response time is greater than 0.5 s.
fprintf("P(R>0.5): %f or %f\n", exp(-(0.5*(u-lambda))), exp(-(0.5/R)));

%% 90 percentile of the response time distribution
fprintf("90 percentile of the response time: %f\n", -log(1-90/100)*R);
