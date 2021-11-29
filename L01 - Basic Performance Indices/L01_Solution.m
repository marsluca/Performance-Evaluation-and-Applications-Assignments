clear variables;

% Arrival time, Departure time
filename = 'DataSet1.csv';
records = readmatrix(filename);

% Number of arrivals
A = size(records, 1);
% Completions
C = size(records, 1);

% Time = last departure time
T = records(C, 2);

% Arrival Rate (Lambda=A/T)
Lambda = A/T;

% Throughput (X=C/T)
X = C/T;

% Response time = difference between the
% departure time and the arrival time
r_i = records(:,2)-records(:,1);

% Sum of all response time r_i
W = sum(r_i);

% Average Number of Jobs in the system
% (Little's law rielaboration)
N = W/T;

% Average Response Time
% (Little's law rielaboration)
R = W/C;
 
% Probability response time < threshold
p = sum([r_i<1, r_i<10, r_i<50]) / C;
