CREATE TABLE publicacao 
  ( 
     issn    VARCHAR(50) PRIMARY KEY, 
     titulop VARCHAR(50) NOT NULL, 
     editor  VARCHAR(50), 
     url     VARCHAR(100) 
  ); 

CREATE TABLE area 
  ( 
     areaid     NUMBER PRIMARY KEY, 
     descricaoa VARCHAR(50) NOT NULL 
  ); 

CREATE TABLE artigo 
  ( 
     artigoid        NUMBER PRIMARY KEY, 
     tituloa         VARCHAR(50) NOT NULL UNIQUE, 
     issn            VARCHAR(50) NOT NULL, 
     ano             NUMBER, 
     numerodepaginas NUMBER CHECK(numerodepaginas > 0), 
     areaid          NUMBER, 
     CONSTRAINT fk_areaid_area FOREIGN KEY(areaid) REFERENCES area(areaid), 
     CONSTRAINT fk_issn_publicacao FOREIGN KEY(issn) REFERENCES publicacao(issn) 
  ); 

CREATE TABLE palavrachave 
  ( 
     pc          NUMBER PRIMARY KEY, 
     descricaopc VARCHAR(50) 
  ); 

CREATE TABLE artigopc 
  ( 
     artigoid NUMBER, 
     pc       NUMBER, 
     --CONSTRAINT pkartigopc PRIMARY KEY(artigoid), REMOVER
     CONSTRAINT fk_artigoid_artigo FOREIGN KEY(artigoid) REFERENCES artigo( 
     artigoid), 
     CONSTRAINT fk_pc_palavrachave FOREIGN KEY(pc) REFERENCES palavrachave(pc) 
  ); 

INSERT INTO publicacao 
VALUES     ('2515-8761', 
            'Brazilian Journal of Development', 
            'Brazilian Journals Publicações', 
            'https://www.brazilianjournals.com/'); 

INSERT INTO publicacao 
VALUES     ('1041-4347', 
            'IEEE Transactions', 
            'IEEE', 
            'https://www.computer.org/csdl/journal/tk'); 

INSERT INTO publicacao 
VALUES     ('0007-6813', 
            'Business Horizons', 
            'Kelley School of Business', 
            'https://www.sciencedirect.com/journal/business-horizons/'); 

INSERT INTO area VALUES   (10,'Banco de Dados'); 

INSERT INTO area VALUES  (20,'Inteligência Artificial');
 
INSERT INTO artigo VALUES  (1,'ConceptER - Modelo Entidade-Relacionamento','2515-8761',2020,NULL,10); 

-- ERRO DE CHECK
INSERT INTO artigo VALUES  (2,'Database Meets Artificial Intelligence','2515-8761',2020,0,10); 

-- ERRO DE CHECK - Corrigido
INSERT INTO artigo VALUES  (2,'Database Meets Artificial Intelligence','2515-8761',2020,100,10); 

INSERT INTO artigo VALUES  (3,'Artificial intelligence: innovation typology','0007-6813',2020,9,20); 

INSERT INTO palavrachave VALUES  (100,'Banco de Dados'); 

INSERT INTO palavrachave VALUES  (200,'Inteligência Artificial'); 

INSERT INTO palavrachave VALUES  (300,'DER'); 

INSERT INTO palavrachave VALUES  (400,'SQL'); 

INSERT INTO palavrachave VALUES  (500,'scripts'); 

INSERT INTO palavrachave VALUES  (600,'Aprendizado de Máquina'); 

INSERT INTO palavrachave VALUES  (700,'Tomada de Decisão'); 

INSERT INTO artigopc VALUES  (1,100); 

INSERT INTO artigopc VALUES  (2,300); 

INSERT INTO artigopc VALUES  (1, 400); 

INSERT INTO artigopc VALUES  (1, 500); 

INSERT INTO artigopc VALUES  (2,100); 

INSERT INTO artigopc VALUES  (2,200); 

INSERT INTO artigopc VALUES  (3,200); 

INSERT INTO artigopc VALUES  (3,  600); 

INSERT INTO artigopc  VALUES  (3,  700); 

--Chegagem das tabelas
SELECT * FROM artigo;

SELECT * FROM area;

SELECT * FROM palavrachave;

SELECT * FROM artigopc;

SELECT * FROM publicacao;

--Selecionar o título e número de páginas dos os artigos cadastrados.
SELECT tituloa, numerodepaginas FROM artigo;

--Selecionar os título dos artigos da área de 'Banco de Dados'.
SELECT tituloa FROM artigo
JOIN area ON artigo.areaid = area.areaid
WHERE area.descricaoa = 'Banco de Dados';

--Selecionar os títulos dos artigos que têm a palavra chave 'Banco de Dados'. Faça a busca utilizando a tabela "palavrachave".
SELECT artigo.tituloa FROM artigo
JOIN artigopc ON artigo.artigoid = artigopc.artigoid
JOIN palavrachave ON artigopc.pc = palavrachave.pc
WHERE palavrachave.descricaoa = 'Banco de Dados';

--Selecionar a quantidade de palavras chave de cada artigo. Para cada artigo, devem ser apresentados o ID do artigo e a quantidade de palavras do artigo.
SELECT artigo.artigoid,
COUNT (palavrachave.pc)
FROM artigo JOIN artigopc ON artigo.artigoid = artigopc.artigoid
JOIN palavrachave ON artigopc.pc = palavrachave.pc
GROUP BY artigo.artigoid;

--Selecionar a quantidade de artigos cadastrados para cada palavra chave também cadastrada. Para cada palavra chave, devem ser apresentadas a descrição da palavra chave e a quantidade de artigos que a palavra chave possui.
SELECT palavrachave.descricaopc,
COUNT(artigo.artigoid)
FROM artigo 
JOIN artigopc ON artigo.artigoid = artigopc.artigoid
JOIN palavrachave ON artigopc.pc = palavrachave.pc
GROUP BY palavrachave.descricaopc;

--Selecionar os títulos dos artigos que foram cadastrados sem o seu número de páginas.
SELECT tituloa FROM artigo
WHERE numerodepaginas IS NULL;

--Imagine que você quer ter uma ideia do número total de páginas que terá que ler dos artigos da área 'Banco de Dados'. Selecione o número total de páginas dos artigos da área 'Banco de Dados'.
SELECT SUM(numerodepaginas) AS numerototaldepaginas
FROM artigo 
JOIN area ON artigo.areaid = area.areaid
WHERE area.descricao = 'Banco de Dados';