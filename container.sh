#!/bin/bash
#
# ./container.sh [common][options]
#   Prepare staging branch for release.
#   Does only local changes.
#
# Options:
#
#   -c    Continue with current container, don't pull an updated one.
#
#   -u    Update to latest website+content git commits
#
# For common options, see './common.sh -h'.
#

 . $(dirname "`readlink -e "$0"`")/common.sh || exit 1

[[ "$1" == "-c" ]] && {
  shift
  PULL=''
  :
} || {
  PULL="--pull=always"
}

[[ "$1" == "-u" ]] && {
  shift
  upgit "website"
  upgit "website/content"
}

MSG='Content & Website update\n'

scd "website"

vrun 'echo > _includes/announcement.html'
vrun 'rm Gemfile.lock ||:'

# container run
vrun "podman run $PULL -d --rm -v $PWD:/opt/developerportal/website:Z quay.io/developer-portal/devel"

sleep 15

vrun 'podman logs -l'
vrun 'podman ps -l --format "{{.Status}}" | grep "^Up "'

# container copy
vrun 'podman container cp "`podman ps -lq`:/opt/developerportal/website/_site/" .'

sleep 1

vrun 'podman stop -l'

cleanup

prepgit master

logg "Done\n"
