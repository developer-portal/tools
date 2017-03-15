
[[ "$SCL_RUBY" ]] && {
  bash -c '. /etc/os-release ; grep -q "Red Hat Enterprise Linux" <<< "$NAME" ; exit $?' && {
     . scl_source enable "$SCL_RUBY" || die "$F scl_source enable $SCL_RUBY"
    scl_enabled "$SCL_RUBY" || die "$F enable $SCL_RUBY"

  }

}
