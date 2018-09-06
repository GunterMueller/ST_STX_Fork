#	@(#)Makefile	8.9 (Berkeley) 7/14/94

prefix = /root/usr
libdir = ${prefix}/lib
includedir = ${prefix}/include

INSTALL = install -c
LN	= ln -s

LIBNAME		= libdb
MAJ_VERSION 	= 1
MIN_VERSION 	= 85
TINY_VERSION 	= 4
VERSION 	= ${MAJ_VERSION}.${MIN_VERSION}.${TINY_VERSION}

LIBDB	= ${LIBNAME}.a
SHLIBDB	= ${LIBNAME}.so.${VERSION}
SONAME	= ${LIBNAME}.so.${MAJ_VERSION}

OBJ1=	hash.o hash_bigkey.o hash_buf.o \
	hash_func.o hash_log2.o hash_page.o \
	hsearch.o ndbm.o
OBJ2=	bt_close.o bt_conv.o bt_debug.o \
	bt_delete.o bt_get.o bt_open.o \
	bt_overflow.o bt_page.o bt_put.o \
	bt_search.o bt_seq.o bt_split.o bt_utils.o
OBJ3=	db.o
OBJ4=	mpool.o
OBJ5=	rec_close.o rec_delete.o rec_get.o \
	rec_open.o rec_put.o rec_search.o \
	rec_seq.o rec_utils.o
MISC=	snprintf.o

OBJS=	${OBJ1} ${OBJ2} ${OBJ3} ${OBJ4} ${OBJ5} ${MISC}

all: ${LIBDB} ${SHLIBDB}

