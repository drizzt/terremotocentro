#!/usr/bin/env bash

git clean -fxd
git reset --hard HEAD
git pull

BASE_URI='https://docs.google.com/spreadsheets/d/1WL5BuoKQRM560VNctYOeDeineLeBwP7vtFlwltasASM/export?single=true&format=csv&gid='

wget -O- 'https://docs.google.com/spreadsheets/d/1WL5BuoKQRM560VNctYOeDeineLeBwP7vtFlwltasASM/export?gid=208924232&single=true&format=tsv' |
sed -e 's/\r$//g' -e '$a\' | tail -n +2 | while IFS=$'\t' read -r section gid; do
	filename="${section,,}.csv"
	# Paranoia++
	[[ "/$filename/" == */../* ]] && continue
	wget -O "_data/$filename" "$BASE_URI$gid"
done

#MD_vittime='http://blog.spaziogis.it/static/projs/terremotocentroitalia/vittime.md'

#wget -O vittime.md $MD_vittime

sed -i 's/\r$//g' _data/*.csv

git add _data
#git add vittime.md
git commit -m "auto CSV update $(date -Iseconds)"
git pull --rebase
git push

git clean -fxd
git reset --hard HEAD

