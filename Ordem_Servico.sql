-- MySQL Workbench Forward Engineering
SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS,
  UNIQUE_CHECKS = 0;
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS,
  FOREIGN_KEY_CHECKS = 0;
SET @OLD_SQL_MODE = @@SQL_MODE,
  SQL_MODE = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
-- -----------------------------------------------------
-- Schema ordem_servico_db
-- -----------------------------------------------------
DROP DATABASE IF EXISTS `ordem_servico_db`;
-- -----------------------------------------------------
-- Schema ordem_servico_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ordem_servico_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `ordem_servico_db`;
-- -----------------------------------------------------
-- Table `ordem_servico_db`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ordem_servico_db`.`cliente` (
  `IdCliente` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `Tipo_Cliente` ENUM('PF', 'PJ') NOT NULL,
  `CPF` VARCHAR(14) NULL DEFAULT NULL,
  `RG` VARCHAR(20) NULL DEFAULT NULL,
  `CNPJ` VARCHAR(18) NULL DEFAULT NULL,
  `Razao_Social_PJ` VARCHAR(100) NULL DEFAULT NULL,
  `Email` VARCHAR(45) NOT NULL,
  `Telefone` VARCHAR(20) NULL DEFAULT NULL,
  `Logradouro` VARCHAR(100) NOT NULL,
  `Numero` VARCHAR(10) NOT NULL,
  `Complemento` VARCHAR(50) NULL DEFAULT NULL,
  `Bairro` VARCHAR(100) NOT NULL,
  `Cidade` VARCHAR(100) NOT NULL,
  `Estado` VARCHAR(2) NOT NULL,
  `CEP` VARCHAR(9) NOT NULL,
  `Data_Cadastro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IdCliente`),
  UNIQUE INDEX `Email` (`Email` ASC) VISIBLE,
  UNIQUE INDEX `CPF` (`CPF` ASC) VISIBLE,
  UNIQUE INDEX `CNPJ` (`CNPJ` ASC) VISIBLE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
-- -----------------------------------------------------
-- Table `ordem_servico_db`.`equipemecanica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ordem_servico_db`.`equipemecanica` (
  `idEquipe` INT NOT NULL AUTO_INCREMENT,
  `NomeEquipe` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idEquipe`),
  UNIQUE INDEX `NomeEquipe` (`NomeEquipe` ASC) VISIBLE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
