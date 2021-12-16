clear variables;
clc;

N = 100;
% Avg Service time
S = [50/1000, 150/1000 ,25/1000];
% Visists
v = [0.7, 0.2, 1];
%Think time
Z = 10;

%% The demand of the three station
D = S.*v;
fprintf('Visits of the three stations: %f <-> %f <-> %f\n', D(1), D(2), D(3));

R = zeros(N, 3);
X = zeros(1, N);
currentN = zeros(N, 3);

for i=1:N
    if i == 1
        R(i,:) = D;
    else
        R(i,:) = D.*(1+[currentN(i-1,1) currentN(i-1,2) currentN(i-1,3)]);
    end
    X(i) = i/(Z+sum(R(i,:)));
    currentN(i,:) = R(i,:)*X(i);
end

%% System response time
FinalR = sum(R(N,:)); 
fprintf('System response time: %f\n', FinalR);

%% System throughput
fprintf('System throughput: %f\n', X(N));

