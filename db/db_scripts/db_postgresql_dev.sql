/* SCRIPTS DE INICIALIZACION
  CORRER COMO SUPERUSER */

DROP TABLE TEJIDOS_DEV.SALES_HAVE_INVENTORIES;

DROP TABLE TEJIDOS_DEV.EXISTENCES;

DROP TABLE TEJIDOS_DEV.INVENTORIES;

DROP SEQUENCE TEJIDOS_DEV.SALES_NOI_NUMBER_SQ;
DROP SEQUENCE TEJIDOS_DEV.SALES_NUMBER_SQ;
DROP TABLE TEJIDOS_DEV.SALES;


DROP TABLE TEJIDOS_DEV.CLIENTS_HAVE_PHONES;

DROP TABLE TEJIDOS_DEV.PURCHASES;

DROP TABLE TEJIDOS_DEV.SUPPLIERS_HAVE_PHONES;

DROP TABLE TEJIDOS_DEV.FABRICS;

/*DROP TABLE TEJIDOS_DEV.SCHEMA_MIGRATIONS;*/

DROP TABLE TEJIDOS_DEV.USERS;

DROP TABLE TEJIDOS_DEV.CLIENTS;

DROP TABLE TEJIDOS_DEV.SUPPLIERS;

DROP TABLE TEJIDOS_DEV.PHONES;

DROP TABLE TEJIDOS_DEV.IVAS;

DROP SCHEMA TEJIDOS_DEV CASCADE;

DROP USER tuser;


/* ############################################################################################## */
CREATE SCHEMA TEJIDOS_DEV;
/* ############################################################################################## */



/* ############################################################################################## */
CREATE TABLE TEJIDOS_DEV.IVAS (
  ID SERIAL  NOT NULL ,
  PERCENTAGE NUMERIC(5,2)   NOT NULL ,
  INSERT_DATE TIMESTAMP   NOT NULL   ,
PRIMARY KEY(ID));

CREATE UNIQUE INDEX IVAS_UNIQUE_PERCENTAGE ON TEJIDOS_DEV.IVAS (PERCENTAGE);
/* ############################################################################################## */



/* ############################################################################################## */
CREATE TABLE TEJIDOS_DEV.PHONES (
  ID SERIAL  NOT NULL ,
  COUNTRY_CODE VARCHAR(5)   NOT NULL ,
  AREA_CODE VARCHAR(5)   NOT NULL ,
  PHONE_NUMBER VARCHAR(15)   NOT NULL   ,
PRIMARY KEY(ID));

CREATE UNIQUE INDEX PHONES_UNIQUE_PHONE ON TEJIDOS_DEV.PHONES (COUNTRY_CODE, AREA_CODE, PHONE_NUMBER);
/* ############################################################################################## */



/* ############################################################################################## */
CREATE TABLE TEJIDOS_DEV.SUPPLIERS (
  ID SERIAL  NOT NULL ,
  SUPPLIER_NAME  VARCHAR(155)   NOT NULL ,
  TYPE_ID  VARCHAR(5)      NOT NULL ,
  NUMBER_ID VARCHAR(50)   NOT NULL ,
  ADDRESS VARCHAR(255)    ,
  EMAIL VARCHAR(25)      ,
  SUPPLIER_STATE VARCHAR(20)  DEFAULT 'CURRENT' NOT NULL   ,
PRIMARY KEY(ID)  );

CREATE UNIQUE INDEX SUPPLIERS_UNIQUE_ID ON TEJIDOS_DEV.SUPPLIERS (TYPE_ID, NUMBER_ID) WHERE SUPPLIER_STATE = 'CURRENT';
/* ############################################################################################## */



/* ############################################################################################## */
CREATE TABLE TEJIDOS_DEV.CLIENTS (
  ID SERIAL  NOT NULL ,
  CLIENT_NAME VARCHAR(50)   NOT NULL ,
  TYPE_ID  VARCHAR(5)   NOT NULL ,
  NUMBER_ID VARCHAR(50)   NOT NULL ,
  ADDRESS VARCHAR(255)    ,
  EMAIL VARCHAR(25)      ,
  CLIENT_STATE VARCHAR(20)  DEFAULT 'CURRENT' NOT NULL   ,
PRIMARY KEY(ID));

