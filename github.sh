#!/bin/bash
WWWDIR="/var/www/gciruelos.com/html"
HOME="/home/"$USER
FOLDER="gciruelos.com"
SITE="__site"
HTML="$WWWDIR"
current_dir=$(basename "$PWD")
if [[ $(basename "$PWD") != $FOLDER ]]; then
  git clone https://github.com/gciruelos/gciruelos.com.git; cd $FOLDER
fi
git pull; make clean; make build;
cp -af "$SITE/." "$HTML/"
