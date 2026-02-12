DROP SCHEMA IF EXISTS veterinaria_lupoyciro;
CREATE SCHEMA veterinaria_lupoyciro;
USE veterinaria_lupoyciro;

CREATE TABLE especie (
    id_especie INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(20),
    PRIMARY KEY (id_especie)
);

CREATE TABLE raza (
    id_raza INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(20),
    id_especie INT,
    PRIMARY KEY (id_raza),
    FOREIGN KEY (id_especie) REFERENCES especie(id_especie)
);

CREATE TABLE color (
    id_color INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(10),
    PRIMARY KEY (id_color)
);

CREATE TABLE sexo (
    id_sexo INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(10),
    PRIMARY KEY (id_sexo)
);

CREATE TABLE especialidad (
    id_especialidad INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(20),
    PRIMARY KEY (id_especialidad)
);

CREATE TABLE sintoma (
    id_sintoma INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50),
    PRIMARY KEY (id_sintoma)
);

CREATE TABLE diagnostico (
    id_diagnostico INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50),
    PRIMARY KEY (id_diagnostico)
);

CREATE TABLE medicamento (
    id_medicamento INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50),
    presentacion VARCHAR(50),
    PRIMARY KEY (id_medicamento)
);

CREATE TABLE sucursal (
    id_sucursal INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50),
    direccion VARCHAR(100),
    telefono VARCHAR(11),
    PRIMARY KEY (id_sucursal)
);

CREATE TABLE tutor (
    id_tutor INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    telefono VARCHAR(11),
    email VARCHAR(100),
    direccion VARCHAR(100),
    PRIMARY KEY (id_tutor)
);

CREATE TABLE veterinario (
    id_veterinario INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    matricula VARCHAR(10),
    id_especialidad INT,
    telefono VARCHAR(11),
    id_sucursal INT NOT NULL, 
    PRIMARY KEY (id_veterinario),
    FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal),
    FOREIGN KEY (id_especialidad) REFERENCES especialidad(id_especialidad)
);

CREATE TABLE paciente (
    id_paciente INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50),
    id_raza INT,
    id_color INT,
    id_sexo INT,
    fecha_nacimiento DATE NOT NULL,
    peso DECIMAL(10,2),
    id_tutor INT NOT NULL, 
    PRIMARY KEY (id_paciente),
    FOREIGN KEY (id_tutor) REFERENCES tutor(id_tutor),
    FOREIGN KEY (id_raza) REFERENCES raza(id_raza),
    FOREIGN KEY (id_color) REFERENCES color(id_color),
    FOREIGN KEY (id_sexo) REFERENCES sexo(id_sexo)
);

CREATE TABLE historia_clinica (
    id_historia INT NOT NULL AUTO_INCREMENT,
    fecha_hora DATETIME,
    motivo_consulta TEXT,
    id_paciente INT NOT NULL,
    id_veterinario INT NOT NULL,
    id_sucursal INT NOT NULL,
    PRIMARY KEY (id_historia),    
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_veterinario) REFERENCES veterinario(id_veterinario),
    FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal)
);

CREATE TABLE lista_sintoma (
    id_lista_sintoma INT NOT NULL AUTO_INCREMENT,
    id_historia INT,
    id_sintoma INT,
    PRIMARY KEY (id_lista_sintoma),
    FOREIGN KEY (id_historia) REFERENCES historia_clinica(id_historia),
    FOREIGN KEY (id_sintoma) REFERENCES sintoma(id_sintoma)
);

CREATE TABLE lista_diagnostico (
    id_lista_diagnostico INT NOT NULL AUTO_INCREMENT,
    id_historia INT,
    id_diagnostico INT,
    observacion VARCHAR(100),
    PRIMARY KEY (id_lista_diagnostico),
    FOREIGN KEY (id_historia) REFERENCES historia_clinica(id_historia),
    FOREIGN KEY (id_diagnostico) REFERENCES diagnostico(id_diagnostico)
);

