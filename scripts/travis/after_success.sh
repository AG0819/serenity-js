#!/bin/bash
set -e

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo "Pull requests are not released to NPM."
  exit 0
fi

if [[ $TRAVIS_BRANCH != 'master' ]]; then
  echo "Builds from a branch are not released to NPM"
  exit 0
fi

if [[ $TRAVIS_BRANCH == 'master' ]]; then
  npm run semantic-release

  echo "[DEBUG] NPM DEBUG"
  cat /home/travis/build/jan-molak/serenity-js/npm-debug.log

  echo "[DEBUG] CHANGELOG"
  find packages -maxdepth 2 -name 'CHANGELOG.md' -print0 | xargs -0 -I % sh -c 'echo %; cat %'

  cp packages/serenity-js/CHANGELOG.md book/_changelog/serenity-js.md

  npm run coverage:publish
fi
