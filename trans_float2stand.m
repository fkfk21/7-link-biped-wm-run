%% 浮遊期から立脚期への遷移

function trans_float2stand(ch, x0, xF)
% x0 current stage
% xF previous stage

[~, dq, ~, ~] = utils.decompose_state(xF);
M = SEA_model.M(params,xF);
Jc2 = SEA_model.Jc2(params,xF);
dq_after_lambda = [M,-Jc2.'; Jc2,zeros(3,3)] \ [M*dq; zeros(3,1)];
dq_after = dq_after_lambda(1:10);

ch.add(x0.xb  , '==', xF.xb  );
ch.add(x0.yb  , '==', xF.yb  );
ch.add(x0.thb , '==', xF.thb );
ch.add(x0.lw  , '==', xF.lw  );
ch.add(x0.th1 , '==', xF.th1 );
ch.add(x0.th2 , '==', xF.th2 );
ch.add(x0.th3 , '==', xF.th3 );
ch.add(x0.th4 , '==', xF.th4 );
ch.add(x0.th5 , '==', xF.th5 );
ch.add(x0.th6 , '==', xF.th6 );
ch.add(x0.phi1, '==', xF.phi1);
ch.add(x0.phi2, '==', xF.phi2);
ch.add(x0.phi3, '==', xF.phi3);
ch.add(x0.phi4, '==', xF.phi4);
ch.add(x0.phi5, '==', xF.phi5);
ch.add(x0.phi6, '==', xF.phi6);
ch.add(x0.dxb  , '==', dq_after(1) );
ch.add(x0.dyb  , '==', dq_after(2) );
ch.add(x0.dthb , '==', dq_after(3) );
ch.add(x0.dlw  , '==', dq_after(4) );
ch.add(x0.dth1 , '==', dq_after(5) );
ch.add(x0.dth2 , '==', dq_after(6) );
ch.add(x0.dth3 , '==', dq_after(7) );
ch.add(x0.dth4 , '==', dq_after(8) );
ch.add(x0.dth5 , '==', dq_after(9) );
ch.add(x0.dth6 , '==', dq_after(10));
ch.add(x0.dphi1, '==', xF.dphi1);
ch.add(x0.dphi2, '==', xF.dphi2);
ch.add(x0.dphi3, '==', xF.dphi3);
ch.add(x0.dphi4, '==', xF.dphi4);
ch.add(x0.dphi5, '==', xF.dphi5);
ch.add(x0.dphi6, '==', xF.dphi6);
ch.add(x0.time,'==',xF.time);
end