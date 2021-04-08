#!/bin/bash
#
# ./links.sh [common] [-s]
#   Git diff to links.
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

  [[ "$1" == '-s' ]] && { stg='stg.' ; ind='  ' ; shift ; }

  [[ -n "$1" ]] || die "Commit missing"

  URL="$U1$stg$U2"

  scd "website/content"

  set -o pipefail

  git diff --stat "$1" \
    | head -n -1 \
    | sed -e 's/^[\. ]*//g' \
    | cut -d' ' -f1 \
    | xargs -i bash -c "
        f='{}'
        [[ -r \"\$f\" ]] || \
          f=\"\$( find -name \"\$(basename \"\$f\")\" | grep \"\$f$\" | head -1 | cut -d'/' -f2- )\"
        [[ -r \"\$f\" ]] || exit 255

        f=\"\$(rev <<< \"\$f\" | cut -d'.' -f2- | rev)\"
        echo \"  ${URL}\${f}.html\"
      "
