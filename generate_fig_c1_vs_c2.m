% generate_fig_c1_vs_c2.m
% Gera figura comparativa entre calibração livre (C1) e restrita (C2)
% para o modelo SEIR. Salva fig8_c1_vs_c2.png
%
% Execute DEPOIS de rodar run_mpox_paper_pipeline.m (que já carrega 'data')
% ou rode standalone (vai recarregar os dados).

clear; clc; close all;
pkg load io;
more off;

csv_file = 'owid-monkeypox-data.csv';
data = load_mpox_brazil_firstwave(csv_file);

N = data.N;
t = data.t;
y = data.y;

% ---------------------------------------------------------------
% Condições iniciais (mesmas do fit_seir_mpox.m)
% ---------------------------------------------------------------
E0 = max(1, round(y(1)));
I0 = max(1, round(y(1)));
R0_ic = 0;
S0 = N - E0 - I0 - R0_ic;
IC = [S0; E0; I0; R0_ic];

% ---------------------------------------------------------------
% C1 - parâmetros da calibração livre (resultados anteriores)
% ---------------------------------------------------------------
p_c1 = [1.8754, 0.9550, 1.7787];   % beta, sigma, gamma
sim_c1 = simulate_seir_rk4(t, p_c1, N, IC);

% ---------------------------------------------------------------
% C2 - calibração restrita com bounds biológicos
% ---------------------------------------------------------------
lb_c2 = [1e-6, 1/21, 1/28];
ub_c2 = [5,    1/5,  1/7 ];
p0_c2 = [0.65, 1/10, 1/14];

bound = @(p) max(min(p, ub_c2), lb_c2);
obj_c2 = @(p) sqrt(mean((y - simulate_seir_rk4(t, bound(p), N, IC).yhat).^2));
p_c2_raw = fminsearch(obj_c2, p0_c2);
p_c2 = bound(p_c2_raw);

fprintf('C2 params: beta=%.6f  sigma=%.6f (1/sigma=%.1fd)  gamma=%.6f (1/gamma=%.1fd)\n', ...
        p_c2(1), p_c2(2), 1/p_c2(2), p_c2(3), 1/p_c2(3));

sim_c2 = simulate_seir_rk4(t, p_c2, N, IC);

% ---------------------------------------------------------------
% Métricas
% ---------------------------------------------------------------
m_c1 = compute_metrics(y, sim_c1.yhat);
m_c2 = compute_metrics(y, sim_c2.yhat);

fprintf('C1 -> RMSE=%.3f  MAE=%.3f  R2=%.4f\n', m_c1.rmse, m_c1.mae, m_c1.r2);
fprintf('C2 -> RMSE=%.3f  MAE=%.3f  R2=%.4f\n', m_c2.rmse, m_c2.mae, m_c2.r2);

% ---------------------------------------------------------------
% Figura 8 - comparação C1 vs C2 (ajuste diário SEIR)
% ---------------------------------------------------------------
figure(8); clf;
set(gcf, 'Position', [100 100 800 420]);

plot(t, y, 'k-',  'LineWidth', 2.2); hold on;
plot(t, sim_c1.yhat, 'b-',  'LineWidth', 1.8);
plot(t, sim_c2.yhat, 'r--', 'LineWidth', 1.8);

xlabel('Dias', 'FontSize', 12);
ylabel('Casos diários', 'FontSize', 12);
title('SEIR: calibração livre (C1) vs restrita (C2)', 'FontSize', 13);

leg = legend( ...
  'Observado', ...
  sprintf('C1 – livre  (RMSE=%.1f)', m_c1.rmse), ...
  sprintf('C2 – restrita (RMSE=%.1f)', m_c2.rmse), ...
  'Location', 'northeast');
set(leg, 'FontSize', 10);

% Adiciona caixa de texto com parâmetros
txt_c1 = sprintf('C1: \\beta=%.3f, 1/\\sigma=%.2fd, 1/\\gamma=%.2fd', ...
                  p_c1(1), 1/p_c1(2), 1/p_c1(3));
txt_c2 = sprintf('C2: \\beta=%.4f, 1/\\sigma=%.1fd, 1/\\gamma=%.1fd', ...
                  p_c2(1), 1/p_c2(2), 1/p_c2(3));
annotation('textbox', [0.13 0.72 0.45 0.12], ...
           'String', {txt_c1, txt_c2}, ...
           'FitBoxToText', 'on', ...
           'BackgroundColor', [1 1 1 0.8], ...
           'FontSize', 9, 'EdgeColor', [0.5 0.5 0.5]);

grid on;
print('-dpng', '-r300', 'fig8_c1_vs_c2.png');
fprintf('\nFigura salva: fig8_c1_vs_c2.png\n');
