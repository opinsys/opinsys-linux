#!/bin/sh

set -eux

sudo apt-get update
sudo apt-get install -y --force-yes kernel-wedge kernel-package bison flex dialog libncurses5-dev bc

version=$(sed -r -n 's/^VERSION = //p' Makefile)
patchlevel=$(sed -r -n 's/^PATCHLEVEL = //p' Makefile)
sublevel=$(sed -r -n 's/^SUBLEVEL = //p' Makefile)
extraversion=$(sed -r -n 's/^EXTRAVERSION = //p' Makefile)

upstream_version="${version}.${patchlevel}.${sublevel}${extraversion}"

debian_revision="${upstream_version}-0+opinsys1"

arch=i386

cp "opinsys/config.${arch}" .config

cp -a -r /usr/share/kernel-package /tmp
cp -a -t /tmp/kernel-package/pkg/image \
    opinsys/preinst \
    opinsys/prerm \
    opinsys/postinst \
    opinsys/postrm
cp -a -t /tmp/kernel-package/pkg/headers \
    opinsys/headers-postinst

CONCURRENCY_LEVEL=4 make-kpkg --initrd --overlay-dir=/tmp/kernel-package --revision="${debian_revision}" kernel_image kernel_headers