CREATE UNIQUE INDEX CLIENTS_UNIQUE_ID ON TEJIDOS_DEV.CLIENTS (TYPE_ID, NUMBER_ID) WHERE CLIENT_STATE = 'CURRENT';
/* ############################################################################################## */


/* ############################################################################################## */
/*CREATE TABLE TEJIDOS_DEV.SCHEMA_MIGRATIONS (
  VERSION VARCHAR NOT NULL ,
PRIMARY KEY(VERSION));

CREATE UNIQUE INDEX UNIQUE_VERSION ON TEJIDOS_DEV.SCHEMA_MIGRATIONS (VERSION);

INSERT INTO TEJIDOS_DEV.SCHEMA_MIGRATIONS VALUES(TO_CHAR(NOW(), 'YYYYMMDDhhmmss'));
 ############################################################################################## */


/* ############################################################################################## */
CREATE TABLE TEJIDOS_DEV.USERS (
  ID SERIAL  NOT NULL ,
  USER_NAME VARCHAR(50)   NOT NULL ,
  USER_LASTNAME VARCHAR(50)   NOT NULL ,
  EMAIL VARCHAR   NOT NULL ,
  ENCRYPTED_PASSWORD VARCHAR NOT NULL,
  RESET_PASSWORD_TOKEN VARCHAR,
  RESET_PASSWORD_SENT_AT TIMESTAMP,
  REMEMBER_CREATED_AT TIMESTAMP,
  SIGN_IN_COUNT INT DEFAULT 0 NOT NULL,
  CURRENT_SIGN_IN_AT TIMESTAMP,
  LAST_SIGN_IN_AT TIMESTAMP,
  CURRENT_SIGN_IN_IP INET,
  LAST_SIGN_IN_IP INET,
PRIMARY KEY(ID));

CREATE UNIQUE INDEX USERS_UNIQUE_EMAIL ON TEJIDOS_DEV.USERS (EMAIL);
CREATE UNIQUE INDEX USERS_UNIQUE_RESET_TOKEN ON TEJIDOS_DEV.USERS (RESET_PASSWORD_TOKEN);
/* ############################################################################################## */



/* ############################################################################################## */
CREATE TABLE TEJIDOS_DEV.FABRICS (
  ID SERIAL  NOT NULL ,
  CODE VARCHAR(20)   NOT NULL ,
  DESCRIPTION VARCHAR(255)    ,
  COLOR VARCHAR(50)    ,
  UNIT_PRICE NUMERIC(18,2)   NOT NULL ,
  FABRIC_STATE VARCHAR(20)  DEFAULT 'CURRENT' NOT NULL   ,
PRIMARY KEY(ID));

CREATE UNIQUE INDEX FABRICS_UNIQUE_CODE ON TEJIDOS_DEV.FABRICS (CODE) WHERE FABRIC_STATE = 'CURRENT';
/* ############################################################################################## */



/* ############################################################################################## */
CREATE TABLE TEJIDOS_DEV.SUPPLIERS_HAVE_PHONES (
  SUPPLIER_ID INT   NOT NULL ,
  PHONE_ID INT   NOT NULL   ,
PRIMARY KEY(SUPPLIER_ID, PHONE_ID)    ,
  FOREIGN KEY(SUPPLIER_ID)
    REFERENCES TEJIDOS_DEV.SUPPLIERS(ID),
  FOREIGN KEY(PHONE_ID)
    REFERENCES TEJIDOS_DEV.PHONES(ID));

CREATE INDEX SUPP_HAVE_PHONES_SUPPLIERS_FK ON TEJIDOS_DEV.SUPPLIERS_HAVE_PHONES (SUPPLIER_ID);
CREATE INDEX SUPP_HAVE_PHONES_PHONES_FK ON TEJIDOS_DEV.SUPPLIERS_HAVE_PHONES (PHONE_ID);
/* ############################################################################################## */



