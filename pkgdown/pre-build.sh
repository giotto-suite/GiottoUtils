#!/usr/bin/env bash
# Repo-specific preparation, run by the shared pkgdown workflow
# (giotto-suite/.github) in the package checkout, after this branch's
# _pkgdown.yml and pkgdown/ have been laid over it.
#
# Vignettes ship in the package, so the site documents the ones at the ref
# being built. The shared workflow replaces the package's vignettes/ with this
# branch's (empty here); put them back from the checkout. Both modes.
set -euo pipefail

git checkout HEAD -- vignettes/
echo "pre-build: vignettes from the documented ref ($(ls vignettes/*.Rmd 2>/dev/null | wc -l | tr -d ' ') Rmd)"
