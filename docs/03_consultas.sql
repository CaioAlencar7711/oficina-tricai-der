
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
