function [t, u, w_star, c, p, R2] = pls_nipals(X, Y, num_components)

% center X and Y
X_centered = X - mean(X);
Y_centered = Y - mean(Y);

% initialize arrays
t = zeros(size(X, 1), num_components);
u = zeros(size(Y, 1), num_components);
w_star = zeros(size(X, 2), num_components);
c = zeros(size(Y, 2), num_components);
p = zeros(size(X, 2), num_components);
R2 = zeros(1, num_components);

for i = 1:num_components
    % initialize weight vector
    w = X_centered(:, 1);
    
    % repeat until convergence
    while true
        % calculate score vector for X
        t_new = X_centered * w / norm(w);
        
        % calculate loading vector for Y
        c_new = Y_centered' * t_new / (t_new' * t_new);
        
        % calculate score vector for Y
        u_new = Y_centered * c_new / (c_new' * c_new);
        
        % calculate weight vector for X
        w_star_new = X_centered' * u_new / (u_new' * u_new);
        
        % check for convergence
        if norm(w_star_new - w) < 1e-6
            break;
        end
        w = w_star_new;
    end
    
    % calculate loading vector for X
    p_new = X_centered' * t_new / (t_new' * t_new);
    
    % store results
    t(:, i) = t_new;
    u(:, i) = u_new;
    w_star(:, i) = w / norm(w);
    c(:, i) = c_new;
    p(:, i) = p_new / norm(p_new);
    
    % calculate R^2
    Yhat = t * c';
    R2(i) = 1 - sum(sum((Y_centered - Yhat).^2)) / sum(sum(Y_centered.^2));
    
    % update X and Y for next component
    X_centered = X_centered - t_new * p_new';
    Y_centered = Y_centered - u_new * c_new';
end

end
