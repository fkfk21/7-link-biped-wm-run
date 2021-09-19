function force(result)
figure;

hold on
plot(result.algvars_time, result.fex);
plot(result.algvars_time, result.fey);
title('force');
legend('fex', 'fey');
xlabel('time [t]'); ylabel('force [N]');
result.separate_background_with_section('algvars');

end