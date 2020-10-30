/*This is source code from a project for INFSCI 1022 Database Management Systems
at the University of Pittsburgh. The purpose was to create a database for tracking
and maintaining personal movie collections for collectors of physical copies of
films. */

CREATE DATABASE IF NOT EXISTS movie_collection;
USE movie_collection;
/*genre types*/
CREATE TABLE IF NOT EXISTS genre
(
genre_id INT PRIMARY KEY auto_increment,
genre_name VARCHAR(50) NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*film is separate from collection_item because having many copies of the same film on different formats is how this 
style of collecting works*/
CREATE TABLE IF NOT EXISTS film
(
film_id INT PRIMARY KEY auto_increment,
film_title VARCHAR(150) NOT NULL,
release_date DATE NOT NULL,
director_name VARCHAR(50) NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*one film can have many genres which allows multi-genre searches */
CREATE TABLE IF NOT EXISTS film_genre
(
film_id INT,
genre_id INT,
FOREIGN KEY (genre_id) REFERENCES genre(genre_id),
FOREIGN KEY (film_id) REFERENCES film(film_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*format types*/
CREATE TABLE IF NOT EXISTS video_format
(
format_id INT PRIMARY KEY auto_increment,
format_name VARCHAR(50) NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*object's condition types, separate table in order to standardize condition determining*/
CREATE TABLE IF NOT EXISTS video_condition
(
condition_id INT PRIMARY KEY auto_increment,
condition_title VARCHAR(50) NOT NULL,
condition_description VARCHAR(500) NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*locations, some attributes here can be NULL because exact location is not neccessary or may be unknown*/
CREATE TABLE IF NOT EXISTS purchase_location
(
location_id INT PRIMARY KEY auto_increment,
store_name VARCHAR(50) NOT NULL,
address_line1 varchar(50),
address_line2 VARCHAR(50),
city VARCHAR(50),
state VARCHAR(50),
postal_code VARCHAR(50)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*the main item that the database revolves around*/
CREATE TABLE IF NOT EXISTS collection_item
(
item_id INT PRIMARY KEY auto_increment,
format_id INT NOT NULL,
condition_id INT NOT NULL,
film_id INT NOT NULL,
notes VARCHAR(500),
purchase_year YEAR,
purchase_price DOUBLE,
purchase_location INT, 
FOREIGN KEY (film_id) REFERENCES film(film_id),
FOREIGN KEY (format_id) REFERENCES video_format(format_id),
FOREIGN KEY (condition_id) REFERENCES video_condition(condition_id),
FOREIGN KEY (purchase_location) REFERENCES purchase_location(location_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*update and monitor changes in an item's resale value*/
CREATE TABLE IF NOT EXISTS current_resale
(
current_resale_id INT PRIMARY KEY auto_increment,
current_value DOUBLE,
update_time TIMESTAMP default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
item_id INT NOT NULL,
FOREIGN KEY (item_id) REFERENCES collection_item(item_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO genre(genre_name)
VALUES ('Horror'),
('Science Fiction'),
('Anime'),
('Action'),
('Drama'),
('Romance'),
('Cyber'),
('Fantasy'),
('Neo-noir'),
('Crime');

INSERT INTO film(film_title, release_date, director_name)
VALUES
('Alien', '1979-05-25', 'Ridley Scott'),
('Blade Runner', '1982-06-25', 'Ridley Scott'),
('Akira', '1988-07-16', 'Katsuhiro Otomo'),
('Romeo + Juliet', '1996-11-01', 'Baz Luhrmann'),
('2001: A Space Odyssey', '1968-04-02', 'Stanley Kubrick'),
('Terminator 2: Judgement Day', '1991-07-03', 'James Cameron'),
('My Neighbor Totoro', '1988-04-16', 'Hayao Miyazaki'),
('The Matrix', '1999-03-31', 'The Wachowski Brothers'),
('Mulholland Drive', '2001-05-16', 'David Lynch'),
('Aliens', '1986-07-18', 'James Cameron'),
('Alien 3', '1992-05-22', 'David Fincher'),
('Pulp Fiction', '1994-05-12', 'Quentin Tatantino');


INSERT INTO film_genre(film_id, genre_id)
VALUES
(1, 1), (1, 2), (1, 4), (1, 6), (2, 2), (2, 4), (2, 6), (3, 2), (3, 3), (3, 6), (4, 6),
(4, 5), (5, 2), (6, 4), (6, 7), (7, 3), (7, 8), (8, 4), (8, 7), (9, 9), (10, 1), (10, 2), (10, 4),
(10, 6), (11, 1), (11, 2), (11, 4), (11, 6), (12, 5), (12, 10);

/*Only four movie formats*/
INSERT INTO video_format(format_name)
VALUES
('DVD'), ('VHS'), ('Laser Disk'), ('Blu-Ray');

/*Condition descriptions taken from Ebay's classification system*/
INSERT INTO video_condition(condition_title, condition_description)
VALUES
('Brand New', 'An item that has never been opened or removed from the manufacturers sealing. Item is in original shrink wrap.'),
('Like New', 'An item that looks as if it was just taken out of shrink wrap. No visible wear, and all facets of the item are flawless and intact.'),
('Very Good', 'An item that is used but still in very good condition. No damage to the jewel case or item cover, no scuffs, scratches cracks, or holes. The cover art and liner notes are included. The VHS or DVD box is included. The teeth of disk holder are undamaged. Minimal wear on the exterior of item. No skipping on CD/DVD. No fuzzy/snowy frames on VHS tape.'),
('Good', 'An item in used but good condition. May have minor damage to jewel case. VHS or DVD box is included. No skipping on CD/DVD. No fuzzy/snowy frames on VHS tape.'),
('Acceptable', 'An item with obvious and significant wear but is still operational. May have tears or holes in VHS/DVD box. The box may not be included.');

INSERT INTO purchase_location(store_name, address_line1, address_line2, city, state, postal_code)
VALUES
('Edgewood Towne Centre Re-Store', null, null, 'Pittsburgh', 'PA', '15218'),
('Lawrenceville Goodwill', '125 51st St', null, 'Pittsburgh', 'PA', '15201'),
('Ebay', null, null, null, null, null),
('Atlas Game Exchange', '4735 Liberty Ave', null, 'Pittsburgh', 'PA', '15224'),
('Irwin Salvation Army', ' 12751 US-30', null, 'North Huntingdon', 'PA', '15642'),
('Thriftique', '125 51st St', null, 'Pittsburgh', 'PA', '15201'),
('Half Price Books', '4932 McKnight Rd', null, 'Pittsburgh', 'PA', '15237'),
('The Exchange', '3613 Forbes Ave', null, 'Pittsburgh', 'PA', '15213');

INSERT INTO collection_item(film_id, format_id, condition_id, purchase_year, purchase_price, purchase_location, notes)
VALUES
(1, 2, 4, 2014, 0.99, 1, null),
(1, 2, 3, 2016, 7.99, 2, 'part of complete Alien box-set'),
(1, 2, 4, 2016, 0.99, 8, null),
(2, 1, 4, 2015, 2.99, 7, null),
(2, 3, 3, 2015, 12.99, 7, null),
(3, 2, 3, 2015, 14.99, 3, null),
(4, 2, 4, 2015, 0.99, 1, null),
(5, 2, 3, 2016, 0.99, 4, null),
(5, 4, 2, 2016, null, 8, null),
(6, 2, 4, 2015, 0.99, 2, null),
(6, 3, 3, 2017,14.99, 7, null),
(7, 2, 5, null, null, null, 'childhood copy-- no box'),
(8, 2, 3, 2016, 0.99, 5, 'holographic case'),
(9, 1, 3, 2016, 5.99, 7, null),
(9, 2, 4, 2017, 3.99, 3, null),
(10, 4, 2, 2016, 5, null, null),
(10, 2, 3, 2016, 7.99, 2, 'part of complete Alien box-set'),
(11, 2, 4, 2016, 7.99, 2, 'part of complete Alien box-set'),
(12, 4, 2, 2015, null, 8, null),
(12, 4, 2, 2015, 49.99, 8, 'part of Tarantino Blu-Ray Box Set'),
(12,1, 2, 2014, null, 8, null),
(12, 2, 4, 2018, 0.99, 1, 'Special Collectors Edition');

/*Current resale values taken from a similar Ebay 'Sold and Completed' listings for same item and condition on 12/10/18*/
INSERT INTO current_resale(item_id, current_value)
VALUES
(1, 7.99),
(2, 8.99),
(3, 7.99),
(4, 0.71),
(5, 9.99),
(6, 14.99),
(7, 2.99),
(8, 3.99),
(9, 5.99),
(10, 4.99),
(11, 4.99),
(12, 0.99),
(13, 2.99),
(14, 9.99),
(15, 12.99),
(16, 6.99),
(17, 8.99),
(18, 8.99),
(19, 8.99),
(20, 30.99),
(21, 3.99),
(22, 1.99);


