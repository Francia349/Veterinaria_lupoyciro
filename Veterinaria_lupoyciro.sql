CREATE SCHEMA veterinaria_lupoyciro;
USE veterinaria_lupoyciro;

CREATE TABLE sucursal (
    id_sucursal INT NOT NULL,
    nombre VARCHAR(50),
    direccion VARCHAR(100),
    telefono VARCHAR(11),
    PRIMARY KEY (id_sucursal)
);
CREATE TABLE tutor (
    id_tutor INT NOT NULL,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    telefono VARCHAR(11),
    email VARCHAR(100),
    direccion VARCHAR(100),
    PRIMARY KEY (id_tutor)
);
CREATE TABLE veterinario (
    id_veterinario INT NOT NULL,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    matricula VARCHAR(10),
    especialidad VARCHAR(50),
    telefono VARCHAR(11),
    id_sucursal INT NOT NULL, 
    PRIMARY KEY (id_veterinario),
    FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal)
);
CREATE TABLE paciente (
    id_paciente INT NOT NULL,
    nombre VARCHAR(50),
    especie VARCHAR(30),
    raza VARCHAR(30),
    color VARCHAR(30),
    sexo VARCHAR(10),
    fecha_nacimiento DATE NOT NULL,
    peso DECIMAL(10,2),
    id_tutor INT NOT NULL, 
    PRIMARY KEY (id_paciente),
    FOREIGN KEY (id_tutor) REFERENCES tutor(id_tutor)
);
CREATE TABLE historia_clinica (
    id_historia INT NOT NULL,
    fecha_hora DATETIME,
    motivo_consulta TEXT,
    sintomas TEXT,
    diagnostico TEXT,
    tratamiento TEXT,
    id_paciente INT NOT NULL,
    id_veterinario INT NOT NULL,
    id_sucursal INT NOT NULL,
    PRIMARY KEY (id_historia),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_veterinario) REFERENCES veterinario(id_veterinario),
    FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal)
);