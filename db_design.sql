CREATE TABLE AppUser (
    ID SERIAL PRIMARY KEY,
    NAME TEXT UNIQUE NOT NULL,
    ROLE TEXT CHECK (ROLE='owner' OR ROLE='customer'),
    AGE INTEGER CHECK (AGE > 0 AND AGE <= 150),
    STATE CHAR(2)
);

CREATE TABLE ShoppingCart (
    ID SERIAL PRIMARY KEY,
    STATUS TEXT CHECK (STATUS='unpaid' OR STATUS='paid'),
    OWNER INTEGER REFERENCES AppUser(ID) NOT NULL
);

CREATE TABLE PurchaseOrder (
    ID SERIAL PRIMARY KEY,
    CHECKOUT_DATE DATE,
    CHECKOUT_TIME TIME,
    CHECKOUT_ID INTEGER REFERENCES ShoppingCart(ID) NOT NULL
);

CREATE TABLE Category (
    ID SERIAL PRIMARY KEY,
    NAME TEXT UNIQUE NOT NULL,
    DESCRIPTION TEXT
);

CREATE TABLE Product (
    ID SERIAL PRIMARY KEY,
    NAME TEXT NOT NULL,
    SKU TEXT UNIQUE NOT NULL,
    PRICE REAL CHECK (PRICE > 0),
    CATEGORY_ID INTEGER REFERENCES Category(ID) NOT NULL,
    STATUS TEXT CHECK (STATUS='existent' OR STATUS='deleted')
);


CREATE TABLE Contains (
    ID SERIAL PRIMARY KEY,
    ADDED_PRICE REAL CHECK (ADDED_PRICE > 0),
    QUANTITY INTEGER CHECK (QUANTITY > 0),
    PRODUCT_ID INTEGER REFERENCES Product(ID) NOT NULL,
    CART_ID INTEGER REFERENCES ShoppingCart(ID) NOT NULL
);
