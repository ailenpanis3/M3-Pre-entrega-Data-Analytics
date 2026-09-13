
DROP TABLE IF EXISTS dbo.FACTVentas;
DROP TABLE IF EXISTS dbo.DIMProductos;
DROP TABLE IF EXISTS dbo.DIMClientes;
DROP TABLE IF EXISTS dbo.DIMCategoria;
USE master;
DROP DATABASE IF EXISTS Ventas_Tech_DB;

/* ============================================================
   1) Definición del esquema (DDL)
   ============================================================ */
   CREATE DATABASE Ventas_Tech_DB;
   GO
   
   USE Ventas_Tech_DB;
   GO

   CREATE TABLE dbo.DIMCategoria (
   ID_Categoria INT PRIMARY KEY,
   Nombre_Categoria VARCHAR(50) NOT NULL,
   Descripcion 	VARCHAR(200)
   );

   CREATE TABLE dbo.DIMClientes (
   ID_Cliente INT PRIMARY KEY,
   Nombre_Cliente VARCHAR(100) NOT NULL,
   Email 	VARCHAR(100) UNIQUE,
   Ciudad VARCHAR(50),
   Fecha_registro DATE NOT NULL
   );

   CREATE TABLE dbo.DIMProductos (
   ID_Producto INT PRIMARY KEY,
   Nombre_Producto VARCHAR(100) NOT NULL,
   ID_Categoria INT NOT NULL,
   Precio DECIMAL(10,2) NOT NULL,
   Stock INT DEFAULT 0,
   Activo TINYINT DEFAULT 1,

   CONSTRAINT FK_Fact_Categoria FOREIGN KEY (ID_Categoria) REFERENCES dbo.DimCategoria(ID_Categoria)
   
   );

   CREATE TABLE dbo.FACTVentas (
   ID_Venta INT IDENTITY(1,1) PRIMARY KEY,
   ID_Cliente INT NOT NULL,
   ID_Producto INT NOT NULL,
   Cantidad INT NOT NULL,
   Precio_unitario DECIMAL(10,2) NOT NULL,
   Fecha_venta DATE NOT NULL,

   CONSTRAINT FK_Fact_Cliente FOREIGN KEY (ID_Cliente) REFERENCES dbo.DimClientes(ID_Cliente),
   CONSTRAINT FK_Fact_Producto FOREIGN KEY (ID_Producto) REFERENCES dbo.DimProductos(ID_Producto)
   ); 

   GO

 /* ============================================================
   2) Carga inicil de datos (DML)
   ============================================================ */

   INSERT INTO dbo.DIMCategoria
   (ID_Categoria, Nombre_Categoria, Descripcion)
   VALUES
   (1, 'Computación', 'Laptops, PCs y monitores'),
   (2, 'Accesorios', 'Periféricos y complementos'),
   (3, 'Audio', 'Auriculares y parlantes'),
   (4, 'Almacenamiento', 'Discos y memorias');

   SELECT * FROM dbo.DIMCategoria

   INSERT INTO dbo.DIMClientes
   (ID_Cliente, Nombre_Cliente, Email, Ciudad, Fecha_registro)
   VALUES
   (1, 'María López',   'maria@mail.com',   'Buenos Aires', '2024-01-05'),
   (2, 'Carlos Ruiz',   'carlos@mail.com',  'Córdoba',      '2024-01-10'),
   (3, 'Ana Gómez',     'ana@mail.com',     'Rosario',      '2024-02-01'),
   (4, 'Pedro Sanz',    'pedro@mail.com',   'Mendoza',      '2024-02-15'),
   (5, 'Laura Torres',  'laura@mail.com',   'Tucumán',      '2024-03-01');

   SELECT * FROM dbo.DIMClientes

   INSERT INTO dbo.DIMProductos
   (ID_Producto, Nombre_Producto,  ID_Categoria, Precio, Stock, Activo)
   VALUES
   (1, 'Laptop Pro 15',       1, 1200.00, 15, 1),
   (2, 'Mouse Inalámbrico',   2,   28.00, 80, 1),
   (3, 'Monitor 4K 27"',      1,  450.00, 12, 1),
   (4, 'Auriculares BT Pro',  3,  120.00, 35, 1),
   (5, 'SSD Externo 1TB',     4,  130.00, 18, 1),
   (6, 'Teclado Mecánico',    2,   95.00, 40, 1);

   SELECT * FROM dbo.DIMProductos


   INSERT INTO dbo.FACTVentas
   (ID_Cliente, ID_Producto, Cantidad, Precio_unitario, Fecha_venta)
   VALUES
   (1, 1, 2, 1200.00, '2024-03-05'),
   (2, 2, 5,   28.00, '2024-03-06'),
   (3, 3, 1,  450.00, '2024-03-07'),
   (1, 4, 2,  120.00, '2024-03-08'),
   (4, 5, 3,  130.00, '2024-03-10'),
   (2, 6, 4,   95.00, '2024-03-11'),
   (5, 1, 1, 1200.00, '2024-03-12'),
   (3, 2, 8,   28.00, '2024-03-13'),
   (4, 4, 1,  120.00, '2024-03-14'),
   (5, 3, 2,  450.00, '2024-03-15');

   SELECT * FROM dbo.FACTVentas
