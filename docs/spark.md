# ⚡ Apache Spark (PySpark)

## O que é o Apache Spark?

Apache Spark é um framework de processamento de dados distribuído, open-source, projetado para ser rápido e de uso geral. Ele processa grandes volumes de dados em memória, sendo muito mais rápido que soluções baseadas em disco como o MapReduce.

## Principais conceitos

### SparkSession
Ponto de entrada para qualquer aplicação Spark. É através dela que criamos DataFrames e executamos SQL.

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("MeuApp") \
    .getOrCreate()
```

### DataFrame
Coleção distribuída de dados organizada em colunas, similar a uma tabela SQL.

```python
df = spark.read.csv("arquivo.csv", header=True, inferSchema=True)
df.show()
df.printSchema()
```

### Spark SQL
Permite executar queries SQL diretamente sobre DataFrames e tabelas registradas.

```python
spark.sql("SELECT * FROM minha_tabela WHERE valor > 100").show()
```

## Configuração neste projeto

Neste projeto, a SparkSession é configurada com suporte a:

- **Delta Lake** — extensão para tabelas ACID
- **Hadoop AWS (S3A)** — conector para o MinIO
- **PostgreSQL JDBC** — driver para leitura do banco de dados

```python
spark = (
    SparkSession.builder
    .appName("Trabalho2-SparkMinIO")
    .config("spark.jars.packages",
            "io.delta:delta-spark_2.12:3.2.0,"
            "org.apache.hadoop:hadoop-aws:3.3.4,"
            "com.amazonaws:aws-java-sdk-bundle:1.12.262,"
            "org.postgresql:postgresql:42.7.3")
    .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension")
    .config("spark.sql.catalog.spark_catalog",
            "org.apache.spark.sql.delta.catalog.DeltaCatalog")
    .config("spark.hadoop.fs.s3a.endpoint",          "http://localhost:9000")
    .config("spark.hadoop.fs.s3a.access.key",        "minioadmin")
    .config("spark.hadoop.fs.s3a.secret.key",        "minioadmin123")
    .config("spark.hadoop.fs.s3a.path.style.access", "true")
    .getOrCreate()
)
```

## Leitura via JDBC (PostgreSQL)

```python
pg_props = {
    "user":     "admin",
    "password": "admin123",
    "driver":   "org.postgresql.Driver"
}

df = spark.read.jdbc(
    url="jdbc:postgresql://localhost:5432/loja_db",
    table="vendas",
    properties=pg_props
)
df.show()
```
