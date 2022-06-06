-- https://github.com/ChristoferLv/TrabalhoBD

drop table if exists ESCALA_DE_NOTAS, ENDERECO, CREDENCIAIS, USUARIO, USUARIO_SECRETARIA, USUARIO_PROFESSORA, USUARIO_ALUNO, TURMA, AULA, PROVA, ALUNO_FAZ_PROVA, AVALIACAO_DAS_COMPETENCIAS;

CREATE TABLE ESCALA_DE_NOTAS (
    valor INTEGER PRIMARY KEY,
    descricao VARCHAR(20)
);

create table ENDERECO(
	idEndereco integer auto_increment primary key,
    bairro varchar(50),
    logradouro varchar(100),
    complemento varchar(70)
);

CREATE TABLE CREDENCIAIS (
    login VARCHAR(40) unique PRIMARY KEY,
    senha VARCHAR(15),
    emailRecuperacao VARCHAR(40) unique
);

CREATE TABLE USUARIO (
    cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(100),
    dataNascimento DATE,
    endereco integer,
    login VARCHAR(40) UNIQUE,
    FOREIGN KEY (login) REFERENCES CREDENCIAIS (login) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (endereco) REFERENCES ENDERECO (idEndereco)
);

CREATE TABLE USUARIO_SECRETARIA (
    cpf CHAR(11) PRIMARY KEY,
    folhaDePagamento VARCHAR(20),
    telefoneDeContato CHAR(13),
    dataContratacao DATE,
    FOREIGN KEY (cpf)
        REFERENCES USUARIO (cpf) ON UPDATE CASCADE ON DELETE CASCADE
);

create table USUARIO_PROFESSORA(
	cpf char(11) primary key,
    folhaDePagamento varchar(20),
    dataContratacao DATE,
    nivelTOEFL char(2),
    foreign key (cpf) REFERENCES USUARIO(cpf) ON UPDATE CASCADE ON DELETE CASCADE
);

create table TURMA (
    nomeDaTurma varchar(50) primary key,
    nivel varchar(20),
    numeroDeAlunos integer,
    dataDeAbertura date
);

create table AULA(
	idAula integer auto_increment primary key,
    conteudo varchar(100),
    anotacoes text,
    paginasTarefas varchar(100),
    dataDaAula date,
    turma varchar(50),
    professora char(11),
    foreign key (professora) REFERENCES USUARIO_PROFESSORA(cpf),
    foreign key (turma) REFERENCES TURMA(nomeDaTurma)
);

create table USUARIO_ALUNO(
    cpf char(11) primary key,
    nomeResponsavel varchar(100),
    telefoneDeContato char(13),
    nivel varchar(20),
    turma varchar(50),
    foreign key (cpf) REFERENCES USUARIO(cpf),
    foreign key (turma) REFERENCES TURMA(nomeDaTurma)
);

create table PROVA(
	idProva integer auto_increment primary key,
	num_prova integer,
    nota real,
    dataDaProva date
);

create table ALUNO_FAZ_PROVA(
	cpfAluno char(11),
    idProva integer,
    primary key(cpfAluno, idProva),
    foreign key(cpfALuno) REFERENCES USUARIO_ALUNO(cpf),
    foreign key(idProva) REFERENCES PROVA(idProva)
);

create table AVALIACAO_DAS_COMPETENCIAS(
	id integer auto_increment primary key,
    nomeDaCompetencia varchar(20),
    periodo integer,
    dataEmissao date,
    aluno char(11),
    valor integer,
    foreign key (aluno) REFERENCES USUARIO_ALUNO(cpf),
    foreign key (valor) REFERENCES ESCALA_DE_NOTAS(valor)
);