CREATE TABLE detalle_tratamiento (
    id_detalle INT NOT NULL AUTO_INCREMENT,
    id_historia INT,
    id_medicamento INT,
    dosis VARCHAR(100),
    PRIMARY KEY (id_detalle),
    FOREIGN KEY (id_historia) REFERENCES historia_clinica(id_historia),
    FOREIGN KEY (id_medicamento) REFERENCES medicamento(id_medicamento)
);

CREATE TABLE proveedor (
    id_proveedor INT AUTO_INCREMENT,
    nombre_empresa VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion VARCHAR(100),
    PRIMARY KEY (id_proveedor)
);

CREATE TABLE insumo (
    id_insumo INT AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(100),
    precio_costo DECIMAL(10,2),
    precio_venta DECIMAL(10,2),
    stock_actual INT DEFAULT 0,
    stock_minimo INT DEFAULT 5,
    PRIMARY KEY (id_insumo)
);

CREATE TABLE compra_insumo (
    id_compra INT AUTO_INCREMENT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_proveedor INT,
    id_insumo INT,
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    PRIMARY KEY (id_compra),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    FOREIGN KEY (id_insumo) REFERENCES insumo(id_insumo)
);

CREATE TABLE auditoria_peso (
    id_auditoria INT AUTO_INCREMENT,
    id_paciente INT,
    peso_anterior DECIMAL(10,2),
    peso_nuevo DECIMAL(10,2),
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50),
    PRIMARY KEY (id_auditoria)
);

DELIMITER //
CREATE TRIGGER `trg_auditoria_peso`
AFTER UPDATE ON `paciente`
FOR EACH ROW
BEGIN
    IF OLD.peso <> NEW.peso THEN
        INSERT INTO auditoria_peso (id_paciente, peso_anterior, peso_nuevo, usuario)
        VALUES (OLD.id_paciente, OLD.peso, NEW.peso, USER());
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER `trg_actualizar_stock_compra`
AFTER INSERT ON `compra_insumo`
FOR EACH ROW
BEGIN
    UPDATE insumo
    SET stock_actual = stock_actual + NEW.cantidad
    WHERE id_insumo = NEW.id_insumo;
END//
DELIMITER ;

CREATE VIEW vista_info_paciente AS
SELECT 
    p.id_paciente,
    p.nombre AS mascota,
    e.nombre AS especie,
    r.nombre AS raza,
    p.peso,
    CONCAT(t.nombre, ' ', t.apellido) AS tutor
FROM paciente AS p
JOIN raza AS r ON p.id_raza = r.id_raza
JOIN especie AS e ON r.id_especie = e.id_especie
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

CREATE FUNCTION `calcular_edad`(fecha_nac DATE) RETURNS int
    NO SQL
    DETERMINISTIC
BEGIN
    DECLARE resultado INT;
    SET resultado = TIMESTAMPDIFF(YEAR, fecha_nac, CURDATE());
    RETURN resultado;
END//

CREATE FUNCTION `contar_visitas`(id_pac INT) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE resultado INT;
    SELECT COUNT(*) INTO resultado FROM historia_clinica WHERE id_paciente = id_pac;
    RETURN resultado;
END//

CREATE PROCEDURE `sp_registrar_paciente`(
    IN p_nombre VARCHAR(50),
    IN p_nacimiento DATE,
    IN p_peso DECIMAL(10,2),
    IN p_tutor INT,
    IN p_raza INT,
    IN p_color INT,
    IN p_sexo INT
)
BEGIN
    INSERT INTO paciente (nombre, fecha_nacimiento, peso, id_tutor, id_raza, id_color, id_sexo)
    VALUES (p_nombre, p_nacimiento, p_peso, p_tutor, p_raza, p_color, p_sexo);
END//

CREATE PROCEDURE `sp_actualizar_peso`(
    IN p_id_paciente INT,
    IN p_nuevo_peso DECIMAL(10,2)
)
BEGIN
    UPDATE paciente SET peso = p_nuevo_peso WHERE id_paciente = p_id_paciente;
END//

