
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
#patch -p1 -E --backup -z .extlibs --verbose -i ${SB_PATCHDIR}/${NAME}-0.5.0-extlibs.patch
patch -p1 -E --backup -z .optflags --verbose -i ${SB_PATCHDIR}/${NAME}-0.6.0-optflags.patch

set +e +o pipefail
