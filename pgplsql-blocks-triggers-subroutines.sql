CREATE TABLE keyvalue ( 
  id SERIAL,
  key VARCHAR(128) UNIQUE,
  value VARCHAR(128) UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY(id)
);

insert into keyvalue(key,value) values ('key1','val1');

select *
from keyvalue;

update keyvalue
set value = 'value1';

CREATE OR REPLACE FUNCTION trigger_kv_timestamp()
RETURNS TRIGGER AS $$
BEGIN
	NEW.updated_at = NOW();
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_timestamp_kv
BEFORE UPDATE ON keyvalue
FOR EACH ROW
EXECUTE PROCEDURE trigger_kv_timestamp();



CREATE TABLE album (
  id SERIAL,
  title VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

CREATE TABLE track (
    id SERIAL,
    title VARCHAR(128),
    len INTEGER, rating INTEGER, count INTEGER,
    album_id INTEGER REFERENCES album(id) ON DELETE CASCADE,
    UNIQUE(title, album_id),
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS track_raw;
CREATE TABLE track_raw
 (title TEXT, artist TEXT, album TEXT, album_id INTEGER,
  count INTEGER, rating INTEGER, len INTEGER);
 
 UPDATE track_raw SET album_id = (SELECT album.id FROM album WHERE album.title = track_raw.album);

SELECT track.title, album.title
    FROM track
    JOIN album ON track.album_id = album.id
    ORDER BY track.title LIMIT 3;
 
insert into track(title,len,rating,count,album_id)
select title,len,rating,count,album_id
 from track_raw;

delete FROM album;

commit;

select *
from album;

select *
from track_raw;


update track_raw tr
set album_id = (select id
				from album al
				where al.title = tr.album);


		SELECT track.title, album.title
    FROM track
    JOIN album ON track.album_id = album.id
    ORDER BY track.title LIMIT 3;
    
   
   
   insert into album(title)
   select distinct album
   from track_raw;
   
  
  delete from track;
  delete from album;
  
 
 
DROP TABLE unesco_raw;
CREATE TABLE unesco_raw
 (name TEXT, description TEXT, justification TEXT, year INTEGER,
    longitude FLOAT, latitude FLOAT, area_hectares FLOAT,
    category TEXT, category_id INTEGER, state TEXT, state_id INTEGER,
    region TEXT, region_id INTEGER, iso TEXT, iso_id INTEGER);

CREATE TABLE category (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);



INSERT INTO category(name) SELECT DISTINCT category FROM 
unesco_raw;
INSERT INTO state(name) SELECT DISTINCT state FROM unesco_raw;
INSERT INTO region(name) SELECT DISTINCT region FROM 
 unesco_raw;
INSERT INTO iso(name) SELECT DISTINCT iso FROM unesco_raw;

UPDATE unesco_raw SET category_id = (
  SELECT category.id FROM category WHERE category.name = unesco_raw.category);
UPDATE unesco_raw SET state_id = ( 
  SELECT state.id FROM state WHERE state.name = unesco_raw.state );
UPDATE unesco_raw SET region_id = (
    SELECT region.id FROM region WHERE region.name = unesco_raw.region);
UPDATE unesco_raw SET iso_id = (
    SELECT iso.id FROM iso WHERE iso.name = unesco_raw.iso);


select distinct iso_id
from unesco_raw;


CREATE TABLE unesco (
    name TEXT,
    description TEXT,
    justification TEXT,
    year INTEGER,
    longitude FLOAT,
    latitude FLOAT,
    area_hectares FLOAT,
    category_id INTEGER,
    state_id INTEGER,
    region_id INTEGER,
    iso_id INTEGER
);
INSERT INTO
  unesco(
    name,
    description,
    justification,
    year,
    longitude,
    latitude,
    area_hectares,
    category_id,
    state_id,
    region_id,
    iso_id
  ) select
  name,
  description,
  justification,
  year,
  longitude,
  latitude,
  area_hectares,
  category_id,
  state_id,
  region_id,
  iso_id from unesco_raw;
  
 
 SELECT unesco.name, year, category.name, state.name, region.name, iso.name
  FROM unesco
  JOIN category ON unesco.category_id = category.id
  JOIN iso ON unesco.iso_id = iso.id
  JOIN state ON unesco.state_id = state.id
  JOIN region ON unesco.region_id = region.id
  ORDER BY year, unesco.name
  LIMIT 3;
  
 
 SELECT track.title, album.title, artist.name
FROM track
JOIN album ON track.album_id = album.id
JOIN tracktoartist ON track.id = tracktoartist.track_id
JOIN artist ON tracktoartist.artist_id = artist.id
ORDER BY track.title
LIMIT 3;


CREATE TABLE tracktoartist (
    id SERIAL,
    track VARCHAR(128),
    track_id INTEGER REFERENCES track(id) ON DELETE CASCADE,
    artist VARCHAR(128),
    artist_id INTEGER REFERENCES artist(id) ON DELETE CASCADE,
    PRIMARY KEY(id)
);

select *
from artist;
