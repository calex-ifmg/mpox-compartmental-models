function out = simulate_seir_rk4(t, p, N, IC)
  % p = [beta sigma gamma]
  beta = p(1);
  sigma = p(2);
  gamma = p(3);

  dt = 1;
  n = numel(t);

  Y = zeros(n, 4);
  Y(1,:) = IC(:)';

  for k = 1:n-1
    yk = Y(k,:)';
    k1 = seir_rhs(yk, beta, sigma, gamma, N);
    k2 = seir_rhs(yk + 0.5*dt*k1, beta, sigma, gamma, N);
    k3 = seir_rhs(yk + 0.5*dt*k2, beta, sigma, gamma, N);
    k4 = seir_rhs(yk + dt*k3, beta, sigma, gamma, N);
    Y(k+1,:) = (yk + (dt/6)*(k1 + 2*k2 + 2*k3 + k4))';
  end

  S = Y(:,1); E = Y(:,2); I = Y(:,3); R = Y(:,4);
  incidence = sigma .* E;

  out.Y = Y;
  out.S = S;
  out.E = E;
  out.I = I;
  out.R = R;
  out.yhat = incidence;
  out.cumulative = cumsum(incidence);
end

function dY = seir_rhs(Y, beta, sigma, gamma, N)
  S = Y(1); E = Y(2); I = Y(3); R = Y(4);
  dS = -beta*S*I/N;
  dE =  beta*S*I/N - sigma*E;
  dI =  sigma*E - gamma*I;
  dR =  gamma*I;
  dY = [dS; dE; dI; dR];
end