function vars1(vh)
  tic;

  % 共通部分
  optimizer.vars_base(vh);
  
  
  % ZMP
  vh.addAlgVar('zmp_x','lb', -params.a3, 'ub', params.l3-params.a3);
  vh.addAlgVar('fex');
  vh.addAlgVar('fey', 'lb', 0);
  vh.addAlgVar('feth');


  fprintf('vars1                  complete : %.2f seconds\n',toc);
