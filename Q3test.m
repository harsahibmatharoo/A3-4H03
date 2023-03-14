% Load data
data = csvread('peas.csv', 1, 0);
X = data(:, 1:11);
Y = data(:, 12:end);

% Specify number of components to fit
num_components = 3;

% Perform NIPALS algorithm for PLS
[A, B, R2] = pls_nipals(X, Y, num_components);


% Load REAL values
real_A = 0.8502;	

real_B = 0.8636;
real_R2 = 0.8924;

% Compare R2
if isequal(R2, real_R2)
    disp('Computed R2 values match expected values.');
else
    disp('Computed R2 values do not match expected values.');
end

if isequal(R2, real_A)
    disp('Computed R2 values match expected values.');
else
    disp('Computed R2 values do not match expected values.');
end

if isequal(R2, real_B)
    disp('Computed R2 values match expected values.');
else
    disp('Computed R2 values do not match expected values.');
end
