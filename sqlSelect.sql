-- https://github.com/ChristoferLv/TrabalhoBD

-- 1) Selecione os professores que deram aula para uma turma com nível maior que 4A
-- ou tem nota TOEFL maior ou igual que 110.
select U.nome, U.cpf
FROM usuario_professora P, USUARIO U
WHERE P.cpf = U.cpf
AND P.nivelTOEFL >= 110
UNION
(select U2.nome, U2.cpf
FROM usuario_professora P2, USUARIO U2, TURMA T2, AULA A
WHERE P2.cpf = U2.cpf AND P2.cpf = A.professora AND T2.nomeDaTurma = A.turma
AND T2.nivel >= '4A');
-- 2) Selecione a professora que aplicou as provas com maior media.
select U.nome
from USUARIO U 
where U.cpf IN (
select cpfProfessora
from(
select MAX(medias.notasMedias), cpfProfessora
from(select AVG(P.nota) as notasMedias, UP2.cpf as cpfProfessora
from PROVA P, USUARIO_PROFESSORA UP2
Where P.professora = UP2.cpf
group by UP2.cpf) as medias)as cpfs);

-- 3) Selecione os alunos que tiveram prova aplicada pelo professor Abe Morrowe.
select U1.cpf
from USUARIO_ALUNO A, USUARIO U1, aluno_faz_prova AFP, PROVA P
where P.idProva = AFP.idProva AND AFP.cpfAluno = A.cpf AND A.cpf = U1.cpf
AND P.idProva IN
(select P.idProva
from USUARIO_PROFESSORA UP, USUARIO U2, PROVA P
where UP.cpf = U2.cpf AND P.professora = U2.cpf AND U2.nome = 'Abe Morrowe');

-- 4) Selecione os aluno que tiveram aula com o prefessor Abe Morrowe.
select U1.cpf
from USUARIO_ALUNO A, USUARIO U1, TURMA T
where A.cpf = U1.cpf AND T.nomeDaTurma = A.turma
AND T.nomeDaTurma IN
(select T.nomeDaTurma
from USUARIO_PROFESSORA UP, USUARIO U2, AULA A, TURMA T
where UP.cpf = U2.cpf AND A.professora = U2.cpf AND T.nomeDaTurma = A.turma AND U2.nome = 'Abe Morrowe');

-- 5) Selecione o aluno com a avaliação de 'very good' para a competencia 'Writing/grammar' 
-- que estudou com o professor 'Abe Morrowe'.
select U.nome
from USUARIO U, USUARIO_ALUNO UA, aluno_tem_avaliacao ATA
where U.cpf = UA.cpf AND ATA.cpfAluno = UA.cpf
AND ATA.nomeAvaliacao = 'Very good' AND ATA.nomeCompetencia = 'Writing/grammar'
AND U.cpf IN
(select U1.cpf
from USUARIO U1, USUARIO U2, usuario_aluno UA, TURMA T, AULA A, usuario_professora UP
where U1.cpf = UA.cpf AND U1.cpf != U2.cpf AND U2.cpf = UP.cpf
AND UA.turma = T.nomeDaTurma AND A.turma = T.nomeDaTurma AND A.professora = UP.cpf AND U2.nome = 'Abe Morrowe');

-- 6) Selecione o professro que não aplicou nenhuma prova.
select UP.cpf
from USUARIO_PROFESSORA UP
where not exists (
select idProva
from PROVA
where idProva in (
select idProva
from PROVA
where professora = UP.cpf));

-- 7) Selecione as professoras que deram alguma aula mas deram aulas apenas para turmas com nivel menor que 3B.
select distinct UP.cpf
from USUARIO_PROFESSORA UP, AULA A, TURMA T
where UP.cpf = A.professora AND A.turma = T.nomeDaTurma
AND UP.cpf NOT IN(
select UP.cpf
from USUARIO_PROFESSORA UP, AULA A, TURMA T
where UP.cpf = A.professora AND A.turma = T.nomeDaTurma
AND T.nivel < '3B');

-- 8) Selecione das professoras responsaveis por alguma turma que tem a menor nota TOEFL
select UP.cpf
from USUARIO_PROFESSORA UP, TURMA T
where T.professoraResponsavel = UP.cpf
AND UP.nivelTOEFL <= ALL (
select UP2.nivelTOEFL
from usuario_professora UP2);

-- 9) Selecione o nome e o numero dos pais dos alunos que tiverem nota menor que 6.5 na prova, 
-- ou que tem alguma competencia com avaliação igual a 'Poor'.
select R.nome, R.contato
from RESPONSAVEL R, USUARIO_ALUNO UA, ALUNO_TEM_AVALIACAO ATA
where R.cpf = UA.cpfResponsavel AND ATA.cpfAluno = UA.cpf
AND ATA.nomeAvaliacao = 'Poor'
UNION
(select R.nome, R.contato
from RESPONSAVEL R, USUARIO_ALUNO UA, aluno_faz_prova AFP, PROVA P
where R.cpf = UA.cpfResponsavel AND AFP.cpfAluno = UA.cpf AND P.idProva = AFP.idProva
AND P.nota < 6.5);

-- 10) Selecione os professores responsaveis que não aplicaram prova.
select distinct UP.cpf
from USUARIO_PROFESSORA UP, TURMA T
where UP.cpf = T.professoraResponsavel
AND UP.cpf NOT IN
(
select UP.cpf
from USUARIO_PROFESSORA UP
where not exists (
select idProva
from PROVA
where idProva in (
select idProva
from PROVA
where professora = UP.cpf))
);

