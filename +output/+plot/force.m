function force(result)
figure;

subplot(3,1,1);
hold on
plot(result.f1x);
plot(result.f2x);
title('force x');
legend('f1x', 'f2x');

subplot(3,1,2);
hold on
plot(result.f1y);
plot(result.f2y);
title('force y');
legend('f1y', 'f2y');

subplot(3,1,3);
hold on
plot(result.f1th);
plot(result.f2th);
title('force theta');
legend('f1th', 'f2th');

end