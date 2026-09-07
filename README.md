# outer-joins-ministore

Auditoría de datos de MiniStore usando LEFT JOIN, RIGHT JOIN y FULL OUTER JOIN para detectar productos sin ventas y ventas con productos inexistentes en el catálogo.

-- Contenido

- `schema.sql`: creación de las tablas `productos` y `ventas`, con datos de prueba que incluyen intencionalmente productos nunca vendidos y una venta con un producto inexistente.
- `soluciones.sql`: las 3 consultas requeridas, cada una con una vista completa y una vista filtrada que aísla la respuesta a la pregunta de negocio.

## Preguntas de reflexión

### ¿Por qué usaste LEFT JOIN para la Consulta 1 y no INNER JOIN? ¿Qué se perdería si usaras INNER JOIN?
Usé `LEFT JOIN` porque la pregunta de negocio necesita ver *todos* los productos del catálogo, incluidos los que nunca se vendieron. Un `INNER JOIN` solo devuelve filas donde hay coincidencia en ambas tablas,
como los productos 108 (Hub USB-C) y 109 (Parlante Bluetooth) no tienen ninguna fila en `ventas`, un `INNER JOIN` los excluiría directamente del resultado. 
Eso arruinaría el propósito del ejercicio: justo esos dos productos "invisibles" para un `INNER JOIN` son la respuesta que el equipo de operaciones está buscando.

### ¿Por qué usaste RIGHT JOIN para la Consulta 2? ¿Qué tabla está a la izquierda y cuál a la derecha en tu consulta?
En mi consulta, `productos` está a la izquierda (es la tabla que sigue al `FROM`) y `ventas` está a la derecha (la que sigue al `RIGHT JOIN`). 
Usé `RIGHT JOIN` para garantizar que se devuelvan *todas* las filas de `ventas`, incluso la venta con `venta_id = 10`, que tiene `producto_id = 999`, un valor que no existe en la tabla `productos`. 
Si hubiera usado `INNER JOIN`, esa venta huérfana desaparecería del resultado, y ese es justamente el error de carga de datos que el equipo necesita detectar.

### ¿Qué representan los valores NULL en cada resultado? Explicá con un ejemplo concreto.
En la Consulta 1, cuando `venta_id` aparece `NULL`, significa que ese producto no tiene ninguna fila coincidente en `ventas`, por ejemplo, el producto 108 (Hub USB-C 7p) aparece con `venta_id NULL` porque nunca se registró 
una venta con `producto_id = 108`. No es un error: es la señal de que ese producto está en el catálogo pero nunca se movió.

En la Consulta 2, cuando `producto_id` (de la tabla `productos`) aparece `NULL`, significa lo contrario: hay una venta real registrada, pero ningún producto del catálogo coincide con su `producto_id`. 
Es el caso de `venta_id = 10`, que referencia `producto_id = 999` — ese número simplemente no existe en `productos`. Acá el `NULL` sí es señal de un problema: probablemente un error de carga o un producto que
fue eliminado del catálogo después de haberse vendido.

### ¿Cuándo usarías FULL OUTER JOIN en un caso real de negocio?
Usaría `FULL OUTER JOIN` en auditorías de calidad de datos donde necesito ver, en una sola consulta, tanto los productos sin ventas como las ventas sin producto, por ejemplo, antes de cargar datos a un dashboard de
Power BI, para asegurarme de que no haya inconsistencias escondidas en ninguna de las dos direcciones. En el caso de MiniStore, la Consulta 3 muestra en un solo resultado tanto los 2 productos nunca vendidos como la 
venta con `producto_id = 999`, dándome una vista completa de todo lo que no cuadra entre el catálogo y las transacciones, sin tener que correr dos consultas separadas y compararlas manualmente.
