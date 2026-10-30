-- 1. Borrado seguro de tablas mediante PL/SQL (Evita el ORA-00933)
BEGIN
    FOR t IN (
        SELECT table_name 
        FROM user_tables 
        WHERE table_name IN ('EMPLEADO', 'PRODUCTO', 'MARCAS', 'PRODUCCION', 'PLANILLA', 'DIASFERIADOS')
    ) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE "' || t.table_name || '" CASCADE CONSTRAINTS';
    END LOOP;
END;
/

-- 2. Creación de tablas e integridad referencial

CREATE TABLE empleado (
    idEmpleado   NUMBER,
    nombre       VARCHAR2(50),
    tipoEmpleado VARCHAR2(20),
    salario      NUMBER,
    CONSTRAINT pk_empleado PRIMARY KEY (idEmpleado)
);

CREATE TABLE producto (
    idProducto          NUMBER,
    nombre              VARCHAR2(50),
    costoKiloProducido  NUMBER,
    CONSTRAINT pk_producto PRIMARY KEY (idProducto)
);

CREATE TABLE marcas (
    idMarca    NUMBER,
    idEmpleado NUMBER,
    fecha      DATE,
    entrada    NUMBER,
    salida     NUMBER,
    tipoMarca  VARCHAR2(10),
    CONSTRAINT pk_marcas PRIMARY KEY (idMarca),
    CONSTRAINT fk_marcas_empleado FOREIGN KEY (idEmpleado) 
        REFERENCES empleado(idEmpleado)
);

CREATE TABLE produccion (
    idProduccion    NUMBER,
    fecha           DATE,
    idProducto      NUMBER,
    idEmpleado      NUMBER,
    kilosProducidos NUMBER,
    CONSTRAINT pk_produccion PRIMARY KEY (idProduccion),
    CONSTRAINT fk_prod_producto FOREIGN KEY (idProducto) 
        REFERENCES producto(idProducto),
    CONSTRAINT fk_prod_empleado FOREIGN KEY (idEmpleado) 
        REFERENCES empleado(idEmpleado)
);

CREATE TABLE planilla (
    idEmpleado  NUMBER,
    fecha       DATE,
    montoAPagar NUMBER,
    CONSTRAINT pk_planilla PRIMARY KEY (idEmpleado, fecha),
    CONSTRAINT fk_planilla_empleado FOREIGN KEY (idEmpleado) 
        REFERENCES empleado(idEmpleado)
);

CREATE TABLE diasFeriados (
    idFeriado   NUMBER,
    fecha       DATE,
    descripcion VARCHAR2(50),
    CONSTRAINT pk_diasFeriados PRIMARY KEY (idFeriado)
);