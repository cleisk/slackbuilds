
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
### Fedora
# patch making libcurl multilib ready
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/0101-curl-7.32.0-multilib.patch
# prevent configure script from discarding -g in CFLAGS
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/0102-curl-7.36.0-debug.patch
# use localhost6 instead of ip6-localhost in the curl test-suite
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/0104-curl-7.19.7-localhost6.patch

# work around valgrind bug (#678518)
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/0107-curl-7.21.4-libidn-valgrind.patch

# Set to YES if autogen is needed
SB_AUTOGEN=NO

set +e +o pipefail
