hook-before-clean::
	@echo "Debug: hook-before-clean"

	# lowlatency: derive our configuration from that in master ...
	rm -rf $(DEBIAN)/config
	cp -rp $(CURDIR)/debian.master/config $(DEBIAN)/config
	mv $(DEBIAN)/d-i/kernel-versions.in $(DEBIAN)/d-i/kernel-versions.in-keep
	cp -rp $(CURDIR)/debian.master/d-i/* $(DEBIAN)/d-i
	mv $(DEBIAN)/d-i/kernel-versions.in-keep $(DEBIAN)/d-i/kernel-versions.in
	cat $(DEBIAN)/config/i386/config.flavour.generic $(DEBIAN)/config-delta >$(DEBIAN)/config/i386/config.flavour.lowlatency
	cat $(DEBIAN)/config/amd64/config.flavour.generic $(DEBIAN)/config-delta >$(DEBIAN)/config/amd64/config.flavour.lowlatency
