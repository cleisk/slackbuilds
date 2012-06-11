#!/bin/bash

set -e

module=$(basename $0 -tarball.sh)

tmp=$(mktemp -d)

trap cleanup EXIT
cleanup() {
  set +e
  [ -z "${tmp}" -o ! -d "${tmp}" ] || rm -rf "${tmp}"
}

unset CDPATH

pwd=$(pwd)

[ -d "$(pwd)/${module}" ]
[ -f "$(pwd)/${module}/CMakeLists.txt" ]
version=$(grep FCM_VERSION "$(pwd)/${module}/CMakeLists.txt" | cut -d\" -f2)

pushd "${tmp}"
  mkdir ${module}-${version}
  cp -a "${pwd}/${module}"/* ${module}-${version}/
  rm -rf ${module}-${version}/build
  tar -Jcf "${pwd}"/${module}-${version}.tar.xz ${module}-${version}
popd >/dev/null
