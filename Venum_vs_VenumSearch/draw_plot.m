load data_venum_vs_venumSearch.mat

% Color palette for people with colorblindness. See
% T. B. Plante, M. Cushman, "Choosing color palettes for scientific
% figures", 2020
RPTH_blue = [0, 92, 171]./255;
RPTH_red = [227, 27, 35]./255;
RPTH_yellow = [255, 195, 37]./255;

t_venum_worst_case = zeros(1, rho_precision);
t_venum_mean_case = zeros(1, rho_precision);
t_venum_best_case = zeros(1, rho_precision);

t_venumSearch_worst_case = zeros(1, rho_precision);
t_venumSearch_mean_case = zeros(1, rho_precision);
t_venumSearch_best_case = zeros(1, rho_precision);

for i = 1:rho_precision
    t_venum_worst_case(i) = max(all_results_venum{i});
    t_venum_mean_case(i) = mean(all_results_venum{i});
    t_venum_best_case(i) = min(all_results_venum{i});
    
    t_venumSearch_worst_case(i) = max(all_results_venumSearch{i});
    t_venumSearch_mean_case(i) = mean(all_results_venumSearch{i});
    t_venumSearch_best_case(i) = min(all_results_venumSearch{i});
end

clf;
hold on
plot_venum = errorbar(rho, t_venum_mean_case, t_venum_mean_case - t_venum_best_case, t_venum_worst_case - t_venum_mean_case, 'o', 'color', RPTH_red, 'CapSize', 15);
plot_venumSearch = errorbar(rho, t_venumSearch_mean_case, t_venumSearch_mean_case - t_venumSearch_best_case, t_venumSearch_worst_case - t_venumSearch_mean_case, 'x', 'color', RPTH_blue);



title("Runtime of Vertex Enumeration", 'Interpreter', 'latex', 'FontSize', 13)
xlabel("$\varrho$", 'Interpreter', 'latex', 'FontSize', 13)
ylabel("Runtime in seconds", 'Interpreter', 'latex', 'FontSize', 13)

lgd = legend([plot_venum plot_venumSearch], {'Original Method', 'Search-Based Method'}, 'Interpreter', 'latex', 'Location', 'northeast');
lgd.FontSize = 13;

%matlab2tikz('venum_vs_venumSearch.tex')