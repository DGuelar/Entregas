SET SQL_SAFE_UPDATES = 0;

ALTER TABLE City ADD COLUMN is_population_large BOOLEAN;
UPDATE City SET is_population_large = (Population > 1000000);
ALTER TABLE Country ADD COLUMN region_code CHAR(3) DEFAULT 'NA';
ALTER TABLE City ADD CONSTRAINT check_population CHECK (Population >= 0);
ALTER TABLE Country ADD CONSTRAINT unique_country_code UNIQUE (Code);
CREATE INDEX idx_city_name ON City(Name);
EXPLAIN SELECT * FROM City WHERE Name = 'Berlin';

CREATE VIEW high_population_cities AS
SELECT Name, CountryCode, Population
FROM City
WHERE Population > 1000000;

CREATE VIEW countries_with_languages AS
SELECT Country.Name, CountryLanguage.Language
FROM Country
JOIN CountryLanguage ON Country.Code = CountryLanguage.CountryCode
WHERE CountryLanguage.Language != 'English';

CREATE USER 'db_user'@'localhost' IDENTIFIED BY 'password123';

GRANT SELECT ON world.City TO 'db_user'@'localhost';
GRANT SELECT ON world.Country TO 'db_user'@'localhost';

GRANT INSERT, UPDATE ON world.City TO 'db_user'@'localhost';

REVOKE INSERT, UPDATE, DELETE ON world.Country FROM 'db_user'@'localhost';

GRANT SELECT ON world.high_population_cities TO 'db_user'@'localhost';

SELECT * FROM City;

INSERT INTO City (Name, CountryCode, District, Population) VALUES ('TestCity', 'USA', 'TestDistrict', 500000);

UPDATE City SET Population = 600000 WHERE Name = 'TestCity';

SELECT Name, Population FROM Country
WHERE Population BETWEEN 50000000 AND 200000000;

SELECT Name FROM Country
WHERE Population IN (20000000, 30000000, 40000000, 50000000);

SELECT City.Name, City.Population, Country.Continent
FROM City
JOIN Country ON City.CountryCode = Country.Code
WHERE City.Population BETWEEN 1000000 AND 10000000
AND Country.Continent != 'Asia';

SELECT Name FROM Country
WHERE Population > 100000000 OR Region = 'Europe';

SELECT Name FROM City
WHERE Name LIKE 'A%' AND Name NOT LIKE '%n';

SELECT Name FROM Country
WHERE Code IN (
    SELECT CountryCode FROM City WHERE Population > 1000000 GROUP BY CountryCode HAVING COUNT(*) > 5
);

SELECT Name FROM Country
WHERE Code IN (
    SELECT CountryCode FROM CountryLanguage WHERE IsOfficial = 'T' GROUP BY CountryCode HAVING COUNT(*) > 3
);

SELECT City.Name, CountryLanguage.Language
FROM City
JOIN CountryLanguage ON City.CountryCode = CountryLanguage.CountryCode
WHERE CountryLanguage.Language != 'English' AND CountryLanguage.IsOfficial = 'T';

SELECT Country.Name, TotalPopulation
FROM Country
JOIN (
    SELECT CountryCode, SUM(Population) AS TotalPopulation
    FROM City GROUP BY CountryCode
) AS CityPop ON Country.Code = CityPop.CountryCode;

SELECT Name, Population FROM City ORDER BY Population DESC LIMIT 10;
EXPLAIN SELECT Name, Population FROM City ORDER BY Population DESC LIMIT 10;
CREATE INDEX idx_city_population ON City(Population);

SELECT Name, Population FROM City
WHERE Population > 1000000 AND Name LIKE 'A%'
ORDER BY Name;
CREATE INDEX idx_city_name_population ON City(Name, Population);

START TRANSACTION;
INSERT INTO City (Name, CountryCode, District, Population)
VALUES ('TestCity', 'USA', 'TestDistrict', 500000);
SELECT * FROM City WHERE Name = 'TestCity';
ROLLBACK;

START TRANSACTION;
INSERT INTO City (Name, CountryCode, District, Population) VALUES ('NewCity', 'FRA', 'Paris', 600000);
UPDATE Country SET Population = Population + 600000 WHERE Code = 'FRA';
COMMIT;

START TRANSACTION;
SAVEPOINT before_insert;
INSERT INTO City (Name, CountryCode, District, Population) VALUES ('RollbackCity', 'GER', 'Berlin', 700000);
ROLLBACK TO before_insert;
COMMIT;