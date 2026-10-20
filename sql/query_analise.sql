--Analisando todos os datdos das tabelas
SELECT TOP 10 * FROM cursos;
SELECT TOP 10 * FROM alunos;
SELECT TOP 10 * FROM matriculas;

--Contando todas as linhas
SELECT COUNT(*) AS total_matriculas FROM matriculas;

--Contado quantas matriculas tem em cada status
SELECT status, COUNT(*) AS qtd
FROM matriculas
GROUP BY status;

--Valor total
SELECT SUM(valor_pago) AS receita_total
FROM matriculas
WHERE status <> 'Cancelado';

--Quantas matriculas tem por cada forma de pagamento
select
	forma_pagamento,
	count(matricula_id) as qtd
from matriculas
group by forma_pagamento;

--Analisando valor pago por cada curso
SELECT TOP 10
       m.matricula_id,
       c.nome_curso,
       m.valor_pago
FROM matriculas m
INNER JOIN cursos c 
ON c.curso_id = m.curso_id;

--Analisando receita por curso
SELECT c.nome_curso,
    COUNT(*) as qtd_matriculas,
    SUM(m.valor_pago) as receita
from matriculas m
JOIN cursos c
ON m.curso_id = c.curso_id
where m.status<> 'Cancelado'
group by c.nome_curso
order by receita desc;

--Analisando receita por categoria
select c.categoria,
    count(*) as qtd_matriculas,
    sum(m.valor_pago) as receita
from matriculas m
join cursos c
on m.curso_id = c.curso_id
where m.status <> 'Cancelado'
group by c.categoria
order by receita desc;

--Analisando receita por estado
select
    a.estado,
    count(*) as qtd_matriculas,
    sum(m.valor_pago) as receita
from matriculas m
join alunos a
on m.aluno_id = a.aluno_id
where m.status <> 'Cancelado'
group by a.estado
order by receita desc

--Analisando receita por data
select month(data_matricula) as mes,
    count(*) as qtd_matricula,
    sum(valor_pago) as receita
from matriculas
where status <> 'Cancelado'
group by month(data_matricula)
order by mes 

--Analisando receita do mes 10 e mes 11
select month(data_matricula) as mes,
    count(*) as qtd_matriculas,
    round(sum(valor_pago),2) as receita,
    round(avg(valor_pago),2) as media_paga
from matriculas
where status <> 'Cancelado'
    and month(data_matricula) in (10, 11)
group by month(data_matricula)

--Analisando desconto por mes
SELECT MONTH(m.data_matricula) AS mes,
       ROUND(AVG(1 - m.valor_pago / c.preco) * 100, 1) AS desconto_medio_pct
FROM matriculas m
JOIN cursos c ON c.curso_id = m.curso_id
WHERE m.status <> 'Cancelado'
GROUP BY MONTH(m.data_matricula)
ORDER BY mes;

--Taxa de cancelamento 
select c.nome_curso,
    count(*) as qtd_matriculas,
    sum(case when m.status = 'Cancelado' then 1 else 0 end) as cancelados,
    round(100.0 * sum(case when m.status = 'Cancelado' then 1 else 0 end)
        / count(*), 1) as pct_cancelamento
from matriculas m
join cursos c
on c.curso_id = m.curso_id
group by c.nome_curso
order by pct_cancelamento desc