/* ############################################################################################## */
CREATE TABLE TEJIDOS_DEV.PURCHASES (
  ID SERIAL  NOT NULL ,
  SUPPLIER_ID INT   NOT NULL ,
  IVA_ID INT   NOT NULL ,
  PURCHASE_NUMBER VARCHAR(50)   NOT NULL ,
  SUBTOTAL NUMERIC(18,2)   NOT NULL ,
  FORM_OF_PAYMENT VARCHAR(155)    ,
  PURCHASE_DATE DATE   NOT NULL   ,
  PURCHASE_STATE VARCHAR(20)  DEFAULT 'CURRENT' NOT NULL   ,
PRIMARY KEY(ID)    ,
  FOREIGN KEY(IVA_ID)
    REFERENCES TEJIDOS_DEV.IVAS(ID),
  FOREIGN KEY(SUPPLIER_ID)
    REFERENCES TEJIDOS_DEV.SUPPLIERS(ID));

CREATE INDEX PURCHASES_IVAS_FK ON TEJIDOS_DEV.PURCHASES (IVA_ID);
CREATE INDEX PURCHASES_SUPPLIERS_FK ON TEJIDOS_DEV.PURCHASES (SUPPLIER_ID);
CREATE UNIQUE INDEX PURCHASES_UNIQUE_NUMBER ON TEJIDOS_DEV.PURCHASES (SUPPLIER_ID, PURCHASE_NUMBER) WHERE PURCHASE_STATE = 'CURRENT';
/* ############################################################################################## */



/* ############################################################################################## */
CREATE TABLE TEJIDOS_DEV.CLIENTS_HAVE_PHONES (
  CLIENT_ID INT   NOT NULL ,
  PHONE_ID INT   NOT NULL   ,
PRIMARY KEY(CLIENT_ID, PHONE_ID)    ,
  FOREIGN KEY(CLIENT_ID)
    REFERENCES TEJIDOS_DEV.CLIENTS(ID),
  FOREIGN KEY(PHONE_ID)
    REFERENCES TEJIDOS_DEV.PHONES(ID));

CREATE INDEX CLIENTS_HAVE_PHONES_CLIENTS_FK ON TEJIDOS_DEV.CLIENTS_HAVE_PHONES (CLIENT_ID);
CREATE INDEX CLIENTS_HAVE_PHONES_PHONES_FK ON TEJIDOS_DEV.CLIENTS_HAVE_PHONES (PHONE_ID);
/* ############################################################################################## */



/* ############################################################################################## */

-- Sequence: TEJIDOS_DEV.SALES_NUMBER_SQ
CREATE SEQUENCE TEJIDOS_DEV.SALES_NUMBER_SQ
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE TEJIDOS_DEV.SALES_NUMBER_SQ
  OWNER TO postgres;

-- Sequence: TEJIDOS_DEV.SALES_NOI_NUMBER_SQ
CREATE SEQUENCE TEJIDOS_DEV.SALES_NOI_NUMBER_SQ
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE TEJIDOS_DEV.SALES_NOI_NUMBER_SQ
  OWNER TO postgres;

CREATE TABLE TEJIDOS_DEV.SALES (
  ID SERIAL  NOT NULL ,
  CLIENT_ID INT   NOT NULL ,
  IVA_ID INT   NOT NULL ,
  SALE_NUMBER VARCHAR(50)   NOT NULL,
  SUBTOTAL NUMERIC(18,2)   NOT NULL ,
  SALE_DATE DATE   NOT NULL ,
  FORM_OF_PAYMENT VARCHAR(155)   NOT NULL ,
  SALE_STATE VARCHAR(20)  DEFAULT 'CURRENT' NOT NULL   ,
PRIMARY KEY(ID)    ,
  FOREIGN KEY(IVA_ID)
    REFERENCES TEJIDOS_DEV.IVAS(ID),
  FOREIGN KEY(CLIENT_ID)
    REFERENCES TEJIDOS_DEV.CLIENTS(ID));

CREATE INDEX SALES_IVAS_FK ON TEJIDOS_DEV.SALES (IVA_ID);
CREATE INDEX SALES_CLIENTS_FK ON TEJIDOS_DEV.SALES (CLIENT_ID);
CREATE UNIQUE INDEX SALES_UNIQUE_NUMBER ON TEJIDOS_DEV.SALES(SALE_NUMBER);
/* ############################################################################################## */



