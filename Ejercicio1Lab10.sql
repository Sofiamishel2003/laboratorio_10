CREATE OR REPLACE PROCEDURE llenar_tabla(p_fecha_inicial date, p_fecha_final date) AS $$
DECLARE
    fecha_actual date := p_fecha_inicial;
    anio_actual int;
    semestre_actual int;
    trimestre_actual int;
    mes_actual int;
	id_mes text;
BEGIN
    WHILE fecha_actual <= p_fecha_final LOOP
        anio_actual := EXTRACT(YEAR FROM fecha_actual);
        mes_actual := EXTRACT(MONTH FROM fecha_actual);
        
        IF mes_actual <= 6 THEN
            semestre_actual := 1;
        ELSE
            semestre_actual := 2;
        END IF;
		
		IF mes_actual <= 3 THEN
            trimestre_actual := 1;
        ELSIF mes_actual > 3 AND mes_actual <=6 THEN
            trimestre_actual := 2;
		ELSIF mes_actual > 6 AND mes_actual <=9 THEN
            trimestre_actual := 3;
		ELSE
            trimestre_actual := 4;
        END IF;
		
		id_mes := anio_actual::text || mes_actual::text ;
       
        INSERT INTO Dim_tiempo(anio, Id_anio, semestre, Id_semestre, trimestre, Id_trimestre, mes, Id_mes, dia)
        VALUES (anio_actual, anio_actual, semestre_actual, (anio_actual * 10 + semestre_actual), trimestre_actual, (anio_actual * 10 + trimestre_actual), mes_actual, id_mes::int, fecha_actual);
        
        fecha_actual := fecha_actual + interval '1 day';
    END LOOP;
END;
$$ LANGUAGE plpgsql;