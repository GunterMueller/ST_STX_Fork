TOP=../../../..
CC=gcc
CPP=g++
CFLAGS=$(OPT)
CPPGLAGS=$(CFLAGS)


INCLUDE=-I$(TOP)/include

XERCESC4STX_OBJS=\
	StxCPPUtils.o \
	StxXercesInputStream.o \
	StxXercesInputSource.o \
	StxXercesHandler.o \
	StxXercesUtils.o \

default: all

all: support

support: $(XERCESC4STX_OBJS)
#	$(CPP) -c -o support.o $^

StxCPPUtils.o: StxCPPUtils.c StxCPPUtils.c
	$(CC) $(CFLAGS) $(INCLUDE) -c $<

%.o: %.cpp %.hpp
	$(CPP) $(CFLAGS) $(INCLUDE) -c $<

clean:
	rm -f *~ *.o

