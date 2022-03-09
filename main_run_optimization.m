close all;
clc;
clear;
global v step T flags

% ↓ optimization setting ↓
v = 4.0;  % velocity
step = 0.9;  % step (approximate)
period = step/v;
T = period;

flags = Flags;
flags.use_sea = true;
flags.use_wobbling_mass = true;
flags.optimize_mw = true;
flags.optimize_k = true;
flags.check()
% ↑ optimization setting ↑


ig = InitialGuess(step, false);
%ig.draw();


mode1 = ocl.Stage( ...
  [], ...
  'vars', @optimizer.vars1, ...
  'dae', @optimizer.dae1, ...
  'pathcosts', @optimizer.pathcosts, ...
  'gridconstraints', @optimizer.gridconstraints1, ...
  'N', 10, 'd', 3);
mode2 = ocl.Stage( ...
  [], ...
  'vars', @optimizer.vars2, ...
  'dae', @optimizer.dae2, ...
  'pathcosts', @optimizer.pathcosts, ...
  'gridconstraints', @optimizer.gridconstraints2, ...
  'N', 14, 'd', 3);


%                        1end  
period_bound = period*[0.3, 0.6];
mode1.setInitialStateBounds('time', 0);
mode1.setEndStateBounds('time', period_bound(1), period_bound(2));
mode2.setInitialStateBounds('time', period_bound(1), period_bound(2));
mode2.setEndStateBounds('time', period*0.8, period*1.2);


ig.set_initial_guess(mode1, mode2, period);

ocp = ocl.MultiStageProblem({mode1,mode2}, ...
                            {@optimizer.trans_stand2float});

% save console log
exe_time = now;
[~,~]=mkdir('+console');
console_filename = ['+console/' datestr(exe_time,'yyyy-mm-dd_HH-MM-SS') '.log'];
diary(console_filename)

% solve
[sol,times, sol_info] = ocp.solve();

result = output.Result(sol, times, flags, sol_info);

% save results to file
[~,~]=mkdir('+results');
result_filename = [datestr(exe_time,'yyyy-mm-dd_HH-MM-SS') '.mat'];
save(['+results/' result_filename],'sol','times','result','flags','v','step');

diary off;
    
