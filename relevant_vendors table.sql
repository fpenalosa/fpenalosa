USE Wedding_database;

/*
In order to categorize all vendors into the wedding sizes small, medium and large we decided on different rationale. For the venue department we decided to use
the vendor location as we assume that in the inner city like San Francisco and Oakland there are only venues with smaller capacities and their capacity increase
the further away the venue is, whereas for the catering department we decided to use the food type as the criteria to categorize into small, medium and large because
we assume that a buffet is also available for more than 150 people but hors doeuvres only for small and medium sized weddings. Regarding the music department we categorized
based on the number of equipment the DJ can provide, the more boxed he/she has, the higher the capacity he can play for. For invitations there are only packages of 100 
availabe to purchase which means that by ordering them for the wedding guests you automatically have enough for small sized weddings too. In that case we need to inform the 
client that for a smaller wedding size they pay for 100 despite only needing 50. For the departments jewelry, photo and video, flowers, attire, hair and makeup and rentals
we think that they do not depend on the wedding size and therefore chose to have them available for every size. 

For the column budget_level we used different rationale as well. For the departments venues, jewelry, music, photo and video, hair and makeup, attire and rentals we used 
the price_ce provided by the database or adapted the four categories of the price_ce based on the price_unit of the relevant vendors for our vision board 13. For invitations
and catering we used .....



write something about wedding options and assumptions of missing values





*/


DROP TEMPORARY TABLE IF EXISTS relevant_vendors;
CREATE TEMPORARY TABLE relevant_vendors AS

-- venues
SELECT 	v.vendor_id, 
		vendor_name, 
        vs.product_id, 
        product_name, 
        price_unit,
CASE 																		-- CASE statement for categorizing into wedding size
	WHEN 	v.vendor_location LIKE 'san%francisco%' 	THEN "small"        -- based on the venue's location we assigned the size/capacity as we assume that in 
	WHEN 	v.vendor_location LIKE 'oakland%' 			THEN "small"        -- downtown SF and Oakland there are no venues that can hold many people
	WHEN 	v.vendor_location LIKE 'sausalito%' 		THEN "medium"       -- whereas the more fare one gets away from the city, the bigger a venue and its capacity get
	WHEN 	v.vendor_location LIKE 'half%moon%bay%%' 	THEN "medium"      
	WHEN 	v.vendor_location LIKE 'san%mateo%' 		THEN "medium"       
	WHEN 	v.vendor_location LIKE 'san%ramon%' 		THEN "large"        
	WHEN 	v.vendor_location LIKE 'menlo%park%'	 	THEN "large"        
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	price_unit <= 7000					  THEN "inexpensive"
	WHEN 	price_unit BETWEEN 7001 	AND 12000 THEN "affordable"
	WHEN 	price_unit BETWEEN 12001 	AND 18000 THEN "moderate"
	WHEN 	price_unit > 18000 					  THEN "luxury"
END AS  budget_level
FROM 	ven_settings AS vs
JOIN 	ven_amenities AS va													-- join vendors and products table as well as optional tables for the venue department
	ON 	vs.product_id = va.product_id
JOIN 	ven_ceremonies AS vc
	ON 	vs.product_id = vc.product_id
JOIN 	products AS p
	ON 	p.product_id = vs.product_id
JOIN 	vendors AS v
	ON	v.vendor_id = p.vendor_id
WHERE 	ven_type IN ('ballroom', 'country club', 'hotel', 'museum', 'backyard', 'farm') -- requirements for modern/moody theme
	AND ven_ceremony_area = 1															-- venue needs to have a ceremony area based on vision board
	AND ven_outdoor = 1																	-- venue needs to have an outdoor area based on vision board (for ceremony)
	AND (vendor_location LIKE '%san%ramon%' 											-- filter for locations close by
		OR vendor_location LIKE 'half%moon%bay%' 
        OR vendor_location LIKE 'san%mateo%' 
        OR vendor_location LIKE 'menlo%park%'
        OR vendor_location LIKE 'sausalito%'
        OR vendor_location LIKE 'oakland%'
        OR vendor_location LIKE 'san%francisco%')


