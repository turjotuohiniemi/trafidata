#!/bin/bash
cmd="true"
postcmd="psql trafi"
if [ "$1" = '--sql' ]; then
	postcmd="cat"
	shift
fi
if [ "$1" = "autot" -o "$1" = "all" ]; then
	cmd="$cmd && cat autot.sql data.csv && echo '\.'"
fi
if [ "$1" = "koodit" -o "$1" = "all" ]; then
	cmd="$cmd && cat koodisto.sql && (tr -d '\r' < 14931-Koodisto.csv) && echo -e '\n\\.'"
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
