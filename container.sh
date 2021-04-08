#!/bin/bash
#
# ./commit.sh [common]
#   Prepare staging branch for release.
#   Does only local changes.
#   For common options, see './common.sh -h'.
#

 . $(dirname "`readlink -e "$0"`")/common.sh || exit 1

  MSG='Content & Website update\n'

  scd "website"

  # container run
  vrun 'docker run -it --rm -p4000:4000 -v $PWD:/opt/developerportal/website:Z pvalena/developer-portal'

  vrun 'echo > _includes/announcement.html'

  # container copy
  vrun 'podman container cp "`podman ps -lq`:/opt/developerportal/website/_site/" .'

  cleanup

  prepgit master

  vrun 'podman stop -l'

  logg "Done\n"
