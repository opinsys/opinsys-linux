#!/bin/sh

set -eu

dist=${1:-quantal}
dir=${2:-${dist}-chroot}
debootstrap \
    --arch=i386 \
    --components='main,restricted,universe,multiverse' \
    --include='kernel-wedge,kernel-package,bison,flex,dialog,libncurses5-dev,bc' \
    "${dist}" "${dir}"
chroot "${dir}" locale-gen "${LANG}"


cat <<EOF >"${dir}"/usr/local/sbin
CONCURRENCY_LEVEL=6 make-kpkg --initrd --overlay-dir=/tmp/kernel-package --revision=
EOF


#cp -r "${dir}"/usr/share/kernel-package "${dir}"/tmp/"${dist}"-kernel-package
#cp /usr/share/opinsys-dev-tools/kernel
