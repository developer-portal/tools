
[[ "$SCL_RUBY" ]] && {
   . scl_source enable "$SCL_RUBY" || die "$F scl_source enable $SCL_RUBY"
  scl_enabled "$SCL_RUBY" || die "$F enable $SCL_RUBY"

}
