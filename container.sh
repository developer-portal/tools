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

  vrun 'echo > _includes/announcement.html'

  # container run
  vrun 'docker run -d --rm -p4000:4000 -v $PWD:/opt/developerportal/website:Z quay.io/developer-portal/start'

  sleep 10

  # container copy
  vrun 'podman container cp "`podman ps -lq`:/opt/developerportal/website/_site/" .'

  vrun 'podman stop -l'

  cleanup

  prepgit master

  logg "Done\n"
