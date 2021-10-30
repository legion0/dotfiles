# TODO: Consider using https://github.com/bpkg/bpkg or https://github.com/basherpm/basher

[[ ! -d "${HOME}/.bashrc.d" ]] || {
  for f in "${HOME}/.bashrc.d/"*.sh; do
    source "$f"
  done
}
