USE veterinaria_lupoyciro;

INSERT INTO especie (nombre) VALUES ('Perro'), ('Gato');

INSERT INTO raza (nombre, id_especie) VALUES 
('Mestizo', 1), ('Caniche', 1), ('Golden Ret', 1), ('Bulldog', 1), ('Labrador', 1),
('Mestizo', 2), ('Siamés', 2), ('Persa', 2), ('Angora', 2), ('Maine Coon', 2);

INSERT INTO color (nombre) VALUES ('Negro'), ('Blanco'), ('Marrón'), ('Gris'), ('Manchado');
INSERT INTO sexo (nombre) VALUES ('Macho'), ('Hembra');

INSERT INTO especialidad (nombre) VALUES 
('Clínica General'), ('Cirugía'), ('Traumatología'), ('Dermatología'), ('Cardiología');

INSERT INTO sintoma (nombre) VALUES 
('Vómitos'), ('Diarrea'), ('Tos'), ('Cojera'), ('Prurito (Picazón)'), 
('Decaimiento'), ('Anorexia'), ('Sangrado'), ('Convulsiones'), ('Dificultad Resp');

INSERT INTO diagnostico (nombre) VALUES 
('Gastroenteritis'), ('Otitis'), ('Fractura'), ('Alergia Alimentaria'), ('Insuficiencia Cardíaca'),
('Control Sano'), ('Parasitosis'), ('Moquillo'), ('Cistitis'), ('Dermatitis');

INSERT INTO medicamento (nombre, presentacion) VALUES 
('Amoxicilina', 'Comprimidos'), ('Meloxicam', 'Jarabe'), ('Prednisolona', 'Comprimidos'),
('Tramadol', 'Inyectable'), ('Vacuna Quintuple', 'Ampolla'), ('Pipeta Pulgas', 'Pipeta'),
('Ranitidina', 'Inyectable'), ('Cefalexina', 'Comprimidos');

INSERT INTO sucursal (nombre, direccion, telefono) VALUES 
('Sede Central', 'Av. San Martín 1234', '444-1111'),
('Sede Norte', 'Calle Los Pinos 88', '444-2222');

INSERT INTO veterinario (nombre, apellido, matricula, id_especialidad, telefono, id_sucursal) VALUES 
('Roberto', 'Cura', 'MP-100', 1, '155-111', 1),
('Ana', 'Sánchez', 'MP-200', 2, '155-222', 1),
('Carlos', 'Díaz', 'MP-300', 3, '155-333', 2),
('Lucía', 'Gómez', 'MP-400', 4, '155-444', 2),
('Pedro', 'López', 'MP-500', 1, '155-555', 2);

INSERT INTO proveedor (nombre_empresa, telefono, email, direccion) VALUES
('Distribuidora Vet', '111-222', 'ventas@distri.com', 'Calle 1'),
('Insumos Medicos SA', '333-444', 'contacto@insumos.com', 'Calle 2');

INSERT INTO insumo (nombre, descripcion, precio_costo, precio_venta, stock_actual) VALUES
('Jeringas 5ml', 'Caja x 100', 500.00, 1000.00, 50),
('Gasas Estériles', 'Paquete x 10', 200.00, 400.00, 100),
('Alimento Puppy', 'Bolsa 15kg', 15000.00, 22000.00, 10);

CALL sp_poblar_base_masiva();