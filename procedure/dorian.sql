-- SPATIAL JOIN AND MAPPING NORMALIZED TWEETS

-- Either in R or in PostGIS (via QGIS DB Manager)...

-- Count the number of dorian points in each county
CREATE TABLE dorian_count AS
SELECT "name.x", COUNT(status_id)
FROM dorian, counties
WHERE st_intersects(counties.geometry, dorian.geom)
GROUP BY "name.x";

ALTER TABLE counties
ADD COLUMN tweetcount int;
/* alter table lets to change table structure, including adding, dropping, or renaming columns. int is the integer data type for the columns */

/* update fields based on a join */
UPDATE counties
SET tweetcount = count,
FROM dorian_count, counties
WHERE dorian_count."name.x" = counties."name.x";

-- Count the number of november points in each county
CREATE TABLE november_count AS
SELECT "name.x", COUNT(status_id)
FROM november, counties
WHERE st_intersects(counties.geometry, november.geom)
GROUP BY "name.x";

ALTER TABLE counties
ADD COLUMN novcount int;
/* alter table lets to change table structure, including adding, dropping, or renaming columns. int is the integer data type for the columns */

/* update fields based on a join */
UPDATE counties
SET novcount = count,
FROM november_count, counties
WHERE november_count."name.x" = counties."name.x";

-- Set counties with no points to 0 for the november count
-- Calculate the normalized difference tweet index (made this up, based on NDVI), where
-- ndti = (tweets about storm – baseline twitter activity) / (tweets about storm + baseline twitter activity)
-- remember to multiply something by 1.0 so that you'll get decimal devision, not integer division
-- also if the denominator would end up being 0, set the result to 0

-- Either in QGIS or in R...
-- Map the normalized tweet difference index for Hurricane Dorian
-- Try using the heatmap symbology in QGIS to visualize kernel density of tweets
