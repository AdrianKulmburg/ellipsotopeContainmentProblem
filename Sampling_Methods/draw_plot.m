load data_sampling.mat

% Color palette for people with colorblindness. See
% T. B. Plante, M. Cushman, "Choosing color palettes for scientific
% figures", 2020
RPTH_blue = [0, 92, 171]./255;
RPTH_red = [227, 27, 35]./255;
RPTH_yellow = [255, 195, 37]./255;

P_sigma = 0.6827;

mean_ratio_vertexSampling = zeros(1, length(N_range));
std_deviation_vertexSampling = zeros(1, length(N_range));

mean_ratio_halfspaceSampling = zeros(1, length(N_range));
std_deviation_halfspaceSampling = zeros(1, length(N_range));

epsilons = zeros(1, length(N_range));

for i = 1:length(N_range)
    N = N_range(i);
    
    epsilons(i) = min([1 2/(1/((1- (1-P_sigma)^(1/N))/2)^(1/dim) - 1)]);
    
    mean_ratio_vertexSampling(i) = mean(all_results_vertex_sampling{i}./all_results_exact{i});
    std_deviation_vertexSampling(i) = std(all_results_vertex_sampling{i}./all_results_exact{i});
    
    mean_ratio_halfspaceSampling(i) = mean(all_results_halfspace_sampling{i}./all_results_exact{i});
    std_deviation_halfspaceSampling(i) = std(all_results_halfspace_sampling{i}./all_results_exact{i});
end

clf;
hold on
plot_vertexSampling = errorbar(N_range, mean_ratio_vertexSampling, std_deviation_vertexSampling, 'o', 'color', RPTH_red, 'CapSize', 15);
plot_halfspaceSampling = errorbar(N_range, mean_ratio_halfspaceSampling, std_deviation_halfspaceSampling, 'x', 'color', RPTH_blue);

plot_epsilons = plot(N_range, 1 - epsilons, 'color', RPTH_yellow);

set(gca, 'XScale', 'log')


ylim([0 1.5]);

title("Accuracy of Sampling Methods", 'Interpreter', 'latex', 'FontSize', 13)
xlabel("Number of Samples N", 'Interpreter', 'latex', 'FontSize', 13)
ylabel("Approximation ratio $\rho$", 'Interpreter', 'latex', 'FontSize', 13)

lgd = legend([plot_vertexSampling plot_halfspaceSampling plot_epsilons], {'Vertex Sampling', 'Halfspace Sampling', '$\varepsilon_{std}$'}, 'Interpreter', 'latex', 'Location', 'northwest');
lgd.FontSize = 13;

matlab2tikz('sampling_experiments.tex')