function vars1(vh)
  tic;

  % ć±ééšć
  optimizer.vars_base(vh);
  
  
  % ZMP
  vh.addAlgVar('zmp_x','lb', -params.a3, 'ub', params.l3-params.a3);
  vh.addAlgVar('fex');
  vh.addAlgVar('fey', 'lb', 0);
  vh.addAlgVar('feth');%, 'lb', 0, 'ub', 0);


  fprintf('vars1                  complete : %.2f seconds\n',toc);
