--    Openbravo POS is a point of sales application designed for touch screens.
--    Copyright (C) 2007-2010 Openbravo, S.L.
--    http://sourceforge.net/projects/openbravopos
--
--    This file is part of Openbravo POS.
--
--    Openbravo POS is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    Openbravo POS is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with Openbravo POS.  If not, see <http://www.gnu.org/licenses/>.

-- Database initial script for MYSQL
-- v2

CREATE TABLE  APPLICATIONS (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    VERSION VARCHAR(255) NOT NULL,
    PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO APPLICATIONS(ID, NAME, VERSION) VALUES($APP_ID{}, $APP_NAME{}, $DB_VERSION{});

CREATE TABLE  ROLES (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    PERMISSIONS MEDIUMBLOB,
    PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX ROLES_NAME_INX ON ROLES(NAME);

CREATE TABLE  PEOPLE (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    APPPASSWORD VARCHAR(255),
    CARD VARCHAR(255),
    ROLE VARCHAR(255) NOT NULL,
    VISIBLE BIT NOT NULL,
    IMAGE MEDIUMBLOB,
    PRIMARY KEY (ID),
    CONSTRAINT PEOPLE_FK_1 FOREIGN KEY (ROLE) REFERENCES ROLES(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX PEOPLE_NAME_INX ON PEOPLE(NAME);
CREATE INDEX PEOPLE_CARD_INX ON PEOPLE(CARD);

CREATE TABLE  RESOURCES (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    RESTYPE INTEGER NOT NULL,
    CONTENT MEDIUMBLOB,
    PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX RESOURCES_NAME_INX ON RESOURCES(NAME);

CREATE TABLE  TAXCUSTCATEGORIES (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX TAXCUSTCAT_NAME_INX ON TAXCUSTCATEGORIES(NAME);

CREATE TABLE  CUSTOMERS (
    ID VARCHAR(255) NOT NULL,
    SEARCHKEY VARCHAR(255) NOT NULL,
    TAXID VARCHAR(255),
    NAME VARCHAR(255) NOT NULL,
    TAXCATEGORY VARCHAR(255),
    CARD VARCHAR(255),
    MAXDEBT DOUBLE DEFAULT 0 NOT NULL,
    ADDRESS VARCHAR(255),
    ADDRESS2 VARCHAR(255),
    POSTAL VARCHAR(255),
    CITY VARCHAR(255),
    REGION VARCHAR(255),
    COUNTRY VARCHAR(255),
    FIRSTNAME VARCHAR(255),
    LASTNAME VARCHAR(255),
    EMAIL VARCHAR(255),
    PHONE VARCHAR(255),
    PHONE2 VARCHAR(255),
    FAX VARCHAR(255),
    NOTES VARCHAR(255),
    VISIBLE BIT DEFAULT b'1' NOT NULL,
    CURDATE DATETIME,
    CURDEBT DOUBLE,
    PRIMARY KEY (ID),
    CONSTRAINT CUSTOMERS_TAXCAT FOREIGN KEY (TAXCATEGORY) REFERENCES TAXCUSTCATEGORIES(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX CUSTOMERS_SKEY_INX ON CUSTOMERS(SEARCHKEY);
CREATE INDEX CUSTOMERS_TAXID_INX ON CUSTOMERS(TAXID);
CREATE INDEX CUSTOMERS_NAME_INX ON CUSTOMERS(NAME);
CREATE INDEX CUSTOMERS_CARD_INX ON CUSTOMERS(CARD);

CREATE TABLE  CATEGORIES (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    PARENTID VARCHAR(255),
    IMAGE MEDIUMBLOB,
    PRIMARY KEY(ID),
    CONSTRAINT CATEGORIES_FK_1 FOREIGN KEY (PARENTID) REFERENCES CATEGORIES(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX CATEGORIES_NAME_INX ON CATEGORIES(NAME);

CREATE TABLE  TAXCATEGORIES (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX TAXCAT_NAME_INX ON TAXCATEGORIES(NAME);

CREATE TABLE  TAXES (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    VALIDFROM DATETIME DEFAULT '2001-01-01 00:00:00' NOT NULL,
    CATEGORY VARCHAR(255) NOT NULL,
    CUSTCATEGORY VARCHAR(255),
    PARENTID VARCHAR(255),
    RATE DOUBLE NOT NULL,
    RATECASCADE BIT DEFAULT b'0' NOT NULL,
    RATEORDER INTEGER,
    PRIMARY KEY(ID),
    CONSTRAINT TAXES_CAT_FK FOREIGN KEY (CATEGORY) REFERENCES TAXCATEGORIES(ID),
    CONSTRAINT TAXES_CUSTCAT_FK FOREIGN KEY (CUSTCATEGORY) REFERENCES TAXCUSTCATEGORIES(ID),
    CONSTRAINT TAXES_TAXES_FK FOREIGN KEY (PARENTID) REFERENCES TAXES(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX TAXES_NAME_INX ON TAXES(NAME);

CREATE TABLE  ATTRIBUTE (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  ATTRIBUTEVALUE (
    ID VARCHAR(255) NOT NULL,
    ATTRIBUTE_ID VARCHAR(255) NOT NULL,
    VALUE VARCHAR(255),
    PRIMARY KEY (ID),
    CONSTRAINT ATTVAL_ATT FOREIGN KEY (ATTRIBUTE_ID) REFERENCES ATTRIBUTE(ID) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  ATTRIBUTESET (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  ATTRIBUTEUSE (
    ID VARCHAR(255) NOT NULL,
    ATTRIBUTESET_ID VARCHAR(255) NOT NULL,
    ATTRIBUTE_ID VARCHAR(255) NOT NULL,
    LINENO INTEGER,
    PRIMARY KEY (ID),
    CONSTRAINT ATTUSE_SET FOREIGN KEY (ATTRIBUTESET_ID) REFERENCES ATTRIBUTESET(ID) ON DELETE CASCADE,
    CONSTRAINT ATTUSE_ATT FOREIGN KEY (ATTRIBUTE_ID) REFERENCES ATTRIBUTE(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX ATTUSE_LINE ON ATTRIBUTEUSE(ATTRIBUTESET_ID, LINENO);

CREATE TABLE  ATTRIBUTESETINSTANCE (
    ID VARCHAR(255) NOT NULL,
    ATTRIBUTESET_ID VARCHAR(255) NOT NULL,
    DESCRIPTION VARCHAR(255),
    PRIMARY KEY (ID),
    CONSTRAINT ATTSETINST_SET FOREIGN KEY (ATTRIBUTESET_ID) REFERENCES ATTRIBUTESET(ID) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  ATTRIBUTEINSTANCE (
    ID VARCHAR(255) NOT NULL,
    ATTRIBUTESETINSTANCE_ID VARCHAR(255) NOT NULL,
    ATTRIBUTE_ID VARCHAR(255) NOT NULL,
    VALUE VARCHAR(255),
    PRIMARY KEY (ID),
    CONSTRAINT ATTINST_SET FOREIGN KEY (ATTRIBUTESETINSTANCE_ID) REFERENCES ATTRIBUTESETINSTANCE(ID) ON DELETE CASCADE,
    CONSTRAINT ATTINST_ATT FOREIGN KEY (ATTRIBUTE_ID) REFERENCES ATTRIBUTE(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  PRODUCTS (
    ID VARCHAR(255) NOT NULL,
    REFERENCE VARCHAR(255) NOT NULL,
    CODE VARCHAR(255),
    CODETYPE VARCHAR(255),
    NAME VARCHAR(255) NOT NULL,
    PRICEBUY DOUBLE,
    PRICESELL DOUBLE NOT NULL,
    CATEGORY VARCHAR(255) NOT NULL,
    TAXCAT VARCHAR(255) NOT NULL,
    ATTRIBUTESET_ID VARCHAR(255),
    STOCKCOST DOUBLE,
    STOCKVOLUME DOUBLE,
    IMAGE MEDIUMBLOB,
    ISCOM BIT DEFAULT b'0' NOT NULL,
    ISSCALE BIT DEFAULT b'0' NOT NULL,
    ATTRIBUTES MEDIUMBLOB,
    DISCOUNTENABLED BIT DEFAULT b'0' NOT NULL,
    DISCOUNTRATE DOUBLE DEFAULT 0.0 NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT PRODUCTS_FK_1 FOREIGN KEY (CATEGORY) REFERENCES CATEGORIES(ID),
    CONSTRAINT PRODUCTS_TAXCAT_FK FOREIGN KEY (TAXCAT) REFERENCES TAXCATEGORIES(ID),
    CONSTRAINT PRODUCTS_ATTRSET_FK FOREIGN KEY (ATTRIBUTESET_ID) REFERENCES ATTRIBUTESET(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX PRODUCTS_INX_0 ON PRODUCTS(REFERENCE);
CREATE UNIQUE INDEX PRODUCTS_NAME_INX ON PRODUCTS(NAME);

CREATE TABLE  PRODUCTS_CAT (
    PRODUCT VARCHAR(255) NOT NULL,
    CATORDER INTEGER,
    PRIMARY KEY (PRODUCT),
    CONSTRAINT PRODUCTS_CAT_FK_1 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE INDEX PRODUCTS_CAT_INX_1 ON PRODUCTS_CAT(CATORDER);

CREATE TABLE  PRODUCTS_COM (
    ID VARCHAR(255) NOT NULL,
    PRODUCT VARCHAR(255) NOT NULL,
    PRODUCT2 VARCHAR(255) NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT PRODUCTS_COM_FK_1 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT PRODUCTS_COM_FK_2 FOREIGN KEY (PRODUCT2) REFERENCES PRODUCTS(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX PCOM_INX_PROD ON PRODUCTS_COM(PRODUCT, PRODUCT2);

CREATE TABLE TARIFFAREAS (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    TARIFFORDER INTEGER DEFAULT 0,
    PRIMARY KEY(ID)
);
CREATE UNIQUE INDEX TARIFFAREAS_NAME_INX ON TARIFFAREAS(NAME);

CREATE TABLE TARIFFAREAS_PROD (
    TARIFFID VARCHAR(255) NOT NULL,
    PRODUCTID VARCHAR(255) NOT NULL,
    PRICESELL DOUBLE NOT NULL,
    PRIMARY KEY (TARIFFID, PRODUCTID),
    CONSTRAINT TARIFFAREAS_PROD_FK_1 FOREIGN KEY (TARIFFID) REFERENCES TARIFFAREAS(ID) ON DELETE CASCADE,
    CONSTRAINT TARIFFAREAS_PROD_FK_2 FOREIGN KEY (PRODUCTID) REFERENCES PRODUCTS(ID) ON DELETE CASCADE
);

CREATE TABLE  LOCATIONS (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    ADDRESS VARCHAR(255),
    PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX LOCATIONS_NAME_INX ON LOCATIONS(NAME);

CREATE TABLE  STOCKDIARY (
    ID VARCHAR(255) NOT NULL,
    DATENEW DATETIME NOT NULL,
    REASON INTEGER NOT NULL,
    LOCATION VARCHAR(255) NOT NULL,
    PRODUCT VARCHAR(255) NOT NULL,
    ATTRIBUTESETINSTANCE_ID VARCHAR(255),
    UNITS DOUBLE NOT NULL,
    PRICE DOUBLE NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT STOCKDIARY_FK_1 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT STOCKDIARY_ATTSETINST FOREIGN KEY (ATTRIBUTESETINSTANCE_ID) REFERENCES ATTRIBUTESETINSTANCE(ID),
    CONSTRAINT STOCKDIARY_FK_2 FOREIGN KEY (LOCATION) REFERENCES LOCATIONS(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE INDEX STOCKDIARY_INX_1 ON STOCKDIARY(DATENEW);

CREATE TABLE  STOCKLEVEL (
    ID VARCHAR(255) NOT NULL,
    LOCATION VARCHAR(255) NOT NULL,
    PRODUCT VARCHAR(255) NOT NULL,
    STOCKSECURITY DOUBLE,
    STOCKMAXIMUM DOUBLE,
    PRIMARY KEY (ID),
    CONSTRAINT STOCKLEVEL_PRODUCT FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT STOCKLEVEL_LOCATION FOREIGN KEY (LOCATION) REFERENCES LOCATIONS(ID)
 )ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  STOCKCURRENT (
    LOCATION VARCHAR(255) NOT NULL,
    PRODUCT VARCHAR(255) NOT NULL,
    ATTRIBUTESETINSTANCE_ID VARCHAR(255),
    UNITS DOUBLE NOT NULL,
    CONSTRAINT STOCKCURRENT_FK_1 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT STOCKCURRENT_ATTSETINST FOREIGN KEY (ATTRIBUTESETINSTANCE_ID) REFERENCES ATTRIBUTESETINSTANCE(ID),
    CONSTRAINT STOCKCURRENT_FK_2 FOREIGN KEY (LOCATION) REFERENCES LOCATIONS(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX STOCKCURRENT_INX ON STOCKCURRENT(LOCATION, PRODUCT, ATTRIBUTESETINSTANCE_ID);

CREATE TABLE  CLOSEDCASH (
    MONEY VARCHAR(255) NOT NULL,
    HOST VARCHAR(255) NOT NULL,
    HOSTSEQUENCE INTEGER NOT NULL,
    DATESTART DATETIME,
    DATEEND DATETIME,
    PRIMARY KEY(MONEY)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE INDEX CLOSEDCASH_INX_1 ON CLOSEDCASH(DATESTART);
CREATE UNIQUE INDEX CLOSEDCASH_INX_SEQ ON CLOSEDCASH(HOST, HOSTSEQUENCE);

CREATE TABLE  RECEIPTS (
    ID VARCHAR(255) NOT NULL,
    MONEY VARCHAR(255) NOT NULL,
    DATENEW DATETIME NOT NULL,
    ATTRIBUTES MEDIUMBLOB,
    PRIMARY KEY(ID),
    CONSTRAINT RECEIPTS_FK_MONEY FOREIGN KEY (MONEY) REFERENCES CLOSEDCASH(MONEY)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE INDEX RECEIPTS_INX_1 ON RECEIPTS(DATENEW);

CREATE TABLE  TICKETS (
    ID VARCHAR(255) NOT NULL,
    TICKETTYPE INTEGER DEFAULT 0 NOT NULL,
    TICKETID INTEGER NOT NULL,
    PERSON VARCHAR(255) NOT NULL,
    CUSTOMER VARCHAR(255),
    STATUS INTEGER DEFAULT 0 NOT NULL,
    CUSTCOUNT INTEGER NULL,
    TARIFFAREA VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT TICKETS_FK_ID FOREIGN KEY (ID) REFERENCES RECEIPTS(ID),
    CONSTRAINT TICKETS_FK_2 FOREIGN KEY (PERSON) REFERENCES PEOPLE(ID),
    CONSTRAINT TICKETS_CUSTOMERS_FK FOREIGN KEY (CUSTOMER) REFERENCES CUSTOMERS(ID),
    CONSTRAINT TICKETS_TARIFFAREA FOREIGN KEY (TARIFFAREA) REFERENCES TARIFFAREAS(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE INDEX TICKETS_TICKETID ON TICKETS(TICKETTYPE, TICKETID);

CREATE TABLE  TICKETSNUM (ID INTEGER NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO TICKETSNUM VALUES(1);

CREATE TABLE  TICKETSNUM_REFUND (ID INTEGER NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO TICKETSNUM_REFUND VALUES(1);

CREATE TABLE  TICKETSNUM_PAYMENT (ID INTEGER NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO TICKETSNUM_PAYMENT VALUES(1);

CREATE TABLE  TICKETLINES (
    TICKET VARCHAR(255) NOT NULL,
    LINE INTEGER NOT NULL,
    PRODUCT VARCHAR(255),
    ATTRIBUTESETINSTANCE_ID VARCHAR(255),
    UNITS DOUBLE NOT NULL,
    PRICE DOUBLE NOT NULL,
    TAXID VARCHAR(255) NOT NULL,
    ATTRIBUTES MEDIUMBLOB,
    PRIMARY KEY (TICKET, LINE),
    CONSTRAINT TICKETLINES_FK_TICKET FOREIGN KEY (TICKET) REFERENCES TICKETS(ID),
    CONSTRAINT TICKETLINES_FK_2 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT TICKETLINES_ATTSETINST FOREIGN KEY (ATTRIBUTESETINSTANCE_ID) REFERENCES ATTRIBUTESETINSTANCE(ID),
    CONSTRAINT TICKETLINES_FK_3 FOREIGN KEY (TAXID) REFERENCES TAXES(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  PAYMENTS (
    ID VARCHAR(255) NOT NULL,
    RECEIPT VARCHAR(255) NOT NULL,
    PAYMENT VARCHAR(255) NOT NULL,
    TOTAL DOUBLE NOT NULL,
    TRANSID VARCHAR(255),
    RETURNMSG MEDIUMBLOB,
    PRIMARY KEY (ID),
    CONSTRAINT PAYMENTS_FK_RECEIPT FOREIGN KEY (RECEIPT) REFERENCES RECEIPTS(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE INDEX PAYMENTS_INX_1 ON PAYMENTS(PAYMENT);

CREATE TABLE  TAXLINES (
    ID VARCHAR(255) NOT NULL,
    RECEIPT VARCHAR(255) NOT NULL,
    TAXID VARCHAR(255) NOT NULL, 
    BASE DOUBLE NOT NULL, 
    AMOUNT DOUBLE NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT TAXLINES_TAX FOREIGN KEY (TAXID) REFERENCES TAXES(ID),
    CONSTRAINT TAXLINES_RECEIPT FOREIGN KEY (RECEIPT) REFERENCES RECEIPTS(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  FLOORS (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    IMAGE MEDIUMBLOB,
    PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX FLOORS_NAME_INX ON FLOORS(NAME);

CREATE TABLE  PLACES (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    X INTEGER NOT NULL,
    Y INTEGER NOT NULL,
    FLOOR VARCHAR(255) NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT PLACES_FK_1 FOREIGN KEY (FLOOR) REFERENCES FLOORS(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX PLACES_NAME_INX ON PLACES(NAME);

CREATE TABLE  RESERVATIONS (
    ID VARCHAR(255) NOT NULL,
    CREATED DATETIME NOT NULL,
    DATENEW DATETIME DEFAULT '2001-01-01 00:00:00' NOT NULL,
    TITLE VARCHAR(255) NOT NULL,
    CHAIRS INTEGER NOT NULL,
    ISDONE BIT NOT NULL,
    DESCRIPTION VARCHAR(255),
    PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE INDEX RESERVATIONS_INX_1 ON RESERVATIONS(DATENEW);

CREATE TABLE  RESERVATION_CUSTOMERS (
    ID VARCHAR(255) NOT NULL,
    CUSTOMER VARCHAR(255) NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT RES_CUST_FK_1 FOREIGN KEY (ID) REFERENCES RESERVATIONS(ID),
    CONSTRAINT RES_CUST_FK_2 FOREIGN KEY (CUSTOMER) REFERENCES CUSTOMERS(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  THIRDPARTIES (
    ID VARCHAR(255) NOT NULL,
    CIF VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    ADDRESS VARCHAR(255),
    CONTACTCOMM VARCHAR(255),
    CONTACTFACT VARCHAR(255),
    PAYRULE VARCHAR(255),
    FAXNUMBER VARCHAR(255),
    PHONENUMBER VARCHAR(255),
    MOBILENUMBER VARCHAR(255),
    EMAIL VARCHAR(255),
    WEBPAGE VARCHAR(255),
    NOTES VARCHAR(255),
    PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE UNIQUE INDEX THIRDPARTIES_CIF_INX ON THIRDPARTIES(CIF);
CREATE UNIQUE INDEX THIRDPARTIES_NAME_INX ON THIRDPARTIES(NAME);

CREATE TABLE  SHAREDTICKETS (
    ID VARCHAR(255) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    CONTENT MEDIUMBLOB,
    PRIMARY KEY(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
