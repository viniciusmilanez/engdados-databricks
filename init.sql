-- ============================================================
-- Script de inicialização do banco de dados loja_db
-- ============================================================

-- Tabela de produtos
CREATE TABLE IF NOT EXISTS produtos (
    id_produto SERIAL PRIMARY KEY,
    nome       VARCHAR(100) NOT NULL,
    categoria  VARCHAR(50),
    preco      NUMERIC(10, 2),
    estoque    INTEGER
);

-- Tabela de clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome       VARCHAR(100) NOT NULL,
    email      VARCHAR(100),
    cidade     VARCHAR(50),
    estado     VARCHAR(2)
);

-- Tabela de vendas
CREATE TABLE IF NOT EXISTS vendas (
    id_venda       SERIAL PRIMARY KEY,
    id_cliente     INTEGER REFERENCES clientes(id_cliente),
    id_produto     INTEGER REFERENCES produtos(id_produto),
    quantidade     INTEGER,
    valor_unitario NUMERIC(10, 2),
    data_venda     DATE
);

-- ============================================================
-- Dados de exemplo
-- ============================================================

INSERT INTO produtos (nome, categoria, preco, estoque) VALUES
('Notebook Dell',      'Informática',   3500.00, 15),
('Mouse Logitech',     'Informática',    120.00, 80),
('Teclado Mecânico',   'Informática',    800.00, 30),
('Monitor LG 24"',     'Informática',   1500.00, 20),
('iPhone 15',          'Celular',        5500.00,  8),
('Fone Bluetooth',     'Acessório',      250.00, 50),
('SSD 1TB',            'Informática',    450.00, 40),
('Webcam HD',          'Informática',    200.00, 25);

INSERT INTO clientes (nome, email, cidade, estado) VALUES
('Ana Silva',     'ana@email.com',    'Florianópolis', 'SC'),
('Bruno Costa',   'bruno@email.com',  'São Paulo',     'SP'),
('Carla Mendes',  'carla@email.com',  'Curitiba',      'PR'),
('Diego Lima',    'diego@email.com',  'Porto Alegre',  'RS'),
('Eva Souza',     'eva@email.com',    'Belo Horizonte','MG');

INSERT INTO vendas (id_cliente, id_produto, quantidade, valor_unitario, data_venda) VALUES
(1, 1, 1, 3500.00, '2024-01-15'),
(2, 2, 3,  120.00, '2024-01-16'),
(3, 3, 1,  800.00, '2024-01-17'),
(1, 4, 2, 1500.00, '2024-01-18'),
(4, 5, 1, 5500.00, '2024-01-19'),
(5, 6, 4,  250.00, '2024-01-20'),
(2, 7, 2,  450.00, '2024-02-01'),
(3, 8, 1,  200.00, '2024-02-02'),
(4, 1, 1, 3500.00, '2024-02-10'),
(5, 2, 2,  120.00, '2024-02-15');