/* ############################################################################################## */
CREATE TABLE TEJIDOS_DEV.INVENTORIES (
  ID SERIAL  NOT NULL ,
  PURCHASE_ID INT   NOT NULL ,
  FABRIC_ID INT   NOT NULL ,
  PIECES INT NOT NULL,
  AMOUNT NUMERIC(10,2)   NOT NULL ,
  UNIT VARCHAR(15)   NOT NULL ,
  UNIT_PRICE NUMERIC(18,2)   NOT NULL ,
PRIMARY KEY(ID)    ,
  FOREIGN KEY(PURCHASE_ID)
    REFERENCES TEJIDOS_DEV.PURCHASES(ID),
  FOREIGN KEY(FABRIC_ID)
    REFERENCES TEJIDOS_DEV.FABRICS(ID));

CREATE INDEX PUR_HAS_FAB_PURCHASES_FK ON TEJIDOS_DEV.INVENTORIES (PURCHASE_ID);
CREATE INDEX PUR_HAS_FAB_FABRICS_FK ON TEJIDOS_DEV.INVENTORIES (FABRIC_ID);
/* ############################################################################################## */


/* ############################################################################################## */
CREATE TABLE TEJIDOS_DEV.EXISTENCES (
  ID SERIAL  NOT NULL ,
  INVENTORY_ID INT   NOT NULL ,
  PIECES INT NOT NULL,
  AMOUNT NUMERIC(10,2)   NOT NULL ,
  UNIT VARCHAR(15)   NOT NULL ,
PRIMARY KEY(ID)    ,
  FOREIGN KEY(INVENTORY_ID)
    REFERENCES TEJIDOS_DEV.INVENTORIES(ID));

CREATE INDEX EX_HAVE_INVENTORIES_FK ON TEJIDOS_DEV.EXISTENCES (INVENTORY_ID);
CREATE UNIQUE INDEX EXISTENCES_UNIQUE_INV ON TEJIDOS_DEV.EXISTENCES (INVENTORY_ID);
/* ############################################################################################## */


/* ############################################################################################## */
CREATE TABLE TEJIDOS_DEV.SALES_HAVE_INVENTORIES (
  ID SERIAL  NOT NULL ,
  SALE_ID INT   NOT NULL ,
  INVENTORY_ID INT   NOT NULL ,
  PIECES INT NOT NULL,
  AMOUNT NUMERIC(10,2)   NOT NULL ,
  UNIT VARCHAR(15)   NOT NULL ,
  UNIT_PRICE NUMERIC(18,2)   NOT NULL ,
PRIMARY KEY(ID)    ,
  FOREIGN KEY(SALE_ID)
    REFERENCES TEJIDOS_DEV.SALES(ID),
  FOREIGN KEY(INVENTORY_ID)
    REFERENCES TEJIDOS_DEV.INVENTORIES(ID));

CREATE INDEX SALES_HAVE_INVENTORIES_SALES_FK ON TEJIDOS_DEV.SALES_HAVE_INVENTORIES (SALE_ID);
CREATE INDEX SALES_HAVE_INVENTORIES_INV_FK ON TEJIDOS_DEV.SALES_HAVE_INVENTORIES (INVENTORY_ID);
/* ############################################################################################## */



/* ############################################################################################## */
CREATE USER tuser WITH PASSWORD 'tejidos2014KK';
GRANT USAGE ON SCHEMA TEJIDOS_DEV TO tuser;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA TEJIDOS_DEV TO tuser;
GRANT USAGE, UPDATE, SELECT ON ALL SEQUENCES IN SCHEMA TEJIDOS_DEV TO tuser;
/* ############################################################################################## */



/* ############################################################################################## */
/*                        TRIGGERS -- CORRER EN PG-ADMIN                                          */
/* ############################################################################################## */
/* ############################################################################################## */
DROP TRIGGER IF EXISTS update_on_inventory_insert ON tejidos_dev.inventories;
DROP FUNCTION IF EXISTS tejidos_dev.update_on_inventory_insert();

CREATE OR REPLACE FUNCTION tejidos_dev.update_on_inventory_insert() RETURNS TRIGGER AS 
$BODY$
    BEGIN
        --
        -- Despues de un insert en inventories, se replica la sentencia en existences
        --
        IF (TG_OP = 'INSERT') THEN
            INSERT INTO tejidos_dev.existences (inventory_id, pieces, amount, unit)
            VALUES (NEW.id, NEW.pieces, NEW.amount, NEW.unit);
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$BODY$ LANGUAGE plpgsql;

