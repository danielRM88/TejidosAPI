INSERT INTO tejidos_dev.fabrics (code, description, color, unit_price, fabric_state, created_at, updated_at) VALUES ('rj-001', 'Tela Roja', 'Rojo', 150.00, 'CURRENT', current_timestamp, current_timestamp);
INSERT INTO tejidos_dev.fabrics (code, description, color, unit_price, fabric_state, created_at, updated_at) VALUES ('bl-001', 'Tela Azul', 'Azul', 200.00, 'CURRENT', current_timestamp, current_timestamp);

INSERT INTO tejidos_dev.ivas (percentage, created_at, updated_at) VALUES (12.00, current_timestamp, current_timestamp);

INSERT INTO tejidos_dev.suppliers (supplier_name, type_id, number_id, address, email, supplier_state, created_at, updated_at) VALUES ('Tesco', 'J', '123456789', 'Salford', 'tesco@gmail.com', 'CURRENT', current_timestamp, current_timestamp);

INSERT INTO tejidos_dev.purchases (supplier_id, iva_id, purchase_number, subtotal, form_of_payment, purchase_date, purchase_state, created_at, updated_at) VALUES (1, 1, '00001', 5000.00, 'credito', '2015-09-10', 'CURRENT', current_timestamp, current_timestamp);

INSERT INTO tejidos_dev.inventories (purchase_id, fabric_id, pieces, amount, unit, unit_price, created_at, updated_at) VALUES (1, 1, 50, 150.00, 'm', 200.00, current_timestamp, current_timestamp);
INSERT INTO tejidos_dev.inventories (purchase_id, fabric_id, pieces, amount, unit, unit_price, created_at, updated_at) VALUES (1, 2, 15, 45.00, 'm', 340.00, current_timestamp, current_timestamp);
INSERT INTO tejidos_dev.inventories (purchase_id, fabric_id, pieces, amount, unit, unit_price, created_at, updated_at) VALUES (1, 1, 8, 200.00, 'm', 100.00, current_timestamp, current_timestamp);
INSERT INTO tejidos_dev.inventories (purchase_id, fabric_id, pieces, amount, unit, unit_price, created_at, updated_at) VALUES (1, 1, 25, 90.00, 'm', 250.00, current_timestamp, current_timestamp);

INSERT INTO tejidos_dev.clients (client_name, type_id, number_id, address, email, client_state, created_at, updated_at) VALUES ('Daniel', 'V', '123456789', 'Trafford', 'dr@test.com', 'CURRENT', current_timestamp, current_timestamp);

INSERT INTO tejidos_dev.invoices (client_id, iva_id, invoice_number, subtotal, invoice_date, form_of_payment, created_at, updated_at) VALUES (1, 1, '000001', 10000.00, '2015-09-10', 'credito', current_timestamp, current_timestamp);

INSERT INTO tejidos_dev.sales (invoice_id, inventory_id, pieces, amount, unit, unit_price, created_at, updated_at) VALUES (1, 1, 15, 40.00, 'm', 200.00, current_timestamp, current_timestamp);
INSERT INTO tejidos_dev.sales (invoice_id, inventory_id, pieces, amount, unit, unit_price, created_at, updated_at) VALUES (1, 1, 6, 13.00, 'm', 300.00, current_timestamp, current_timestamp);
INSERT INTO tejidos_dev.sales (invoice_id, inventory_id, pieces, amount, unit, unit_price, created_at, updated_at) VALUES (1, 2, 14, 44.99, 'm', 150.00, current_timestamp, current_timestamp);
INSERT INTO tejidos_dev.sales (invoice_id, inventory_id, pieces, amount, unit, unit_price, created_at, updated_at) VALUES (1, 3, 7, 20, 'm', 50.00, current_timestamp, current_timestamp);