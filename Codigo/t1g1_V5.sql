-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema t1g1
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema t1g1
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `t1g1` DEFAULT CHARACTER SET utf8 ;
USE `t1g1` ;

-- -----------------------------------------------------
-- Table `t1g1`.`codigos_postais`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`codigos_postais` (
  `codPostal` VARCHAR(8) NOT NULL COMMENT 'Código postal. É chave primária da tabela.',
  `local` VARCHAR(100) NOT NULL COMMENT 'Localizade referente ao respectivo código postal. ',
  PRIMARY KEY (`codPostal`),
  UNIQUE INDEX `codpostal_UNIQUE` (`codPostal` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`loja`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`loja` (
  `idLoja` INT NOT NULL AUTO_INCREMENT COMMENT 'Código de identificação da loja. É chave Primária da tabela. É autoincrementável. ',
  `desigComercial` VARCHAR(40) NOT NULL COMMENT 'Designação comercial, \"Marca\", da loja. É chave primária desta tabela.',
  `desigSocial` VARCHAR(60) NULL COMMENT 'Designação social da loja.',
  `nif` INT(9) NOT NULL COMMENT 'Número de contríbuinte da loja.  ',
  `moradaLoja` VARCHAR(120) NOT NULL COMMENT 'Morada da loja. ',
  `codPostal` VARCHAR(8) NOT NULL COMMENT 'Codigo postal da Loja.',
  `wesite` VARCHAR(50) NULL COMMENT 'Web site da loja.',
  `logotipo` VARCHAR(120) NULL COMMENT 'Caminho para o ficheiro de imagem com o logotipo da loja.',
  PRIMARY KEY (`idLoja`),
  UNIQUE INDEX `desigComercial_UNIQUE` (`desigComercial` ASC),
  UNIQUE INDEX `nic_UNIQUE` (`nif` ASC),
  INDEX `fk_loja_codigos_postais1_idx` (`codPostal` ASC),
  CONSTRAINT `fk_loja_codigos_postais1`
    FOREIGN KEY (`codPostal`)
    REFERENCES `t1g1`.`codigos_postais` (`codPostal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`tipo_utilizador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`tipo_utilizador` (
  `idTipoUt` INT NOT NULL AUTO_INCREMENT,
  `idTipoUtilizador` VARCHAR(4) NOT NULL COMMENT 'Código identificativo do tipo de utilizador. É Chave Primária da tabela.',
  `descrTipoUtilizador` VARCHAR(60) NULL COMMENT 'Descrição do tipo de utilizador.',
  PRIMARY KEY (`idTipoUt`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`utilizadores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`utilizadores` (
  `idUtilizador` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificação do Utilizador na BD. É Chave Primária da tabela e é auto incremental. ',
  `idLoja` INT NOT NULL,
  `idTipoUt` INT NOT NULL,
  `userName` VARCHAR(50) NOT NULL COMMENT 'User name  identificativo do utilizador. É chave primária da tabela.',
  `password` VARCHAR(10) NOT NULL COMMENT 'Palavra passe do utilizador.',
  PRIMARY KEY (`idUtilizador`),
  INDEX `fk_utilizadores_loja1_idx` (`idLoja` ASC),
  INDEX `fk_utilizadores_tipo_utilizador1_idx` (`idTipoUt` ASC),
  UNIQUE INDEX `idUtilizador_UNIQUE` (`idUtilizador` ASC),
  CONSTRAINT `fk_utilizadores_loja1`
    FOREIGN KEY (`idLoja`)
    REFERENCES `t1g1`.`loja` (`idLoja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_utilizadores_tipo_utilizador1`
    FOREIGN KEY (`idTipoUt`)
    REFERENCES `t1g1`.`tipo_utilizador` (`idTipoUt`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`clientes` (
  `idCliente` INT NOT NULL AUTO_INCREMENT COMMENT 'Código identificativo do cliente da loja. É auto incrementável e gerado quando o utilizador se regista como cliente da loja.\nÉ Chave Primária desta tabela.',
  `idUtilizador` INT NOT NULL,
  `nomeCliente` VARCHAR(50) NOT NULL COMMENT 'Nome do cliente.',
  `contactTelef` INT(15) NULL COMMENT 'Contacto telefónico do cliente. Permite inserir 15 algarismos, para incluir, se necessário, indicativos estrangeiros.',
  `emailCliente` VARCHAR(50) NOT NULL COMMENT 'Endereço email do cliente.',
  `nifCliente` INT(9) NOT NULL COMMENT 'Número de contríbuinte do cliente. ',
  `moradaCliente` VARCHAR(100) NOT NULL COMMENT 'Morada do cliente.',
  `codPostal` VARCHAR(8) NOT NULL,
  `tipoCliente` VARCHAR(4) NULL DEFAULT 'Part' COMMENT 'Identificação do tipo de cliente. Particular ou empresa.',
  `nCartaoCliente` INT(9) NULL COMMENT 'Numero de cartão de cliente. Preparado para eventual upgrade gestão de utilização de cartões de cliente.',
  PRIMARY KEY (`idCliente`),
  UNIQUE INDEX `idCliente_UNIQUE` (`idCliente` ASC),
  INDEX `fk_clientes_codigos_postais1_idx` (`codPostal` ASC),
  INDEX `fk_clientes_utilizadores1_idx` (`idUtilizador` ASC),
  CONSTRAINT `fk_clientes_codigos_postais1`
    FOREIGN KEY (`codPostal`)
    REFERENCES `t1g1`.`codigos_postais` (`codPostal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_clientes_utilizadores1`
    FOREIGN KEY (`idUtilizador`)
    REFERENCES `t1g1`.`utilizadores` (`idUtilizador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`funcoes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`funcoes` (
  `idFuncao` INT NOT NULL AUTO_INCREMENT COMMENT 'Código identificativo da função que os funcionários podem desempenhar.',
  `desigFuncao` VARCHAR(15) NOT NULL COMMENT 'Designação da função.',
  `descrFuncao` VARCHAR(60) NULL COMMENT 'Descrição da função.',
  PRIMARY KEY (`idFuncao`),
  UNIQUE INDEX `idFuncao_UNIQUE` (`idFuncao` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`funcionarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`funcionarios` (
  `codFuncionario` INT NOT NULL AUTO_INCREMENT COMMENT 'Código identificativo do funcionário. É Cave Primária e é auto incrementável.',
  `idUtilizador` INT NOT NULL,
  `nomeFuncionario` VARCHAR(50) NOT NULL COMMENT 'Nome do funcionário.',
  `idFuncao` INT NOT NULL COMMENT 'Código identificativo da função desempenhada pelo funcionário. Permite ligar à tabela de funções.',
  UNIQUE INDEX `codFuncionario_UNIQUE` (`codFuncionario` ASC),
  INDEX `fk_funcionarios_funcoes1_idx` (`idFuncao` ASC),
  PRIMARY KEY (`codFuncionario`),
  INDEX `fk_funcionarios_utilizadores1_idx` (`idUtilizador` ASC),
  CONSTRAINT `fk_funcionarios_funcoes1`
    FOREIGN KEY (`idFuncao`)
    REFERENCES `t1g1`.`funcoes` (`idFuncao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_funcionarios_utilizadores1`
    FOREIGN KEY (`idUtilizador`)
    REFERENCES `t1g1`.`utilizadores` (`idUtilizador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`tipoPagamentos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`tipoPagamentos` (
  `idtipoTipoPag` INT NOT NULL AUTO_INCREMENT,
  `desigTipoPag` VARCHAR(2) NOT NULL COMMENT 'Identifica cada tipo de pagamento disponíveis para o cliente escolher. É chave primária desta tabela.\n',
  `descrTipoPag` VARCHAR(100) NULL COMMENT 'Destcreve o tipo de pagamento associado ao respectivo código.',
  PRIMARY KEY (`idtipoTipoPag`),
  UNIQUE INDEX `idTipoPagamento_UNIQUE` (`desigTipoPag` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`tipopag_loja`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`tipopag_loja` (
  `idTipoPagLoja` INT NOT NULL AUTO_INCREMENT,
  `idLoja` INT NOT NULL,
  `idTipoPag` INT NOT NULL,
  PRIMARY KEY (`idTipoPagLoja`),
  INDEX `fk_tipopag_loja_loja1_idx` (`idLoja` ASC),
  INDEX `fk_tipopag_loja_tipopagamentos1_idx` (`idTipoPag` ASC),
  CONSTRAINT `fk_tipopag_loja_loja1`
    FOREIGN KEY (`idLoja`)
    REFERENCES `t1g1`.`loja` (`idLoja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tipopag_loja_tipopagamentos1`
    FOREIGN KEY (`idTipoPag`)
    REFERENCES `t1g1`.`tipoPagamentos` (`idtipoTipoPag`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`taxaivaproduto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`taxaivaproduto` (
  `idTaxa` INT NOT NULL COMMENT 'Identificação simplificada da taxa de iva do produto.\nÉ chave primária e permite ligar à tabela produtos.',
  `valorTaxa` FLOAT NOT NULL COMMENT 'Valor da taxa de iva associado ao idTaxa a aplicar ao preço dos produto.',
  `desigTaxa` VARCHAR(10) NOT NULL,
  `descrTaxa` VARCHAR(45) NULL DEFAULT 'Sem descrição' COMMENT 'Descrição da da taxa de iva associada ao respectivo código.',
  PRIMARY KEY (`idTaxa`),
  UNIQUE INDEX `idtaxa_UNIQUE` (`idTaxa` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`tiposEntrega`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`tiposEntrega` (
  `idTipoEntr` INT NOT NULL AUTO_INCREMENT,
  `desigTipoEntr` VARCHAR(3) NOT NULL COMMENT 'Identifica do tipo de entraga. É chave primária da tabela.',
  `descrTipoEntr` VARCHAR(60) NULL COMMENT 'Descreve o tipo de pagamento associado ao respectivo código.\n',
  PRIMARY KEY (`idTipoEntr`),
  UNIQUE INDEX `idTipoEnt_UNIQUE` (`desigTipoEntr` ASC),
  UNIQUE INDEX `idtipo_UNIQUE` (`idTipoEntr` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`tipoentr_loja`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`tipoentr_loja` (
  `idTipoEntrLoja` INT NOT NULL AUTO_INCREMENT,
  `custo` FLOAT NULL,
  `idLoja` INT NOT NULL,
  `idTaxa` INT NOT NULL,
  `idTipoEntr` INT NOT NULL,
  PRIMARY KEY (`idTipoEntrLoja`),
  INDEX `fk_tipoentr_loja_loja1_idx` (`idLoja` ASC),
  INDEX `fk_tipoentr_loja_taxaivaproduto1_idx` (`idTaxa` ASC),
  INDEX `fk_tipoentr_loja_tiposEntrega1_idx` (`idTipoEntr` ASC),
  CONSTRAINT `fk_tipoentr_loja_loja1`
    FOREIGN KEY (`idLoja`)
    REFERENCES `t1g1`.`loja` (`idLoja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tipoentr_loja_taxaivaproduto1`
    FOREIGN KEY (`idTaxa`)
    REFERENCES `t1g1`.`taxaivaproduto` (`idTaxa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tipoentr_loja_tiposEntrega1`
    FOREIGN KEY (`idTipoEntr`)
    REFERENCES `t1g1`.`tiposEntrega` (`idTipoEntr`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`encomendas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`encomendas` (
  `idEncomenda` INT NOT NULL AUTO_INCREMENT COMMENT 'Identifica a encomenda. é chave primária da tabela de encomendas e á auto incrementável. ',
  `idCliente` INT NOT NULL COMMENT 'Identifica o cliente que efectua a encomenda. Permiti a ligação à tabela de clientes.',
  `idTipoPagLoja` INT NOT NULL,
  `codPagamento` INT NULL COMMENT 'Codigo que permitirá  identificar o pagamento relativo a cada encomenda.',
  `custoEntrega` FLOAT NULL DEFAULT 0 COMMENT 'Custo de entrega, relativo à encomenda, defenido na tabela de tipos de entrega, incluindo iva.',
  `codDespacho` INT NULL COMMENT 'Codigo que permitirá  identificar o despacho relativo a cada encomenda.',
  `txIvaEntr` FLOAT NULL DEFAULT 1 COMMENT 'Taxa de iva associado ao transporte à data da encomenda. Permite guardar o histórico do preço e iva nos despachos.\n',
  `valorTotal` FLOAT NOT NULL DEFAULT 0 COMMENT 'Valor total de encomedada resultante do sumatório dos valores parciais realtivos aos produtos e quantidades encomendadas, acrescido do valor do despacho. Este valor inclui o valor do Iva.\n',
  `moradaEntrega` VARCHAR(100) NULL DEFAULT 'Morada do Cliente' COMMENT 'Morada de entrega. Pr defeito será a morada do cliente.\n',
  `codpostal` VARCHAR(8) NOT NULL COMMENT 'Codigo postal ligando com a tabela de codigos postais.',
  `observacoes` VARCHAR(500) NULL COMMENT 'Poderão se colocadas observações relativas à encomenda.',
  `tipoentr_loja_idTipoEntrLoja` INT NOT NULL,
  PRIMARY KEY (`idEncomenda`),
  INDEX `fk_encomendas_clientes1_idx` (`idCliente` ASC),
  INDEX `fk_encomendas_codigos_postais1_idx` (`codpostal` ASC),
  INDEX `fk_encomendas_tipopag_loja1_idx` (`idTipoPagLoja` ASC),
  INDEX `fk_encomendas_tipoentr_loja1_idx` (`tipoentr_loja_idTipoEntrLoja` ASC),
  CONSTRAINT `fk_encomendas_clientes1`
    FOREIGN KEY (`idCliente`)
    REFERENCES `t1g1`.`clientes` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_encomendas_codigos_postais1`
    FOREIGN KEY (`codpostal`)
    REFERENCES `t1g1`.`codigos_postais` (`codPostal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_encomendas_tipopag_loja1`
    FOREIGN KEY (`idTipoPagLoja`)
    REFERENCES `t1g1`.`tipopag_loja` (`idTipoPagLoja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_encomendas_tipoentr_loja1`
    FOREIGN KEY (`tipoentr_loja_idTipoEntrLoja`)
    REFERENCES `t1g1`.`tipoentr_loja` (`idTipoEntrLoja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`corredor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`corredor` (
  `idCorredor` INT NOT NULL AUTO_INCREMENT COMMENT 'Codigo simplificado para identificar a categoria principal (\"corredor\") do produto.\nÉ chave principal da tabela.\n',
  `desigCorredor` VARCHAR(15) NOT NULL DEFAULT 'Corredor' COMMENT 'Designação reduzida do \"corredor\" que será usado para nos menus.\n',
  `descrCorredor` VARCHAR(60) NULL DEFAULT 'Sem descrição.' COMMENT 'Descrição completa da categoria principal (\"corredor\") dos produtos.',
  `imagem` VARCHAR(120) NULL DEFAULT 'default' COMMENT 'Imagem que surgirá associada ao \"Corredor\" nas aplicação.',
  `idloja` INT NOT NULL COMMENT 'Serve de ligação à tabela Loja.',
  PRIMARY KEY (`idCorredor`),
  UNIQUE INDEX `idCorredor_UNIQUE` (`idCorredor` ASC),
  INDEX `fk_corredor_loja1_idx` (`idloja` ASC),
  CONSTRAINT `fk_corredor_loja1`
    FOREIGN KEY (`idloja`)
    REFERENCES `t1g1`.`loja` (`idLoja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`prateleira`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`prateleira` (
  `idPrateleira` INT NOT NULL AUTO_INCREMENT COMMENT 'Código simplificado do sub-categoria (\"prateleira\") dos produtos.\nÉ chave principal da tabela conjuntamente com o idCorredor.',
  `idCorredor` INT NOT NULL COMMENT 'É chave estrangeira, que permite a ligação à tabela  e faz parte da chave primária desta tabela.\n\nLiga esta tabela à \"corredor\"',
  `desigPrateleira` VARCHAR(15) NOT NULL DEFAULT '\"Prateleira\"',
  `descrPrateleira` VARCHAR(60) NULL DEFAULT '\"Sem descrição.\"',
  `imagem` VARCHAR(120) NULL DEFAULT '\"default\"' COMMENT 'Imagem que surgirá associada à \"Prateleira\" na aplicação.',
  PRIMARY KEY (`idPrateleira`),
  INDEX `fk_Prateleira_Corredor1_idx` (`idCorredor` ASC),
  CONSTRAINT `fk_Prateleira_Corredor1`
    FOREIGN KEY (`idCorredor`)
    REFERENCES `t1g1`.`corredor` (`idCorredor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`marcas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`marcas` (
  `idMarca` INT NOT NULL AUTO_INCREMENT COMMENT 'Código identificativo da marca do produto. É Chave Principal e é auto incrementável.',
  `idLoja` INT NOT NULL COMMENT 'Permite ligar as marcas introduzida, e respectivos representantes a cada loja. ',
  `desigMarca` VARCHAR(20) NOT NULL COMMENT 'Designação da marca do produto.',
  `representante` VARCHAR(70) NULL COMMENT 'Nome do representante da marca com quem a loja trata.',
  `telefoneRepresentante` INT(15) NULL COMMENT 'Telefone do representante.',
  `emailRepresentante` VARCHAR(45) NULL COMMENT 'Email do representante.',
  `paginaMarca` VARCHAR(45) NULL COMMENT 'Pagina Web do representante.',
  `moradaRepresentante` VARCHAR(160) NULL COMMENT 'Morada do representante.',
  `codPostal` VARCHAR(8) NULL COMMENT 'Código postal do Representante.',
  PRIMARY KEY (`idMarca`),
  UNIQUE INDEX `idMarca_UNIQUE` (`idMarca` ASC),
  INDEX `fk_marcas_codigos_postais1_idx` (`codPostal` ASC),
  INDEX `fk_marcas_loja1_idx` (`idLoja` ASC),
  CONSTRAINT `fk_marcas_codigos_postais1`
    FOREIGN KEY (`codPostal`)
    REFERENCES `t1g1`.`codigos_postais` (`codPostal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_marcas_loja1`
    FOREIGN KEY (`idLoja`)
    REFERENCES `t1g1`.`loja` (`idLoja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`produtos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`produtos` (
  `idProduto` INT NOT NULL AUTO_INCREMENT COMMENT 'Codigo simplificado do produto. \nÉ chave primária da tabela e é auto incrementável.',
  `idPrateleira` INT NOT NULL,
  `desigProduto` VARCHAR(25) NOT NULL DEFAULT 'Produto' COMMENT 'Designação reduzida do produto que surgirá nas pesquisas.',
  `idMarca` INT NULL,
  `modelo` VARCHAR(40) NULL DEFAULT 'Não defenido' COMMENT 'Representa o modelo do produto (referência da marca ), quando exista. ',
  `informacaoProduto` VARCHAR(400) NULL DEFAULT 'Sem informações dísponiveis.' COMMENT 'Informação detalhada do produto.',
  `precoUnit` FLOAT NOT NULL COMMENT 'Preço de venda do produto. Preço sem iva.',
  `idTaxa` INT NOT NULL COMMENT 'Taxa de iva aplicável ao produto conforme tabela de taxas de iva.',
  `unid1` VARCHAR(4) NOT NULL DEFAULT 'Un.' COMMENT 'Unidade principal de venda e apresentação do produto.',
  `taxaconvercao` FLOAT NOT NULL DEFAULT 1 COMMENT 'Taxa de conversão para a unidade efectiva de venda.\n\nNo caso de produtos vendidos a peso, por vezes não é possivel fornecer um numero de unidades fisicas que correspondam à unidade de venda ( Kg ). Esta taxa de conversão permite corresponder o numero de unidades fisicas do produto ao valor unitário da unidade de venda, conforme o produto é exposto.\nO comprador irá receber o numero de unidades físicas do produto solicitadas.',
  `unid2` VARCHAR(4) NOT NULL DEFAULT 'Un.' COMMENT 'Unidade que o cliente irá utilizar na indicação da quantidade a adequirir.',
  `stockActual` FLOAT NULL DEFAULT 0 COMMENT 'Valor do Stock actualizado do produto.\n\nÉ incrementado nas reposições e decrementado quando confirmadas as encomendas. ',
  `stockMinimo` FLOAT NULL DEFAULT 1 COMMENT 'Stock registado como mínimo para o respectivo produto e serve de base ao planeamento das encomendas de produtos.\n',
  `imagemPesquisa` VARCHAR(120) NULL DEFAULT '\imagensloja\default.jpg' COMMENT 'Imagem do produto utilizada para apresentação nas pesquisas de produtos.\n\nQuando não é inserida imagem é apresentada a imagem por defeito.\n ',
  PRIMARY KEY (`idProduto`),
  UNIQUE INDEX `idProduto_UNIQUE` (`idProduto` ASC),
  INDEX `fk_produtos_prateleira1_idx` (`idPrateleira` ASC),
  INDEX `fk_produtos_marcas1_idx` (`idMarca` ASC),
  INDEX `fk_produtos_taxaivaproduto1_idx` (`idTaxa` ASC),
  CONSTRAINT `fk_produtos_prateleira1`
    FOREIGN KEY (`idPrateleira`)
    REFERENCES `t1g1`.`prateleira` (`idPrateleira`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_produtos_marcas1`
    FOREIGN KEY (`idMarca`)
    REFERENCES `t1g1`.`marcas` (`idMarca`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_produtos_taxaivaproduto1`
    FOREIGN KEY (`idTaxa`)
    REFERENCES `t1g1`.`taxaivaproduto` (`idTaxa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`detencomenda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`detencomenda` (
  `idDetEnc` INT NOT NULL AUTO_INCREMENT COMMENT 'Identifica a ordem dos vários produtos relativos a uma encomenda. é chave primária desta tabela conjuntamente com o idEncomenda.  ',
  `idEncomenda` INT NOT NULL COMMENT 'Identifica a encomenda que à qual pertence o detalhe.',
  `idProduto` INT NOT NULL COMMENT 'Identifica o produto relativo ao item do detalhe  da encomenda. ',
  `quantidade` FLOAT NOT NULL COMMENT 'Quantidade de produto adequirida neste item.',
  `precoVenda` FLOAT NOT NULL COMMENT 'Preço total do item da  encomenda, com o preço do produto há data da encomenda. Preço unitário x quantidade + iva. \n',
  `tIva` FLOAT NOT NULL COMMENT 'Representa o valor da taxa de iva à data da encomenda, do respectivo item.',
  PRIMARY KEY (`idDetEnc`),
  INDEX `fk_detencomenda_encomendas1_idx` (`idEncomenda` ASC),
  INDEX `fk_detencomenda_produtos1_idx` (`idProduto` ASC),
  CONSTRAINT `fk_detencomenda_encomendas1`
    FOREIGN KEY (`idEncomenda`)
    REFERENCES `t1g1`.`encomendas` (`idEncomenda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_detencomenda_produtos1`
    FOREIGN KEY (`idProduto`)
    REFERENCES `t1g1`.`produtos` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`seccao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`seccao` (
  `idSeccao` INT NOT NULL AUTO_INCREMENT,
  `desigSeccao` VARCHAR(15) NOT NULL,
  `descSeccao` VARCHAR(70) NULL,
  PRIMARY KEY (`idSeccao`),
  UNIQUE INDEX `idCorredor_UNIQUE` (`idSeccao` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`promocoes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`promocoes` (
  `idPromocao` INT NOT NULL AUTO_INCREMENT COMMENT 'Código Identificativo da Promoção. É Chave Primária da tabela e é  Auto incremental.',
  `desigPromocao` VARCHAR(25) NULL DEFAULT 'Sem designação.' COMMENT 'Designação da Promoção.\n',
  `descrPromocao` VARCHAR(60) NULL DEFAULT 'Sem descrição.' COMMENT 'Descrição da Promoção.\n',
  `precoPromocao` FLOAT NOT NULL COMMENT 'Preço que o produto obetem na promoção. Valor sem iva.',
  `dataInicio` DATETIME NOT NULL COMMENT 'Data de inicio da promoção.',
  `dataFim` DATETIME NOT NULL COMMENT 'Data de final da promoção.',
  `idProduto` INT NOT NULL COMMENT 'Código identificativo do produto em promoção. Permite a ligação à tabela de produtos.',
  `codFuncionario` INT NOT NULL COMMENT 'Código do funcionário que introduziu a promoção. Permite ligar à tabela de funcionários',
  PRIMARY KEY (`idPromocao`),
  UNIQUE INDEX `idPromocao_UNIQUE` (`idPromocao` ASC),
  INDEX `fk_promocoes_produtos1_idx` (`idProduto` ASC),
  INDEX `fk_promocoes_funcionarios1_idx` (`codFuncionario` ASC),
  CONSTRAINT `fk_promocoes_produtos1`
    FOREIGN KEY (`idProduto`)
    REFERENCES `t1g1`.`produtos` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_promocoes_funcionarios1`
    FOREIGN KEY (`codFuncionario`)
    REFERENCES `t1g1`.`funcionarios` (`codFuncionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`reposicao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`reposicao` (
  `idReposicao` INT NOT NULL AUTO_INCREMENT COMMENT 'Código identificatico da reposição de produtos. É Chave Primária da tabela e é auto incremental.',
  `quantidadeRep` FLOAT NOT NULL COMMENT 'Quantidade de produto reposta.',
  `dataReposicao` DATETIME NOT NULL COMMENT 'Data em que a reposição foi realizada.',
  `idProduto` INT NOT NULL COMMENT 'Código identificativo do produto reposto.',
  `codFuncionario` INT NOT NULL COMMENT 'Código identificativo do funcionários responsável pela reposição de stock.',
  PRIMARY KEY (`idReposicao`),
  UNIQUE INDEX `idReposicao_UNIQUE` (`idReposicao` ASC),
  INDEX `fk_reposicao_produtos1_idx` (`idProduto` ASC),
  INDEX `fk_reposicao_funcionarios1_idx` (`codFuncionario` ASC),
  CONSTRAINT `fk_reposicao_produtos1`
    FOREIGN KEY (`idProduto`)
    REFERENCES `t1g1`.`produtos` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reposicao_funcionarios1`
    FOREIGN KEY (`codFuncionario`)
    REFERENCES `t1g1`.`funcionarios` (`codFuncionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`estadosEncomendas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`estadosEncomendas` (
  `idEstado` INT NOT NULL AUTO_INCREMENT,
  `dsigEstado` VARCHAR(3) NOT NULL COMMENT 'Identificação de cada estado que a encomenta pode ter.\nÉ chave primária desta tabela.',
  `DescrEstado` VARCHAR(60) NOT NULL COMMENT 'Descrição do estado da encomenda associado ao respectivo idEstado. ',
  PRIMARY KEY (`idEstado`),
  UNIQUE INDEX `idEstado_UNIQUE` (`dsigEstado` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`estado_encomenda_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`estado_encomenda_data` (
  `idEstEncDat` INT NOT NULL,
  `idEncomenda` INT NOT NULL,
  `idEstado` INT NOT NULL,
  `dataEstado` DATETIME NOT NULL COMMENT 'Representa a data em que a encomenda passa ao respectivo estado.',
  `codFuncionario` INT NULL COMMENT 'Indica o código do funcionário verifica ou insere o estado da encomenda. ',
  PRIMARY KEY (`idEstEncDat`),
  INDEX `fk_estado_encomenda_data_estadosEncomendas1_idx` (`idEstado` ASC),
  INDEX `fk_estado_encomenda_data_encomendas1_idx` (`idEncomenda` ASC),
  CONSTRAINT `fk_estado_encomenda_data_estadosEncomendas1`
    FOREIGN KEY (`idEstado`)
    REFERENCES `t1g1`.`estadosEncomendas` (`idEstado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_estado_encomenda_data_encomendas1`
    FOREIGN KEY (`idEncomenda`)
    REFERENCES `t1g1`.`encomendas` (`idEncomenda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`subscricao_newsletter`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`subscricao_newsletter` (
  `idSubsc` INT NOT NULL AUTO_INCREMENT COMMENT 'Identifica a suscrição dentro da Base de Dados. É Chave Primária da tabela e é auto incremental.',
  `email` VARCHAR(50) NOT NULL COMMENT 'Nesta coluna são registados os emails dos subscritores da Newsletter.\n\nConsidera-se que um subscritor da Newsletter não necessita de estar registado como utilizador ou cliente da loja.\n\nO campo estado permite ativar ou desativar a subscrição.',
  `estado` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Estado em que se encontra a subscrição da Newsletter. (activa ou não activa).',
  `idLoja` INT NOT NULL COMMENT 'Serve de ligação à tabela loja.',
  PRIMARY KEY (`idSubsc`),
  INDEX `fk_subscricao_newsletter_loja1_idx` (`idLoja` ASC),
  CONSTRAINT `fk_subscricao_newsletter_loja1`
    FOREIGN KEY (`idLoja`)
    REFERENCES `t1g1`.`loja` (`idLoja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`avalcoment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`avalcoment` (
  `idAval` INT NOT NULL AUTO_INCREMENT COMMENT 'Código identificativo da avaliação e comentário. É Chave Primária da tabela e é auto incremental. ',
  `dataAval` DATETIME NOT NULL COMMENT 'Data da avaliação e comentário.',
  `idProduto` INT NOT NULL COMMENT 'Código identificativo do produto correspondente à avaliação e comentário. Permite fazer a ligação à tabela de produtos.',
  `idCliente` INT NOT NULL COMMENT 'Código identificativo cliente responsável pela avaliação e comentário. Permite fazer a ligação à tabela de clientes.',
  `aval` INT(1) NOT NULL DEFAULT 5 COMMENT 'Avaliação do produto a ser dada pelo cliente com os valores de 1,2,3,4,5. Caso não seja dada avaliação e seja feito apenas comentário é atribuído por defeito o valor \"0\", não entrando para as estatísticas de avaliação do produto. ',
  `comentario` VARCHAR(200) NULL COMMENT 'Comentário introduzido pelo utilizador e que será posteriormente validado por um funcionário da loja como moderação do conteúdo apresentado.',
  `validacao` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Estado do comentário. Valido (1)  se aceite para ser visualizado. Por defeito toma o valor de (0) até ver verificado pelo funcionário. ',
  `codFuncionario` INT NULL COMMENT 'Código do funcionário responsável pela validação dos comentários.',
  `obsValid` VARCHAR(200) NULL COMMENT 'Introdução de comentários que levaram à não validação do comentário.',
  `dataValid` DATETIME NULL COMMENT 'Data da validação da avaliação e comentário por um funcionário da loja.',
  PRIMARY KEY (`idAval`),
  UNIQUE INDEX `idavalcoment_UNIQUE` (`idAval` ASC),
  INDEX `fk_avalcoment_clientes1_idx` (`idCliente` ASC),
  INDEX `fk_avalcoment_funcionarios1_idx` (`codFuncionario` ASC),
  INDEX `fk_avalcoment_produtos1_idx` (`idProduto` ASC),
  CONSTRAINT `fk_avalcoment_clientes1`
    FOREIGN KEY (`idCliente`)
    REFERENCES `t1g1`.`clientes` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_avalcoment_funcionarios1`
    FOREIGN KEY (`codFuncionario`)
    REFERENCES `t1g1`.`funcionarios` (`codFuncionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_avalcoment_produtos1`
    FOREIGN KEY (`idProduto`)
    REFERENCES `t1g1`.`produtos` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`imagensprodutos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`imagensprodutos` (
  `numero` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Código de imagem que permite pesquisa directa.\nÉ auto incrementável.',
  `idProduto` INT NOT NULL,
  `imagem` VARCHAR(120) NOT NULL DEFAULT '\imagensloja\default.jpg' COMMENT 'Caminho para a imagem.\nCaso não exista imagem a aplicação deverá reconhecer \'default\' para apresentar imagem defenida por defeito. \n',
  `comentario` VARCHAR(60) NULL DEFAULT 'Sem comentário.' COMMENT 'Descrição da imagem que surgirá quando solicitado.',
  PRIMARY KEY (`numero`),
  INDEX `fk_imagensprodutos_produtos1_idx` (`idProduto` ASC),
  CONSTRAINT `fk_imagensprodutos_produtos1`
    FOREIGN KEY (`idProduto`)
    REFERENCES `t1g1`.`produtos` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`depcontactos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`depcontactos` (
  `iddep` INT NOT NULL AUTO_INCREMENT COMMENT 'Código identificativo de cada departamento da loja.',
  `idLoja` INT NOT NULL COMMENT 'Código identificativo da Loja. É Chave Principal da tabela  cojuntamente com o código de departamento.',
  `desigDep` VARCHAR(30) NULL COMMENT 'Designação do Departamento.',
  `telefone` INT(15) NULL COMMENT 'Numero de telefone relativo ao Departamento.',
  `telemovel` INT(15) NULL COMMENT 'Numero de telemóvel relativo ao Departamento.',
  `email` VARCHAR(50) NULL COMMENT 'Endereço de Email do Departamento.',
  PRIMARY KEY (`iddep`),
  UNIQUE INDEX `desigTipoContacto_UNIQUE` (`desigDep` ASC),
  INDEX `fk_depcontactos_loja1_idx` (`idLoja` ASC),
  CONSTRAINT `fk_depcontactos_loja1`
    FOREIGN KEY (`idLoja`)
    REFERENCES `t1g1`.`loja` (`idLoja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`tipofoto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`tipofoto` (
  `idTipoFoto` INT NOT NULL AUTO_INCREMENT COMMENT 'É Chave Primária e Autoincrementavel. ',
  `codTipo` VARCHAR(15) NOT NULL COMMENT 'Código a tipologia de imagem da loja. ',
  `DescrTipo` VARCHAR(60) NULL COMMENT 'Descrição do tipo de fotografia da Loja.',
  PRIMARY KEY (`idTipoFoto`),
  UNIQUE INDEX `idtipo_UNIQUE` (`idTipoFoto` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `t1g1`.`fotosloja`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t1g1`.`fotosloja` (
  `idFoto` INT NOT NULL AUTO_INCREMENT COMMENT 'Código de identificação da imagem da loja. É Chave Primária da tabela e auto incrementavel.',
  `data` DATETIME NULL COMMENT 'Data em que foi inserida a imagem.',
  `descricao` VARCHAR(60) NULL COMMENT 'Descrição da imagem.',
  `idLoja` INT NOT NULL COMMENT 'Código identificativo da loja.',
  `idTipoFoto` INT NOT NULL COMMENT 'Identifica o tipo da foto. Liga à tabela de tipofoto.',
  PRIMARY KEY (`idFoto`),
  INDEX `fk_fotosloja_loja1_idx` (`idLoja` ASC),
  INDEX `fk_fotosloja_tipofoto1_idx` (`idTipoFoto` ASC),
  CONSTRAINT `fk_fotosloja_loja1`
    FOREIGN KEY (`idLoja`)
    REFERENCES `t1g1`.`loja` (`idLoja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fotosloja_tipofoto1`
    FOREIGN KEY (`idTipoFoto`)
    REFERENCES `t1g1`.`tipofoto` (`idTipoFoto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
