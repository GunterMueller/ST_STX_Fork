#
# Common definition for i686 arch
#
CPU_INTERN_H=cpu_i386.h
DEFS += -D__amd64_mode32__
CCCONFOPT = -m32

# When performing partial linking, we have to specify `-m elf_i386` in case
# we're compiling 32bit version on otherwise 64bit system - by far the most
# common case these days. If the system is truly 32bit, `-m elf_i386` won't
# hatm.
CLASSLIB_LD=ld -m elf_i386
