SRC= stubs.c linear_8.c linear_15.c linear_16.c linear_24.c linear_32.c

OBJ:=$(patsubst %.c,%.so,$(SRC))

CFLAGS= -O3 -m486 -fomit-frame-pointer -Wall -I../../. -I../. 

all: $(OBJ)

$(OBJ): %.so: %.c
	cc $(CFLAGS) -o $@ -shared -Wl,-soname,$@ $< 
clean:
	rm *.so

LIBS= -lggi -lGL 

CFLAGS= -O2 -Wall -fomit-frame-pointer -m486

all: asc-view gears gears2

asc-view: asc-view.o
	cc -o $@ $< $(LIBS)

gears: gears.o
	cc -o $@ $< $(LIBS)

gears2: gears2.o
	cc -o $@ $< $(LIBS)

.c.o:
	cc -c $< $(CFLAGS)

clean:
	rm *.o asc-view gears gears2

GLUT_MAJOR=3
GLUT_MINOR=7

VPATH=RCS

INCDIR=../include
LIBDIR=../lib

GLUTDIR=../src-glut

SRC=	ggiglut.c \
	$(GLUTDIR)/glut_8x13.c \
	$(GLUTDIR)/glut_9x15.c \
	$(GLUTDIR)/glut_bitmap.c \
	$(GLUTDIR)/glut_bwidth.c \
	$(GLUTDIR)/glut_ext.c \
	$(GLUTDIR)/glut_hel10.c \
	$(GLUTDIR)/glut_hel12.c \
	$(GLUTDIR)/glut_hel18.c \
	$(GLUTDIR)/glut_mroman.c \
	$(GLUTDIR)/glut_roman.c \
	$(GLUTDIR)/glut_shapes.c \
	$(GLUTDIR)/glut_stroke.c \
	$(GLUTDIR)/glut_swidth.c \
	$(GLUTDIR)/glut_teapot.c \
	$(GLUTDIR)/glut_tr10.c \
	$(GLUTDIR)/glut_tr24.c \
	$(GLUTDIR)/glut_util.c 

OBJ=$(patsubst %.c,%.o,$(SRC))

default:
	@echo "Specify a target configuration"

clean:
	-rm *.o *~

targets: $(LIBDIR)/$(GLUT_LIB)

 
$(LIBDIR)/$(GLUT_LIB): $(OBJ) 
	$(MAKELIB) $(GLUT_LIB) $(GLUT_MAJOR) $(GLUT_MINOR) $(OBJ) 
	mv $(GLUT_LIB)* $(LIBDIR)

include ../Make-config

include depend

dep: $(SRC)
	makedepend -fdepend -Y -I../include $(SRC)
	
