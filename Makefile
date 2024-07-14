OUTPUT := .output
CLANG ?= clang
BPFTOOL ?= bpftool
LIBBPF_SRC := $(abspath ../libbpf/src)
LIBBPF_OBJ := $(abspath $(OUTPUT)/libbpf.a)
INCLUDES := -I/usr/include/x86_64-linux-gnu/
CFLAGS := -g -Wall -O0
ARCH := $(shell uname -m | sed 's/x86_64/x86/')

BPFSRC := $(wildcard *.c)
BPFOBJ := $(BPFSRC: .c=.o)

.PHONY: all

%.o: %.c
	$(CLANG) -g -O0 -target bpf $(INCLUDES) -D__TARGET_ARCH_$(ARCH) -c $(filter %.c,$^) -o $@

