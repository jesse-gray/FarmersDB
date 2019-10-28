--Create two stored procedures or functions to
--Apply a discount of a specified price for all the products in a selected department for a specified date range
CREATE OR REPLACE PROCEDURE apply_discount(_discount_amount INT, _department_name VARCHAR, _start_date DATE, _end_date DATE)
LANGUAGE plpgsql
AS $$
BEGIN
    --Apply discount for date specified
    INSERT INTO discount(discount_amount, discount_start_date, discount_end_date)
    VALUES (_discount_amount, _start_date, _end_date);
    COMMIT;

    --Apply discount to given department
    INSERT INTO department_discount(department_id, discount_id)
    VALUES ((SELECT department_id FROM department WHERE department_name = _department_name), (SELECT discount_id FROM discount WHERE discount_amount = _discount_amount AND discount_start_date = _start_date AND discount_end_date = _end_date));
END;
$$;


--Accept a product return, including storing the relevant invoice and updating stock on hand
CREATE OR REPLACE PROCEDURE item_return(_invoice_id INT, _product_name VARCHAR, _quantity INT)
LANGUAGE plpgsql
AS $$
BEGIN
    --Storing relevent invoice (creates a new invoice with the same order id showing a refund)
    INSERT INTO invoice(invoice_creation_date, invoice_shipping, invoice_tax, invoice_total, invoice_status, order_id, store_id)
    VALUES (date('now'), 0, 0, -1 * (SELECT product_price FROM product WHERE product_name = _product_name), 'Returned', (SELECT order_id FROM invoice WHERE invoice_id = _invoice_id), (SELECT store_id FROM invoice WHERE invoice_id = _invoice_id));
    COMMIT;

    --Update stock available for the relevant inventory
    UPDATE inventory
    SET product_quantity = inventory.product_quantity + _quantity
    FROM inventory AS t1
    JOIN product
    ON t1.product_id = product.product_id
    JOIN line
    ON product.product_id = line.product_id
    JOIN order_line
    ON line.line_id = order_line.line_id
    JOIN "order"
    ON order_line.order_id = "order".order_id
    JOIN invoice
    ON "order".order_id = invoice.order_id
    WHERE product.product_name  = _product_name AND invoice.invoice_id = _invoice_id AND inventory.store_id = (SELECT store_id FROM invoice WHERE invoice_id = _invoice_id);
    COMMIT;
END;
$$;