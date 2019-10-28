--Create Indices
--Address indices
CREATE INDEX idx_address_city 
ON address(address_city);

CREATE INDEX idx_address_country
ON address(address_country);

--Store indices
CREATE INDEX idx_store_name
ON store(store_name);

--Department indices
CREATE INDEX idx_department_name
ON department(department_name);

--Event indices
CREATE INDEX idx_event_end_date
ON event(event_end_date);

--Employee indices
CREATE INDEX idx_employee_given_name
ON employee(employee_given_name);

CREATE INDEX idx_employee_family_name
ON employee(employee_family_name);

CREATE INDEX idx_employee_start_date
ON employee(employee_start_date);

CREATE INDEX idx_employee_salary
ON employee(employee_salary);

--Skill indices
CREATE INDEX idx_skill_name
ON skill(skill_name);

--Employee Skill indices
CREATE INDEX idx_skill_expiration
ON employee_skill(skill_expiration);

--Timesheet indices
CREATE INDEX idx_timesheet_start_date
ON timesheet(timesheet_start_date);

--Roster indices
CREATE INDEX idx_roster_start_date
ON roster(roster_start_date);

--Product Type indices
CREATE INDEX idx_type_name
ON product_type(type_name);

--Brand indices
CREATE INDEX idx_brand_name
ON brand(brand_name);

--Product indices
CREATE INDEX idx_product_name
ON product(product_name);

CREATE INDEX idx_product_price
ON product(product_price);

CREATE INDEX idx_product_discount
ON product(product_discount);

--Inventory indices
CREATE INDEX idx_inventory_quantity
ON inventory(product_quantity);

--Discount indices
CREATE INDEX idx_discount_amount
ON discount(discount_amount);

CREATE INDEX idx_discount_start_date
ON discount(discount_start_date);

CREATE INDEX idx_discount_end_date
ON discount(discount_end_date);

--Supplier indices
CREATE INDEX idx_supplier_name
ON supplier(supplier_name);

--Customer indices
CREATE INDEX idx_customer_given_name
ON customer(customer_given_name);

CREATE INDEX idx_customer_family_name
ON customer(customer_family_name);

CREATE INDEX idx_customer_gender
ON customer(customer_gender);

--Order indices
CREATE INDEX idx_order_placed_date
ON "order"(order_placed_date);

CREATE INDEX idx_order_shipped_date
ON "order"(order_shipped_date);

CREATE INDEX idx_order_total
ON "order"(order_total);

--Invoice indices
CREATE INDEX idx_invoice_creation_date
ON invoice(invoice_creation_date);

CREATE INDEX idx_invoice_total
ON invoice(invoice_total);

--Club Card indices
CREATE INDEX idx_club_card_expiry_date
ON club_card(club_card_expiry_date);

CREATE INDEX idx_club_card_points
ON club_card(club_card_points);

CREATE INDEX idx_club_reward_count
ON club_card(club_card_reward_count);

--Mastercard indices
CREATE INDEX idx_mastercard_expiry_date
ON mastercard(mastercard_expiry_date);

--Gift Card indices
CREATE INDEX idx_gift_card_expiry_date
ON gift_card(gift_card_expiry_date);

CREATE INDEX idx_gift_card_is_enabled
ON gift_card(gift_card_is_enabled);