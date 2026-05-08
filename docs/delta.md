# 🏔️ Delta Lake

## O que é Delta Lake?

Delta Lake é uma camada de armazenamento open-source que traz confiabilidade para Data Lakes. Ele adiciona suporte a transações **ACID**, versionamento de dados (*Time Travel*) e operações DML (`INSERT`, `UPDATE`, `DELETE`) sobre arquivos Parquet no S3/MinIO.

## Conversão: landing-zone → bronze

```python
for tabela in ["produtos", "clientes", "vendas"]:
    df = spark.read \
        .option("header", "true") \
        .option("inferSchema", "true") \
        .csv(f"s3a://landing-zone/{tabela}")

    df.write \
        .format("delta") \
        .mode("overwrite") \
        .save(f"s3a://bronze/{tabela}")

    spark.sql(f"""
        CREATE TABLE IF NOT EXISTS {tabela}_bronze
        USING DELTA
        LOCATION 's3a://bronze/{tabela}'
    """)
```

## Operações DML

### INSERT

```sql
INSERT INTO vendas_bronze VALUES
(100, 1, 3, 2, 120.00, '2024-03-01'),
(101, 2, 5, 1, 800.00, '2024-03-02')
```

### UPDATE

```sql
UPDATE vendas_bronze
SET valor_unitario = 999.99
WHERE id_venda = 100
```

### DELETE

```sql
DELETE FROM vendas_bronze
WHERE id_venda = 101
```

## Time Travel

O Delta Lake registra cada operação como uma nova versão da tabela.

```python
# Visualizar histórico
spark.sql("DESCRIBE HISTORY vendas_bronze").show()

# Consultar versão 0 (estado inicial)
spark.read \
    .format("delta") \
    .option("versionAsOf", 0) \
    .load("s3a://bronze/vendas") \
    .show()
```

## Tabelas Gerenciadas vs Não Gerenciadas

| Aspecto | Gerenciada | Não Gerenciada (External) |
|---|---|---|
| Localização dos dados | Gerenciada pelo Spark | Definida pelo usuário |
| `DROP TABLE` | Remove dados e metadados | Remove apenas metadados |
| Dados persistem sem Spark? | Não | **Sim** |
| Uso típico | Dev / testes | **Data Lake em produção** |

!!! warning "Tabelas neste projeto"
    Usamos tabelas **não gerenciadas** (external), registradas com `LOCATION 's3a://bronze/...'`. Os dados ficam no MinIO e sobrevivem a um `DROP TABLE`.

## Estrutura de arquivos no MinIO (bronze)

```
bronze/
└── vendas/
    ├── _delta_log/
    │   ├── 00000000000000000000.json  ← versão 0 (overwrite inicial)
    │   ├── 00000000000000000001.json  ← versão 1 (INSERT)
    │   ├── 00000000000000000002.json  ← versão 2 (UPDATE)
    │   └── 00000000000000000003.json  ← versão 3 (DELETE)
    └── part-00000-*.parquet
```