UNION


 
-- flowers
SELECT 	v.vendor_id, 
		vendor_name, 
        p.product_id, 
        product_name, 
        price_unit,
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	v.vendor_id LIKE "%flo%" THEN "small, medium, large"        	-- flowers do not depend on wedding size, therefore it is small, medium and large
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	price_ce = 1 THEN "inexpensive"
	WHEN 	price_ce = 2 THEN "affordable"
	WHEN 	price_ce = 3 THEN "moderate"
	WHEN 	price_ce = 4 THEN "luxury"
END AS	budget_level
FROM 	products AS p
JOIN 	Flower_Season_Style AS f											-- join vendors and products table as well as optional tables for the flowers department								
	ON	p.product_id = f.product_id
JOIN 	vendors AS v
	ON 	p.vendor_id = v.vendor_id
WHERE	p.vendor_id LIKE "flo%"
	AND (product_name LIKE "bouquet" OR product_name LIKE "flowers arrangement%" OR product_name LIKE "boutounneries%" )	-- filter for only three necessary types of flowers
	AND (flower_season LIKE "%spring" OR flower_season LIKE "%fall" OR flower_season LIKE "%winter")						-- filter for flower season other than summer



UNION


-- jewelry
SELECT 	c.vendor_id, 
		vendor_name, 
        a.product_id, 
        product_name, 
        price_unit,
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	c.vendor_id LIKE "%jwl%" THEN "small, medium, large"        	-- jewelry does not depend on wedding size, therefore it is small, medium and large
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	price_unit > 3150 				 THEN "luxury"
	WHEN 	price_unit BETWEEN 1896 AND 3150 THEN "moderate"
	WHEN 	price_unit BETWEEN 951 	AND 1895 THEN "affordable"
	WHEN 	price_unit BETWEEN 0 	AND 950  THEN "inexpensive"
END AS 	budget_level
FROM 	categories AS a
JOIN 	product_description AS b											-- join vendors and products table as well as optional tables for the jewelry department
	ON 	a.product_id = b.product_id
JOIN 	products AS c
	ON 	a.product_id = c.product_id
JOIN 	vendors AS d
	ON 	c.vendor_id = d.vendor_id
WHERE 	category_name = "ring"												-- filter only for rings as no watches or necklaces are available and the database
	AND product_description LIKE "%gold%"									-- does not provide earrings


UNION



-- Music
SELECT 	a.vendor_id, 
		vendor_name, 
        c.product_id, 
        product_name, 
        price_unit,
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	number_equipment BETWEEN 0 AND 3  THEN "small"   				-- defined wedding size by number of equipment a DJ can provide
    WHEN 	number_equipment BETWEEN 4 AND 7  THEN "medium" 
    WHEN 	number_equipment BETWEEN 8 AND 10 THEN "large" 
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	price_unit > 2500 				 THEN "luxury"
	WHEN 	price_unit BETWEEN 1795 AND 2500 THEN "moderate"
	WHEN 	price_unit BETWEEN 1100 AND 1794 THEN "affordable"
	WHEN 	price_unit BETWEEN 0 	AND 1099 THEN "inexpensive"
END AS  budget_level
FROM 	vendors    AS a
JOIN 	popularity AS b														-- join vendors and products table as well as optional tables for the music department
	ON	a.vendor_id = b.vendor_id
JOIN 	products   AS c
	ON	a.vendor_id = c.vendor_id
JOIN	sustainability AS s
	ON	s.vendor_id = a.vendor_id
WHERE 	awards >= 1															-- filter for a dj who has won awards and is close to the wedding venue (locationwise)
	AND (vendor_location LIKE "%san%ramon%"
		OR vendor_location LIKE "half%moon%bay%"
		OR vendor_location LIKE "san%mateo%"
		OR vendor_location LIKE "menlo%park%"
		OR vendor_location LIKE "sausalito%"
		OR vendor_location LIKE "oakland%"
		OR vendor_location LIKE "san%francisco%")


UNION


