# Levantamento — Oficina Tricai

## 1. Caracterização da organização
- **Nome:** Oficina Tricai
- **Tipo:** Oficina mecânica especializada em vans Mercedes-Benz
- **Tamanho:** Pequena
- **Pessoas:** 4 a 5
- **Atividades:** Diagnóstico e reparo de vans Mercedes (revisões, troca de pastilhas/freios, reparos gerais)
- **Endereço:** Av. Miguel Badra, 782 — Suzano/SP
- **Contato:** (11) 99778-1502
- **Evidências reunidas:** foto do galpão com vans de clientes em manutenção
- **Evidências ainda faltando:** foto da fachada/letreiro da própria Tricai, link do Google Maps, Instagram/site (se existir)

### Problema operacional identificado
A oficina não possui nenhum sistema. Cadastro de cliente só existe dentro da ordem de serviço (não há cadastro prévio nem histórico centralizado por cliente/veículo), agendamentos são combinados por WhatsApp/telefone sem registro único, e o controle de estoque de peças (ex.: pastilhas de freio) parece ser manual. Isso gera risco de perda de histórico de manutenção do veículo e falta de visão de estoque.

## 2. Processo atual (fluxo textual)

```text
Cliente relata defeito (mensagem/WhatsApp/telefone ou presencial)
↓
Se contato prévio → agenda horário
   (se aparecer sem agendar e houver mecânico livre → é atendido na hora)
↓
Cliente comparece na oficina no horário
↓
Mecânico disponível diagnostica o defeito
↓
Mecânico executa o reparo
   (usa peça do estoque, ou peça é solicitada/comprada para o serviço)
↓
Abertura da Ordem de Serviço (registra cliente, veículo, serviço realizado)
↓
Cliente paga (débito, crédito, PIX ou parcelado em até 4x)
```

Regra de prioridade de atendimento: quem tem horário marcado tem prioridade; um veículo sem agendamento só é atendido na hora se houver mecânico ocioso.

## 3. Requisitos funcionais (RF)
- RF01 — O sistema deve permitir cadastrar clientes e seus veículos.
- RF02 — O sistema deve permitir registrar ordens de serviço, vinculando cliente, veículo, mecânico responsável e serviços realizados.
- RF03 — O sistema deve permitir agendar horários de atendimento.
- RF04 — O sistema deve permitir consultar a disponibilidade de horários e de mecânicos.
- RF05 — O sistema deve permitir registrar o pagamento de uma ordem de serviço, à vista ou parcelado em até 4x.
- RF06 — O sistema deve permitir controlar o estoque de peças (entrada e saída).
- RF07 — O sistema deve permitir consultar o histórico de ordens de serviço de um cliente ou veículo.

## 4. Requisitos não funcionais (RNF)
- RNF01 — O sistema deve restringir o acesso por usuário e senha.
- RNF02 — O sistema deve proteger os dados dos clientes.
- RNF03 — O sistema deve ter interface simples, considerando que a equipe não tem familiaridade com sistemas.
- RNF04 — As consultas devem responder rapidamente mesmo em dispositivos simples.

## 5. Regras de negócio (RN)
- RN01 — Uma ordem de serviço deve estar associada a exatamente um cliente e um veículo.
- RN02 — Um mecânico não pode estar alocado a dois atendimentos no mesmo horário.
- RN03 — Um agendamento tem prioridade sobre um atendimento não agendado, salvo se houver mecânico ocioso.
- RN04 — Um pagamento deve estar relacionado a uma única ordem de serviço e pode ser dividido em até 4 parcelas.
- RN05 — Uma peça só pode ser utilizada em uma ordem de serviço se houver quantidade disponível em estoque.
- RN06 — Um veículo pode ter várias ordens de serviço ao longo do tempo (histórico de manutenções).

## 6. Entidades preliminares e atributos

**CLIENTE**: id_cliente, nome, telefone

**VEICULO**: id_veiculo, placa, modelo, ano, id_cliente

**MECANICO**: id_mecanico, nome, especialidade

**ORDEM_SERVICO**: id_os, data, defeito_relatado, descricao_servico, status, id_veiculo, id_mecanico

**PECA**: id_peca, nome, quantidade_estoque, valor_unitario

**ITEM_OS** (associativa, peças usadas em cada OS): id_item, id_os, id_peca, quantidade

**PAGAMENTO**: id_pagamento, id_os, forma_pagamento, valor, numero_parcelas, data_pagamento

**AGENDAMENTO**: id_agendamento, data, horario, status, id_cliente, id_veiculo
