clear variables;
clc;

lambda1 = 0.5;

% Matrix (rows*columns) Probability(i,j) of choosing j after i
% Every row rappresent the current station
% Every column rappresent the next station
P = [ 0.7, 0.3, 0;
      0.5, 0  ,0.3;
      0, 1  , 0];

% In open models
% = [ lambda1/sum(all_lambda), lambda2/sum(all_lambda), lambda3/sum(all_lambda)];
L = [ 1, 0, 0];

% Service times
S = [ 1, 2, 2.5];
    
%% The visits of the three stations
v = L * inv(eye(3) - P);
fprintf('Visits of the three stations: %f <-> %f <-> %f\n', v(1), v(2), v(3));

%% The demand of the three station
D = v.*S;
fprintf('Demand of the three stations: %f <-> %f <-> %f\n\n', D(1), D(2), D(3));

%% Is the system stable?
% The system is stable only if the arrival rate is less than 1/maxD
rDmax = 1/max(D);
if lambda1 < rDmax
    fprintf('The system is STABLE beacuse (lambda:%f) < (1/max(D)%f)\n', lambda1, rDmax);
else
    fprintf('The system is NOT STABLE (lambda:%f) > (1/max(D):%f)\n', lambda1, rDmax);
    fprintf('or\nThe system is NOT STABLE (U1:%f) > 1\nUk should be < 1 for each k\n', lambda1*D(1));
end
