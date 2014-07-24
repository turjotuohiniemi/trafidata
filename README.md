trafidata
=========

Näillä skripteillä voit luoda oman PostgreSQL-tietokannan Trafin avoimen datan aineistosta. Testattu postgres-versiolla 8.4, mutta toiminee uudemmallakin.

Käyttöohjeet
------------

1. Luo trafi-niminen tietokanta sekä kytke PLpg/SQL-kieli käyttöön. Voit käyttää esimerkiksi seuraavia komentoja:

  ```
  createdb --locale fi_FI.utf8 trafi
  createlang plpgsql trafi
  ```

  Jos createdb-komento epäonnistuu template1-tietokannan merkistön vuoksi, voit käyttää sen sijaan komentoa:

  ```
  createdb --locale fi_FI.utf8 --template template0 trafi
  ```

2. Lataa csv-muotoinen aineisto Trafin sivuilta niin, että lopputuloksena hakemistossa on data.csv-niminen tiedosto. Tätä kirjoittaessa aineiston kotisivu on http://www.trafi.fi/palvelut/avoin_data
3. Lataa "datassa käytetty koodisto", joka on xls-tiedosto. Avaa se Excelissä ja tallenna csv-muotoon. Valitse tallennuksen yhteydessä merkistöksi utf-8 ja talenna nimellä koodisto.csv.
4. Aja nyt seuraava komento:

  ```
./import.sh all
  ```
  Komento luo tarvittavat tietokantataulut sekä ajaa sisällön niihin. Suoritus saattaa kestää jonkin aikaa (puoli tuntia lienee yleinen suoritusaika).
