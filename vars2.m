function vars2(vh)
  tic;

  % 共通部分
  optimizer.vars_base(vh);
  
  
  % 拘束力
  vh.addAlgVar('f1x','lb', 0, 'ub', 0);
  vh.addAlgVar('f1y','lb', 0, 'ub', 0);
  vh.addAlgVar('f1th','lb', 0, 'ub', 0);
  vh.addAlgVar('f2x','lb', 0, 'ub', 0);
  vh.addAlgVar('f2y','lb', 0, 'ub', 0);
  vh.addAlgVar('f2th','lb', 0, 'ub', 0);

  fprintf('vars2                  complete : %.2f seconds\n',toc);