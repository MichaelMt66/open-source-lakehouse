
DROP SCHEMA IF EXISTS transactional CASCADE;

CREATE SCHEMA transactional;

CREATE TABLE transactional.roles(
   role_id serial PRIMARY KEY,
   role_name VARCHAR (255) UNIQUE NOT NULL
);

-- -----------------------------------------------------
-- Table transactional.customers
-- -----------------------------------------------------

-- DROP TABLE transactional.customer;
CREATE TABLE transactional.customer (
	id int4 NOT NULL,
	company varchar NULL,
	last_name varchar NULL,
	first_name varchar NULL,
	email_address varchar NULL,
	job_title varchar NULL,
	business_phone varchar NULL,
	home_phone varchar NULL,
	mobile_phone varchar NULL,
	fax_number varchar NULL,
	address varchar NULL,
	city varchar NULL,
	state_province varchar NULL,
	zip_postal_code varchar NULL,
	country_region varchar NULL,
	web_page varchar NULL,
	notes varchar NULL,
	attachments varchar NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT customer_pkey PRIMARY KEY (id)
);
-- -----------------------------------------------------
-- Table transactional.employees
-- -----------------------------------------------------

-- DROP TABLE transactional.employees;

CREATE TABLE transactional.employees (
	id int4 NOT NULL,
	company varchar NULL,
	last_name varchar NULL,
	first_name varchar NULL,
	email_address varchar NULL,
	job_title varchar NULL,
	business_phone varchar NULL,
	home_phone varchar NULL,
	mobile_phone varchar NULL,
	fax_number varchar NULL,
	address varchar NULL,
	city varchar NULL,
	state_province varchar NULL,
	zip_postal_code varchar NULL,
	country_region varchar NULL,
	web_page varchar NULL,
	notes varchar NULL,
	attachments varchar NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT employees_pkey PRIMARY KEY (id)
);
-- -----------------------------------------------------
-- Table transactional.privileges
-- -----------------------------------------------------

-- DROP TABLE transactional."privileges";

CREATE TABLE transactional."privileges" (
	id int4 NOT NULL,
	privilege_name varchar NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT privileges_pkey PRIMARY KEY (id)
);
-- -----------------------------------------------------
-- Table transactional.employee_privileges
-- -----------------------------------------------------

-- DROP TABLE transactional.employee_privileges;

CREATE TABLE transactional.employee_privileges (
	employee_id int4 NOT NULL,
	privilege_id int4 NOT NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT employee_privileges_pkey PRIMARY KEY (employee_id, privilege_id)
);
-- -----------------------------------------------------
-- Table transactional.inventory_transaction_types
-- -----------------------------------------------------

-- DROP TABLE transactional.inventory_transaction_types;

CREATE TABLE transactional.inventory_transaction_types (
	id int4 NOT NULL,
	type_name varchar NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT inventory_transaction_types_pkey PRIMARY KEY (id)
);
-- -----------------------------------------------------
-- Table transactional.shippers
-- -----------------------------------------------------

-- DROP TABLE transactional.shippers;

CREATE TABLE transactional.shippers (
	id int4 NOT NULL,
	company varchar NULL,
	last_name varchar NULL,
	first_name varchar NULL,
	email_address varchar NULL,
	job_title varchar NULL,
	business_phone varchar NULL,
	home_phone varchar NULL,
	mobile_phone varchar NULL,
	fax_number varchar NULL,
	address varchar NULL,
	city varchar NULL,
	state_province varchar NULL,
	zip_postal_code varchar NULL,
	country_region varchar NULL,
	web_page varchar NULL,
	notes varchar NULL,
	attachments varchar NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT shippers_pkey PRIMARY KEY (id)
);
-- -----------------------------------------------------
-- Table transactional.orders_tax_status
-- -----------------------------------------------------

-- DROP TABLE transactional.orders_tax_status;

CREATE TABLE transactional.orders_tax_status (
	id int4 NOT NULL,
	tax_status_name varchar NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT orders_tax_status_pkey PRIMARY KEY (id)
);
-- -----------------------------------------------------
-- Table transactional.orders_status
-- -----------------------------------------------------

-- DROP TABLE transactional.orders_status;

CREATE TABLE transactional.orders_status (
	id int4 NOT NULL,
	status_name varchar NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT orders_status_pkey PRIMARY KEY (id)
);
-- -----------------------------------------------------
-- Table transactional.orders
-- -----------------------------------------------------

-- DROP TABLE transactional.orders;

CREATE TABLE transactional.orders (
	id int4 NOT NULL,
	employee_id int4 NULL,
	customer_id int4 NULL,
	order_date date NULL,
	shipped_date date NULL,
	shipper_id int4 NULL,
	ship_name varchar NULL,
	ship_address varchar NULL,
	ship_city varchar NULL,
	ship_state_province varchar NULL,
	ship_zip_postal_code varchar NULL,
	ship_country_region varchar NULL,
	shipping_fee numeric NULL,
	taxes numeric NULL,
	payment_type varchar NULL,
	paid_date date NULL,
	notes varchar NULL,
	tax_rate numeric NULL,
	tax_status_id int4 NULL,
	status_id int4 NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT orders_pkey PRIMARY KEY (id)
);


