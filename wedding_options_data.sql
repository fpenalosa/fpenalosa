-- wedding_cost_data
DROP TEMPORARY TABLE IF EXISTS wedding_cost_data;
CREATE TEMPORARY TABLE wedding_cost_data(									-- create temporary table vendor_options
    
	id INT PRIMARY KEY,
    category TEXT,
    vendor_name TEXT,
    budget_level DECIMAL,
    item_name TEXT,
    price_per_item DECIMAL,
    quantity INT,
    subtotal DECIMAL

);


-- Insert data into the table
INSERT INTO wedding_cost_data (id, category, vendor_name, budget_level, item_name, price_per_item, quantity, subtotal)
VALUES
	('1', 'venues', 'pinstripes san mateo', '4500', 'pinstripes san mateo wedding venue', '4500', '1', '4500'),
    ('2', 'dress and attire', 'jj house', '300', 'dress - a-line v-neck asymmetrical tulle wedding dress', '104', '1', '104'), -- bride dress
    ('3', 'dress and attire', 'birdy grey', '380', 'dress - birdy grey', '75', '4', '300'), -- bridesmaid dress
    ('4', 'dress and attire', 'blacktux', '300', 'tuxedo - notch lapel tuxedo', '241', '1', '241'), -- tuxedo (rent)
    ('5', 'flowers', 'absolute elegance floral', '2000', 'flower arrangements', '130', '14', '1820'), -- flower arrangements
    ('6', 'flowers', 'absolute elegance floral', '1000', 'boquets - lacy rose', '195', '5', '975'), -- boquets 
    ('7', 'flowers', 'absolute elegance floral', '500', 'boutonniere - white tie boutonniere', '75', '4', '300'), -- boutonniere
    ('8', 'catering', 'quake catering', '5000', 'hors doeuvres', '25', '135', '3375'),
    ('9', 'invitations', 'theknot', '50', 'invitations', '50', '1', '50'), -- invitations (135 guests but some of them in couples, so 100 invitations are enough)
    ('10', 'invitations', 'theknot', '50', 'rsvp', '50', '1', '50'), -- rsvp (135 guests but some of them in couples, so 100 rsvps are enough)
    ('11', 'invitations', 'theknot', '50', 'place cards', '50', '2', '100'), -- place cards (one for every person)
    ('12', 'invitations', 'theknot', '50', 'menu', '50', '1', '50'), -- menu (not every person needs a menu, 100 are enough)
    ('13', 'photo and video', 'hand in hand production', '2300', 'photo and video', '2291', '1', '2291'),
    ('14', 'music', 'all ears', '2000', 'i want to dance with somebody', '2000', '1', '2000'),
    ('15', 'jewelry', 'altana marie', '420', 'riley ring', '210', '2', '420'),
    ('16', 'hair and makeup', 'beyond beauty inc.', '450', 'updo', '95', '5', '475'), -- price is just for the bride
    ('17', 'rentals', 'abbey party rents sf', '300', 'arch with neon sing', '215', '1', '215'),
    ('18', 'rentals', 'abbey party rents sf', '350', 'tables', '13', '17', '221'),
    ('19', 'rentals', 'abbey party rents sf', '1500', 'chairs', '10', '135', '1350'),
    ('20', 'rentals', 'abbey party rents sf', '500', 'linen', '15', '17', '255'),
    ('21', 'rentals', 'abbey party rents sf', '500', 'glassware', '1.6', '135', '216'),
    ('22', 'rentals', 'abbey party rents sf', '500', 'plates', '1.6', '135', '216'), 
    ('23', 'rentals', 'abbey party rents sf', '500', 'silverware', '0.8', '135', '324') -- 135 forks, spoons, knifes
;

SELECT SUM(budget_level), SUM(subtotal)
FROM wedding_cost_data
;

SELECT *
FROM wedding_cost_data
;