--CONSULTAS
--ventas totales por producto: 
Select P.Producto_ID, P.Nombre_Producto, SUM(V.Total) AS VENTAS_TOTALES
from DWVentas AS V 
join DWProductos AS P
ON V.Producto_ID=P.Producto_ID
GROUP BY P.Nombre_Producto,P.Producto_ID; 

--Calcular las ventas totales por clientes: 
Select C.Ciudad, C.País, SUM(V.Total) AS VENTAS_CLIENTES
from DWVentas AS V
join DWClientes AS C
ON C.Cliente_ID=V.Cliente_ID
GROUP BY C.Ciudad,C.País;

--Calcular la cantidad de producto : 

SELECT P.Nombre_Producto, count(V.Cantidad) AS Conteo_Cantidad
FROM DWVentas AS V
join DWProductos AS P
ON P.Producto_ID=V.Producto_ID
GROUP BY P.Nombre_Producto;

--Ventas totales en agosto
SELECT V.Fecha_id ,SUM(V.Total) AS VENTAS_TOTALES
FROM DWVentas AS V
GROUP BY V.Fecha_id
HAVING V.Fecha_id BETWEEN  20250801 AND 20250831;