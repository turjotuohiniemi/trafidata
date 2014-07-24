SET client_encoding = 'UTF8';
SET client_min_messages = 'warning';
DROP VIEW kaarat;

CREATE OR REPLACE FUNCTION parsi_koodit(kuvaus text, selitetyyppi text,
  tietotyyppi text, taulunimi text) RETURNS void
AS $function$
DECLARE
  rows INTEGER;
BEGIN
  EXECUTE
    'DROP TABLE IF EXISTS ' || taulunimi;
  EXECUTE '
    CREATE TABLE ' || taulunimi || '
    AS SELECT koodintunnus::' || tietotyyppi || ', '
      || selitetyyppi || 'selite AS selite
      FROM koodit
      WHERE koodistonkuvaus = ''' || kuvaus || ''' AND kieli = ''fi''
    ';
  GET DIAGNOSTICS rows = ROW_COUNT;
  IF rows = 0 THEN
    RAISE EXCEPTION 'Koodistolle "%" ei löydy sisältöä', kuvaus;
  END IF;
END;
$function$
LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION parsi_kaikki_koodit() RETURNS TEXT AS $function$
BEGIN
  PERFORM parsi_koodit('Ajoneuvon väri', 'pitka', 'text', 'k_varit');
  PERFORM parsi_koodit('Polttoaine', 'pitka', 'text', 'k_polttoaine');
  PERFORM parsi_koodit('Kuntien numerot ja nimet', 'pitka', 'integer', 'k_kunnat');
  PERFORM parsi_koodit('Vaihteistotyyppi', 'pitka', 'text', 'k_vaihteisto');
  PERFORM parsi_koodit('Voimanvälitys ja tehostamistapa', 'pitka','integer', 'k_voimanvalitys');
  PERFORM parsi_koodit('Ohjaamotyyppi', 'lyhyt', 'integer', 'k_ohjaamo');
  PERFORM parsi_koodit('Korityyppi', 'pitka', 'text', 'k_kori');
  PERFORM parsi_koodit('Ajoneuvon käyttö', 'lyhyt', 'text', 'k_kaytto');
  RETURN 'ok';
END;
$function$
LANGUAGE 'plpgsql';

SELECT parsi_kaikki_koodit();

CREATE OR REPLACE VIEW kaarat AS
  SELECT autot.*,
    k_kaytto.selite AS ajoneuvonkaytto_,
    k_kori.selite AS korityyppi_,
    k_kunnat.selite AS kunta_,
    k_ohjaamo.selite AS ohjaamotyyppi_,
    k_polttoaine.selite AS kayttovoima_,
    k_vaihteisto.selite AS vaihteisto_,
    k_varit.selite AS vari_,
    k_voimanvalitys.selite AS voimanvaljatehostamistapa_
  FROM autot
    LEFT OUTER JOIN k_kaytto ON (ajoneuvonkaytto = k_kaytto.koodintunnus)
    LEFT OUTER JOIN k_kori ON (korityyppi = k_kori.koodintunnus)
    LEFT OUTER JOIN k_kunnat ON (kunta = k_kunnat.koodintunnus)
    LEFT OUTER JOIN k_ohjaamo ON (ohjaamotyyppi = k_ohjaamo.koodintunnus)
    LEFT OUTER JOIN k_polttoaine ON (kayttovoima = k_polttoaine.koodintunnus)
    LEFT OUTER JOIN k_vaihteisto ON (vaihteisto = k_vaihteisto.koodintunnus)
    LEFT OUTER JOIN k_varit ON (vari = k_varit.koodintunnus)
    LEFT OUTER JOIN k_voimanvalitys ON (voimanvaljatehostamistapa = k_voimanvalitys.koodintunnus);
