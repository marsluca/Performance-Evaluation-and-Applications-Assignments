clear variables;
clc;

A = csvread('Traces.csv');

%% Moments calculation
% First moment
m1 = mean(A);
% Second moment
m2 = mean(A.^2);
% Third moment
m3 = mean(A.^3);
% Fourth moment
m4 = mean(A.^4);

%% Fit the data against the uniform, the exponential, the two stages hyper-exponential and 
%% the two stage hypo-exponential distributions using the method of moments

% Uniform "A" method moment
Unif_A_MM = m1-sqrt(12*(m2-m1.^2))/2;
Unif_B_MM = m1+sqrt(12*(m2-m1.^2))/2;

% Exponential "A" using method moment
%Exp_A_MM =

% Two stages hyper-exponential "A" using method moment
%HyperExp_A_MM =
% "fsolve" solve system of equations, specified by F(x)=0
HE_pars_MM = fsolve(@MM_HyperExp, [0.5, 0.5, 0.5]);

% Two stages hypo-exponential "A" using method moment
%HypoExp_A_MM =
 


%% Fit the data against the exponential, the two stages hyper-exponential and the two stage 
%% hypo-exponential distributions using the method of maximum likelihood



%% Plotting Phase
for i = 1:4 
    MM_run(i, Unif_A_MM, Unif_B_MM);
end

function MM_run(i, Unif_A_MM, Unif_B_MM)
    fprintf('Trace number: %d\n', i);
    global A;
    len = length(A);
    figure(i);
    % linspace generates N points between X1 and X2
    xUnif = linspace(Unif_A_MM(i), Unif_B_MM(i), 100);
    plot(sort(A(:,i)), [1:len]/len, ".", xUnif, [0:99]/99, "*" , [0:100]/10, 1-HE_pars_MM(3)*exp(-x*HE_pars_MM(1)) - (1-HE_pars_MM(3))*exp(-x*HE_pars_MM(2)) , "-r");
end