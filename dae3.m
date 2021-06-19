function dae3(daeh,x,z,u,p)
  tic;
  
  % 共通部分
  optimizer.dae_base(daeh, x, z, u, p);
  
  
  [q, dq, phi, ~] = utils.decompose_state(x);
  
  [ddq, ddphi] = utils.decompose_algvars(z);

  U = [u.u1; u.u2; u.u3; u.u4; u.u5; u.u6;];

  F1 = [z.f1x; z.f1y; z.f1th];
  F2 = [z.f2x; z.f2y; z.f2th];

  % spring sttifness of SEA
  %K = diag(repmat([276.6257 153.8759 250.0],1,2));
  K = diag(repmat([x.khip x.kknee x.kankle],1,2));
  % inertia of SEA
  B = diag(repmat([0.02 0.02 0.02],1,2));
  %B = diag(repmat([0.02 0.02 x.bankle],1,2));

  S = params.S;
  % wobbling mass
  uw = u.uw;

  M = SEA_model.M(params,x);
  h = SEA_model.h(params,x,z);

  Jc2 = SEA_model.Jc2(params,x);
  dJc2 = SEA_model.dJc2(params,x,z);

  tau = K*(phi-q(5:10,:));
  tau2 = [uw;tau];
  DAE1 = [M,-Jc2.'; Jc2,zeros(3,3)]*[ddq;F2] - [S*tau2-h; -dJc2*dq];
  DAE2 = B*ddphi - (U-tau);
  DAE3 = F1;
  
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
  
  fprintf('dae3                   complete : %.2f seconds\n',toc);
end