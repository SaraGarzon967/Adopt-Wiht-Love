-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 03-12-2024 a las 05:14:16
-- Versión del servidor: 8.0.40
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `dbawl`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `RegAdopVali` (IN `p_fecha` DATE, IN `p_id_animal` INT, IN `p_id_cliente` INT)   BEGIN
    DECLARE v_estado VARCHAR(20);
    
    -- Obtener el estado actual del animal
    SELECT estado INTO v_estado
    FROM animales
    WHERE id_animales = p_id_animal;

    -- Validar que el animal esté disponible
    IF v_estado = 'disponible' THEN
        -- Iniciar transacción
        START TRANSACTION;

        -- Registrar la adopción
        INSERT INTO adopcion (fecha, fk_id_animales, fk_id_cliente)
        VALUES (p_fecha, p_id_animal, p_id_cliente);

        -- Actualizar el estado del animal a 'adoptado'
        UPDATE animales
        SET estado = 'adoptado'
        WHERE id_animales = p_id_animal;

        -- Confirmar transacción
        COMMIT;
    ELSE
        -- Si el animal no está disponible, lanzar un error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El animal no está disponible para adopción.';
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `adopcion`
--

CREATE TABLE `adopcion` (
  `id_adopcion` int NOT NULL,
  `fecha` date NOT NULL,
  `fk_id_animales` int NOT NULL,
  `fk_id_cliente` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `adopcion`
--

INSERT INTO `adopcion` (`id_adopcion`, `fecha`, `fk_id_animales`, `fk_id_cliente`) VALUES
(1, '2024-11-15', 1, 1),
(2, '2024-11-18', 2, 3),
(3, '2024-11-20', 4, 5),
(4, '2024-09-20', 12, 9),
(5, '2024-09-20', 3, 8),
(6, '2024-09-20', 6, 7),
(7, '2024-09-20', 5, 18),
(8, '2024-09-20', 9, 11),
(9, '2024-09-20', 11, 5),
(10, '2024-12-02', 7, 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `animales`
--

CREATE TABLE `animales` (
  `id_animales` int NOT NULL,
  `nombre` varchar(15) NOT NULL,
  `edad` int NOT NULL,
  `fk_nit_fundacion` varchar(11) NOT NULL,
  `fk_id_raza` int NOT NULL,
  `estado` enum('disponible','adoptado') DEFAULT 'disponible'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `animales`
--

INSERT INTO `animales` (`id_animales`, `nombre`, `edad`, `fk_nit_fundacion`, `fk_id_raza`, `estado`) VALUES
(1, 'Firulais', 3, '805678912', 1, 'adoptado'),
(2, 'Michi', 2, '902345678', 3, 'adoptado'),
(3, 'Max', 4, '902345678', 2, 'adoptado'),
(4, 'Bobby', 5, '904567123', 2, 'adoptado'),
(5, 'Toby', 2, '905678123', 6, 'adoptado'),
(6, 'Mara', 6, '907890345', 6, 'adoptado'),
(7, 'Samii', 1, '904567123', 13, 'adoptado'),
(8, 'Linda', 3, '902345678', 17, 'disponible'),
(9, 'Manchas', 2, '905678123', 2, 'adoptado'),
(10, 'Luna', 4, '902345678', 10, 'disponible'),
(11, 'Polar', 5, '904567123', 15, 'adoptado'),
(12, 'Lulu', 2, '902345678', 2, 'adoptado'),
(13, 'Pedro', 1, '907890345', 5, 'disponible'),
(14, 'Esponja', 3, '900123456', 16, 'disponible');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `id_cliente` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`id_cliente`) VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(18);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compras`
--

CREATE TABLE `compras` (
  `id_compra` int NOT NULL,
  `total` int NOT NULL,
  `fecha` date NOT NULL,
  `fk_id_cliente` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `compras`
--

INSERT INTO `compras` (`id_compra`, `total`, `fecha`, `fk_id_cliente`) VALUES
(1, 150000, '2024-11-15', 1),
(2, 50000, '2024-11-16', 2),
(3, 120000, '2024-11-17', 3),
(4, 30000, '2024-11-18', 4),
(5, 75000, '2024-11-19', 5),
(6, 180000, '2024-11-20', 6),
(7, 90000, '2024-11-21', 7),
(8, 250000, '2024-11-22', 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `donacion`
--

CREATE TABLE `donacion` (
  `id_donacion` int NOT NULL,
  `fk_nit_fundacion` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `fecha` date NOT NULL,
  `monto_donacion` bigint NOT NULL,
  `fk_id_cliente` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `donacion`
--

INSERT INTO `donacion` (`id_donacion`, `fk_nit_fundacion`, `fecha`, `monto_donacion`, `fk_id_cliente`) VALUES
(1, '900123456', '2024-09-18', 200000, 5),
(2, '900123456', '2023-09-13', 120000, 18),
(3, '904567123', '2023-09-13', 560000, 6),
(4, '904567123', '2024-09-20', 160000, 11),
(5, '900123456', '2024-11-21', 150000, 1),
(6, '900123456', '2024-11-20', 200000, 2),
(7, '803456789', '2024-11-22', 300000, 8),
(8, '904567123', '2024-11-19', 120000, 10),
(9, '803456789', '2024-11-18', 500000, 6);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `encargado_fund`
--

CREATE TABLE `encargado_fund` (
  `id_encargado` int NOT NULL,
  `fk_nit_fundacion` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `encargado_fund`
--

INSERT INTO `encargado_fund` (`id_encargado`, `fk_nit_fundacion`) VALUES
(1, '801987654'),
(2, '803456789'),
(3, '805678912'),
(4, '900123456'),
(5, '902345678'),
(6, '904567123'),
(7, '905678123'),
(8, '906789234'),
(9, '907890345');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fundacion`
--

CREATE TABLE `fundacion` (
  `nit_fundacion` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `Nombre` varchar(35) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `numero` varchar(10) NOT NULL,
  `correo` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ubicacion` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `fundacion`
--

INSERT INTO `fundacion` (`nit_fundacion`, `Nombre`, `numero`, `correo`, `ubicacion`) VALUES
('801987654', 'Dogs', '3425081079', 'dogs@gmail.com', 'Bosa'),
('803456789', 'Amores', '3903759102', 'amores@gmail.com', 'Suba'),
('805678912', 'TEPA', '3609172058', 'tepa@gmail.com', 'Bosa'),
('900123456', 'Huellitas', '3627058491', 'huellitas@gmail.com', 'Suba'),
('902345678', 'Adop', '3224051987', 'adop@gmail.com', 'Chapinero'),
('904567123', 'Perro Amor', '3802519846', 'perro_amor@gmail.com', 'Suba'),
('905678123', 'Fundacion Gatos', '3101234567', 'fundaciongatos@gmail.com', 'Chapinero'),
('906789234', 'Fundacion Perros Felices', '3201234567', 'perrosfelices@gmail.com', 'Candelaria'),
('907890345', 'Fundacion Animalistas', '3301234567', 'animalistas@gmail.com', 'Bosa');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

CREATE TABLE `persona` (
  `id_persona` int NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `apellido` varchar(25) NOT NULL,
  `contacto` varchar(10) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `contrasena` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`id_persona`, `nombre`, `apellido`, `contacto`, `fecha_nacimiento`, `contrasena`) VALUES
(1, 'Camilo', 'Quintero', '3836295749', '2000-11-19', 'ewrfesd'),
(2, 'Maicol', 'Olivera', '3102584736', '2000-10-19', 'aeg4hs5'),
(3, 'Michel', 'Rodrigez', '3301849675', '1995-10-19', 'poiuytr'),
(4, 'Pablo', 'Vargas', '3705829341', '1985-08-21', 'lkjhgfz'),
(5, 'Juan', 'Calderon', '3968012574', '1995-03-16', 'mnbvcxs'),
(6, 'Sara', 'Rodrigez', '3867501294', '1994-08-25', 'rtyuiop'),
(7, 'Jaime', 'Olivera', '3664051829', '1989-03-31', 'asdfqwe'),
(8, 'Nicolas', 'Torres', '3462105987', '1985-08-21', 'zxcvmnb'),
(9, 'Pablo', 'Vargas', '3264198057', '2000-01-19', 'ghjklyt'),
(10, 'Tatiana', 'Gonzales', '3945028176', '1995-07-12', 'plmokni'),
(11, 'Nicol', 'Salamanca', '3847012958', '1991-07-09', 'uytrfgh'),
(12, 'Valentina', 'Gomez', '3642050918', '1994-10-05', 'hjklzxc'),
(13, 'Daniela', 'Rodrigez', '3445078296', '1995-03-16', 'bnmasdf'),
(14, 'Miguel', 'Torres', '3112511569', '2006-09-18', 'qwetryu'),
(15, 'Juan', 'Gomez', '3209867126', '2007-06-18', 'oplkjhg'),
(16, 'Juan', 'Clavijo', '3249081745', '2006-06-14', 'mnbvczx'),
(17, 'Sara', 'Garzon', '3921047583', '2004-09-20', 'asdfghr'),
(18, 'Maicol', 'Sanches', '3824501976', '1995-05-24', 'zxcvbnq');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_Productos` int NOT NULL,
  `nombre` varchar(35) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `precio` bigint NOT NULL,
  `cantidad` bigint NOT NULL,
  `fk_id_vendedor` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_Productos`, `nombre`, `precio`, `cantidad`, `fk_id_vendedor`) VALUES
(1, 'pelota', 20000, 50, 2),
(2, 'Hueso de Juguete', 60000, 30, 2),
(3, 'Comedero', 10000, 120, 2),
(4, 'Correa para perros', 65500, 40, 7),
(5, 'Arena para gatos', 59999, 250, 10),
(6, 'torre para gatos', 120000, 30, 17),
(7, 'juguete para gatos', 89999, 250, 17),
(8, 'Cama para perros', 150000, 50, 14),
(9, 'Cama para gatos', 150000, 50, 14),
(10, 'Collar para perros', 40000, 100, 2),
(11, 'Jaula para gatos', 90000, 50, 7),
(12, 'Alimento para perros', 50000, 200, 14),
(13, 'Alimento para gatos', 45000, 150, 10),
(14, 'Pelota para perros', 25000, 300, 17);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos_has_compras`
--

CREATE TABLE `productos_has_compras` (
  `fk_id_productos` int NOT NULL,
  `fk_id_compra` int NOT NULL,
  `cantidad_compra` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `productos_has_compras`
--

INSERT INTO `productos_has_compras` (`fk_id_productos`, `fk_id_compra`, `cantidad_compra`) VALUES
(1, 4, 1),
(1, 6, 1),
(3, 4, 1),
(3, 6, 1),
(6, 3, 1),
(8, 1, 1),
(8, 6, 1),
(8, 8, 1),
(11, 7, 1),
(12, 2, 1),
(12, 8, 2),
(14, 5, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `razas`
--

CREATE TABLE `razas` (
  `id_raza` int NOT NULL,
  `raza` varchar(25) NOT NULL,
  `fk_id_tipoAnimal` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `razas`
--

INSERT INTO `razas` (`id_raza`, `raza`, `fk_id_tipoAnimal`) VALUES
(1, 'Pastor alemán', 1),
(2, 'Pitbull', 1),
(3, 'siames', 2),
(4, 'Beagle', 1),
(5, 'Chihuahua', 1),
(6, 'Bóxer', 1),
(7, 'Bichón maltés', 1),
(8, 'San bernardo', 1),
(9, 'Samoyedo', 1),
(10, 'Shiba Inu', 1),
(11, 'Doberman', 1),
(12, 'Bombay', 2),
(13, 'Azul ruso', 2),
(14, 'Abisinio', 2),
(15, 'Siberiano', 2),
(16, 'Gato tonkinés', 2),
(17, 'Colorpoint Shorthair', 2),
(18, 'Australian mist', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_animales`
--

CREATE TABLE `tipo_animales` (
  `id_tipoAnimal` int NOT NULL,
  `tipo_animal` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `tipo_animales`
--

INSERT INTO `tipo_animales` (`id_tipoAnimal`, `tipo_animal`) VALUES
(1, 'Perro'),
(2, 'Gato');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vendedor`
--

CREATE TABLE `vendedor` (
  `id_vendedor` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `vendedor`
--

INSERT INTO `vendedor` (`id_vendedor`) VALUES
(2),
(3),
(4),
(5),
(7),
(8),
(9),
(10),
(14),
(16),
(17);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `adopcion`
--
ALTER TABLE `adopcion`
  ADD PRIMARY KEY (`id_adopcion`),
  ADD KEY `fk_adopcion_animales1_idx` (`fk_id_animales`),
  ADD KEY `fk_adopcion_cliente1_idx` (`fk_id_cliente`);

--
-- Indices de la tabla `animales`
--
ALTER TABLE `animales`
  ADD PRIMARY KEY (`id_animales`),
  ADD KEY `fk_animales_fundacion1` (`fk_nit_fundacion`),
  ADD KEY `fk_animales_raza1` (`fk_id_raza`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id_cliente`),
  ADD KEY `fk_cliente_persona1_idx` (`id_cliente`);

--
-- Indices de la tabla `compras`
--
ALTER TABLE `compras`
  ADD PRIMARY KEY (`id_compra`),
  ADD KEY `fk_compras_cliente1_idx` (`fk_id_cliente`);

--
-- Indices de la tabla `donacion`
--
ALTER TABLE `donacion`
  ADD PRIMARY KEY (`id_donacion`,`fk_nit_fundacion`),
  ADD KEY `fk_Cliente_has_fundacion_fundacion1_idx` (`fk_nit_fundacion`),
  ADD KEY `fk_donacion_cliente1_idx` (`fk_id_cliente`);

--
-- Indices de la tabla `encargado_fund`
--
ALTER TABLE `encargado_fund`
  ADD PRIMARY KEY (`id_encargado`),
  ADD KEY `fk_encargado_fund_persona1_idx` (`id_encargado`),
  ADD KEY `fk_encargado_fund_fundacion1_idx` (`fk_nit_fundacion`);

--
-- Indices de la tabla `fundacion`
--
ALTER TABLE `fundacion`
  ADD PRIMARY KEY (`nit_fundacion`);

--
-- Indices de la tabla `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`id_persona`),
  ADD UNIQUE KEY `id_UNIQUE` (`id_persona`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_Productos`),
  ADD KEY `fk_productos_vendedor1_idx` (`fk_id_vendedor`);

--
-- Indices de la tabla `productos_has_compras`
--
ALTER TABLE `productos_has_compras`
  ADD PRIMARY KEY (`fk_id_productos`,`fk_id_compra`),
  ADD KEY `fk_productos_has_compras_compras1` (`fk_id_compra`);

--
-- Indices de la tabla `razas`
--
ALTER TABLE `razas`
  ADD PRIMARY KEY (`id_raza`),
  ADD KEY `fk_razas_tipo_animales1_idx` (`fk_id_tipoAnimal`);

--
-- Indices de la tabla `tipo_animales`
--
ALTER TABLE `tipo_animales`
  ADD PRIMARY KEY (`id_tipoAnimal`);

--
-- Indices de la tabla `vendedor`
--
ALTER TABLE `vendedor`
  ADD PRIMARY KEY (`id_vendedor`),
  ADD KEY `fk_vendedor_persona1_idx` (`id_vendedor`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `adopcion`
--
ALTER TABLE `adopcion`
  MODIFY `id_adopcion` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `animales`
--
ALTER TABLE `animales`
  MODIFY `id_animales` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `donacion`
--
ALTER TABLE `donacion`
  MODIFY `id_donacion` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_Productos` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `razas`
--
ALTER TABLE `razas`
  MODIFY `id_raza` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `adopcion`
--
ALTER TABLE `adopcion`
  ADD CONSTRAINT `fk_adopcion_animales1` FOREIGN KEY (`fk_id_animales`) REFERENCES `animales` (`id_animales`),
  ADD CONSTRAINT `fk_adopcion_cliente1` FOREIGN KEY (`fk_id_cliente`) REFERENCES `cliente` (`id_cliente`);

--
-- Filtros para la tabla `animales`
--
ALTER TABLE `animales`
  ADD CONSTRAINT `fk_animales_fundacion1` FOREIGN KEY (`fk_nit_fundacion`) REFERENCES `fundacion` (`nit_fundacion`),
  ADD CONSTRAINT `fk_animales_raza1` FOREIGN KEY (`fk_id_raza`) REFERENCES `razas` (`id_raza`);

--
-- Filtros para la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `fk_cliente_persona1` FOREIGN KEY (`id_cliente`) REFERENCES `persona` (`id_persona`);

--
-- Filtros para la tabla `compras`
--
ALTER TABLE `compras`
  ADD CONSTRAINT `fk_compras_cliente1` FOREIGN KEY (`fk_id_cliente`) REFERENCES `cliente` (`id_cliente`);

--
-- Filtros para la tabla `donacion`
--
ALTER TABLE `donacion`
  ADD CONSTRAINT `fk_Cliente_has_fundacion_fundacion1` FOREIGN KEY (`fk_nit_fundacion`) REFERENCES `fundacion` (`nit_fundacion`),
  ADD CONSTRAINT `fk_donacion_cliente1` FOREIGN KEY (`fk_id_cliente`) REFERENCES `cliente` (`id_cliente`);

--
-- Filtros para la tabla `encargado_fund`
--
ALTER TABLE `encargado_fund`
  ADD CONSTRAINT `fk_encargado_fund_fundacion1` FOREIGN KEY (`fk_nit_fundacion`) REFERENCES `fundacion` (`nit_fundacion`),
  ADD CONSTRAINT `fk_encargado_fund_persona1` FOREIGN KEY (`id_encargado`) REFERENCES `persona` (`id_persona`);

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `fk_productos_vendedor1` FOREIGN KEY (`fk_id_vendedor`) REFERENCES `vendedor` (`id_vendedor`);

--
-- Filtros para la tabla `productos_has_compras`
--
ALTER TABLE `productos_has_compras`
  ADD CONSTRAINT `fk_productos_has_compras_compras1` FOREIGN KEY (`fk_id_compra`) REFERENCES `compras` (`id_compra`),
  ADD CONSTRAINT `fk_productos_has_compras_productos1` FOREIGN KEY (`fk_id_productos`) REFERENCES `productos` (`id_Productos`);

--
-- Filtros para la tabla `razas`
--
ALTER TABLE `razas`
  ADD CONSTRAINT `fk_razas_tipo_animales1` FOREIGN KEY (`fk_id_tipoAnimal`) REFERENCES `tipo_animales` (`id_tipoAnimal`);

--
-- Filtros para la tabla `vendedor`
--
ALTER TABLE `vendedor`
  ADD CONSTRAINT `fk_vendedor_persona1` FOREIGN KEY (`id_vendedor`) REFERENCES `persona` (`id_persona`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
