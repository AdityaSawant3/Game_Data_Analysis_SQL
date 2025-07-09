USE GameDB;

-- BASIC DATA EXPLORATION.

SELECT TOP 10 * FROM dbo.game_data;

SELECT TOP 10 * FROM dbo.game_ratings;

-- ALL GAMES.
SELECT DISTINCT name FROM dbo.game_data;
-- CONCLUSION: THERE ARE MORE THAN 5000 GAMES.

SELECT COUNT(*) FROM dbo.game_data; -- 5k

SELECT COUNT(*) FROM dbo.game_ratings; --273k

-- 
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'game_data';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'game_ratings';

-- LETS DIVE INTO ANALYSIS WORK

-- 1.) WHICH GAME HAVE LARGE NUMBER OF PLAYERS.
SELECT d.name, COUNT(r.user_id) AS total_players
FROM dbo.game_data d
LEFT JOIN dbo.game_ratings r ON d.game_id = r.game_id
GROUP BY d.name
HAVING COUNT(r.user_id) > 80
ORDER BY total_players DESC;
-- CONCLUSION: THERE ARE MORE THAN 1K GAMES AND TOTAL_PLAYERS SO LETS CALCULATE BASED ON RATINGS.

-- 2.) GAMES BASED ON HIGHEST RATINGS.

SELECT TOP 20 name, ROUND(rating, 2) AS ratings
FROM dbo.game_data
ORDER BY rating DESC;
-- CONCLUSION: MOST OCCURING GAMES ARE 1) THE WITCHER 3 & THE LAST OF US.

-- 3.) GAMES BASED ON GENRES.
SELECT name, 
FROM dbo.game_data
ORDER BY rating DESC;

SELECT genres, COUNT(genres) as genre_count
FROM dbo.game_data
GROUP BY genres
HAVING COUNT(genres) > 50
ORDER BY genre_count desc;
-- CONCLUSION: PLAYERS LOVE TO PLAY ACTION, ADVENTURES GAMES.

-- 4.) WHICH PLATFORMS ARE MOSTLY USED FOR GAMING.
SELECT TOP 10 platforms, COUNT(platforms) as platforms_count
FROM dbo.game_data
GROUP BY platforms
ORDER BY platforms_count desc;
-- OBSERVATION: MOST OF THE GAMERS PREFER PC GAMES.

SELECT DISTINCT YEAR(released) AS year
FROM dbo.game_data
ORDER BY year;

-- THERE ARE SOME WRONG VALUES REMOVE NULL & 2026.
DELETE FROM dbo.game_data
WHERE released IS NULL;

DELETE FROM dbo.game_data
WHERE released = '2026-12-31';

-- VERIFY IT.
SELECT *
FROM dbo.game_data
WHERE released IS NULL AND released = '2026-12-31';

-- TIME SERIES ANALYSIS

-- 5.) GAMES RELEASED PER YEARS.
SELECT YEAR(released) AS year, COUNT(game_id) AS game_count
FROM dbo.game_data
GROUP BY YEAR(released)
ORDER BY year;
-- OBSERVATION: DECLINE IN NUMBER OF GAME RELEASE STARTED AFTER YEAR 2016.

-- .6) PLAYERS TRENDS IN PREVIOUS AND THIS DECADE.
SELECT YEAR(d.released) AS year, COUNT(r.game_id) AS game_count
FROM dbo.game_data d
LEFT JOIN dbo.game_ratings r ON d.game_id = r.game_id
GROUP BY YEAR(d.released)
ORDER BY year;
-- OBSERVATION: PLAYERS STARTED TO RISE FROM 1980'S AND STARTED TO DECLINE AFTER 2020
-- REASON: BEFORE 1990'S THERE IS RISE IN TECHNOLOGY AND AFTER 2020 THESE IS DECLINE IN PANDAMIC COVID-19.

-- DROP NOT NECESSARY COLUMNS IN THIS ANALYSIS.
ALTER TABLE dbo.game_data
DROP COLUMN cover_image;

ALTER TABLE dbo.game_data
DROP COLUMN game_link;

ALTER TABLE dbo.game_data
DROP COLUMN metacritic_url;

SELECT TOP 10 * FROM dbo.game_data;

-- GAMERS WITH HIGH RATINGS PLAYS WHICH GAMES.
WITH high_gamers_cte AS (
	SELECT d.name, r.user_id, r.rating
	FROM dbo.game_data d
	LEFT JOIN dbo.game_ratings r ON d.game_id = r.game_id
	WHERE r.rating > 4
)
SELECT DISTINCT TOP 10 name
FROM high_gamers_cte

-- MOST RATED GAMES.
SELECT name, ROUND(rating, 0) AS rating
FROM dbo.game_data
WHERE ROUND(rating, 0) >= 5
GROUP BY name, ROUND(rating, 0)
ORDER BY rating DESC;
-- OBSERVATION: HIGHLY RATED GAME IS CYBERPUNK.

-- GAMES RELEASED AFTER YEAR 2022.
SELECT YEAR(released) AS release_year, name
FROM dbo.game_data
WHERE YEAR(released) > 2021
GROUP BY YEAR(released), name
ORDER BY release_year DESC;