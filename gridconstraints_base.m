%% 立脚期と浮遊期共通のgridconstraints
% 各関節角の制限,角速度の制限はvarsに記述

function gridconstraints_base(conh, q, phi, pj, dpj)

  global step
  
  % 前進制約
  conh.add(dpj(6,1),'>=',0);
  
  % thetaとphiが離れすぎない(バネの伸びに関する制約)
  conh.add(q(5:10)-phi,'>=',-pi*ones(6,1));
  conh.add(q(5:10)-phi,'<=',pi*ones(6,1));
  
  % 仮想障害物の回避
  conh.add((pj(6,1)-step/2)^2+pj(6,2)^2,'>=',0.1^2);
  
end