CREATE TRIGGER update_on_inventory_insert AFTER INSERT ON tejidos_dev.inventories FOR EACH ROW EXECUTE PROCEDURE tejidos_dev.update_on_inventory_insert();
/* ############################################################################################## */


/* ############################################################################################## */
DROP TRIGGER IF EXISTS update_on_purchase_update ON tejidos_dev.purchases;
DROP FUNCTION IF EXISTS tejidos_dev.update_on_purchase_update();

CREATE OR REPLACE FUNCTION tejidos_dev.update_on_purchase_update() RETURNS TRIGGER AS 
$BODY$
    DECLARE
        r                tejidos_dev.inventories%rowtype;
        pexistence       integer;
        aexistence       numeric(10,2);
        pinventory       integer;
        ainventory       numeric(10,2);
    BEGIN
        --
        -- Despues de un modificar una compra se actualiza existencia
        -- No se puede modificar una compra sin antes remover los registros asociados en purchase_have_inventories
        --
        IF (NEW.purchase_state = 'CURRENT') THEN
          FOR r IN (SELECT * FROM tejidos_dev.inventories i WHERE i.purchase_id = NEW.id) LOOP
             INSERT INTO tejidos_dev.existences (inventory_id, pieces, amount, unit) VALUES (r.id, r.pieces, r.amount, r.unit);
          END LOOP;
        ELSIF (NEW.purchase_state = 'CANCEL') THEN
          pexistence = (SELECT SUM(e.pieces) FROM tejidos_dev.existences e 
                                    INNER JOIN tejidos_dev.inventories i ON e.inventory_id = i.id
                                    INNER JOIN tejidos_dev.purchases pu ON pu.id = i.purchase_id
                                    WHERE (pu.id = NEW.id));
          aexistence = (SELECT SUM(e.amount) FROM tejidos_dev.existences e 
                                    INNER JOIN tejidos_dev.inventories i ON e.inventory_id = i.id
                                    INNER JOIN tejidos_dev.purchases pu ON pu.id = i.purchase_id
                                    WHERE (pu.id = NEW.id));

          pinventory = (SELECT SUM(i.pieces) FROM tejidos_dev.inventories i
                                    INNER JOIN tejidos_dev.purchases pu ON pu.id = i.purchase_id
                                    WHERE (pu.id = NEW.id));
          ainventory = (SELECT SUM(i.amount) FROM tejidos_dev.inventories i
                                    INNER JOIN tejidos_dev.purchases pu ON pu.id = i.purchase_id
                                    WHERE (pu.id = NEW.id));

          IF (pinventory > pexistence OR ainventory > aexistence) THEN
            RAISE EXCEPTION 'not enough in existence to cancel purchase (If fabrics have been sold cancel the sales first OR check that the purchase has not already been cancelled)';
          END IF;
          FOR r IN (SELECT * FROM tejidos_dev.inventories i WHERE i.purchase_id = NEW.id) LOOP
             DELETE FROM tejidos_dev.existences e WHERE e.inventory_id = r.id;
          END LOOP;
        END IF;
    
        RETURN OLD;
    END;
$BODY$ 
LANGUAGE plpgsql;

CREATE TRIGGER update_on_purchase_update AFTER UPDATE ON tejidos_dev.purchases FOR EACH ROW EXECUTE PROCEDURE tejidos_dev.update_on_purchase_update();
/* ############################################################################################## */


/* ############################################################################################## */
DROP TRIGGER IF EXISTS update_on_purchase_delete ON tejidos_dev.purchases;
DROP FUNCTION IF EXISTS tejidos_dev.update_on_purchase_delete();

