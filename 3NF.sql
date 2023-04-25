--Rename the imported_pokemon_data to pokemon_info
ALTER TABLE imported_pokemon_data RENAME TO pokemon_info;

--Remove pokedex_number from effectiveness_against
ALTER TABLE effectiveness_against DROP COLUMN pokedex_number;

--Create primary key for abililties table and foreign key for pokedex_number
CREATE TABLE abilities_temp (
  ability_id INTEGER PRIMARY KEY AUTOINCREMENT,
  pokedex_number INTEGER,
  ability1 TEXT,
  ability2 TEXT,
  ability3 TEXT,
  ability4 TEXT,
  FOREIGN KEY (pokedex_number) REFERENCES pokemon_info(pokedex_number)
);

INSERT INTO abilities_temp (pokedex_number, ability1, ability2, ability3, ability4)
SELECT pokedex_number, ability_1, ability_2, ability_3, ability_4
FROM abilities_cleaned;

--Drop old abilities table and abilities_cleaned table and rename temp table
DROP TABLE abilities;
DROP TABLE abilities_cleaned;

ALTER TABLE abilities_temp RENAME TO abilities;


--Create a table for pokemon base stats
CREATE TABLE base_stats (
  base_id INTEGER PRIMARY KEY AUTOINCREMENT,
  base_egg_steps INTEGER,
  base_happiness INTEGER,
  base_total INTEGER
);

INSERT INTO base_stats (base_egg_steps, base_happiness, base_total)
SELECT base_egg_steps, base_happiness, base_total
FROM pokemon_info;

--Remove base stats columns from pokemon_info table to avoid duplicates
ALTER TABLE pokemon_info DROP COLUMN base_egg_steps;
ALTER TABLE pokemon_info DROP COLUMN base_happiness;
ALTER TABLE pokemon_info DROP COLUMN base_total;

--Create a table with all the pokemon stats related to battle
CREATE TABLE battle_stats (
  battle_id INTEGER PRIMARY KEY AUTOINCREMENT,
  attack INTEGER,
  defense INTEGER,
  hp INTEGER,
  sp_attack INTEGER,
  sp_defense INTEGER,
  speed INTEGER,
  base_id INTEGER,
  ability_id INTEGER,
  effectiveness_id INTEGER,
  FOREIGN KEY (base_id) REFERENCES base_stats (base_id),
  FOREIGN KEY (ability_id) REFERENCES abilities (ability_id),
  FOREIGN KEY (effectiveness_id) REFERENCES effectiveness_against (effectiveness_id)
);

INSERT INTO battle_stats (attack, defense, hp, sp_attack, sp_defense, speed, base_id, ability_id, effectiveness_id)
SELECT pi.attack, pi.defense, pi.hp, pi.sp_attack, pi.sp_defense, pi.speed, bs.base_id, ab.ability_id, ea.effectiveness_id
FROM pokemon_info pi
INNER JOIN base_stats bs ON pi.pokedex_number = bs.base_id
INNER JOIN abilities ab ON pi.pokedex_number = ab.ability_id
INNER JOIN effectiveness_against ea ON pi.pokedex_number = ea.effectiveness_id;

--Drop columns to remove duplication from pokemon_info
ALTER TABLE pokemon_info DROP COLUMN attack;
ALTER TABLE pokemon_info DROP COLUMN defense;
ALTER TABLE pokemon_info DROP COLUMN hp;
ALTER TABLE pokemon_info DROP COLUMN sp_attack;
ALTER TABLE pokemon_info DROP COLUMN sp_defense;
ALTER TABLE pokemon_info DROP COLUMN speed;

--Add battle_id to the pokemon_info table
ALTER TABLE pokemon_info
ADD COLUMN battle_id INTEGER REFERENCES battle_stats (battle_id);

UPDATE pokemon_info
SET battle_id = (SELECT battle_id FROM battle_stats WHERE battle_stats.battle_id = pokemon_info.pokedex_number);

