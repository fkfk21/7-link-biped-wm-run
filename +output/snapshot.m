function snapshot(result)

figure;
hold on
axis equal
plot([-0.7 1.7],[0 0],'k')

index = [1 result.state_size(1) sum(result.state_size(1:2)) sum(result.state_size)];
color = ['r' 'b' 'm' 'g'];
for i = 1:4
  result.draw_line(index(i), color(i));
end

color = [0.6 0.6 0.6];
plot(result.xb, result.yb,'Color',color);
for i = [1 2 5 6 9 10]
  plot(result.pjx(i,:), result.pjy(i,:),'Color',color);
end

xlim([-0.5, 1.7]);
ylim([-0.1, 1.4]);

end