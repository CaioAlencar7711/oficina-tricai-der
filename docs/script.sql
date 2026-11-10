-- ==========================================
-- OFICINA TRICAI - SCRIPT SQL COMPLETO
-- ENTREGA 2 - BANCO DE DADOS
-- ==========================================

-- 1. CRIACAO DO BANCO E DAS TABELAS
CREATE DATABASE IF NOT EXISTS oficina_tricai;
USE oficina_tricai;

CREATE TABLE CLIENTE (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf_cnpj VARCHAR(18) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100),
    logradouro VARCHAR(150),
    numero VARCHAR(10),
    bairro VARCHAR(100),
    cep VARCHAR(9)
);
CREATE TABLE VEICULO (
    id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10) NOT NULL UNIQUE,
    modelo VARCHAR(100) NOT NULL,
    ano INT,
    id_cliente INT NOT NULL,

    FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE(id_cliente)
);
CREATE TABLE MECANICO (
    id_mecanico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(100),
    telefone VARCHAR(20)
);
CREATE TABLE SERVICO (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(200) NOT NULL,
    valor_padrao DECIMAL(10,2)
);
CREATE TABLE PECA (
    id_peca INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    quantidade_estoque INT NOT NULL DEFAULT 0,
    estoque_minimo INT NOT NULL DEFAULT 0,
    valor_venda DECIMAL(10,2),
    mantida_em_estoque BOOLEAN NOT NULL DEFAULT FALSE,

CONSTRAINT chk_estoque_nao_negativo
CHECK (quantidade_estoque >= 0),

CONSTRAINT chk_estoque_minimo_nao_negativo
CHECK (estoque_minimo >= 0)
);
CREATE TABLE FORNECEDOR (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cnpj VARCHAR(18) NOT NULL UNIQUE,
    telefone VARCHAR(20)
);
CREATE TABLE ORDEM_SERVICO (
    id_os INT AUTO_INCREMENT PRIMARY KEY,
    data_abertura DATE NOT NULL,
    data_fechamento DATE,
    status VARCHAR(30) NOT NULL,
    descricao_problema TEXT,
    valor_total DECIMAL(10,2),
    numero_nota_fiscal VARCHAR(50) UNIQUE,
    id_veiculo INT NOT NULL,
    id_mecanico INT NOT NULL,
    id_os_original INT UNIQUE,

    FOREIGN KEY (id_veiculo)
        REFERENCES VEICULO(id_veiculo),

    FOREIGN KEY (id_mecanico)
        REFERENCES MECANICO(id_mecanico),

    FOREIGN KEY (id_os_original)
        REFERENCES ORDEM_SERVICO(id_os)
);
CREATE TABLE AGENDAMENTO (
    id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    horario TIME NOT NULL,
    status VARCHAR(30) NOT NULL,
    id_veiculo INT NOT NULL,
    id_mecanico INT NOT NULL,
    id_os INT UNIQUE,

    FOREIGN KEY (id_veiculo)
        REFERENCES VEICULO(id_veiculo),

    FOREIGN KEY (id_mecanico)
        REFERENCES MECANICO(id_mecanico),

    FOREIGN KEY (id_os)
        REFERENCES ORDEM_SERVICO(id_os),

    CONSTRAINT uq_agendamento_mecanico_horario
        UNIQUE (id_mecanico, data, horario)
);
CREATE TABLE PAGAMENTO (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    valor DECIMAL(10,2) NOT NULL,
    numero_parcelas INT DEFAULT NULL,
    data_pagamento DATE DEFAULT NULL,
    forma_pagamento VARCHAR(30) NOT NULL,
    id_os INT NOT NULL UNIQUE,

    FOREIGN KEY (id_os)
        REFERENCES ORDEM_SERVICO(id_os),

    CONSTRAINT chk_forma_pagamento
    CHECK (
        LOWER(TRIM(forma_pagamento)) IN (
            'pix',
            'dinheiro',
            'debito',
            'débito',
            'credito',
            'crédito',
            'cartao de credito',
            'cartão de crédito'
        )
    ),

    CONSTRAINT chk_numero_parcelas
    CHECK (
        (
            LOWER(TRIM(forma_pagamento)) IN (
                'credito',
                'crédito',
                'cartao de credito',
                'cartão de crédito'
            )
            AND numero_parcelas IS NOT NULL
            AND numero_parcelas BETWEEN 1 AND 4
        )
        OR
        (
            LOWER(TRIM(forma_pagamento)) NOT IN (
                'credito',
                'crédito',
                'cartao de credito',
                'cartão de crédito'
            )
            AND numero_parcelas IS NULL
        )
    )
);
CREATE TABLE COMPRA (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    data_compra DATE NOT NULL,
    data_recebimento DATE,
    valor_total DECIMAL(10,2),
    id_fornecedor INT NOT NULL,

    FOREIGN KEY (id_fornecedor)
        REFERENCES FORNECEDOR(id_fornecedor)
);
CREATE TABLE UTILIZA (
    id_os INT NOT NULL,
    id_peca INT NOT NULL,
  quantidade INT NOT NULL,
 valor_unitario DECIMAL(10,2) NOT NULL,
  
CONSTRAINT chk_utiliza_quantidade_positiva
CHECK (quantidade > 0),

    -- Chave primária composta
    PRIMARY KEY (id_os, id_peca),

    -- Relacionamento com ORDEM_SERVICO
    FOREIGN KEY (id_os)
        REFERENCES ORDEM_SERVICO(id_os),

    -- Relacionamento com PECA
    FOREIGN KEY (id_peca)
        REFERENCES PECA(id_peca)
);
CREATE TABLE REALIZA (
    id_os INT NOT NULL,
    id_servico INT NOT NULL,
    valor_cobrado DECIMAL(10,2) NOT NULL,
    -- Chave primária composta
    PRIMARY KEY (id_os, id_servico),

    -- Relacionamento com a ordem de serviço
    FOREIGN KEY (id_os)
        REFERENCES ORDEM_SERVICO(id_os),

    -- Relacionamento com o serviço
    FOREIGN KEY (id_servico)
        REFERENCES SERVICO(id_servico)
);
CREATE TABLE CONTEM (
    id_compra INT NOT NULL,
    id_peca INT NOT NULL,
    quantidade INT NOT NULL,
    CONSTRAINT chk_contem_quantidade_positiva
CHECK (quantidade > 0),
    valor_custo DECIMAL(10,2) NOT NULL,

    -- Chave primária composta
    PRIMARY KEY (id_compra, id_peca),

    -- Relacionamento com COMPRA
    FOREIGN KEY (id_compra)
        REFERENCES COMPRA(id_compra),

    -- Relacionamento com PECA
    FOREIGN KEY (id_peca)
        REFERENCES PECA(id_peca)
);


