clear; clc; close all;

pkg load io;
more off;

csv_file = 'owid-monkeypox-data.csv';

data = load_mpox_brazil_firstwave(csv_file);

fprintf('Janela usada: %s até %s\n', data.start_date, data.end_date);
fprintf('Número de pontos: %d\n', numel(data.t));

% Ajustes
sir   = fit_sir_mpox(data);
seir  = fit_seir_mpox(data);
seird = fit_seird_mpox(data);

disp('--- PARÂMETROS CALIBRADOS ---');
disp('SIR (beta, gamma)');
disp(sir.p);

disp('SEIR (beta, sigma, gamma)');
disp(seir.p);

disp('SEIRD (beta, sigma, gamma, mu)');
disp(seird.p);

% Métricas
metrics_sir   = compute_metrics(data.y, sir.yhat);
metrics_seir  = compute_metrics(data.y, seir.yhat);
metrics_seird = compute_metrics(data.y, seird.yhat);

disp('--- MÉTRICAS ---');
disp('SIR');   disp(metrics_sir);
disp('SEIR');  disp(metrics_seir);
disp('SEIRD'); disp(metrics_seird);

% Geração das figuras
generate_figures_mpox(data, sir, seir, seird, metrics_sir, metrics_seir, metrics_seird);

% Salva métricas em CSV
fid = fopen('metrics.csv','w');
fprintf(fid,'model,rmse,mae,r2\n');
fprintf(fid,'SIR,%.4f,%.4f,%.4f\n', metrics_sir.rmse, metrics_sir.mae, metrics_sir.r2);
fprintf(fid,'SEIR,%.4f,%.4f,%.4f\n', metrics_seir.rmse, metrics_seir.mae, metrics_seir.r2);
fprintf(fid,'SEIRD,%.4f,%.4f,%.4f\n', metrics_seird.rmse, metrics_seird.mae, metrics_seird.r2);
fclose(fid);

%save('results_workspace.mat', 'data', 'sir', 'seir', 'seird', ...
%     'metrics_sir', 'metrics_seir', 'metrics_seird');

fprintf('\nArquivos gerados com sucesso.\n');
