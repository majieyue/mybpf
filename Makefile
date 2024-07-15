OUTPUT := .output
CLANG ?= clang
BPFTOOL ?= ./bpftool
LLVM_STRIP ?= llvm-strip
LIBBPF_SRC := $(abspath ../libbpf/src)
LIBBPF_OBJ := $(abspath $(OUTPUT)/libbpf.a)
INCLUDES := -I/usr/include/x86_64-linux-gnu/
CFLAGS := -g -Wall -O0
ARCH := $(shell uname -m | sed 's/x86_64/x86/')

BPFSRC := $(wildcard *.bpf.c)
BPFOBJ := $(patsubst %.bpf.c, %.bpf.o, $(BPFSRC))

.PHONY: all
all: $(BPFOBJ)

%.bpf.o: %.bpf.c
	$(CLANG) -g -O2 -target bpf $(INCLUDES) -D__TARGET_ARCH_$(ARCH) -c $(filter %.bpf.c,$^) -o $@
	$(LLVM_STRIP) -g $@

install:
	$(foreach obj,$(BPFOBJ),$(BPFTOOL) prog load $(obj) /sys/fs/bpf/$(subst .bpf.o,,$(obj)) autoattach;)

uninstall:
	$(foreach obj,$(BPFOBJ),rm -rf /sys/fs/bpf/$(subst .bpf.o,,$(obj));)

clean:
	rm -rf $(BPFOBJ)
	$(foreach obj,$(BPFOBJ),rm -rf /sys/fs/bpf/$(subst .bpf.o,,$(obj));)
