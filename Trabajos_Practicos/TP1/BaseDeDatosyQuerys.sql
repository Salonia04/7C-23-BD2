TRABAJADO CON MARCO FINI MINUÉ
====================================================================================================================================================

CREACION DATABASE
---
TABLA USUARIO
create table Usuario(id int primary key auto_increment, nombre varchar(15), correo varchar(30), fechaNacimiento date, nombreUsuario varchar(25), ubicacion varchar(30), juegoFavorito varchar(30), gametag varchar(4),
lvlHabilidad varchar(10), ranking int, fechaRegistro date);

TABLA TIPOSANCION
create table TipoSancion (id int primary key auto_increment, descripcion varchar(30));

TABLA SANCION
create table Sancion (id int primary key auto_increment, duracion time, fechaSancion date, tipoSancion int, constraint foreign key (tipoSancion) references TipoSancion(id), textoSancion varchar(30));

TABLA TORNEO
create table Torneo (id int primary key auto_increment, fechaInicio datetime, fechaFin datetime);

TABLA PERSO
create table Perso(id int primary key auto_increment, numJugadores
int, juego varchar(35), datetime datetime, duracion time);

TABLA ESTADO
create table Estado(id int primary key auto_increment, estado varchar(25));

TABLA PARTIDA
create table Partida(id int primary key auto_increment, idTorneo int, constraint foreign key (idTorneo) references Torneo(id), idPerso int, constraint foreign key (idPerso) references Perso(id), idEstado int, constraint foreign key (idEstado) references Estado(id));

TABLA PLATAFORMA
create table Plataforma(id int primary key auto_increment, idUsuario int, constraint foreign key (idUsuario) references Usuario(id), idPartida int, constraint foreign key (idPartida) references Partida(id));

TABLA HISTORIAL
create table Historial(id int primary key auto_increment, posicion
int, puntosRecibidos int, idUsuario int, constraint foreign key (idUsuario) references Usuario(id), idPartida int, constraint foreign key (idPartida) references Partida(id), idSancion int, constraint foreign key (idSancion) references Sancion(id));

====================================================================================================================================================

QUERYS
---
1. 
SELECT COUNT(*) AS Num_Active_Tournaments, Torneo.fechaFin AS Tournament_End_Date FROM Torneo INNER JOIN Partida ON Torneo.id = Partida.idTorneo INNER JOIN Perso ON Perso.id = Partida.idPerso INNER JOIN Usuario ON Usuario.id = Perso.numJugadores WHERE Usuario.lvlHabilidad = 'Casual' AND Torneo.fechaFin > NOW() GROUP BY Torneo.id;

2. 
SELECT Usuario.nombre AS Player_Name, COUNT(DISTINCT Partida.id) AS Matches_Played, COUNT(DISTINCT Torneo.id) AS Tournaments_Played, (SUM(Historial.puntosRecibidos)/COUNT(DISTINCT Partida.id))*100 AS Winning_Percentage FROM Usuario INNER JOIN Historial ON Historial.idUsuario = Usuario.id INNER JOIN Partida ON Partida.id = Historial.idPartida INNER JOIN Torneo ON Torneo.id = Partida.idTorneo GROUP BY Usuario.id ORDER BY SUM(Historial.puntosRecibidos) DESC LIMIT 10;

3.
SELECT COUNT(*) AS New_Users FROM Usuario WHERE MONTH(fechaRegistro) = MONTH(CURRENT_DATE()) AND YEAR(fechaRegistro) = YEAR(CURRENT_DATE()) AND MONTH(fechaRegistro) <> MONTH(CURRENT_DATE() - INTERVAL 1 MONTH) AND YEAR(fechaRegistro) = YEAR(CURRENT_DATE() - INTERVAL 1 MONTH);

4.
SELECT t.fechaFin, COUNT(DISTINCT h.idSancion) AS cantidad_sanciones, COUNT(DISTINCT u.id) AS cantidad_participantes, u.nombre AS ganador, SUM(h.puntosRecibidos) AS puntos_obtenidos FROM Historial h INNER JOIN Partida p ON p.id = h.idPartida INNER JOIN Torneo t ON t.id = p.idTorneo INNER JOIN Usuario u ON u.id = h.idUsuario WHERE t.fechaFin < NOW() GROUP BY t.id ORDER BY t.fechaFin DESC LIMIT 10;

5.
SELECT AVG(h.posicion) AS posicion_promedio, SUM(h.puntosRecibidos) AS puntos_obtenidos, COUNT(DISTINCT p.idTorneo) AS cantidad_torneos, COUNT(DISTINCT h.idPartida) AS cantidad_partidas  FROM Historial h  INNER JOIN Partida p ON p.id = h.idPartida  INNER JOIN Torneo t ON t.id = p.idTorneo  INNER JOIN Usuario u ON u.id = h.idUsuario  WHERE u.lvlHabilidad = 'experto';
