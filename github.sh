#!/bin/bash
WWWDIR="/var/www/gciruelos.com/html"
HOME="/home/"$USER
FOLDER=$HOME"/gciruelos.com"
SITE="_site"
HTML="$WWWDIR"
if [ ! -d "$FOLDER" ]; then
  cd $HOME
  git clone https://github.com/gciruelos/gciruelos.com.git
  cd gciruelos.com
  stack build
fi
cd $FOLDER
git pull
make clean
stack build
make build
cp -af "$FOLDER/$SITE/." "$HTML/"
