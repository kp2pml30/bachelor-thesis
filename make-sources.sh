#!/bin/bash

set -e

rm -f thesis-sources.zip full.zip full-src-password.txt || true

tmp="$(mktemp -d)"
echo "tmp dir: $tmp"
trap "rm -rf '$tmp'" EXIT

PASS=123

function getGitFiles {
	CUR="$(pwd)"
	CURA="$(readlink -f -- "$CUR")"
	for i in $(find . -name '.git')
	do
		base="$(dirname -- "$i")"
		cd "$base"
		ANS="$(git ls-tree "$(git branch --show-current)" --full-tree --name-only -r)"
		cd "$CUR"
		for file in $ANS
		do
			echo "$base/$file"
		done
	done
	cd "$CUR"
	find data/build
}

echo "creating full zip"
getGitFiles | grep -vP '(presentation|eng)/' | sort | xargs zip --password "$PASS" full.zip

echo "archive password: $PASS" >> "full-src-password.txt"

FILES=$(cat << EOF
full-src-password.txt
ru/bachelor-thesis.tex
res
full.zip
EOF
)

function foo {
	for i in $1
	do
		find "$i"
	done
}

FILES=$(foo "$FILES" | sort)


echo "creating needed zip"

echo "$FILES" | xargs zip thesis-sources.zip

rm -f full.zip full-src-password.txt || true
