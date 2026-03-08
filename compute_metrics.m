function m = compute_metrics(y, yhat)

  y = y(:);
  yhat = yhat(:);

  rmse = sqrt(mean((y - yhat).^2));
  mae = mean(abs(y - yhat));

  ss_res = sum((y - yhat).^2);
  ss_tot = sum((y - mean(y)).^2);

  if ss_tot == 0
    r2 = 0;
  else
    r2 = 1 - ss_res/ss_tot;
  end

  m.rmse = rmse;
  m.mae = mae;
  m.r2 = r2;
end