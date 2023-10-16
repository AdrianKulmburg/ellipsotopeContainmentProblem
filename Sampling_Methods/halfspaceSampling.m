function [res,cert,scaling] = halfspaceSampling(Z1,Z2,tol,N,scalingToggle)
% Solves the zonotope containment problem by computing the maximal value of
% the polyhedral norm over Z1 w.r.t. Z2, by sampling the halfspaces of Z2.

H = Z2.generators;
n = size(H,1);
ell = size(H, 2);

G = Z1.generators;

c = center(Z1);
d = center(Z2);

G_prime = [G c-d];

scaling = 0;
for i = 1:N
    permutation = randperm(ell);
    ind = permutation(1:n-1);
    Q = H(:,ind);
    lambda = ndimCross(Q);
    
    b = sum(abs(lambda' * H));
    
    if b == 0
        lambda = 0.*lambda;
    else
        lambda = lambda / b;
    end
    
    s = sum(abs(G_prime' * lambda));
    
    scaling = max([scaling s]);
    
    if ~scalingToggle && scaling > 1 + tol
        break
    end
end

res = scaling <= 1+tol;
cert = ~res;

end