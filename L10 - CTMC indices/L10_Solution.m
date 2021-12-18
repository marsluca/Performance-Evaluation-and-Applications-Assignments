clear variables;
clc;

% Average durations
WA = 10;
WB = 5;
EA = 8;
EB = 12;
TotalTime = 100;

% Rates waiting
rWA = 1/WA;
rWB = 1/WB;
% Rates for normal execution
rEA = 1/EA;
rEB = 1/EB;
% Rates for parallel execution
p_rEA = 1/(EA*2);
p_rEB = 1/(EB*2);

% From the graph for each row write the output arrows
% Diagonal = sum with opposite sign
%       s1    s2         s3          s4
Q = [ -p_rEA-p_rEB ,p_rEA  ,  p_rEB,   0;       %s1
        rWA ,  -rWA-rEB    ,   0   , rEB;       %s2
        rWB ,   0  , -rWB-rEA,  rEA;            %s3
        0   ,   rWB  ,  rWA  ,  -rWB-rWA];      %s4

% System initial status
%    s1 s2  s3 s4
p0 = [1, 0, 0, 0];
alphaU = [1, 1, 1, 0];
alphaN = [2, 1, 1, 0];

% We have a completed execution (1 value) every time we have a transaction from an Execution to a Waiting
%      s1 s2 s3 s4
Ex = [ 0, 1, 1, 0;    %s1
       0, 0, 0, 1;    %s2
       0, 0, 0, 1;    %s3
       0, 0, 0, 0];   %s4
    
[t, Sol] = ode45(@(t,x) Q'*x, [0 TotalTime], p0');

%{
figure(1);
plot(t, Sol, "-");
legend("EE", "WE", "EW", "WW");

figure(2);
plot(t, Sol * alphaU', "-");
legend("Power");

[Sol(end,:) * alphaU', max(Sol * alphaU')]
%}

%% Utilization and average number of tasks in execution
% Utilization calulcated with matrix formulas
U1 = Sol(end,:) * alphaU';
% Alternative way to calculate the Utilization with the full formula on the slide
U2 = 0;
for i=1:length(Sol(end,:))
    U2 = U2 + Sol(end,i)*alphaU(i);
end
fprintf("Utilization: %f or %f\n", U1, U2);
N = Sol(end,:) * alphaN';
fprintf("Avg number of tasks: %f\n", N);

%% Throughput
X = 0;
for i=1:length(Sol(end,:))
    multiplier = 0;
    for j=1:length(Ex(:,end))
        % In Mathlab "~=" means "!="
        if j ~= i
            multiplier = multiplier + Q(i,j)*Ex(i,j);
        end
    end
    if multiplier ~= 0
        X = X + Sol(end,i)*multiplier;
    end
end
fprintf("Throughput: %f\n", X);

%% Number of jobs at t = 10s, t = 20s, t = 50s and t = 100s
times = [10, 20, 50, 100];
for i=1:length(times)
    % Save the index of the time with the closest value to the one specified in the text    
    [val,idx]=min(abs(t-times(i)));
    fprintf("Solution found for t=%f is N=%f\n", t(idx), Sol(idx,:) * alphaN');
end

%% Plotting phase
figure('Name', 'Utlization','NumberTitle','off');
plot(t, Sol * alphaU', "-");
xlabel('Seconds') ;
ylabel('Utlization') ;

figure('Name', 'Avg Number of tasks','NumberTitle','off');
plot(t, Sol * alphaN', "r-");
xlabel('Seconds') ;
ylabel('Tasks') ;
