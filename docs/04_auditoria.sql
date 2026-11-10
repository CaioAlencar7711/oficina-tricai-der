
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