CREATE OR REPLACE FUNCTION tejidos_dev.update_on_purchase_delete() RETURNS TRIGGER AS 
$BODY$
    DECLARE
        r                tejidos_dev.inventories%rowtype;
        sales            integer;
        pexistence       integer;
        aexistence       numeric(10,2);
        pinventory       integer;
        ainventory       numeric(10,2);
    BEGIN
        sales = (SELECT COUNT(*) FROM tejidos_dev.sales_have_inventories si
                                 INNER JOIN tejidos_dev.inventories i ON si.inventory_id = i.id
                                 INNER JOIN tejidos_dev.purchases p ON p.id = i.purchase_id
                                 WHERE p.id = OLD.id);
        
        IF (sales > 0) THEN
            RAISE EXCEPTION 'fabrics have been sold (delete sales first)';
        END IF;

        IF (OLD.purchase_state = 'CURRENT') THEN
          pexistence = (SELECT SUM(e.pieces) FROM tejidos_dev.existences e 
                                    INNER JOIN tejidos_dev.inventories i ON e.inventory_id = i.id
                                    INNER JOIN tejidos_dev.purchases pu ON pu.id = i.purchase_id
                                    WHERE (pu.id = OLD.id));
          aexistence = (SELECT SUM(e.amount) FROM tejidos_dev.existences e 
                                    INNER JOIN tejidos_dev.inventories i ON e.inventory_id = i.id
                                    INNER JOIN tejidos_dev.purchases pu ON pu.id = i.purchase_id
                                    WHERE (pu.id = OLD.id));

          pinventory = (SELECT SUM(i.pieces) FROM tejidos_dev.inventories i
                                    INNER JOIN tejidos_dev.purchases pu ON pu.id = i.purchase_id
                                    WHERE (pu.id = OLD.id));
          ainventory = (SELECT SUM(i.amount) FROM tejidos_dev.inventories i
                                    INNER JOIN tejidos_dev.purchases pu ON pu.id = i.purchase_id
                                    WHERE (pu.id = OLD.id));

          IF (pinventory > pexistence OR ainventory > aexistence) THEN
            RAISE EXCEPTION 'not enough in existence to delete purchase (there may be some data inconsistency)';
          END IF;
        END IF;

        FOR r IN (SELECT * FROM tejidos_dev.inventories i WHERE i.purchase_id = OLD.id) LOOP
           DELETE FROM tejidos_dev.existences e WHERE e.inventory_id = r.id;
        END LOOP;

        DELETE FROM tejidos_dev.inventories i WHERE i.purchase_id = OLD.id;
    
        RETURN OLD;
    END;
$BODY$ 
LANGUAGE plpgsql;

CREATE TRIGGER update_on_purchase_delete BEFORE DELETE ON tejidos_dev.purchases FOR EACH ROW EXECUTE PROCEDURE tejidos_dev.update_on_purchase_delete();
/* ############################################################################################## */


/* ############################################################################################## */
DROP TRIGGER IF EXISTS update_on_sales_insert ON tejidos_dev.sales_have_inventories;
DROP FUNCTION IF EXISTS tejidos_dev.update_on_sales_insert();

CREATE OR REPLACE FUNCTION tejidos_dev.update_on_sales_insert()
  RETURNS trigger AS
$BODY$
    DECLARE
        p       integer;
        a       numeric(10,2);
    BEGIN
        --
        -- Despues de un insert en sales, se reducen las cantidades y las piezas de existences
        --
        p = (SELECT e.pieces FROM tejidos_dev.existences e WHERE e.inventory_id = NEW.inventory_id);
        a = (SELECT e.amount FROM tejidos_dev.existences e WHERE e.inventory_id = NEW.inventory_id);
        IF (TG_OP = 'INSERT') THEN
            IF (a - NEW.amount) < 0 THEN RAISE EXCEPTION 'not enough amount in existence'; END IF;
            IF (p - NEW.pieces) < 0 THEN RAISE EXCEPTION 'not enough pieces in existence'; END IF;
            IF (((a - NEW.amount) = 0 AND (p - NEW.pieces) != 0) OR ((a - NEW.amount) != 0 AND (p - NEW.pieces) = 0)) THEN 
              RAISE EXCEPTION 'inconsistency between pieces and amount (one is zero the other is not)'; 
            END IF;
            UPDATE tejidos_dev.existences SET 
              amount = (a - NEW.amount),
              pieces = (p - NEW.pieces)
            WHERE inventory_id = NEW.inventory_id;
            DELETE FROM tejidos_dev.existences WHERE amount = 0 AND pieces = 0;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER update_on_sales_insert AFTER INSERT ON tejidos_dev.sales_have_inventories FOR EACH ROW EXECUTE PROCEDURE tejidos_dev.update_on_sales_insert();
/* ############################################################################################## */


/* ############################################################################################## */
DROP TRIGGER IF EXISTS update_on_sales_update ON tejidos_dev.sales;
DROP FUNCTION IF EXISTS tejidos_dev.update_on_sales_update();

CREATE OR REPLACE FUNCTION tejidos_dev.update_on_sales_update()
  RETURNS trigger AS
