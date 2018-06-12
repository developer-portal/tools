#!/bin/bash
#
#  . common.sh
#     Intended for sourcing. Contains common presets and functions.
#     Specific options order is required!
#
# Common options:
#   -h    this help
#   -d    debug mode
#   -i    interactive run
#
#

 F="Failed to"
 P="`pwd`"
 LOGF="$(readlink -m "$P/log/`date -I'seconds'`_`basename -s '.sh' "$0"`.log")"
 RSYN='rsync --del -az'
 DST='root@developer.fedorainfracloud.org:'
 LOGGPR="--> "
 SITE='developer.fedoraproject.org'

getd () {
  readlink -f "$P/$1"
}

usage () {
  awk '{if(NR>1)print;if(NF==0)exit(0)}' < "$0" | sed '
    s|^#[   ]||
    s|^#$||
  ' | ${PAGER-more}

  exit 0
}

upgit () {
  local D="`getd "$1"`"

  [[ -d "$D" ]] || {
    scd "`dirname "$D"`"
    vrun "git clone https://github.com/developer-portal/`basename "$1"`.git"
  }

  scd "$1"

  vrun 'git stash'
  vrun 'git checkout master'
  [[ "`git branch | grep '^*' | cut -d' ' -f2`" == 'master' ]] || die "Invalid branch"
  vrun 'git pull'
}

scd () {
  local D="`getd "$1"`"
  local S=
  [[ "$2" == "-s" ]] && S=y

  [[ "$D" ]] || {
    [[ "$S" ]] && return 1

    die "Dir nonexistent '$P/$1'"

  }

  cd "$D" || die "$F cd '$D'"
  [[ "`pwd`" == "$D" ]] || die "Invalid cd '`pwd`' <> '$D'"
  [[ "$S" ]] || logg "cd '$D'"

  return 0

}

die () {
  logg "Error: ${1}!" >&2

  exit 1

}

logg () {
  local M="$@"
  echo -e "$LOGGPR$M" | tr "\n" "\t"
  echo

  return 0

}

vrun () {
  [[ "$1" == '-a' ]] && {
    shift
    [[ "$INT" ]] && ask "$1"

  }

  [[ "$1" == '-s' ]] && {
    shift
    logg "[NOT RUN] $1"
    return 0

  }

  logg "$1"

  [[ "$DEB" ]] && set -x
  bash -c "$1 2>&1" || die "while running '$1'"
  [[ "$DEB" ]] && set +x

  return 0

}

gitnchange () {
  local X="`git remote -v update 2>&1 | tr -s '\t' ' ' | grep ' master -> origin/master$' | grep -v ' = \[up to date\]'`"

  [[ "$X" ]] && {
    logg "Git Updated: `pwd`"
    logg "`date -I'seconds'`"
    logg "$X"

    return 1

  }

  return 0

}

buildsite () {
  local Y="website/_site"
  local X="`getd "$Y"`"

  [[ -d "$X" || -r "$X" ]] && {
    logg "Removing '$X'"
    rm -rf "$X"

  }

  scd 'website'
  logg 'Building site ...'

  local f=
  local O
  O="$(vrun 'jekyll build')" || f=y
  grep -v "Build Warning: Layout 'content' requested in" <<< "$O"
  [[ -n "$f" ]] && die "Jekyll build failed!"

  [[ -d "$X" ]] || die "'$X' does not exist!"
  find "$X" -type f -iname '*.html' | while read z; do
    TMP="`ruby -ne 'BEGIN{ \$pre = false } ; x = \$_ ; \$pre = ( (x =~ /<pre/i) || (\$pre && !(x =~ /<\/pre/i) ) ) ; print unless (!\$pre && x =~ /^\s*$/)' < "$z"`"

    echo "$TMP" > "$z"
    TMP=
  done

}

addmsg () {
  MSG="`echo -e "$MSG\n$1"`"

}

ask () {
  local R=
  for u in {1..3}; do
    R=
    read -p "${LOGGPR}Run '$1'? (y/N) " R
    [[ "${R^^}" == "Y" ]] && break
    [[ "${R^^}" == "N" || -z "${R^^}" ]] && break

  done

  [[ "${R^^}" == "Y" ]] || die "User Quit"

}

prepgit () {
  [[ "$1" ]] || die "Invalid prepgit"

  scd "website"
  addmsg "website commit: `git rev-parse --verify HEAD`"

  scd "website/content"
  addmsg "content commit: `git rev-parse --verify HEAD`"

  upgit "$SITE"
  scd "$SITE"

  vrun "git checkout $1"
  [[ "`git branch | grep '^*' | cut -d' ' -f2`" == "$1" ]] || die "Invalid branch"

  vrun -a "rm -fr *"
  vrun "cp -r `getd "website/_site"`/* ."
  vrun "cp -r `getd "website"`/rss.py ."

  vrun "gita -A"

  local C="git commit -am"
  echo "${LOGGPR}$C $MSG"
  $C "$MSG" || die "Failed to create commit"

  local L="`git show | cat -n | grep 'diff --git a/js/index.json b/js/index.json' | tr -s '\t' ' ' | cut -d' ' -f2`"

  grep -qE '^[0-9]+$' <<< "$L" && {
    let 'L += 5' 'K = L + 2'
    logg "git show"
    gith | sed -e "$L,${K}d" | colordiff

  }

  vrun 'git status'
}

 [[ "$1" == "-h" || "$1" == "--help" ]] && usage
 [[ "$1" == "-d" ]] && { DEB="$1" ; shift ; } || DEB=
 [[ "$1" == "-i" ]] && { INT="$1" ; shift ; } || INT=

 [[ "$LOGF" ]] || die "No LOGF"
 mkdir -p "`dirname "$LOGF"`" || die "$F mkdir -p '`dirname "$LOGF"`'"
 touch "$LOGF"
 [[ -w "$LOGF" ]] || die "$F write '$LOGF'"

 exec &> >(tee -a "$LOGF")

  . $(dirname "`readlink -e "$0"`")/enable_scl.sh
