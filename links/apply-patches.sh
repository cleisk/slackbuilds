
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p1 -E --backup -z .ssl-verify --verbose -i ${SB_PATCHDIR}/0001-Abort-connection-when-SSL-verification-fails.patch

set +e +o pipefail
