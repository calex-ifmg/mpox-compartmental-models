function fit = fit_seir_mpox(data)

  t = data.t;
  y = data.y;
  N = data.N;

  E0 = max(1, round(y(1)));
  I0 = max(1, round(y(1)));
  R0 = 0;
  S0 = N - E0 - I0 - R0;
  IC = [S0; E0; I0; R0];

%  p0 = [0.65, 0.25, 0.16];   % beta sigma gamma
%  lb = [1e-6, 1e-6, 1e-6];
%  ub = [5, 3, 2];
% DEPOIS:
p0 = [0.65, 1/10, 1/14];   % incubação ~10d, infeccioso ~14d
% DEPOIS (bounds biológicos para mpox):
% beta: livre | sigma: 1/21 a 1/5 dias | gamma: 1/28 a 1/7 dias
lb = [1e-6, 1/21, 1/28];
ub = [5,    1/5,  1/7 ];

  obj = @(p) seir_obj(bound(p, lb, ub), t, y, N, IC);
  p = fminsearch(obj, p0);

  p = bound(p, lb, ub);
  sim = simulate_seir_rk4(t, p, N, IC);

  fit.p = p;
  fit.IC = IC;
  fit.yhat = sim.yhat;
  fit.cumulative = sim.cumulative;
  fit.S = sim.S;
  fit.E = sim.E;
  fit.I = sim.I;
  fit.R = sim.R;
  fit.residuals = y - sim.yhat;
end

function val = seir_obj(p, t, y, N, IC)
  sim = simulate_seir_rk4(t, p, N, IC);
  val = sqrt(mean((y - sim.yhat).^2));
end

function p = bound(p, lb, ub)
  p = max(p, lb);
  p = min(p, ub);
end
