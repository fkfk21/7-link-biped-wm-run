function lw(result)

figure;

subplot(2,1,1);
ylim([0.195 0.225])
plot(result.time,result.lw);
legend("lw");
title("lw");
xlabel("time");

subplot(2,1,2);
plot(result.time,result.dlw);
legend("dlw");
title("dlw");
xlabel("time");

end