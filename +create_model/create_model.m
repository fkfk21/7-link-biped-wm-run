function create_model()
  tic

% numbers
  nl = 7; % nunber of links
  nj = 6; % number of joints

% sym
  disp('Creating syms');

% constants
  syms g  % gravitional acceleration

% constants of links
  syms m [1 nl] % mass of link
  syms I [1 nl] % inertia of link
  syms l [1 nl] % length of link
  syms a [1 nl] % distance from joint to CoM
  syms c [1 2]  % distance from ankle to heel

% generalized coordinate
  syms q [4+nj 1]
  syms dq [4+nj 1]
  syms d2q [4+nj 1]
  syms d3q [4+nj 1]

% base(hip) cordinates
  pb = [q(1) q(2)];
  thb = q(3);
  dthb = dq(3);

% wobbling mass
  lw = q(4);
  syms mw % mass of wobbling mass

% link angle
  th = q(4+1:4+nj);
  dth = dq(4+1:4+nj);

  % absolute angle of link
  th_abs = [
      thb + th(1);
      thb + th(1) + th(2);
      thb + th(1) + th(2) + th(3);
      thb + th(4);
      thb + th(4) + th(5);
      thb + th(4) + th(5) + th(6);
      thb
      ];
  dth_abs = [
      dthb + dth(1);
      dthb + dth(1) + dth(2);
      dthb + dth(1) + dth(2) + dth(3);
      dthb + dth(4);
      dthb + dth(4) + dth(5);
      dthb + dth(4) + dth(5) + dth(6);
      dthb
      ];

% positions
  disp('Calculate positions');

  % position of each joint
  syms pj [nl+2 2]
  pj(1,:) = pb      +  l(1)       * [cos(th_abs(1)) sin(th_abs(1))]; %leg1 knee
  pj(2,:) = pj(1,:) +  l(2)       * [cos(th_abs(2)) sin(th_abs(2))]; %leg1 ankle
  pj(3,:) = pj(2,:) + (l(3)-c(1)) * [cos(th_abs(3)) sin(th_abs(3))]; %leg1 toe
  pj(4,:) = pj(2,:) -  c(1)       * [cos(th_abs(3)) sin(th_abs(3))]; %leg1 heel
  pj(5,:) = pb      +  l(4)       * [cos(th_abs(4)) sin(th_abs(4))]; %leg2 knee
  pj(6,:) = pj(5,:) +  l(5)       * [cos(th_abs(5)) sin(th_abs(5))]; %leg2 ankle
  pj(7,:) = pj(6,:) + (l(6)-c(2)) * [cos(th_abs(6)) sin(th_abs(6))]; %leg2 toe
  pj(8,:) = pj(6,:) -  c(2)       * [cos(th_abs(6)) sin(th_abs(6))]; %leg2 heel
  pj(9,:) = pb      +  l(7)       * [cos(th_abs(7)) sin(th_abs(7))]; %head

% position of CoM of each link
  syms pc [nl 2]
  pc(1,:) = pb      +  a(1)       * [cos(th_abs(1)) sin(th_abs(1))]; %leg1 upper
  pc(2,:) = pj(1,:) +  a(2)       * [cos(th_abs(2)) sin(th_abs(2))]; %leg1 lower
  pc(3,:) = pj(2,:) + (a(3)-c(1)) * [cos(th_abs(3)) sin(th_abs(3))]; %leg1 foot
  pc(4,:) = pb      +  a(4)       * [cos(th_abs(4)) sin(th_abs(4))]; %leg2 upper
  pc(5,:) = pj(5,:) +  a(5)       * [cos(th_abs(5)) sin(th_abs(5))]; %leg2 lower
  pc(6,:) = pj(6,:) + (a(6)-c(2)) * [cos(th_abs(6)) sin(th_abs(6))]; %leg2 foot
  pc(7,:) = pb      +  a(7)       * [cos(th_abs(7)) sin(th_abs(7))]; %torso

% position of wobbling mass
  pw = pb + (l(7)-lw) * [cos(th_abs(7)) sin(th_abs(7))];

  disp('Calculating velocity');
  dpc = create_model.mydiff(pc,q,dq,d2q,d3q);
  dpw = create_model.mydiff(pw,q,dq,d2q,d3q);

% inertia of wobbling mass
  lgw = (m7 * a7 + mw * (l7 - lw)) / (m7 + mw);
  Iw = (lgw - a7)^2 * m7 + (lgw - (l7 - lw))^2 * mw;

  I = I + [0, 0, 0, 0, 0, 0, 1] * Iw;
% energy
disp('Calculating Energy');

% potential energy
  Pe = m * g * pc(:,2) + mw * g * pw(2);

% kinetic energy
  Kt = sum(1/2 * m * dpc.^2) + sum(1/2 * mw * dpw.^2); % translation
  Kr = 1/2 * I * dth_abs.^2; % rotation
  Ke = Kt + Kr;

% lagragian
  L = Ke-Pe;

  disp('Calculating Lagrange equation');
  Equations=create_model.Lagrange(L, q, dq, d2q, d3q);

  disp('Calculating M matrix');
  M = simplify(jacobian(Equations,d2q));
  disp('Calculating h');
  h = simplify(Equations-M*d2q);


  disp('Calculating constraints');
  dpj=create_model.mydiff(pj,q,dq, d2q,d3q);

  Jc1 = jacobian(dpj(3,:),dq);
  dJc1 = create_model.mydiff(Jc1,q,dq, d2q,d3q);

  Jc2 = jacobian(dpj(7,:),dq);
  dJc2 = create_model.mydiff(Jc2,q,dq, d2q,d3q);

  disp(['Writing SEA model to file']);
  [~,~]=mkdir('+SEA_model');
  matlabFunction(pj,'file','+SEA_model/pj.m');
  matlabFunction(dpj,'file','+SEA_model/dpj.m');
  matlabFunction(pc,'file','+SEA_model/pc.m');
  matlabFunction(dpc,'file','+SEA_model/dpc.m');
  matlabFunction(M,'file','+SEA_model/M.m');
  matlabFunction(h,'file','+SEA_model/h.m');
  matlabFunction(Jc1,'file','+SEA_model/Jc1.m');
  matlabFunction(dJc1,'file','+SEA_model/dJc1.m');
  matlabFunction(Jc2,'file','+SEA_model/Jc2.m');
  matlabFunction(dJc2,'file','+SEA_model/dJc2.m');
  create_model.modify_functions();
  disp('Finish');
  toc
end
