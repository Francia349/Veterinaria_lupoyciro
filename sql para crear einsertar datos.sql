CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_base_masiva`()
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
        
        SET v_nombre_paciente = ELT(FLOOR(1 + RAND() * 15), 
            'Lola', 'Milo', 'Rocky', 'Luna', 'Coco', 'Thor', 'Simón', 'Mia', 
            'Frida', 'Max', 'Ciro', 'Lupo', 'Bella', 'Nina', 'Toby');
        
        IF v_especie = 1 THEN SET v_raza = FLOOR(1 + RAND() * 5);
        ELSE SET v_raza = FLOOR(6 + RAND() * 5); END IF;

        INSERT INTO paciente (nombre, id_especie, id_raza, id_color, id_sexo, fecha_nacimiento, peso, id_tutor)
        VALUES (v_nombre_paciente, v_especie, v_raza, FLOOR(1 + RAND() * 5), FLOOR(1 + RAND() * 2), DATE_SUB(CURDATE(), INTERVAL FLOOR(1 + RAND() * 3000) DAY), ROUND(2 + RAND() * 30, 2), v_tutor);
        SET i = i + 1;
    END WHILE;

    SET i = 1;
    WHILE i <= max_historias DO
        SET v_paciente = FLOOR(1 + RAND() * max_pacientes);
        SET v_vet = FLOOR(1 + RAND() * 5);
        SELECT id_sucursal INTO v_sucursal FROM veterinario WHERE id_veterinario = v_vet LIMIT 1;
        
        SET v_fecha_random = DATE_SUB(NOW(), INTERVAL FLOOR(1 + RAND() * 700) DAY);
        SET v_fecha_random = ADDTIME(v_fecha_random, SEC_TO_TIME(FLOOR(0 + RAND() * 40000)));

        SET v_motivo = ELT(FLOOR(1 + RAND() * 8), 
            'Vacunación Anual', 'Control de Rutina', 'Vómitos reiterados', 'Cojera pata trasera', 
            'Decaimiento y falta de apetito', 'Revisión de herida', 'Corte de uñas y limpieza', 'Alergia en la piel');

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
END