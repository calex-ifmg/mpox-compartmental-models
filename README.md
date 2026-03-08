# Mpox Compartmental Models — SBCAS 2026

Código-fonte do artigo:  
**"Análise Comparativa de Modelos Compartimentais SIR, SEIR e SEIRD 
na Dinâmica da Mpox no Brasil"**  
Submetido ao SBCAS 2026.

## Requisitos
- GNU Octave ≥ 7.0
- Pacote `io` (`pkg install -forge io`)
- Toolkit [EPIDEMIC](https://github.com/americocunhajr/EPIDEMIC)

## Dados
Baixe o arquivo `owid-monkeypox-data.csv` em:  
https://ourworldindata.org/monkeypox

## Como executar
```octave
run run_mpox_paper_pipeline.m
```

Para gerar a figura comparativa C1 vs C2:
```octave
run generate_fig_c1_vs_c2.m
```

## Estrutura
| Arquivo | Descrição |
|---|---|
| `run_mpox_paper_pipeline.m` | Pipeline principal |
| `fit_sir/seir/seird_mpox.m` | Calibração de cada modelo |
| `simulate_sir/seir/seird_rk4.m` | Simulação RK4 |
| `compute_metrics.m` | RMSE, MAE, R² |
| `generate_figures_mpox.m` | Figuras do artigo |
| `generate_fig_c1_vs_c2.m` | Figura C1 vs C2 |
| `load_mpox_brazil_firstwave.m` | Carregamento e pré-processamento |
```

## Atribuições e licenças

- Toolkit EPIDEMIC (Cunha Jr. et al.): MIT License  
  https://github.com/americocunhajr/EPIDEMIC

- Dados epidemiológicos: Our World in Data, CC BY  
  https://ourworldindata.org/mpox  
  Baixe o arquivo `owid-monkeypox-data.csv` e coloque 
  na mesma pasta antes de executar.

## Este repositório
Licença MIT. Código original desenvolvido para o artigo 
submetido ao SBCAS 2026.
