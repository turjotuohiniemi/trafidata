#!/bin/bash

# 
# konffaus (tietokanta- ja tiedostonimet)
#
dbname=trafi
koodistocsv=koodisto.csv
datacsv=data.csv

#
# koodi alkaa tästä
#

requirefile() {
	if [ ! -e $1 ]; then
		echo "$1: file does not exist"
		exit 1
	fi
}

cmd="true"
postcmd="psql $dbname"
if [ "$1" = '--sql' ]; then
	postcmd="cat"
	shift
fi
if [ "$1" = "autot" -o "$1" = "all" ]; then
	requirefile $datacsv
	cmd="$cmd && cat autot.sql $datacsv && echo '\.'"
fi
if [ "$1" = "koodit" -o "$1" = "all" ]; then
	requirefile $koodistocsv
	cmd="$cmd && cat koodisto.sql && (tr -d '\r' < $koodistocsv) && echo -e '\n\\.'"
	cmd="$cmd && cat prosessoi_koodit.sql"
fi
if [ "$1" = "indeksit" -o "$1" = "all" ]; then
	tmp=`tempfile -s .sql`
	for field in `head -1 data.csv | tr ',' ' ' | tr -d '\r' ` ; do
		if [ "x$field" != "xjarnro" ]; then
			echo "CREATE INDEX autot_${field}_index ON autot ($field) WITH (FILLFACTOR = 100);" >> $tmp
		fi
	done
	cmd="$cmd && cat $tmp"
fi
if [ "$cmd" = "true" ]; then
	echo "Usage: import.sh [--sql] (all | autot | koodit | indeksit)"
	exit 1
fi
eval "($cmd ) | $postcmd"
if [ "x$tmp" != "x" ]; then
	rm $tmp
fi
