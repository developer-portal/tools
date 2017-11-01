
[[ "$SCL_ENABLE" ]] && {
  for scl in $SCL_ENABLE; do
     . scl_source enable "$scl" || die "$F scl_source enable $scl"
    scl_enabled "$scl" || die "$F enable $scl"
    echo "scl enabled: $scl"
  done
}

