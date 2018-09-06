ifndef BUILD_TARGET
$(error "BUILD_TARGET not defined")
endif

CC=
ifeq ($(OS), Windows_NT)
OS=windows32
else
OS=$(shell uname -s)
endif
CFLAGS=-ggdb3 -O0 -W -Wall -Wno-unused-parameter -I.
CFLAGS_BIN=$(CFLAGS)
CFLAGS_LIB=$(CFLAGS)

RM    = rm -f
RM_RF = rm -rf
MD = mkdir -p
GREP = grep

ifeq ($(OS), windows32)
EXE = .exe
DLL = .dll
LIB = .a
ifeq ($(CC),)
CC = gcc
endif
else
EXE =
DLL = .so
LIB =.so
CC = gcc

endif

SOURCES = $(wildcard *.c)
SOURCES_BIN = $(shell $(GREP) -l 'main.*argc.*argv' *.c)

BINARIES   = $(patsubst %.c,$(BUILD_TARGET)/%$(EXE),$(SOURCES_BIN))


default: $(BUILD_TARGET) $(BINARIES)

config:
	echo "BUILD_TARGET=$(BUILD_TARGET)"
	echo "CC=$(CC)"
	echo "OS=$(OS)"
	echo "BINARIES=$(BINARIES)"

$(BUILD_TARGET):
	$(MD) $(BUILD_TARGET)

$(BUILD_TARGET)/%.o: %.c
	$(CC) \
		$(shell if grep CFLAGS $< > /dev/null; then grep CFLAGS $< | sed -e 's/^.*CFLAGS=//g'; else echo "$(CFLAGS)"; fi) \
	 	-o $@ -c $<

$(BUILD_TARGET)/%$(EXE): %.c
	$(CC) \
		$(shell if grep CFLAGS $< > /dev/null; then grep CFLAGS $< | sed -e 's/^.*CFLAGS=//g'; else echo "$(CFLAGS_BIN)"; fi) \
		-o $@ $<

clean:
	$(RM_RF) $(BUILD_TARGET)

clobber: clean

