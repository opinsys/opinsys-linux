
build_arch	= i386
header_arch	= x86_64
defconfig	= defconfig
flavours	= lowlatency
build_image	= bzImage
kernel_file	= arch/$(build_arch)/boot/bzImage
install_file	= vmlinuz
loader		= grub

no_dumpfile    = true
skipdbg        = true
skipabi        = true
skipmodule     = true
do_doc_package = false
do_source_package       = false
do_full_source          = true
do_common_headers_indep = true
do_libc_dev_package     = false
do_tools                = false
disable_d_i             = true
