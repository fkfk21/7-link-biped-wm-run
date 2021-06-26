function dae1(daeh,x,z,u,p)
  tic;
  
  global flags
  
  % 共通部分
  optimizer.dae_base(daeh, x, z, u, p);
  
  
  [q, dq, phi, ~] = utils.decompose_state(x);
  
  [ddq, ddphi] = utils.decompose_algvars(z);

  U = [u.u1; u.u2; u.u3; u.u4; u.u5; u.u6;];

  F1 = [z.f1x; z.f1y; z.f1th];
  F2 = [z.f2x; z.f2y; z.f2th];

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

  Jc1 = SEA_model.Jc1(params,x);
  dJc1 = SEA_model.dJc1(params,x);

  tau = K*(phi-q(5:10,:));
  tau2 = [uw;tau];
  DAE1 = [M,-Jc1.'; Jc1,zeros(3,3)]*[ddq;F1] - [S*tau2-h; -dJc1*dq];
  DAE2 = B*ddphi - (U-tau);
  DAE3 = F2;
  
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
  daeh.setAlgEquation(DAE1(11));
  daeh.setAlgEquation(DAE1(12));
  daeh.setAlgEquation(DAE1(13));
  daeh.setAlgEquation(DAE2(1));
  daeh.setAlgEquation(DAE2(2));
  daeh.setAlgEquation(DAE2(3));
  daeh.setAlgEquation(DAE2(4));
  daeh.setAlgEquation(DAE2(5));
  daeh.setAlgEquation(DAE2(6));
  daeh.setAlgEquation(DAE3(1));
  daeh.setAlgEquation(DAE3(2));
  daeh.setAlgEquation(DAE3(3));
  
  fprintf('dae1                   complete : %.2f seconds\n',toc);
end
