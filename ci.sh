#!/bin/sh

set -eux

sudo apt-get update
sudo apt-get install -y --force-yes kernel-wedge kernel-package bison flex dialog libncurses5-dev bc aptirepo-upload git

version=$(sed -r -n 's/^VERSION = //p' Makefile)
patchlevel=$(sed -r -n 's/^PATCHLEVEL = //p' Makefile)
sublevel=$(sed -r -n 's/^SUBLEVEL = //p' Makefile)
extraversion=$(sed -r -n 's/^EXTRAVERSION = //p' Makefile)

upstream_version="${version}.${patchlevel}.${sublevel}${extraversion}"
debian_revision="${BUILD_NUMBER}~master.$(git rev-parse HEAD)"

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

CONCURRENCLY_LEVEL=4 make-kpkg --initrd --overlay-dir=/tmp/kernel-package --revision="${debian_revision}" kernel_image kernel_headers

aptirepo-upload -r "${APTIREPO_REMOTE}" -b "git-$(echo "$GIT_BRANCH" | cut -d / -f 2)" "../linux-image-${upstream_version}_${debian_revision}_${arch}.deb"
aptirepo-upload -r "${APTIREPO_REMOTE}" -b "git-$(echo "$GIT_BRANCH" | cut -d / -f 2)" "../linux-headers-${upstream_version}_${debian_revision}_${arch}.deb"
