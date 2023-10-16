rng(123456);

N_zonotopes = 100;
dim = 5;
m = dim * 2;
rho_precision = 13;

rho = linspace(0, 1.2, rho_precision);

all_results_venum = cell(1, rho_precision);
all_results_venumSearch = cell(1, rho_precision);

for i = 1:rho_precision
    r = rho(i)
    [results_venum, results_venumSearch] = test_N_zonotopes(N_zonotopes, dim, m, r);
    all_results_venum{i} = results_venum;
    all_results_venumSearch{i} = results_venumSearch;
end

save data_venum_vs_venumSearch.mat


function [results_venum, results_venumSearch] = test_N_zonotopes(N, dim, m, r)
    results_venum = zeros(1,N);
    results_venumSearch = zeros(1,N);
    
    for i=1:N
        G = 2.*rand(dim, m) - 1;
        H = 2.*rand(dim, m) - 1;
        
        Z1 = r * zonotope(zeros(dim,1), G);
        Z2 = zonotope(zeros(dim,1), H);
        
        tic;
        venum(Z1, Z2, 0, false);
        results_venum(i) = toc;
        
        tic;
        venumSearch(Z1, Z2, 0, false);
        results_venumSearch(i) = toc;
    end
end