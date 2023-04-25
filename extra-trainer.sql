--Create a new table, trainer which consists of first_name and last_name (both string types not longer than 80 characters).
CREATE TABLE trainer (
  first_name TEXT(80),
  last_name TEXT(80)
);

--Add trainers to the table

INSERT INTO trainer (first_name, last_name)
VALUES
  ('Ted', 'Neward'),
  ('Justin', 'Dong'),
  ('Ling Ling', 'Lee'),
  ('Bernita', 'Chen');