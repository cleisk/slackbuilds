
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/libusb-documentation.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/libusb-error-access-log-message.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/libusb-config-multilib.patch

set +e +o pipefail
