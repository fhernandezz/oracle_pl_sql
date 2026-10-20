SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER validarMatricula 
BEFORE INSERT ON MatriculaDetalle
FOR EACH ROW

DECLARE
   vCreditosMaximo number;
   vTotalCreditos number;
   vCreditosCurso number;
   vCreditosActuales number;
   vIdEstudiante number;
   vEstaMatriculado number;
   vTotalCreditosEst number;
   
BEGIN
    SELECT e.creditosMaximo,m.creditosMat, c.creditos, m.idEstudiante, e.totalCreditosMat INTO 
        vcreditosmaximo,vtotalcreditos,vcreditoscurso, vIdEstudiante, vTotalCreditosEst
    FROM matricula m
    JOIN estudiante e
        ON m.idEstudiante = e.idEstudiante
    JOIN curso c
        ON :NEW.idCurso = c.idCurso
    WHERE :NEW.idMatricula = m.idMatricula;
    
    vCreditosActuales := vTotalCreditos + vCreditosCurso;
    
    IF vCreditosActuales > vCreditosMaximo THEN
        RAISE_APPLICATION_ERROR(-20001, 'Los creditos superan el limite');
     END IF;   
    
    
    SELECT COUNT(*)
    INTO vEstaMatriculado
    FROM matriculadetalle md
    WHERE md.idMatricula = :NEW.idMatricula 
        AND md.idCurso = :NEW.idCurso;
        
    IF vEstaMatriculado > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Ese estudiante ya tiene ese curso matriculado');
    END IF;
    
    
    UPDATE matricula m
    SET m.creditosmat = vCreditosActuales
    WHERE m.idMatricula = :NEW.idMatricula;
    
      
    UPDATE estudiante e
    SET e.totalCreditosMat = vTotalCreditosEst + vCreditosCurso
    WHERE e.idEstudiante = vIdEstudiante;
END;

