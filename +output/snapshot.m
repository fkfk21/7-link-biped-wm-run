function snapshot(result)

figure;
hold on
axis equal
plot([-0.7 1.5],[0 0],'k')

index = [1 result.state_size(1) sum(result.state_size(1:2)) sum(result.state_size)];
color = ['r' 'b' 'm' 'g'];
for i = 1:4
  result.draw_line(index(i), color(i));
end


end