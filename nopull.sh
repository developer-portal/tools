#!/bin/bash
#
# ./nopull.sh BRANCH [common]
#   Simple build, no rsync to server or git push.
#
# BRANCH    branch for commit on git
#

  . $(dirname "`readlink -e "$0"`")/common.sh
[[ "$SITE" ]] || exit 1
[[ -n "$1" ]] || die 'you have to specify a branch.'

[[ "$1" == "devel" ]] || {
  scd "website"
  echo > _includes/announcement.html
}

 buildsite

 MSG="${1^} update\n"

 prepgit "$1"
