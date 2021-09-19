close all;
clc;
clear;
global v step flags
v = 2.8;
step = 0.5;
period = step/v;

flags = Flags;
flags.use_sea = true;
flags.use_wobbling_mass = true;
flags.optimize_mw = true;
flags.optimize_k = true;
flags.check()


ig = InitialGuess(step, false);
%ig.draw();


mode1 = ocl.Stage( ...
  [], ...
  'vars', @vars1, ...
  'dae', @dae1, ...
  'pathcosts', @pathcosts, ...
  'gridconstraints', @gridconstraints1, ...
  'N', 8, 'd', 3);
mode2 = ocl.Stage( ...
  [], ...
  'vars', @vars2, ...
  'dae', @dae2, ...
  'pathcosts', @pathcosts, ...
  'gridconstraints', @gridconstraints2, ...
  'N', 8, 'd', 3);


%                        1end  
period_bound = period*[0.3, 0.7];
mode1.setInitialStateBounds('time', 0);
mode1.setEndStateBounds('time', period_bound(1), period_bound(2));
mode2.setInitialStateBounds('time', period_bound(1), period_bound(2));
mode2.setEndStateBounds('time', period*0.8, period*1.2);


ig.set_initial_guess(mode1, mode2, period);

ocp = ocl.MultiStageProblem({mode1,mode2}, ...
                            {@trans_stand2float});

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
    
