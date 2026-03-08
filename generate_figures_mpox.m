function generate_figures_mpox(data, sir, seir, seird, msir, mseir, mseird)

  % Figura 1 - série completa
  figure(1); clf;
  plot(data.full_series, 'LineWidth', 1.5);
  xlabel('Dias');
  ylabel('Casos diários (média móvel 7d)');
  title('Mpox no Brasil - série temporal completa');
  grid on;
  print('-dpng', '-r300', 'fig1_brazil_series.png');

  % Figura 2 - primeira onda
  figure(2); clf;
  plot(data.t, data.y, 'LineWidth', 1.8);
  xlabel('Dias');
  ylabel('Casos diários');
  title('Primeira onda de mpox no Brasil');
  grid on;
  print('-dpng', '-r300', 'fig2_wave_daily.png');

  % Figura 3 - ajuste acumulado
  figure(3); clf;
  plot(data.t, data.cumulative - data.cumulative(1), 'k', 'LineWidth', 2); hold on;
  plot(data.t, sir.cumulative, '--', 'LineWidth', 1.5);
  plot(data.t, seir.cumulative, '-', 'LineWidth', 1.5);
  plot(data.t, seird.cumulative, '-.', 'LineWidth', 1.5);
  xlabel('Dias');
  ylabel('Casos acumulados');
  title('Ajuste acumulado dos modelos');
  legend('Observado','SIR','SEIR','SEIRD','Location','best');
  grid on;
  print('-dpng', '-r300', 'fig3_cumulative_fit.png');

  % Figura 4 - ajuste diário
  figure(4); clf;
  plot(data.t, data.y, 'k', 'LineWidth', 2); hold on;
  plot(data.t, sir.yhat, '--', 'LineWidth', 1.5);
  plot(data.t, seir.yhat, '-', 'LineWidth', 1.5);
  plot(data.t, seird.yhat, '-.', 'LineWidth', 1.5);
  xlabel('Dias');
  ylabel('Casos diários');
  title('Ajuste diário dos modelos');
  legend('Observado','SIR','SEIR','SEIRD','Location','best');
  grid on;
  print('-dpng', '-r300', 'fig4_daily_fit.png');

  % Figura 5 - métricas
  figure(5); clf;
  M = [msir.rmse, mseir.rmse, mseird.rmse;
       msir.mae,  mseir.mae,  mseird.mae;
       msir.r2,   mseir.r2,   mseird.r2]';
  bar(M);
  set(gca, 'XTickLabel', {'SIR','SEIR','SEIRD'});
  legend('RMSE','MAE','R^2','Location','best');
  title('Comparação de métricas');
  grid on;
  print('-dpng', '-r300', 'fig5_metrics.png');

  % Figura 6 - dinâmica dos compartimentos infecciosos
  figure(6); clf;

  plot(data.t, seir.E ./ data.N, 'LineWidth', 2); hold on;
  plot(data.t, seir.I ./ data.N, 'LineWidth', 2);
  plot(data.t, seir.R ./ data.N, 'LineWidth', 2);

  xlabel('Dias');
  ylabel('Proporção da população efetiva');
  title('Dinâmica dos compartimentos do modelo SEIR');

  legend('Expostos','Infectados','Recuperados','Location','northeast');

  grid on;

  print('-dpng', '-r300', 'fig6_seir_compartments.png');

  % Figura 7 - resíduos
  figure(7); clf;
  boxplot([sir.residuals, seir.residuals, seird.residuals], ...
          'Labels', {'SIR','SEIR','SEIRD'});
  ylabel('Resíduos');
  title('Distribuição dos resíduos');
  grid on;
  print('-dpng', '-r300', 'fig7_residuals_box.png');
end
