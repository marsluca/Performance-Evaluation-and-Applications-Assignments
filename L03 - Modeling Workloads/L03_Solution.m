clear variables;
clc;

for i = 1:4 
    run(i);
end

function run(i)
    % The file contains the "Inter arrival time".
    % It measures the time between the arrivals of two jobs
    filename = sprintf('Data%d.txt', i);
    fprintf('File name: %s\n', filename);
    records = table2array(readtable(filename));
    fprintf('---------------------------\n');
    
    %% First four moments
    %Number of the Inter Arrivals in the file
    N_IA = size(records,1);
    
    % First moment - mean
    m1 = sum(records) / N_IA;
    fprintf('First moment: %f or %f \n', m1, mean(records));
    
    % Second moment
    m2 = sum(records.^2) / N_IA;
    fprintf('Second moment: %f or %f\n', m2, mean(records.^2));
    
    % Third moment
    m3 = sum(records.^3) / N_IA;
    fprintf('Third moment: %f or %f\n', m3, mean(records.^3));
    
    % Fourth moment
    m4 = sum(records.^4) / N_IA;
    fprintf('Fourth moment: %f or %f\n', m4, mean(records.^4));
    fprintf('---------------------------\n');
    
    %% The second, third and fourth centered moments
    % Second centered moments (or Variance) - Meausre of the spread
    cm2 = sum((records - m1).^2)/N_IA;
    varX = m2 - m1^2;
    fprintf('Second centered moment (or variance): %f or %f or %f\n', cm2, varX, var(records));
    
    % Third centered moment
    cm3 = sum((records - m1).^3)/N_IA;
    fprintf('Third centered moment: %f\n', cm3);
    
    % Fourth centered moment
    cm4 = sum((records - m1).^4)/N_IA;
    fprintf('Fourth centered moment: %f\n', cm4);
    fprintf('---------------------------\n');
    
    %% Standard Deviation, The third and fourth standardized moments
    % Standard Deviation
    stdX = sqrt(varX); 
    fprintf('Standard Deviation: %f\n', stdX);
    
    % Third standardized moment or Skewness - (measure of the symmetry)
    % positive value -> more probability mass to the left
    % negative value -> more probability mass to the right
    scm3 = sum(((records - m1)/stdX).^3)/N_IA;
    fprintf('Third standardized moment (or Skewness): %f\n', scm3);
    
    % Fourth standardized moment
    scm4 = sum(((records - m1)/stdX).^4)/N_IA;
    fprintf('Fourth standardized moment: %f\n', scm4);
    fprintf('---------------------------\n');
    
    %% Coefficient of Variation and Kurtosis
    % Coefficient of Variation - It tells how different is the variance 
    % compared to the mean
    cv = stdX/m1;  
    fprintf('Coefficient of Variation: %f\n', cv);
     
    % Kurtosis - (measure of the peakedness (apice))
    kurtois = scm4 - 3; 
    fprintf('Kurtosis: %f\n', kurtois);
    fprintf('---------------------------\n');
    
    %% The 10%, 25%, 50%, 75% and 90% percentiles
    p = [10, 25, 50, 75, 90];
    for i=1:length(p)
        fprintf('%d Percentiles of the distribution: %f or %f\n', p(i), my_prctile(records, N_IA, p(i)), prctile(records, p(i)));
    end
    fprintf('---------------------------\n');
    
    %% The cross-covariance for lags m=1, m=2 and m=3
    % "m" rapresents the "distance" between two samples
    for m=1:3
        ccv = sum((records(1:(N_IA-m))-m1).*(records(m+1:N_IA))/(N_IA-m));
        fprintf('Cross-covariance for m=%d: %f\n', m, ccv);
    end
    fprintf('\n');
    
    %% Plotting phase
    figure('Name', sprintf("Cumulative Distribution Function - %s", filename), 'NumberTitle','off');
    % I have to sort the elements to display well the resoults
    plot(sort(records), [1:N_IA]/N_IA, "+");
    xlabel("Inter arrival times");
end

%% Mine percentile function, linear interpolation
function prctile = my_prctile(records, size, percentage)
    records = sort(records);
    h = (percentage/100) * (size - 1) + 1;
    if floor(h) < size
        prctile = records(floor(h)) + (h - floor(h)) * (records(floor(h)+1) - records(floor(h)));
    else
        prctile = records(size);
    end
end