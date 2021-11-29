clear variables;

% 192.168.10.149 - - [24/Sep/2021:10:56:11 -0200] "GET /heartbeat.php HTTP/1.1" 200 11828 "-" "Mozilla 8.1"
% The "*" inside "%*s" means: skip the current
% %*[^[] = Skip until "["
% %*[^\n] = Skip until new line
%records = textscan(fileID,'%*[^[] [%[^:]:%s %*[^\n]'); 

table_str = readtable('Log4.txt', 'Format','%*[^[] [%{dd/MMM/yyyy:HH:mm:ss}D %*[^\n]');

table_sec = posixtime(table_str{:,1});

%% Number of arrivals
A = size(table_sec, 1);

%% Set time zero
start_value = table_sec(1,:);
for row = 1:A
    table_sec(row,:) = table_sec(row,:) - start_value;
end

%% The average inter arrival time [sec]
% The "Inter arrival time" measures the time between the arrivals of two jobs
Sum_Inter_Arrival = 0;
Inter_Arrival = zeros(1,A-1);

for row = 2:A
    difference = table_sec(row,:)-table_sec(row-1,:);
    Inter_Arrival(row-1) = difference;
    Sum_Inter_Arrival = Sum_Inter_Arrival + difference;
end
Avg_Inter_Arrival = Sum_Inter_Arrival/A;

%% The arrival rate [jobs/sec]
% Total time "T"
T = table_sec(A,:)-table_sec(1,:);

Arrival_Rate = A / T;

%% Variability
V = var(Inter_Arrival);

%% Correlation
table_sec_copy =  table_sec;
table_sec_copy(1,:) = [];
table_sec(A,:) = [];

scatter(table_sec(:,1), table_sec_copy(:,1),'.');
