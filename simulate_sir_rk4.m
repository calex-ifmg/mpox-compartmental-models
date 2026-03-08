function out = simulate_sir_rk4(t, p, N, IC)
  % p = [beta gamma]
  beta = p(1);
  gamma = p(2);

  dt = 1;
  n = numel(t);

  Y = zeros(n, 3);
  Y(1,:) = IC(:)';

  for k = 1:n-1
    yk = Y(k,:)';
    k1 = sir_rhs(yk, beta, gamma, N);
    k2 = sir_rhs(yk + 0.5*dt*k1, beta, gamma, N);
    k3 = sir_rhs(yk + 0.5*dt*k2, beta, gamma, N);
    k4 = sir_rhs(yk + dt*k3, beta, gamma, N);
    Y(k+1,:) = (yk + (dt/6)*(k1 + 2*k2 + 2*k3 + k4))';
  end

  S = Y(:,1); I = Y(:,2); R = Y(:,3);
  incidence = beta .* S .* I ./ N;

  out.Y = Y;
  out.S = S;
  out.I = I;
  out.R = R;
  out.yhat = incidence;
  out.cumulative = cumsum(incidence);
end

function dY = sir_rhs(Y, beta, gamma, N)
  S = Y(1); I = Y(2); R = Y(3);
  dS = -beta*S*I/N;
  dI =  beta*S*I/N - gamma*I;
  dR =  gamma*I;
  dY = [dS; dI; dR];
end