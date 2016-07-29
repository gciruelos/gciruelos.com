#!/bin/bash
FOLDER=$HOME"/gciruelos.com"
SITE="_site"
HTML="$WWWDIR"
if [ ! -d "$FOLDER" ]; then
  cd $HOME
  git clone https://github.com/gciruelos/gciruelos.com.git
  cd gciruelos.com
  cabal sandbox init
  cabal update
  cabal install --only-dependencies
fi
cd $FOLDER
make clean
cabal configure
cabal build
make build
cp -Rf "$FOLDER/$SITE" $HTML