${LIBDB}: ${OBJS}
	rm -f $@
	ar cq $@ static/*.o
	ranlib $@

${SHLIBDB}: ${OBJS}
	rm -f $@
	gcc -shared -Wl,-soname,${SONAME} shared/*.o -o $@

install:
	-mkdir ${libdir}
	-mkdir ${includedir}
	${INSTALL} -m 644 ${LIBDB} ${libdir}/${LIBDB}
	${INSTALL} -m 755 ${SHLIBDB} ${libdir}/${SHLIBDB}
	${LN} ${libdir}/${SHLIBDB} ${libdir}/${SONAME}
	${LN} ${libdir}/${SHLIBDB} ${libdir}/${LIBNAME}.so
	${INSTALL} -m 644 include/mpool.h ${includedir}/mpool.h
	${INSTALL} -m 644 include/db.h ${includedir}/db.h
	
clean:
	rm -f ${LIBDB} ${SHLIBDB}
	rm -f static/* shared/*

OORG=	-O6 -m486 -fomit-frame-pointer
CL=	${CC} -c -D__DBINTERFACE_PRIVATE ${OORG} -I. -Iinclude
CS=	${CC} -fPIC -c -D__DBINTERFACE_PRIVATE ${OORG} -I. -Iinclude

hash.o: ../../hash/hash.c
	${CL} -I../../hash ../../hash/hash.c -o static/$@
	${CS} -I../../hash ../../hash/hash.c -o shared/$@
	
hash_bigkey.o: ../../hash/hash_bigkey.c
	${CL} -I../../hash ../../hash/hash_bigkey.c -o static/$@
	${CS} -I../../hash ../../hash/hash_bigkey.c -o shared/$@

hash_buf.o: ../../hash/hash_buf.c
	${CL} -I../../hash ../../hash/hash_buf.c -o static/$@
	${CS} -I../../hash ../../hash/hash_buf.c -o shared/$@

hash_func.o: ../../hash/hash_func.c
	${CL} -I../../hash ../../hash/hash_func.c -o static/$@
	${CS} -I../../hash ../../hash/hash_func.c -o shared/$@

hash_log2.o: ../../hash/hash_log2.c
	${CL} -I../../hash ../../hash/hash_log2.c -o static/$@
	${CS} -I../../hash ../../hash/hash_log2.c -o shared/$@

hash_page.o: ../../hash/hash_page.c
	${CL} -I../../hash ../../hash/hash_page.c -o static/$@
	${CS} -I../../hash ../../hash/hash_page.c -o shared/$@

hsearch.o: ../../hash/hsearch.c
	${CL} -I../../hash ../../hash/hsearch.c -o static/$@
	${CS} -I../../hash ../../hash/hsearch.c -o shared/$@

ndbm.o: ../../hash/ndbm.c
	${CL} -I../../hash ../../hash/ndbm.c -o static/$@
	${CS} -I../../hash ../../hash/ndbm.c -o shared/$@

bt_close.o: ../../btree/bt_close.c
	${CL} -I../../btree ../../btree/bt_close.c -o static/$@
	${CS} -I../../btree ../../btree/bt_close.c -o shared/$@

bt_conv.o: ../../btree/bt_conv.c
	${CL} -I../../btree ../../btree/bt_conv.c -o static/$@
	${CS} -I../../btree ../../btree/bt_conv.c -o shared/$@

bt_debug.o: ../../btree/bt_debug.c
	${CL} -I../../btree ../../btree/bt_debug.c -o static/$@
	${CS} -I../../btree ../../btree/bt_debug.c -o shared/$@

bt_delete.o: ../../btree/bt_delete.c
	${CL} -I../../btree ../../btree/bt_delete.c -o static/$@
	${CS} -I../../btree ../../btree/bt_delete.c -o shared/$@

bt_get.o: ../../btree/bt_get.c
	${CL} -I../../btree ../../btree/bt_get.c -o static/$@
	${CS} -I../../btree ../../btree/bt_get.c -o shared/$@

bt_open.o: ../../btree/bt_open.c
	${CL} -I../../btree ../../btree/bt_open.c -o static/$@
	${CS} -I../../btree ../../btree/bt_open.c -o shared/$@

bt_overflow.o: ../../btree/bt_overflow.c
	${CL} -I../../btree ../../btree/bt_overflow.c -o static/$@
	${CS} -I../../btree ../../btree/bt_overflow.c -o shared/$@

bt_page.o: ../../btree/bt_page.c
	${CL} -I../../btree ../../btree/bt_page.c -o static/$@
	${CS} -I../../btree ../../btree/bt_page.c -o shared/$@

bt_put.o: ../../btree/bt_put.c
	${CL} -I../../btree ../../btree/bt_put.c -o static/$@
	${CS} -I../../btree ../../btree/bt_put.c -o shared/$@

bt_search.o: ../../btree/bt_search.c
	${CL} -I../../btree ../../btree/bt_search.c -o static/$@
	${CS} -I../../btree ../../btree/bt_search.c -o shared/$@

bt_seq.o: ../../btree/bt_seq.c
	${CL} -I../../btree ../../btree/bt_seq.c -o static/$@
	${CS} -I../../btree ../../btree/bt_seq.c -o shared/$@

bt_split.o: ../../btree/bt_split.c
	${CL} -I../../btree ../../btree/bt_split.c -o static/$@
	${CS} -I../../btree ../../btree/bt_split.c -o shared/$@

bt_stack.o: ../../btree/bt_stack.c
	${CL} -I../../btree ../../btree/bt_stack.c -o static/$@
	${CS} -I../../btree ../../btree/bt_stack.c -o shared/$@

bt_utils.o: ../../btree/bt_utils.c
	${CL} -I../../btree ../../btree/bt_utils.c -o static/$@
	${CS} -I../../btree ../../btree/bt_utils.c -o shared/$@

db.o: ../../db/db.c
	${CL} ../../db/db.c -o static/$@
	${CS} ../../db/db.c -o shared/$@

mpool.o: ../../mpool/mpool.c
	${CL} -I../../mpool ../../mpool/mpool.c -o static/$@
	${CS} -I../../mpool ../../mpool/mpool.c -o shared/$@

rec_close.o: ../../recno/rec_close.c
	${CL} -I../../recno ../../recno/rec_close.c -o static/$@
	${CS} -I../../recno ../../recno/rec_close.c -o shared/$@

rec_delete.o: ../../recno/rec_delete.c
	${CL} -I../../recno ../../recno/rec_delete.c -o static/$@
	${CS} -I../../recno ../../recno/rec_delete.c -o shared/$@

rec_get.o: ../../recno/rec_get.c
	${CL} -I../../recno ../../recno/rec_get.c -o static/$@
	${CS} -I../../recno ../../recno/rec_get.c -o shared/$@

rec_open.o: ../../recno/rec_open.c
	${CL} -I../../recno ../../recno/rec_open.c -o static/$@
	${CS} -I../../recno ../../recno/rec_open.c -o shared/$@

rec_put.o: ../../recno/rec_put.c
	${CL} -I../../recno ../../recno/rec_put.c -o static/$@
	${CS} -I../../recno ../../recno/rec_put.c -o shared/$@

rec_search.o: ../../recno/rec_search.c
	${CL} -I../../recno ../../recno/rec_search.c -o static/$@
	${CS} -I../../recno ../../recno/rec_search.c -o shared/$@

rec_seq.o: ../../recno/rec_seq.c
	${CL} -I../../recno ../../recno/rec_seq.c -o static/$@
	${CS} -I../../recno ../../recno/rec_seq.c -o shared/$@

rec_utils.o: ../../recno/rec_utils.c
	${CL} -I../../recno ../../recno/rec_utils.c -o static/$@
	${CS} -I../../recno ../../recno/rec_utils.c -o shared/$@

memmove.o:
	${CC} -DMEMMOVE -c -O -I. -Iinclude clib/memmove.c -o static/$@
	${CC} -fPIC -DMEMMOVE -c -O -I. -Iinclude clib/memmove.c -o shared/$@
mktemp.o:
	${CC} -c -O -I. -Iinclude clib/mktemp.c -o static/$@
	${CC} -fPIC -c -O -I. -Iinclude clib/mktemp.c -o shared$@

snprintf.o:
	${CC} -c -O -I. -Iinclude clib/snprintf.c -o static/$@
	${CC} -fPIC -c -O -I. -Iinclude clib/snprintf.c -o shared/$@
