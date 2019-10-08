--Set Total for all order_lines
DO
$do$
DECLARE
	i int;
BEGIN
	FOR i IN 1..200 LOOP
		UPDATE order_line
		SET order_line_total = (SELECT SUM(product_price * line_quantity)
		FROM order_line
		JOIN line
		ON order_line.line_id = line.line_id
		JOIN product
		ON line.product_id = product.product_id
		WHERE order_line_id = i)
		WHERE order_line_id = i;
	END LOOP;
END
$do$;

--Set Total for all orders
DO
$do$
DECLARE
	i int;
BEGIN
	FOR i IN 1..80 LOOP
		UPDATE "order"
		SET order_total = (SELECT SUM(order_line_total)
		FROM order_line
		WHERE order_id = i)
		WHERE order_id = i;
	END LOOP;
END
$do$;

--Set Total for all invoices
DO
$do$
DECLARE
	i int;
BEGIN
	FOR i IN 1..80 LOOP
		UPDATE "invoice"
		SET invoice_total = (SELECT (order_total + invoice_shipping) * (1 +(invoice_tax / 100))
		FROM invoice
	 	JOIN "order"
	 	ON invoice.order_id = "order".order_id
		WHERE invoice.order_id = i)
		WHERE order_id = i;
	END LOOP;
END
$do$;

--Set Creation Date for all invoices
DO
$do$
DECLARE
	i int;
BEGIN
	FOR i IN 1..80 LOOP
		UPDATE invoice
		SET invoice_creation_date = (SELECT order_placed_date
		FROM "order"
		WHERE order_id = i)
		WHERE order_id = i;
	END LOOP;
END
$do$;