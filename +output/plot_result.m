function plot_result(result)
close all;

% plot lw
output.plot.lw(result);

% plot pb
output.plot.pb(result);

% plot pj
output.plot.pj(result);

% plot theta and phi
output.plot.theta_phi(result);

% plot controls
output.plot.controls(result);




end