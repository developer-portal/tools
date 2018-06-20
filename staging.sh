#!/bin/bash
#
# ./staging.sh [common]
#   Prepare staging branch for release.
#   Does only local changes.
#   For common options, see './common.sh -h'.
#

 . $(dirname "`readlink -e "$0"`")/common.sh || exit 1

  MSG='Content & Website update\n'

  upgit "website"
  upgit "website/content"

  scd "website"
  vrun 'echo > _includes/announcement.html'

  buildsite

  prepgit master

  logg "Done\n"
