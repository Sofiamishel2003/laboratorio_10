CREATE OR REPLACE FUNCTION productos_cliente(
    codigocustomer_input integer
) 
RETURNS TABLE (
    productcode character varying,
    productline character varying,
    orderdate date,
    quantityordered bigint,
    sales double precision
) 
AS $$
BEGIN
    RETURN QUERY 
    SELECT
        p.productcode,
        p.productline,
        o.orderdate,
        o.quantityordered,
        o.sales
    FROM
        orden o
    JOIN
        cliente c ON o.codigocustomer = c.codigocustomer
    JOIN
        producto p ON o.productcode = p.productcode
    WHERE
        c.codigocustomer = codigocustomer_input;
END;
$$ LANGUAGE plpgsql;
