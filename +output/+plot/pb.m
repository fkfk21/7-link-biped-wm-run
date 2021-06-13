function pb(result)
% plot xb,yb
figure;
subplot(3,2,1); plot(result.time, result.xb); title('xb');
subplot(3,2,2); plot(result.time, result.dxb); title('dxb');
subplot(3,2,3); plot(result.time, result.yb); title('yb');
subplot(3,2,4); plot(result.time, result.dyb); title('dyb');
subplot(3,2,5); plot(result.time, result.thb); title('thb');
subplot(3,2,6); plot(result.time, result.dthb); title('dthb');
end

