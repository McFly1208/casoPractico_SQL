-- a) Crear la base de datos con el archivo create_restaurant_db.sql
-- (Ejecutar el archivo create_restaurant_db.sql antes de continuar)

-- b) Explorar la tabla 'menu_items' para conocer los productos del menú.
SELECT * FROM menu_items
-- 1. Encontrar el número de artículos en el menú.
SELECT COUNT(*) AS total_articulos FROM menu_items;

-- 2. ¿Cuál es el artículo menos caro y el más caro en el menú?
SELECT item_name, price FROM menu_items ORDER BY price ASC LIMIT 1; -- Menos caro
SELECT item_name, price FROM menu_items ORDER BY price DESC LIMIT 1; -- Más caro

-- 3. ¿Cuántos platos americanos hay en el menú?
SELECT COUNT(*) AS total_platos_americanos FROM menu_items WHERE category = 'American';

-- 4. ¿Cuál es el precio promedio de los platos?
SELECT AVG(price) AS precio_promedio FROM menu_items;

-- c) Explorar la tabla 'order_details' para conocer los datos que han sido recolectados.
SELECT * FROM order_details
-- 1. ¿Cuántos pedidos únicos se realizaron en total?
SELECT COUNT(DISTINCT order_id) AS total_pedidos FROM order_details;

-- 2. ¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?
SELECT order_id, COUNT(*) AS total_articulos 
FROM order_details 
GROUP BY order_id 
ORDER BY total_articulos DESC 
LIMIT 5;

-- 3. ¿Cuándo se realizó el primer pedido y el último pedido?
SELECT MIN(order_date) AS primer_pedido, MAX(order_date) AS ultimo_pedido FROM order_details;

-- 4. ¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'?
SELECT COUNT(DISTINCT order_id) AS total_pedidos FROM order_details 
WHERE order_date BETWEEN '2023-01-01' AND '2023-01-05';

-- d) Usar ambas tablas para conocer la reacción de los clientes respecto al menú.

-- 1. Realizar un LEFT JOIN entre order_details y menu_items con el identificador item_id (order_details) y menu_item_id (menu_items).
SELECT od.order_id, od.order_date, od.order_time, mi.item_name, mi.price, mi.category
FROM order_details od
LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id;

-- e) Análisis adicional para identificar 5 puntos clave útiles para los dueños del restaurante.

-- 1. Identificar los 5 artículos más vendidos.
SELECT mi.item_name, COUNT(*) AS total_ventas
FROM order_details od
LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.item_name
ORDER BY total_ventas DESC
LIMIT 5;

-- 2. Determinar los platos con mayores ingresos totales.
SELECT mi.item_name, SUM(mi.price) AS ingresos_totales
FROM order_details od
LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.item_name
ORDER BY ingresos_totales DESC
LIMIT 5;

-- 3. Identificar la categoría de cocina más popular.
SELECT mi.category, COUNT(*) AS total_pedidos
FROM order_details od
LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.category
ORDER BY total_pedidos DESC
LIMIT 1;

-- 4. Identificar las horas pico de pedidos.
SELECT EXTRACT(HOUR FROM od.order_time) AS hora, COUNT(*) AS total_pedidos
FROM order_details od
GROUP BY EXTRACT(HOUR FROM od.order_time)
ORDER BY total_pedidos DESC
LIMIT 5;
-- 5. Calcular el ticket promedio por pedido.
SELECT AVG(total) AS ticket_promedio
FROM (
    SELECT od.order_id, SUM(mi.price) AS total
    FROM order_details od
    LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
    GROUP BY od.order_id
) pedidos;
