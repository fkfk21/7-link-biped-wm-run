classdef Result
  properties
    xb
    yb
    thb
    lw
    th1
    th2
    th3
    th4
    th5
    th6
    phi1
    phi2
    phi3
    phi4
    phi5
    phi6
    dxb
    dyb
    dthb
    dlw
    dth1
    dth2
    dth3
    dth4
    dth5
    dth6
    dphi1
    dphi2
    dphi3
    dphi4
    dphi5
    dphi6
    u1
    u2
    u3
    u4
    u5
    u6
    uw
    time
    control_time
    pjx
    pjy
    step
  end
  methods
    function obj = Result(sol, times)
      for i=1:length(sol)
        obj.xb = [obj.xb, sol{i}.states.xb.value];
        obj.yb = [obj.yb, sol{i}.states.yb.value];
        obj.thb = [obj.thb, sol{i}.states.thb.value];
        obj.lw = [obj.lw, sol{i}.states.lw.value];
        obj.th1 = [obj.th1, sol{i}.states.th1.value];
        obj.th2 = [obj.th2, sol{i}.states.th2.value];
        obj.th3 = [obj.th3, sol{i}.states.th3.value];
        obj.th4 = [obj.th4, sol{i}.states.th4.value];
        obj.th5 = [obj.th5, sol{i}.states.th5.value];
        obj.th6 = [obj.th6, sol{i}.states.th6.value];
        obj.phi1 = [obj.phi1, sol{i}.states.phi1.value];
        obj.phi2 = [obj.phi2, sol{i}.states.phi2.value];
        obj.phi3 = [obj.phi3, sol{i}.states.phi3.value];
        obj.phi4 = [obj.phi4, sol{i}.states.phi4.value];
        obj.phi5 = [obj.phi5, sol{i}.states.phi5.value];
        obj.phi6 = [obj.phi6, sol{i}.states.phi6.value];
        obj.dxb = [obj.dxb, sol{i}.states.dxb.value];
        obj.dyb = [obj.dyb, sol{i}.states.dyb.value];
        obj.dthb = [obj.dthb, sol{i}.states.dthb.value];
        obj.dlw = [obj.dlw, sol{i}.states.dlw.value];
        obj.dth1 = [obj.dth1, sol{i}.states.dth1.value];
        obj.dth2 = [obj.dth2, sol{i}.states.dth2.value];
        obj.dth3 = [obj.dth3, sol{i}.states.dth3.value];
        obj.dth4 = [obj.dth4, sol{i}.states.dth4.value];
        obj.dth5 = [obj.dth5, sol{i}.states.dth5.value];
        obj.dth6 = [obj.dth6, sol{i}.states.dth6.value];
        obj.dphi1 = [obj.dphi1, sol{i}.states.dphi1.value];
        obj.dphi2 = [obj.dphi2, sol{i}.states.dphi2.value];
        obj.dphi3 = [obj.dphi3, sol{i}.states.dphi3.value];
        obj.dphi4 = [obj.dphi4, sol{i}.states.dphi4.value];
        obj.dphi5 = [obj.dphi5, sol{i}.states.dphi5.value];
        obj.dphi6 = [obj.dphi6, sol{i}.states.dphi6.value];
        obj.time = [obj.time, sol{i}.states.time.value];
        obj.u1 = [obj.u1, sol{i}.controls.u1.value];
        obj.u2 = [obj.u2, sol{i}.controls.u2.value];
        obj.u3 = [obj.u3, sol{i}.controls.u3.value];
        obj.u4 = [obj.u4, sol{i}.controls.u4.value];
        obj.u5 = [obj.u5, sol{i}.controls.u5.value];
        obj.u6 = [obj.u6, sol{i}.controls.u6.value];
        obj.uw = [obj.uw, sol{i}.controls.uw.value];
        obj.control_time = [obj.control_time, times{i}.controls.value];
      end
      for k=1:length(obj.time)
        pj = calc_pj(obj, k);
        obj.pjx = [obj.pjx, pj(:,1)];
        obj.pjy = [obj.pjy, pj(:,2)];
      end
      steps = sol{1}.parameters.p3.value;
      obj.step = steps(1);
    end
    function pj = calc_pj(obj, k)
        q = [obj.xb(k);obj.yb(k);obj.thb(k);obj.lw(k); ...
             obj.th1(k);obj.th2(k);obj.th3(k);obj.th4(k);obj.th5(k);obj.th6(k)];
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
    end
    
    function draw_line(obj, k)
        color = [0.6, 0.3, 0];
        l1 = line([obj.xb(k)   ,obj.pjx(1,k)],[obj.yb(k)   ,obj.pjy(1,k)],'Color', color);
        l2 = line([obj.pjx(1,k),obj.pjx(2,k)],[obj.pjy(1,k),obj.pjy(2,k)],'Color', color);
        l3 = line([obj.pjx(3,k),obj.pjx(4,k)],[obj.pjy(3,k),obj.pjy(4,k)],'Color', color);
        l4 = line([obj.xb(k)   ,obj.pjx(5,k)],[obj.yb(k)   ,obj.pjy(5,k)],'Color', color);
        l5 = line([obj.pjx(5,k),obj.pjx(6,k)],[obj.pjy(5,k),obj.pjy(6,k)],'Color', color);
        l6 = line([obj.pjx(7,k),obj.pjx(8,k)],[obj.pjy(7,k),obj.pjy(8,k)],'Color', color);
        l7 = line([obj.xb(k)   ,obj.pjx(9,k)],[obj.yb(k)   ,obj.pjy(9,k)],'Color', color);
        l8 = plot(obj.pjx(10,k),obj.pjy(10,k),'o','Color',color,'MarkerSize',10);
    end
  end
  
end