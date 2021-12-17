clear variables;
clc;

for i = 1:2    
    run(sprintf('DataSet%d.csv', i));
end

function run(filename)
    fprintf('File name: %s\n', filename);
    % Arrival time, Departure time
    records = readmatrix(filename);
    
    %% Arrival rate and throughput
    % Number of arrivals
    A = size(records, 1);
    % Number of completions
    C = size(records, 1);

    % Time = last departure time
    T = records(end, 2);

    % Arrival Rate (Lambda=(Number of arrivals)/T)
    Lambda = A/T;
    fprintf('Arrival rate: %f\n', Lambda);

    % Throughput (X=C/T)
    X = C/T;
    fprintf('Throughput: %f\n', X);
    
    %% Busy time
    Arrivals(:,1) = records(:,1);
    Arrivals(:,2) = 1;
    Departures(:,1) = records(:,2);
    Departures(:,2) = -1;
    concat = sortrows(cat(1, Arrivals, Departures));
    % Number of Jobs in the system for each point in time
    concat(:,3) = cumsum(concat(:,2));
    % Add the first row to the concatenation array 
%    concat = cat(1, [0 0 0], concat);
    % Create a new matrix with the duration of each number of job in the system
    durations(:,1) = concat(2:end,1) - concat(1:(end-1),1);
    durations(:,2) = concat(1:(end-1),3);
    % We compute is summing all the service time
    B = 0;
    for i=1:length(durations(:,1))
        % "~=" means "!=" in matlab
        if durations(i,2) ~= 0
            B = B + durations(i,1);
        end
    end
    fprintf('Busy time: %f\n', B);
    
    %% Utilization
    U = B/T;
    fprintf('Utilization: %f\n', U);
    
    %% W = Difference between the departures and the arrivals
    % (All the elements of the second column) - (All the elements of the first column)
    r_i = records(:,2)-records(:,1);

    % Sum of all response time r_i
    W = sum(r_i);
    fprintf('W: %d\n', W);

    %% Average Service Time
    S = U/X;
    fprintf('Average Service Time: %f\n', S);

    %% Average Number of Jobs in the system
    N = W/T;
    fprintf('Average Number of Jobs: %f\n', N);

    %% Average Response Time
    R = W/C;
    fprintf('Average Response Time: %f\n', R);

    %% Probability of having m jobs in the station (with m = 0, 1, 2, 3)
    p1 = zeros(4);
    for i=0:3
        p1(i+1) = time_M_Jobs(durations, i)/T;
    end
    fprintf('P(m=0):%f P(m=1):%f P(m=2):%f P(m=3):%f\n', p1(1), p1(2), p1(3), p1(4));
    
    %% Probability response time < threshold
    p2 = sum([r_i<1, r_i<10, r_i<50]) / C;
    fprintf('P(R<1):%f P(R<10):%f P(R<50):%f\n', p2(1), p2(2), p2(3));
    fprintf('\n');
end

function t = time_M_Jobs(durations, m)
    t = 0;
    for i=1:length(durations(:,1))
        if durations(i,2) == m
            t = t + durations(i,1);
        end
    end
end
