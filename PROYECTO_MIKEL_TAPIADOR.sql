--2.Muestra los nombres de todas las películas con una clasificación por 
--edades de ‘Rʼ.

SELECT rating , title 
FROM film f
WHERE "rating"= 'R';

--3.Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 y 40.

SELECT concat(first_name ,' ',last_name ), actor_id 
FROM actor a 
WHERE actor_id BETWEEN 30 AND 40;

--4.Obtén las películas cuyo idioma coincide con el idioma original

SELECT *
FROM film f 
WHERE original_language_id = language_id ;  --Los valores de la base de datos son siempre NULL para idioma original y 1 para idioma

--5.Ordena las películas por duración de forma ascendente.

SELECT title , film_id , length 
FROM film f 
ORDER BY length ASC;

--6.Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su apellido

SELECT first_name , last_name 
FROM actor a 
WHERE last_name like '%ALLEN%';

--7.Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento

SELECT rating AS clasificacion, COUNT(*) AS Total_Peliculas
FROM film f
GROUP BY rating;

--8.Encuentra el título de todas las películas que son ‘PG13ʼ o tienen una duración mayor a 3 horas en la tabla film


SELECT title , length , rating
FROM film f 
WHERE rating = 'PG-13' OR length > 180;

--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

SELECT variance(replacement_cost ) 
FROM film f ;

--10.Encuentra la mayor y menor duración de una película de nuestra BBDD

SELECT MAX(length ), MIN(length ),
FROM film f ;

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día

SELECT amount , payment_date , rental_id 
FROM payment p 
ORDER BY p.payment_date desc
LIMIT 1 
OFFSET 2;
--No me da el resultado número 3 de la columna payment day cuando lo busco sin limit ni offset, pero creo que es por que todas coinciden en la fecha y la hora exactas. 
--Lo dejo así por que creo que está bien formulado.

--12. Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-17ʼ ni ‘Gʼ en cuanto a su clasificación


SELECT title , rating 
FROM film f 
WHERE f.rating NOT IN ('NC-17', 'G');

--13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración


SELECT AVG(length ), rating 
FROM film f 
GROUP BY f.rating ;
--14.Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos


SELECT title , length 
FROM film f 
WHERE length > 180;


--15.¿Cuánto dinero ha generado en total la empresa?

SELECT SUM(amount )
FROM payment p ;

--16.Muestra los 10 clientes con mayor valor de id

SELECT customer_id 
FROM customer c 
ORDER BY c.customer_id DESC 
LIMIT 10;

--17.Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ

SELECT first_name , last_name , title 
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'EGG IGBY'

--18. Selecciona todos los nombres de las películas únicos.

SELECT DISTINCT title , film_id 
FROM film f 
ORDER BY f.title 
--Creo que no he entendido bien lo que se pedía en este ejercicio. Todas las peliculas son unicas, así que no se si era esto lo que se pedía.


--19.Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ

SELECT title , length , c.category_id ,c."name"
FROM film f 
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c."name" = 'Comedy' AND length > 180;


--20.Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración


SELECT c."name", AVG(length )
FROM film f 
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
GROUP BY c."name"
HAVING AVG(length) > 110;


--21.¿Cuál es la media de duración del alquiler de las películas?

SELECT AVG(rental_duration )
FROM film f ;

--22.Crea una columna con el nombre y apellidos de todos los actores y actrices

SELECT concat(first_name,' ', last_name )
FROM actor a ;

--23.Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

SELECT rental_date , COUNT(*) 
FROM rental 
GROUP BY rental_date 
ORDER BY count(*) DESC;

--24. Encuentra las películas con una duración superior al promedio

SELECT AVG(length )
FROM film f 


SELECT title , length 
FROM film f 
WHERE length > (SELECT AVG(length )
				FROM film f );

--25. Averigua el número de alquileres registrados por mes

--No tengo ni idea de trabajar con fechas

--26.Encuentra el promedio, la desviación estándar y varianza del total pagado

SELECT AVG(amount ), stddev(amount ), variance(amount )
FROM payment p ;
--No tengo muy claro si esto era lo que se pedía

--27.¿Qué películas se alquilan por encima del precio medio?

SELECT AVG(amount )
FROM payment p 

SELECT f.film_id , title , amount 
FROM film f 
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN payment p ON p.rental_id = r.rental_id
WHERE amount > (SELECT AVG(amount )
				FROM payment p );

--28.Muestra el id de los actores que hayan participado en más de 40 películas


SELECT actor_id , COUNT(film_id) 
FROM film_actor fa 
GROUP BY actor_id 
HAVING COUNT(film_id) > 40

--29.Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible

SELECT f.film_id , f.title, count(inventory_id ) AS cantidad_disponible
FROM inventory i2  
RIGHT JOIN film f ON i2.film_id = f.film_id
GROUP BY f.film_id ;

--30.Obtener los actores y el número de películas en las que ha actuado y el nombre de los actores


