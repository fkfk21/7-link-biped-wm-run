function pj(result)

% plot body
figure;
hold on
plot(result.xb, result.yb);
for i=1:height(result.pjx)
  plot(result.pjx(i,:), result.pjy(i,:));
end

len = length(result.pjx);
for k=1:len/5:len
  result.draw_line(int32(k));
end
result.draw_line(len);


% plot theta
th = [result.th1; result.th2; result.th3; result.th4; result.th5; result.th6];
figure;
hold on
title('theta');
for i=1:6
  plot(result.time, th(i,:));
end
legend('th1','th2','th3','th4','th5','th6');


end