CREATE TABLE dogs (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (id, address)
VALUES
  (1, "65 East 96th Street"), (2, "103rd and Riverside"), (3, "101 and Riverside"), (4, "68th and West End");

INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, "Taki", "Koutsomitis", 1),
  (2, "Jeff", "From", 2),
  (3, "Robert", "Ronan", 3),
  (4, "Jake", "Saphier", 4);

INSERT INTO
  dogs (id, name, owner_id)
VALUES
  (1, "Mocca", 1),
  (2, "Finn", 1),
  (3, "Boomer", 2),
  (4, "Luna", 2),
  (5, "Pacha", 3),
  (6, "Maybe", 3),
  (7, "Olive", 3);
