#!/bin/bash
#
# ./email.sh [common] [-s]
#   Get links for email.
#   Does not do any changes.
#   For common options, see './common.sh -h'.
#
#   -s    output for staging server
#

 . $(dirname "`readlink -e "$0"`")/common.sh &>/dev/null

U1='https://developer.'
U2='fedoraproject.org/'

stg=
ind=

[[ "$1" == '-s' ]] && { stg='stg.' ; ind='  ' ; shift ; }
URL="$U1$stg$U2"

[[ -d "$SITE" ]] || exit 1
cd "$SITE" || exit 1

c=0

git log --numstat master -1 \
  | grep '^[0-9]' \
  | tr -s '\t' ' ' \
  | cut -d' ' -f3 \
  | grep -vE '^(js/index.json|sitemap.xml|deployment.html|start.html|tech.html|tools.html|css/main.css|index.html)$' \
  | while read x; do
    let 'c+=1'
    echo "${ind}[$c] ${URL}$x"
  done
