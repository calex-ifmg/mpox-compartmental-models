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

Clique **Commit changes**.

---

### 4. Copiar a URL e adicionar no artigo

A URL do repositório será:
```
https://github.com/calex-ifmg/mpox-compartmental-models