$BODY$
    DECLARE
        r       tejidos_dev.sales_have_inventories%rowtype;
        p       integer;
        a       numeric(10,2);
    BEGIN
      IF (NEW.sale_state = 'CANCEL') THEN
        FOR r IN (SELECT * FROM tejidos_dev.sales_have_inventories s WHERE s.sale_id = NEW.id) LOOP
          a = (SELECT e.amount FROM tejidos_dev.existences e WHERE e.inventory_id = r.inventory_id);
          p = (SELECT e.pieces FROM tejidos_dev.existences e WHERE e.inventory_id = r.inventory_id);
            IF (a > 0) THEN 
                UPDATE tejidos_dev.existences SET 
                    amount = (a + r.amount),
                    pieces = (p + r.pieces)
                WHERE inventory_id = r.inventory_id;
            ELSE
                INSERT INTO tejidos_dev.existences (inventory_id, pieces, amount, unit) VALUES (r.inventory_id, r.pieces, r.amount, r.unit);
            END IF;
        END LOOP;
      ELSIF (NEW.sale_state = 'CURRENT') THEN
        FOR r IN (SELECT * FROM tejidos_dev.sales_have_inventories s WHERE s.sale_id = NEW.id) LOOP
          p = (SELECT e.pieces FROM tejidos_dev.existences e WHERE e.inventory_id = r.inventory_id);
          a = (SELECT e.amount FROM tejidos_dev.existences e WHERE e.inventory_id = r.inventory_id);
          IF (a IS NULL OR (a - r.amount) < 0) THEN RAISE EXCEPTION 'not enough amount in existence'; END IF;
          IF (p IS NULL OR (p - r.pieces) < 0) THEN RAISE EXCEPTION 'not enough pieces in existence'; END IF;
          IF (((a - r.amount) = 0 AND (p - r.pieces) != 0) OR ((a - r.amount) != 0 AND (p - r.pieces) = 0)) THEN 
            RAISE EXCEPTION 'inconsistency between pieces and amount (one is zero the other is not)';
          END IF;
          UPDATE tejidos_dev.existences SET 
            amount = (a - r.amount),
            pieces = (p - r.pieces)
          WHERE inventory_id = r.inventory_id;
          DELETE FROM tejidos_dev.existences WHERE amount = 0 AND pieces = 0;
        END LOOP;
      END IF;
      RETURN NULL;
    END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER update_on_sales_update AFTER UPDATE ON tejidos_dev.sales FOR EACH ROW EXECUTE PROCEDURE tejidos_dev.update_on_sales_update();
/* ############################################################################################## 


/* ############################################################################################## */
DROP TRIGGER IF EXISTS update_on_sales_delete ON tejidos_dev.sales;
DROP FUNCTION IF EXISTS tejidos_dev.update_on_sales_delete();

CREATE OR REPLACE FUNCTION tejidos_dev.update_on_sales_delete()
  RETURNS trigger AS
$BODY$
    DECLARE
        r       tejidos_dev.sales_have_inventories%rowtype;
        p       integer;
        a       numeric(10,2);
    BEGIN

      FOR r IN (SELECT * FROM tejidos_dev.sales_have_inventories s WHERE s.sale_id = OLD.id) LOOP
        a = (SELECT e.amount FROM tejidos_dev.existences e WHERE e.inventory_id = r.inventory_id);
        p = (SELECT e.pieces FROM tejidos_dev.existences e WHERE e.inventory_id = r.inventory_id);
        IF (a > 0) THEN 
            UPDATE tejidos_dev.existences SET 
                amount = (a + r.amount),
                pieces = (p + r.pieces)
            WHERE inventory_id = r.inventory_id;
        ELSE
            INSERT INTO tejidos_dev.existences (inventory_id, pieces, amount, unit) VALUES (r.inventory_id, r.pieces, r.amount, r.unit);
        END IF;
      END LOOP;

      DELETE FROM tejidos_dev.sales_have_inventories si WHERE si.sale_id = OLD.id;

      RETURN OLD;
    END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER update_on_sales_delete BEFORE DELETE ON tejidos_dev.sales FOR EACH ROW EXECUTE PROCEDURE tejidos_dev.update_on_sales_delete();
/* ############################################################################################## 