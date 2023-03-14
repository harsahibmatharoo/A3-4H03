function [scores_X, scores_Y, loadings_X, loadings_Y, weights_X, R2] = pls_nipals(X, Y, num_components)

% center X and Y
X_centered = X - mean(X);
Y_centered = Y - mean(Y);

% initialize arrays
scores_X = zeros(size(X, 1), num_components);
scores_Y = zeros(size(Y, 1), num_components);
weights_X = zeros(size(X, 2), num_components);
loadings_Y = zeros(size(Y, 2), num_components);
loadings_X = zeros(size(X, 2), num_components);
R2 = zeros(1, num_components);

for i = 1:num_components
    % initialize weight vector
    weight = X_centered(:, 1);
    
    % repeat until convergence
    while true
        % calculate score vector for X
        score_X = X_centered * weight / norm(weight);
        
        % calculate loading vector for Y
        loading_Y = Y_centered' * score_X / (score_X' * score_X);
        
        % calculate score vector for Y
        score_Y = Y_centered * loading_Y / (loading_Y' * loading_Y);
        
        % calculate weight vector for X
        weight_new = X_centered' * score_Y / (score_Y' * score_Y);
        
        % check for convergence
        if norm(weight_new - weight) < 1e-6
            break;
        end
        weight = weight_new;
    end
    
    % calculate loading vector for X
    loading_X = X_centered' * score_X / (score_X' * score_X);
    
    % store results
    scores_X(:, i) = score_X;
    scores_Y(:, i) = score_Y;
    weights_X(:, i) = weight / norm(weight);
    loadings_Y(:, i) = loading_Y;
    loadings_X(:, i) = loading_X / norm(loading_X);
    
    % calculate R^2
    Yhat = scores_X * loadings_Y';
    R2(i) = 1 - sum(sum((Y_centered - Yhat).^2)) / sum(sum(Y_centered.^2));
    
    % update X and Y for next component
    X_centered = X_centered - score_X * loading_X';
    Y_centered = Y_centered - score_Y * loading_Y';
end