-- photo and video
SELECT	V.vendor_id,
		V.vendor_name,
		P.product_id,
		P.product_name,
		P.price_unit,
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	v.vendor_id LIKE "%vid%"  THEN "small, medium, large"       	-- photo and video does not depend on wedding size, therefore small, medium and large
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN P.price_unit > 4581 					THEN 'luxury'
	WHEN P.price_unit BETWEEN 3055 AND 4581 	THEN 'moderate'
	WHEN P.price_unit BETWEEN 1528 AND 3054 	THEN 'affordable'
	WHEN P.price_unit BETWEEN 0    AND 1527 	THEN 'inexpensive'
END AS price_category
FROM 	Vendors  AS V
JOIN	Products AS P														-- join vendors and products table and no optional tables because photo and video
	ON 	V.vendor_id = P.vendor_id											-- department does not have optional tables
WHERE	P.product_name LIKE 'photo%and%video%'								-- filter for vendors that provide photos and video


UNION


-- invitations
SELECT	V.vendor_id,
		V.vendor_name,
		P.product_id,
		P.product_name,
		P.price_unit,
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	v.vendor_id LIKE "%inv%"  THEN "medium, large"                  -- one unit = 100 pieces (100, 200, 300, 400, etc.), therefore only medium and large available 
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	P.price_unit >= 390 THEN 'luxury'
	WHEN 	P.price_unit > 350  THEN 'moderate'
	WHEN 	P.price_unit > 300  THEN 'affordable'
	WHEN 	P.price_unit <= 300 THEN 'inexpensive'
END AS 	price_category
FROM	Vendors AS V
JOIN	Products AS P 
	ON 	V.vendor_id = P.vendor_id
WHERE	P.product_name LIKE '%invitation%'									-- filter for invitations although no invitations in vision board visible, 
																			-- we decided to offer it anyway as it usually is part of a wedding


UNION



SELECT	V.vendor_id,
		V.vendor_name,
		P.product_id,
		P.product_name,
		P.price_unit,
CASE																	  	-- CASE statement for categorizing into wedding size
WHEN 	v.vendor_id LIKE "%inv%"  THEN "medium, large"                    	-- one unit = 100 pieces, therefore only medium and large available
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	P.price_unit >= 390 THEN 'luxury'
	WHEN 	P.price_unit > 350  THEN 'moderate'
	WHEN 	P.price_unit > 300  THEN 'affordable'
	WHEN 	P.price_unit <= 300 THEN 'inexpensive'
END AS 	price_category
FROM	Vendors V
JOIN	Products P 
	ON	V.vendor_id = P.vendor_id
WHERE	P.product_name LIKE '%menu%'										-- filter for menu


UNION


SELECT	V.vendor_id,
		V.vendor_name,
		P.product_id,
		P.product_name,
		P.price_unit,
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	v.vendor_id LIKE "%inv%"  THEN "medium, large"                  -- one unit = 100 pieces, therefore only medium and large available
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	P.price_unit >= 390 THEN 'luxury'
	WHEN 	P.price_unit > 350  THEN 'moderate'
	WHEN 	P.price_unit > 300  THEN 'affordable'
	WHEN 	P.price_unit <= 300 THEN 'inexpensive'
END AS 	price_category
FROM	Vendors  AS V
JOIN	Products AS P 
	ON 	V.vendor_id = P.vendor_id
WHERE	P.product_name LIKE '%rsvp%'										-- filter for rsvp


UNION


SELECT	V.vendor_id,
		V.vendor_name,
		P.product_id,
		P.product_name,
		P.price_unit,
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	v.vendor_id LIKE "%inv%"  THEN "medium, large"                  -- one unit = 100 pieces, therefore only medium and large available
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	P.price_unit >= 390 			 THEN 'luxury'
	WHEN 	P.price_unit BETWEEN 351 AND 390 THEN 'moderate'
	WHEN 	P.price_unit BETWEEN 301 AND 350 THEN 'affordable'
	WHEN    P.price_unit BETWEEN 0 	 AND 300 THEN 'inexpensive'
END AS 	price_category
FROM 	Vendors  AS V
JOIN	Products AS P 
	ON 	V.vendor_id = P.vendor_id
WHERE	P.product_name LIKE '%place_card%'									-- filter for place cards



UNION


