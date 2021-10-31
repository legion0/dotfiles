# TODO: Consider using https://github.com/bpkg/bpkg or https://github.com/basherpm/basher

shopt -q nullglob && { bashrc_manager__shopt_nullglob_prev_state="-s" } || { bashrc_manager__shopt_nullglob_prev_state="-u" }
[[ "${bashrc_manager__shopt_nullglob_prev_state}" == "-s" ]] || shopt -s nullglob

bashrc_manager__files=("${HOME}/.bashrc.d/"*.sh)

[[ "${bashrc_manager__shopt_nullglob_prev_state}" == "-s" ]] || shopt -u nullglob
unset bashrc_manager__shopt_nullglob_prev_state

for f in "${bashrc_manager__files[@]}"; do
  source "$f"
done

unset bashrc_manager__files
