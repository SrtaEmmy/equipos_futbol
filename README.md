# equipos_futbol
Explicación de lo que hace el código: 

Crea tres tablas: "jugadores", "equipos" y "totales_tabla", con sus respectivas columnas y restricciones de clave primaria y clave ajena

Crea cuatro triggers para manejar eventos en las tablas:
El primer trigger, llamado "trigger_alta_jugador", se activa después de insertar un jugador en la tabla "jugadores" y actualiza el campo "numero_jugadores"
en la tabla "equipos" incrementándolo en 1. También incrementa en 1 el campo "num_registros" en la tabla "totales_tabla" para el registro "jugadores".

El segundo trigger, llamado "trigger_baja_jugador", se activa después de eliminar un jugador de la tabla "jugadores" y actualiza el campo "numero_jugadores"
en la tabla "equipos" decrementándolo en 1. También decrementa en 1 el campo "num_registros" en la tabla "totales_tabla" para el registro "jugadores".

El tercer trigger, llamado "trigger_alta_equipo", se activa después de insertar un equipo en la tabla "equipos" y actualiza el campo "num_registros"
en la tabla "totales_tabla" incrementándolo en 1 para el registro "equipos".

El cuarto trigger, llamado "trigger_baja_equipo", se activa después de eliminar un equipo de la tabla "equipos" y actualiza el campo "num_registros"
en la tabla "totales_tabla" decrementándolo en 1 para el registro "equipos".

Crea una vista llamada "view_datos_equipos" que combina datos de las tablas "jugadores" y "equipos" y los ordena por apellido y nombre de manera ascendente.

Crea otra vista llamada "view_descuadre" que muestra los datos de la tabla "equipos" donde la cantidad de jugadores en cada equipo no coincide con la cantidad
de jugadores registrados en la tabla "jugadores" para ese equipo.

Crea una otra tabla "empleados" e inserta sus datos excepto la letra del dni

Crea un procedimiento "proc_calcular_letra_nif" que calcula la letra del dni de los empleados y vuelca los datos en un archivo txt en la ruta C:/desarrolloSQL
