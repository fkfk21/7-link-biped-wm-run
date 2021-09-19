function dae1(daeh,x,z,u,p)
  tic;
  
  global flags
  
  % 共通部分
  optimizer.dae_base(daeh, x, z, u, p);
  
  [q, dq, phi, ~] = utils.decompose_state(x);
  
  [ddq, ddphi] = utils.decompose_algvars(z);

  U = [u.u1; u.u2; u.u3; u.u4; u.u5; u.u6;];

  if flags.optimize_k
    % spring sttifness of SEA
    K = diag(repmat([x.khip x.kknee x.kankle],1,2));
    % inertia of SEA
    B = diag(repmat([params.bhip params.bknee params.bankle],1,2));
  else
    K = diag(repmat([params.khip params.kknee params.kankle],1,2));
    B = diag(repmat([params.bhip params.bknee params.bankle],1,2));
  end
  
  S = params.S;
  % wobbling mass
  uw = u.uw;

  M = SEA_model.M(params,x);
  h = SEA_model.h(params,x,z);

  if flags.optimize_mw
    m = [params.m1;params.m2;params.m3;params.m4;params.m5;params.m6;params.m7;x.mw];
  else
    m = [params.m1;params.m2;params.m3;params.m4;params.m5;params.m6;params.m7;params.mw];
  end
  I = [params.i1;params.i2;params.i3;params.i4;params.i5;params.i6;params.i7];

  g = params.g;

  thb = q(3); dthb = dq(3); ddthb = ddq(3);
  th = q(4+1:4+6); dth = dq(4+1:4+6); ddth = ddq(4+1:4+6);
  [~, ~, ddth_abs] = utils.calculate_absolute_angle(th, dth, ddth, thb, dthb, ddthb);
  pcom = SEA_model.pcom(params,x);
  ddpcom = SEA_model.ddpcom(params,x,z);
  xcom = pcom(1); ycom = pcom(2);
  ddxcom = ddpcom(1); ddycom = ddpcom(2);
  %Jc1 = SEA_model.Jc1(params,x);
  fe = [z.fex; z.fey];
  
  if flags.use_sea
    tau = K*(phi-q(5:10,:));
  else 
    tau = U;
  end
  tau2 = [uw;tau];
  %DAE1 = M*ddq -(S*tau2+Jc1.'*fe-h);
  DAE1 = M*ddq -(S*tau2-h);
  DAE2 = B*ddphi - (U-tau);
  DAE3 = z.zmp_x - (sum(m)*g*xcom + I.'*ddth_abs)/(sum(m)*(ddycom+g));
  %DAE3 = z.zmp_x - (sum(m.*(ddpcy+g) - m.*ddpcx.*(pcy - 0)) + sum(I.*ddth_abs)) ...
  %                 /sum(m.*(ddpcy+g));
  %DAE3 = z.zmp_x - (xcom - ycom*ddxcom/(ddycom+g));
  %DAE4 = [(xcom-z.zmp_x)/ycom*sum(m)*g; sum(m)*g];
  
  daeh.setAlgEquation(DAE1(1));
  daeh.setAlgEquation(DAE1(2));
  daeh.setAlgEquation(DAE1(3));
  daeh.setAlgEquation(DAE1(4));
  daeh.setAlgEquation(DAE1(5));
  daeh.setAlgEquation(DAE1(6));
  daeh.setAlgEquation(DAE1(7));
  daeh.setAlgEquation(DAE1(8));
  daeh.setAlgEquation(DAE1(9));
  daeh.setAlgEquation(DAE1(10));
  daeh.setAlgEquation(DAE2(1));
  daeh.setAlgEquation(DAE2(2));
  daeh.setAlgEquation(DAE2(3));
  daeh.setAlgEquation(DAE2(4));
  daeh.setAlgEquation(DAE2(5));
  daeh.setAlgEquation(DAE2(6));
  daeh.setAlgEquation(DAE3(1));
  %daeh.setAlgEquation(DAE4(1));
  %daeh.setAlgEquation(DAE4(2));
  
  fprintf('dae1                   complete : %.2f seconds\n',toc);
end