-- -----------------------------------------------------
-- Table `ordem_servico_db`.`veiculos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ordem_servico_db`.`veiculos` (
  `veiculo_id` INT NOT NULL AUTO_INCREMENT,
  `cliente_id` INT NOT NULL,
  `marca` VARCHAR(100) NULL DEFAULT NULL,
  `modelo_ano` VARCHAR(50) NULL DEFAULT NULL,
  `placa` VARCHAR(10) NOT NULL,
  `numero_chassis` VARCHAR(50) NULL DEFAULT NULL,
  `numero_patrimonio` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`veiculo_id`),
  UNIQUE INDEX `placa` (`placa` ASC) VISIBLE,
  UNIQUE INDEX `numero_chassis` (`numero_chassis` ASC) VISIBLE,
  INDEX `fk_veiculos_cliente_unified` (`cliente_id` ASC) VISIBLE,
  CONSTRAINT `fk_veiculos_cliente_unified` FOREIGN KEY (`cliente_id`) REFERENCES `ordem_servico_db`.`cliente` (`IdCliente`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
-- -----------------------------------------------------
-- Table `ordem_servico_db`.`ordensservico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ordem_servico_db`.`ordensservico` (
  `os_id` INT NOT NULL AUTO_INCREMENT,
  `os_numero` VARCHAR(50) NOT NULL,
  `data_os` DATE NOT NULL,
  `veiculo_id` INT NOT NULL,
  `defeito_reclamacao` TEXT NULL DEFAULT NULL,
  `servicos_executados_local` TEXT NULL DEFAULT NULL,
  `garantia` VARCHAR(100) NULL DEFAULT NULL,
  `proxima_revisao` DATE NULL DEFAULT NULL,
  `mao_de_obra` DECIMAL(10, 2) NULL DEFAULT NULL,
  `pecas` DECIMAL(10, 2) NULL DEFAULT NULL,
  `total` DECIMAL(10, 2) GENERATED ALWAYS AS ((`mao_de_obra` + `pecas`)) STORED,
  `id_Equipe` INT NOT NULL,
  `status_os` ENUM(
    'Aberta',
    'Em Andamento',
    'Aguardando Aprovação',
    'Aguardando Peças',
    'Concluída',
    'Cancelada'
  ) NOT NULL DEFAULT 'Aberta',
  -- Adicionado
  `data_prev_conclusao` DATE NULL DEFAULT NULL,
  -- Adicionado
  `data_autorizacao_cliente` DATETIME NULL DEFAULT NULL,
  -- Adicionado
  PRIMARY KEY (`os_id`),
  UNIQUE INDEX `os_numero` (`os_numero` ASC) VISIBLE,
  INDEX `veiculo_id` (`veiculo_id` ASC) VISIBLE,
  INDEX `fk_ordem_servico_equipe` (`id_Equipe` ASC) VISIBLE,
  CONSTRAINT `fk_ordem_servico_equipe` FOREIGN KEY (`id_Equipe`) REFERENCES `ordem_servico_db`.`equipemecanica` (`idEquipe`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ordensservico_ibfk_1` FOREIGN KEY (`veiculo_id`) REFERENCES `ordem_servico_db`.`veiculos` (`veiculo_id`) ON DELETE RESTRICT
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
-- -----------------------------------------------------
-- Table `ordem_servico_db`.`pecas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ordem_servico_db`.`pecas` (
  `id_peca` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(255) NOT NULL,
  `descricao` TEXT NULL DEFAULT NULL,
  `preco_custo` DECIMAL(10, 2) NULL DEFAULT NULL,
  `preco_venda_sugerido` DECIMAL(10, 2) NOT NULL,
  `quantidade_estoque` INT NULL DEFAULT '0',
  `data_ultima_atualizacao_estoque` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_peca`),
  UNIQUE INDEX `nome` (`nome` ASC) VISIBLE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
-- -----------------------------------------------------
-- Table `ordem_servico_db`.`itensos_peca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ordem_servico_db`.`itensos_peca` (
  `id_item_os_peca` INT NOT NULL AUTO_INCREMENT,
  `id_os` INT NOT NULL,
  `id_peca` INT NOT NULL,
  `quantidade` INT NOT NULL,
  `valor_unitario_cobrado` DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (`id_item_os_peca`),
  UNIQUE INDEX `id_os` (`id_os` ASC, `id_peca` ASC) VISIBLE,
  INDEX `id_peca` (`id_peca` ASC) VISIBLE,
  CONSTRAINT `itensos_peca_ibfk_1` FOREIGN KEY (`id_os`) REFERENCES `ordem_servico_db`.`ordensservico` (`os_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `itensos_peca_ibfk_2` FOREIGN KEY (`id_peca`) REFERENCES `ordem_servico_db`.`pecas` (`id_peca`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
-- -----------------------------------------------------
-- Table `ordem_servico_db`.`servicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ordem_servico_db`.`servicos` (
  `id_servico` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(255) NOT NULL,
  `valor_mao_de_obra_referencia` DECIMAL(10, 2) NOT NULL,
  `especialidade_requerida` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id_servico`),
  UNIQUE INDEX `descricao` (`descricao` ASC) VISIBLE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
-- -----------------------------------------------------
-- Table `ordem_servico_db`.`itensos_servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ordem_servico_db`.`itensos_servico` (
  `id_item_os_servico` INT NOT NULL AUTO_INCREMENT,
  `id_os` INT NOT NULL,
  `id_servico` INT NOT NULL,
  `quantidade` INT NULL DEFAULT '1',
  `valor_unitario_cobrado` DECIMAL(10, 2) NOT NULL,
  `descricao_adicional` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id_item_os_servico`),
  UNIQUE INDEX `id_os` (`id_os` ASC, `id_servico` ASC) VISIBLE,
  INDEX `id_servico` (`id_servico` ASC) VISIBLE,
  CONSTRAINT `itensos_servico_ibfk_1` FOREIGN KEY (`id_os`) REFERENCES `ordem_servico_db`.`ordensservico` (`os_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `itensos_servico_ibfk_2` FOREIGN KEY (`id_servico`) REFERENCES `ordem_servico_db`.`servicos` (`id_servico`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
-- -----------------------------------------------------
-- Table `ordem_servico_db`.`mecanico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ordem_servico_db`.`mecanico` (
  `idMecanico` INT NOT NULL AUTO_INCREMENT,
  `Codigo` VARCHAR(50) NOT NULL,
  `Nome` VARCHAR(255) NOT NULL,
  `Endereco` VARCHAR(255) NULL DEFAULT NULL,
  `Especialidade` VARCHAR(100) NULL DEFAULT NULL,
  `Telefone` VARCHAR(20) NULL DEFAULT NULL,
  `id_Equipe` INT NOT NULL,
  PRIMARY KEY (`idMecanico`),
  UNIQUE INDEX `Codigo` (`Codigo` ASC) VISIBLE,
  INDEX `id_Equipe` (`id_Equipe` ASC) VISIBLE,
  CONSTRAINT `mecanico_ibfk_1` FOREIGN KEY (`id_Equipe`) REFERENCES `ordem_servico_db`.`equipemecanica` (`idEquipe`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
SET SQL_MODE = @OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS;