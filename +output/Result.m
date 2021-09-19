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
    zmp_x
    fex
    fey
    time
    control_time
    algvars_time
    pjx
    pjy
    pcom
    step
    khip
    kknee
    kankle
    mw
    flags
    state_size
    control_size
    algvars_size
    v
    period
    objective
    sr
    solve_time
  end
  methods
    function obj = Result(sol, times, flags, sol_info)
      obj.flags = flags;
      obj.state_size = zeros(1,length(sol));
      obj.control_size = zeros(1,length(sol));
      obj.algvars_size = zeros(1, length(sol));
      for i=1:length(sol)
        s = sol{i}.states.size; obj.state_size(i) = s(2);
        s = sol{i}.controls.size; obj.control_size(i) = s(2);
        s = sol{i}.integrator.algvars.size; obj.algvars_size(i) = s(2);
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
        obj.fex = [obj.fex, sol{i}.integrator.algvars.fex.value];
        obj.fey = [obj.fey, sol{i}.integrator.algvars.fey.value];
      end
      
      obj.zmp_x = sol{1}.integrator.algvars.zmp_x.value;

      for i=1:length(sol)
        if i == 1
          obj.control_time = times{i}.controls.value;
          obj.algvars_time = reshape(times{i}.integrator.value,1,[]);
        else
          obj.control_time = [obj.control_time, obj.control_time(end)+times{i}.controls.value];
          obj.algvars_time = [obj.algvars_time, obj.algvars_time(end)+reshape(times{i}.integrator.value,1,[])];
        end
      end
      for k=1:length(obj.time)
        pj = calc_pj(obj, k);
        obj.pjx = [obj.pjx, pj(:,1)];
        obj.pjy = [obj.pjy, pj(:,2)];
      end
      
      if obj.flags.optimize_k
        khips = sol{1}.states.khip.value; obj.khip = khips(1);
        kknees = sol{1}.states.kknee.value; obj.kknee = kknees(1);
        kankles = sol{1}.states.kankle.value; obj.kankle = kankles(1);
      end
      if obj.flags.optimize_mw
        mws = sol{1}.states.mw.value; obj.mw = mws(1);
      end

      obj.period = obj.time(end);
      obj.v = (obj.xb(end)-obj.xb(1))/obj.period;
      obj.step = obj.v*obj.period;
      
      obj.objective = sol_info.ipopt_stats.iterations.obj(end);
      obj.sr = obj.objective/obj.period;
      
      obj.solve_time = sol_info.timeMeasures.solveTotal;

      % ダブり要素の削除
      del = obj.state_size(1);
      obj.xb(del) = []; obj.yb(del) = []; obj.thb(del) = []; obj.lw(del) = [];
      obj.th1(del) = []; obj.th2(del) = []; obj.th3(del) = [];
      obj.th4(del) = []; obj.th5(del) = []; obj.th6(del) = [];
      obj.phi1(del) = []; obj.phi2(del) = []; obj.phi3(del) = [];
      obj.phi4(del) = []; obj.phi5(del) = []; obj.phi6(del) = [];
      obj.dxb(del) = []; obj.dyb(del) = []; obj.dthb(del) = []; obj.dlw(del) = [];
      obj.dth1(del) = []; obj.dth2(del) = []; obj.dth3(del) = [];
      obj.dth4(del) = []; obj.dth5(del) = []; obj.dth6(del) = [];
      obj.dphi1(del) = []; obj.dphi2(del) = []; obj.dphi3(del) = [];
      obj.dphi4(del) = []; obj.dphi5(del) = []; obj.dphi6(del) = [];
      obj.pjx(:,del) = []; obj.pjy(:,del) = [];
      obj.time(del) = [];
      obj.state_size = obj.state_size - [0 1];
      
      
      del = obj.control_size(1);
      obj.u1(del) = []; obj.u2(del) = []; obj.u3(del) = [];
      obj.u4(del) = []; obj.u5(del) = []; obj.u6(del) = [];
      obj.uw(del) = []; obj.control_time(del) = [];
      obj.control_size = obj.control_size - [0 1];
      
      
      del = obj.algvars_size(1);
      obj.algvars_time(del) = [];
      obj.fex(del) = []; obj.fey(del) = [];
      obj.algvars_size = obj.algvars_size - [0 1];
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
    
    function x = make_struct(obj, k)
      x = struct('xb',obj.xb(k),'yb',obj.yb(k),'thb',obj.thb(k),'lw',obj.lw(k), ...
                 'th1',obj.th1(k),'th2',obj.th2(k),'th3',obj.th3(k), ...
                 'th4',obj.th4(k),'th5',obj.th5(k),'th6',obj.th6(k), ...
                 'dxb',obj.dxb(k),'dyb',obj.dyb(k),'dthb',obj.dthb(k),'dlw',obj.dlw(k), ...
                 'dth1',obj.dth1(k),'dth2',obj.dth2(k),'dth3',obj.dth3(k), ...
                 'dth4',obj.dth4(k),'dth5',obj.dth5(k),'dth6',obj.dth6(k));
      if obj.flags.optimize_mw
        x.mw = obj.mw;
      end
      %{ 
      z = {'ddxb',obj.ddxb(k),'ddyb',obj.ddyb(k),'ddthb',obj.ddthb(k),'ddlw',obj.ddlw(k), ...
            'ddth1',obj.ddth1(k),'ddth2',obj.ddth2(k),'ddth3',obj.ddth3(k), ...
            'ddth4',obj.ddth4(k),'ddth5',obj.ddth5(k),'ddth6',obj.ddth6(k)};
      %}
    end
    
    function pcom = calc_pcom(obj, k)
      x = make_struct(obj, k);
      pcom = SEA_model.pcom(params, x);
    end
    
    function draw_line(obj, k, color)
        l1 = line([obj.xb(k)   ,obj.pjx(1,k)],[obj.yb(k)   ,obj.pjy(1,k)],'Color', color);
        l2 = line([obj.pjx(1,k),obj.pjx(2,k)],[obj.pjy(1,k),obj.pjy(2,k)],'Color', color);
        l3 = line([obj.pjx(3,k),obj.pjx(4,k)],[obj.pjy(3,k),obj.pjy(4,k)],'Color', color);
        l4 = line([obj.xb(k)   ,obj.pjx(5,k)],[obj.yb(k)   ,obj.pjy(5,k)],'Color', color);
        l5 = line([obj.pjx(5,k),obj.pjx(6,k)],[obj.pjy(5,k),obj.pjy(6,k)],'Color', color);
        l6 = line([obj.pjx(7,k),obj.pjx(8,k)],[obj.pjy(7,k),obj.pjy(8,k)],'Color', color);
        l7 = line([obj.xb(k)   ,obj.pjx(9,k)],[obj.yb(k)   ,obj.pjy(9,k)],'Color', color);
        l8 = plot(obj.pjx(10,k),obj.pjy(10,k),'o','Color',color,'MarkerSize',10);
    end
    
    function separate_background_with_section(obj, version)
        if strcmp(version, 'state')
          idx = [1 obj.state_size(1) sum(obj.state_size(1:2)) sum(obj.state_size)];
          section = obj.time(idx);
        elseif strcmp(version, 'control')
          idx = [1 obj.control_size(1) sum(obj.control_size(1:2)) sum(obj.control_size)];
          section = obj.control_time(idx);
        elseif strcmp(version, 'algvars')
          idx = [1 obj.algvars_size(1) sum(obj.algvars_size(1:2))-1 sum(obj.algvars_size)];
          section = obj.algvars_time(idx);
        else
          throw('Invalid Argument of Version');
        end
        color = {[1 1 1], [0.2 0.2 0.2]};
        %color = {'r', 'b'};
        utils.back_coloring(section(1:2), color{1});
        utils.back_coloring(section(2:3), color{2});
        utils.back_coloring([section(3), inf], color{1});
    end
  end
  
end