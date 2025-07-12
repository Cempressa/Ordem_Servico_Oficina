# Ordem_Servico_Oficina
Modelagem conceitual e script SQL para sistema de Ordens de Serviço em oficina mecânica
# Sistema de Gerenciamento de Ordens de Serviço - Oficina Mecânica

## Descrição do Projeto

Este repositório contém a modelagem conceitual e lógica (física) para um sistema de controle e gerenciamento de execução de Ordens de Serviço (OS) em uma oficina mecânica. O projeto foi desenvolvido com base em uma narrativa fornecida, detalhando o fluxo de trabalho da oficina.

## Objetivos do Sistema

O sistema visa otimizar os seguintes processos:
* **Cadastro e Gerenciamento de Clientes e Veículos:** Permitindo registrar informações detalhadas de clientes e seus respectivos veículos.
* **Criação e Gestão de Ordens de Serviço (OS):** Com registro de defeitos, serviços a serem executados, peças utilizadas, valores e status de cada OS.
* **Atribuição de Equipes:** Designação de Ordens de Serviço a equipes de mecânicos.
* **Controle de Mão de Obra e Peças:** Cálculo do valor total da OS, considerando serviços (tabela de referência de mão de obra) e peças.
* **Registro de Mecânicos:** Informações detalhadas sobre os mecânicos e suas especialidades.
* **Monitoramento do Status da OS:** Acompanhamento do progresso da OS desde a abertura até a conclusão ou cancelamento.
* **Autorização do Cliente:** Registro da aprovação do cliente para a execução dos serviços.

## Modelagem de Dados

A modelagem foi dividida em etapas:

### 1. Modelagem Conceitual
Identificação das principais entidades do negócio e seus relacionamentos. As entidades primárias incluem:
* `Cliente`: Informações sobre os clientes da oficina (PF/PJ, contato, endereço).
* `Veículo`: Detalhes dos veículos trazidos pelos clientes.
* `Ordem de Serviço (OS)`: O documento central que registra os serviços e peças de um veículo.
* `Mecânico`: Dados dos profissionais da oficina.
* `Equipe Mecânica`: Organização dos mecânicos em equipes.
* `Peça`: Itens de estoque utilizados nos serviços.
* `Serviço`: Tipos de serviços oferecidos pela oficina, com valores de referência de mão de obra.

### 2. Modelagem Lógica/Física (Esquema SQL)

O modelo conceitual foi traduzido para um esquema de banco de dados relacional, implementado em MySQL. O script `Ordem_Servico.sql` contém a DDL (Data Definition Language) para a criação de todas as tabelas, índices e chaves estrangeiras, estabelecendo os relacionamentos entre as entidades.

**Principais Tabelas:**
* `cliente`
* `equipemecanica`
* `veiculos`
* `ordensservico`
* `pecas`
* `servicos`
* `mecanico`
* `itensos_peca` (tabela de junção para OS e Peças)
* `itensos_servico` (tabela de junção para OS e Serviços)

## Diagrama de Entidade-Relacionamento (DER)

Um diagrama visual da modelagem de dados, gerado a partir do esquema SQL, está disponível no arquivo `diagrama_oficina.png`. Este diagrama ilustra as entidades, seus atributos e os relacionamentos definidos no banco de dados.

## Arquivos do Repositório

* `Ordem_Servico.sql`: Script SQL para criação do banco de dados e tabelas.
* `diagrama_oficina.png`: Imagem do diagrama EER da modelagem de dados.
* `README.md`: Este arquivo, com a descrição do projeto.

---
*Este projeto foi desenvolvido como parte de um desafio de modelagem de banco de dados.*
