CREATE database world;

SELECT c.Name, cl.Language
FROM CountryLanguage cl
JOIN Country c ON cl.CountryCode = c.Code
WHERE cl.IsOfficial = 'T';

SELECT City.Name, City.Population
FROM City
JOIN Country ON City.CountryCode = Country.Code
WHERE Country.Name = 'Germany';

SELECT Name, SurfaceArea
FROM Country
ORDER BY SurfaceArea ASC
LIMIT 5;

SELECT Name, Population
FROM Country
WHERE Population > 50000000
ORDER BY Population DESC;

SELECT Continent, AVG(LifeExpectancy) AS AvgLifeExpectancy
FROM Country
GROUP BY Continent;

SELECT Region, SUM(Population) AS TotalPopulation
FROM Country
GROUP BY Region;

SELECT CountryCode, COUNT(*) AS NumberOfCities
FROM City
GROUP BY CountryCode
ORDER BY NumberOfCities DESC;

SELECT c.Name AS City, co.Name AS Country, c.Population
FROM City c
JOIN Country co ON c.CountryCode = co.Code
ORDER BY c.Population DESC
LIMIT 10;

SELECT DISTINCT c.Name
FROM Country c
JOIN CountryLanguage cl ON c.Code = cl.CountryCode
WHERE cl.Language = 'French' AND cl.IsOfficial = 'T';

SELECT DISTINCT c.Name
FROM Country c
JOIN CountryLanguage cl ON c.Code = cl.CountryCode
WHERE cl.Language = 'English' AND cl.IsOfficial = 'F';

SELECT Name, Population
FROM Country
WHERE Population >= 3 * Population_50_Years_Ago;

SELECT Continent, Name, GNP
FROM Country
WHERE (Continent, GNP) IN (
    (SELECT Continent, MAX(GNP) FROM Country GROUP BY Continent)
    UNION
    (SELECT Continent, MIN(GNP) FROM Country GROUP BY Continent)
);

SELECT Name, LifeExpectancy
FROM Country
WHERE LifeExpectancy < (SELECT AVG(LifeExpectancy) FROM Country);

SELECT Country.Name AS Country, City.Name AS Capital
FROM Country
JOIN City ON Country.Capital = City.ID
WHERE Country.Population > 100000000;

SELECT Continent, COUNT(*) AS NumberOfCountries
FROM Country
GROUP BY Continent
ORDER BY NumberOfCountries DESC
LIMIT 1;