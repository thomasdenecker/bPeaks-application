CREATE EXTENSION pgcrypto;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  user_name TEXT NOT NULL UNIQUE,
  email TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  UserType TEXT NOT NULL,
  Country TEXT NOT NULL,
  creation_date timestamp default current_timestamp
);


INSERT INTO users (first_name, last_name, user_name, email, UserType, password, Country) VALUES (
  'ad',
  'min',
  'admin',
  'admin@mail.com',
  'Admin',
  crypt('admin', gen_salt('bf')),
  'France'
);

CREATE TABLE dashboard (
  id SERIAL PRIMARY KEY,
  Peaks_detected integer NOT NULL,
  Chromosome_studied integer NOT NULL,
  type_use TEXT NOT NULL,
  Utilisation_date timestamp default current_timestamp
);
