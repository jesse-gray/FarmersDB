--Create database
--CREATE DATABASE farmersDB TEMPLATE template0;

--Drop all tables to start fresh
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;

--CREATE tables
--CREATE ADDRESS TYPE table
CREATE TABLE address_type (
	address_type_id				int			GENERATED ALWAYS AS IDENTITY,
	address_type_description	varchar(55)	NOT NULL,    	
	CONSTRAINT pk_address_type_id PRIMARY KEY (address_type_id) 
)WITH ( 
  OIDS=FALSE 
);

--CREATE ADDRESS table
CREATE TABLE address (
	address_id				int				GENERATED ALWAYS AS IDENTITY,     
	address_unit_number		int,
	address_street_number	int				NOT NULL,    
	address_street_name		varchar(55)		NOT NULL,     
	address_suburb			varchar(55),    
	address_city			varchar(55)		NOT NULL,    
	address_country			varchar(55)		NOT NULL,    
	address_postal_code		varchar(10)		NOT NULL,    
	address_type			int				NOT NULL 		REFERENCES address_type(address_type_id),   	
	CONSTRAINT pk_address_id PRIMARY KEY (address_id) 
)WITH ( 
  OIDS=FALSE 
);

--CREATE STORE table
CREATE TABLE store (
	store_id			int				GENERATED ALWAYS AS IDENTITY, 
	store_name 			varchar(25)		NOT NULL,   
	store_phone_number	varchar(11)		NOT NULL,    
	store_address_id   	int				NOT NULL		REFERENCES address(address_id),    	
	CONSTRAINT pk_store_id PRIMARY KEY (store_id) 
)WITH ( 
  OIDS=FALSE 
);

--CREATE DEPARTMENT table
CREATE TABLE department (
	department_id			int			GENERATED ALWAYS AS IDENTITY,
	department_name			varchar(55)	NOT NULL,
	department_acronym		varchar(3)	NOT NULL,
	department_phone_number	int			NOT NULL,    	
	CONSTRAINT pk_department_id PRIMARY KEY (department_id) 
)WITH ( 
  OIDS=FALSE 
);

--CREATE STORE DEPARTMENT table
CREATE TABLE store_department (
	store_department_id		int			GENERATED ALWAYS AS IDENTITY,
	store_id				int			NOT NULL		REFERENCES store(store_id),
	department_id			int			NOT NULL		REFERENCES department(department_id),    	
	CONSTRAINT pk_store_department_id PRIMARY KEY (store_department_id) 
)WITH ( 
  OIDS=FALSE 
);

-- --Create SALE table
-- CREATE TABLE sale (
-- 	sale_id				int				GENERATED ALWAYS AS IDENTITY,
-- 	sale_name			varchar(55)		NOT NULL,
-- 	sale_description	text			NOT NULL,
-- 	sale_start_date		date			NOT NULL,
-- 	sale_end_date		date			NOT NULL,
-- 	department_id		int				NOT NULL		REFERENCES department(department_id),    	
-- 	CONSTRAINT pk_sale_id PRIMARY KEY (sale_id) 
-- )WITH (
-- 	OIDS=FALSE
-- );


--Create EVENT table
CREATE TABLE event (
	event_id			int				GENERATED ALWAYS AS IDENTITY,
	event_name			varchar(55)		NOT NULL,
	event_description	text			NOT NULL,
	event_start_date	date			NOT NULL,
    event_end_date      date            NOT NULL,
	event_start_time	time			NOT NULL,
	store_id			int				NOT NULL		REFERENCES store(store_id),    	
	CONSTRAINT pk_event_id PRIMARY KEY (event_id) 
)WITH (
	OIDS=FALSE
);

--CREATE EMPLOYEE POSITION table
CREATE TABLE employee_position (
	employee_position_id	int				GENERATED ALWAYS AS IDENTITY,
	employee_position_name	varchar(55)		NOT NULL,
	CONSTRAINT pk_employee_position_id PRIMARY KEY (employee_position_id) 
)WITH (
	OIDS=FALSE
);

--CREATE EMPLOYEE table
CREATE TABLE employee (
	employee_id				int				GENERATED ALWAYS AS IDENTITY,
	employee_given_name		varchar(55)		NOT NULL,
	employee_family_name	varchar(55),
	employee_start_date		date			NOT NULL,
	employee_email_address	varchar(55) 	NOT NULL,
	employee_phone_number	varchar(11)		NOT NULL,
	employee_date_of_birth	date			NOT NULL,
	employee_gender			varchar(10)		NOT NULL,
	employee_salary			decimal(18, 2)	NOT NULL,
	employee_ird_no			char(11)		NOT NULL,
	employee_bank_account	char(19)		NOT NULL,
	employee_position_id	int				NOT NULL		REFERENCES employee_position(employee_position_id),
	employee_address_id		int				NOT NULL		REFERENCES address(address_id),
	employee_supervisor_id	int								REFERENCES employee(employee_id),
	CONSTRAINT pk_employee_id PRIMARY KEY (employee_id) 
)WITH (
	OIDS=FALSE
);

