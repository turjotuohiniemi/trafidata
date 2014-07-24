#!/bin/bash
> stats.sql
for field in `head -1 ajoneuvodata.csv | tr ',' ' ' | tr -d '\r' ` ; do
	if [ "x$field" != "xjarnro" ]; then
		echo "SELECT $field, count(*) FROM autot GROUP BY $field ORDER BY count DESC LIMIT 100;" >> stats.sql
	fi
done
psql -f stats.sql trafi > stats.txt
rm stats.sql
