#!/bin/bash

PROJ="bachelor-thesis"

function xelat() {
    echo "proj $PROJ"
    xelatex -shell-escape -output-directory=build "$PROJ"
}

function build() {
    mkdir -p build/res/dot
    for i in res/dot/*.dot
    do
        dot "-obuild/res/dot/$(basename -- "$i").svg" -Tsvg "$i"
    done
    xelat
}

case "$1" in
clean)
    rm -f {bachelor-thesis,master-thesis,master-thesis-en}.{bib,aux,log,bbl,bcf,blg,run.xml,toc,tct,pdf,out}
    rm -rf build
;;
build)
    build
;;
build-full)
    build
    biber "$PROJ"
    xelat
    xelat
;;
*)
    echo "unknown command"
    exit 1
;;
esac
