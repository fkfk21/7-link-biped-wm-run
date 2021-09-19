function vars2(vh)
  tic;

  % 共通部分
  optimizer.vars_base(vh);
  
  
  % ZMP
  % 浮遊期なので無し

  fprintf('vars2                  complete : %.2f seconds\n',toc);
