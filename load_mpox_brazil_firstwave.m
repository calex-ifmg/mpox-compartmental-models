function data = load_mpox_brazil_firstwave(csv_file)

  pkg load io;

  C = csv2cell(csv_file);
  header = C(1,:);

  col_location      = find(strcmp(header, 'location'));
  col_date          = find(strcmp(header, 'date'));
  col_new_cases     = find(strcmp(header, 'new_cases'));
  col_total_cases   = find(strcmp(header, 'total_cases'));
  col_total_deaths  = find(strcmp(header, 'total_deaths'));

  if isempty(col_location) || isempty(col_date) || isempty(col_new_cases)
    error('Colunas necessárias não encontradas no CSV.');
  end

  rows = C(2:end,:);
  locs = rows(:, col_location);

  idx_br = strcmp(locs, 'Brazil');
  B = rows(idx_br, :);

  dates = B(:, col_date);
  new_cases = cell_to_num(B(:, col_new_cases));
  total_cases = zeros(size(new_cases));
  total_deaths = zeros(size(new_cases));

  if ~isempty(col_total_cases)
    total_cases = cell_to_num(B(:, col_total_cases));
  else
    total_cases = cumsum(new_cases);
  end

  if ~isempty(col_total_deaths)
    total_deaths = cell_to_num(B(:, col_total_deaths));
  end

  % Suavização 7 dias
  new_cases_sm = movmean(new_cases, 7);

  % Primeira onda: do primeiro valor > 0 até o primeiro vale estável
  start_idx = find(new_cases_sm > 0, 1, 'first');
  if isempty(start_idx)
    error('Não foi possível localizar início da série com casos > 0.');
  end

  % Heurística simples para primeira onda
  [~, peak_idx_local] = max(new_cases_sm(start_idx:end));
  peak_idx = start_idx + peak_idx_local - 1;

  end_idx = min(numel(new_cases_sm), peak_idx + 60);
  tail = new_cases_sm(peak_idx:end_idx);
  low_idx = find(tail < max(new_cases_sm)*0.10, 1, 'first');

  if isempty(low_idx)
    wave_end = end_idx;
  else
    wave_end = peak_idx + low_idx - 1;
  end

  sel = start_idx:wave_end;

  y = new_cases_sm(sel);
  y(y < 0) = 0;

  total_cases_sel = total_cases(sel);
  total_deaths_sel = total_deaths(sel);

  t = (0:numel(sel)-1)';

  % População aproximada do Brasil
  N = 214000000;

  data.t = t;
  data.y = y(:);
  data.daily_raw = new_cases(sel);
  data.cumulative = total_cases_sel(:);
  data.deaths = total_deaths_sel(:);
  data.N = N;
  data.start_date = dates{start_idx};
  data.end_date = dates{wave_end};
  data.all_dates = dates(sel);
  data.full_dates = dates;
  data.full_series = new_cases_sm(:);
end

function x = cell_to_num(c)
  x = zeros(numel(c),1);
  for i = 1:numel(c)
    v = c{i};
    if isempty(v)
      x(i) = 0;
    elseif isnumeric(v)
      x(i) = v;
    else
      x(i) = str2double(v);
      if isnan(x(i))
        x(i) = 0;
      end
    end
  end
end