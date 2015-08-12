ccflags-y += -D__CHECK_ENDIAN__

obj-$(CONFIG_MT7662U)	+= mt7662u.o

mt7662u-objs	= \
	usb.o init.o main.o mcu.o trace.o dma.o core.o eeprom.o phy.o \
	mac.o util.o debugfs.o tx.o

CFLAGS_trace.o := -I$(src)
