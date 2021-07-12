function force(result)
figure;

subplot(2,1,1);
hold on
plot(result.algvars_time, result.f1x);
plot(result.algvars_time, result.f2x);
title('force x');
legend('f1x', 'f2x');
xlabel('time [t]'); ylabel('force [N]');
result.separate_background_with_section('algvars');


subplot(2,1,2);
hold on
plot(result.algvars_time, result.f1y);
plot(result.algvars_time, result.f2y);
title('force y');
legend('f1y', 'f2y');
xlabel('time [t]'); ylabel('force [N]');
result.separate_background_with_section('algvars');

end