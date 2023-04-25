--Pull out pokedex number and abilities into a table
CREATE TABLE abilities AS
SELECT pokedex_number, abilities
FROM imported_pokemon_data;

--Creates a table of abilities sorted into separate columns with pokedex_number as primary key
CREATE TABLE abilities_cleaned AS
SELECT pokedex_number,
  MAX(CASE WHEN ability_num = 1 THEN abilities ELSE NULL END) AS ability_1,
  MAX(CASE WHEN ability_num = 2 THEN abilities ELSE NULL END) AS ability_2,
  MAX(CASE WHEN ability_num = 3 THEN abilities ELSE NULL END) AS ability_3,
  MAX(CASE WHEN ability_num = 4 THEN abilities ELSE NULL END) AS ability_4
FROM (
  SELECT pokedex_number,
    abilities,
    ROW_NUMBER() OVER (PARTITION BY pokedex_number ORDER BY abilities) AS ability_num
  FROM abilities
) subquery
GROUP BY pokedex_number;

-- Remove tables that are no longer needed and rename abilities_cleaned to abilities
DROP TABLE abilities;

ALTER TABLE abilities_cleaned RENAME TO abilities;

--Selecting Distinct IDs and the info from the table and all the other columns
CREATE TABLE distinct_pokedex_table (
    pokedex_number INTEGER PRIMARY KEY,
    against_bug REAL,
    against_dark REAL,
    against_dragon REAL,
    against_electric REAL,
    against_fairy REAL,
    against_fight REAL,
    against_fire REAL,
    against_flying REAL,
    against_ghost REAL,
    against_grass REAL,
    against_ground REAL,
    against_ice REAL,
    against_normal REAL,
    against_poison REAL,
    against_psychic REAL,
    against_rock REAL,
    against_steel REAL,
    against_water REAL,
    attack INTEGER,
    base_egg_steps INTEGER,
    base_happiness INTEGER,
    base_total INTEGER,
    capture_rate INTEGER,
    classfication TEXT,
    defense INTEGER,
    experience_growth INTEGER,
    height_m REAL,
    hp INTEGER,
    name TEXT,
    percentage_male REAL,
    sp_attack INTEGER,
    sp_defense INTEGER,
    speed INTEGER,
    type1 TEXT,
    type2 TEXT,
    weight_kg REAL,
    generation INTEGER,
    is_legendary INTEGER
);

INSERT INTO distinct_pokedex_table
    SELECT DISTINCT pokedex_number, against_bug, against_dark, against_dragon, against_electric,
    against_fairy, against_fight, against_fire, against_flying, against_ghost, against_grass,
    against_ground, against_ice, against_normal, against_poison, against_psychic, against_rock,
    against_steel, against_water, attack, base_egg_steps, base_happiness, base_total,
    capture_rate, classfication, defense, experience_growth, height_m, hp, name, percentage_male,
    sp_attack, sp_defense, speed, type1, type2, weight_kg, generation, is_legendary
    FROM imported_pokemon_data;

--Drop imported_pokemon_data original table and rename distinct_pokedex_table
DROP TABLE imported_pokemon_data;

ALTER TABLE distinct_pokedex_table RENAME TO imported_pokemon_data;

--Seperating type 1 and type 2 into a new table and remove from imported_pokemon_data

CREATE TABLE types(
  name TEXT PRIMARY KEY,
  type1 TEXT(80),
  type2 TEXT(80)
);

INSERT INTO types (name, type1, type2)
SELECT name, type1, type2 FROM imported_pokemon_data;

ALTER TABLE imported_pokemon_data DROP COLUMN type1;
ALTER TABLE imported_pokemon_data DROP COLUMN type2;

--Seperate Pokemon effectiveness against different types

CREATE TABLE effectiveness_against (
    effectiveness_id INTEGER PRIMARY KEY AUTOINCREMENT,
    pokedex_number INTEGER,
    against_bug REAL,
    against_dark REAL,
    against_dragon REAL,
    against_electric REAL,
    against_fairy REAL,
    against_fight REAL,
    against_fire REAL,
    against_flying REAL,
    against_ghost REAL,
    against_grass REAL,
    against_ground REAL,
    against_ice REAL,
    against_normal REAL,
    against_poison REAL,
    against_psychic REAL,
    against_rock REAL,
    against_steel REAL,
    against_water REAL
);

INSERT INTO effectiveness_against (
  pokedex_number,
  against_bug,
  against_dark,
  against_dragon,
  against_electric,
  against_fairy,
  against_fight,
  against_fire,
  against_flying,
  against_ghost,
  against_grass,
  against_ground,
  against_ice,
  against_normal,
  against_poison,
  against_psychic,
  against_rock,
  against_steel,
  against_water)
SELECT
  pokedex_number,
  against_bug,
  against_dark,
  against_dragon,
  against_electric,
  against_fairy,
  against_fight,
  against_fire,
  against_flying,
  against_ghost,
  against_grass,
  against_ground,
  against_ice,
  against_normal,
  against_poison,
  against_psychic,
  against_rock,
  against_steel,
  against_water
  FROM imported_pokemon_data;

--Drop the columns we put in the effectiveness_against_table
ALTER TABLE imported_pokemon_data DROP COLUMN against_bug;
ALTER TABLE imported_pokemon_data DROP COLUMN against_dark;
ALTER TABLE imported_pokemon_data DROP COLUMN against_dragon;
ALTER TABLE imported_pokemon_data DROP COLUMN against_electric;
ALTER TABLE imported_pokemon_data DROP COLUMN against_fairy;
ALTER TABLE imported_pokemon_data DROP COLUMN against_fight;
ALTER TABLE imported_pokemon_data DROP COLUMN against_fire;
ALTER TABLE imported_pokemon_data DROP COLUMN against_flying;
ALTER TABLE imported_pokemon_data DROP COLUMN against_ghost;
ALTER TABLE imported_pokemon_data DROP COLUMN against_grass;
ALTER TABLE imported_pokemon_data DROP COLUMN against_ground;
ALTER TABLE imported_pokemon_data DROP COLUMN against_ice;
ALTER TABLE imported_pokemon_data DROP COLUMN against_normal;
ALTER TABLE imported_pokemon_data DROP COLUMN against_poison;
ALTER TABLE imported_pokemon_data DROP COLUMN against_psychic;
ALTER TABLE imported_pokemon_data DROP COLUMN against_rock;
ALTER TABLE imported_pokemon_data DROP COLUMN against_steel;
ALTER TABLE imported_pokemon_data DROP COLUMN against_water;