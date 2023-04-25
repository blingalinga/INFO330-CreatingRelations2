--Split the abilities with uncleaned query
WITH split(pokedex_number, abilities, split_abilities) AS (
  SELECT pokedex_number, '' AS abilities, abilities|| ',' AS split_abilities
  FROM imported_pokemon_data
  UNION ALL
    SELECT pokedex_number,
      substr(split_abilities, 0, instr(split_abilities, ',')) AS abilities,
      substr(split_abilities, instr(split_abilities, ',')+1) AS split_abilities
      FROM split
      WHERE split_abilities !=''
      )
SELECT pokedex_number, abilities,
  replace(replace(replace(trim(abilities), '[', ''), ']', ''), '''', '') AS abilities
FROM split
WHERE abilities !=''
ORDER BY pokedex_number;

--Finalized code that cleans the query and selects only the cleaned query
WITH split(pokedex_number, abilities, split_abilities) AS (
  SELECT pokedex_number, '' AS abilities, abilities|| ',' AS split_abilities
  FROM imported_pokemon_data
  UNION ALL
    SELECT pokedex_number,
      substr(split_abilities, 0, instr(split_abilities, ',')) AS abilities,
      substr(split_abilities, instr(split_abilities, ',')+1) AS split_abilities
      FROM split
      WHERE split_abilities !=''
      )
SELECT pokedex_number,
  replace(replace(replace(trim(abilities), '[', ''), ']', ''), '''', '') AS abilities
FROM split
WHERE abilities !=''
ORDER BY pokedex_number;

--Create table with only two new columns
CREATE TABLE imported_pokemon_data_temp AS
WITH split(pokedex_number, abilities, split_abilities) AS (
  SELECT pokedex_number, '' AS new_abilities, abilities|| ',' AS split_abilities
  FROM imported_pokemon_data
  UNION ALL
    SELECT pokedex_number,
      substr(split_abilities, 0, instr(split_abilities, ',')) AS new_abilities,
      substr(split_abilities, instr(split_abilities, ',')+1) AS split_abilities
      FROM split
      WHERE split_abilities !=''
      )
SELECT pokedex_number,
  replace(replace(replace(trim(abilities), '[', ''), ']', ''), '''', '') AS new_abilities
FROM split
WHERE new_abilities !=''
ORDER BY pokedex_number;

-- Join Tables
CREATE TABLE imported_pokemon_data_temp2 AS
SELECT * FROM imported_pokemon_data_temp it
LEFT JOIN
imported_pokemon_data i WHERE it.pokedex_number = i.pokedex_number;

--Drop the original abilities column
ALTER TABLE imported_pokemon_data_temp2 DROP COLUMN abilities;

--Drop the original table
DROP TABLE imported_pokemon_data;

--Rename the new table to imported_pokemon_data
ALTER TABLE imported_pokemon_data_temp2 RENAME TO imported_pokemon_data;

--Rename abilities column
ALTER TABLE imported_pokemon_data RENAME COLUMN new_abilities TO abilities;

--Fixing capture rate for Minior
UPDATE imported_pokemon_data
SET capture_rate = '285'
WHERE pokedex_number = 774;

--Drop temporary table
DROP TABLE imported_pokemon_data_temp;