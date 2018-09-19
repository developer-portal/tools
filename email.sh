#!/bin/bash
#
# ./email.sh [common] [-s]
#   Get links for email.
#   Does not do any changes.
#   For common options, see './common.sh -h'.
#
#   -s    output for staging server
#

 . $(dirname "`readlink -e "$0"`")/common.sh &>/dev/null || exit 1

  U1='https://developer.'
  U2='fedoraproject.org/'

  stg=
  ind=
  c=0
  br=release

  [[ "$1" == '-s' ]] && { stg='stg.' ; br=master ; ind='  ' ; shift ; }

  URL="$U1$stg$U2"

  scd "$SITE"

  git log --numstat -1 "$br" \
    | grep '^[0-9]' \
    | tr -s '\t' ' ' \
    | cut -d' ' -f3 \
    | grep -vE '^(js/index.json|sitemap.xml|deployment.html|start.html|tech.html|tools.html|css/main.css|index.html)$' \
    | \
    while read x; do
      #let 'c+=1'
      echo "${ind}[] ${URL}$x"
    done