CREATE PROCEDURE sp_poblar_base_masiva()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max_tutores INT DEFAULT 50;
    DECLARE max_pacientes INT DEFAULT 200; 
    DECLARE max_historias INT DEFAULT 1000;
    
    DECLARE v_tutor INT;
    DECLARE v_especie INT;
    DECLARE v_raza INT;
    DECLARE v_paciente INT;
    DECLARE v_vet INT;
    DECLARE v_sucursal INT;
    DECLARE v_historia INT;
    
    DECLARE v_nombre_paciente VARCHAR(50);
    DECLARE v_apellido_tutor VARCHAR(50);
    DECLARE v_motivo VARCHAR(100);
    DECLARE v_fecha_random DATETIME;

    SET i = 1;
    WHILE i <= max_tutores DO
        SET v_apellido_tutor = ELT(FLOOR(1 + RAND() * 10), 'González', 'Rodríguez', 'Gómez', 'Fernández', 'López', 'Díaz', 'Martínez', 'Pérez', 'Romero', 'Sánchez');
        INSERT INTO tutor (nombre, apellido, telefono, email, direccion)
        VALUES (CONCAT('Dueño_', i), v_apellido_tutor, CONCAT('155-', FLOOR(100000 + RAND() * 899999)), CONCAT('cliente', i, '@gmail.com'), 'Calle Falsa 123');
        SET i = i + 1;
    END WHILE;

    SET i = 1;
    WHILE i <= max_pacientes DO
        SET v_especie = FLOOR(1 + RAND() * 2);
        SET v_tutor = FLOOR(1 + RAND() * max_tutores);
        
        SET v_nombre_paciente = ELT(FLOOR(1 + RAND() * 15), 'Lola', 'Milo', 'Rocky', 'Luna', 'Coco', 'Thor', 'Simón', 'Mia', 'Frida', 'Max', 'Ciro', 'Lupo', 'Bella', 'Nina', 'Toby');
        
        IF v_especie = 1 THEN SET v_raza = FLOOR(1 + RAND() * 5);
        ELSE SET v_raza = FLOOR(6 + RAND() * 5); END IF;

        INSERT INTO paciente (nombre, id_raza, id_color, id_sexo, fecha_nacimiento, peso, id_tutor)
        VALUES (v_nombre_paciente, v_raza, FLOOR(1 + RAND() * 5), FLOOR(1 + RAND() * 2), DATE_SUB(CURDATE(), INTERVAL FLOOR(1 + RAND() * 3000) DAY), ROUND(2 + RAND() * 30, 2), v_tutor);
        SET i = i + 1;
    END WHILE;

    SET i = 1;
    WHILE i <= max_historias DO
        SET v_paciente = FLOOR(1 + RAND() * max_pacientes);
        SET v_vet = FLOOR(1 + RAND() * 5);
        SELECT id_sucursal INTO v_sucursal FROM veterinario WHERE id_veterinario = v_vet LIMIT 1;
        
        SET v_fecha_random = DATE_SUB(NOW(), INTERVAL FLOOR(1 + RAND() * 700) DAY);
        SET v_fecha_random = ADDTIME(v_fecha_random, SEC_TO_TIME(FLOOR(0 + RAND() * 40000)));

        SET v_motivo = ELT(FLOOR(1 + RAND() * 8), 'Vacunación Anual', 'Control de Rutina', 'Vómitos reiterados', 'Cojera pata trasera', 'Decaimiento', 'Revisión de herida', 'Corte de uñas', 'Alergia en la piel');

        INSERT INTO historia_clinica (fecha_hora, motivo_consulta, id_paciente, id_veterinario, id_sucursal)
        VALUES (v_fecha_random, v_motivo, v_paciente, v_vet, v_sucursal);
        
        SET v_historia = LAST_INSERT_ID();
        INSERT INTO lista_sintoma (id_historia, id_sintoma) VALUES (v_historia, FLOOR(1 + RAND() * 10));
        INSERT INTO lista_diagnostico (id_historia, id_diagnostico, observacion) VALUES (v_historia, FLOOR(1 + RAND() * 10), 'Obs');
        
        IF RAND() > 0.5 THEN
            INSERT INTO detalle_tratamiento (id_historia, id_medicamento, dosis) VALUES (v_historia, FLOOR(1 + RAND() * 8), 'Cada 12hs');
        END IF;

        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;