function out = simulate_seird_rk4(t, p, N, IC)
  % p = [beta sigma gamma mu]
  beta  = p(1);
  sigma = p(2);
  gamma = p(3);
  mu    = p(4);

  dt = 1;
  n = numel(t);

  Y = zeros(n, 5);
  Y(1,:) = IC(:)';

  for k = 1:n-1
    yk = Y(k,:)';
    k1 = seird_rhs(yk, beta, sigma, gamma, mu, N);
    k2 = seird_rhs(yk + 0.5*dt*k1, beta, sigma, gamma, mu, N);
    k3 = seird_rhs(yk + 0.5*dt*k2, beta, sigma, gamma, mu, N);
    k4 = seird_rhs(yk + dt*k3, beta, sigma, gamma, mu, N);
    Y(k+1,:) = (yk + (dt/6)*(k1 + 2*k2 + 2*k3 + k4))';
  end

  S = Y(:,1); E = Y(:,2); I = Y(:,3); R = Y(:,4); D = Y(:,5);
  incidence = sigma .* E;

  out.Y = Y;
  out.S = S;
  out.E = E;
  out.I = I;
  out.R = R;
  out.D = D;
  out.yhat = incidence;
  out.cumulative = cumsum(incidence);
end

function dY = seird_rhs(Y, beta, sigma, gamma, mu, N)
  S = Y(1); E = Y(2); I = Y(3); R = Y(4); D = Y(5);
  dS = -beta*S*I/N;
  dE =  beta*S*I/N - sigma*E;
  dI =  sigma*E - gamma*I - mu*I;
  dR =  gamma*I;
  dD =  mu*I;
  dY = [dS; dE; dI; dR; dD];
end