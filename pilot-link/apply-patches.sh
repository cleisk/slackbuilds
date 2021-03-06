
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
zcat ${SB_PATCHDIR}/${NAME}.serial.group.is.uucp.diff.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/${NAME}-0.12.1-var.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/${NAME}-0.12.5-open.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/${NAME}-0.12.3-clio.patch.gz | patch -p1 --verbose
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-0.12.5-mp.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-0.12.5-redefinePerlsymbols.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-0.12.5-compiler_warnings.patch

set +e +o pipefail
