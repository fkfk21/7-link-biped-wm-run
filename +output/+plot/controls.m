function controls(result)
figure;
subplot(2,1,1);
u = [result.u1; result.u2; result.u3; result.u4; result.u5; result.u6];
hold on
title('control');
for i=1:6
  plot(u(i,:));
end
legend('u1','u2','u3','u4','u5','u6');

subplot(2,1,2);
plot(result.control_time, result.uw);
title('uw');
end