--CREATE DEPARTMENT EMPLOYEE table
CREATE TABLE department_employee (
	store_department_id	int			NOT NULL 		REFERENCES store_department(store_department_id),
	employee_id			int			NOT NULL		REFERENCES employee(employee_id),
	CONSTRAINT pk_store_department_id_employee_id PRIMARY KEY (store_department_id, employee_id) 
)WITH (
	OIDS=FALSE
);

--CREATE SKILL table
CREATE TABLE skill (
	skill_id			int				GENERATED ALWAYS AS IDENTITY,
	skill_name			varchar(55)		NOT NULL,
	skill_description	text,
	CONSTRAINT pk_skill_id PRIMARY KEY (skill_id) 
)WITH (
	OIDS=FALSE
);

--CREATE EMPLOYEE SKILL table
CREATE TABLE employee_skill (
	employee_id			int			NOT NULL 		REFERENCES employee(employee_id),
	skill_id			int			NOT NULL		REFERENCES skill(skill_id),
	skill_achieved		date		NOT NULL,
	skill_expiration	date,
	CONSTRAINT pk_employee_id_skill_id PRIMARY KEY (employee_id, skill_id) 
)WITH (
	OIDS=FALSE
);

--CREATE TIMESHEET table
CREATE TABLE timesheet (
	timesheet_id			int				GENERATED ALWAYS AS IDENTITY,
	timesheet_start_date	date			NOT NULL,
	timesheet_end_date		date			NOT NULL,
	timesheet_hours			float,
	employee_id				int				NOT NULL			REFERENCES employee(employee_id),
	CONSTRAINT pk_timesheet_id PRIMARY KEY (timesheet_id) 
)WITH (
	OIDS=FALSE
);

--CREATE SHIFT table
CREATE TABLE shift (
	shift_id				int				GENERATED ALWAYS AS IDENTITY,
	shift_start_time		time			NOT NULL,
	shift_end_time			time			NOT NULL,
	CONSTRAINT pk_shift_id PRIMARY KEY (shift_id) 
)WITH (
	OIDS=FALSE
);

--CREATE TIMESHEET SHIFT table
CREATE TABLE timesheet_shift (
	timesheet_id		int			NOT NULL 		REFERENCES timesheet(timesheet_id),
	shift_id			int			NOT NULL		REFERENCES shift(shift_id),
	CONSTRAINT pk_timesheet_id_shift_id PRIMARY KEY (timesheet_id, shift_id) 
)WITH (
	OIDS=FALSE
);

--CREATE ROSTER table
CREATE TABLE roster (
	roster_id				int			GENERATED ALWAYS AS IDENTITY,
	roster_start_date		date		NOT NULL,
	roster_end_date			date		NOT NULL,
	store_department_id		int			NOT NULL			REFERENCES store_department(store_department_id),
	shift_id				int			NOT NULL			REFERENCES shift(shift_id),
	CONSTRAINT pk_roster_id PRIMARY KEY (roster_id) 
)WITH (
	OIDS=FALSE
);

--CREATE EMPLOYEE ROSTER table
CREATE TABLE employee_roster (
	employee_id			int			NOT NULL 		REFERENCES employee(employee_id),
	roster_id			int			NOT NULL		REFERENCES roster(roster_id),
	CONSTRAINT pk_employee_id_roster_id PRIMARY KEY (employee_id, roster_id) 
)WITH (
	OIDS=FALSE
);

--CREATE PRODUCT TYPE table
CREATE TABLE product_type (
	type_id				int				GENERATED ALWAYS AS IDENTITY,
	type_name			varchar(55)		NOT NULL,
	type_description	text,
	department_id		int				NOT NULL		REFERENCES department(department_id),
	CONSTRAINT pk_type_id PRIMARY KEY (type_id) 
)WITH (
	OIDS=FALSE
);

--CREATE BRAND table
CREATE TABLE brand (
	brand_id			int				GENERATED ALWAYS AS IDENTITY,
	brand_name			varchar(55)		NOT NULL,
	brand_logo			bytea,
	CONSTRAINT pk_brand_id PRIMARY KEY (brand_id) 
)WITH (
	OIDS=FALSE
);

--CREATE BRAND TYPE table
CREATE TABLE brand_type (
	brand_id			int			NOT NULL 		REFERENCES brand(brand_id),
	type_id				int			NOT NULL		REFERENCES product_type(type_id),
	CONSTRAINT pk_brand_id_type_id PRIMARY KEY (brand_id, type_id) 
)WITH (
	OIDS=FALSE
);

