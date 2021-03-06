#!/bin/bash

set -e

module=$(basename $0 -snapshot.sh)
snaproot="svn://svn.mplayerhq.hu/${module}/trunk"
ffsnaproot="git://git.videolan.org/ffmpeg.git"

tmp=$(mktemp -d)

trap cleanup EXIT
cleanup() {
  set +e
  [ -z "${tmp}" -o ! -d "${tmp}" ] || rm -rf "${tmp}"
}

unset CDPATH
unset SNAP_COOPTS
pwd=$(pwd)
snap=${snap:-$(date +%Y%m%d)}
snapbranch=${snapbranch:-master}
gittree=${gittree:-${snapbranch}}

[ "${snap}" = "$(date +%Y%m%d)" ] || SNAP_COOPTS="-r {$snap}"
[ "${snap}" = "$(date +%Y%m%d)" ] && FFSNAP_COOPTS="--depth 1"
[ "${snapbranch}" = "master" ] || snapbranch="origin/${snapbranch}"

pushd "${tmp}"
  svn export ${SNAP_COOPTS} ${snaproot} ${module}-${snap}
  svn co --depth=files --force ${SNAP_COOPTS} ${snaproot} ${module}-${snap}
  pushd ${module}-${snap}
    # Force revision number
    SVNREV="$(LC_ALL=C svn info 2> /dev/null | grep Revision | cut -d' ' -f2)"
    sed -i -e "/^svn_revision=/s|=.*|=${SVNREV}|g" ./version.sh
    find . -type d -name .svn -print0 | xargs -0r rm -rf
    sed -i -e '/^\.PHONY: version\.h$/d' Makefile

    ( git clone ${FFSNAP_COOPTS} ${ffsnaproot} ffmpeg
      cd ffmpeg
      if [ "${snap}" != "$(date +%Y%m%d)" ] ; then
        gitdate="$(echo -n ${snap} | head -c -4)-$(echo -n ${snap} | tail -c -4|head -c -2)-$(echo -n ${snap} | tail -c -2)"
        git checkout $(git rev-list -n 1 --before="${gitdate}" ${snapbranch})
        gittree=$(git reflog | grep 'HEAD@{0}' | awk '{print $1}')
      fi
      if [ "${snapbranch}" != "master" ] && [ -z "${snaptag}" ];then
        git checkout -q ${gittree}
      fi
      if [ -n "${snaptag}" ] ;then
        if git tag | grep -q ${snaptag} ;then
          git checkout ${snaptag}
        else
          echo "Tag not found! Printing available."
          git tag
          exit 1
        fi
      fi
      echo "git-$(git describe --always 2> /dev/null)" > VERSION
      find . -type d -name .git -print0 | xargs -0r rm -rf
      rm -f .gitignore config.git-hash
    )

  popd
  tar -Jcf "${pwd}"/${module}-${snap}.tar.xz ${module}-${snap}
popd >/dev/null
