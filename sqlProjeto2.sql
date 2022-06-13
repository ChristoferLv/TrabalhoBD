-- https://github.com/ChristoferLv/TrabalhoBD

drop table if exists ALUNO_TEM_AVALIACAO, RESPONSAVEL, COMPETENCIA, AVALIACAO, COMPETENCIA_COM_AVALIACAO, ENDERECO, CREDENCIAIS, USUARIO, USUARIO_SECRETARIA, USUARIO_PROFESSORA, USUARIO_ALUNO, TURMA, AULA, PROVA, ALUNO_FAZ_PROVA;

create table COMPETENCIA(
	nome varchar(20) primary key
);

create table AVALIACAO(
    nome varchar(20) primary key
);

create table COMPETENCIA_COM_AVALIACAO(
    nomeCompetencia varchar(20),
    nomeAvaliacao varchar(20),
    primary key (nomeCompetencia, nomeAvaliacao),
    foreign key (nomeAvaliacao) REFERENCES AVALIACAO(nome),
    foreign key (nomeCompetencia) REFERENCES COMPETENCIA(nome)
);

CREATE TABLE CREDENCIAIS (
    login VARCHAR(40) unique PRIMARY KEY,
    senha VARCHAR(25),
    emailRecuperacao VARCHAR(40) unique
);

CREATE TABLE USUARIO (
    cpf CHAR(14) PRIMARY KEY,
    nome VARCHAR(100),
    dataNascimento DATE,
    login VARCHAR(40) UNIQUE,
    FOREIGN KEY (login) REFERENCES CREDENCIAIS (login)
);

create table ENDERECO(
	idEndereco integer auto_increment,
    cpfUsuario char(14),
    bairro varchar(50),
    logradouro varchar(100),
    complemento varchar(70),
    primary key (idEndereco, cpfUsuario),
    foreign key (cpfUsuario) REFERENCES USUARIO(cpf) ON DELETE CASCADE
);

CREATE TABLE USUARIO_SECRETARIA (
    cpf CHAR(14) PRIMARY KEY,
    folhaDePagamento VARCHAR(20),
    telefoneDeContato VARCHAR(20),
    dataContratacao DATE,
    FOREIGN KEY (cpf)
        REFERENCES USUARIO (cpf) ON UPDATE CASCADE ON DELETE CASCADE
);

create table USUARIO_PROFESSORA(
	cpf char(14) primary key,
    folhaDePagamento varchar(20),
    dataContratacao DATE,
    nivelTOEFL integer,
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

create table RESPONSAVEL(
	cpf char(14) primary key,
    nome varchar(100),
    contato varchar(20)
);

create table USUARIO_ALUNO(
    cpf char(14) primary key,
    cpfResponsavel char(14),
    telefoneDeContato VARCHAR(20),
    nivel varchar(20),
    turma varchar(50),
    foreign key (cpf) REFERENCES USUARIO(cpf),
    foreign key (cpfResponsavel) REFERENCES RESPONSAVEL(cpf),
    foreign key (turma) REFERENCES TURMA(nomeDaTurma)
);

create table PROVA(
	idProva integer auto_increment primary key,
	professora char(14),
    num_prova integer,
    nota real,
    dataDaProva date,
    foreign key (professora) REFERENCES USUARIO_PROFESSORA(cpf)
);

create table ALUNO_FAZ_PROVA(
	cpfAluno char(14),
    idProva integer,
    primary key(cpfAluno, idProva),
    foreign key(cpfALuno) REFERENCES USUARIO_ALUNO(cpf),
    foreign key(idProva) REFERENCES PROVA(idProva)
);

create table ALUNO_TEM_AVALIACAO(
	cpfAluno char(14),
    nomeAvaliacao varchar(20),
    nomeCompetencia varchar(20),
    dataEmissao date,
    periodo integer,
    primary key (cpfAluno, nomeAvaliacao, nomeCompetencia),
    foreign key (cpfAluno) REFERENCES USUARIO_ALUNO(cpf),
    foreign key (nomeAvaliacao, nomeCompetencia) REFERENCES COMPETENCIA_COM_AVALIACAO(nomeAvaliacao, nomeCompetencia)
);



