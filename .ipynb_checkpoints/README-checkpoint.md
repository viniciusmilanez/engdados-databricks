# 🚀 Trabalho 2 — Apache Spark com MinIO, PostgreSQL e Delta Lake

Projeto desenvolvido para a disciplina **Arquitetura de Dados — SATC**.

Pipeline completo de dados: **PostgreSQL → MinIO (landing-zone) → Delta Lake (bronze)**

---

## 👥 Integrantes

- Luiz Fillipy Vefago Binatti
- João Vitor de Oliveira Lima
- Vinicius Pedroso Milanez

---

## 🏗️ Arquitetura

```
PostgreSQL (fonte)
      │
      │  JDBC
      ▼
MinIO bucket: landing-zone  (CSV)
      │
      │  PySpark + Delta Lake
      ▼
MinIO bucket: bronze  (Delta Lake)
      │
      │  DML: INSERT / UPDATE / DELETE
      ▼
Time Travel (versionamento automático)
```

---

## 📋 Pré-requisitos

| Ferramenta | Versão |
|---|---|
| Python | 3.12+ |
| Poetry | 1.8+ |
| Docker | 24+ |
| Docker Compose | 2.24+ |
| Java (JDK) | 11 ou 17 |

---

## ⚙️ Configuração do ambiente

### 1. Clone o repositório

```bash
git clone https://github.com/<seu-usuario>/<seu-repo>.git
cd <seu-repo>
```

### 2. Instale as dependências com Poetry

```bash
# Instale o Poetry se não tiver
curl -sSL https://install.python-poetry.org | python3 -

# Instale as dependências do projeto
poetry install

# Ative o ambiente virtual
poetry shell
```

### 3. Suba os serviços com Docker Compose

```bash
docker compose up -d
```

Isso irá subir:
- **PostgreSQL** na porta `5432` com o banco `loja_db` já populado
- **MinIO** na porta `9000` (API) e `9001` (console web)
- **minio-init**: container auxiliar que cria os buckets `landing-zone` e `bronze` automaticamente

Verifique se está tudo rodando:

```bash
docker compose ps
```

### 4. Acesse o console do MinIO (opcional)

Abra [http://localhost:9001](http://localhost:9001) no navegador.

| Campo | Valor |
|---|---|
| Usuário | `minioadmin` |
| Senha | `minioadmin123` |

### 5. Inicie o JupyterLab

```bash
poetry run jupyter lab
```

Abra o notebook em `notebooks/01-pipeline-minio-delta.ipynb`.

---

## 📓 Notebooks

| Arquivo | Descrição |
|---|---|
| `notebooks/01-pipeline-minio-delta.ipynb` | Pipeline completo: extração do PostgreSQL, ingestão na landing-zone, conversão para Delta Lake no bronze e operações DML |

---

## 🗄️ Banco de dados (PostgreSQL)

O script `data/init.sql` cria e popula automaticamente 3 tabelas:

- **`produtos`** — catálogo de produtos da loja
- **`clientes`** — cadastro de clientes
- **`vendas`** — registro de transações

---

## 🔄 Operações DML demonstradas

Após a conversão para Delta Lake no bucket `bronze`, o notebook executa:

```sql
-- INSERT: adiciona novas vendas
INSERT INTO vendas_bronze VALUES (100, 1, 3, 2, 120.00, '2024-03-01'), ...

-- UPDATE: corrige o valor de uma venda
UPDATE vendas_bronze SET valor_unitario = 999.99 WHERE id_venda = 100

-- DELETE: remove um registro
DELETE FROM vendas_bronze WHERE id_venda = 101
```

---

## ⏱️ Time Travel (Delta Lake)

O Delta Lake versiona automaticamente todas as alterações. Para consultar uma versão anterior:

```python
spark.read.format("delta").option("versionAsOf", 0).load("s3a://bronze/vendas").show()
```

---

## 📊 Tabelas Gerenciadas vs Não Gerenciadas

| Aspecto | Gerenciada | Não Gerenciada (External) |
|---|---|---|
| Localização dos dados | Controlada pelo Spark | Definida pelo usuário (ex: MinIO) |
| `DROP TABLE` | Remove dados + metadados | Remove apenas metadados |
| Uso típico | Ambientes dev/teste | Data Lake em produção |

Neste projeto utilizamos tabelas **não gerenciadas**, pois os dados residem no MinIO e registramos apenas os metadados com `LOCATION`.

---

## 📚 Documentação

A documentação completa está disponível via MkDocs:

```bash
poetry run mkdocs serve
```

Acesse [http://localhost:8000](http://localhost:8000)

---

## 🔗 Referências

- [Repositório modelo do professor](https://github.com/jlsilva01/spark-delta-minio-sqlserver)
- [Delta Lake — documentação oficial](https://docs.delta.io)
- [MinIO — documentação oficial](https://min.io/docs)
- [Apache Spark — documentação oficial](https://spark.apache.org/docs/latest)
