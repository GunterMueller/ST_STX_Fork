#
# Common definition for i686 arch
#

CPU_INTERN_H = cpu_x86_64.h
DEFS += -D__x86_64__
CCCONFOPT = -m64 -fPIC
