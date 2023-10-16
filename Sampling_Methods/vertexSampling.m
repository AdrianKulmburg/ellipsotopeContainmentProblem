function [res,cert,scaling] = vertexSampling(Z1,Z2,tol,N,scalingToggle)
% Solves the zonotope containment problem by computing the maximal value of
% the polyhedral norm over Z1 w.r.t. Z2, by sampling the vertices of Z1.

G = generators(Z1);
c = center(Z1);

alphas = sign(rand(size(G,2),N)-0.5);

norm_Z2 = @(x) Z2.zonotopeNorm(x);

scaling = 0;
for i=1:N
    x = G * alphas(:,i)+c - center(Z2);
    scaling = max([scaling norm_Z2(x)]);
    
    if ~scalingToggle && scaling > 1+tol
        break
    end
end

res = scaling <= 1+tol;
cert = ~res;
end