--CREATE PRODUCT table
CREATE TABLE product (
	product_id				int				GENERATED ALWAYS AS IDENTITY,
	product_name			varchar(155)		NOT NULL,
	product_description		text,
	product_price			decimal(18, 2)			NOT NULL,
	product_sku				varchar(10),
	product_image 			bytea,
	product_discount		float,
	product_type_id			int				REFERENCES product_type(type_id),
	brand_id				int				REFERENCES brand(brand_id),
	CONSTRAINT pk_product_id PRIMARY KEY (product_id) 
)WITH (
	OIDS=FALSE
);

--Create INVENTORY table
CREATE TABLE inventory (
	store_id				int			NOT NULL 		REFERENCES store(store_id),
	product_id				int			NOT NULL		REFERENCES product(product_id),
	product_quantity		int			NOT NULL,
	CONSTRAINT pk_store_id_product_id PRIMARY KEY (store_id, product_id) 
)WITH (
	OIDS=FALSE
);

--CREATE DISCOUNT table
CREATE TABLE discount (
	discount_id				int				GENERATED ALWAYS AS IDENTITY,
	discount_amount			float			NOT NULL,
	discount_start_date		date			NOT NULL,
	discount_end_date		date			NOT NULL,
	CONSTRAINT pk_discount_id PRIMARY KEY (discount_id) 
)WITH (
	OIDS=FALSE
);

--CREATE DEPARTMENT DISCOUNT table
CREATE TABLE department_discount (
	department_id	int				REFERENCES department(department_id),
	discount_id		int				REFERENCES discount(discount_id),
	CONSTRAINT pk_department_id_discount_id PRIMARY KEY (department_id, discount_id) 
)WITH (
	OIDS=FALSE
);

--CREATE BRAND DISCOUNT table
CREATE TABLE brand_discount (
	brand_id		int			NOT NULL 		REFERENCES brand(brand_id),
	discount_id		int			NOT NULL		REFERENCES discount(discount_id),
	CONSTRAINT pk_brand_id_discount_id PRIMARY KEY (brand_id, discount_id) 
)WITH (
	OIDS=FALSE
);

--CREATE SUPPLIER table
CREATE TABLE supplier (
	supplier_id				int				GENERATED ALWAYS AS IDENTITY,
	supplier_name			varchar(55)		NOT NULL,
	supplier_phone_number	varchar(20)		NOT NULL,
	supplier_address_id		int				NOT NULL			REFERENCES address(address_id),
	CONSTRAINT pk_supplier_id PRIMARY KEY (supplier_id) 
)WITH (
	OIDS=FALSE
);

--CREATE SUPPLIER PRODUCT table
CREATE TABLE supplier_product (
	supplier_id			int			NOT NULL 		REFERENCES supplier(supplier_id),
	product_id			int			NOT NULL		REFERENCES product(product_id),
	CONSTRAINT pk_supplier_id_product_id PRIMARY KEY (supplier_id, product_id) 
)WITH (
	OIDS=FALSE
);

--CREATE CUSTOMER table
CREATE TABLE customer (
	customer_id					int				GENERATED ALWAYS AS IDENTITY,
	customer_title				varchar(10),
	customer_given_name			varchar(55)		NOT NULL,
	customer_family_name		varchar(55),
	customer_phone_number		varchar(11),
	customer_email_address		varchar(55) 	NOT NULL,
	customer_date_of_birth		date,
	customer_password			varchar(55)		NOT NULL,
	customer_gender				varchar(10),
	customer_shipping_address	int				NOT NULL			REFERENCES address(address_id),
	customer_billing_address	int									REFERENCES address(address_id),
	CONSTRAINT pk_customer_id PRIMARY KEY (customer_id) 
)WITH (
	OIDS=FALSE
);

--CREATE ORDER table
CREATE TABLE "order"(
	order_id			int				GENERATED ALWAYS AS IDENTITY,
	order_placed_date	date			NOT NULL,
	order_shipped_date	date,
	order_total			decimal(18, 2)			NOT NULL,
	customer_id			int				NOT NULL			REFERENCES customer(customer_id),
	CONSTRAINT pk_order_id PRIMARY KEY (order_id) 
)WITH (
	OIDS=FALSE
);

--CREATE LINE table
CREATE TABLE line (
	line_id				int				GENERATED ALWAYS AS IDENTITY,
	line_quantity		int				NOT NULL,
	product_id			int				NOT NULL			REFERENCES product(product_id),
	CONSTRAINT pk_line_id PRIMARY KEY (line_id) 
)WITH (
	OIDS=FALSE
);

