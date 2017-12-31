CREATE DATABASE OLTP
GO
 
USE OLTP
GO 
 
CREATE TABLE CLIENTES ( 
    ID INT NOT NULL IDENTITY (1,1),
    NOME VARCHAR(25),
    CPF VARCHAR(14),
    EMAIL VARCHAR(25),
    DDD CHAR(2),
    TELEFONE CHAR(8),
    DATA_CADASTRO DATE)
GO

CREATE DATABASE OLAP
GO
  
USE OLAP
GO 
 
CREATE TABLE DM_CLIENTES ( 
     SK NOT NULL IDENTITY (1,1), 
     ID INT NOT NULL,
     NOME VARCHAR(25),
     CPF VARCHAR(14),
     EMAIL VARCHAR(25),
     DDD CHAR(2),
     TELEFONE CHAR(8),
     DATA_INICIO DATE
     DATA_FIM DATE )
GO

DECLARE @n INT, @n1 INT, @n2 INT, @n3 INT, @n4 INT, 
        @n5 INT, @n6 INT, @n7 INT, @n8 INT, @n9 INT
DECLARE @d1 INT, @d2 INT
DECLARE @nome VARCHAR(21), @email VARCHAR(20), @cpf VARCHAR(14) 
DECLARE @ddd CHAR(2), @telefone CHAR(8)
DECLARE @data DATE
DECLARE @contador INT
 
SET @contador = 0
 
WHILE @contador < 500000
 
BEGIN  
-- Gera nome do cliente aleatório.
SET @nome = SUBSTRING(CONVERT(VARCHAR(40), NEWID()),0,21);
 
-- Gera CPF do cliente aleatório.
SET @n = 9;
SET @n1 = CAST((@n + 1) * RAND(CAST(NEWID() AS VARBINARY )) AS INT)
SET @n2 = CAST((@n + 1) * RAND(CAST(NEWID() AS VARBINARY )) AS INT)
SET @n3 = CAST((@n + 1) * RAND(CAST(NEWID() AS VARBINARY )) AS INT)
SET @n4 = CAST((@n + 1) * RAND(CAST(NEWID() AS VARBINARY )) AS INT)
SET @n5 = CAST((@n + 1) * RAND(CAST(NEWID() AS VARBINARY )) AS INT)
SET @n6 = CAST((@n + 1) * RAND(CAST(NEWID() AS VARBINARY )) AS INT)
SET @n7 = CAST((@n + 1) * RAND(CAST(NEWID() AS VARBINARY )) AS INT)
SET @n8 = CAST((@n + 1) * RAND(CAST(NEWID() AS VARBINARY )) AS INT)
SET @n9 = CAST((@n + 1) * RAND(CAST(NEWID() AS VARBINARY )) AS INT)
SET @d1 = @n9*2+@n8*3+@n7*4+@n6*5+@n5*6+@n4*7+@n3*8+@n2*9+@n1*10;
SET @d1 = 11 - (@d1%11);
 
IF (@d1 >= 10) 
SET @d1 = 0
SET @d2 = @d1*2+@n9*3+@n8*4+@n7*5+@n6*6+@n5*7+@n4*8+@n3*9+@n2*10+@n1*11;
SET @d2 = 11 - ( @d2%11 );
 
IF (@d2 >= 10) 
SET @d2 = 0;
SET @cpf = CAST(@n1 AS VARCHAR(1)) + 
CAST(@n2 AS VARCHAR(1)) + 
CAST(@n3 AS VARCHAR(1)) + '.' + 
CAST(@n4 AS VARCHAR(1)) + 
CAST(@n5 AS VARCHAR(1)) + 
CAST(@n6 AS VARCHAR(1)) + '.' +
CAST(@n7 AS VARCHAR(1)) + 
CAST(@n8 AS VARCHAR(1)) + 
CAST(@n9 AS VARCHAR(1)) + '-' +
CAST(@d1 AS VARCHAR(1)) + 
45 CAST(@d2 AS VARCHAR(1))
 
-- Gera email do cliente aleatório.
SET @email = SUBSTRING(CONVERT(varchar(40), NEWID()),0,11) + 
'@email.com';
 
-- Gera data de cadastro do cliente aleatória.
SET @data = CONVERT(DATE, CONVERT(VARCHAR(15),'2013-'
+CONVERT(VARCHAR(5),(CONVERT(INT,RAND()*12))+1) + '-' + 
CONVERT(VARCHAR(5),(CONVERT(INT,RAND()*27))+1) ))
 
-- Gera DDD do cliente aleatório.
SET @ddd = CAST(@n8 AS VARCHAR(1)) +
CAST(@n4 AS VARCHAR(1))
 
-- Gera telefone do cliente aleatório.
SET @telefone = CAST(@n6 AS VARCHAR(1)) +
CAST(@n9 AS VARCHAR(1)) +
CAST(@n2 AS VARCHAR(1)) + 
CAST(@n4 AS VARCHAR(1)) +
CAST(@n1 AS VARCHAR(1)) +
CAST(@n5 AS VARCHAR(1)) +
CAST(@n8 AS VARCHAR(1)) +
CAST(@n3 AS VARCHAR(1)) 
 
-- Popula a tabela Clientes.
INSERT INTO CLIENTES VALUES (
    @nome ,
    @cpf ,
    @email ,
    @ddd ,
    @telefone ,
    @data )
 
SET @contador = @contador + 1 
 
END