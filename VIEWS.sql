--Create SQL views to produce the following
--Farmers Club members list showing points and rewards earnt, for a given store
CREATE VIEW club_member_master AS
SELECT customer.customer_id, CONCAT(customer_given_name, ' ', customer_family_name) AS "Customer Name", club_card_points, club_card_reward_count
FROM club_card
JOIN customer
ON club_card.customer_id = customer.customer_id;

--Comprehensive product list for given product category (actual products from Farmers), showing all current prices for each product
CREATE VIEW product_list_master AS
SELECT type_name, product_id, CONCAT(brand_name, ' ', product_name) AS Product, product_price
FROM product
JOIN product_type
ON product.product_type_id = product_type.type_id
JOIN brand
ON product.brand_id = brand.brand_id;

--Stock on Hand for a given store
CREATE VIEW stock_on_hand_master AS
SELECT store_name, department_name, type_name, CONCAT(brand_name, ' ', product_name) AS Product, product_quantity
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
ORDER BY department_name, type_name, brand_name, product_name;

--A sales invoice for a given customer
CREATE VIEW invoice_master AS
SELECT store_name AS Store,
CONCAT (store_address.address_unit_number, ' ', store_address.address_street_number, ' ', store_address.address_street_name) AS "Store Address",
CONCAT(store_address.address_city, ' ', store_address.address_postal_code) AS "Store City",
store_address.address_country AS "Store Country",
store_phone_number,
invoice_creation_date,
invoice_id,
customer.customer_id, 
CONCAT(customer_given_name, ' ', customer_family_name) AS "Customer Name", 
CONCAT(customer_address.address_unit_number, ' ', customer_address.address_street_number, ' ', customer_address.address_street_name) AS "Customer Address",
CONCAT(customer_address.address_city, ' ', customer_address.address_postal_code)AS "Customer City",
customer_address.address_country AS "Customer Country",
customer_phone_number,
CONCAT(brand_name, ' ', product_name) AS "Product",
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
ON store.store_address_id = customer_address.address_id;