# Catering
SELECT 	v.vendor_id,
		v.vendor_name,
		p.product_id, 
		p.product_name, 
        price_unit,		
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	p.product_name LIKE "%buffet%"  THEN "small, medium, large"     -- we are only looking for buffet and hors doeuvres and therefore assume that a
	WHEN 	p.product_name LIKE "%hors%"  	THEN "small, medium"            -- buffet is for all wedding sizes but hors doeuvres is only for small and medium sizes
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	price_unit > 100  			  THEN "luxury"
	WHEN 	price_unit BETWEEN 61 and 100 THEN "moderate"
	WHEN 	price_unit BETWEEN 25 and 60  THEN "affordable"
	WHEN 	price_unit < 25 			  THEN "inexpensive"
END AS 	budget_level
FROM 	cuisine AS c
JOIN 	dietary_option AS d													-- join vendors and products table as well as optional tables for the catering department
	ON 	c.product_id = d.product_id
JOIN 	products AS p
	ON 	c.product_id = p.product_id
JOIN 	vendors AS v
	ON 	v.vendor_id = p.vendor_id
WHERE 	(product_name LIKE "%hors%doeuvres%"								-- filter for food type based on vision board
	OR 	product_name LIKE "%buffet%")
	AND italian =  1														-- filter for food nationalities based on vision board 
	AND german = 1
	AND mediterranean = 1
	AND greek = 1


UNION


# Men's Attire final ver
SELECT 	v.vendor_id, 
        v.vendor_name,
		p.product_id, 
        p.product_name, 
        price_unit,
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	v.vendor_id LIKE "%att%"  THEN "small, medium, large"           -- attire does not depend on wedding size, therefore small, medium and large
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	price_ce   	= 4 THEN "luxury"
	WHEN 	price_ce 	= 3 THEN "moderate"
	WHEN 	price_ce  	= 2 THEN "affordable"
	WHEN 	price_ce  	= 1 THEN "inexpensive"
END AS  budget_level
FROM 	attire   AS a
JOIN 	products AS p														-- join vendors and products table as well as optional tables for the dress&attire department
	ON 	a.product_id = p.product_id
JOIN 	vendors  AS v
	ON 	v.vendor_id = p.vendor_id
WHERE 	(color = "black" and tie = "bow tie"								-- filter for look of tuxedo based on vision board
	OR 	color = "navy" and tie = "bow tie")									-- no white in database available, thus taking navy as reference



UNION


# Women's Dress final ver
SELECT 	v.vendor_id, 
        v.vendor_name, 
		p.product_id, 
        p.product_name, 
        price_unit, 
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	v.vendor_id LIKE "%att%"  THEN "small, medium, large"       	-- dress does not depend on wedding size, therefore small, medium and large
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	price_ce  = 4 THEN "luxury"
	WHEN 	price_ce  = 3 THEN "moderate"
	WHEN 	price_ce  = 2 THEN "affordable"
	WHEN 	price_ce  = 1 THEN "inexpensive"
END AS  budget_level
FROM 	dress    AS d
JOIN 	products AS p														-- join vendors and products table as well as optional tables for the dress&attire department
	ON  d.product_id = p.product_id
JOIN 	vendors  AS v
	ON 	v.vendor_id = p.vendor_id
WHERE 	sleeve = "without sleeve"											-- filter for look of dress based on vision board
AND 	neckline = "v-neck"



UNION



-- FOR HAIR AND MAKEUP
SELECT 	v.vendor_id,
		p.product_id,
		v.vendor_name,
		p.product_name,
		p.price_unit,
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	v.vendor_id LIKE "%hmu%"  THEN "small, medium, large"           -- hair and makeup does not depend on wedding size, therefore small, medium and large
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	p.price_unit BETWEEN 0 	 AND 100 THEN "inexpensive"
	WHEN 	p.price_unit BETWEEN 101 AND 150 THEN "affordable"
	WHEN 	p.price_unit BETWEEN 151 AND 229 THEN "moderate"
	WHEN 	p.price_unit >= 230 			 THEN "luxury"
END AS 	budget_level
FROM 	vendors  AS v
JOIN 	products AS p
	ON  v.vendor_id = p.vendor_id
