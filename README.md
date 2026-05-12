# Lakehouse com Databricks Free Edition e Arquitetura Medalhão

---

## Integrantes

- Luiz Fillipy Vefago Binatti
- João Vitor de Oliveira Lima
- Vinicius Pedroso Milanez

---
 
## Objetivo

Este projeto tem como objetivo construir um pipeline de dados utilizando o Databricks Free Edition, implementando a arquitetura Medalhão (Landing → Bronze → Silver → Gold) com automação através de Jobs & Pipelines.

O pipeline realiza a extração, tratamento, organização e modelagem dos dados utilizando Delta Lake e conceitos de Engenharia de Dados.

---

# Arquitetura Medalhão

A arquitetura do projeto segue o modelo Medalhão dividido em quatro camadas:

* LANDING/DADOS
* BRONZE
* SILVER
* GOLD

Fluxo do pipeline:

```text
Banco de Dados
      ↓
LANDING/DADOS (CSV / JSON)
      ↓
BRONZE (Delta Lake bruto)
      ↓
SILVER (Data Quality)
      ↓
GOLD (Modelagem Dimensional)
      ↓
Jobs & Pipelines
```

---

# Etapas do Projeto

## 1. Extração de Dados — LANDING/DADOS

Os dados são extraídos de um banco de dados relacional ou não relacional.

* Banco relacional → arquivos CSV
* Banco não relacional → arquivos JSON

Os arquivos são armazenados no schema:

```text
LANDING/DADOS
```

---

## 2. Camada Bronze

Os arquivos CSV ou JSON são lidos e convertidos para o formato Delta Lake.

Objetivos da camada Bronze:

* Persistência dos dados brutos
* Armazenamento histórico
* Padronização inicial

Schema utilizado:

```text
BRONZE
```

---

## 3. Camada Silver

Na camada Silver são aplicadas regras de Data Quality.

Exemplos:

* Remoção de valores nulos
* Tratamento de duplicidades
* Padronização de tipos
* Validações de regras de negócio

Após o tratamento, os dados confiáveis são gravados no schema:

```text
SILVER
```

---

## 4. Camada Gold

Os dados tratados da camada Silver são utilizados para construir tabelas dimensionais seguindo a modelagem Ralph Kimball.

Exemplos:

* Tabelas fato
* Tabelas dimensão
* Estruturas analíticas

Schema utilizado:

```text
GOLD
```

---

# Automação

Toda a execução do pipeline é automatizada utilizando Jobs & Pipelines do Databricks.

Fluxo de execução:

```text
Notebook Landing
↓
Notebook Bronze
↓
Notebook Silver
↓
Notebook Gold
```

---

# Tecnologias Utilizadas

* Databricks Free Edition
* Delta Lake
* Apache Spark
* Python
* CSV / JSON
* Jobs & Pipelines
* MkDocs
* GitHub

---

# Documentação

A documentação do projeto foi desenvolvida utilizando MkDocs.

Para executar localmente:

```bash
pip install mkdocs-material
mkdocs serve
```

---

# Execução

Clone o repositório:

```bash
git clone https://github.com/usuario/repositorio.git
```

Entre na pasta:

```bash
cd repositorio
```

Execute o MkDocs:

```bash
mkdocs serve
```

---

# Considerações Finais

O projeto demonstra a implementação de uma arquitetura Lakehouse utilizando Databricks e Delta Lake, aplicando conceitos modernos de Engenharia de Dados, Data Quality e modelagem dimensional com automação completa do pipeline.
