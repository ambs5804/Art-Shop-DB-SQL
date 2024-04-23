USE art_shop;
SET SQL_SAFE_UPDATES = 0;

-- Customer wants to know the distinct paint colours that the shop stocks
SELECT DISTINCT p.colour
FROM paints p
ORDER BY p.colour;

-- Customer wants to know the prices of all orange and all pink paints in stock
SELECT p.paint_id, p.colour, p.stock_qty, b.sell_price
FROM paints p
LEFT JOIN
brands b
ON
p.brand_id = b.brand_id
WHERE p.colour = 'orange' OR p.colour = 'pink'
ORDER BY p.colour;

-- Customer needs 5 yellow paints of all the same brand and wants to know which is the cheapest
SELECT p.paint_id, p.colour, p.stock_qty, b.brand_name, b.sell_price
FROM paints p
LEFT JOIN
brands b
ON
p.brand_id = b.brand_id
WHERE p.colour = 'yellow' AND p.stock_qty >= 5
ORDER BY b.sell_price ASC;  -- From here we can see that paint_id 2 from Paints R Us is the cheapest yellow paint with 5 or more units in stock

-- Customer needs 50 paints of the same colour, however these can be from mixed brands. 
-- Let's list the colours the customer can choose from.
SELECT p.colour
FROM paints p
GROUP BY p.colour
HAVING SUM(p.stock_qty) >= 50
ORDER BY p.colour; -- This returns blue, black & green paint which the customer can choose from

-- The shop want to know the average price across all paint brands:
SELECT
ROUND(AVG(b.sell_price),2) AS Market_Average_Paint_Price
FROM brands b; -- This tells us that the average price of paint across all brands is £2.60

-- Paints R Us have relocated from Manchester to Birmingham - lets update the brand table:
UPDATE brands b
SET b.brand_location = 'Birmingham'
WHERE b.brand_name = 'Paints R Us';

-- All Lime paint has been deemed radioactive and so needs to be removed immediately - we need to delete this from the paints table:
DELETE FROM paints p
WHERE
p.colour = 	'Lime';

-- There have been some price changes for paints and tools. We will write a transaction to update all of the prices at once, but we want to be able to check these before we commit to the changes.
-- All paints coming from London have increased by 10%. All canvas prices have decreased by 7%. All paints from 'Happy Hues' have increased by 20p.
SET autocommit=0;

START TRANSACTION;

UPDATE brands b
SET b.sell_price = ROUND(b.sell_price * 1.1,2)
WHERE b.brand_location = 'London';

UPDATE tools t
SET t.sell_price = ROUND(t.sell_price * 0.93,2)
WHERE t.tool_desc LIKE 'Canvas%';

UPDATE brands b
SET b.sell_price = ROUND(b.sell_price + 0.20,2)
WHERE b.brand_name = 'Happy Hues';

SELECT * FROM brands;
SELECT * FROM tools;

-- COMMIT;
-- ROLLBACK;


-- We want to know the number of paints needed to complete all of the painting kits, for this we would use the below query:
SELECT COUNT(DISTINCT p.paint_id) AS number_unique_paints
FROM paint_kits k
INNER JOIN
paints p
ON
k.paint_id = p.paint_id; -- This tells us that to complete all of the paint kits, we would need 12 unique paints


-- Each painting kit contains multiple paint colours, the price of each kit is equal to the sum of the individiual paints minus a 15% discount. 
-- We want to calculate the price for each kit, and we will create a view to easily refer back to this summary.
CREATE VIEW Painting_Kit_Prices
AS
	SELECT k.kit_name as Kit, ROUND((SUM(b.sell_price)*0.85),2) AS Kit_Price
	FROM paint_kits k
	INNER JOIN
	paints p
	ON
	k.paint_id = p.paint_id
	INNER JOIN 
	brands b
	ON p.brand_id = b.brand_id
	GROUP BY kit_name
	ORDER BY k.kit_name;

-- The art store is now stocking extra large paint brushes, they have had a delivery of 12 extra large brushes.
-- Let's create a stored procedure to add tools to the tool table.
DELIMITER //
CREATE PROCEDURE InsertValueTools(
	IN id INT,
	IN tool_desc VARCHAR(100),
	IN price FLOAT,
	IN qty INT)
BEGIN
	INSERT INTO tools (tool_id, tool_desc, sell_price, stock_qty)
    VALUES (id, tool_desc, price, qty);

END//
DELIMITER ;

-- Now we have created the stored procedure, let's use it to add our new paintbrush.
CALL InsertValueTools(9, 'Paint Brush X Lrg', 2.29, 12);

-- It's black friday! The art store is running a promotion, where each customer gets a randomly selected tube of paint for free! 
-- Let's create a query to select a paint at random and show us the paint_id and colour.
SET @RandomPaint = CEILING(RAND()*(49-1)+1);
SELECT p.paint_id, p.colour
FROM paints p
WHERE p.paint_id = @RandomPaint;