WHERE 	v.vendor_rating >= '48'
AND 	p.unit_vol NOT LIKE "%kids%"
AND 	(p.vendor_id  LIKE "%hmu_02%"  										-- Filtering for vendors based on location (SF)
	OR 	p.vendor_id  LIKE "%hmu_08%"
	OR 	p.vendor_id  LIKE "%hmu_09%")



UNION



-- QUERY FOR ALL RENTAL PRODUCTS
-- Rental for Backdrops
SELECT 	v.vendor_id,
		p.product_id,
		v.vendor_name,
		p.product_name,
		p.price_unit,
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	v.vendor_id LIKE "%ren%"  THEN "small, medium, large" 			-- assuming a company that specializes on providing rentals can provide rentals for large events
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	p.price_unit <= 450 THEN "inexpensive" 
    WHEN 	p.price_unit <= 600 THEN "affordable" 
	WHEN 	p.price_unit <= 750 THEN "moderate"
	WHEN 	p.price_unit > 750 THEN "luxury"
END AS 	budget_level
FROM 	vendors  AS v
JOIN 	products AS p
	ON  v.vendor_id = p.vendor_id
WHERE 	p.product_name LIKE '%backdrop%'									-- filter for backdrops


UNION


-- Rental for Chairs
SELECT 	v.vendor_id,
		p.product_id,
		v.vendor_name,
		p.product_name,
		p.price_unit,
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	v.vendor_id LIKE "%ren%"  THEN "small, medium, large" 			-- assuming a company that specializes on providing rentals can provide rentals for large events
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	p.price_unit <= 1.50 THEN "inexpensive"
	WHEN 	p.price_unit <= 3.50 THEN "affordable"
	WHEN 	p.price_unit <= 8.50 THEN "moderate"
	WHEN 	p.price_unit >= 10.0 THEN "luxury"
END AS 	budget_level
FROM 	vendors  AS v
JOIN 	products AS p
	ON  v.vendor_id = p.vendor_id
WHERE 	p.product_name LIKE '%chairs%'										-- filter for chairs


UNION



-- Rental for dinnerware
SELECT 	v.vendor_id,
		p.product_id,
		v.vendor_name,
		p.product_name,
		p.price_unit,
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	v.vendor_id LIKE "%ren%"  THEN "small, medium, large"			-- assuming a company that specializes on providing rentals can provide rentals for large events
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	p.price_unit <= 0.50 THEN "inexpensive"
	WHEN 	p.price_unit <= 0.70 THEN "affordable"
	WHEN 	p.price_unit <= 0.90 THEN "moderate"
	WHEN 	p.price_unit >= 1.0  THEN "luxury"
END AS  budget_level
FROM 	vendors  AS v
JOIN 	products AS p
	ON  v.vendor_id = p.vendor_id
WHERE 	p.product_name LIKE '%dinnerware%'									-- filter for dinnerware


UNION


-- Rental for glasswares
SELECT 	v.vendor_id,
		p.product_id,
		v.vendor_name,
		p.product_name,
		p.price_unit,
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	v.vendor_id LIKE "%ren%"  THEN "small, medium, large" 			-- assuming a company that specializes on providing rentals can provide rentals for large events
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	p.price_unit <= 0.70 THEN "inexpensive"
	WHEN 	p.price_unit <= 0.90 THEN "affordable"
	WHEN 	p.price_unit <= 1.0  THEN "moderate"
	WHEN 	p.price_unit >= 2.0  THEN "luxury"
END AS  budget_level
FROM 	vendors  AS v
JOIN 	products AS p
	ON  v.vendor_id = p.vendor_id
WHERE 	p.product_name LIKE '%glasswares%'									-- filter for glassware


UNION



-- Rental for linen
SELECT 	v.vendor_id,
		p.product_id,
		v.vendor_name,
		p.product_name,
		p.price_unit,
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	v.vendor_id LIKE "%ren%"  THEN "small, medium, large" 			-- assuming a company that specializes on providing rentals can provide rentals for large events
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	p.price_unit <= 1.0  THEN "inexpensive"
	WHEN 	p.price_unit <= 1.50 THEN "affordable"
	WHEN 	p.price_unit <= 3.0  THEN "moderate"
	WHEN 	p.price_unit >= 4.0  THEN "luxury"
