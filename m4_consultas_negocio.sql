 
 USE Ventas_Tech_DB;

 /* ============================================================
   Consulta 1 — Resumen ejecutivo mensual 
   ============================================================ */
   SELECT * FROM ventas

   SELECT
        MONTH (Fecha_venta) AS Mes,
        SUM(Cantidad * Precio_unitario) AS Total_facturado,
        Count (ID_Venta) AS Cantidad_de_pedidos,
        AVG (Cantidad * Precio_unitario) AS Ticket_promedio
   FROM ventas
   GROUP BY MONTH (fecha_venta)
   ORDER BY mes;

    /* ============================================================
   Consulta 2 — Ranking de productos 
   ============================================================ */

   SELECT TOP 5
        ID_Producto,
        SUM(Cantidad) AS Unidades_vendidas,
        SUM(Cantidad * Precio_unitario) AS Total_facturado
   FROM ventas
   GROUP BY ID_Producto
   ORDER BY Total_facturado DESC;

       /* ============================================================
   Consulta 3 — Clientes recurrentes 
   ============================================================ */

   SELECT
        ID_Cliente,
        Count(*) AS Cantidad_pedidos,
        SUM(Cantidad * Precio_unitario) AS Total_gastado
   FROM ventas
   GROUP BY ID_Cliente
   HAVING COUNT(*) > 1
   ORDER BY Total_gastado DESC;

    /* ============================================================
   Consulta 4 — Meses por encima/por debajo del promedio 
   ============================================================ */
-- Paso 1: Calculamos el total facturado por mes
    WITH VentasPorMes AS (
      SELECT 
            MONTH(Fecha_venta) AS Mes,
            SUM(Cantidad * Precio_unitario) AS Total_Facturado
      FROM ventas
      GROUP BY MONTH(Fecha_venta)
      )

-- Paso 2: Mostrar cada mes y evaluar con CASE WHEN contra el promedio global
    SELECT 
      Mes,
      Total_Facturado,
     CASE 
            WHEN Total_Facturado >= (SELECT AVG(Total_Facturado) FROM VentasPorMes) 
                THEN 'Por encima'
                ELSE 'Por debajo'
            END AS Promedio_ventas
    FROM VentasPorMes
    ORDER BY Mes;

    /* ============================================================
   Bloque de cierre. Hallazgos:

  1. El cliente 1 gastó $5.280, lo que significa el 40.97% de las compras del mes.
  2. Se facturó del producto 1 $7.200, lo que significa el 55.87% de las ventas del mes.
  3. El producto más vendido fue el 2, con un total de 26 unidades vendidas, aunque fue uno 
  de los productos que menos aportó al total facturado (se encuentra quinto en el ranking de
  productos según el total facturado, cuando hay un total de 6 productos a la venta).  

   ============================================================ */



