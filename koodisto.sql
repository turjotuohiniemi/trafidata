DROP TABLE IF EXISTS koodit;
CREATE TABLE koodit (
  Järjestysnumero		INT,
  KOODISTONKUVAUS		TEXT,
  KOODINTUNNUS			TEXT,
  LYHYTSELITE			TEXT,
  PITKASELITE			TEXT,
  KIELI				TEXT
);
SET client_encoding = 'iso-8859-1';
COPY koodit FROM stdin DELIMITER ';' CSV HEADER;
