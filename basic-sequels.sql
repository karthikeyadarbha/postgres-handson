CREATE TABLE pg4e_debug (
  id SERIAL,
  query VARCHAR(4096),
  result VARCHAR(4096),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(id)
);

SELECT query, result, created_at FROM pg4e_debug;

CREATE TABLE pg4e_result (
  id SERIAL,
  link_id INTEGER UNIQUE,
  score FLOAT,
  title VARCHAR(4096),
  note VARCHAR(4096),
  debug_log VARCHAR(8192),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE TABLE automagic (
  id SERIAL,
  name varchar(32) constraint automagic_name CHECK (name is not null),
  height FLOAT constraint automagic_height CHECK (height is not null)
);

select *
from automagic;


CREATE TABLE pg4e_result (
  id SERIAL,
  link_id INTEGER UNIQUE,
  score FLOAT,
  title VARCHAR(4096),
  note VARCHAR(4096),
  debug_log VARCHAR(8192),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP
);

SELECT query, result, created_at FROM pg4e_debug;



CREATE TABLE pg4e_debug (
  id SERIAL,
  query VARCHAR(4096),
  result VARCHAR(4096),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(id)
);

SELECT query, result, created_at FROM pg4e_debug;


CREATE TABLE pg4e_result (
  id SERIAL,
  link_id INTEGER UNIQUE,
  score FLOAT,
  title VARCHAR(4096),
  note VARCHAR(4096),
  debug_log VARCHAR(8192),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP
);

SELECT neon845 FROM pg4e_debug LIMIT 1;

select *
from pg4e_debug;


select * from taxdata;

alter table pg4e_debug add neon845 INTEGER;


DROP TABLE album CASCADE;
CREATE TABLE album (
    id SERIAL,
    title VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

DROP TABLE track CASCADE;
CREATE TABLE track (
    id SERIAL,
    title TEXT, 
    artist TEXT, 
    album TEXT, 
    album_id INTEGER REFERENCES album(id) ON DELETE CASCADE,
    count INTEGER, 
    rating INTEGER, 
    len INTEGER,
    PRIMARY KEY(id)
);

DROP TABLE artist CASCADE;
CREATE TABLE artist (
    id SERIAL,
    name VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

DROP TABLE tracktoartist CASCADE;
CREATE TABLE tracktoartist (
    id SERIAL,
    track VARCHAR(128),
    track_id INTEGER REFERENCES track(id) ON DELETE CASCADE,
    artist VARCHAR(128),
    artist_id INTEGER REFERENCES artist(id) ON DELETE CASCADE,
    PRIMARY KEY(id)
);


select *
 from track;
INSERT INTO album (title) SELECT DISTINCT album FROM track;
UPDATE track SET album_id = (SELECT album.id FROM album WHERE album.title = track.album);

INSERT INTO tracktoartist (track, artist) SELECT distinct title,artist from track;

INSERT INTO artist (name) SELECT DISTINCT artist FROM track;

UPDATE tracktoartist SET track_id = (select id from track where track.title = tracktoartist.track);
UPDATE tracktoartist SET artist_id = (select id from artist where artist.name = tracktoartist.artist);

select tracktoartist.*
from tracktoartist
inner join artist
ON artist.name = tracktoartist.artist;


select *
from track;

select *
from tracktoartist;

select *
from track;

-- We are now done with these text fields
ALTER TABLE track DROP COLUMN album;
ALTER TABLE track drop column artist;
ALTER TABLE tracktoartist DROP COLUMN track;
ALTER TABLE tracktoartist drop column artist;


SELECT track.title, album.title, artist.name
FROM track
JOIN album ON track.album_id = album.id
JOIN tracktoartist ON track.id = tracktoartist.track_id
JOIN artist ON tracktoartist.artist_id = artist.id
ORDER BY track.title
LIMIT 3;


ALTER TABLE track DROP COLUMN album;
ALTER TABLE tracktoartist DROP COLUMN track;
ALTER TABLE track DROP artist;
ALTER TABLE tracktoartist 


select *
from track;


select *
from tracktoartist;


DROP TABLE album CASCADE;
CREATE TABLE album (
    id SERIAL,
    title VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

DROP TABLE track CASCADE;
CREATE TABLE track (
    id SERIAL,
    title TEXT, 
    artist TEXT, 
    album TEXT, 
    album_id INTEGER REFERENCES album(id) ON DELETE CASCADE,
    count INTEGER, 
    rating INTEGER, 
    len INTEGER,
    PRIMARY KEY(id)
);

DROP TABLE artist CASCADE;
CREATE TABLE artist (
    id SERIAL,
    name VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

DROP TABLE tracktoartist CASCADE;
CREATE TABLE tracktoartist (
    id SERIAL,
    track VARCHAR(128),
    track_id INTEGER REFERENCES track(id) ON DELETE CASCADE,
    artist VARCHAR(128),
    artist_id INTEGER REFERENCES artist(id) ON DELETE CASCADE,
    PRIMARY KEY(id)
);


select *
 from track;
INSERT INTO album (title) SELECT DISTINCT album FROM track;
UPDATE track SET album_id = (SELECT album.id FROM album WHERE album.title = track.album);

INSERT INTO tracktoartist (track, artist) SELECT distinct title,artist from track;

INSERT INTO artist (name) SELECT DISTINCT artist FROM track;

UPDATE tracktoartist SET track_id = (select id from track where track.title = tracktoartist.track);
UPDATE tracktoartist SET artist_id = (select id from artist where artist.name = tracktoartist.artist);

select tracktoartist.*
from tracktoartist
inner join artist
ON artist.name = tracktoartist.artist;


select *
from track;

select *
from tracktoartist;

select *
from track;

-- We are now done with these text fields
ALTER TABLE track DROP COLUMN album;
ALTER TABLE track drop column artist;
ALTER TABLE tracktoartist DROP COLUMN track;
ALTER TABLE tracktoartist drop column artist;


SELECT track.title, album.title, artist.name
FROM track
JOIN album ON track.album_id = album.id
JOIN tracktoartist ON track.id = tracktoartist.track_id
JOIN artist ON tracktoartist.artist_id = artist.id
ORDER BY track.title
LIMIT 3;


ALTER TABLE track DROP COLUMN album;
ALTER TABLE tracktoartist DROP COLUMN track;
ALTER TABLE track DROP artist;
ALTER TABLE tracktoartist 


select *
from track;


select *
from tracktoartist;