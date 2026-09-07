-- ══════════════════════════════════════════
-- MiniStore — Soluciones con Outer JOINs
-- Autor: Lucas Villarroel Arancibia
-- Fecha: 07-09-2026
-- ══════════════════════════════════════════

-- ── CONSULTA 1: LEFT JOIN ─────────────────
-- Pregunta de negocio: ¿Qué productos del catálogo nunca fueron vendidos?
-- Mostrá todos los productos y sus ventas asociadas.
-- Los productos sin ventas aparecerán con NULL en las columnas de ventas.

-- 1a) Vista completa: los 9 productos, con o sin ventas
SELECT
    p.producto_id,
    p.nombre,
    p.categoria,
    v.venta_id,
    v.cantidad,
    v.fecha_venta
FROM productos p
LEFT JOIN ventas v ON p.producto_id = v.producto_id;

-- 1b) Vista filtrada: solo los productos que NUNCA se vendieron
-- (aísla directamente la respuesta a la pregunta de negocio)
SELECT
    p.producto_id,
    p.nombre,
    p.categoria
FROM productos p
LEFT JOIN ventas v ON p.producto_id = v.producto_id
WHERE v.venta_id IS NULL;

-- ── CONSULTA 2: RIGHT JOIN ────────────────
-- Pregunta de negocio: ¿Existen ventas registradas con productos
-- que no figuran en nuestro catálogo? (posible error de carga de datos)
-- Los registros huérfanos aparecerán con NULL en las columnas de productos.

-- 2a) Vista completa: todas las ventas, con o sin producto asociado
SELECT
    v.venta_id,
    v.producto_id,
    v.cliente_id,
    v.cantidad,
    v.fecha_venta,
    p.nombre,
    p.categoria
FROM productos p
RIGHT JOIN ventas v ON p.producto_id = v.producto_id;

-- 2b) Vista filtrada: solo las ventas huérfanas (producto_id inexistente en catálogo)
SELECT
    v.venta_id,
    v.producto_id,
    v.cliente_id,
    v.cantidad,
    v.fecha_venta
FROM productos p
RIGHT JOIN ventas v ON p.producto_id = v.producto_id
WHERE p.producto_id IS NULL;

-- ── CONSULTA 3: FULL OUTER JOIN ───────────
-- Pregunta de negocio: Vista completa de auditoría que muestre
-- todos los productos y todas las ventas sin perder ninguna fila,
-- identificando tanto productos sin ventas como ventas sin producto.

-- 3a) Vista completa de auditoría: todos los productos + todas las ventas
SELECT
    p.producto_id,
    p.nombre,
    v.venta_id,
    v.producto_id AS producto_id_venta,
    v.cliente_id
FROM productos p
FULL OUTER JOIN ventas v ON p.producto_id = v.producto_id;

-- 3b) Vista filtrada: solo las anomalías (huecos de cualquiera de los dos lados)
SELECT
    p.producto_id,
    p.nombre,
    v.venta_id,
    v.producto_id AS producto_id_venta,
    v.cliente_id
FROM productos p
FULL OUTER JOIN ventas v ON p.producto_id = v.producto_id
WHERE p.producto_id IS NULL OR v.venta_id IS NULL;
