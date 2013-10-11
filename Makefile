ifeq ($(NODEMO),)
TARGET = demo.bin
TARGET_OBJS = test-romfs.o
endif

LIBDEPS = FreeRTOS/libFreeRTOS.a arch/libarch.a os/libos.a libc/libc.a libm/libm.a acorn/libacorn.a lwip/liblwip.a
LIBS = -Wl,--start-group $(LIBDEPS) -Wl,--end-group

export ROOTDIR = $(CURDIR)

include common.mk

all: tools libs $(TARGET)

clean: clean-generic
	$(Q)$(MAKE) $(MAKE_OPTS) -C FreeRTOS clean
	$(Q)$(MAKE) $(MAKE_OPTS) -C arch clean
	$(Q)$(MAKE) $(MAKE_OPTS) -C os clean
	$(Q)$(MAKE) $(MAKE_OPTS) -C libc clean
	$(Q)$(MAKE) $(MAKE_OPTS) -C libm clean
	$(Q)$(MAKE) $(MAKE_OPTS) -C acorn clean
	$(Q)$(MAKE) $(MAKE_OPTS) -C lwip clean
	$(Q)$(MAKE) $(MAKE_OPTS) -C tools clean
	$(Q)rm -f test-romfs.bin

.PHONY: libs FreeRTOS arch os libc libm acorn lwip tools deps

FreeRTOS/libFreeRTOS.a: FreeRTOS
arch/libarch.a: arch
os/libos.a: os
libc/libc.a: libc
libm/libm.a: libm
acorn/libacorn.a: acorn
lwip/liblwip.a: lwip

libs: FreeRTOS arch os libc libm acorn lwip

FreeRTOS:
	$(E) "[MAKE]   Entering FreeRTOS"
	$(Q)$(MAKE) $(MAKE_OPTS) -C FreeRTOS

arch:
	$(E) "[MAKE]   Entering arch"
	$(Q)$(MAKE) $(MAKE_OPTS) -C arch

os:
	$(E) "[MAKE]   Entering os"
	$(Q)$(MAKE) $(MAKE_OPTS) -C os

libc:
	$(E) "[MAKE]   Entering libc"
	$(Q)$(MAKE) $(MAKE_OPTS) -C libc

libm:
	$(E) "[MAKE]   Entering libm"
	$(Q)$(MAKE) $(MAKE_OPTS) -C libm

acorn:
	$(E) "[MAKE]   Entering acorn"
	$(Q)$(MAKE) $(MAKE_OPTS) -C acorn

lwip:
	$(E) "[MAKE]   Entering lwip"
	$(Q)$(MAKE) $(MAKE_OPTS) -C lwip

tools:
	$(E) "[MAKE]   Entering tools"
	$(Q)$(MAKE) $(MAKE_OPTS) -C tools

test-romfs.o:
	$(E) "[ROMFS]  Building test romfs"
	$(Q) tools/mkromfs -d test-romfs test-romfs.bin
	$(Q) $(TARGET_OBJCOPY_BIN) --prefix-sections '.romfs' test-romfs.bin test-romfs.o
	$(Q)$(MAKE) $(MAKE_OPTS) -C tools

deps: ldeps
	$(E) "[DEPS]   Creating dependency tree for FreeRTOS"
	$(Q)$(MAKE) $(MAKE_OPTS) -C FreeRTOS ldeps
	$(E) "[DEPS]   Creating dependency tree for arch"
	$(Q)$(MAKE) $(MAKE_OPTS) -C arch ldeps
	$(E) "[DEPS]   Creating dependency tree for os"
	$(Q)$(MAKE) $(MAKE_OPTS) -C os ldeps
	$(E) "[DEPS]   Creating dependency tree for libc"
	$(Q)$(MAKE) $(MAKE_OPTS) -C libc ldeps
	$(E) "[DEPS]   Creating dependency tree for libm"
	$(Q)$(MAKE) $(MAKE_OPTS) -C libm ldeps
	$(E) "[DEPS]   Creating dependency tree for acorn"
	$(Q)$(MAKE) $(MAKE_OPTS) -C acorn ldeps
	$(E) "[DEPS]   Creating dependency tree for lwip"
	$(Q)$(MAKE) $(MAKE_OPTS) -C lwip ldeps

include arch/config.mk
include FreeRTOS/config.mk
include os/config.mk
include libc/config.mk
include libm/config.mk
include lwip/config.mk
include acorn/config.mk
include target-rules.mk
