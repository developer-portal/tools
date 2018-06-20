#!/bin/bash
#
# ./devel.sh [common] [-c] [-f] [-s]
#   Build devel instance, rsync to server and push to git if changes in git are present.
#   Can monitor for git changes, i.e. continuous run(-c).
#
#   For service-like usage, see run.sh.
#   For common options, see './common.sh -h'.
#   Specific order of options is required!
#
#   Options:
#     -c    continuous run
#     -f    run even with no changes present
#     -s    simulate; do not rsync/push
#
#

 . $(dirname "`readlink -e "$0"`")/common.sh || exit 1

[[ "$1" == "-c" ]] && { CONT="$1" ; shift ; } || CONT=

[[ "$1" == "-f" ]] && {
  logg "Force update"
  shift

  :
} || {
  [[ "$CONT" ]] && logg "Git monitoring..."

  while :; do
    scd "website" -s && gitnchange && \
    scd "website/content" -s && gitnchange && {
      [[ "$CONT" ]] || {
        echo "Already Up To date :)"
        exit 0

      }

      sleep 300
      continue

    }

    break
  done
}

  [[ "$1" == '-s' ]] && { SIM="$1" ; shift ; } || SIM=

  MSG='Devel update\n'

  upgit "website"
  upgit "website/content"

  buildsite

  prepgit devel
  vrun -a $SIM "git push"

  HTML="/var/www/html/"

  scd "website"
  vrun -a $SIM "$RSYN rss.py $DST/root/"
  vrun -a $SIM "$RSYN rss.py $DST$HTML"

  scd "website/_site"
  vrun -a $SIM "$RSYN * $DST$HTML"
  vrun -a $SIM "$RSYN * $DST/root/_site/"

  [[ "$CONT" ]] || exit 0

  scd
  logg "Done\n"
  logg "`date -I'seconds'`"
  C="`readlink -e "$0"` -c"
  logg "exec $C"
  exec $C -c
