rng(123456);

N_zonotopes = 100;
dim = 5;
m = dim * 2;
N_range = [1 10 100 250 500 750 1000 2500 5000 7500 10000];

all_results_vertex_sampling = cell(1, length(N_range));
all_results_halfspace_sampling = cell(1, length(N_range));
all_results_exact = cell(1,length(N_range));

all_runtimes_vertex_sampling = cell(1, length(N_range));
all_runtimes_halfspace_sampling = cell(1, length(N_range));
all_runtimes_exact = cell(1, length(N_range));

for i = 1:length(N_range)
    N = N_range(i)
    [results_vertex_sampling, results_halfspace_sampling, results_exact, runtimes_vertex_sampling, runtimes_halfspace_sampling, runtimes_exact] = test_N_zonotopes(N_zonotopes, dim, m, N);
    all_results_vertex_sampling{i} = results_vertex_sampling;
    all_results_halfspace_sampling{i} = results_halfspace_sampling;
    all_results_exact{i} = results_exact;
    
    all_runtimes_vertex_sampling = runtimes_vertex_sampling;
    all_runtimes_halfspace_sampling = runtimes_halfspace_sampling;
    all_runtimes_exact = runtimes_exact;
end

save data_sampling.mat


function [results_vertex_sampling, results_halfspace_sampling, results_exact, runtimes_vertex_sampling, runtimes_halfspace_sampling, runtimes_exact] = test_N_zonotopes(N_zonotopes, dim, m, N)
    results_vertex_sampling = zeros(1,N_zonotopes);
    results_halfspace_sampling = zeros(1,N_zonotopes);
    results_exact = zeros(1,N_zonotopes);
    
    for i=1:N_zonotopes
        G = 2.*rand(dim, m) - 1;
        H = 2.*rand(dim, m) - 1;
        
        Z1 = zonotope(zeros(dim,1), G);
        Z2 = zonotope(zeros(dim,1), H);
        
        tic;
        [~,~,results_vertex_sampling(i)] = vertexSampling(Z1,Z2,0,N,true);
        runtimes_vertex_sampling(i) = toc;
        
        tic;
        [~,~,results_halfspace_sampling(i)] = halfspaceSampling(Z1,Z2,0,N,true);
        runtimes_halfspace_sampling(i) = toc;
        
        tic;
        [~,~,results_exact(i)] = venumSearch(Z1, Z2, 0, true);
        runtimes_exact(i) = toc;
    end
end