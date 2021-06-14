%% 浮遊期のgridconstraints

function gridconstraints2(conh, k, K, x, p)
  tic;
  global ppphi pphi

  % 共通部分
  [q, ~, phi, ~] = utils.decompose_state(x);
  pj = SEA_model.pj(params,x);
  dpj = SEA_model.dpj(params,x);
  gridconstraints_base(conh, q, phi, pj, dpj);

  % 各関節が地面より上(y座標制約)
  conh.add(pj(1,2),'>=',0);
  conh.add(pj(3,2),'>=',0); % 支持脚つまさき
  conh.add(pj(4,2),'>=',0); % 支持脚かかと
  conh.add(pj(5,2),'>=',0);
  conh.add(pj(7,2),'>=',0);
  conh.add(pj(8,2),'>=',0);
  
  
  % 滑らか制約
  conh.add(ppphi-2*pphi+phi,'<=',2)
  conh.add(ppphi-2*pphi+phi,'>=',-2)
  ppphi = pphi;
  pphi = phi;
  
  fprintf('gridconstraints2(k=%2d) complete : %.2f seconds\n',k,toc);
end
