#!/usr/bin/env bash
OUTDIR=__site
OUTTMP=${OUTDIR}_tmp
IDENTITY=("css/*" "js/*" "lyrics/*" "argentina/**" "static/**" "robots.txt" "favicon.ico")
POSTS=posts/*
INDEX="index.html"
TEMPLATES=templates/*
POSTLIST="templates/post-list.html"
TEMPLATE="templates/default.html"
POST="templates/post.html"

P=pandoc
PM="pandoc --mathjax"

postprocess_html() {
  sed -i -e 's/href="\/\(.*\)"/href=".\/\1"/g' $1
  sed -i -e 's/script async/script async="async"/g' $1
  for ((i=1; i<=10; i++))
  do
    sed -i -e "s/title=\"$i\"/data-line-number=\"$i\"/g" $1
  done
}

no_diff_hacks() {
  sed -i -e 's/^\(.*\)post_link\(.*\)<br>\(.*\)$/\1post_link\2<!-- br-->\3/g' \
    $OUTDIR/index.html
  # sed -i -e 's/<span class="fu">=<\/span>/<span class="ot">=<\/span>/g' \
  #   $OUTDIR/propositions-as-types.html
  sed -i -e 's/href="\//href=".\//g' $OUTDIR/about.html
  # twice to resolve all appearances.
  sed -i -e 's/^\(.*\)sourceLine\(.*\)\\\\\(.*\)$/\1sourceLine\2\\\3/' \
    $OUTDIR/propositions-as-types.html
  sed -i -e 's/^\(.*\)sourceLine\(.*\)\\\\\(.*\)$/\1sourceLine\2\\\3/' \
    $OUTDIR/propositions-as-types.html
}

remove_yaml_header() {
  sed -i '0,/^---$/d' $1
  sed -i '0,/^---$/d' $1
}

get_post_date() {
  basename $1 .markdown | cut -c-10 | xargs -0 date '+%B %e, %Y' -d
}
# xargs echo -n trims whitespace.
get_post_title() {
  head $1 | grep "title:" | sed -e "s/title://" | xargs echo -n
}
get_post_url() {
  head $1 | grep "url:" | sed -e "s/url://" | xargs echo -n
}

run_build() {
  rm -r $OUTDIR
  rm -r $OUTTMP
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
  $P --template=$TEMPLATE -o $OUTDIR/about.html ./about.markdown
  postprocess_html $OUTDIR/about.html

  # Resolve posts.
  echo "Resolving posts..."
  for f in $POSTS
  do
    echo "Resolving $f..."
    post_url=$(get_post_url $f)
    post_date=$(get_post_date $f)
    outtmp=$OUTTMP/$(basename $f .markdown).1.markdown
    echo "---" > $outtmp
    echo "title: $(get_post_title $f)" >> $outtmp
    echo "url: $post_url" >> $outtmp
    echo "date: $post_date" >> $outtmp
    echo "---" >> $outtmp
    $PM --metadata date="$post_date" --template=$POST -o- $f >> $outtmp
    sed -i 's/\\/\\\\/g' $outtmp
    sed -e 's/.*\$body\$.*/$body$/' $TEMPLATE > $OUTTMP/default.4.html
    $P --template=$OUTTMP/default.4.html -o $OUTDIR/$post_url $outtmp
    postprocess_html $OUTDIR/$post_url
  done


  # Resolve index.
  echo "Resolving index..."
  index_tmp=$OUTTMP/index.1.html
  sed -e 's/\$partial("\(.*\)")\$/$\1()$/' $INDEX > $index_tmp
  remove_yaml_header $index_tmp  # unneeded
  cp templates/post-list.html $OUTTMP/post-list.1.html
  for field in url title date teaser
  do
    sed -i "s/\\\$$field\\$/\$posts.$field\$/"  $OUTTMP/post-list.1.html
  done
  index_title=$(get_post_title $INDEX)
  post_list=$(basename $POSTLIST .html);
  post_list_yaml=$OUTTMP/$post_list.2.yaml
  edited_default=$OUTTMP/default.1.html
  cp $TEMPLATE $edited_default
  sed -i -e "/\\\$body\\$/{r $OUTTMP/post-list.1.html" -e 'd}' $edited_default
  echo "title: $index_title" >> $post_list_yaml
  echo "posts:" >> $post_list_yaml
  REVPOSTS=()
  for f in $POSTS
  do
    echo "Resolving index.html teaser for $f..."
    post_url=$(head $f | grep "url:" | sed -e "s/url://" | xargs echo -n)
    post_date=$(get_post_date $f)
    teasermd=$OUTTMP/post_url.2.markdown
    teaseryaml=$OUTTMP/$post_url.1.yaml
    cp $f $teasermd
    remove_yaml_header $teasermd
    sed -i '/<!--more-->/q' $teasermd
    sed -i 's/<!--more-->//' $teasermd
    sed -i '1d' $teasermd
    sed -i -e 's/^/    /'  $teasermd
    echo "- title: $(get_post_title $f)" >> $teaseryaml
    echo "  url: $post_url" >> $teaseryaml
    echo "  date: $post_date" >> $teaseryaml
    echo "  teaser: |" >> $teaseryaml
    sed -e 's/_/\&#95;/g' $teasermd >> $teaseryaml
    echo "      " >> $teaseryaml
    REVPOSTS[${#REVPOSTS[@]}]=$teaseryaml
  done
  for ((i=${#REVPOSTS[@]}-1; i>=0; i--))
  do
    cat ${REVPOSTS[i]} >> $post_list_yaml
  done
  $PM --metadata-file=$post_list_yaml --template=$edited_default -o- /dev/null \
    | sed -e 's/<\/ br>/<br>/' > $OUTDIR/$INDEX
  postprocess_html $OUTDIR/$INDEX
  no_diff_hacks
  echo "Done!"
}

run_tidy() {
  tidy -config tidy.conf $1 | sed -e "s/^[ \t]*//"
}

run_diff () {
  echo "Diffing..."
  for new_f in $OUTDIR/**.html
  do
    echo "Diffing $new_f..."
    diff <(run_tidy ${new_f:1}) <(run_tidy $new_f)
  done
}

if [ $1 == "build" ];
then
  run_build
elif [ $1 == "watch" ];
then
  run_build
  python -m http.server 9999 --directory $OUTDIR
elif [ $1 == "diff" ];
then
  run_build
  run_diff
else
  echo "Nothing to do"
fi
