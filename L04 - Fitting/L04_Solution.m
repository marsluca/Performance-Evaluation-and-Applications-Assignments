clear variables;
clc;

% Service times
global A;
A = csvread('Traces.csv');

%% Moments calculation
global m1;
global m2;
global m3;
% First moment
m1 = mean(A);
% Second moment
m2 = mean(A.^2);
% Third moment
m3 = mean(A.^3);
% Fourth moment
m4 = mean(A.^4);

%% Uniform "A" method moment
global Unif_A_MM;
global Unif_B_MM;
Unif_A_MM = m1-sqrt(12*(m2-m1.^2))/2;
Unif_B_MM = m1+sqrt(12*(m2-m1.^2))/2;


%% Plotting Phase
for i = 1:4 
    MM_run(i);
    MaxLikelihood_run(i);
end

function MM_run(i)
    global Unif_A_MM;
    global Unif_B_MM;
    global A;
    global m1;
    
    %% Exponential "A" using method moment
    E_lambda = 1./m1;
    
    %% Two stages hyper-exponential "A" using method moment
    % "fsolve" solve system of equations, specified by F(x)=0
    % This function returns the best parameters of p,l1 and l2 that fit the trace
    HyperE_values = fsolve(@HyperExp_MM, [0.5, 0.5, 0.5, i]);
    
    %% Two stages hypo-exponential "A" using method moment
    % This function returns the best parameters of l1 and l2 that fit the trace
    HypoE_values = fsolve(@HypoExp_MM, [1, 0.5, i]);

    len = length(A);
    figure('Name', sprintf('[Method of moments] Trace number: %d\n', i), 'NumberTitle','off');
    
    % linspace generates N points between X1 and X2
    xUnif = linspace(Unif_A_MM(i), Unif_B_MM(i), 100);
    x = [0:50];
    plot(sort(A(:,i)), [1:len]/len, ".", xUnif, [0:99]/99, "xg", x, (1-HyperE_values(3)*exp(-x*HyperE_values(1)) - (1-HyperE_values(3))*exp(-x*HyperE_values(2))) , "-r", x, 1-exp(-E_lambda(i)*x), "+m", x, 1-((HypoE_values(2)*exp(-HypoE_values(1)*x))/(HypoE_values(2)-HypoE_values(1)))+((HypoE_values(1)*exp(-HypoE_values(2)*x))/(HypoE_values(2)-HypoE_values(1))), "-y");
    xlim([-20 50]);
    legend("Trace", "Uniform", "HyperExp", "Exponential", "HypoExp");
end

function MaxLikelihood_run(i)
    global A;
    len = length(A);
    figure('Name', sprintf('[Maximum likelihood] Trace number: %d\n', i), 'NumberTitle','off');
    
    % mle used to estimate the values
    HyperE_values = mle(A(:,i), 'pdf', @HyperExp_pdf, 'start', [0.5, 0.5, 0.5], 'LowerBound', [0, 0, 0], 'UpperBound', [Inf, Inf, 1]);
    HypoE_values = mle(A(:,i), 'pdf', @HypoExp_pdf, 'start', [1, 0.5], 'LowerBound', [0, 0], 'UpperBound', [Inf, Inf]);
    E_lambda = mle(A(:,i), 'pdf', @Exp_pdf, 'start', 0.5, 'LowerBound', 0, 'UpperBound', Inf);
    x = [0:50];
    plot(sort(A(:,i)), [1:len]/len, ".", x, (1-HyperE_values(3)*exp(-x*HyperE_values(1)) - (1-HyperE_values(3))*exp(-x*HyperE_values(2))) , "-r", x, 1-exp(-E_lambda*x), "+m", x, 1-((HypoE_values(2)*exp(-HypoE_values(1)*x))/(HypoE_values(2)-HypoE_values(1)))+((HypoE_values(1)*exp(-HypoE_values(2)*x))/(HypoE_values(2)-HypoE_values(1))), "-y");
    xlim([-20 50]);
    legend("Trace", "HyperExp", "Exponential", "HypoExp");
end

function Values = HyperExp_MM(args)
    global m1;
    global m2;
    global m3;
    l1 = args(1);
    l2 = args(2);
    p1 = args(3);
    i = int32(args(4));
    
    Values = zeros(1,3);
    % First moment
    Values(1,1) = (p1/l1 + (1-p1)/l2)/m1(i) - 1;
    % Second moment
    Values(1,2) = 2*(p1/l1^2 + (1-p1)/l2^2)/m2(i) - 1;
    % Third moment
    Values(1,3) = 6*(p1/l1^3 + (1-p1)/l2^3)/m3(i) - 1;
end

function Values = HypoExp_MM(args)
    global m1;
    global m2;
    l1 = args(1);
    l2 = args(2);
    i = int32(args(3));
    
    Values = zeros(1,2);
    % First moment
    Values(1,1) = (1/(l1-l2)*(l1/l2-l2/l1))/m1(i) - 1;
    % Second moment
    Values(1,2) = (2/(l1-l2)*(l1/l2^2-l2/l1^2))/m2(i) - 1;
end

%% Probability density functions
function f = HyperExp_pdf(x, l1, l2, p1)
    f = p1*l1*exp(-l1*x) + (1-p1)*l2*exp(-l2*x);
end

function f = HypoExp_pdf(x, l1, l2)
    f = (l1*l2)/(l1-l2)*(exp(-l2*x)-exp(-l1*x));
end

function f = Exp_pdf(x, l1)
    f = l1*exp(-l1*x);
end