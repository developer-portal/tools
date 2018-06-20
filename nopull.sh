#!/bin/bash
#
# ./nopull.sh [common][options] BRANCH [common]
#   Simple build, no rsync to server or git push.
#
# See `common.sh -h` for common options.
#
# Options:
#   -s      Do a 'Staging' build - without devel-server message.
#
# BRANCH    branch for commit on git
#

 . $(dirname "`readlink -e "$0"`")/common.sh || exit 1

  scd "website"

  [[ "$1" == '-s' ]] && {
    shift
    [[ -z "$1" ]] && die 'You have to specify a branch.'

    echo 'Warning: building without devel message!'
    vrun 'echo > _includes/announcement.html'

    :
  } || vrun 'git checkout HEAD _includes/announcement.html'

  buildsite

  B="${1:-devel}"
  MSG="${B^} update\n"
  prepgit "$B"
