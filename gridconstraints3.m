%% 立脚期(最後)のgridconstraints

function gridconstraints3(conh, k, K, x, p)
  tic;
  global v
  global q0 phi0 dq0 dphi0
  global ppphi pphi

  % 共通部分
  [q, dq, phi, dphi] = utils.decompose_state(x);
  pj = SEA_model.pj(params,x);
  dpj = SEA_model.dpj(params,x);
  gridconstraints_base(conh, q, phi, pj, dpj, x);

  % 各関節が地面より上(y座標制約)
  conh.add(pj(1,2),'>=',0);
  conh.add(pj(3,2),'>=',0); % 支持脚つまさき
  conh.add(pj(4,2),'>=',0); % 支持脚かかと
  conh.add(pj(5,2),'>=',0);
  conh.add(pj(7,2),'==',0);
  conh.add(pj(8,2),'==',0);
  
  % 支持脚のx方向の停止
  conh.add(dpj(6,1), '==', 0);

  if k == K
      conh.add(dpj(6,2),'<=',0); %脚交換制約
      conh.add((q(1)-q0(1))/x.time,'==',v); %速度制約
      % reset map
      reset_map1 = [
        zeros(3),eye(3);
        eye(3),zeros(3)
        ];
      reset_map2 = blkdiag(eye(4),reset_map1,reset_map1);
      reset_map = blkdiag(reset_map2,reset_map2);
      conh.add([q;phi;dq;dphi],'==',reset_map*[q0;phi0;dq0;dphi0]+[x.time*v;zeros(31,1)]);
  end
  
  % 滑らか制約
  conh.add(ppphi-2*pphi+phi,'<=',2)
  conh.add(ppphi-2*pphi+phi,'>=',-2)
  ppphi = pphi;
  pphi = phi;

  fprintf('gridconstraints3(k=%2d) complete : %.2f seconds\n',k,toc);
end
