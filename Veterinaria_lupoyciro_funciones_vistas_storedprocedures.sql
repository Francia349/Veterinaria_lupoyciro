USE veterinaria_lupoyciro;

CREATE VIEW vista_info_paciente AS
SELECT 
    p.id_paciente,
    p.nombre AS mascota,
    e.nombre AS especie,
    r.nombre AS raza,
    p.peso,
    CONCAT(t.nombre, ' ', t.apellido) AS tutor
FROM paciente AS p
JOIN especie AS e ON p.id_especie = e.id_especie
JOIN raza AS r ON p.id_raza = r.id_raza
JOIN tutor AS t ON p.id_tutor = t.id_tutor;

CREATE VIEW vista_historia_completa AS
SELECT 
	h.id_historia,
    h.fecha_hora,
    p.nombre AS paciente,
    CONCAT(v.nombre, ' ', v.apellido) AS veterinario,
    s.nombre AS sucursal,
    h.motivo_consulta
FROM historia_clinica AS h
JOIN paciente AS p ON h.id_paciente = p.id_paciente
JOIN veterinario AS v ON h.id_veterinario = v.id_veterinario
JOIN sucursal AS s ON h.id_sucursal = s.id_sucursal;

CREATE VIEW vista_tratamientos AS
SELECT 
    dt.id_detalle,
    h.fecha_hora,
    p.nombre AS paciente,
    m.nombre AS medicamento,
    dt.dosis
FROM detalle_tratamiento AS dt
JOIN historia_clinica AS h ON dt.id_historia = h.id_historia
JOIN paciente AS p ON h.id_paciente = p.id_paciente
JOIN medicamento AS m ON dt.id_medicamento = m.id_medicamento;

CREATE VIEW vista_especialistas AS
SELECT 
    v.id_veterinario,
    CONCAT(v.nombre, ' ', v.apellido) AS profesional,
    v.matricula,
    e.nombre AS especialidad,
    s.nombre AS sucursal
FROM veterinario AS v
JOIN especialidad AS e ON v.id_especialidad = e.id_especialidad
JOIN sucursal AS s ON v.id_sucursal = s.id_sucursal;

CREATE VIEW vista_contacto_tutores AS
SELECT 
    id_tutor,
    CONCAT(nombre, ' ', apellido) AS nombre_completo,
    email,
    telefono
FROM tutor;

DELIMITER //

CREATE DEFINER=`root`@`localhost` FUNCTION `calcular_edad`(fecha_nac DATE) RETURNS int
    NO SQL
    DETERMINISTIC
BEGIN
    DECLARE resultado INT;
    SET resultado = TIMESTAMPDIFF(YEAR, fecha_nac, CURDATE());
    RETURN resultado;
END//

CREATE DEFINER=`root`@`localhost` FUNCTION `contar_visitas`(id_pac INT) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE resultado INT;
    
    SELECT COUNT(*) 
    INTO resultado
    FROM historia_clinica 
    WHERE id_paciente = id_pac;
    
    RETURN resultado;
END//

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_paciente`(
    IN p_nombre VARCHAR(50),
    IN p_nacimiento DATE,
    IN p_peso DECIMAL(10,2),
    IN p_tutor INT,
    IN p_especie INT,
    IN p_raza INT,
    IN p_color INT,
    IN p_sexo INT
)
BEGIN
    INSERT INTO paciente (nombre, fecha_nacimiento, peso, id_tutor, id_especie, id_raza, id_color, id_sexo)
    VALUES (p_nombre, p_nacimiento, p_peso, p_tutor, p_especie, p_raza, p_color, p_sexo);
END//

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_peso`(
    IN p_id_paciente INT,
    IN p_nuevo_peso DECIMAL(10,2)
)
BEGIN
    UPDATE paciente 
    SET peso = p_nuevo_peso 
    WHERE id_paciente = p_id_paciente;
END//

DELIMITER ;