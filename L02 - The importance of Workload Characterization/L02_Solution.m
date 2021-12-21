clear variables;
clc;

% 192.168.10.149 - - [24/Sep/2021:10:56:11 -0200] "GET /heartbeat.php HTTP/1.1" 200 11828 "-" "Mozilla 8.1"
% The "*" inside "%*s" means: skip the current
% %*[^[] = Skip until "["
% %*[^\n] = Skip until new line
%records = textscan(fileID,'%*[^[] [%[^:]:%s %*[^\n]'); 

for i = 1:4 
    run(sprintf('Log%d.txt', i), i);
end

function run(filename, i)
    fprintf('File name: %s\n', filename);
    table_str = readtable(filename, 'Format','%*[^[] [%{dd/MMM/yyyy:HH:mm:ss}D %*[^\n]');

    table_sec = posixtime(table_str{:,1});

    %% Number of arrivals
    A = size(table_sec, 1);

    %% Set first arrival at time zero
    start_value = table_sec(1,:);
    for row = 1:A
        table_sec(row,:) = table_sec(row,:) - start_value;
    end

    %% The average inter arrival time [sec]
    % The "Inter arrival time" measures the time between the arrivals of two jobs
    Sum_Inter_Arrival = 0;
    N_IA = A-1;
    Inter_Arrival = zeros(1,N_IA);
    
    for row = 2:A
        difference = table_sec(row,:)-table_sec(row-1,:);
        Inter_Arrival(row-1) = difference;
        Sum_Inter_Arrival = Sum_Inter_Arrival + difference;
    end
    Avg_Inter_Arrival = Sum_Inter_Arrival/N_IA;
    fprintf('Average Inter-arrival time: %f\n', Avg_Inter_Arrival);
  
    %% The arrival rate [jobs/sec]
    % Total time "T"
    T = table_sec(A,:)-table_sec(1,:);

    l = A / T;
    fprintf('Arrival Rate : %f\n', l);
    
    %% Variability
    V = var(Inter_Arrival);
    fprintf('Variance: %f\n', V);
    
    % Standard Deviation
    std = sqrt(V);
    % First moment - mean
    m1 = sum(Inter_Arrival) / N_IA;
    % Coefficient of Variation
    cv =  std/m1;  
    fprintf('Variability (Coefficient of Variation of Inter_Arrival): %f\n', cv);
    
    %% Correlation
    % The cross-covariance for m=1
    ccv1 = sum((Inter_Arrival(1:N_IA-1)-m1).*(Inter_Arrival(2:N_IA)-m1)/(N_IA-1));
    fprintf('Correlation (cross-covariance for m=1): %f\n', ccv1);
    fprintf('\n');
    
    %% Plotting phase
    % Useful to determine the correlation between a set of sample
    figure('Name', filename, 'NumberTitle','off');
    Inter_ArrivalX = Inter_Arrival(2:end);
    Inter_ArrivalY = Inter_Arrival;
    Inter_ArrivalY(end) = [];
    plot(Inter_ArrivalX(1,:), Inter_ArrivalY(1,:), ".");
end


%% Old Plotting phase
%{
    figure('Name', filename, 'NumberTitle','off');
    for j = 1:(N_IA-1) 
        %plot(Inter_Arrival(j), Inter_Arrival(j+1), ".");
        hold on;
        drawnow;
    end
%}