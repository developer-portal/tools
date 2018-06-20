#!/bin/bash
#
# ./run.sh [anything]
#   Run devel.sh in continuous mode and restart it on failure.
#   Intended for service-like usage.
#   See './common.sh -h' and others for more info.
#
#   All args are passed to devel.sh
#

  [[ "$1" == "-h" ]] && { echo 'No help here! `head` this file ;)' ; exit 0 ; }

  D="$(readlink -f "`dirname "$0"`")"
  F="`readlink -f "$D/devel.sh"`"

  [[ -x "$F" ]] || { echo "Could not exec '$F' in '$D'" ; exit 1 ; }

  while echo -e "\n--> Running $F -c $@"; do
    $F -c "$@"
    echo '=== FAIL ==='
    sleep 300
  done