-- transactional.orders foreign keys

ALTER TABLE transactional.orders ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES transactional.customer(id);
ALTER TABLE transactional.orders ADD CONSTRAINT orders_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES transactional.employees(id);
ALTER TABLE transactional.orders ADD CONSTRAINT orders_shipper_id_fkey FOREIGN KEY (shipper_id) REFERENCES transactional.shippers(id);
ALTER TABLE transactional.orders ADD CONSTRAINT orders_status_id_fkey FOREIGN KEY (status_id) REFERENCES transactional.orders_status(id);
ALTER TABLE transactional.orders ADD CONSTRAINT orders_tax_status_id_fkey FOREIGN KEY (tax_status_id) REFERENCES transactional.orders_tax_status(id);

-- -----------------------------------------------------
-- Table transactional.products
-- -----------------------------------------------------

-- DROP TABLE transactional.products;

CREATE TABLE transactional.products (
	supplier_ids varchar NULL,
	id int4 NOT NULL,
	product_code varchar NULL,
	product_name varchar NULL,
	description varchar NULL,
	standard_cost numeric NULL,
	list_price numeric NULL,
	reorder_level int4 NULL,
	target_level int4 NULL,
	quantity_per_unit varchar NULL,
	discontinued int4 NULL,
	minimum_reorder_quantity int4 NULL,
	category varchar NULL,
	attachments varchar NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT products_pkey PRIMARY KEY (id)
);
-- -----------------------------------------------------
-- Table transactional.purchase_order_status
-- -----------------------------------------------------

-- DROP TABLE transactional.purchase_order_status;

CREATE TABLE transactional.purchase_order_status (
	id int4 NOT NULL,
	status varchar NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT purchase_order_status_pkey PRIMARY KEY (id)
);
-- -----------------------------------------------------
-- Table transactional.suppliers
-- -----------------------------------------------------

CREATE TABLE transactional.suppliers
(
	id int4 NOT NULL,
	company varchar NULL,
	last_name varchar NULL,
	first_name varchar NULL,
	email_address varchar NULL,
	job_title varchar NULL,
	business_phone varchar NULL,
	home_phone varchar NULL,
	mobile_phone varchar NULL,
	fax_number varchar NULL,
	address varchar NULL,
	city varchar NULL,
	state_province varchar NULL,
	zip_postal_code varchar NULL,
	country_region varchar NULL,
	web_page varchar NULL,
	notes varchar NULL,
	attachments varchar NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT suppliers_pkey PRIMARY KEY (id)
)
;
-- -----------------------------------------------------
-- Table transactional.purchase_orders
-- -----------------------------------------------------

-- DROP TABLE transactional.purchase_orders;

CREATE TABLE transactional.purchase_orders (
	id int4 NOT NULL,
	supplier_id int4 NULL,
	created_by int4 NULL,
	submitted_date date NULL,
	creation_date date NULL,
	status_id int4 NULL,
	expected_date date NULL,
	shipping_fee numeric NULL,
	taxes numeric NULL,
	payment_date date NULL,
	payment_amount numeric NULL,
	payment_method varchar NULL,
	notes varchar NULL,
	approved_by int4 NULL,
	approved_date date NULL,
	submitted_by int4 NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT purchase_orders_pkey PRIMARY KEY (id)
);


-- transactional.purchase_orders foreign keys

ALTER TABLE transactional.purchase_orders ADD CONSTRAINT purchase_orders_created_by_fkey FOREIGN KEY (created_by) REFERENCES transactional.employees(id);
ALTER TABLE transactional.purchase_orders ADD CONSTRAINT purchase_orders_status_id_fkey FOREIGN KEY (status_id) REFERENCES transactional.purchase_order_status(id);
ALTER TABLE transactional.purchase_orders ADD CONSTRAINT purchase_orders_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES transactional.suppliers(id);
-- -----------------------------------------------------
-- Table transactional.inventory_transactions
-- -----------------------------------------------------

-- DROP TABLE transactional.inventory_transactions;

CREATE TABLE transactional.inventory_transactions (
	id int4 NOT NULL,
	transaction_type int4 NULL,
	transaction_created_date date NULL,
	transaction_modified_date date NULL,
	product_id int4 NULL,
	quantity int4 NULL,
	purchase_order_id int4 NULL,
	customer_order_id int4 NULL,
	"comments" varchar NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT inventory_transactions_pkey PRIMARY KEY (id)
);


-- transactional.inventory_transactions foreign keys

ALTER TABLE transactional.inventory_transactions ADD CONSTRAINT inventory_transactions_product_id_fkey FOREIGN KEY (product_id) REFERENCES transactional.products(id);
ALTER TABLE transactional.inventory_transactions ADD CONSTRAINT inventory_transactions_purchase_order_id_fkey FOREIGN KEY (purchase_order_id) REFERENCES transactional.purchase_orders(id);
ALTER TABLE transactional.inventory_transactions ADD CONSTRAINT inventory_transactions_transaction_type_fkey FOREIGN KEY (transaction_type) REFERENCES transactional.inventory_transaction_types(id);

