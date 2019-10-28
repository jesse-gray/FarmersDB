--Create SQL views to produce the following
--Farmers Club members list showing points and rewards earnt, for a given city (City here is Napier)
CREATE VIEW club_member_view AS
SELECT address_city, customer.customer_id, customer_given_name, customer_family_name, club_card_points, club_card_reward_count
FROM club_card
JOIN customer
ON club_card.customer_id = customer.customer_id
JOIN address
on customer.customer_shipping_address = address.address_id
WHERE address_city = 'Napier';

--Comprehensive product list for given product type (actual products from Farmers), showing all current prices for each product (type here is Bath Care)
CREATE VIEW product_list_view AS
SELECT type_name, product_id, brand_name, product_name, product_price
FROM product
JOIN product_type
ON product.product_type_id = product_type.type_id
JOIN brand
ON product.brand_id = brand.brand_id
WHERE product_type.type_name = 'Bath Care';

--Stock on Hand for a given store (Store here is Napier)
CREATE VIEW stock_on_hand_view AS
SELECT store_name, department_name, type_name, brand_name, product_name, product_quantity
FROM Product
JOIN inventory
ON product.product_id = inventory.product_id
JOIN store
ON inventory.store_id = store.store_id
JOIN product_type
ON product.product_type_id = product_type.type_id
JOIN department
ON product_type.department_id = department.department_id
JOIN brand
ON product.brand_id = brand.brand_id
WHERE store.store_name = 'Napier'
ORDER BY department_name, type_name, brand_name, product_name;

--A sales invoice for a given customer (Invoice ID here is 4)
CREATE VIEW invoice_view AS
SELECT store_name,
store_address.address_unit_number AS store_unit_number,
store_address.address_street_number AS store_street_number,
store_address.address_street_name AS store_street_name,
store_address.address_city AS store_city,
store_address.address_postal_code AS store_postal_code,
store_address.address_country AS store_country,
store_phone_number,
invoice_creation_date,
invoice_id,
customer.customer_id, 
customer_given_name,
customer_family_name, 
customer_address.address_unit_number AS customer_unit_number,
customer_address.address_street_number AS customer_street_number, 
customer_address.address_street_name AS customer_street_name,
customer_address.address_city AS customer_city,
customer_address.address_postal_code AS customer_postal_code,
customer_address.address_country AS customer_country,
customer_phone_number,
brand_name,
product_name,
line_quantity,
product_price,
order_line_total,
invoice_tax,
invoice_shipping,
invoice_total
FROM invoice
JOIN "order"
ON invoice.order_id = "order".order_id
JOIN order_line
ON "order".order_id = order_line.order_id
JOIN line
ON order_line.line_id = line.line_id
JOIN product
ON line.product_id = product.product_id
JOIN brand
ON product.brand_id = brand.brand_id
JOIN customer
ON "order".customer_id = customer.customer_id
JOIN store
ON invoice.store_id = store.store_id
JOIN address store_address
ON customer.customer_billing_address = store_address.address_id
JOIN address customer_address
ON store.store_address_id = customer_address.address_id
WHERE invoice.invoice_id = 63;