
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-cmake_minimum_required.patch
## Most patches are from Fedora
zcat ${SB_PATCHDIR}/kdebase-runtime-4.1.x-searchproviders-shortcuts.patch.gz | patch -p1 -E --backup --verbose
# support kdesud -Wl,-z,relro,-z,now linker flags
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-kdesud_relro.patch
zcat ${SB_PATCHDIR}/kdebase-runtime-4.3.1-manpath.patch.gz | patch -p1 -E --backup --verbose
# add OnlyShowIn=KDE  to Desktop/Home.desktop (like trash.desktop)
zcat ${SB_PATCHDIR}/kdebase-runtime-4.3.3-home_onlyshowin_kde.patch.gz | patch -p1 -E --backup --verbose

# Launch compiz via compiz-manager so we get window decorations and
# other such decadent luxuries (AdamW 2011/01)
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/kdebase-runtime-4.5.95-compiz.patch
# disable making files read only when moving them into trash
# (Upstream wouldn't accept this)
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-4.10.4-trash-readonly.patch
# Fix FTBFS
# workaround missing dependency on glib2 in NetworkManager.pc
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-15.08.0-fix-build.patch

# tirpc support
#patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/kdebase-runtime-4.6.4-tirpc.patch

## upstreamable patches

## upstream patches

set +e +o pipefail
