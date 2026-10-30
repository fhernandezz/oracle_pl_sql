SET SERVEROUTPUT ON;

SELECT * FROM empleado;
SELECT * FROM marcas;
SELECT * FROM produccion;
SELECT * FROM producto;
SELECT * FROM planilla;
SELECT * FROM diasFeriados;

CREATE OR REPLACE FUNCTION costoDestajo(p_idEmpleado number, p_fecha date)
    RETURN NUMBER
    IS
        vEsFeriado number;
        vTotalDestajo number;
    BEGIN
        SELECT COUNT(*) INTO vEsFeriado
        FROM diasFeriados df
        WHERE df.fecha = p_fecha;
        
        SELECT SUM(p.kilosProducidos * pr.costoKiloProducto) INTO vTotalDestajo
        FROM produccion p
        JOIN producto pr
            ON p.idProducto = pr.idProducto
        WHERE p_idEmpleado = p.idEmpleado AND p_fecha=p.fecha;
        
        IF vEsFeriado > 0 THEN
            RETURN (vTotalDestajo) * 2;
        
        END IF;
        
        RETURN vTotalDestajo;
            
    END;
    
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION costoHora(p_idEmpleado number, p_fecha date)
    RETURN NUMBER
    IS
        vEsFeriado number;
        vTotalHora number;
    BEGIN       
        SELECT COUNT(*) INTO vEsFeriado
        FROM diasFeriados df
        WHERE df.fecha = p_fecha;
        
        SELECT SUM(
        (m.salida - m.entrada) * (e.salario) * (
            CASE 
                WHEN m.tipoMarca = 'Nocturnas' THEN 2
                ELSE 1
            END
            )
        ) 
        INTO vTotalHora
        FROM marcas m
        JOIN empleado e
            ON m.idEmpleado = e.idEmpleado
        WHERE m.idEmpleado = p_idEmpleado AND m.fecha = p_fecha;
        
        IF vEsFeriado > 0 THEN
            vTotalHora := vTotalHora * 2;
        END IF;
        
        RETURN vTotalHora;  
    END;
    
    
        