# Levantamento de requisitos — Oficina Tricai

## 1. Identificação da organização

- **Nome:** Oficina Tricai
- **Atividade:** oficina mecânica especializada em vans Mercedes-Benz, incluindo diagnóstico, revisões e reparos.
- **Porte informado no levantamento inicial:** pequeno, com aproximadamente 4 a 5 pessoas.
- **Endereço registrado:** Av. Miguel Badra, 782 — Suzano/SP.
- **Contato registrado:** (11) 99778-1502.
- **Pessoas consultadas:** Alexandre Tricai (proprietário) e Gabriel Tricai (contato para esclarecimentos sobre a operação).

## 2. Etapas do levantamento

O levantamento foi organizado em duas etapas: uma entrevista inicial com informações sobre a rotina da Oficina Tricai e uma segunda entrevista complementar estruturada, voltada principalmente às compras, ao estoque, à emissão de notas fiscais e ao volume estimado de operações. As perguntas abaixo foram adaptadas para organizar os temas investigados.

## 3. Entrevistas e esclarecimentos

### 3.1. Primeira etapa — funcionamento geral da oficina

**Pergunta: Qual é a atividade principal da Oficina Tricai?**  
**Resposta sintetizada:** A oficina realiza diagnósticos, revisões e reparos mecânicos, com foco em vans Mercedes-Benz.

**Pergunta: Como os clientes solicitam atendimento?**  
**Resposta sintetizada:** O contato pode ser feito por telefone, mensagens ou presencialmente. Há agendamentos prévios; o atendimento sem horário depende da disponibilidade da equipe.

**Pergunta: Como são registrados os serviços?**  
**Resposta sintetizada:** A oficina utiliza ordens de serviço com informações sobre o cliente, o veículo e a manutenção realizada. O levantamento inicial não identificou um cadastro informatizado centralizado de clientes, veículos e histórico.

**Pergunta: Quais são as formas de pagamento?**  
**Resposta sintetizada:** O levantamento inicial registrou pagamentos por débito, crédito e PIX, com parcelamento em até quatro vezes.

**Pergunta: Como são acompanhadas as peças armazenadas?**  
**Resposta sintetizada:** O acompanhamento das peças ocorre visualmente nas prateleiras, sem um sistema informatizado de controle de estoque.

### 3.2. Segunda etapa — Entrevista complementar com Alexandre Tricai

**Entrevistado:** Alexandre Tricai — proprietário da Oficina Tricai.

**Apoio na comunicação:** Gabriel Tricai.

**Objetivo:** Aprofundar o levantamento de requisitos, esclarecendo o processo de compra de peças, a organização do estoque, a emissão de notas fiscais e o volume aproximado das operações.

As respostas abaixo foram organizadas a partir das informações fornecidas pelo proprietário, com apoio de Gabriel na comunicação.

**Pergunta 1 — A oficina compra as peças necessárias aos reparos ou solicita que os clientes as comprem?**

**Resposta:** Normalmente, a própria oficina realiza a compra das peças utilizadas nos reparos.

**Pergunta 2 — Quais fornecedores são utilizados pela oficina?**

**Resposta:** A Rodobens foi mencionada como um dos locais utilizados para a compra de peças.

**Pergunta 3 — A oficina mantém peças em estoque ou compra tudo conforme a necessidade?**

**Resposta:** São mantidas em estoque principalmente peças utilizadas em revisões, como filtros de óleo, filtros de ar, filtros de combustível e pastilhas de freio. As demais peças são adquiridas conforme a necessidade de cada reparo.

**Pergunta 4 — Como funciona o controle das peças armazenadas?**

**Resposta consolidada do levantamento:** O controle é realizado visualmente, por meio da observação das peças disponíveis nas prateleiras, sem um sistema informatizado de estoque.

**Pergunta 5 — A oficina realiza a emissão de notas fiscais?**

**Resposta:** Sim, a oficina emite notas fiscais.

**Pergunta 6 — Quantos atendimentos são realizados por semana?**

**Resposta estimada:** Aproximadamente 20 atendimentos.

**Pergunta 7 — Quantos clientes ativos a oficina possui?**

**Resposta estimada:** Cerca de 50 clientes ativos.

**Pergunta 8 — Quantos veículos são atendidos mensalmente?**

**Resposta estimada:** Aproximadamente 70 veículos por mês.

**Pergunta 9 — Qual é a quantidade aproximada de peças em estoque?**

