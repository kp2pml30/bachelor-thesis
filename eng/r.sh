#!/bin/bash

set -e

OLD_PWD=$(pwd)
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
pushd "$SCRIPT_DIR" 2> /dev/null
trap 'popd 2> /dev/null' EXIT

PROJ="bachelor-thesis"

function xelat() {
    echo "proj $PROJ $ARGS"
    xelatex -shell-escape -output-directory=build "$ARGS" "\input{$PROJ}"
}

function build() {
    mkdir -p build/res/dot
    rm build/res/data-build 2> /dev/null || true
    cur="$(pwd)"
    cd build/res
    ln -s "$(readlink -f -- "$SCRIPT_DIR/../data/build")" data-build
    cd "$cur"
    for i in ../res/dot/*.dot
    do
        dot -Gfontsize=14 "-obuild/res/dot/$(basename -- "$i").svg" -Tsvg "$i"
    done
    xelat
}

MODE="$1"
shift
ARGS="$@"

case "$MODE" in
clean)
    rm -f {bachelor-thesis,master-thesis,master-thesis-en}.{bib,aux,log,bbl,bcf,blg,run.xml,toc,tct,pdf,out}
    rm -rf build
;;
build)
    build
;;
build-full)
    build
    cd build
    biber "$PROJ"
    # --input-directory build
    cd ..
    xelat
    xelat
;;
*)
    echo "unknown command"
    exit 1
;;
esac
