CREATE OR REPLACE PROCEDURE calcular_salario_total()
LANGUAGE plpgsql
AS $$
DECLARE
    empleado RECORD;
    s NUMERIC;
BEGIN
    -- Intenta ejecutar el bloque de operaciones
    BEGIN
        FOR empleado IN SELECT * FROM empleado1 LOOP
            	s := 0;

            IF empleado.puesto IN ('JEFATURAS', 'GERENCIA') THEN
                -- Para jefes y gerentes, el salario total es simplemente el salario base
                s := empleado.salario;
            ELSIF empleado.puesto = 'VENDEDOR' THEN
                -- Para vendedores, agregar salario, horas extras y comisión
                s := empleado.salario + (empleado.horasextras) + (empleado.salario * empleado.comision / 100);
            ELSE
                -- Para otros empleados, sumar salario y horas extras
                s := empleado.salario + (empleado.horasextras);
            END IF;

            -- Actualizar el salario total en la base de datos para el empleado actual
            UPDATE empleado1 SET salariototal = s WHERE id = empleado.id;
        END LOOP;
    EXCEPTION
        WHEN division_by_zero THEN
            RAISE NOTICE 'Error de división por cero.';
        WHEN no_data_found THEN
            RAISE NOTICE 'No se encontraron datos.';
        WHEN too_many_rows THEN
            RAISE NOTICE 'La consulta retornó demasiadas filas.';
        WHEN OTHERS THEN
            RAISE NOTICE 'Ha ocurrido un error inesperado: %', SQLERRM;
    END;
END;
$$;


Call calcular_salario_total()
