function fit = fit_seird_mpox(data)

  t = data.t;
  y = data.y;
  N = data.N;

  E0 = max(1, round(y(1)));
  I0 = max(1, round(y(1)));
  R0 = 0;
  D0 = 0;
  S0 = N - E0 - I0 - R0 - D0;
  IC = [S0; E0; I0; R0; D0];

  p0 = [0.65, 0.25, 0.15, 0.001];  % beta sigma gamma mu
  lb = [1e-6, 1e-6, 1e-6, 0];
  ub = [5, 3, 2, 0.05];

% DEPOIS:
%p0 = [0.65, 1/10, 1/14, 0.001];
% DEPOIS:
%lb = [1e-6, 1/21, 1/28, 0];
%ub = [5,    1/5,  1/7,  0.05];

  obj = @(p) seird_obj(bound(p, lb, ub), t, y, N, IC);
  p = fminsearch(obj, p0);

  p = bound(p, lb, ub);
  sim = simulate_seird_rk4(t, p, N, IC);

  fit.p = p;
  fit.IC = IC;
  fit.yhat = sim.yhat;
  fit.cumulative = sim.cumulative;
  fit.S = sim.S;
  fit.E = sim.E;
  fit.I = sim.I;
  fit.R = sim.R;
  fit.D = sim.D;
  fit.residuals = y - sim.yhat;
end

function val = seird_obj(p, t, y, N, IC)
  sim = simulate_seird_rk4(t, p, N, IC);
  val = sqrt(mean((y - sim.yhat).^2));
end

function p = bound(p, lb, ub)
  p = max(p, lb);
  p = min(p, ub);
end

