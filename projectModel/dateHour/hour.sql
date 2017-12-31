/*
Gerando a dimensão Hora
Segue um exemplo de Script que você pode utilizar para gerar a dimensão Hora:
*/

DECLARE @hora TIME
SET NOCOUNT ON

SET @hora = '00:00:00'

--drop table dimHora

CREATE TABLE dbo.dimHora(
       idHora time(7) NOT NULL,
       Hora tinyint NOT NULL,
       Minuto tinyint NOT NULL,
       Segundo tinyint NOT NULL
)  ON [PRIMARY]

ALTER TABLE dbo.dimHora ADD CONSTRAINT
       PK_Table_2 PRIMARY KEY CLUSTERED
       (idHora) 
WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

 
WHILE @hora <> '23:59:59'
BEGIN  

      insert into dimHora
      values(@hora, DATEPART(hour,@hora), DATEPART(minute,@hora), DATEPART(second,@hora) )
 select @hora = DATEADD(second,1,@hora)
END  

   insert into dimHora
     values(@hora, DATEPART(hour,@hora), DATEPART(minute,@hora), DATEPART(second,@hora) )
       select * from dbo.dimHora