END AS 	budget_level
FROM 	vendors  AS v
JOIN 	products AS p
	ON  v.vendor_id = p.vendor_id
WHERE 	p.product_name LIKE '%linen%'										-- filter for linen


UNION


-- Rental for tables
SELECT 	v.vendor_id,
		p.product_id,
		v.vendor_name,
		p.product_name,
		p.price_unit,
CASE																		-- CASE statement for categorizing into wedding size
	WHEN 	v.vendor_id LIKE "%ren%"  THEN "small, medium, large" 			-- assuming a company that specializes on providing rentals can provide rentals for large events
END AS 	wedding_size,
CASE 																		-- CASE statement for categorizing into budget level
	WHEN 	p.price_unit <= 10.0 THEN "inexpensive"
	WHEN 	p.price_unit <= 15.0 THEN "affordable"
	WHEN 	p.price_unit <= 20.0 THEN "moderate"
	WHEN 	p.price_unit >= 25.0 THEN "luxury"
END AS  budget_level
FROM 	vendors  AS v
JOIN 	products AS p
	ON  v.vendor_id = p.vendor_id
WHERE  	p.product_name LIKE '%tables%'										-- filter for tables
;



-- ------------------------- --
-- ------------------------- --
--                           --
-- end of temporary table    --
--                           --
-- ------------------------- --
-- ------------------------- --


-- working with temporary table "relevant_vendors"
SELECT *
FROM relevant_vendors
-- LIMIT 10
;

-- working on vendor_options small & inexpensive
SELECT 	wedding_size, budget_level, vendor_id, vendor_name, price_unit
FROM 	relevant_vendors
WHERE 	vendor_id LIKE 'ven%' 
-- OR vendor_id LIKE 'flo%' OR vendor_id LIKE 'jwl%' OR vendor_id LIKE 'dj%')
AND 	wedding_size LIKE 'small%' 
AND 	budget_level LIKE 'inexpensive%'
;




DROP TEMPORARY TABLE IF EXISTS vendor_options;
CREATE TEMPORARY TABLE vendor_options AS

SELECT
    wedding_size,
    budget_level,
    SUM(price_unit) AS est_cost,
    CASE
		WHEN wedding_size = 'small' 											THEN 'moody'
        WHEN wedding_size LIKE 'small%'  	AND budget_level = 'inexpensive' 	THEN 'moody'
        WHEN wedding_size LIKE 'small%'  	AND budget_level = 'affordable' 	THEN 'moody'
        WHEN wedding_size LIKE 'small%'  	AND budget_level = 'moderate' 		THEN 'moody'
        WHEN wedding_size LIKE 'small%'  	AND budget_level = 'luxury' 		THEN 'moody'
        WHEN wedding_size LIKE '%medium%'  	AND budget_level = 'inexpensive' 	THEN 'modern/moody'
        WHEN wedding_size LIKE '%medium%'  	AND budget_level = 'affordable' 	THEN 'modern/moody'
        WHEN wedding_size LIKE '%medium%'  	AND budget_level = 'moderate' 		THEN 'modern/moody'
        WHEN wedding_size LIKE '%medium%'  	AND budget_level = 'luxury' 		THEN 'modern/moody'
        WHEN wedding_size LIKE '%large'  	AND budget_level = 'inexpensive' 	THEN 'modern'
        WHEN wedding_size LIKE '%large'  	AND budget_level = 'affordable' 	THEN 'modern'
        WHEN wedding_size LIKE '%large'  	AND budget_level = 'moderate' 		THEN 'modern'
        WHEN wedding_size LIKE '%large'  	AND budget_level = 'luxury' 		THEN 'modern'
    END AS wedding_theme
FROM (SELECT DISTINCT (wedding_size),
        budget_level,
        price_unit
    FROM relevant_vendors) AS distinct_vendors
GROUP BY
    wedding_size, budget_level
;
    
    
SELECT *
FROM vendor_options
ORDER BY wedding_size DESC
;





