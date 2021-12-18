clear variables;
clc;

% Request according to a Poisson process [req/s]
lambda = [0.1, 10];
% First row -> Demands E and C of the first NAS 
% Second row -> Demands E and C of the second NAS 
D = [2, 0.06;
     5, 0.04];

%% System stability
% Product row*column of the transposed matrix
U = lambda*D';
if max(U) < 1
    fprintf('The system is STABLE because [max(U) %f] < 1\n', max(U));
else
    fprintf('The system is NOT STABLE because [max(U) %f] > 1\n', max(U));
end

%% Utilization of the two NAS
fprintf('Utilization of the two NAS are: %f and %f\n', U(1), U(2));

%% Residence time of the two NAS
% For residence time and response time we have to apply specific formula in
% case of multi class models. It comes from the Litte's law. Nk = X*Rk
Rkc = zeros(2,2);
X = sum(lambda);

for c=1:2
    for k=1:2
        Rkc(k,c) = D(k,c)/(1-U(k));
    end
end

Rk = zeros(2);
for i=1:2
    % Residence time for each NAS
    Rk(i) = lambda(1)/X*Rkc(i,1)+lambda(2)/X*Rkc(i,2);
    fprintf('Residence time of the %d NAS: %f\n', i, Rk(i));
end

%% System response time
fprintf('System response time: %f\n', sum(Rk(:)));