-- 2. INSERCAO DOS DADOS

-- =========================================
-- OFICINA TRICAI
-- 02 - MASSA DE DADOS
-- =========================================

USE oficina_tricai;

-- =========================================
-- 1. CLIENTES
-- =========================================

INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (1, 'Carlos Oliveira', '00000000000', '11999990000', 'cliente.tricai.001@hotmail.com', 'Rua das Flores', '150', 'Centro', '00000-000');
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (2, 'Mariana Costa', '00000000001', '11990000001', 'cliente.tricai.002@outlook.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (3, 'Fernando Lima', '00000000002', '11990000002', 'cliente.tricai.003@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (4, 'Juliana Martins', '00000000003', '11990000003', 'cliente.tricai.004@hotmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (5, 'Ricardo Almeida', '00000000004', '11990000004', 'cliente.tricai.005@outlook.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (6, 'Patricia Souza', '00000000005', '11990000005', 'cliente.tricai.006@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (7, 'Eduardo Ferreira', '00000000006', '11990000006', 'cliente.tricai.007@hotmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (8, 'Camila Rodrigues', '00000000007', '11990000007', 'cliente.tricai.008@outlook.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (9, 'Roberto Santos', '00000000008', '11990000008', 'cliente.tricai.009@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (10, 'Ana Beatriz Oliveira', '00000000009', '11990000009', 'cliente.tricai.010@hotmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (11, 'Marcelo Ribeiro', 'TESTE0000000000011', '11990000011', 'cliente.tricai.011@outlook.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (12, 'André Luiz Carvalho', 'TESTE0000000000012', '11990000012', 'cliente.tricai.012@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (13, 'Fernanda Pereira', 'TESTE0000000000013', '11990000013', 'cliente.tricai.013@hotmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (14, 'Lucas Henrique Martins', 'TESTE0000000000014', '11990000014', 'cliente.tricai.014@outlook.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (15, 'Renata Fernandes', 'TESTE0000000000015', '11990000015', 'cliente.tricai.015@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (16, 'Gustavo Moreira', 'TESTE0000000000016', '11990000016', 'cliente.tricai.016@hotmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (17, 'Daniela Rocha', 'TESTE0000000000017', '11990000017', 'cliente.tricai.017@outlook.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (18, 'Paulo Henrique Dias', 'TESTE0000000000018', '11990000018', 'cliente.tricai.018@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (19, 'Vanessa Almeida', 'TESTE0000000000019', '11990000019', 'cliente.tricai.019@hotmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (20, 'Bruno Teixeira', 'TESTE0000000000020', '11990000020', 'cliente.tricai.020@outlook.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (21, 'Felipe Augusto Nunes', 'TESTE0000000000021', '11990000021', 'cliente.tricai.021@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (22, 'Carolina Mendes', 'TESTE0000000000022', '11990000022', 'cliente.tricai.022@hotmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (23, 'Rodrigo Barbosa', 'TESTE0000000000023', '11990000023', 'cliente.tricai.023@outlook.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (24, 'Aline Cristina Lopes', 'TESTE0000000000024', '11990000024', 'cliente.tricai.024@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (25, 'Thiago Oliveira', 'TESTE0000000000025', '11990000025', 'cliente.tricai.025@hotmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (26, 'Priscila Cardoso', 'TESTE0000000000026', '11990000026', 'cliente.tricai.026@outlook.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (27, 'Rafael Monteiro', 'TESTE0000000000027', '11990000027', 'cliente.tricai.027@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (28, 'Beatriz Gonçalves', 'TESTE0000000000028', '11990000028', 'cliente.tricai.028@hotmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (29, 'Leonardo Batista', 'TESTE0000000000029', '11990000029', 'cliente.tricai.029@outlook.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (30, 'Tatiane Ribeiro', 'TESTE0000000000030', '11990000030', 'cliente.tricai.030@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (31, 'Diego Fernandes', 'FICTICIO-000031', '11984527316', 'diego.fernandes31@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (32, 'Mariana Ribeiro', 'FICTICIO-000032', '11976318425', 'mariana.ribeiro32@hotmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (33, 'Alexandre Moreira', 'FICTICIO-000033', '11992468137', 'alexandre.moreira33@outlook.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (34, 'Cristiane Martins', 'FICTICIO-000034', '11985639214', 'cristiane.martins34@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (35, 'Vinicius Carvalho', 'FICTICIO-000035', '11973528146', 'vinicius.carvalho35@hotmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (36, 'Patricia Nascimento', 'FICTICIO-000036', '11991846325', 'patricia.nascimento36@outlook.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (37, 'Eduardo Henrique Costa', 'FICTICIO-000037', '11986472513', 'eduardo.costa37@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (38, 'Larissa Monteiro', 'FICTICIO-000038', '11978253641', 'larissa.monteiro38@hotmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (39, 'Fabio Rodrigues', 'FICTICIO-000039', '11993614827', 'fabio.rodrigues39@outlook.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (40, 'Juliana Ferreira', 'FICTICIO-000040', '11987521463', 'juliana.ferreira40@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (41, 'Gabriel Henrique Souza', 'FICTICIO-000041', '11974638251', 'gabriel.souza41@hotmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (42, 'Amanda Cristina Lima', 'TESTE0000000000031', '11990000031', 'cliente.tricai.042@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (43, 'Ricardo Fernandes', 'TESTE0000000000032', '11990000032', 'cliente.tricai.043@hotmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (44, 'Camila Nascimento', 'TESTE0000000000033', '11990000033', 'cliente.tricai.044@outlook.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (45, 'Marcelo Augusto Pereira', 'TESTE0000000000034', '11990000034', 'cliente.tricai.045@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (46, 'Isabela Rodrigues', 'TESTE0000000000035', '11990000035', 'cliente.tricai.046@hotmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (47, 'Anderson Oliveira', 'TESTE0000000000036', '11990000036', 'cliente.tricai.047@outlook.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (48, 'Leticia Barbosa', 'TESTE0000000000037', '11990000037', 'cliente.tricai.048@gmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (49, 'Fernando Henrique Alves', 'TESTE0000000000038', '11990000038', 'cliente.tricai.049@hotmail.com', NULL, NULL, NULL, NULL);
INSERT INTO CLIENTE (id_cliente, nome, cpf_cnpj, telefone, email, logradouro, numero, bairro, cep) VALUES (50, 'Renata Cristina Dias', 'TESTE0000000000039', '11990000039', 'cliente.tricai.050@outlook.com', NULL, NULL, NULL, NULL);


-- =========================================
-- 2. VEICULOS
-- =========================================

INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES (1, 'TST1A23', 'Mercedes-Benz Sprinter 415 CDI', 2020, 1);
INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES (2, 'ABC1D23', 'Mercedes-Benz Sprinter 415 CDI', 2019, 2);
INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES (3, 'DEF2G34', 'Mercedes-Benz Sprinter 416 CDI', 2021, 3);
INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES (4, 'GHI3J45', 'Mercedes-Benz Sprinter 313 CDI', 2018, 4);
INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES (5, 'JKL4M56', 'Mercedes-Benz Sprinter 517 CDI', 2022, 5);
INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES (6, 'NOP5Q67', 'Mercedes-Benz Sprinter 415 CDI', 2020, 6);
INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES (7, 'FKA2B31', 'Mercedes-Benz Sprinter 415 CDI', 2018, 7);
INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES (8, 'GHT4C52', 'Mercedes-Benz Sprinter 416 CDI', 2021, 8);
INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES (9, 'EPR7D84', 'Mercedes-Benz Sprinter 313 CDI', 2017, 9);
INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES (10, 'JLM3E26', 'Mercedes-Benz Sprinter 517 CDI', 2023, 10);
INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES (11, 'DVS5F91', 'Mercedes-Benz Sprinter 415 CDI', 2020, 11);
INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES (12, 'HNR8G43', 'Mercedes-Benz Sprinter 416 CDI', 2022, 12);
INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES (13, 'BKT1H65', 'Mercedes-Benz Sprinter 313 CDI', 2016, 13);
INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES (14, 'MPC6J27', 'Mercedes-Benz Sprinter 415 CDI', 2019, 14);
INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES (15, 'RFL9K38', 'Mercedes-Benz Sprinter 517 CDI', 2024, 7);
INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES (16, 'SNA2L74', 'Mercedes-Benz Sprinter 416 CDI', 2021, 8);


-- =========================================
-- 3. MECANICOS
-- =========================================

INSERT INTO MECANICO (id_mecanico, nome, especialidade, telefone) VALUES (1, 'Roberto Almeida', 'Manutenção de vans Mercedes-Benz', '11988887777');


-- =========================================
-- 4. SERVICOS
-- =========================================

INSERT INTO SERVICO (id_servico, descricao, valor_padrao) VALUES (1, 'Troca de óleo do motor', 180.00);
INSERT INTO SERVICO (id_servico, descricao, valor_padrao) VALUES (2, 'Diagnóstico do sistema de partida', 120.00);
INSERT INTO SERVICO (id_servico, descricao, valor_padrao) VALUES (3, 'Substituição de pastilhas de freio', 250.00);
INSERT INTO SERVICO (id_servico, descricao, valor_padrao) VALUES (4, 'Revisão preventiva', 480.00);
INSERT INTO SERVICO (id_servico, descricao, valor_padrao) VALUES (5, 'Diagnóstico da suspensão', 150.00);
INSERT INTO SERVICO (id_servico, descricao, valor_padrao) VALUES (6, 'Manutenção do sistema de arrefecimento', 300.00);


-- =========================================
-- 5. PECAS
-- =========================================

INSERT INTO PECA (id_peca, nome, quantidade_estoque, estoque_minimo, valor_venda, mantida_em_estoque) VALUES (1, 'Filtro de óleo Mercedes-Benz Sprinter', 9, 3, 65.00, 1);
INSERT INTO PECA (id_peca, nome, quantidade_estoque, estoque_minimo, valor_venda, mantida_em_estoque) VALUES (2, 'Pastilha de freio Sprinter', 1, 5, 100.00, 1);
INSERT INTO PECA (id_peca, nome, quantidade_estoque, estoque_minimo, valor_venda, mantida_em_estoque) VALUES (3, 'Filtro de ar Sprinter', 7, 3, 80.00, 1);
INSERT INTO PECA (id_peca, nome, quantidade_estoque, estoque_minimo, valor_venda, mantida_em_estoque) VALUES (4, 'Correia do alternador Sprinter', 1, 2, 150.00, 1);
INSERT INTO PECA (id_peca, nome, quantidade_estoque, estoque_minimo, valor_venda, mantida_em_estoque) VALUES (5, 'Aditivo para radiador', 12, 4, 35.00, 1);
INSERT INTO PECA (id_peca, nome, quantidade_estoque, estoque_minimo, valor_venda, mantida_em_estoque) VALUES (6, 'Sensor de temperatura Sprinter', 0, 2, 120.00, 0);

-- =========================================
-- 6. FORNECEDORES
-- =========================================

INSERT INTO FORNECEDOR (id_fornecedor, nome, cnpj, telefone) VALUES (1, 'Distribuidora Exemplo de Autopeças', '00000000000001', '11977776666');

-- =========================================
-- 7. ORDENS DE SERVICO
-- =========================================

INSERT INTO ORDEM_SERVICO (id_os, data_abertura, data_fechamento, status, descricao_problema, valor_total, numero_nota_fiscal, id_veiculo, id_mecanico, id_os_original) VALUES (1, '2026-11-09', '2026-11-09', 'Concluída', 'Cliente solicita troca de óleo do motor', 245.00, 'NF-TESTE-001', 1, 1, NULL);
INSERT INTO ORDEM_SERVICO (id_os, data_abertura, data_fechamento, status, descricao_problema, valor_total, numero_nota_fiscal, id_veiculo, id_mecanico, id_os_original) VALUES (2, '2026-11-09', NULL, 'Em andamento', 'Cliente relata dificuldade na partida do motor', NULL, NULL, 2, 1, NULL);
INSERT INTO ORDEM_SERVICO (id_os, data_abertura, data_fechamento, status, descricao_problema, valor_total, numero_nota_fiscal, id_veiculo, id_mecanico, id_os_original) VALUES (3, '2026-10-05', '2026-10-06', 'Concluída', 'Substituição das pastilhas de freio', 350.00, NULL, 3, 1, NULL);
INSERT INTO ORDEM_SERVICO (id_os, data_abertura, data_fechamento, status, descricao_problema, valor_total, numero_nota_fiscal, id_veiculo, id_mecanico, id_os_original) VALUES (4, '2026-10-15', '2026-10-16', 'Concluída', 'Revisão preventiva do veículo', 560.00, NULL, 4, 1, NULL);
INSERT INTO ORDEM_SERVICO (id_os, data_abertura, data_fechamento, status, descricao_problema, valor_total, numero_nota_fiscal, id_veiculo, id_mecanico, id_os_original) VALUES (5, '2026-11-03', NULL, 'Em andamento', 'Ruído na suspensão dianteira', NULL, NULL, 5, 1, NULL);
INSERT INTO ORDEM_SERVICO (id_os, data_abertura, data_fechamento, status, descricao_problema, valor_total, numero_nota_fiscal, id_veiculo, id_mecanico, id_os_original) VALUES (6, '2026-11-07', NULL, 'Aguardando peças', 'Problema no sistema de arrefecimento', NULL, NULL, 6, 1, NULL);
INSERT INTO ORDEM_SERVICO (id_os, data_abertura, data_fechamento, status, descricao_problema, valor_total, numero_nota_fiscal, id_veiculo, id_mecanico, id_os_original) VALUES (8, '2026-09-14', '2026-09-15', 'Concluída', 'Cliente relata dificuldade na partida do veículo.', 120.00, NULL, 7, 1, NULL);
INSERT INTO ORDEM_SERVICO (id_os, data_abertura, data_fechamento, status, descricao_problema, valor_total, numero_nota_fiscal, id_veiculo, id_mecanico, id_os_original) VALUES (9, '2026-10-21', '2026-10-22', 'Concluída', 'Cliente solicita revisão preventiva antes de viagem.', 480.00, NULL, 8, 1, NULL);
INSERT INTO ORDEM_SERVICO (id_os, data_abertura, data_fechamento, status, descricao_problema, valor_total, numero_nota_fiscal, id_veiculo, id_mecanico, id_os_original) VALUES (10, '2026-11-09', NULL, 'Em andamento', 'Cliente relata ruídos na suspensão dianteira.', NULL, NULL, 9, 1, NULL);
INSERT INTO ORDEM_SERVICO (id_os, data_abertura, data_fechamento, status, descricao_problema, valor_total, numero_nota_fiscal, id_veiculo, id_mecanico, id_os_original) VALUES (7, '2026-11-16', NULL, 'Em andamento', 'Retorno para verificar vazamento após troca de óleo', NULL, NULL, 1, 1, 1);


-- =========================================
-- 8. SERVICOS REALIZADOS
-- =========================================

INSERT INTO REALIZA (id_os, id_servico, valor_cobrado) VALUES (1, 1, 180.00);
INSERT INTO REALIZA (id_os, id_servico, valor_cobrado) VALUES (2, 2, 120.00);
INSERT INTO REALIZA (id_os, id_servico, valor_cobrado) VALUES (3, 3, 250.00);
INSERT INTO REALIZA (id_os, id_servico, valor_cobrado) VALUES (4, 4, 480.00);
INSERT INTO REALIZA (id_os, id_servico, valor_cobrado) VALUES (5, 5, 150.00);
INSERT INTO REALIZA (id_os, id_servico, valor_cobrado) VALUES (6, 6, 300.00);
INSERT INTO REALIZA (id_os, id_servico, valor_cobrado) VALUES (8, 2, 120.00);
INSERT INTO REALIZA (id_os, id_servico, valor_cobrado) VALUES (9, 4, 480.00);
INSERT INTO REALIZA (id_os, id_servico, valor_cobrado) VALUES (10, 5, 150.00);



-- =========================================
-- 9. PECAS UTILIZADAS
-- =========================================

INSERT INTO UTILIZA (id_os, id_peca, quantidade, valor_unitario) VALUES (1, 1, 1, 65.00);
INSERT INTO UTILIZA (id_os, id_peca, quantidade, valor_unitario) VALUES (3, 2, 1, 100.00);
INSERT INTO UTILIZA (id_os, id_peca, quantidade, valor_unitario) VALUES (4, 3, 1, 80.00);


-- =========================================
-- 10. COMPRAS
-- =========================================

INSERT INTO COMPRA (id_compra, data_compra, data_recebimento, valor_total, id_fornecedor) VALUES (1, '2026-11-05', '2026-11-07', 300.00, 1);


-- =========================================
-- 11. PECAS COMPRADAS
-- =========================================

INSERT INTO CONTEM (id_compra, id_peca, quantidade, valor_custo) VALUES (1, 2, 2, 100.00);
INSERT INTO CONTEM (id_compra, id_peca, quantidade, valor_custo) VALUES (1, 3, 2, 50.00);

-- =========================================
-- 12. AGENDAMENTOS
-- =========================================

INSERT INTO AGENDAMENTO (id_agendamento, data, horario, status, id_veiculo, id_mecanico, id_os) VALUES (1, '2026-11-09', '08:00:00', 'Realizado', 1, 1, 1);
INSERT INTO AGENDAMENTO (id_agendamento, data, horario, status, id_veiculo, id_mecanico, id_os) VALUES (2, '2026-11-12', '09:30:00', 'Agendado', 3, 1, NULL);
INSERT INTO AGENDAMENTO (id_agendamento, data, horario, status, id_veiculo, id_mecanico, id_os) VALUES (3, '2026-11-13', '14:00:00', 'Cancelado', 4, 1, NULL);


-- =========================================
-- 13. PAGAMENTOS
-- =========================================



INSERT INTO PAGAMENTO
(id_pagamento, valor, numero_parcelas, data_pagamento, forma_pagamento, id_os)
VALUES
(1, 245.00, NULL, '2026-11-09', 'PIX', 1);

INSERT INTO PAGAMENTO
(id_pagamento, valor, numero_parcelas, data_pagamento, forma_pagamento, id_os)
VALUES
(2, 120.00, NULL, '2026-09-15', 'PIX', 8);

INSERT INTO PAGAMENTO
(id_pagamento, valor, numero_parcelas, data_pagamento, forma_pagamento, id_os)
VALUES
(3, 480.00, 3, '2026-10-22', 'Cartão de crédito', 9);


-- Observação:
-- As quantidades representam valores fictícios de estoque
-- em uma data de referência.
-- Os registros de compras são históricos e não atualizam
-- automaticamente a quantidade disponível em PECA.



-- 3. CONSULTAS SQL

-- =============================================
-- OFICINA MECANICA ALEXANDRE TRICAI
-- 03 - CONSULTAS OPERACIONAIS E GERENCIAIS
-- Banco de dados: oficina_tricai
-- SGBD: MySQL 8
-- =============================================

USE oficina_tricai;


-- =============================================
-- CONSULTAS OPERACIONAIS
-- =============================================

-- O01 - LISTAGEM DE CLIENTES
-- Pergunta: Quais clientes estão cadastrados?

SELECT
    id_cliente,
    nome,
    telefone,
    email
FROM CLIENTE
ORDER BY nome;


-- O02 - VEICULOS E SEUS PROPRIETARIOS
-- Pergunta: Quais veículos pertencem a cada cliente?

SELECT
    v.id_veiculo,
    v.placa,
    v.modelo,
    v.ano,
    c.nome AS proprietario
FROM VEICULO v
INNER JOIN CLIENTE c
    ON v.id_cliente = c.id_cliente
ORDER BY c.nome;


-- O03 - ORDENS DE SERVICO DETALHADAS
-- Pergunta: Quais são as ordens de serviço registradas?

SELECT
    os.id_os,
    c.nome AS cliente,
    v.placa,
    v.modelo,
    m.nome AS mecanico,
    os.data_abertura,
    os.status,
    os.valor_total
FROM ORDEM_SERVICO os
INNER JOIN VEICULO v
    ON os.id_veiculo = v.id_veiculo
INNER JOIN CLIENTE c
    ON v.id_cliente = c.id_cliente
INNER JOIN MECANICO m
    ON os.id_mecanico = m.id_mecanico
ORDER BY os.data_abertura DESC, os.id_os;


-- O04 - PAGAMENTOS POR FORMA DE PAGAMENTO
-- Pergunta: Quais formas de pagamento são mais utilizadas?

SELECT
    forma_pagamento,
    COUNT(*) AS quantidade_pagamentos,
    SUM(valor) AS valor_total
FROM PAGAMENTO
GROUP BY forma_pagamento
ORDER BY valor_total DESC;


-- O05 - AGENDAMENTOS DA OFICINA
-- Pergunta: Quais são os atendimentos agendados?

SELECT
    a.id_agendamento,
    a.data,
    a.horario,
    c.nome AS cliente,
    v.placa,
    m.nome AS mecanico,
    a.status
FROM AGENDAMENTO a
INNER JOIN VEICULO v
    ON a.id_veiculo = v.id_veiculo
INNER JOIN CLIENTE c
    ON v.id_cliente = c.id_cliente
INNER JOIN MECANICO m
    ON a.id_mecanico = m.id_mecanico
ORDER BY a.data, a.horario;


-- O06 - RETORNOS DE GARANTIA
-- Pergunta: Quais ordens de serviço são retornos?

SELECT
    original.id_os AS ordem_original,
    retorno.id_os AS ordem_retorno,
    c.nome AS cliente,
    v.placa,
    original.data_abertura AS data_servico_original,
    retorno.data_abertura AS data_retorno,
    retorno.descricao_problema AS motivo_retorno,
    retorno.status
FROM ORDEM_SERVICO retorno
INNER JOIN ORDEM_SERVICO original
    ON retorno.id_os_original = original.id_os
INNER JOIN VEICULO v
    ON retorno.id_veiculo = v.id_veiculo
INNER JOIN CLIENTE c
    ON v.id_cliente = c.id_cliente
ORDER BY retorno.data_abertura DESC;


-- O07 - SERVICOS MAIS REALIZADOS
-- Pergunta: Quais serviços são mais executados na oficina?

SELECT
    s.id_servico,
    s.descricao AS servico,
    COUNT(r.id_os) AS quantidade_realizada,
    SUM(r.valor_cobrado) AS valor_total
FROM REALIZA r
INNER JOIN SERVICO s
    ON r.id_servico = s.id_servico
GROUP BY
    s.id_servico,
    s.descricao
ORDER BY quantidade_realizada DESC, valor_total DESC;


-- =============================================
-- CONSULTAS GERENCIAIS
-- =============================================

-- G01 - PECAS ABAIXO DO ESTOQUE MINIMO
-- Pergunta: Quantas peças mantidas em estoque
-- estão abaixo da quantidade mínima?
-- KPI: Quantidade de peças abaixo do mínimo.

SELECT
    COUNT(*) AS quantidade_pecas_abaixo_minimo,
    GROUP_CONCAT(nome ORDER BY nome SEPARATOR ', ')
        AS pecas_identificadas
FROM PECA
WHERE mantida_em_estoque = TRUE
  AND quantidade_estoque < estoque_minimo;


-- G02 - HISTORICO DE OS POR VEICULO
-- Pergunta: Qual é o histórico de manutenção
-- de cada veículo?
-- KPI: Histórico de ordens de serviço por veículo.

SELECT
    v.id_veiculo,
    v.placa,
    v.modelo,
    c.nome AS cliente,
    os.id_os,
    os.data_abertura,
    os.status,
    os.valor_total,

    (
        SELECT GROUP_CONCAT(
            s.descricao ORDER BY s.descricao SEPARATOR ', '
        )
        FROM REALIZA r
        INNER JOIN SERVICO s
            ON r.id_servico = s.id_servico
        WHERE r.id_os = os.id_os
    ) AS servicos_realizados,

    (
        SELECT GROUP_CONCAT(
            p.nome ORDER BY p.nome SEPARATOR ', '
        )
        FROM UTILIZA u
        INNER JOIN PECA p
            ON u.id_peca = p.id_peca
        WHERE u.id_os = os.id_os
    ) AS pecas_utilizadas

FROM VEICULO v
INNER JOIN CLIENTE c
    ON v.id_cliente = c.id_cliente
LEFT JOIN ORDEM_SERVICO os
    ON v.id_veiculo = os.id_veiculo
ORDER BY v.placa, os.data_abertura DESC;


-- G03 - TEMPO MEDIO DE ATENDIMENTO
-- Pergunta: Quantos dias, em média, a oficina
-- leva para concluir uma ordem de serviço?
-- KPI: Média de dias entre abertura e fechamento,
-- agrupada por mês.

SELECT
    YEAR(data_abertura) AS ano,
    MONTH(data_abertura) AS mes,
    ROUND(
        AVG(DATEDIFF(data_fechamento, data_abertura)),
        2
    ) AS media_dias_atendimento
FROM ORDEM_SERVICO
WHERE data_fechamento IS NOT NULL
GROUP BY
    YEAR(data_abertura),
    MONTH(data_abertura)
ORDER BY ano, mes;


-- G04 - FATURAMENTO MENSAL
-- Pergunta: Quanto a oficina recebeu em pagamentos
-- a cada mês?
-- KPI: Soma dos pagamentos por mês.

SELECT
    YEAR(data_pagamento) AS ano,
    MONTH(data_pagamento) AS mes,
    COUNT(*) AS quantidade_pagamentos,
    SUM(valor) AS faturamento_mensal
FROM PAGAMENTO
GROUP BY
    YEAR(data_pagamento),
    MONTH(data_pagamento)
ORDER BY ano, mes;


-- G05 - TAXA DE RETORNO POR GARANTIA
-- Pergunta: Qual percentual das ordens de serviço
-- corresponde a retornos vinculados a uma OS original?
-- KPI: OS de retorno / total de OS x 100, por mês.

SELECT
    YEAR(data_abertura) AS ano,
    MONTH(data_abertura) AS mes,
    COUNT(*) AS total_ordens,
    SUM(
        CASE
            WHEN id_os_original IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS total_retornos,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN id_os_original IS NOT NULL THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS taxa_retorno_percentual
FROM ORDEM_SERVICO
GROUP BY
    YEAR(data_abertura),
    MONTH(data_abertura)
ORDER BY ano, mes;


-- G06 - AGENDAMENTOS POR MECANICO E SEMANA
-- Pergunta: Quantos agendamentos cada mecânico
-- possui por semana?
-- KPI: Quantidade de agendamentos por mecânico,
-- agrupada por semana.

SELECT
    m.id_mecanico,
    m.nome AS mecanico,
    YEARWEEK(a.data, 3) AS ano_semana,
    COUNT(*) AS quantidade_agendamentos
FROM AGENDAMENTO a
INNER JOIN MECANICO m
    ON a.id_mecanico = m.id_mecanico
GROUP BY
    m.id_mecanico,
    m.nome,
    YEARWEEK(a.data, 3)
ORDER BY ano_semana, quantidade_agendamentos DESC;


-- G07 - GASTOS COM COMPRAS POR FORNECEDOR
-- Pergunta: Quanto a oficina gastou com compras
-- de cada fornecedor por mês?
-- KPI: Soma do valor_total das compras,
-- agrupada por fornecedor e mês.

SELECT
    f.id_fornecedor,
    f.nome AS fornecedor,
    YEAR(c.data_compra) AS ano,
    MONTH(c.data_compra) AS mes,
    SUM(c.valor_total) AS total_gasto
FROM COMPRA c
INNER JOIN FORNECEDOR f
    ON c.id_fornecedor = f.id_fornecedor
GROUP BY
    f.id_fornecedor,
    f.nome,
    YEAR(c.data_compra),
    MONTH(c.data_compra)
ORDER BY ano, mes, total_gasto DESC;


-- G08 - CLIENTES CADASTRADOS E VEICULOS POR CLIENTE
-- Pergunta: Quantos clientes estão cadastrados
-- e quantos veículos estão vinculados a cada um?
-- KPI: Total de clientes e quantidade de veículos
-- associados individualmente.

SELECT
    COUNT(*) OVER() AS total_clientes_cadastrados,
    clientes.id_cliente,
    clientes.nome,
    clientes.quantidade_veiculos
FROM (
    SELECT
        c.id_cliente,
        c.nome,
        COUNT(v.id_veiculo) AS quantidade_veiculos
    FROM CLIENTE c
    LEFT JOIN VEICULO v
        ON c.id_cliente = v.id_cliente
    GROUP BY
        c.id_cliente,
        c.nome
) AS clientes
ORDER BY clientes.nome;


-- =============================================
-- FIM DAS CONSULTAS
-- Total: 7 operacionais + 8 gerenciais
-- =============================================


-- =====================================================
-- EXEMPLOS DE UPDATE E DELETE
-- =====================================================

-- UPDATE: atualizar o telefone de um cliente
-- Utiliza uma transação para não alterar os dados definitivos.
START TRANSACTION;

UPDATE CLIENTE
SET telefone = '(11) 99999-9999'
WHERE id_cliente = 1;

-- Conferir a alteração
SELECT id_cliente, nome, telefone
FROM CLIENTE
WHERE id_cliente = 1;

ROLLBACK;


-- DELETE: demonstrar exclusão de um registro temporário
-- O registro é criado apenas para testar a operação.
START TRANSACTION;

INSERT INTO CLIENTE (nome, cpf_cnpj)
VALUES ('Cliente Teste Exclusao', '99999999999');

SET @id_cliente_teste = LAST_INSERT_ID();

DELETE FROM CLIENTE
WHERE id_cliente = @id_cliente_teste;

-- Conferir que o registro foi excluído
SELECT *
FROM CLIENTE
WHERE id_cliente = @id_cliente_teste;

ROLLBACK;



-- 4. AUDITORIAS

-- =====================================================
-- OFICINA MECANICA ALEXANDRE TRICAI
-- 04 - CONSULTAS DE AUDITORIA
-- Banco de dados: oficina_tricai

-- SGBD: MySQL 8
-- =====================================================

USE oficina_tricai;


-- =====================================================
-- A01 - COMPRAS SEM PECAS
-- Pergunta: Existem compras sem nenhuma peça registrada?
-- Regra de negocio: RN16.
-- =====================================================

SELECT
    c.id_compra,
    c.data_compra,
    c.id_fornecedor,
    c.valor_total
FROM COMPRA c
LEFT JOIN CONTEM ct
    ON c.id_compra = ct.id_compra
WHERE ct.id_compra IS NULL;


-- =====================================================
-- A02 - OS COM PAGAMENTO MAS SEM NOTA FISCAL
-- Pergunta: Existem OS com pagamento registrado,
-- mas sem numero de nota fiscal?
-- Regra de negocio: RN17.
-- =====================================================

SELECT
    os.id_os,
    os.numero_nota_fiscal,
    p.id_pagamento,
    p.valor AS valor_pago
FROM ORDEM_SERVICO os
INNER JOIN PAGAMENTO p
    ON os.id_os = p.id_os
WHERE os.numero_nota_fiscal IS NULL
   OR TRIM(os.numero_nota_fiscal) = '';


-- =====================================================
-- A03 - AGENDAMENTOS CONFLITANTES
-- Pergunta: Existe mecanico com dois agendamentos
-- ativos no mesmo dia e horario?
-- Regra de negocio: RN02.
-- =====================================================

SELECT
    id_mecanico,
    data,
    horario,
    COUNT(*) AS quantidade_agendamentos
FROM AGENDAMENTO
WHERE status NOT IN ('Cancelado', 'Não compareceu')
GROUP BY
    id_mecanico,
    data,
    horario
HAVING COUNT(*) > 1;


-- =====================================================
-- A04 - RETORNOS VINCULADOS A VEICULOS DIFERENTES
-- Pergunta: Existem retornos associados a um veiculo
-- diferente daquele da OS original?
-- Regra de negocio: RN19.
-- =====================================================

SELECT
    R.id_os AS id_os_retorno,
    R.id_os_original,
    R.id_veiculo AS veiculo_retorno,
    O.id_veiculo AS veiculo_original
FROM ORDEM_SERVICO R
INNER JOIN ORDEM_SERVICO O
    ON R.id_os_original = O.id_os
WHERE R.id_veiculo <> O.id_veiculo
   OR R.id_veiculo IS NULL
   OR O.id_veiculo IS NULL;


-- =====================================================
-- A05 - PAGAMENTOS COM PARCELAMENTO INCONSISTENTE
-- Pergunta: Existem pagamentos com parcelamento
-- fora das regras estabelecidas?
-- Regra de negocio: RN04.
-- =====================================================

SELECT
    id_pagamento,
    id_os,
    forma_pagamento,
    numero_parcelas
FROM PAGAMENTO
WHERE (
    LOWER(forma_pagamento) IN (
        'crédito',
        'credito',
        'cartão de crédito',
        'cartao de credito'
    )
    AND (
        numero_parcelas IS NULL
        OR numero_parcelas NOT BETWEEN 1 AND 4
    )
)
OR (
    LOWER(forma_pagamento) NOT IN (
        'crédito',
        'credito',
        'cartão de crédito',
        'cartao de credito'
    )
    AND numero_parcelas IS NOT NULL
);


-- =====================================================
-- A06 - PECAS COM ESTOQUE NEGATIVO
-- Pergunta: Existem pecas com quantidade em estoque
-- inferior a zero?
-- Regra de negocio: RN05.
-- =====================================================

SELECT
    id_peca,
    nome,
    quantidade_estoque
FROM PECA
WHERE quantidade_estoque < 0;


-- =====================================================
-- A07 - DIVERGENCIA NO VALOR TOTAL DA OS
-- Pergunta: O valor total das OS concluidas corresponde
-- a soma dos servicos e das pecas utilizadas?
-- Regra de negocio: RN08.
-- =====================================================

WITH total_servicos AS (
    SELECT
        id_os,
        SUM(valor_cobrado) AS valor_servicos
    FROM REALIZA
    GROUP BY id_os
),
total_pecas AS (
    SELECT
        id_os,
        SUM(quantidade * valor_unitario) AS valor_pecas
    FROM UTILIZA
    GROUP BY id_os
)
SELECT
    os.id_os,
    os.status,
    os.valor_total AS valor_registrado,
    COALESCE(ts.valor_servicos, 0)
        + COALESCE(tp.valor_pecas, 0) AS valor_calculado
FROM ORDEM_SERVICO os
LEFT JOIN total_servicos ts
    ON os.id_os = ts.id_os
LEFT JOIN total_pecas tp
    ON os.id_os = tp.id_os
WHERE os.status = 'Concluída'
  AND (
      os.valor_total IS NULL
      OR ABS(
          os.valor_total -
          (
              COALESCE(ts.valor_servicos, 0)
              + COALESCE(tp.valor_pecas, 0)
          )
      ) > 0.01
  );


-- =====================================================
-- FIM DAS AUDITORIAS
-- TOTAL: 7 CONSULTAS (A01 A A07)
-- =====================================================
