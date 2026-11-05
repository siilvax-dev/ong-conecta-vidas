-- Projeto Integrador Extensionista II - Atividade 2
-- ONG Conecta Vidas | database/schema.sql
-- Modelo proposto: validar entidades e relacionamentos com o MER do PIE I.
-- Compativel com MySQL 8.0.16+ (versoes anteriores nao aplicam CHECK).

SET NAMES utf8mb4;
DROP DATABASE IF EXISTS conecta_vidas;
CREATE DATABASE conecta_vidas CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE conecta_vidas;

-- Pessoas que doam recursos para a ONG.
CREATE TABLE doador (
    id_doador INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE,
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Pessoas atendidas pela ONG. Dados minimos, conforme LGPD.
CREATE TABLE beneficiario (
    id_beneficiario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE voluntario (
    id_voluntario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE campanha (
    id_campanha INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    status_campanha VARCHAR(20) NOT NULL DEFAULT 'planejada',
    CONSTRAINT chk_campanha_datas CHECK (data_fim IS NULL OR data_fim >= data_inicio),
    CONSTRAINT chk_campanha_status CHECK (status_campanha IN ('planejada', 'ativa', 'encerrada', 'cancelada'))
) ENGINE=InnoDB;

CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE item (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    nome VARCHAR(150) NOT NULL,
    unidade_medida VARCHAR(20) NOT NULL DEFAULT 'unidade',
    CONSTRAINT uq_item_categoria_nome UNIQUE (id_categoria, nome),
    CONSTRAINT fk_item_categoria FOREIGN KEY (id_categoria)
        REFERENCES categoria (id_categoria) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_item_unidade CHECK (unidade_medida IN ('unidade', 'kg', 'litro', 'pacote', 'caixa'))
) ENGINE=InnoDB;

-- Doacao: cada registro pertence a um doador; campanha e opcional.
CREATE TABLE doacao (
    id_doacao INT AUTO_INCREMENT PRIMARY KEY,
    id_doador INT NOT NULL,
    id_campanha INT,
    data_doacao DATE NOT NULL,
    observacao VARCHAR(500),
    data_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_doacao_doador FOREIGN KEY (id_doador)
        REFERENCES doador (id_doador) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_doacao_campanha FOREIGN KEY (id_campanha)
        REFERENCES campanha (id_campanha) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Associativa N:N: uma doacao pode incluir varios itens e vice-versa.
CREATE TABLE doacao_item (
    id_doacao INT NOT NULL,
    id_item INT NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_doacao, id_item),
    CONSTRAINT chk_doacao_item_quantidade CHECK (quantidade > 0),
    CONSTRAINT fk_doacao_item_doacao FOREIGN KEY (id_doacao)
        REFERENCES doacao (id_doacao) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_doacao_item_item FOREIGN KEY (id_item)
        REFERENCES item (id_item) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Associativa N:N: voluntarios podem atuar em varias campanhas.
CREATE TABLE voluntario_campanha (
    id_voluntario INT NOT NULL,
    id_campanha INT NOT NULL,
    data_entrada DATE NOT NULL,
    funcao VARCHAR(100),
    PRIMARY KEY (id_voluntario, id_campanha),
    CONSTRAINT fk_vc_voluntario FOREIGN KEY (id_voluntario)
        REFERENCES voluntario (id_voluntario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_vc_campanha FOREIGN KEY (id_campanha)
        REFERENCES campanha (id_campanha) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Registro de entrega dos itens a beneficiarios.
CREATE TABLE entrega (
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_beneficiario INT NOT NULL,
    id_voluntario INT,
    data_entrega DATE NOT NULL,
    observacao VARCHAR(500),
    CONSTRAINT fk_entrega_beneficiario FOREIGN KEY (id_beneficiario)
        REFERENCES beneficiario (id_beneficiario) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_entrega_voluntario FOREIGN KEY (id_voluntario)
        REFERENCES voluntario (id_voluntario) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Associativa N:N: cada entrega contempla um ou varios itens.
CREATE TABLE entrega_item (
    id_entrega INT NOT NULL,
    id_item INT NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_entrega, id_item),
    CONSTRAINT chk_entrega_item_quantidade CHECK (quantidade > 0),
    CONSTRAINT fk_entrega_item_entrega FOREIGN KEY (id_entrega)
        REFERENCES entrega (id_entrega) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_entrega_item_item FOREIGN KEY (id_item)
        REFERENCES item (id_item) ON DELETE RESTRICT ON UPDATE CASCADE
