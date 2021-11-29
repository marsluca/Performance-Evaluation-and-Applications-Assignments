clear variables;
clc;

filename = 'DataSet1.csv';
run(filename);
filename = 'DataSet2.csv';
run(filename);

function run(filename)
% Arrival time, Departure time
records = readmatrix(filename);
fprintf('File name: %s\n', filename);

% Number of arrivals
A = size(records, 1);
% Completions
C = size(records, 1);

% Time = last departure time
T = records(C, 2);

% Arrival Rate (Lambda=A/T)
Lambda = A/T;
fprintf('Arrival rate: %f\n', Lambda);

% Throughput (X=C/T)
X = C/T;
fprintf('Throughput: %f\n', X);

% Response time = difference between the
% departure time and the arrival time
r_i = records(:,2)-records(:,1);

% Sum of all response time r_i
W = sum(r_i);
fprintf('W: %d\n', W);

% Average Number of Jobs in the system
% (Little's law rielaboration)
N = W/T;
fprintf('Average Number of Jobs: %d\n', N);

% Average Response Time
% (Little's law rielaboration)
R = W/C;
fprintf('Average Response Time: %f\n', R);
 
% Probability response time < threshold
p = sum([r_i<1, r_i<10, r_i<50]) / C;
fprintf('P(R<1):%f P(R<10):%f P(R<50):%f\n', p(1), p(2), p(3));
fprintf('\n');
end