SELECT fa.actor_id , COUNT(film_id), concat(first_name,' ', last_name )
FROM film_actor fa 
JOIN actor a ON fa.actor_id = a.actor_id 
GROUP BY fa.actor_id , concat(first_name,' ', last_name )
ORDER BY concat(first_name,' ', last_name );

--31.Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.


SELECT f.title , fa.film_id , fa.actor_id , concat(first_name,' ', last_name )
FROM film f 
LEFT JOIN film_actor fa ON fa.film_id = f.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
ORDER BY f.title 

--32.Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película

SELECT concat(first_name,' ', last_name ) AS nombre_actor, actor.actor_id , title AS titulo_pelicula
FROM actor
LEFT JOIN film_actor fa ON actor.actor_id = fa.actor_id 
LEFT JOIN film f ON fa.film_id = f.film_id


---33.Obtener todas las películas que tenemos y todos los registros de alquiler.

SELECT title AS peliculas, rental_id AS registros_de_alquiler
FROM film f 
FULL JOIN inventory i ON i.film_id = f.film_id
FULL JOIN rental r ON r.inventory_id = i.inventory_id
ORDER BY peliculas DESC ;


--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros

SELECT c.customer_id , concat(first_name,' ', last_name ) AS nombre_cliente, SUM(amount ) AS cantidad_gastada
FROM customer c 
JOIN rental r ON r.customer_id = c.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id 
ORDER BY SUM(amount ) DESC 
LIMIT 5;

--35.Selecciona todos los actores cuyo primer nombre es 'Johnny'.

SELECT *
FROM actor a 
WHERE first_name = 'Johnny';

--36. Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido

SELECT first_name AS Nombre, last_name AS Apellido
FROM actor a 
WHERE first_name = 'Johnny';



--37. Encuentra el ID del actor más bajo y más alto en la tabla actor

SELECT MAX(actor_id ), MIN(actor_id )
FROM actor a ;


---38.Cuenta cuántos actores hay en la tabla “actorˮ

SELECT COUNT(actor_id )
FROM actor a ;

---39.Selecciona todos los actores y ordénalos por apellido en orden ascendente


SELECT *
FROM actor a 
ORDER BY a.last_name ASC ;

--40.Selecciona las primeras 5 películas de la tabla “filmˮ
SELECT *
FROM film f 
LIMIT 5;

--41.Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?



SELECT first_name AS nombre , COUNT(*) AS cantidad_nombres
FROM actor a 
GROUP BY first_name 
ORDER BY COUNT(*) DESC 
LIMIT 3;
--He limitado a 3 porque hay un triple empate

--42.Encuentra todos los alquileres y los nombres de los clientes que los realizaron

SELECT rental_id , concat(first_name ,' ', last_name ) AS nombre_cliente
FROM rental r 
LEFT JOIN customer c ON c.customer_id = r.customer_id;

--43.Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres

SELECT concat(first_name ,' ', last_name ) AS nombre_cliente, c.customer_id , rental_id 
FROM customer c 
LEFT JOIN rental r ON r.customer_id = c.customer_id;

--44.Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación


--SELECT title, "name" 
--FROM film f 
--JOIN film_category fc ON f.film_id = fc.film_id
--JOIN category c ON fc.category_id = c.category_id ;


SELECT title, name 
FROM film f 
CROSS JOIN category c ;

--En mi opinión no aporta ningún, valor, la consulta de arriba serviría para saber la categoría de cada película pero la que se pide en el ejercicio no sirve para nada, 
--simplemente adjudica todas las películas a todas las categorías lo que no aporta nada.

--45.Encuentra los actores que han participado en películas de la categoría 'Action'

SELECT DISTINCT a.actor_id , concat(first_name ,' ', last_name )
FROM actor a 
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE c."name" = 'Action'
ORDER BY concat(first_name ,' ', last_name );


---46. Encuentra todos los actores que no han participado en películas

SELECT *
FROM actor a 
LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id
LEFT JOIN film f ON f.film_id = fa.film_id
WHERE f.film_id IS NULL 

-- Me pone que todos los actores han participado en películas

--47.Selecciona el nombre de los actores y la cantidad de películas en las que han participado

SELECT concat(first_name ,' ', last_name ) AS nombre_actores, COUNT(f.film_id ) AS cantidad_peliculas
FROM actor a 
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
GROUP BY nombre_actores;

--48.Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres de los actores y el número de películas en las que han participado

CREATE VIEW “actor_num_peliculasˮ AS 
SELECT concat(first_name ,' ', last_name ) AS nombre_actores, COUNT(f.film_id ) AS cantidad_peliculas
FROM actor a 
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
GROUP BY nombre_actores;

--49.Calcula el número total de alquileres realizados por cada cliente


SELECT c.customer_id , concat(first_name ,' ', last_name ) AS nombre_cliente, COUNT(rental_id ) AS total_alquileres
FROM rental r 
JOIN customer c ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY nombre_cliente;

--50.Calcula la duración total de las películas en la categoría 'Action'

SELECT SUM(length )
FROM film f 
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE "name" = 'Action';

--51.Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente

