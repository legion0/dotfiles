#!/usr/bin/env bash

set -e

TOPLEVEL_PATH="$(git rev-parse --show-toplevel 2>&1)" || exit 1
HEAD_REF="$(git symbolic-ref HEAD 2>&1)"
branch="${HEAD_REF:11}"

STATUS="$(git status --porcelain)"

staged=0
untracked=0
modefied=0
dirty=0
other=0

while IFS= read -r line; do
	[ "$line" == "" ] && continue
	echo "###$line###"
	m1="${line:0:1}"
	m2="${line:1:1}"
	mode="${m1}${m2}"
#	path="${line:3}"
	is_not_relative_path=true
#	[[ "${TOPLEVEL_PATH}/${path}" == "$PWD"* ]] || is_not_relative_path=false
#	other_path=""
	is_not_relative_other_path=true
#	if [[ "$path" == *" -> "* ]]; then
#		other_path="${path/* -> /}"
#		path="${path/ -> */}"
#		[[ "${TOPLEVEL_PATH}/${other_path}" == "$PWD"* ]] || is_not_relative_other_path=false
#	fi
	if [ "$mode" == "??" ] && $is_not_relative_path; then
		((untracked+=1))
	fi
	if [[ "MADRC" == *"$m1"* ]] && [[ " MD" == *"$m2"* ]]; then
		((staged+=1))
	fi
	if [[ " MARC" == *"$m1"* ]] && [[ "MD" == *"$m2"* ]] && $is_not_relative_path; then
		((modefied+=1))
	fi
	if [[ "DAU" == *"$m1"* ]] && [[ "DAU" == *"$m2"* ]] && { $is_not_relative_path || $is_not_relative_other_path; }; then
		((dirty+=1))
	fi
done <<< "$STATUS"

if [ -z "$branch" ]; then
	branch=$(git rev-parse --short HEAD)
else
	remote_name=$(git config branch.${branch}.remote) || remote_name=""
	if [ -n "$remote_name" ]; then
		merge_name=$(git config branch.${branch}.merge)
	else
		remote_name=origin
		merge_name="refs/heads/${branch}"
	fi

	if [ "$remote_name" == "." ]; then
		remote_ref=$merge_name
	else
		remote_ref=refs/remotes/$remote_name/${merge_name:11}
	fi
	rev_list="$(git rev-list --left-right ${remote_ref}...HEAD)"
	# rev_list="$(git rev-list --left-right ${merge_name}...HEAD)" # fallback to merge_name
	ahead=$(echo "$rev_list" | grep '^>' | wc -l)
	behind=$(echo "$rev_list" | grep '^<' | wc -l)
fi

echo branch=$branch
echo remote=$remote_name
echo STAGED=$staged
echo DIRTY=$dirty
echo MODEFIED=$modefied
echo UNTRACKED=$untracked
echo OTHER=$other
echo AHEAD=$ahead
echo BEHIND=$behind


