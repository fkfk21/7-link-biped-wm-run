function animation(result, loop, playratio, save_video, filename)
set(0, 'DefaultLineLineWidth', 1);
close all;
f = figure;
f.Position = f.Position +[-500 -500 500 200];
plot([-10 10],[0 0],'k')
hold on
axis equal
ylim([-0.2 1.8])
xlim([-1.0 result.step*loop+0.5])
formatSpec = 'time: %.4f';
title_handle = title(sprintf(formatSpec, 0.0));

rate = 60;
v_period = 1/rate*playratio;
set(0, 'DefaultLineLineWidth', 2);

pause(1)

if save_video
    disp('Saving movie')
    v=VideoWriter(filename, 'MPEG-4');
    v.FrameRate = rate;
    open(v)
    mov = getframe(f);
    writeVideo(v,mov);
end

for n=1:loop
  xb   = result.xb;
  yb   = result.yb;
  thb  = result.thb;
  lw   = result.lw;
  th1  = result.th1;
  th2  = result.th2;
  th3  = result.th3;
  th4  = result.th4;
  th5  = result.th5;
  th6  = result.th6;
  % time = times.states.value;
  time =  result.time;
  step = result.step;

  k = 1;
  for t = 0:v_period:time(end)
      q = [xb(k)+(n-1)*step;yb(k);thb(k);lw(k);th1(k);th2(k);th3(k);th4(k);th5(k);th6(k)];
      th_abs = [
          q(3) + q(5);
          q(3) + q(5) + q(6);
          q(3) + q(5) + q(6) + q(7);
          q(3) + q(8);
          q(3) + q(8) + q(9);
          q(3) + q(8) + q(9) + q(10);
          q(3)
          ];
      lwm = q(4);
      pb = [q(1) q(2)];

      pj(1,:) = pb      +  params.l1              * [cos(th_abs(1)) sin(th_abs(1))]; %leg1 knee
      pj(2,:) = pj(1,:) +  params.l2              * [cos(th_abs(2)) sin(th_abs(2))]; %leg1 ankle
      pj(3,:) = pj(2,:) + (params.l3 - params.c1) * [cos(th_abs(3)) sin(th_abs(3))]; %leg1 toe
      pj(4,:) = pj(2,:) -  params.c1              * [cos(th_abs(3)) sin(th_abs(3))]; %leg1 heel
      pj(5,:) = pb      +  params.l4              * [cos(th_abs(4)) sin(th_abs(4))]; %leg2 knee
      pj(6,:) = pj(5,:) +  params.l5              * [cos(th_abs(5)) sin(th_abs(5))]; %leg2 ankle
      pj(7,:) = pj(6,:) + (params.l6 - params.c2) * [cos(th_abs(6)) sin(th_abs(6))]; %leg2 toe
      pj(8,:) = pj(6,:) -  params.c2              * [cos(th_abs(6)) sin(th_abs(6))]; %leg2 heel
      pj(9,:) = pb      +  params.l7              * [cos(th_abs(7)) sin(th_abs(7))]; %head
      pj(10,:) = pb      + (params.l7 - lwm    )  * [cos(th_abs(7)) sin(th_abs(7))];

      if t > 0
          pause(v_period/playratio-toc);
          delete(l1);
          delete(l2);
          delete(l3);
          delete(l4);
          delete(l5);
          delete(l6);
          delete(l7);
          delete(l8);
      end
      
      % 現在時刻がtime(k)を上回ったらkをインクリメント
      while(t>=time(k))
        k = k + 1;
      end
      
      tic;
      hold on;
      l1 = line([q(1)   ,pj(1,1)],[q(2)   ,pj(1,2)]);
      l2 = line([pj(1,1),pj(2,1)],[pj(1,2),pj(2,2)]);
      l3 = line([pj(3,1),pj(4,1)],[pj(3,2),pj(4,2)]);
      l4 = line([q(1)   ,pj(5,1)],[q(2)   ,pj(5,2)]);
      l5 = line([pj(5,1),pj(6,1)],[pj(5,2),pj(6,2)]);
      l6 = line([pj(7,1),pj(8,1)],[pj(7,2),pj(8,2)]);
      l7 = line([q(1)   ,pj(9,1)],[q(2)   ,pj(9,2)]);
      l8 = plot(pj(10,1),pj(10,2),'o','color',[38,124,185]/255,'MarkerSize',6);
    %   l8 = line([pj(10,1),pj(10,1)],[pj(10,2),pj(10,2)],'marker','o');
      %pause(0.3)
      title_handle.String = sprintf(formatSpec, t+time(end)*(n-1));
      if save_video
        mov = getframe(f);
        writeVideo(v, mov);
      end
      drawnow
  end
  if n~=loop
    delete(l1);
    delete(l2);
    delete(l3);
    delete(l4);
    delete(l5);
    delete(l6);
    delete(l7);
    delete(l8);
  end
end
  if save_video
      close(v);
      disp('Finished!')
  end
  set(0, 'DefaultLineLineWidth', 1);
end
