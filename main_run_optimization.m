close all;
clc;
clear;
global v step flags
v = 3.0;
step = 1.0;
period = step/v;

flags = Flags;
flags.use_sea = true;
flags.use_wobbling_mass = false;
flags.optimize_mw = false;
flags.optimize_k = true;
flags.check()


ig = InitialGuess(step, false);
ig.draw();


mode1 = ocl.Stage( ...
  [], ...
  'vars', @vars1, ...
  'dae', @dae1, ...
  'pathcosts', @pathcosts, ...
  'gridconstraints', @gridconstraints1, ...
  'N', 20, 'd', 3);
mode2 = ocl.Stage( ...
  [], ...
  'vars', @vars2, ...
  'dae', @dae2, ...
  'pathcosts', @pathcosts, ...
  'gridconstraints', @gridconstraints2, ...
  'N', 10, 'd', 3);
mode3 = ocl.Stage( ...
  [], ...
  'vars', @vars3, ...
  'dae', @dae3, ...
  'pathcosts', @pathcosts, ...
  'gridconstraints', @gridconstraints3, ...
  'N', 5, 'd', 3);

%                        1end      2end
period_bound = period*[0.4, 0.6, 0.7, 0.9];
mode1.setInitialStateBounds('time', 0);
mode1.setEndStateBounds('time', period_bound(1), period_bound(2));
mode2.setInitialStateBounds('time', period_bound(1), period_bound(2));
mode2.setEndStateBounds('time', period_bound(3), period_bound(4));
mode3.setInitialStateBounds('time', period_bound(3), period_bound(4));
mode3.setEndStateBounds('time', period*0.9, period*1.1);

ig.set_initial_guess(mode1, mode2, mode3, period);

ocp = ocl.MultiStageProblem({mode1,mode2,mode3}, ...
                            {@trans_stand2float,@trans_float2stand});

% save console log
exe_time = now;
[~,~]=mkdir('+console');
console_filename = ['+console/' datestr(exe_time,'yyyy-mm-dd_HH-MM-SS') '.log'];
diary(console_filename)

% solve
[sol,times] = ocp.solve();

result = output.Result(sol, times, flags);

% save results to file
[~,~]=mkdir('+results');
result_filename = [datestr(exe_time,'yyyy-mm-dd_HH-MM-SS') '.mat'];
save(['+results/' result_filename],'sol','times','result','flags','v','step');

diary off;
    