**Resposta estimada:** Cerca de 40 peças, considerando conjuntamente itens como filtros e pastilhas de freio.

#### Evidências fotográficas complementares

Foram obtidos novos registros fotográficos da oficina, incluindo um veículo Mercedes-Benz Sprinter em manutenção e peças automotivas armazenadas em prateleiras.

As imagens complementam o levantamento ao documentar o ambiente de manutenção e a organização física das peças.

#### Considerações da segunda etapa

As informações complementares permitiram compreender melhor a rotina de aquisição de peças, a manutenção de um estoque básico e a compra de componentes específicos conforme a demanda.

Também foram obtidas estimativas de atendimentos, clientes, veículos e peças armazenadas, utilizadas como referência para o dimensionamento dos dados de teste do projeto.

### 3.3. Relação das respostas com as decisões do projeto

As informações obtidas durante o levantamento foram utilizadas para revisar a modelagem do banco de dados e identificar oportunidades de melhoria nos processos da oficina.

| Informação levantada | Aplicação na modelagem |
|---|---|
| A oficina realiza a compra das próprias peças | Foram incluídas as entidades `COMPRA`, `FORNECEDOR` e `CONTEM`, permitindo representar as compras de peças e seus respectivos fornecedores. |
| A Rodobens foi mencionada como fornecedora | A informação serviu como referência para o cadastro de fornecedores, sem considerar a empresa como fornecedora exclusiva. |
| Filtros e pastilhas de freio são mantidos em estoque | A entidade `PECA` permite cadastrar os itens e suas quantidades disponíveis. |
| Outras peças são compradas conforme a necessidade | O relacionamento entre compras e peças permite registrar os itens adquiridos, enquanto `UTILIZA` representa as peças utilizadas nas ordens de serviço. |
| A oficina emite notas fiscais | A emissão de notas fiscais foi identificada como parte da operação, mas não foi desenvolvido um módulo fiscal nesta entrega. |
| Foram fornecidas estimativas de atendimentos, clientes, veículos e estoque | Os valores foram utilizados como referência para compreender o porte da operação e planejar os dados de teste e as consultas gerenciais. |

**Observação sobre garantia:** A regra de permitir no máximo um retorno por ordem de serviço original foi adotada durante a revisão da modelagem.


## 4. Evidências fotográficas

### 4.1. Registros da primeira entrevista

Arquivos existentes na pasta `evidencias/` do repositório:

- `equipe-oficina.jpg` — registro da equipe.
- `estoque-pecas.jpg` — registro do espaço de armazenamento.
- `fachada-letreiro.jpg` — identificação visual da oficina.
- `galpao-vans-clientes.jpg` — ambiente de manutenção.
- `ordem-servico-modelo.jpg` — exemplo do documento de ordem de serviço, com dados pessoais protegidos.

### 4.2. Registros complementares

Duas fotografias foram disponibilizadas após a primeira entrevista:

1. **Veículo em manutenção:** van Mercedes-Benz vermelha, com o capô aberto, dentro do ambiente da oficina. A imagem ilustra a atividade de manutenção.
2. **Peças em prateleiras:** embalagens de filtros automotivos e outras peças armazenadas em estantes. A imagem ilustra o armazenamento físico mencionado nos esclarecimentos sobre estoque.

**Sugestão de nomes ao publicar essas imagens:** `evidencias/veiculo-manutencaojpg` e `evidencias/estoque-pecas.jpg`. Esses caminhos só devem ser usados como links após o envio dos arquivos ao repositório.

## 5. Diagnóstico do processo atual

O levantamento inicial registra que a oficina não possui um sistema integrado de gestão. O cadastro de clientes e veículos fica associado às ordens de serviço; os agendamentos são combinados por telefone ou mensagens; e o estoque é acompanhado visualmente. Isso dificulta a centralização do histórico de manutenção, a consulta de horários e a visualização das quantidades disponíveis.

## 6. Fluxo de atendimento identificado

```text
Cliente entra em contato ou comparece à oficina
                 ↓
Verificação do agendamento e da disponibilidade
                 ↓
Recepção do veículo e avaliação do defeito
                 ↓
Definição do mecânico responsável
                 ↓
Execução do serviço e utilização de peças, se necessário
                 ↓
Registro da ordem de serviço e do valor do atendimento
                 ↓
Pagamento e manutenção do histórico
                 ↓
Possível retorno relacionado à ordem de serviço original
```

O fluxo é uma **síntese analítica** das informações levantadas, não um procedimento formal escrito pela oficina. A ordem exata de abertura e preenchimento da OS deve ser confirmada com o entrevistado se for relevante para a avaliação.

