#!/bin/bash

VERSION=0.0.0

usage () {
  echo "npm-publish [-hVI]"
  echo
  echo "Options:"
  echo "  -h|--help             Print this help dialogue and exit"
  echo "  -V|--version          Print the current version and exit"
}

npm-publish () {
  for opt in "${@}"; do
    case "$opt" in
      -h|--help)
        usage
        return 0
        ;;
      -V|--version)
        echo "$VERSION"
        return 0
        ;;
    esac
  done

  LATEST_VERSION=`npm v ${PACKAGE_NAME} version 2>/dev/null || exit 0`

  if [[ "$LATEST_VERSION" = "$NEW_VERSION" ]]; then
    echo "${NEW_VERSION} exists. It was skip publishing."
  else
    npm publish
    TAG=v${NEW_VERSION}
    git tag $TAG
    git push origin $TAG
  fi
}

if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f npm-publish
else
  npm-publish "${@}"
  exit $?
fi
