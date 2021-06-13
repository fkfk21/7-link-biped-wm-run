function theta_phi(result)

% plot theta
th = [result.th1; result.th2; result.th3; result.th4; result.th5; result.th6];
figure;
hold on
title('theta');
for i=1:6
  plot(result.time, th(i,:));
end

% plot phi
phi = [result.phi1; result.phi2; result.phi3; result.phi4; result.phi5; result.phi6];
for i=1:6
  plot(result.time, phi(i,:));
end
legend('th1','th2','th3','th4','th5','th6','phi1','phi2','phi3','phi4','phi5','phi6');

% plot theta
dth = [result.dth1; result.dth2; result.dth3; result.dth4; result.dth5; result.dth6];
figure;
hold on
title('dtheta');
for i=1:6
  plot(result.time, dth(i,:));
end

% plot phi
dphi = [result.dphi1; result.dphi2; result.dphi3; result.dphi4; result.dphi5; result.dphi6];
for i=1:6
  plot(result.time, dphi(i,:));
end
legend('dth1','dth2','dth3','dth4','dth5','dth6','dphi1','dphi2','dphi3','dphi4','dphi5','dphi6');


end