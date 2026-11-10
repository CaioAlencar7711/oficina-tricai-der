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
    mantida_em_estoque BOOLEAN NOT NULL DEFAULT FALSE
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
        REFERENCES ORDEM_SERVICO(id_os)
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

-- Limitar o parcelamento de 1 a 4 vezes
ALTER TABLE PAGAMENTO
ADD CONSTRAINT chk_numero_parcelas
CHECK (numero_parcelas BETWEEN 1 AND 4);