-- -----------------------------------------------------
-- Table transactional.invoices
-- -----------------------------------------------------

-- DROP TABLE transactional.invoices;

CREATE TABLE transactional.invoices (
	id int4 NOT NULL,
	order_id int4 NULL,
	invoice_date date NULL,
	due_date date NULL,
	tax numeric NULL,
	shipping numeric NULL,
	amount_due numeric NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT invoices_pkey PRIMARY KEY (id)
);


-- transactional.invoices foreign keys

ALTER TABLE transactional.invoices ADD CONSTRAINT invoices_order_id_fkey FOREIGN KEY (order_id) REFERENCES transactional.orders(id);

-- -----------------------------------------------------
-- Table transactional.order_details_status
-- -----------------------------------------------------

-- DROP TABLE transactional.order_details_status;

CREATE TABLE transactional.order_details_status (
	id int4 NOT NULL,
	status varchar NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT order_details_status_pkey PRIMARY KEY (id)
);
-- -----------------------------------------------------
-- Table transactional.order_details
-- -----------------------------------------------------

-- DROP TABLE transactional.order_details;

CREATE TABLE transactional.order_details (
	id int4 NOT NULL,
	order_id int4 NULL,
	product_id int4 NULL,
	quantity numeric NULL,
	unit_price numeric NULL,
	discount numeric NULL,
	status_id int4 NULL,
	date_allocated date NULL,
	purchase_order_id int4 NULL,
	inventory_id int4 NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT order_details_pkey PRIMARY KEY (id)
);


-- transactional.order_details foreign keys

ALTER TABLE transactional.order_details ADD CONSTRAINT order_details_order_id_fkey FOREIGN KEY (order_id) REFERENCES transactional.orders(id);
ALTER TABLE transactional.order_details ADD CONSTRAINT order_details_product_id_fkey FOREIGN KEY (product_id) REFERENCES transactional.products(id);
ALTER TABLE transactional.order_details ADD CONSTRAINT order_details_status_id_fkey FOREIGN KEY (status_id) REFERENCES transactional.order_details_status(id);

-- -----------------------------------------------------
-- Table transactional.purchase_order_details
-- -----------------------------------------------------

-- DROP TABLE transactional.purchase_order_details;

CREATE TABLE transactional.purchase_order_details (
	id int4 NOT NULL,
	purchase_order_id int4 NULL,
	product_id int4 NULL,
	quantity numeric NULL,
	unit_cost numeric NULL,
	date_received date NULL,
	posted_to_inventory int4 NULL,
	inventory_id int4 NULL,
	created_at timestamp NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT now(),
	deleted_at timestamp NULL,
	CONSTRAINT purchase_order_details_pkey PRIMARY KEY (id)
);


-- transactional.purchase_order_details foreign keys

ALTER TABLE transactional.purchase_order_details ADD CONSTRAINT purchase_order_details_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES transactional.inventory_transactions(id);
ALTER TABLE transactional.purchase_order_details ADD CONSTRAINT purchase_order_details_product_id_fkey FOREIGN KEY (product_id) REFERENCES transactional.products(id);
ALTER TABLE transactional.purchase_order_details ADD CONSTRAINT purchase_order_details_purchase_order_id_fkey FOREIGN KEY (purchase_order_id) REFERENCES transactional.purchase_orders(id);

-- -----------------------------------------------------
-- Table transactional.sales_reports
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS transactional.sales_reports (
  group_by VARCHAR,
  display VARCHAR,
  title VARCHAR,
  filter_row_source VARCHAR,
  "default" VARCHAR
)
;



CREATE TABLE IF NOT EXISTS transactional.strings (
string_id INTEGER,
string_data VARCHAR
);


\COPY transactional.customer FROM './data/customer.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.employees FROM './data/employees.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.privileges FROM './data/privileges.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.employee_privileges FROM './data/employee_privileges.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.inventory_transaction_types FROM './data/inventory_transaction_types.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.shippers FROM './data/shippers.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.orders_tax_status FROM './data/orders_tax_status.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.orders_status FROM './data/orders_status.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.orders FROM './data/orders.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.products FROM './data/products.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.purchase_order_status FROM './data/purchase_order_status.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.suppliers FROM './data/suppliers.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.purchase_orders FROM './data/purchase_orders.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.inventory_transactions FROM './data/inventory_transactions.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.invoices FROM './data/invoices.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.order_details_status FROM './data/order_details_status.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.order_details FROM './data/order_details.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.purchase_order_details FROM './data/purchase_order_details.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.sales_reports FROM './data/sales_reports.csv' DELIMITER ',' CSV HEADER;
\COPY transactional.strings FROM './data/strings.csv' DELIMITER ',' CSV HEADER;



\dt transactional.*
