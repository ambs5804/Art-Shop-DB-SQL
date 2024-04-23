-- We want to create a databse to help an art shop keep track of the colours and brands of paint they stock, along with the relevant price for each brand.
-- We also want to keep a record of the tools the art shop have in stock, we will also later write a query to help update the stock quantities when they have a delivery.
-- The art store also sell a variety of painting kits, we want to keep track of what paints are needed for each kit.

CREATE DATABASE Art_Shop;

-- Different paint brands have different prices, we will store these prices in the price table. (brand_id, brand_name, price)
USE Art_Shop;
CREATE TABLE brands
(brand_id INTEGER PRIMARY KEY,
brand_name VARCHAR(50) NOT NULL,
brand_location VARCHAR(50),
sell_price FLOAT NOT NULL);

-- We will create a table to store the paints that includes (paint_id, colour, brand_id, stock_qty)
-- colour cannot be null, brand cannot be null, and default stock is 0
CREATE TABLE paints
(paint_id INTEGER PRIMARY KEY,
colour VARCHAR(50) NOT NULL,
brand_id INTEGER NOT NULL,
stock_qty INTEGER DEFAULT 0);

-- We alter the paints table to add a foreign key
ALTER TABLE paints
ADD CONSTRAINT
fk_brand_id
FOREIGN KEY
(brand_id)
REFERENCES
brands
(brand_id);

-- We also have a selection of painting tools that need to be kept in stock (tool_id, tool_name, qty, price)
CREATE TABLE tools
(tool_id INTEGER PRIMARY KEY,
tool_desc VARCHAR(100) UNIQUE,
sell_price FLOAT NOT NULL,
stock_qty INTEGER);

-- This art store also offers Painting kits, each kit (ie. 'bee') contains multiple colours needed to paint a specific picture. The store sells these kits at a discounted price. 
-- Kits - (kit_name, paint_id)
CREATE TABLE paint_kits
(kit_name VARCHAR(50) NOT NULL,
paint_id INTEGER);

-- We alter the paint_kits table to add a foreign key
ALTER TABLE paint_kits
ADD CONSTRAINT
fk_paint_id
FOREIGN KEY
(paint_id)
REFERENCES
paints
(paint_id);

-- Populate all tables with the relevant data
INSERT INTO brands
(brand_id, brand_name, brand_location, sell_price)
VALUES
(1, 'ArtCo', 'Manchester', 1.29),
(2, 'Paints R Us', 'Nottingham', 2.99),
(3, 'Classy Colours', 'London', 3.99),
(4, 'Finger Paintz', 'Birmingham', 1.49),
(5, 'Painty Paints', 'Manchester', 2.49),
(6, 'Happy Hues', 'Cornwall', 2.99),
(7, 'Cheap Paint Co', 'London', 0.99),
(8, 'Posh Paints', 'London', 4.49);

INSERT INTO paints
(paint_id, colour, brand_id, stock_qty)
VALUES
(2, 'yellow', 2, 7),
(3, 'yellow', 3, 4),
(23, 'yellow', 6, 14),
(9, 'white', 1, 18),
(10, 'white', 3, 3),
(29, 'white', 4, 7),
(30, 'white', 6, 8),
(20, 'silver', 3, 8),
(40, 'silver', 6, 12),
(45, 'silver', 8, 14),
(13, 'red', 2, 10),
(14, 'red', 3, 5),
(33, 'red', 5, 8),
(42, 'red', 7, 12),
(16, 'purple', 1, 8),
(15, 'purple', 2, 17),
(36, 'purple', 4, 4),
(35, 'purple', 5, 12),
(1, 'pink', 1, 15),
(21, 'pink', 4, 8),
(41, 'pink', 7, 7),
(50, 'peach', 8, 31),
(18, 'orange', 2, 4),
(8, 'orange', 3, 19),
(38, 'orange', 5, 7),
(28, 'orange', 6, 8),
(44, 'orange', 7, 2),
(48, 'navy', 8, 5),
(22, 'lime', 5, 2),
(11, 'green', 1, 20),
(12, 'green', 2, 19),
(31, 'green', 4, 8),
(32, 'green', 5, 9),
(19, 'gold', 3, 5),
(39, 'gold', 6, 8),
(43, 'fuschia', 7, 32),
(46, 'cream', 8, 18),
(34, 'brown', 6, 5),
(47, 'brown', 8, 23),
(4, 'blue', 2, 24),
(17, 'blue', 3, 7),
(24, 'blue', 5, 9),
(37, 'blue', 6, 12),
(5, 'black', 1, 21),
(6, 'black', 2, 9),
(7, 'black', 3, 13),
(25, 'black', 4, 21),
(26, 'black', 5, 7),
(27, 'black', 6, 13),
(49, 'black', 8, 9);

INSERT INTO paint_kits
(kit_name, paint_id)
VALUES
('bee', 3),
('bee', 10),
('bee', 7),
('flower', 31),
('flower', 21),
('flower', 18),
('zebra', 7),
('zebra', 10),
('cat', 28),
('cat', 37),
('cat', 13),
('nature', 47),
('nature', 32),
('nature', 48);

INSERT INTO tools
(tool_id, tool_desc, sell_price, stock_qty)
VALUES
(1, 'Paint Brush Sml', 0.89, 6),
(2, 'Paint Brush Med', 1.29, 19),
(3, 'Paint Brush Lrg', 1.79, 22),
(4, 'Canvas Sml', 3.99, 12),
(5, 'Canvas Lrg', 7.99, 4),
(6, 'Palette', 0.49, 11),
(7, 'Frame', 5.21, 7),
(8, 'Paper', 0.08, 89);