## 7. Requisitos funcionais propostos

- **RF01:** Cadastrar clientes e seus veículos.
- **RF02:** Registrar agendamentos e consultar horários disponíveis.
- **RF03:** Cadastrar mecânicos e vinculá-los aos atendimentos.
- **RF04:** Registrar ordens de serviço com veículo, cliente, mecânico, descrição do problema, serviços executados e situação do atendimento.
- **RF05:** Registrar serviços realizados e peças utilizadas.
- **RF06:** Cadastrar peças e consultar quantidades disponíveis em estoque.
- **RF07:** Registrar pagamentos, incluindo parcelamento de até quatro vezes quando aplicável.
- **RF08:** Consultar o histórico de ordens de serviço por cliente ou veículo.
- **RF09:** Relacionar retornos por garantia às ordens de serviço originais.
- **RF10:** Permitir consultas gerenciais sobre atendimentos, serviços, clientes e estoque.
- **RF11 (melhoria proposta):** Registrar fornecedores e compras de peças para apoiar o controle futuro de abastecimento.

## 8. Requisitos não funcionais propostos

- **RNF01:** Proteger informações pessoais de clientes.
- **RNF02:** Oferecer organização simples e compreensível dos dados.
- **RNF03:** Manter integridade referencial entre clientes, veículos, ordens de serviço, serviços, peças e pagamentos.
- **RNF04:** Permitir consultas eficientes sobre os registros armazenados.

*Observação:* controle de login e interface gráfica podem ser requisitos de um sistema futuro, mas não devem ser apresentados como funcionalidades já implementadas apenas com os scripts SQL desta entrega.

## 9. Regras de negócio adotadas na modelagem

- **RN01:** Cada ordem de serviço está vinculada a um cliente e a um veículo.
- **RN02:** Um veículo pode possuir várias ordens de serviço ao longo do tempo.
- **RN03:** Um mecânico não deve ter dois agendamentos no mesmo horário, conforme a restrição adotada no banco.
- **RN04:** Cada pagamento registrado pertence a uma ordem de serviço; o modelo prevê no máximo um registro de pagamento por OS.
- **RN05:** Pagamentos a crédito podem ter de uma a quatro parcelas; nas demais formas, o número de parcelas não é informado.
- **RN06:** A utilização de peças deve respeitar as quantidades disponíveis, de acordo com os controles implementados.
- **RN07:** Uma ordem de serviço original pode ter, no máximo, um retorno vinculado, conforme decisão de modelagem orientada na revisão do projeto.
- **RN08:** O valor do serviço pode ser registrado após a abertura ou início do atendimento.

As regras devem ser verificadas contra os scripts SQL finais. Algumas representam decisões de implementação, não afirmações literais dos entrevistados.

## 10. Entidades consideradas no modelo

- `CLIENTE` — dados de identificação e contato.
- `VEICULO` — veículos associados aos clientes.
- `MECANICO` — profissionais responsáveis pelos atendimentos.
- `AGENDAMENTO` — datas e horários marcados.
- `ORDEM_SERVICO` — registros de manutenção, valores e possíveis retornos.
- `SERVICO` — tipos de serviços executados.
- `PECA` — peças e quantidades armazenadas.
- `UTILIZA` — associação entre ordens de serviço e peças.
- `REALIZA` — associação entre ordens de serviço e serviços.
- `PAGAMENTO` — informações sobre o pagamento da OS.
- `FORNECEDOR` — cadastro proposto para organização de fornecedores.
- `COMPRA` — registro proposto de compras.
- `CONTEM` — associação entre compras e peças.

## 11. Considerações finais e pontos de validação

- O levantamento partiu das informações da entrevista inicial, foi aprofundado por uma segunda etapa de esclarecimentos estruturados com o proprietario e recebeu registros fotográficos. As evidências mostram o ambiente de manutenção e o armazenamento físico das peças, enquanto as regras operacionais decorrem das informações fornecidas pelos contatos da oficina e da análise do grupo.
- Um dos integrantes do grupo, Gabriel Ferraz Aguiar Tricai, é filho de Alexandre Tricai, proprietário da Oficina Tricai. A relação familiar facilitou o contato com o estabelecimento e a obtenção de informações sobre seu funcionamento. Entretanto, os requisitos do projeto foram definidos a partir das informações fornecidas pelo proprietário, das evidências reunidas e da análise realizada pelo grupo.
