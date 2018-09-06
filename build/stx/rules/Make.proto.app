# This is a demonstration Make.proto for executable (application) building.
#
# your directory should contain:
#
#	Make.proto	
#

# this is the same as described in Make.proto.lib
# read the info there ...

TOP=..
SUBDIRS=

# this states, that we are going to build an executable program here
# and also defines the name of the executable

PROGS      = MyProg

# this defines the class/selector which will be sent by runtime system
# to start the application

STARTUP_CLASS=MyMainClass
STARTUP_SELECTOR="start"

# the default target for make

all::       $(PROGS)

# if there are any local classes, you can define them as:

# OBJS=	    Foo.o Bar.o
# objs::    $(OBJS)

# this defines how the executable is to be built
#
# stdRules already includes a rule to build main.o (from librun/main.c)
# so you dont have to care about that (but it needs STARTUP_CLASS and
# STARTUP_SELECTOR to be defined).
#
# you have to specify which libraries are to be linked to your app:
#
# LIBRARIES=			list of class-libs which are to be statically linked in
# SHARED_CLASSLIBRARIES=	list of class-libs which are shared libs
# EXTRA_OBJS=			individual '.o' files
# EXTRA_CLASSES=		classes found in EXTRA_OBJS

# any install, clean and tar rules as described in Make.proto.lib

# any dependencies as in Make.proto.lib