--CREATE ORDER LINE table
CREATE TABLE order_line (
	order_line_id		int 		GENERATED ALWAYS AS IDENTITY,
	order_id			int			NOT NULL		REFERENCES "order"(order_id),
	line_id				int			NOT NULL		REFERENCES line(line_id),
	order_line_total	decimal(18, 2)			NOT NULL,
	CONSTRAINT pk_order_line_id PRIMARY KEY (order_line_id) 
)WITH (
	OIDS=FALSE
);

--CREATE INVOICE table
CREATE TABLE invoice (
	invoice_id				int				GENERATED ALWAYS AS IDENTITY,
	invoice_creation_date	date			NOT NULL,
	invoice_shipping		decimal(18, 2)			NOT NULL,
	invoice_tax				float			NOT NULL,
	invoice_total			decimal(18, 2)			NOT NULL,
	invoice_status			varchar(10)		NOT NULL,
	order_id				int				NOT NULL			REFERENCES "order"(order_id),
	store_id				int				NOT NULL			REFERENCES store(store_id),
	CONSTRAINT pk_invoice_id PRIMARY KEY (invoice_id) 
)WITH (
	OIDS=FALSE
);

--CREATE SHOPPING CART table
CREATE TABLE shopping_cart (
	cart_id			int				GENERATED ALWAYS AS IDENTITY,
	customer_id		int				NOT NULL			REFERENCES customer(customer_id),
	CONSTRAINT pk_cart_id PRIMARY KEY (cart_id) 
)WITH (
	OIDS=FALSE
);

--CREATE CART LINE table
CREATE TABLE cart_line (
	cart_id			int			NOT NULL 		REFERENCES shopping_cart(cart_id),
	line_id			int			NOT NULL		REFERENCES "line"(line_id),
	CONSTRAINT pk_cart_id_line_id PRIMARY KEY (cart_id, line_id) 
)WITH (
	OIDS=FALSE
);

--CREATE WISHLIST table
CREATE TABLE wishlist (
	wishlist_id		int				GENERATED ALWAYS AS IDENTITY,
	customer_id		int				NOT NULL			REFERENCES customer(customer_id),
	CONSTRAINT pk_wishlist_id PRIMARY KEY (wishlist_id) 
)WITH (
	OIDS=FALSE
);

--CREATE WISHLIST PRODUCT table
CREATE TABLE wishlist_product (
	wishlist_id			int			NOT NULL 		REFERENCES wishlist(wishlist_id),
	product_id			int			NOT NULL		REFERENCES product(product_id),
	CONSTRAINT pk_wishlist_id_product_id PRIMARY KEY (wishlist_id, product_id) 
)WITH (
	OIDS=FALSE
);

--CREATE CLUB CARD table
CREATE TABLE club_card (
	club_card_id				int				GENERATED ALWAYS AS IDENTITY,
	club_card_number			char(12)		NOT NULL,
	club_card_valid_date		date			NOT NULL,
	club_card_expiry_date		date			NOT NULL,
	club_card_points			int,
	club_card_reward_count		int,
	customer_id					int				NOT NULL			REFERENCES customer(customer_id),
	CONSTRAINT pk_club_card_id PRIMARY KEY (club_card_id) 
)WITH (
	OIDS=FALSE
);

--CREATE MASTERCARD table
CREATE TABLE mastercard (
	mastercard_id				int			GENERATED ALWAYS AS IDENTITY,
	mastercard_number			char(12)	NOT NULL,
	mastercard_valid_date		date		NOT NULL,
	mastercard_expiry_date		date		NOT NULL,
	customer_id					int			NOT NULL			REFERENCES customer(customer_id),
	club_card_id				int			NOT NULL			REFERENCES club_card(club_card_id),
	CONSTRAINT pk_mastercard_id PRIMARY KEY (mastercard_id) 
)WITH (
	OIDS=FALSE
);

--CREATE GIFT CARD table
CREATE TABLE gift_card (
	gift_card_id			int			GENERATED ALWAYS AS IDENTITY,
	gift_card_expiry_date	date		NOT NULL,
	gift_card_total			decimal(18, 2)		NOT NULL,
	gift_card_is_enabled	bool		NOT NULL,
	customer_recipient_id	int			NOT NULL			REFERENCES customer(customer_id),
	customer_donor_id		int			NOT NULL			REFERENCES customer(customer_id),
	CONSTRAINT pk_gift_card_id PRIMARY KEY (gift_card_id) 
)WITH (
	OIDS=FALSE
);

--CREATE REUTRN table
-- CREATE TABLE return (
-- 	return_id		int		GENERATED ALWAYS AS IDENTITY,
-- 	return_date		date	NOT NULL,
-- 	order_line_id	int		NOT NULL 		REFERENCES order_line(order_line_id),
-- 	order_id		int 	NOT NULL		REFERENCES "order"(order_id),
-- 	CONSTRAINT pk_return_id PRIMARY KEY (return_id)
-- )WITH (
-- 	OIDS=FALSE
-- );