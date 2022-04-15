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
  # file_name=$(basename $f .markdown)
  # outtmp=./$OUTTMP/$file_name.post.1
  # outtmp2=./$OUTTMP/$file_name.post.2
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
# sed 's/\$partial("\(.+\)")\$/\1()/' $INDEX
sed -e 's/\$partial("\(.*\)")\$/$\1()$/' $INDEX > $OUTTMP/$INDEX.1
sed -i '0,/^---$/d' $OUTTMP/$INDEX.1
sed -i '0,/^---$/d' $OUTTMP/$INDEX.1
cp templates/post-list.html $OUTTMP/post-list.html.1
for field in url title date teaser
do
  sed -i "s/\\\$$field\\$/\$posts.$field\$/"  $OUTTMP/post-list.html.1
done
#pandoc --template=templates/post-list.html -o $OUTTMP/post-list.html /dev/null
index_title=$(head $INDEX | grep "title:" | sed -e "s/title://" | xargs echo -n)
post_list=$(basename $POSTLIST .html);
post_list_yaml=$OUTTMP/$post_list.2.yaml
sed -e 's/\$title\$//' templates/default.html > $OUTTMP/default.html.1
sed -e "/\\\$body\\$/{r $OUTTMP/post-list.html.1" -e 'd}' $OUTTMP/default.html.1 > $OUTTMP/default.2.html
echo $post_list_yaml
echo "title: $index_title" >> $post_list_yaml
echo "posts:" >> $post_list_yaml
for f in $OUTTMP/*.1.markdown
do
  echo "Resolving index.html for $f..."
  post_url=$(head $f | grep "url:" | sed -e "s/url://" | xargs echo -n)
  post_title=$(head $f | grep "title:" | sed -e "s/title://" | xargs echo -n)
  post_date=$(basename $f .1.markdown | cut -c-10)
  echo "$post_date"
  echo "$post_title"
  cp $f $OUTTMP/$post_url.html.2
  sed -i '0,/^---$/d' $OUTTMP/$post_url.html.2
  sed -i '0,/^---$/d' $OUTTMP/$post_url.html.2
  sed -i '/<!--more-->/q' $OUTTMP/$post_url.html.2
  sed -i '1d' $OUTTMP/$post_url.html.2
  sed -i -e 's/^/    /'  $OUTTMP/$post_url.html.2
  #sed -i 's/\\/\\\\/g' $OUTTMP/$post_url.html.2
  echo "- title: $post_title" >> $post_list_yaml
  echo "  url: $post_url" >> $post_list_yaml
  echo "  date: $post_date" >> $post_list_yaml
  echo "  teaser: |" >> $post_list_yaml
  #echo '   ```' >> $post_list_yaml
  cat $OUTTMP/$post_url.html.2 >> $post_list_yaml
  #echo '   ```' >> $post_list_yaml
done
pandoc --mathjax --metadata-file=$post_list_yaml --template=$OUTTMP/default.2.html -o $OUTTMP/index.2.html /dev/null
sed -i 's/\\/\\\\/g' $OUTTMP/index.2.html
cp $OUTTMP/index.2.html $OUTDIR/$INDEX
# pandoc --mathjax --template=templates/default.html -o $outfile $outtmp


# Clean-up and serve.
echo "Done!"
python -m http.server 9999 --directory $OUTDIR

