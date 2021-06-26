function print_param(result)
if result.flags.optimize_mw
  fprintf('m_w     = %f\n',result.mw);
end
if result.flags.optimize_k
  fprintf('k_hip   = %f\n',result.khip);
  fprintf('k_knee  = %f\n',result.kknee);
  fprintf('k_ankle = %f\n',result.kankle);
end
end