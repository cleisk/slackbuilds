  
SB_PATCHDIR=${CWD}/patches

zcat ${SB_PATCHDIR}/libgpg-error-1.7-multilib.patch.gz | patch -p0 -E --backup --verbose || exit 1