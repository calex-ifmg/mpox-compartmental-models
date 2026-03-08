function fit = fit_sir_mpox(data)

  t = data.t;
  y = data.y;
  N = data.N;

  I0 = max(1, y(1));
  R0 = 0;
  S0 = N - I0 - R0;
  IC = [S0; I0; R0];

  p0 = [0.45, 0.18];
  lb = [1e-6, 1e-6];
  ub = [5, 2];

  obj = @(p) sir_obj(bound(p, lb, ub), t, y, N, IC);
  p = fminsearch(obj, p0);

  p = bound(p, lb, ub);
  sim = simulate_sir_rk4(t, p, N, IC);

  fit.p = p;
  fit.IC = IC;
  fit.yhat = sim.yhat;
  fit.cumulative = sim.cumulative;
  fit.S = sim.S;
  fit.I = sim.I;
  fit.R = sim.R;
  fit.residuals = y - sim.yhat;
end

function val = sir_obj(p, t, y, N, IC)
  sim = simulate_sir_rk4(t, p, N, IC);
  val = sqrt(mean((y - sim.yhat).^2));
end

function p = bound(p, lb, ub)
  p = max(p, lb);
  p = min(p, ub);
end