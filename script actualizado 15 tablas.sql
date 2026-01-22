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
    id_especie INT,
    id_raza INT,
    id_color INT,
    id_sexo INT,
    fecha_nacimiento DATE NOT NULL,
    peso DECIMAL(10,2),
    id_tutor INT NOT NULL, 
    PRIMARY KEY (id_paciente),
    FOREIGN KEY (id_tutor) REFERENCES tutor(id_tutor),
    FOREIGN KEY (id_especie) REFERENCES especie(id_especie),
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