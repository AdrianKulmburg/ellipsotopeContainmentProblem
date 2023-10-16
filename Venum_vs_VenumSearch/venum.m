function [res,cert,scaling] = venum(Z1, Z2, tol, scalingToggle)
% Solves the zonotope containment problem by checking whether the maximum
% value of the Z2-norm at one of the vertices of Z1 exceeds 1+tol. Checks
% every vertex until an answer is found (see also [1, Algorithm 1]).

% References:
%    [1] A. Kulmburg, M. Althoff. "On the co-NP-Completeness of the
%        Zonotope Containment Problem", European Journal of Control 2021

scaling = 0;
cert = true; % Since venum is an exact method, cert is always true

% Let c1, c2 be the centers of Z1, Z2. We prepare the norm-function,
% returning the norm of v-c2 w.r.t. the Z2-norm, where v is a given vertex
% of Z1. Since v = c1 +- g_1 +- ... +- g_m, where g_i are the generators of
% Z1, the norm of v-c2 is the same as the norm of G*nu + c1-c2, where
% G is the generator matrix of Z1, nu = [+-1;...;+-1].
G = Z1.generators;
norm_Z2_nu = @(nu) zonotopeNorm(Z2, G*nu + Z1.center-Z2.center);

% Number of generators of Z1
m = size(G, 2);

% Create list of all combinations of generators we have to check (i.e., the
% choices of the +- signs from above). Note that this is a better strategy
% than computing the vertices directly, since it requires less
% memory.
% The next 5 lines produce all m-combinations of +-1
counter =0;
upperLimit =2^m-1;
while counter<=upperLimit
    vector = dec2bin(counter,m)-'0';
    vector = 2*(vector-0.5);
    scaling = max([scaling norm_Z2_nu(vector')]);
    if ~scalingToggle && (scaling>1 + tol)
        break;
    end
    counter=counter+1;
end
% If no vertex of Z1 lies outside of Z2, Z1 lies in Z2
res = scaling <= 1 + tol;
end