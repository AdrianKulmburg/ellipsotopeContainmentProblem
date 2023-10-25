% Start and end time
tStart = 0;
tFinal = 5;

% Initial set
R0 = zonotope([zeros([12 1]),0.4*diag([1; 1; 1; 0; 0; 0; zeros(6,1)])]);

% Control input
params.U = zonotope([1;0;-0.05]);

% Options for reachability
options.timeStep=0.1; 
options.taylorTerms=4; 
options.zonotopeOrder=50; 
options.intermediateOrder=5;
options.reductionTechnique='girard';
options.errorOrder=1;
options.alg = 'lin';
options.tensorOrder = 2;

% Target set
E = ellipsoid(eye(3));
E = diag([0.8;1;0.1]) * E + [4;0;1];

%specify continuous dynamics-----------------------------------------------
quadrocopter = nonlinearSys(@quadrocopterControlledEq,12,3);
%--------------------------------------------------------------------------

% Set up for first iteration
tCurrent = tStart;
R0Current = R0;

% Runtimes
runtime_reachability = [];
runtime_containment = [];

while tCurrent<tFinal
    % Perform reachability analysis
    params.tStart = tCurrent;
    params.tFinal = tCurrent + options.timeStep;
    params.R0 = R0Current;
    
    tic
    RNext = reach(quadrocopter, params, options);
    runtime_reachability = [runtime_reachability toc];
    
    if tCurrent == tStart
        R = RNext;
    else
        R = append(R,RNext);
    end
    
    tCurrent = tCurrent + options.timeStep;
    R0Current = R.timePoint.set{end};
    
    
    % Check for containment
    tic
    contained = venumSearchEllipsoid(project(R0Current,[1 2 3]), E, 0, false);
    runtime_containment = [runtime_containment toc];
    
    % If contained -> abort
    if contained
        break
    end
end


%plot results--------------------------------------------------------------
% Visualization -----------------------------------------------------------

% Color palette for people with colorblindness. See
% T. B. Plante, M. Cushman, "Choosing color palettes for scientific
% figures", 2020
RPTH_blue = [0, 92, 171]./255;
RPTH_red = [227, 27, 35]./255;
RPTH_yellow = [255, 195, 37]./255;

dims = {[1 3]};
for k = 1:length(dims)
    
    clf;
    hold on; box on
    projDim = dims{k};
    

    % plot ellipsoid
    plot(E,projDim,'DisplayName','Target Area', 'FaceColor', RPTH_yellow);
    
    % plot reachable sets
    plot(R,projDim,'DisplayName','Reachable set', 'Unify', true, 'FaceColor', RPTH_blue);
    
    % plot initial set
    plot(R(1).R0,projDim, 'DisplayName','Initial set', 'FaceColor', 'w', 'EdgeColor', 'k');
    
    % plot final set
    plot(R.timePoint.set{end}, projDim, 'DisplayName', 'Final set', 'FaceColor', RPTH_red);
    

    % label plot
    xlabel(['x_{',num2str(projDim(1)),'}'], 'FontSize', 13);
    ylabel(['x_{',num2str(projDim(2)),'}'], 'FontSize', 13);
    title('Reachable Set of Quadrotor', 'FontSize', 13);
    lgd = legend('Location', 'southeast');
    lgd.FontSize = 13;
end

matlab2tikz('quadrotor_experiment.tex')