#!/bin/bash
#
# ./run.sh
#   Run devel.sh in continuous mode and restart it on failure.
#   Intended for service-like usage.
#   See './common.sh -h' and others for more info.
#
#

 [[ "$1" ]] && { echo 'No help here! `head` this file ;)' ; exit 0 ; }

 D="$(readlink -f "`dirname "$0"`")"
 F="`readlink -f "$D/devel.sh"`"

 [[ -x "$F" ]] || { echo "Could not exec '$F' in '$D'" ; exit 1 ; }

while :; do
  echo -e "\n--> Running $F -c"
  $F -c
  echo '=== FAIL ==='
  sleep 300

done
