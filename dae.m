function dae(daeh,x,z,u,p)
  tic;
  [q, dq, phi, ~] = utils.decompose_state(x);
  
  ddq = [
    z.ddxb;
    z.ddyb;
    z.ddthb;
    z.ddlw;
    z.ddth1;
    z.ddth2;
    z.ddth3;
    z.ddth4;
    z.ddth5;
    z.ddth6
    ];

  ddphi = [
    z.ddphi1;
    z.ddphi2;
    z.ddphi3;
    z.ddphi4;
    z.ddphi5;
    z.ddphi6
    ];

  U = [
    u.u1;
    u.u2;
    u.u3;
    u.u4;
    u.u5;
    u.u6;
    ];

  F = [z.f1; z.f2; z.f3];

  % spring sttifness of SEA
  K = diag(repmat([276.6257 153.8759 250.0],1,2));
  %K = diag(repmat([x.khip x.kknee x.kankle],1,2));
  % inertia of SEA
  B = diag(repmat([0.02 0.02 0.02],1,2));
  %B = diag(repmat([0.02 0.02 x.bankle],1,2));

  S = params.S;
  % wobbling mass
  uw = u.uw;

  M = SEA_model.M(params,x);
  h = SEA_model.h(params,x,z);

  Jc1 = SEA_model.Jc1(params,x,z);
  dJc1 = SEA_model.dJc1(params,x,z);

  tau = K*(phi-q(5:10,:));
  tau2 = [uw;tau];
  DAE1 = [M,-Jc1.'; Jc1,zeros(3,3)]*[ddq;F] - [S*tau2-h; -dJc1*dq];
  DAE2 = B*ddphi - (U-tau);

  daeh.setODE('xb'    , x.dxb   );
  daeh.setODE('yb'    , x.dyb   );
  daeh.setODE('thb'   , x.dthb  );
  daeh.setODE('lw'    , x.dlw   );
  daeh.setODE('th1'   , x.dth1  );
  daeh.setODE('th2'   , x.dth2  );
  daeh.setODE('th3'   , x.dth3  );
  daeh.setODE('th4'   , x.dth4  );
  daeh.setODE('th5'   , x.dth5  );
  daeh.setODE('th6'   , x.dth6  );
  daeh.setODE('phi1'  , x.dphi1 );
  daeh.setODE('phi2'  , x.dphi2 );
  daeh.setODE('phi3'  , x.dphi3 );
  daeh.setODE('phi4'  , x.dphi4 );
  daeh.setODE('phi5'  , x.dphi5 );
  daeh.setODE('phi6'  , x.dphi6 );
  daeh.setODE('dxb'   , z.ddxb  );
  daeh.setODE('dyb'   , z.ddyb  );
  daeh.setODE('dthb'  , z.ddthb );
  daeh.setODE('dlw'   , z.ddlw  );
  daeh.setODE('dth1'  , z.ddth1 );
  daeh.setODE('dth2'  , z.ddth2 );
  daeh.setODE('dth3'  , z.ddth3 );
  daeh.setODE('dth4'  , z.ddth4 );
  daeh.setODE('dth5'  , z.ddth5 );
  daeh.setODE('dth6'  , z.ddth6 );
  daeh.setODE('dphi1' , z.ddphi1);
  daeh.setODE('dphi2' , z.ddphi2);
  daeh.setODE('dphi3' , z.ddphi3);
  daeh.setODE('dphi4' , z.ddphi4);
  daeh.setODE('dphi5' , z.ddphi5);
  daeh.setODE('dphi6' , z.ddphi6);
  daeh.setODE('time'  , 1       );
  %daeh.setODE('khip'  , 0);
  %daeh.setODE('kknee' , 0);
  %daeh.setODE('kankle', 0);
  %daeh.setODE('bankle', 0);
  %daeh.setODE('mw'    , 0);

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

  fprintf('dae                   complete : %.2f seconds\n',toc);
end
