function pb(result)
% plot xb,yb
figure;
subplot(3,2,1); plot(result.time, result.xb); title('xb'); xlabel('time');
subplot(3,2,2); plot(result.time, result.dxb); title('dxb'); xlabel('time');
subplot(3,2,3); plot(result.time, result.yb); title('yb'); xlabel('time');
subplot(3,2,4); plot(result.time, result.dyb); title('dyb'); xlabel('time');
subplot(3,2,5); plot(result.time, result.thb); title('thb'); xlabel('time');
subplot(3,2,6); plot(result.time, result.dthb); title('dthb'); xlabel('time');
end

