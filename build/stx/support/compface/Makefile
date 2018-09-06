#
#  Compface - 48x48x1 image compression and decompression
#
#  Copyright (c) James Ashton - Sydney University - June 1990.
#
#  Written 11th November 1989.
#
#  Permission is given to distribute these sources, as long as the
#  copyright messages are not removed, and no monies are exchanged. 
#
#  No responsibility is taken for any errors on inaccuracies inherent
#  either to the comments or the code of this program, but if reported
#  to me, then an attempt will be made to fix them.

# BINDIR, LIBDIR, and MANDIR are expected to be overridden by the
# calling Makefile

BINDIR		= /usr/local/bin
LIBDIR		= /usr/local/lib
MANDIR		= /usr/manl
MANDIR		= /usr/local/man

NAME		= compface
UNNAME		= uncompface
EXECUTABLE	= $(BINDIR)/$(NAME)
UNEXECUTABLE	= $(BINDIR)/$(UNNAME)
LIBNAME		= lib$(NAME).a
LIBRARY		= $(LIBDIR)/$(LIBNAME)
MAN1DIR		= $(MANDIR)/man1
MAN3DIR		= $(MANDIR)/man3
OBJECTS		= compface.o arith.o file.o compress.o gen.o
SOURCES		= compface.c arith.c file.c compress.c gen.c main.c
HDRS		= compface.h data.h
OTHERS		= README $(NAME).1 $(NAME).3 Makefile

CFLAGS		= -g $(DEFINES)

$(NAME) :	main.o $(LIBNAME)
		cc $(CFLAGS) -o $(NAME) main.o $(LIBNAME)
		rm -f $(UNNAME)
		ln $(NAME) $(UNNAME)

$(LIBNAME) :	$(OBJECTS)
		ar rc $(LIBNAME) $(OBJECTS)
		-ranlib $(LIBNAME)

lint :
		lint -abchx $(SOURCES)

clean :
		rm -f *.o

clobber :
		rm -f *.o *.a *.sh core a.out $(NAME) $(UNNAME)

install :	$(NAME) $(LIBNAME)
		-cp $(NAME) $(EXECUTABLE)
		strip $(EXECUTABLE)
		rm -f $(UNEXECUTABLE)
		ln $(EXECUTABLE) $(UNEXECUTABLE)
		-cp $(NAME).1 $(MAN1DIR)
		rm -f $(MAN1DIR)/$(UNNAME).1
		-ln $(MAN1DIR)/$(NAME).1 $(MAN1DIR)/$(UNNAME).1
		-cp $(LIBNAME) $(LIBRARY)
		-cp $(NAME).3 $(MAN3DIR)
		rm -f $(MAN3DIR)/$(UNNAME).3
		-ln $(MAN3DIR)/$(NAME).3 $(MAN3DIR)/$(UNNAME).3

shar :
		shar.script $(OTHERS) $(HDRS) $(SOURCES) > $(NAME).sh
		compress $(NAME).sh

arith.o:	arith.c compface.h data.h
compface.o:	compface.c compface.h data.h
compress.o:	compress.c compface.h data.h
file.o:		file.c compface.h data.h
gen.o:		gen.c compface.h data.h
main.o:		main.c compface.h data.h
