#!/usr/bin/env bash
OUTDIR=__site
OUTTMP=${OUTDIR}_tmp
IDENTITY=("css/*" "js/*" "lyrics/*" "argentina/**" "static/**" "robots.txt" "favicon.ico")
POSTS=posts/*
INDEX="index.html"
TEMPLATES=templates/*
POSTLIST="templates/post-list.html"

mkdir -p $OUTDIR
mkdir -p $OUTTMP

# Resolve files that are copied verbatim.
echo "Resolving verbatim files..."
for f in "${IDENTITY[@]}"
do
  cp -R --parents $f $OUTDIR;
done

# Resolve about page.
echo "Resolving about..."
pandoc --template=templates/default.html -o ./$OUTDIR/about.html ./about.markdown

# Resolve posts.
echo "Resolving posts..."
for f in $POSTS
do
  echo "Resolving $f..."
  # xargs echo -n trims whitespace.
  post_url=$(head $f | grep "url:" | sed -e "s/url://" | xargs echo -n)
  post_title=$(head $f | grep "title:" | sed -e "s/title://" | xargs echo -n)
  post_date=$(basename $f .markdown | cut -c-10)
  file_name=$(basename $f .markdown)
  outtmp=./$OUTTMP/$file_name.1.markdown
  outtmp2=./$OUTTMP/$file_name.2.html
  outfile=./$OUTDIR/$post_url
  pandoc --mathjax --metadata date="$post_date" --template=templates/post.html -o $outtmp2 $f
  echo "---" > $outtmp
  echo "title: $post_title" >> $outtmp
  echo "url: $post_url" >> $outtmp
  echo "date: $post_date" >> $outtmp
  echo "---" >> $outtmp
  cat $outtmp2 >> $outtmp
  sed -i 's/\\/\\\\/g' $outtmp
  pandoc --template=templates/default.html -o $outfile $outtmp
done


# Resolve index.
echo "Resolving index..."
index_tmp=$OUTTMP/index.1.html
sed -e 's/\$partial("\(.*\)")\$/$\1()$/' $INDEX > $index_tmp
sed -i '0,/^---$/d' $index_tmp
sed -i '0,/^---$/d' $index_tmp
cp templates/post-list.html $OUTTMP/post-list.1.html
for field in url title date teaser
do
  sed -i "s/\\\$$field\\$/\$posts.$field\$/"  $OUTTMP/post-list.1.html
done
index_title=$(head $INDEX | grep "title:" | sed -e "s/title://" | xargs echo -n)
post_list=$(basename $POSTLIST .html);
post_list_yaml=$OUTTMP/$post_list.2.yaml
cp templates/default.html $OUTTMP/default.1.html
sed -e "/\\\$body\\$/{r $OUTTMP/post-list.1.html" -e 'd}' $OUTTMP/default.1.html > $OUTTMP/default.2.html
echo $post_list_yaml
echo "title: $index_title" >> $post_list_yaml
echo "posts:" >> $post_list_yaml
REVPOSTS=()
for f in $POSTS
do
  echo "Resolving index.html for $f..."
  post_url=$(head $f | grep "url:" | sed -e "s/url://" | xargs echo -n)
  post_title=$(head $f | grep "title:" | sed -e "s/title://" | xargs echo -n)
  post_date=$(basename $f .markdown | cut -c-10)
  echo "$post_date"
  echo "$post_title"
  post_tmp=$OUTTMP/post_url.2.markdown
  cp $f $post_tmp
  sed -i '0,/^---$/d' $post_tmp
  sed -i '0,/^---$/d' $post_tmp
  sed -i '/<!--more-->/q' $post_tmp
  sed -i 's/<!--more-->//' $post_tmp
  sed -i '1d' $post_tmp
  sed -i -e 's/^/    /'  $post_tmp
  echo "- title: $post_title" >> $OUTTMP/$post_url.1.yaml
  echo "  url: $post_url" >> $OUTTMP/$post_url.1.yaml
  echo "  date: $post_date" >> $OUTTMP/$post_url.1.yaml
  echo "  teaser: |" >> $OUTTMP/$post_url.1.yaml
  cat $post_tmp | sed -e 's/_/\&#95;/g' >> $OUTTMP/$post_url.1.yaml
  REVPOSTS[${#REVPOSTS[@]}]=$OUTTMP/$post_url.1.yaml
done
for (( idx=${#REVPOSTS[@]}-1 ; idx>=0 ; idx-- )) ; do
  cat ${REVPOSTS[idx]} >> $post_list_yaml
done
pandoc --mathjax --metadata-file=$post_list_yaml --template=$OUTTMP/default.2.html -o $OUTTMP/index.2.html /dev/null
cp $OUTTMP/index.2.html $OUTTMP/index.3.html
sed -i 's/<\/ br>/<br>/' $OUTTMP/index.3.html
cp $OUTTMP/index.3.html $OUTDIR/$INDEX


# Serve.
echo "Done!"
python -m http.server 9999 --directory $OUTDIR

