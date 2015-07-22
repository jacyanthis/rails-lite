CREATE TABLE turtles (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  teacher_name VARCHAR(255)
);

INSERT INTO
  turtles (id, name, teacher_name)
VALUES
  (1, "Leonardo", "Splinter"),
  (2, "Donatello", "Splinter");
