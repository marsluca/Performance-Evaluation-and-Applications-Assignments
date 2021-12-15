clear variables;
clc;

% Poisson process arrival rate [job/s]
lambda = 0.95;

%% Compare the previous results with the ones of an M/M/1 system, with average service D = 0.9 s.
% Avg Service time [seconds]
D = 0.9;
fprintf("--- <Exercise 1 - M/M/1> ----\n");
% Average Utilization
U = lambda*D;
fprintf("Utilization (equal to the traffic intensity): %f\n", U);

% Probability of having 4 jobs in the system
fprintf("P(J=4): %f\n", (1-U)*U^4);

% Average number of jobs in the system
fprintf("Average number of jobs in the system: %f\n", U/(1-U));

% Average response time and the average time spent in the queue
R = D/(1-U);
fprintf("Average response time: %f sec\n", R);
fprintf("Average time spent in the queue: %f sec\n\n", R-D);

%% Exercise 1 - M/M/2
% Avg Service time [seconds]
D = 1.8;
fprintf("--- <Exercise 1 - M/M/2> ----\n");
% Average Utilization
U = lambda*D/2;
fprintf("Average Utilization (equal to the traffic intensity): %f\n", U);

% Probability of having 4 jobs in the system
fprintf("P(J=4): %f\n", 2*(1-U)/(1+U)*U^4);

% Average number of jobs in the system
fprintf("Average number of jobs in the system: %f\n", 2*U/(1-U^2));

% Average response time and the average time spent in the queue
fprintf("Average response time: %f sec\n", D/(1-U^2));
fprintf("Average time spent in the queue: %f sec\n\n", ((U^2)*D)/(1-U^2));

%% Exercise 2 - M/M/c
% Avg Service time [seconds]
D = 2.7;
c=3;
fprintf("--- <Exercise 2 - M/M/c> ----\n");
% Average Utilization
U = lambda*D/c;
fprintf("Average Utilization (equal to the traffic intensity): %f\n", U);

%Probability of having zero job in the system
p0=((((c*U)^c)/factorial(c))*((1-U)^(-1))+symsum(((c*U)^k)/factorial(k),k,0,c-1))^-1;
% Probability of having 4 jobs in the system
syms k;
p4 = (p0/(factorial(c)*c^(4-c)))*(lambda*D)^4;
fprintf("P(J=4): %f\n", p4);

% Average number of jobs in the system
N = c*U+(U/(1-U))/(1+(1-U)*(factorial(c)/(c*U)^c)*symsum((c*U)^k/factorial(k),k,0,c-1));
fprintf("Average number of jobs in the system: %f\n", N);

% Average response time and the average time spent in the queue
QueueTime = (D/(c*(1-U)))/(1+(1-U)*(factorial(c)/(c*U)^c)*symsum((c*U)^k/factorial(k),k,0,c-1));
fprintf("Average response time: %f sec\n", D + QueueTime);
fprintf("Average time spent in the queue: %f sec\n\n", QueueTime);

%% Exercise 3 - M/M/inf
% Avg Service time [seconds]
D = 2.7;
c=3;
fprintf("--- <Exercise 3 - M/M/inf> ----\n");
%Probability of having zero job in the system
p0=exp(-(lambda*D));
% Probability of having 4 jobs in the system
p4 = (p0/factorial(4))*(lambda*D)^4;
fprintf("P(J=4): %f\n", p4);

% Average number of jobs in the system
fprintf("Average number of jobs in the system: %f\n", lambda*D);

% Average response time and the average time spent in the queue
QueueTime = (D/(c*(1-U)))/(1+(1-U)*(factorial(c)/(c*U)^c)*symsum((c*U)^k/factorial(k),k,0,c-1));
fprintf("Average response time: %f sec\n", D);
fprintf("Average time spent in the queue: %f sec\n\n", 0);