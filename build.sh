#!/usr/bin/env bash
OUTDIR=__site
OUTTMP=${OUTDIR}_tmp
IDENTITY=("css/*" "js/*" "lyrics/*" "argentina/**" "static/**" "robots.txt" "favicon.ico")
POSTS=posts/*
INDEX="index.html"

mkdir -p $OUTDIR
mkdir -p $OUTTMP

# Resolve files that are copied verbatim.
for f in "${IDENTITY[@]}"
do
  cp -R --parents $f $OUTDIR;
done

# Resolve about page.
pandoc --template=templates/default.html -o ./$OUTDIR/about.html ./about.markdown

# Resolve posts.
for f in $POSTS
do
  echo "$f"
  # xargs echo -n trims whitespace.
  post_url=$(head $f | grep "url:" | sed -e "s/url://" | xargs echo -n);
  post_title=$(head $f | grep "title:" | sed -e "s/title://" | xargs echo -n);
  post_date=$(basename $f .markdown | cut -c-10)
  outtmp=./$OUTTMP/tmp_$post_url.markdown
  outtmp2=./$OUTTMP/tmp_$post_url
  outfile=./$OUTDIR/$post_url
  echo "$post_url"
  echo "$post_title"
  echo "$post_date"
  pandoc --metadata date="$post_date" --template=templates/post.html -o $outtmp2 $f
  echo "---" > $outtmp
  echo "title: $post_title" >> $outtmp
  echo "date: $post_date" >> $outtmp
  echo "---" >> $outtmp
  cat $outtmp2 >> $outtmp
  sed -i "s/\\\\/\\\\\\\\/g" $outtmp
  pandoc --mathjax --template=templates/default.html -o $outfile $outtmp

  # sed "/\$body\$/ r $outfile" templates/default.html
  # sed -e "/.*\$body\$.*/ {" -e "r $outfile" -e "d" -e "}" templates/default.html #> $outfile
  # sed "/<!--more-->/q" $f > ./$OUTTMP/$post_url
done


# Resolve index.
# sed 's/\$partial("\(.+\)")\$/\1()/' $INDEX
sed -e 's/\$partial("\(.*\)")\$/${ \1() }$/' $INDEX > $OUTTMP/$INDEX.html
#pandoc --template=templates/post-list.html -o $OUTTMP/post-list.html /dev/null
pandoc --template=templates/default.html -o $OUTTMP/$INDEX $OUTTMP/$INDEX.html
pandoc --template=$OUTTMP/$INDEX /dev/null

# Clean-up and serve.
ls __site
python -m http.server 9999 --directory $OUTDIR

