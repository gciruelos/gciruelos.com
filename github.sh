#!/bin/bash
WWWDIR="/var/www/gciruelos.com/html"
HOME="/home/"$USER
FOLDER=$HOME"/gciruelos.com"
SITE="__site"
HTML="$WWWDIR"
if [ ! -d "$FOLDER" ]; then
  cd $HOME; git clone https://github.com/gciruelos/gciruelos.com.git;
fi
cd $FOLDER; git pull; make clean; make build;
cp -af "$FOLDER/$SITE/." "$HTML/"