CREATE TEMPORARY TABLE  “cliente_rentas_temporalˮ AS 
SELECT c.customer_id , concat(first_name ,' ', last_name ) AS nombre_cliente, COUNT(rental_id ) AS total_alquileres
FROM rental r 
JOIN customer c ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY nombre_cliente;

--52.Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces

CREATE TEMPORARY TABLE “peliculas_alquiladasˮ AS 
SELECT title , COUNT(rental_id ) AS numero_de_veces_alquiladas
FROM film f 
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY f.title 
HAVING  COUNT(rental_id )>= 10;

--53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.

SELECT title , return_date 
FROM film f 
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE return_date IS NULL AND rental_id IN (SELECT rental_id 
											FROM customer c 
											JOIN rental r ON r.customer_id = c.customer_id
											WHERE c.first_name = 'Tammy' AND c.last_name = 'Sanders');

--Me he calentado haciendo una subconsulta y luego me he dado cuenta que era más fácil, pero la dejo que me ha gustaod akaajajajaj
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE c.first_name = 'Tammy'AND c.last_name = 'Sanders'AND r.return_date IS NULL
ORDER BY f.title ;

--54.Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados 
--alfabéticamente por apellido


SELECT DISTINCT first_name ,  last_name 
FROM actor a 
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE c."name"  = 'Sci-Fi'
ORDER BY a.last_name ;

--55.Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus 
--Cheaperʼ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.


SELECT MIN(rental_date)  
FROM film f 
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE title = 'SPARTACUS CHEAPER'

SELECT DISTINCT first_name AS nombre , last_name AS apellido
FROM actor a 
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
WHERE release_year > (SELECT EXTRACT(YEAR FROM MIN(r.rental_date))
					  FROM film f 
					  JOIN inventory i ON i.film_id = f.film_id
					  JOIN rental r ON r.inventory_id = i.inventory_id
					  WHERE title = 'SPARTACUS CHEAPER')
ORDER BY apellido ;

SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON f.film_id = fa.film_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r2.rental_date)
    FROM film f2
    JOIN inventory i2 ON i2.film_id = f2.film_id
    JOIN rental r2 ON r2.inventory_id = i2.inventory_id
    WHERE f2.title = 'SPARTACUS CHEAPER'
)
ORDER BY a.last_name;

---Me sale lo mismo en ambos modelos pero me parece más correcto el de arriba, más explicable respecto a la pregunta

--56.Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Musicʼ

SELECT DISTINCT  first_name AS nombre, last_name AS apellido
FROM actor a 
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE a.actor_id NOT IN (SELECT a.actor_id 
						FROM actor a 
						JOIN film_actor fa ON fa.actor_id = a.actor_id
						JOIN film f ON f.film_id = fa.film_id
						JOIN film_category fc ON fc.film_id = f.film_id
						JOIN category c ON c.category_id = fc.category_id
						WHERE "name" = 'Music')
ORDER BY last_name ;


SELECT *
FROM actor a 
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE "name" = 'Music'
ORDER BY a.last_name 

--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.


SELECT title 
FROM film f 
WHERE rental_duration > 8;

--58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animationʼ


SELECT title 
FROM film f 
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE c."name" = 'Animation'

---59.  Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Feverʼ. 
--Ordena los resultados alfabéticamente por título de película



SELECT title AS nombre_pelicula
FROM film f 
WHERE length = (SELECT length 
				FROM film 
				WHERE title = 'DANCING FEVER');

--60.Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido


SELECT concat(first_name , ' ', c.last_name ), count(DISTINCT rental_id  ), last_name 
FROM customer c 
JOIN rental r ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = r.inventory_id
GROUP BY concat(first_name , ' ', c.last_name ), last_name 
HAVING count(DISTINCT rental_id )>=7
ORDER BY last_name ;

--Tengo dudas en esta entiendo que cada rental_Id es una pelicula distinta, pero se podría volver a alquilar la misma y en esa caso 
--no se si tendría un rental ID distinto.

--61.Encuentra la cantidad total de películas alquiladas por categoría y 
--muestra el nombre de la categoría junto con el recuento de alquileres



SELECT 
    c.name AS categoria, 
    COUNT(*) AS total_alquileres
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY c.name;


--62. Encuentra el número de películas por categoría estrenadas en 2006


SELECT  c."name" , COUNT(*)
FROM film f 
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE release_year= 2006
GROUP BY c.name ;
--Todas están estrenadas en 2006 asi que no se si esto es lo que se me pedía.


--63.Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos

SELECT s.store_id AS nummero_tienda , staff_id , concat(first_name ,' ', last_name ) AS nombre_empleado
FROM staff s 
CROSS JOIN store s2 ;

--64.Encuentra la cantidad total de películas alquiladas por cada cliente y 
--muestra el ID del cliente, su nombre y apellido junto con la cantidad de 
--películas alquiladas




SELECT COUNT(*) AS numero_peliculas_alquiladas, c.customer_id , concat(first_name ,' ', last_name ) AS nombre_cliente
FROM customer c 
JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id 
ORDER BY nombre_cliente ;
