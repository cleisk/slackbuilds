#!/bin/sh
#
# Sun xVM VirtualBox
#
# Copyright (C) 2006-2007 Sun Microsystems, Inc.
#
# This file is part of VirtualBox Open Source Edition (OSE), as
# available from http://www.virtualbox.org. This file is free software;
# you can redistribute it and/or modify it under the terms of the GNU
# General Public License (GPL) as published by the Free Software
# Foundation, in version 2 as it comes in the "COPYING" file of the
# VirtualBox OSE distribution. VirtualBox OSE is distributed in the
# hope that it will be useful, but WITHOUT ANY WARRANTY of any kind.
#
# Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa
# Clara, CA 95054 USA or visit http://www.sun.com if you need
# additional information or have any questions.
#

PATH="/usr/bin:/bin:/usr/sbin:/sbin"
CONFIG="/etc/vbox/vbox.cfg"

if [ ! -r "${CONFIG}" ]; then
  echo "Could not find VirtualBox installation. Please reinstall."
  exit 1
fi

. "${CONFIG}"

# Note: This script must not fail if the module was not successfully installed
#       because the user might not want to run a VM but only change VM params!

if [ "$1" = "shutdown" ]; then
  SHUTDOWN="true"
elif [ ! -e /lib/modules/$(uname -r)/extra/vbox/vboxdrv.ko ]; then
  cat << EOF
WARNING: There is no module available for the current kernel (`uname -r`).
         Please recompile the kernel module, try kmod-vbox package, or SlackBuild.

         You will not be able to start VMs until this problem is fixed.
EOF
elif ! lsmod|grep -q vboxdrv; then
  cat << EOF
WARNING: The vboxdrv kernel module is not loaded.
         Please load the kernel module by:

           sudo modprobe vboxdrv

         You will not be able to start VMs until this problem is fixed.
EOF
elif [ ! -c /dev/vboxdrv ]; then
  cat << EOF
WARNING: The character device /dev/vboxdrv does not exist.
	 Please try to reload the kernel module by:

           sudo rmmod vboxdrv; sleep 2; sudo modprobe vboxdrv

         and if that is not successful, try kmod-vbox package, or SlackBuild.

         You will not be able to start VMs until this problem is fixed.
EOF
elif [ ! -w /dev/vboxdrv ]; then
  if [ "`id | grep vboxusers`" = "" ]; then
    cat << EOF
WARNING: You are not a member of the "vboxusers" group.
	 Please add yourself to this group before starting VirtualBox.

	 You will not be able to start VMs until this problem is fixed.
EOF
  else
    cat << EOF
WARNING: /dev/vboxdrv not writable for some reason.
	 If you recently added the current user to the "vboxusers" group
	 then you have to logout and re-login to take the change effect.

	 You will not be able to start VMs until this problem is fixed.
EOF
  fi
fi

export LD_LIBRARY_PATH="$INSTALL_DIR${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

SERVER_PID=$(ps -U `whoami` | grep VBoxSVC | awk '{ print $1 }')
if [ -z "${SERVER_PID}" ]; then
  # Server not running yet/anymore, cleanup socket path.
  # See IPC_GetDefaultSocketPath()!
  if [ -n "${LOGNAME}" ]; then
    rm -rf /tmp/.vbox-${LOGNAME}-ipc > /dev/null 2>&1
  else
    rm -rf /tmp/.vbox-${USER}-ipc > /dev/null 2>&1
  fi
fi

if [ "${SHUTDOWN}" = "true" ]; then
  if [ -n "${SERVER_PID}" ]; then
    kill -TERM ${SERVER_PID}
    sleep 2
  fi
  exit 0
fi

APP=$(basename $0)
APP=${APP##/*/}
case "$APP" in
  VirtualBox|VBox|virtualbox)
    exec "$INSTALL_DIR/VirtualBox" "$@"
    ;;
  VBoxManage|vboxmanage)
    exec "$INSTALL_DIR/VBoxManage" "$@"
    ;;
  VBoxSDL|vboxsdl)
    exec "$INSTALL_DIR/VBoxSDL" "$@"
    ;;
  VBoxVRDP|VBoxHeadless|vboxheadless)
    exec "$INSTALL_DIR/VBoxHeadless" "$@"
    ;;
  VBoxAutostart|vboxautostart)
    exec "$INSTALL_DIR/VBoxAutostart" "$@"
    ;;
  VBoxBalloonCtrl|vboxballoonctrl)
    exec "$INSTALL_DIR/VBoxBalloonCtrl" "$@"
    ;;
  vboxwebsrv)
    exec "$INSTALL_DIR/vboxwebsrv" "$@"
    ;;
  *)
    echo "Unknown application - $APP"
  ;;
esac
