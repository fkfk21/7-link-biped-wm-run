function pathcosts(ch, x, z, u, p)
  tic;
  global v
  dphi = [x.dphi1;x.dphi2;x.dphi3;x.dphi4;x.dphi5;x.dphi6;x.dlw];
  U = [u.u1;u.u2;u.u3;u.u4;u.u5;u.u6;u.uw];
  %M=params.m1 + params.m2 + params.m3 + params.m4 + params.m5 + params.m6 + params.m7 + params.mw;
  M=params.m1 + params.m2 + params.m3 + params.m4 + params.m5 + params.m6 + params.m7 + x.mw;
  g = 9.80665;
  ch.add(abs(dphi.*U)/(M*g*v));

  fprintf('pathcosts             complete : %.2f seconds\n',toc);
