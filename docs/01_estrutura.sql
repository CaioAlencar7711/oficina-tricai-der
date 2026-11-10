-- OFICINA TRICAI - ESTRUTURA, RESTRICOES E CONSULTAS
-- Execute este arquivo para criar as tabelas. Depois execute 02_dados.sql.
-- Para visualizar resultados com dados, execute novamente apenas as secoes de consultas abaixo.

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

-- =====================================================
-- CONSULTAS OPERACIONAIS E GERENCIAIS (apos a massa)
-- =====================================================

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
-- AUDITORIAS (apos a massa)
-- =====================================================

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
