
-- TRANSFORMACION
--Creación de tabla de DW: Para elegir las columnas que vamos a utilizar
--ventas

USE DB_Local;
GO

--ventas
IF OBJECT_ID('DWVentas', 'U') IS NOT NULL

BEGIN

    DROP TABLE DWVentas;
END;
GO
	CREATE TABLE DWVentas(
	 [Venta_ID]       int IDENTITY(1,1) PRIMARY KEY
	,[Cliente_ID]     smallint not null
	,[Producto_ID]    smallint not null
	,[Fecha_id]       int not null
	,[Cantidad]       float not null
	,[Total]          float not null
	);
	GO

--clientes

IF OBJECT_ID('DWClientes', 'U') IS NOT NULL
BEGIN

   DROP TABLE DWClientes;
END;
GO

    CREATE TABLE DWClientes(
    [Cliente_ID]     smallint not null
   ,[Ciudad]         nvarchar(50) not null
   ,[País]           nvarchar(50) not null
  
   );
GO

--productos
IF OBJECT_ID('DWProductos', 'U') IS NOT NULL
BEGIN 

   DROP TABLE DWProductos;
END;
GO

    CREATE TABLE DWProductos(
    [Producto_ID]        smallint not null
   ,[Nombre_Producto]    nvarchar (50) not null
   ,[Categoría]          nvarchar(50) not null
   ,[Precio]             float not null
   );
GO

--INSERCION 
--USo de tablas temporal Ventas 

WITH
VENTAS AS
(
     SELECT 
           [Cliente_ID]     
          ,[Producto_ID]
          ,[Fecha_id] = CONCAT(
		                     YEAR(Fecha),
							 CASE
							      WHEN MONTH(Fecha) < 10 THEN CONCAT('0', CONVERT(NVARCHAR,MONTH(Fecha)))
								  ELSE CONVERT(NVARCHAR,MONTH(Fecha))
							   END
							 ,CASE
							      WHEN DAY(Fecha) < 10 THEN CONCAT('0',CONVERT(NVARCHAR,DAY(Fecha)))
								  ELSE CONVERT(NVARCHAR,DAY(Fecha))
							   END
							   )
          ,[Cantidad]=SUM([Cantidad])
		  ,[Total]=SUM([Total])
		  FROM dbo.ventas
		  GROUP BY 
               [Cliente_ID]
			  ,[Producto_ID]
			  ,CONCAT (
			           YEAR(Fecha)
							 ,CASE
							      WHEN MONTH(Fecha) < 10 THEN CONCAT('0', CONVERT(NVARCHAR,MONTH(Fecha)))
								  ELSE CONVERT(NVARCHAR,MONTH(Fecha))
							   END
							 ,CASE
							      WHEN DAY(Fecha) < 10 THEN CONCAT('0',CONVERT(NVARCHAR,DAY(Fecha)))
								  ELSE CONVERT(NVARCHAR,DAY(Fecha))
						 	   END
                       )
)

     INSERT INTO dbo.DWVentas
	 (
            [Cliente_ID]
		   ,[Producto_ID]
           ,[Fecha_id]
		   ,[Cantidad]
		   ,[Total]

     )
	 SELECT * FROM VENTAS;
	 GO

--INSERCION CLIENTES 
WITH 
    CLIENTES AS (
           SELECT 
	             [Cliente_ID]
                ,[Ciudad]
                ,[País]
	       FROM dbo.clientes
    )
	INSERT INTO dbo.DWClientes
	Select * from CLIENTES;

--INSERCION PRODUCTOS
WITH
    PRODUCTOS AS (
	               SELECT 
				         [Producto_ID]
						,[Nombre_Producto]
					    ,[Categoría]
					    ,[Precio]
				    FROM dbo.productos
			      )

	INSERT INTO dbo.DWProductos
    SELECT * FROM PRODUCTOS;


select * from  [dbo].[DWProductos];
select * from  [dbo].[DWVentas];
select * from  [dbo].[DWClientes];

