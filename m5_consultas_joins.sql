
 USE Ventas_Tech_DB;

   /* ============================================================
	Consulta 1 — Vista base del proyecto (INNER JOIN)
   ============================================================ */


SELECT * FROM categorias
SELECT * FROM clientes
SELECT * FROM productos
SELECT * FROM ventas

CREATE TABLE sucursales (
ID_Sucursal INT PRIMARY KEY,
Modalidad_sucursal VARCHAR(50) NOT NULL,
Cantidad_empleados INT NOT NULL,
Fecha_inicio DATE NOT NULL
);

INSERT INTO sucursales
(ID_Sucursal, Modalidad_sucursal, Cantidad_empleados,Fecha_inicio)
VALUES
   (1, 'PRESENCIAL', 9, '2023-12-27'),
   (2, 'ONLINE',5, '2024-01-23');

ALTER TABLE ventas
ADD ID_Sucursal INT,
   CONSTRAINT FK_SUCURSAL FOREIGN KEY (ID_Sucursal) REFERENCES sucursales(ID_Sucursal)
;

UPDATE ventas
SET ID_Sucursal = CASE 
    WHEN ID_Venta IN (3, 8) THEN 2
    ELSE 1
END;


SELECT 
	v.fecha_venta FECHA_VENTA,
	c.ID_Cliente CLIENTE,
	c.Ciudad CIUDAD,
	p.Nombre_Producto PRODUCTO,
	cat.Nombre_Categoria CATEGORIA,
	v.Cantidad CANTIDAD,
	p.Precio PRECIO,
    (v.Cantidad*p.Precio) TOTAL_VENTA,
	s.Modalidad_sucursal
FROM ventas v
INNER JOIN clientes c
    ON v.ID_cliente = c.ID_cliente
INNER JOIN productos p 
    ON v.ID_producto = p.ID_producto
INNER JOIN categorias cat
    ON p.ID_Categoria = cat.ID_Categoria
INNER JOIN sucursales s
    ON v.ID_Sucursal = s.ID_Sucursal
ORDER BY v.fecha_venta;


   /* ============================================================
	Consulta 2 — Clientes sin ventas (LEFT JOIN) 
   ============================================================ */

SELECT 
	v.ID_venta	VENTA,
	c.ID_Cliente CLIENTE,
	c. Email,
	c.Fecha_registro
FROM ventas v
LEFT JOIN clientes c
	ON v.ID_Cliente = c.ID_Cliente
WHERE v.ID_Venta IS NULL

   /* ============================================================
	Consulta 3 — Productos sin ventas (LEFT JOIN)
   ============================================================ */

SELECT
	v.ID_Venta,
	p.ID_Producto,
	p.ID_Categoria,
	p.Precio
FROM productos p
LEFT JOIN ventas v
	ON v.ID_Producto = p.ID_Producto
WHERE v.ID_Venta IS NULL

   /* ============================================================
	Consulta 4 — Consolidado por canal (UNION ALL)
   ============================================================ */

SELECT 
    ID_Venta,
    Fecha_venta,
    ID_Cliente,
    ID_Producto,
    Cantidad,
    Precio_Unitario,
    (Cantidad * Precio_Unitario) AS Total_Venta,
    'Sucursal presencial'            AS Canal_Venta
FROM ventas
WHERE ID_Sucursal = 1

UNION ALL

SELECT 
    ID_Venta,
    Fecha_venta,
    ID_Cliente,
    ID_Producto,
    Cantidad,
    Precio_Unitario,
    (Cantidad * Precio_Unitario) AS Total_Venta,
    'Sucursal online'            AS Canal_Venta
FROM ventas
WHERE ID_Sucursal = 2;
