#!/usr/bin/env bash
jupyter-book build --all ./rapaio
touch ./rapaio/_build/html/.nojekyll
rm -r ../rapaio-pages/*
cp -r ./rapaio/_build/html/* ../rapaio-pages
