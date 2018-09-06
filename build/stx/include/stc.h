/*
 * COPYRIGHT (c) 1988 by Claus Gittinger
 * COPYRIGHT (c) 2015-2018 Jan Vrany
 *              All Rights Reserved
 *
 * This software is furnished under a license and may be used
 * only in accordance with the terms of that license and with the
 * inclusion of the above copyright notice.   This software may not
 * be provided or otherwise made available to, or used by, any
 * other person.  No title to or ownership of the software is
 * hereby transferred.
 *
 *
 * $Header$
 */

#ifndef __STC_H__
# define __STC_H__

# if defined(__VMS__)
#  define __FAST_SETJMP /* does not save FP-registers */
# endif

#ifdef solaris2_0
  /* enable large/64 bit files
   * Must be defined before any #include, especially before types.h
   * is included, so that off_t is 64 bits long.
   */
# define _LARGEFILE_SOURCE   1
# define _FILE_OFFSET_BITS   64
#endif /* solaris2_0 */

# include <setjmp.h>
# include "stxNames.h"
# include "stcIntern.h"

#if defined(__osx__)
# include <string.h>
// # include <memory.h>
# include <stdlib.h>
# include <stdio.h>
#endif

/*
 * To get prototype for printf(), needed for console_printf() definition
 */
#include <stdio.h>

#ifdef __MINGW__
# include <string.h>
# include <stdlib.h>
#endif

# if !defined(stx_jmp_buf)
/* to make typedefs below happy in genOffsets and stc compilation */
# define stx_jmp_buf   jmp_buf
#endif

# define POLY_CACHE
# define USE_METHODDICTIONARY

/*
 * Define this to find out about non-matching
 * BEGIN_INTERRUPTIBLE/END_INTERRUPTIBLE
 */

# define DEBUG_IMMEDIATE_INTERRUPTS 1

/*
 * DO NOT CHANGE at all
 *
 * especially the class structures down here are known in many parts
 * of the system (compiler, run-time-system). If you change anything
 * here, you will probably run into trouble ...
 *
 * the compiler will be changed, to check when compiling critical classes
 * for a matching description, thus detecting such changes.
 * - this will be added when everything else runs fine ...
 */

/*
 * this is no easy-to-change define -
 * increasing needs adding corresponding functions/code to
 *   librun/send.c,
 *   librun/interpret.c
 *   librun/errhandler.c
 * and maybe others ...
 */
#define MAX_METHOD_ARGS         15
/*
 * this is easy to change - although, it requires
 * recompilation of some code
 */
#define MAX_METHOD_VAR_ARGS     50

typedef struct __instance *OBJ;
typedef OBJ* (*OBJPTRFUNC)();
typedef OBJ  (*OBJFUNC)();
typedef void (*VOIDFUNC)();
typedef void (*voidFUNC)();
typedef int  (*INTFUNC)();
typedef int  (*intFUNC)();
typedef INT  (*INTLFUNC)();
typedef unsigned INT (*UINTLFUNC)();
typedef void* (*VOIDPTRFUNC)();
typedef void* (*voidPTRFUNC)();
typedef char* (*CHARPTRFUNC)();
typedef char* (*charPTRFUNC)();
typedef float  (*FLOATFUNC)();
typedef float  (*floatFUNC)();
typedef double  (*DOUBLEFUNC)();
typedef double  (*doubleFUNC)();

#define SIGNED /* just to remind us */

#if __POINTER_SIZE__ == 8

# define __int64__ INT
# define __uint64__ unsigned INT
# define HAS_INT64
# define __LO32(ll) ((ll) & 0xFFFFFFFFL)
# define __HI32(ll) ((ll >> 32) & 0xFFFFFFFFL)

#else
/*
 * long integer support
 * definition should match any long-long datatype (if present)
 */
# ifdef __LSBFIRST__

struct __int64_struct {
    unsigned int lo;
    int hi;
};

struct __uint64_struct {
    unsigned int lo;
    unsigned int hi;
};

# else

struct __int64_struct {
    int hi;
    unsigned int lo;
};

struct __uint64_struct {
    unsigned int hi;
    unsigned int lo;
};

# endif

/*
 * could change those to longlong on some systems ...
 */
typedef struct __int64_struct __int64__;
typedef struct __uint64_struct __uint64__;
# define __LO32(ll) (ll.lo)
# define __HI32(ll) (ll.hi)
#endif /* __POINTER_SIZE__ */

#ifdef __VISUALC__
# define DEBUG_IN_IDE
#endif

#ifdef DEBUG_IN_IDE
# define CLASS_OBJ  struct class *
#else
# define CLASS_OBJ  OBJ
#endif

/*
 * arrange so that a single long-store can set space and
 * clear the other flags without a need for shift instructions
 * this saves an instruction and a memory access in the new-code
 * (sigh - fighting for every cycle :-)
 */
# if defined(__MSBFIRST__)

#  define STX_OBJ_FLAGS                 \
	unsigned char   o_age;          \
	unsigned char   o_hashLow;      \
	SIGNED char     o_flags;        \
	unsigned char   o_space;

#  define o_allFlags(o)   (* (unsigned int *) (& (__objPtr(o)->o_age) ) )

# else /* LSB or unknown */

#  define STX_OBJ_FLAGS                 \
	unsigned char   o_space;        \
	SIGNED char     o_flags;        \
	unsigned char   o_age;          \
	unsigned char   o_hashLow;

#  define o_allFlags(o)   (* (unsigned int *) (& (__objPtr(o)->o_space) ) )

# endif

/*
 * the header of every object (except nil and SmallIntegers)
 */
#if __POINTER_SIZE__ == 8

/*
 * define STX_FULL_HEADER allows huge objects (>4gb),
 * but adds 8 byte to every object header.
 * It is not defined, because
 * we (currently) see no need to support huge strings,bytearrays, etc.
 */
# ifdef STX_FULL_HEADER
#  define STX_OBJ_HEADER                \
	CLASS_OBJ       o_class;        \
	unsigned INT    o_size;         \
	STX_OBJ_FLAGS                   \
	unsigned char   o_align1;       \
	unsigned char   o_align2;       \
	unsigned char   o_align3;       \
	unsigned char   o_align4;
# define __ASM_HEADER_SIZE  24
# undef STX_MAX_OBJECT_SIZE         /* no limit (within INT range) */

// already double aligned
# undef __NEED_FLOATARRAY_ALIGN
# undef __NEED_FLOAT_ALIGN
# undef __NEED_DOUBLE_ALIGN
# undef __NEED_LONGLONG_ALIGN

# else  // ! STX_FULL_HEADER - object size is limited to 4GB

#  define STX_OBJ_HEADER                \
	CLASS_OBJ       o_class;        \
	unsigned int    o_size;         \
	STX_OBJ_FLAGS

#  define __ASM_HEADER_SIZE  16
#  define STX_MAX_OBJECT_SIZE        0xFFFFFFFF

// already double aligned
# undef __NEED_FLOATARRAY_ALIGN
# undef __NEED_FLOAT_ALIGN
# undef __NEED_DOUBLE_ALIGN
# undef __NEED_LONGLONG_ALIGN

# endif /* STX_FULL_HEADER */

#else /* not 64bit */

# ifdef __FULL_ALIGN__

#  define STX_OBJ_HEADER                \
	CLASS_OBJ       o_class;        \
	unsigned INT    o_size;         \
	STX_OBJ_FLAGS                   \
	unsigned char   o_align1;       \
	unsigned char   o_align2;       \
	unsigned char   o_align3;       \
	unsigned char   o_align4;

#  define __ASM_HEADER_SIZE  16
  // now already double aligned
#  undef __NEED_FLOATARRAY_ALIGN
#  undef __NEED_FLOAT_ALIGN
#  undef __NEED_DOUBLE_ALIGN
#  undef __NEED_LONGLONG_ALIGN

# else

#  define STX_OBJ_HEADER                \
	CLASS_OBJ       o_class;        \
	unsigned INT    o_size;         \
	STX_OBJ_FLAGS

#  define __ASM_HEADER_SIZE  12

# endif

# undef STX_MAX_OBJECT_SIZE         /* no limit (within INT range) */

#endif /* __POINTER_SIZE__ */

#if defined(__LSBFIRST__) || defined(__MSBFIRST__)
# define o_setAllFlags(o, space) \
	o_allFlags(o) = space;
#else
# define o_setAllFlags(o, space) \
	o_allFlags(o) = 0; __objPtr(o)->o_space = space;
#endif

/*
 * during scavenge, the forward-ptr is stored in the class-field
 */
#define o_FORWARDPTR    o_class

/*
 * o_flags bits
 */
typedef enum {
    F_NONE          = 0,
    F_ISREMEMBERED  = 1,       /* a new-space thing on rem-list */
    F_ISFORWARDED   = 2,       /* a forwarded object (only valid after scavenge) */
    F_IMMUTABLE     = 4,       /* an immutable object (i.e. literal constant) */
    F_ISONLIFOLIST  = 8,       /* a non-lifo-context-referencing-obj already on list */
    F_MARK          = 16,      /* mark bit for background collector */
    F_LOCKED        = 32,      /* the object is locked at its address - never move it */
    F_REFDBYWEAK    = 64,      /* referenced by a weak object (used temporarily) */
    F_NILLED        = 128      /* already nilled (only valid immediately after allocation) */
} stx_obj_flags;

/*
 * o_age mask
 * only 5 bits, since we use the hi-3-bits in age as the hi-3-bits of the hashvalue
 * also the special age NO_TENURE_AGE is used to mark objects, which should not be
 * tenured into oldspace (currently not used).
 *
 * we could additionally use remaining bits in other fields:
 * 8bits are really not needed for the space; could live with 4
 * (but then we have to mask it, thus slowing down things)
 */
#define AGE_MASK        0x1F
#define AGE_MAX         30
#define NO_TENURE_AGE   31
#define __HI_HASH_IN_AGE    0xE0
/* use this macro to access space, to prepare for putting additional hash-bits into it */
#define __GET_SPACE(o)     (o->o_space)
#define __SET_SPACE(o, s)  (o->o_space = (s))
#define __GET_AGE(o)       (o->o_age & AGE_MASK)
#define __SET_AGE(o, a)    (o->o_age = (o->o_age & ~AGE_MASK) | ((a) & AGE_MASK))
#define _GET_AGE(o)       __GET_AGE(o)
#define _SET_AGE(o, a)    __SET_AGE(o,a)
#define __GET_HASH(o)     (o->o_hashLow | ((o->o_age & __HI_HASH_IN_AGE)<<(8-5)))
#define __SET_HASH(o, h)  (o->o_hashLow = (h & 0xFF), o->o_age |= ((h>>(8-5)) & __HI_HASH_IN_AGE))
#define __MAX_HASH__      0x7FF
#define __HASH_SHIFT__    12
#ifdef LATER
# define __MAKE_HASH__(h) ((((h)<<11) | (h))<<8)
#else
# define __MAKE_HASH__(h)  ((h) << __HASH_SHIFT__)
#endif

/*
 * o_space bits
 *
 * notice: DO NEVER CHANGE THIS
 * since for unsigned compare the following must be true
 *
 * MARKEDOLD < OLD < [NEW/SURV] < [MED/MEDSURV] < any+CATCH < STACK
 *
 * only this allows for an easy compare in the STORE macro
 * the store macro must catch stores from any space into
 * any other left in the above list (for the write barrier).
 * The SURV-spaces are actually not needed;
 * leftovers after a scavenge have these as their space.
 * This is checked in the VM (if compiled with -DDEBUG) to detect unforwarded
 * pointers (i.e. for VM-debugging only).
 *
	MARKEDOLDSPACE  0  an marked old space object
	OLDSPACE        1
	NEWSPACE        2  \ interchanged when scavenging
	SURVSPACE       3  /
	MEDSPACE        4  \ interchanged when scavenging
	MEDSURVSPACE    5  /
 */

#define MARKEDOLDSPACE  0       /* an already marked old space object */
#define OLDSPACE        1       /* an oldspace object */
#define NEWSPACE        2
#define SURVSPACE       3
#define MEDSPACE        4
#define MEDSURVSPACE    5
#define CATCHMARK       8       /* block catch bit */
#define STACKSPACE      0xf0

struct __oHeader {
	STX_OBJ_HEADER
};
#define OHDR_SIZE sizeof(struct __oHeader)

/*
 * for generic access to instance variables
 */
struct __instance {
	STX_OBJ_HEADER
	OBJ             i_instvars[1];
};

/*
 * not used; for gdb debugging only
 * (for: 'print *(struct __instance20 *)foo')
 */
struct __instance10 {
	STX_OBJ_HEADER
	OBJ             i_instvars[10];
};

struct __instance20 {
	STX_OBJ_HEADER
	OBJ             i_instvars[20];
};

struct __instance30 {
	STX_OBJ_HEADER
	OBJ             i_instvars[30];
};

struct __instance40 {
	STX_OBJ_HEADER
	OBJ             i_instvars[40];
};

#if defined(INT_TAG_ZERO)
/*
 * use 11 for objs, 00 for ints on sparc
 * OBJ is even obj-pointer -1
 */
# define __objPtr(o)     ((char *)(o) + 1)
# define __MKOBJPTR(o)   ((OBJ)((char *)(o) - 1))
#else
# define __objPtr(o)     (o)
# define __MKOBJPTR(o)   ((OBJ)(o))
#endif

#define __InstPtr(obj)   ((struct __instance *)(__objPtr(obj)))

/*
 * class objects (instances of Behavior / ClassDescription / Class)
 */
#ifdef LOOKUP_OBJECT_IN_BEHAVIOR
# define OPTIONAL_LOOKUPOBJECT_SLOT_IN_BEHAVIOR        OBJ c_lookupObject;
#else
# define OPTIONAL_LOOKUPOBJECT_SLOT_IN_BEHAVIOR        /* nothing */
#endif

#define __VMBEHAVIOR_INSTVARS__         \
	OBJ             c_superclass;   \
	OBJ             c_flags;        \
	OBJ             c_methodDict;   \
	OPTIONAL_LOOKUPOBJECT_SLOT_IN_BEHAVIOR

#define __BEHAVIOR_INSTVARS__           \
	__VMBEHAVIOR_INSTVARS__         \
	OBJ             c_ninstvars;

#define __CLASSDESCRIPTION_INSTVARS__   \
	__BEHAVIOR_INSTVARS__           \
	OBJ             c_instvars;

#define __CLASS_INSTVARS__                  \
	__CLASSDESCRIPTION_INSTVARS__       \
	OBJ             c_name;             \
	OBJ             c_category;         \
	OBJ             c_classvars;        \
	OBJ             c_comment;          \
	OBJ             c_subclasses;       \
	OBJ             c_classFileName;    \
	OBJ             c_package;          \
	OBJ             c_revision;         \
	OBJ             c_environment;      \
	OBJ             c_signature;        \
	OBJ             c_attributes;

#define __METACLASS_INSTVARS__          \
	__CLASSDESCRIPTION_INSTVARS__   \
	OBJ             m_myClass;

#define __PRIVATEMETACLASS_INSTVARS__   \
	__METACLASS_INSTVARS__          \
	OBJ             pm_owningClass;


struct __VMBehavior {
	STX_OBJ_HEADER
	__VMBEHAVIOR_INSTVARS__
};

struct __Behavior {
	STX_OBJ_HEADER
	__BEHAVIOR_INSTVARS__
};

struct __ClassDescription {
	STX_OBJ_HEADER
	__CLASSDESCRIPTION_INSTVARS__
};

struct __Class {
	STX_OBJ_HEADER
	__CLASS_INSTVARS__
};

struct __Metaclass {
	STX_OBJ_HEADER
	__METACLASS_INSTVARS__
};

struct __PrivateMetaclass {
	STX_OBJ_HEADER
	__PRIVATEMETACLASS_INSTVARS__
};

struct __classWithClassInstvars {
	struct __Class  c_class;
	OBJ             c_classInstvars[1];
};

#define __ClassInstPtr(obj)             ((struct __Class *)(__objPtr(obj)))
#define __MetaclassInstPtr(obj)         ((struct __Metaclass *)(__objPtr(obj)))
#define __PrivateMetaclassInstPtr(obj)  ((struct __PrivateMetaclass *)(__objPtr(obj)))
#define __ClassName(cobj)               (__ClassInstPtr(cobj)->c_name)

#define VMBEHAVIOR_SIZE sizeof(struct __VMBehavior)
#define BEHAVIOR_SIZE   sizeof(struct __Behavior)
#define CLASS_SIZE      sizeof(struct __Class)
#define METACLASS_SIZE  sizeof(struct __Metaclass)
#define NCLASSVARS      ((CLASS_SIZE-OHDR_SIZE)/sizeof(OBJ))

/*
 * instance type bits (boxed i.e. as SmallInteger)
 *
 *    array_type:   ........ ........ ........ ....xxxx
 *
 *    class-like    ........ ........ ........ ...1....
 *    float-like    ........ ........ ........ ..1.....
 *    block-like    ........ ........ ........ .1......
 *    method-like   ........ ........ ........ 1.......
 *    context-like  ........ ........ .......1 ........
 *    bcontext-like ........ ........ ......1. ........
 *    symbol-like   ........ ........ .....1.. ........
 *
 *    non-obj-insts ........ ........ ....1... ........
 *    extBytes-like ........ ........ ...1.... ........
 *    jArray        ........ ........ ..1..... ........
 *
 *    ext-func      ........ .......1 ........ ........
 *    primCode      ........ ......1. ........ ........
 *    blocks        ........ .....1.. ........ ........
 *    jMethods      ........ ....1... ........ ........
 *    jClasses      ........ ...1.... ........ ........
 *
 *    alien         ........ ..1..... ........ ........
 *    subclassed    ........ .1...... ........ ........
 *    c++-proxy     ........ 1.0..... ........ ........
 *    objc-proxy    ........ 1.1..... ........ ........
 */

/*      not-indexed     0       */
#define BYTEARRAY       1       /* byte array after instVars */
#define WORDARRAY       2       /* ushort (16bit) array after instVars */
#define LONGARRAY       3       /* ulong (32bit) array after instVars */
#define POINTERARRAY    4       /* pointer array after instVars */
#define WKPOINTERARRAY  5       /* weak pointers after instVars */
#define FLOATARRAY      6       /* float array after instVars */
#define DOUBLEARRAY     7       /* double array after instVars */
#define SWORDARRAY      8       /* signed shorts (16bit) after instVars */
#define SLONGARRAY      9       /* signed longs (32bit) after instVars */
#define LONGLONGARRAY  10       /* unsigned quad-ints (64bit) after instVars */
#define SLONGLONGARRAY 11       /* signed quad-ints (64bit) after instVars */

/*
 * reserved:            13-15
 */
#define ARRAYMASK       0x0F

#define BEHAVIOR_INSTS  0x0010  /* instances are class-like */
#define FLOAT_INSTS     0x0020  /* instances are float-like */
#define BLOCK_INSTS     0x0040  /* instances are block-like */
#define METHOD_INSTS    0x0080  /* instances are method-like */
#define CONTEXT_INSTS   0x0100  /* instances are context-like */
#define BCONTEXT_INSTS  0x0200  /* instances are block context-like */
#define SYMBOL_INSTS    0x0400  /* instances are symbol-like */

#define NONOBJECT_INSTS     0x0800  /* instances have a non-object pointer at slot 1 */
#define EXTERNALBYTES_INSTS 0x1000  /* instances have a byte pointer at slot 1 */
#define EXTFUNC_INSTS   0x010000 /* instances are proxies for external functions */

/*
 * support for primitive code
 */
#define PRIMITIVE_CODE  0x020000 /* class has primitive code */

/*
 * VM can evaluate this like a block
 */
#define BLOCKLIKE_INSTS 0x040000 /* VM treats it like a block (but not compiled code !) */

/*
 * JAVA method/JAVA class
 */
#define JMETHOD_INSTS   0x080000 /* insts are java Methods; interpreter switches to JAVA bytecode */
#define JCLASS_INSTS    0x100000 /* insts are java classes */
#define JARRAY_INSTS      0x2000 /* instances are java arrays */

/*
 * currently not used - for later extensions
 */
#define ALIENPOINTERS   0x200000 /* instances consist of alien pointers (not currently used) */
#define ISSUBCLASSED    0x400000 /* class has subclasses (not currently used) */
#define CPLUSPLUS_INSTS 0x800000 /* instances are proxies for c++ objects */
#define OBJC_INSTS      0xA00000 /* instances are proxies for objc objects */

#define FINALIZE_H_INSTS 0x1000000 /* instances are finalization helper objects */
#define METAMETHOD_INSTS 0x2000000 /* instances are metaMethods */
#define PROTECTED_CLASS  0x4000000 /* future extension */

/*
 * array objects
 */
struct __arrayHeader {
	STX_OBJ_HEADER
};

struct __Array {
	STX_OBJ_HEADER
	OBJ             a_element[1];
};

#define __ArrayInstPtr(obj)     ((struct __Array *)(__objPtr(obj)))

/*
 * bytearray objects
 */
struct __ByteArray {
	STX_OBJ_HEADER
	unsigned char   ba_element[1];
};

#define __ByteArrayInstPtr(obj)  ((struct __ByteArray *)(__objPtr(obj)))

#define __EXECUTABLEFUNCTION_INSTVARS__                                         \
	OBJFUNC         ex_code;         /* non NULL for real code */

/*
 * any executable-code object
 */
#if USE_LITARRAY
#define __EXECUTABLECODE_INSTVARS__                                             \
	__EXECUTABLEFUNCTION_INSTVARS__                                         \
	OBJ             ex_flags;        /* see below */                        \
	OBJ             ex_bytecodes;    /* non NULL for bytecoded method */    \
	OBJ             ex_literals;     /* literal constants */

#define N_EXECCODE_INSTVARS     4
#else
#define __EXECUTABLECODE_INSTVARS__                                             \
	__EXECUTABLEFUNCTION_INSTVARS__                                         \
	OBJ             ex_flags;        /* see below */                        \
	OBJ             ex_bytecodes;    /* non NULL for bytecoded method */    \

#define N_EXECCODE_INSTVARS     3
#endif


struct __ExecutableCode {
	STX_OBJ_HEADER
	__EXECUTABLECODE_INSTVARS__
};

#define __ExecutableCodeInstPtr(obj)     ((struct __ExecutableCode *)(__objPtr(obj)))

#ifdef SELECTOR_IN_METHOD
# define OPTIONAL_SELECTOR_SLOT_IN_METHOD           OBJ m_mselector;
#else
# define OPTIONAL_SELECTOR_SLOT_IN_METHOD           /* nothing */
#endif

#ifdef ANNOTATION_IN_METHOD
# define OPTIONAL_ANNOTATION_SLOT_IN_METHOD         OBJ m_annotation;
#else
# define OPTIONAL_ANNOTATION_SLOT_IN_METHOD         /* nothing */
#endif

#ifdef LOOKUP_OBJECT_IN_METHOD
# define OPTIONAL_LOOKUPOBJECT_SLOT_IN_METHOD        OBJ m_lookupObject;
#else
# define OPTIONAL_LOOKUPOBJECT_SLOT_IN_METHOD        /* nothing */
#endif

/*
 * method objects
 */
#define __METHOD_INSTVARS__           \
	__EXECUTABLECODE_INSTVARS__   \
	OBJ             m_source;     \
	OBJ             m_sourcepos;  \
	OBJ             m_category;   \
	OBJ             m_package;    \
	OBJ             m_mclass;     \
	OPTIONAL_SELECTOR_SLOT_IN_METHOD  \
	OPTIONAL_LOOKUPOBJECT_SLOT_IN_METHOD  /* needs to be here - same pos as in Java method. Should be moved ExecutableFunction? */ \
	OPTIONAL_ANNOTATION_SLOT_IN_METHOD

struct __Method {
	STX_OBJ_HEADER
	__METHOD_INSTVARS__
};
#define m_code          ex_code         /* for backward compatibility */
#define m_bytecodes     ex_bytecodes
#if USE_LITARRAY
# define m_literals      ex_literals
#endif
#define m_flags         ex_flags

#define __MethodInstPtr(obj)     ((struct __Method *)(__objPtr(obj)))

/*
 * block objects
 */
#define __BLOCK_INSTVARS__                                             \
	__EXECUTABLECODE_INSTVARS__                                    \
	OBJ             b_home;         /* blocks home context */      \
	OBJ             b_nargs;        /* number of args to block */  \
	OBJ             b_sourcepos;    /* offset in home-source */    \
	OBJ             b_initialPC;    /* start of block */

// #define O_BLOCK_HOME    N_EXECCODE_INSTVARS
#define __OFFS_BLOCK_HOME    N_EXECCODE_INSTVARS

struct __Block {
	STX_OBJ_HEADER
	__BLOCK_INSTVARS__
};

#define __CHEAPBLOCK_INSTVARS__                                 \
	__BLOCK_INSTVARS__                                      \
	OBJ             b_selfValue;    /* copy of self */      \
	OBJ             b_method;       /* the blocks method */

struct __CheapBlock {
	STX_OBJ_HEADER
	__CHEAPBLOCK_INSTVARS__
};

#define b_code          ex_code         /* for backward compatibility */
#define b_bytecodes     ex_bytecodes
#if USE_LITARRAY
# define b_literals      ex_literals
#endif
#define b_flags         ex_flags

#define __BlockInstPtr(obj)      ((struct __Block *)(__objPtr(obj)))
#define __CheapBlockInstPtr(obj) ((struct __CheapBlock *)(__objPtr(obj)))
#define b_nextFree              b_home     /* free blocks are linked here */

/*
 * only the stuff from Process instances which are well known in the VM
 * (bad design - there should not be any)
 */
struct __VMProcess {
	STX_OBJ_HEADER
	OBJ             p_nextLink;
	OBJ             p_id;
	OBJ             p_lookupActivations;
	OBJ             p_lookupDisabled;
};
#define __VMProcessInstPtr(obj)      ((struct __VMProcess *)(__objPtr(obj)))

/* JavaArray
 */
struct __JavaArrayClass {
	STX_OBJ_HEADER
	__CLASS_INSTVARS__
	OBJ jac_componentClass;
};

#define __JavaArrayClassPtr(obj)      ((struct __JavaArrayClass *)(__objPtr(obj)))


/*
 * java method
 * only the following are known & req'd by the VM;
 * all other fields are only req'd by the ST/X java support system.
 */
struct __JavaMethod {
	STX_OBJ_HEADER
	__EXECUTABLECODE_INSTVARS__
	OBJ             jm_accessFlags;         /* flags as def'd by java doc */
	OBJ             jm_selector;            /* the methods name */
	OBJ             jm_javaClass;           /* ref to javaClass */
	OBJ             jm_descriptor;          /* */
	OBJ             jm_signature;           /* */
	OPTIONAL_LOOKUPOBJECT_SLOT_IN_METHOD    /* needs to be here - same pos as in Smalltalk method. Should be moved ExecutableFunction? */
	OBJ             jm_lineNumberTable;     /* */
	OBJ             jm_localVariableTable;  /* */
	OBJ             jm_sourceLineNumber;    /* */
	OBJ             jm_annotations;         /* */
};
#define __JavaMethodInstPtr(obj)      ((struct __JavaMethod *)(__objPtr(obj)))

/*
 * java class
 * only the following are known & req'd by the VM;
 * all other fields are only req'd by the ST/X java support system.
 */
struct __JavaBehavior {
	STX_OBJ_HEADER
	__CLASS_INSTVARS__
	OBJ             jc_constantPool;
	OBJ             jc_interfaces;
	OBJ             jc_accessFlags;
	OBJ             jc_initValues;
        OBJ             jc_lock;
};
#define __JavaBehaviorInstPtr(obj)      ((struct __JavaBehavior *)(__objPtr(obj)))

#define __ACC_PUBLIC       0x0000001   /* method, class */
#define __ACC_PRIVATE      0x0000002   /* method, class*/
#define __ACC_PROTECTED    0x0000004   /* method, class*/
#define __ACC_STATIC       0x0000008   /* method*/
#define __ACC_FINAL        0x0000010   /* method, class*/
#define __ACC_SYNCHRONIZED 0x0000020   /* method */
#define __ACC_BRIDGE       0x0000040   /* method */
#define __ACC_VARARGS      0x0000080   /* method */
#define __ACC_SUPER        0x0000020   /* class */
#define __ACC_VOLATILE     0x0000040
#define __ACC_TRANSIENT    0x0000080
#define __ACC_NATIVE       0x0000100   /* method */
#define __ACC_INTERFACE    0x0000200   /* class */
#define __ACC_ABSTRACT     0x0000400   /* method, class */
#define __ACC_STRICT       0x0000800   /* method */
#define __ACC_SYNTHETIC    0x0001000   /* method, class */
#define __ACC_ANNOTATION   0x0002000   /* class */
#define __ACC_ENUM         0x0004000   /* class */

/* Smalltalk/X JVM implementation specific constansts */

#define __ACX_INITIALIZED  0x08000000      /* class, class is properly initialized */
#define __ACX_INITIALIZING 0x00000008      /* class, class is not initialized but initializer is running */
#define __ACX_HASFINALIZE  __ACC_VARARGS   /* class, class has finalize() */
#define __ACX_BREAKPNT     0x10000000      /* method, method is breakpointed */
#define __ACX_HASHANDLER   0x20000000      /* method, method has any handler */
#define __ACX_HASFINALLY   0x00004000      /* method, method has finally handler */
#define __ACX_RESOLVED     0x00002000      /* method, method is fully resolved */
#define __ACX_HASMULTIVERS __ACX_BREAKPNT  /* class, class has multiple versions because layout changed */
#define __ACX_CLONEABLE    __ACC_STRICT    /* class, class/interface implements/extends java.lang.Cloneable */
#define __ACX_HASERRORS    __ACC_BRIDGE    /* class, class has compilation errors */
#define __ACX_OBSOLETE     0x0008000       /* class, class is obsolete (replaced by a new version) */

/*                         44332211                             */
#define __ACX_R_VOID       0x01000000      /* method returns VOID */
#define __ACX_R_LONG       0x02000000      /* method returns LONG / field is of type LONG*/
#define __ACX_R_DOUBLE     0x04000000      /* method returns DOUBLE / field is of type DOUBLE */
#define __ACX_R_MASK       0x07000000      /* method return type mask */
#define __ACX_NARGS_MASK   0x00FF0000      /* method numArgs mask */
#define __ACX_NARGS_SHIFT  16
#define __ACX_NARGS_OF     0x40000000      /* method numArgs overflow - get numArgs from method instvar */

/*
 * method/block flag bits (boxed i.e. as SmallInteger)
 *
 *    nvars:        ........ ........ ........ nnnnnnnn
 *    nstack:       ........ ........ nnnnnnnn ........
 *    nargs:        ........ ...nnnnn ........ ........
 *
 *    restricted:   ........ ..1..... ........ ........
 *    private:      ........ 01...... ........ ........
 *    cls private:  ........ 10...... ........ ........
 *    ignored:      ........ 11...... ........ ........
 *
 *    dynamic:      .......1 ........ ........ ........
 *    checked:      ......1. ........ ........ ........
 *    jit-code:     .....1.. ........ ........ ........
 *
 *    returnable:   ....1... ........ ........ ........
 *    primitive:    ...1.... ........ ........ ........
 *    mark bit:     ..1..... ........ ........ ........
 *    resource:     .1...... ........ ........ ........
 *
 * Java methods:
 * (accessFlag bits)
 *    public        ........ ........ ........ .......1
 *    private       ........ ........ ........ ......1.
 *    protected     ........ ........ ........ .....1..
 *    static        ........ ........ ........ ....1...
 *    final         ........ ........ ........ ...1....
 *    sync'd        ........ ........ ........ ..1..... (methods)
 *    super         ........ ........ ........ ..1..... (classes)
 *    volatile      ........ ........ ........ .1......
 *    transient     ........ ........ ........ 1.......
 *    native        ........ ........ .......1 ........
 *    interface     ........ ........ ......1. ........
 *    abstract      ........ ........ .....1.. ........
 *    strict        ........ ........ ....1... ........
 *    synthetic     ........ ........ ...1.... ........
 *    annotation    ........ ........ ..1..... ........ (classes)
 *    resolved      ........ ........ ..1..... ........ (method)
 *    enum          ........ ........ .1...... ........ (classes)
 *    has finally   ........ ........ .1...... ........ (method)
 *    obsolete      ........ ........ 1....... ........
 *    initialized   ........ .......1 ........ ........ (classes)
 *    nArgs         ........ xxxxxxxx ........ ........ (methods)
 *    return type   .....xxx ........ ........ ........ (methods / fields)
 *    multiversion  ....1... ........ ........ ........ (classes)
 *    breakpoint    ....1... ........ ........ ........ (methods)
 *    hasHandler    ...1.... ........ ........ ........
 *    nArgs overflow..1..... ........ ........ ........
 */
#define F_NVARS         0x0000FF          /* mask for # of local vars */
#define F_NVARSHIFT     0
#define F_NSTACK        0x00FF00          /* mask for stack size */
#define F_NSTACKSHIFT   8
#define F_NARGS         0x1F0000          /* mask for # of expected args */
#define F_NARGSHIFT     16
/*
 * method privacy
 */
#define F_RESTRICTED    0x00200000        /* not at all allowed in restricted (RT) mode */
#define F_PRIVATE       0x00400000        /* send only allowed from class's and subclass's methods */
#define F_CLASSPRIVATE  0x00800000        /* send only allowed from same class's methods */
#define F_IGNORED       0x00C00000        /* invisible method - its physically there, but ignored in lookup */
#define M_PRIVACY       0x00C00000        /* to mask out PRIVATE, CLASSPRIVATE & IGNORED flags */

/*
 * flags to support on-the-fly compilation into machine code
 */
#define F_DYNAMIC       0x01000000        /* code field contains dynamic compiled */
#define F_CHECKED       0x02000000        /* has already been analyzed */
#define F_JUSTINTIME    0x04000000        /* code was created by just-in-time compilation */

/*
 * flags to change context setup
 */
#define F_RETURNABLE    0x08000000        /* force returnable context */

/*
 * additional (currently unused)
 */
#define F_PRIMITIVE     0x10000000        /* has primitive code */
#define F_MARKBIT       0x20000000        /* a mark bit - use for whatever (for example: coverage tests) */
#define F_RESOURCE      0x40000000        /* contains resource spec */

/*
 * external function objects
 */
#define __EXTERNALFUNCTION_INSTVARS__           \
	__EXECUTABLEFUNCTION_INSTVARS__         \
	OBJ             ext_name;               \
	OBJ             ext_moduleHandle;

#define __EXTERNALLIBRARYFUNCTION_INSTVARS__    \
	__EXTERNALFUNCTION_INSTVARS__           \
	OBJ             extl_flags;             \
	OBJ             extl_moduleName;        \
	OBJ             extl_returnType;        \
	OBJ             extl_argumentTypes;     \
	OBJ             extl_owningClass;

struct __ExternalLibraryFunction {
	STX_OBJ_HEADER
	__EXTERNALLIBRARYFUNCTION_INSTVARS__
};
#define extl_code           ex_code
#define extl_name           ext_name
#define extl_moduleHandle   ext_moduleHandle
#define __ExternalLibraryFunctionInstPtr(o) ((struct __ExternalLibraryFunction *)(__objPtr(o)))

#define __EXTL_FLAG_VIRTUAL          0x100       /* a virtual c++ call */
#define __EXTL_FLAG_NONVIRTUAL       0x200       /* a non-virtual c++ call */
#define __EXTL_FLAG_UNLIMITEDSTACK   0x400       /* unlimitedstack under unix */
#define __EXTL_FLAG_ASYNC            0x800       /* async under win32 */
#define __EXTL_FLAG_RETVAL_IS_CONST  0x1000      /* return value is not to be registered for finalization */
#define __EXTL_FLAG_OLE              0x2000      /* ole call */
#define __EXTL_FLAG_OBJECTIVEC       0x4000      /* objectiveC msg-send (osx only) */

#define __EXTL_CALLTYPE_API          1           /* WINAPI-call (win32 only) */
#define __EXTL_CALLTYPE_C            2           /* regular C-call (the default) */
#define __EXTL_CALLTYPE_V8           3           /* v8 call (sparc only) */
#define __EXTL_CALLTYPE_V9           4           /* v9 call (sparc only) */
#define __EXTL_CALLTYPE_UNIX64       5           /* unix64 call (alpha only) */
#define __EXTL_CALLTYPE_MASK         0xFF

/*
 * context objects
 * while on the stack, some private info is added
 */
#define __ContextInstPtr(obj)     ((struct __Context *)(__objPtr(obj)))
#define __JavaContextInstPtr(obj) ((struct __JavaContext *)(__objPtr(obj)))


#if defined(__GNUC__) || defined(__CLANG__)
#  define SETHANDLE(con) _Pragma ("GCC warning \"SETHANDLE() macro is deprecated, use SET_MFRAME_HANDLE() instead\"") SET_MFRAME_HANDLE(con)
#else
#  define SETHANDLE(con) SET_MFRAME_HANDLE(cod)
#endif

#ifndef __getStack__
#  if defined(__GNUC__) || defined(__CLANG__)
#    define __getStack__() ((INT)__builtin_frame_address(0))
#  else
#    error "__getStack__() not defined for this platform / compiler"
#  endif
#endif

#ifdef TRADITIONAL_STACK_FRAME
# if defined(sparc)
/*
 * sparc & TRADITIONAL does not work - it was a try but ...
 */

/*
 * sparc has a very special stack frame format ...
 */

#define __SP__()                                \
    ({                                          \
	int __rslt;                             \
	asm("mov   %%sp,%0" : "=r" (__rslt));   \
	(char *)__rslt;                         \
    })

#  define SET_MFRAME_HANDLE(con)        (con)->c_pSelf = (OBJ *)__SP__();
#  define SET_BFRAME_HANDLE(con)        SET_MFRAME_HANDLE(con)

struct __stackFrame {
	unsigned savedLocal[8];
	union {
	    unsigned savedIn[8];
	    struct {
		unsigned in_i0;
		unsigned in_i1;
		unsigned in_i2;
		unsigned in_i3;
		unsigned in_i4;
		unsigned in_i5;
		struct __stackFrame *prevFrame;
		unsigned *retPC;
	    } u;
	} r;
	unsigned hidden;
	unsigned out[6];
	OBJ outPast6[1];
};

struct __methodStackFrame {
	unsigned savedLocal[8];
	union {
	    unsigned savedIn[8];
	    struct {
		OBJ     in_self;
		OBJ     in_selector;
#  ifndef THIS_CONTEXT
		OBJ     in_sender;
		OBJ     in_searchclass;
		char    *in_pInlineCache;
		OBJ     in_arg0;
#  else
		OBJ     in_searchclass;
		char    *in_pInlineCache;
		OBJ     in_arg0;
		OBJ     in_arg1;
#  endif
		struct __stackFrame *prevFrame;
		unsigned *retPC;
	    } mu;
	} mr;
	unsigned hidden;
	unsigned out[6];
	OBJ outPast6[1];
};
#  define mf_self               mr.mu.in_self
#  define mf_selector           mr.mu.in_selector
#  define mf_searchclass        mr.mu.in_searchclass
#  define mf_pInlineCache       mr.mu.in_pInlineCache
#  define mf_arg0               mr.mu.in_arg0
#  ifndef THIS_CONTEXT
#   define mf_arg1              mr.mu.prevFrame->outPast6[0]
#   define mf_argN(n)           mr.mu.prevFrame->outPast6[n-1]
#  else
#   define mf_arg1              mr.mu.in_arg1
#   define mf_argN(n)           mr.mu.prevFrame->outPast6[n-2]
#  endif

struct __blockStackFrame {
	unsigned savedLocal[8];
	union {
	    unsigned savedIn[8];
	    struct {
        OBJ     in_block;
#  ifndef THIS_CONTEXT
		OBJ     in_sender;
		OBJ     in_arg0;
		OBJ     in_arg1;
		OBJ     in_arg2;
		OBJ     in_arg3;
#  else
		OBJ     in_arg0;
		OBJ     in_arg1;
		OBJ     in_arg2;
		OBJ     in_arg3;
		OBJ     in_arg4;
#  endif
		struct __stackFrame *prevFrame;
		unsigned *retPC;
	    } bu;
	} br;
	unsigned hidden;
	unsigned out[6];
	OBJ outPast6[1];
};
#  define bf_self               br.bu.in_self
#  define bf_block               br.bu.in_block
#  define bf_arg0               br.bu.in_arg0
#  define bf_arg1               br.bu.in_arg1
#  define bf_arg2               br.bu.in_arg2
#  define bf_arg3               br.bu.in_arg3
#  ifndef THIS_CONTEXT
#   define bf_arg4              br.bu.prevFrame->outPast6[0]
#   define bf_argN(n)           br.bu.prevFrame->outPast6[n-4]
#  else
#   define bf_arg4              br.bu.in_arg4
#   define bf_argN(n)           br.bu.prevFrame->outPast6[n-5]
#  endif

# else /* not sparc */
#  ifndef SET_MFRAME_HANDLE
#   warning "Using &self to get pointer to a method frame is unsafe w.r.t optimizations. Beware!"
#   define SET_MFRAME_HANDLE(con)        (con)->c_pSelf = (OBJ *)&self;
#  endif
#  ifndef SET_BFRAME_HANDLE
#   warning "Using &__block to get pointer to a block frame is unsafe w.r.t optimizations. Beware!"
#   define SET_BFRAME_HANDLE(con)        (con)->c_pSelf = (OBJ *)&__block;
#  endif

/*
 * for machines with a TRADITIONAL stack-arg-passing scheme,
 * some optimizations are possible
 * (i.e. not filling contexts from arguments until needed)
 */
#  ifdef ARG_ORDER_NORMAL
    struct __stackFrame {
	OBJ     f_self;
	OBJ     f_selectorOrHome;
#   ifndef THIS_CONTEXT
	OBJ     f_sender;
#   endif
    };

    struct __methodStackFrame {
	OBJ     mf_self;
	OBJ     mf_selector;
#   ifndef THIS_CONTEXT
	OBJ     mf_sender;
#   endif
	OBJ     mf_searchclass;
	char    *mf_pInlineCache;
	OBJ     mf_args[1];
    };

    struct __blockStackFrame {
	OBJ     bf_block;
#   ifndef THIS_CONTEXT
	OBJ     bf_sender;
#   endif
	OBJ     bf_args[1];
    };

#  else /* reverse arg order */

    struct __stackFrame {
	OBJ     f_pointers[1];
    };
    struct __methodStackFrame {
	OBJ     mf_pointers[1];
    };
    struct __blockStackFrame {
	OBJ     bf_pointers[1];
    };

#   ifdef THIS_CONTEXT
#    define f_self              f_pointers[0]
#    define f_selectorOrHome    f_pointers[-1]
#    define mf_searchclass      f_pointers[-2]
#    define mf_pInlineCache     f_pointers[-3]
#    define mf_args             f_pointers[-4]
#    define bf_block            f_pointers[0]
#    define bf_args             f_pointers[-1]
#   else
#	 error "Not implemented"
#   endif
#  endif

# endif /* sparc */

#else /* not TRADITIONAL_STACK_FRAME */

#  define SET_MFRAME_HANDLE(con)        /* nothing */
#  define SET_BFRAME_HANDLE(con)        /* nothing */

#  ifdef sparc
struct __stackFrame {
	unsigned savedLocal[8];
	union {
	    unsigned savedIn[8];
	    struct {
		unsigned in_i0;
		unsigned in_i1;
		unsigned in_i2;
		unsigned in_i3;
		unsigned in_i4;
		unsigned in_i5;
		struct __stackFrame *prevFrame;
		unsigned *retPC;
	    } u;
	} r;
	unsigned hidden;
	unsigned out[6];
	OBJ outPast6[1];
};
#  endif
#endif /* TRADITIONAL_STACK_FRAME */

#ifdef ARG_ORDER_NORMAL
#   define __ARG0       0
#   define __ARG1       1
#   define __ARG2       2
#   define __ARG3       3
#   define __ARG4       4
#   define __ARG5       5
#   define __ARG6       6
#   define __ARG7       7
#   define __ARG8       8
#   define __ARG9       9
#   define __ARG10     10
#   define __ARG11     11
#   define __ARG12     12
#   define __ARG13     13
#   define __ARG14     14
#   define __ARG15     15
#   define __ARG16     16
#   define __ARG17     17
#   define __ARG18     18
#   define __ARG19     19
#else
# ifdef ARG_ORDER_REVERSE
#   define __ARG0       0
#   define __ARG1       -1
#   define __ARG2       -2
#   define __ARG3       -3
#   define __ARG4       -4
#   define __ARG5       -5
#   define __ARG6       -6
#   define __ARG7       -7
#   define __ARG8       -8
#   define __ARG9       -9
#   define __ARG10     -10
#   define __ARG11     -11
#   define __ARG12     -12
#   define __ARG13     -13
#   define __ARG14     -14
#   define __ARG15     -15
#   define __ARG16     -16
#   define __ARG17     -17
#   define __ARG18     -18
#   define __ARG19     -19
# endif
#endif

#define CONPRIVATEDATA           \
    VOLATILE void   *__hook;     \
    VOLATILE INT    __moreFlags; \
    stx_jmp_buf     __retvec;

/*
 * moreFlags are only valid (and even initialized), when SPECIAL is set
 */
#define RETVAL_IS_RETURNBLOCK 1         /* have to execute RETVAL
					 * when returning */

/*
 * contexts
 */
#ifdef METHOD_IN_CONTEXT
# define OPTIONAL_METHOD_SLOT_IN_CONTEXT            OBJ c_method;
# define OPTIONAL_METHOD_SLOT_IN_JCONTEXT           /* nothing */
# define jc_method                                  c_method
#else
# define OPTIONAL_METHOD_SLOT_IN_CONTEXT            /* nothing */
# define OPTIONAL_METHOD_SLOT_IN_JCONTEXT           OBJ jc_method;
#endif

/* see kludge below, before changing the order/offsets of home and sender */

typedef OBJ CONTEXT_OBJ;

#define __CONTEXT_INSTVARS__           \
	OBJ               c_flags;        /* 0 */ \
	CONTEXT_OBJ       c_sender;       /* 1 */ \
	CONTEXT_OBJ       c_home;         /* 2 */ \
	OBJ               c_receiver;     /* 3 */ \
	OBJ               c_selector;     /* 4 */ \
	OBJ               c_searchclass;  /* 5 */ \
	OPTIONAL_METHOD_SLOT_IN_CONTEXT   /* 6 */ \
	OBJ               c_lineno;       /* 7 */ \
	OBJ               c_retval;       /* 8 */ \
	OBJ              *c_pSelf;        /* 9 */

/*
 * kludge:
 * some well-known slot-offsets in a context
 */
#define __OFFS_CONTEXT_FLAGS             0
#define __OFFS_CONTEXT_SENDER            (__OFFS_CONTEXT_FLAGS + 1)
#define __OFFS_CONTEXT_HOME              (__OFFS_CONTEXT_SENDER + 1)
#define __OFFS_CONTEXT_RECEIVER          (__OFFS_CONTEXT_HOME + 1)
#define __OFFS_CONTEXT_SELECTOR          (__OFFS_CONTEXT_RECEIVER + 1)
#define __OFFS_CONTEXT_SEARCHCLASS       (__OFFS_CONTEXT_SELECTOR + 1)
#ifdef METHOD_IN_CONTEXT
# define __OFFS_CONTEXT_METHOD           (__OFFS_CONTEXT_SEARCHCLASS + 1)
# define __OFFS_CONTEXT_LINENO           (__OFFS_CONTEXT_METHOD + 1)
#else
# define __OFFS_CONTEXT_LINENO           (__OFFS_CONTEXT_SEARCHCLASS + 1)
#endif
#define __OFFS_CONTEXT_RETVAL           (__OFFS_CONTEXT_LINENO + 1)
#define __OFFS_CONTEXT_HANDLE           (__OFFS_CONTEXT_RETVAL + 1)

#define __BYTEOFFS_CONTEXT_SENDER        (__ASM_HEADER_SIZE+(__OFFS_CONTEXT_SENDER*sizeof(INT)))
#define __BYTEOFFS_CONTEXT_HOME          (__ASM_HEADER_SIZE+(__OFFS_CONTEXT_HOME*sizeof(INT)))
#define __BYTEOFFS_CONTEXT_RECEIVER      (__ASM_HEADER_SIZE+(__OFFS_CONTEXT_RECEIVER*sizeof(INT)))
#define __BYTEOFFS_CONTEXT_SELECTOR      (__ASM_HEADER_SIZE+(__OFFS_CONTEXT_SELECTOR*sizeof(INT)))
#define __BYTEOFFS_CONTEXT_SEARCHCLASS   (__ASM_HEADER_SIZE+(__OFFS_CONTEXT_SEARCHCLASS*sizeof(INT)))
#define __BYTEOFFS_CONTEXT_LINENO        (__ASM_HEADER_SIZE+(__OFFS_CONTEXT_LINENO*sizeof(INT)))
#define __BYTEOFFS_CONTEXT_RETVAL        (__ASM_HEADER_SIZE+(__OFFS_CONTEXT_RETVAL*sizeof(INT)))
#define __BYTEOFFS_CONTEXT_HANDLE        (__ASM_HEADER_SIZE+(__OFFS_CONTEXT_HANDLE*sizeof(INT)))

#define __SLOT_CONTEXT_SENDER            (__OFFS_CONTEXT_SENDER + 1)
#define __SLOT_CONTEXT_RETVAL            (__OFFS_CONTEXT_RETVAL + 1)
#define __SLOT_CONTEXT_HANDLE            (__OFFS_CONTEXT_HANDLE + 1)

#define __JCONTEXT_ADDITIONAL_INSTVARS__ \
	OBJ             jc_exArg;        \
	OBJ             jc_exPC;         \
	OBJ             jc_byteCode;     \
	OBJ             jc_constPool;    \
	OBJ             jc_acqrMonitors; \
	OPTIONAL_METHOD_SLOT_IN_JCONTEXT


# define __JCONTEXT_INSTVARS__          \
	__CONTEXT_INSTVARS__            \
	__JCONTEXT_ADDITIONAL_INSTVARS__


/*
 * on-stack contexts have more data prepended to the context-object
 */
struct __conPrivate {
    CONPRIVATEDATA
};

#define CONPRIVATE(con)  (((struct __conPrivate *)con) - 1)

#define __CONTEXT0__                    \
struct {                                \
    CONPRIVATEDATA                      \
    VOLATILE struct __Context0 {       \
	STX_OBJ_HEADER                  \
	__CONTEXT_INSTVARS__            \
    } __con;                            \
} __con;

#define __CONTEXT__(n)                  \
struct {                                \
    CONPRIVATEDATA                      \
    VOLATILE struct __Context##n  {     \
	STX_OBJ_HEADER                  \
	__CONTEXT_INSTVARS__            \
	OBJ             c_vars[n];      \
    } __con;                            \
} __con;

#define __JCONTEXT0__                   \
struct {                                \
    CONPRIVATEDATA                      \
    VOLATILE struct __JavaContext0 {    \
	STX_OBJ_HEADER                  \
	__JCONTEXT_INSTVARS__           \
    } __con;                            \
} __con;

#define __JCONTEXT__(n)                 \
struct {                                \
    CONPRIVATEDATA                      \
    VOLATILE struct __JavaContext##n {  \
	STX_OBJ_HEADER                  \
	__JCONTEXT_INSTVARS__           \
	OBJ             c_vars[n];      \
    } __con;                            \
} __con;

struct __contextHeader {
	STX_OBJ_HEADER
	__CONTEXT_INSTVARS__
};

struct __Context {
	STX_OBJ_HEADER
	__CONTEXT_INSTVARS__
	OBJ             c_vars[1];
};

struct __javaContextHeader {
	STX_OBJ_HEADER
	__JCONTEXT_INSTVARS__
};

struct __JavaContext {
	STX_OBJ_HEADER
	__JCONTEXT_INSTVARS__
	OBJ             c_vars[1];
};

struct __stackContextHeader {
	CONPRIVATEDATA
	struct __contextHeader  __con;
};

struct __stackJavaContextHeader {
    CONPRIVATEDATA
    struct __javaContextHeader  __con;
};


struct __stackContext {
	CONPRIVATEDATA
	struct __Context __con;
};

/*
 * contexts flag word is (boxed i.e. as smallInteger):
 *
 *    nargs:        ........ ........ ...nnnnn ........
 *    nvars:        ........ ....nnnn nnn..... ........
 *    ntmp:         .......n nnnn.... ........ ........
 *
 *    compr. narg:  ........ ........ ......nn ........
 *    compr. nvar:  ........ ........ ..nn.... ........
 *    compr. ntmp:  ........ ........ ....nn.. ........
 *
 *    lazy mcon:    ........ ........ ........ ....01..
 *    lazy bcon:    ........ ........ ........ ....10..
 *    lazy jcon:    ........ ........ ........ ....11..
 *    non-lifo:     ........ ........ ........ ...1....
 *    interrupted:  ........ ........ ........ ......1. (now: allNonLazy)
 *    special:      ........ ........ ........ .......1
 *    compressed:   ........ ........ ........ ..1.....
 *    regs used:    ........ ........ ........ .1......
 *    regs used2:   ........ ........ ........ 10......
 *    handle mark:  ......1. ........ ........ ........
 *    raise mark:   .....1.. ........ ........ ........
 *    javaExPend:   ....1... ........ ........ ........
 *    irq on unwind:...1.... ........ ........ ........
 *    no setjmp:    ..1..... ........ ........ ........
 *    unwind mark:  .1...... ........ ........ ........
 *
 * flag in context
 * limits: max 31 args, 127 locals and 31 expression temporaries
 *
 * notice, that actually less than 31 args are supported
 * (currently 15) the limit comes from the number of cases in the
 * various dipatchers (send.c, interpreter.c, Object.st, Method.st).
 *
 * as smallInteger:
 *    special:      ........ ........ ........ ......1.
 *    interrupted:  ........ ........ ........ .....1..
 *    lazy mcon:    ........ ........ ........ ...01...
 *    lazy bcon:    ........ ........ ........ ...10...
 *    non-lifo:     ........ ........ ........ ..1.....
 *    compressed:   ........ ........ ........ .1......
 *    regs used:    ........ ........ ........ 1.......
 *    regs used2:   ........ ........ .......1 0.......
 *    handle mark:  .....1.. ........ ........ ........
 *    raise mark:   ....1... ........ ........ ........
 *    javaExPend:   ...1.... ........ ........ ........
 *    irq on unwind:..1..... ........ ........ ........
 *    no setjmp:    .1...... ........ ........ ........
 *    unwind mark:  1....... ........ ........ ........
 */
#define __NARG_SHIFT    8
#define __NVAR_SHIFT    13
#define __NTMP_SHIFT    20
#define __NARG_MASK     0x1F
#define __NVAR_MASK     0x7F
#define __NTMP_MASK     0x1F
#define __NARG(x)       ((x) << __NARG_SHIFT)
#define __NVAR(x)       ((x) << __NVAR_SHIFT)
#define __NTMP(x)       ((x) << __NTMP_SHIFT)
#define __SPECIAL       1                       /* special handling at return required */
#define __ALLNONLAZY    2                       /* all contexts above are non-lazy */
#define __LAZYMCON      0x04                    /* method context is not valid (i.e. lazy) */
#define __LAZYBCON      0x08                    /* block context is not valid (i.e. lazy) */
#define __LAZYJCON      0x0C                    /* java context is not valid (i.e. lazy) */
#define __MASK_LAZY     0x0C
#define __NONLIFO       0x10                    /* context has reference taken */
#define __COMPRESSED    0x20                    /* flag bits are compressed */
#define __C_NARG_SHIFT  8
#define __C_NVAR_SHIFT  10
#define __C_NTMP_SHIFT  12
#define __C_NARG_MASK   0x03
#define __C_NVAR_MASK   0x03
#define __C_NTMP_MASK   0x03
#define __C_NARG(x)     ((x) << __C_NARG_SHIFT)
#define __C_NVAR(x)     ((x) << __C_NVAR_SHIFT)
#define __C_NTMP(x)     ((x) << __C_NTMP_SHIFT)

#define __REGSUSED      0x40                    /* used with sparc only - marks register usage (context-locals in registers) */
#define __REGSUSED2     0x80
#define __REGSUSED3     0xc0

#define __HANDLE_MARK   0x02000000              /* this is an exception-handle context */
#define __RAISE_MARK    0x04000000              /* this is an exception-raise context */
#define __METHOD_VALID  0x08000000              /* marks a valid value in the c_method slot (nil or a method ref) */

#define __IRQ_ON_UNWIND 0x10000000              /* interrupt on unwind */
#define __CANNOT_RETURN 0x20000000              /* context did not safe machine state - no return/restart */
#define __UNWIND_MARK   0x40000000              /* special action on unwind req'd */

/* do not use 0x80000000 - this is a smallInteger; we only have 31 bits */

#define __ANY_REG_USED  (__REGSUSED|__REGSUSED2|__REGSUSED3)

/*
 * string objects
 */
struct __stringHeader {
	STX_OBJ_HEADER
};

struct __String {
	STX_OBJ_HEADER
	unsigned char   s_element[1];
};

/*
 * not used; for gdb debugging only
 */
struct __string10 {
	STX_OBJ_HEADER
	unsigned char   s_element[10];
};

struct __string20 {
	STX_OBJ_HEADER
	unsigned char   s_element[20];
};

#define __StringInstPtr(obj)     ((struct __String *)(__objPtr(obj)))

struct __TwoByteString {
	STX_OBJ_HEADER
	unsigned short s_element[1];
};

#define __TwoByteStringInstPtr(obj)     ((struct __TwoByteString *)(__objPtr(obj)))
#define __Unicode16StringInstPtr(obj)   ((struct __TwoByteString *)(__objPtr(obj)))

struct __FourByteString {
	STX_OBJ_HEADER
	unsigned int s_element[1];
};

#define __FourByteStringInstPtr(obj)    ((struct __FourByteString *)(__objPtr(obj)))
#define __Unicode32StringInstPtr(obj)   ((struct __FourByteString *)(__objPtr(obj)))

/*
 * symbol objects
 */
struct __symbolHeader {
	STX_OBJ_HEADER
};

struct __Symbol {
	STX_OBJ_HEADER
	unsigned char   s_element[1];
};

/*
 * not used; for gdb debugging only
 */
struct __symbol10 {
	STX_OBJ_HEADER
	unsigned char   s_element[10];
};

struct __symbol20 {
	STX_OBJ_HEADER
	unsigned char   s_element[20];
};

#define __SymbolInstPtr(obj)     ((struct __Symbol *)(__objPtr(obj)))

/*
 * character objects
 */
struct __Character {
	STX_OBJ_HEADER
	OBJ             c_asciivalue;
};

#define __CharacterInstPtr(obj)  ((struct __Character *)(__objPtr(obj)))

#ifdef __NEED_FLOATARRAY_ALIGN
# define __FILLTYPE_FLOATARRAY   unsigned int
#endif
#ifdef __NEED_FLOAT_ALIGN
# define __FILLTYPE_FLOAT        unsigned int
#endif
#ifdef __NEED_DOUBLE_ALIGN
# define __FILLTYPE_DOUBLE       unsigned int
#endif
#ifdef __NEED_LONGLONG_ALIGN
# define __FILLTYPE_LONGLONG     unsigned int
#endif

/*
 * float objects
 */
struct __Float {
	STX_OBJ_HEADER
#ifdef __NEED_DOUBLE_ALIGN
	__FILLTYPE_DOUBLE       f_filler;
#endif
	double          f_floatvalue;
};
#define __FloatInstPtr(obj)      ((struct __Float *)(__objPtr(obj)))

/*
 * shortfloat objects (actually Float in ST-80)
 */
struct __ShortFloat {
	STX_OBJ_HEADER
#ifdef __NEED_FLOAT_ALIGN
	__FILLTYPE_FLOAT       f_filler;
#endif
	float           f_floatvalue;
};
#define __ShortFloatInstPtr(obj) ((struct __ShortFloat *)(__objPtr(obj)))

struct __ExtendedFloat {
	STX_OBJ_HEADER
#ifdef __NEED_LONGFLOAT_ALIGN
	__FILLTYPE_LONGFLOAT       f_filler;
#endif
	char            f_efloatBytes[12];      /* 96 bits of extended float */
};
#define __ExtendedFloatInstPtr(obj) ((struct __ExtendedFloat *)(__objPtr(obj)))

struct __FloatArray {
	STX_OBJ_HEADER
#ifdef __NEED_FLOATARRAY_ALIGN
	__FILLTYPE_FLOATARRAY       f_filler;
#endif
	float           f_element[1];
};
#define __FloatArrayInstPtr(obj) ((struct __FloatArray *)(__objPtr(obj)))

// #define __floatArraySize(o)            ((__qSize(o) - (sizeof(struct __FloatArray) - sizeof(float))) / sizeof(float))
// don't do this because "sizeof(struct __FloatArray)" will return the padded size
// but we don't want the padded size (need it for floatArray size computation)
#ifdef __NEED_FLOATARRAY_ALIGN
# define __floatArraySize(o) \
    ((__qSize(o) - OHDR_SIZE - sizeof(__FILLTYPE_FLOATARRAY)) / sizeof(float))
#else
# define __floatArraySize(o) \
    ((__qSize(o) - OHDR_SIZE) / sizeof(float))
#endif

struct __DoubleArray {
	STX_OBJ_HEADER
#ifdef __NEED_DOUBLE_ALIGN
	__FILLTYPE_DOUBLE        f_filler;
#endif
	double          d_element[1];
};
#define __DoubleArrayInstPtr(obj)  ((struct __DoubleArray *)(__objPtr(obj)))
// #define __doubleArraySize(o)            ((__qSize(o) - (sizeof(struct __DoubleArray) - sizeof(double))) / sizeof(double))
// don't do this because "sizeof(struct __FloatArray)" will return the padded size
// but we don't want the padded size (need it for floatArray size computation)
#ifdef __NEED_FLOATARRAY_ALIGN
# define __doubleArraySize(o) \
    ((__qSize(o) - OHDR_SIZE - sizeof(__FILLTYPE_DOUBLE)) / sizeof(double))
#else
# define __doubleArraySize(o) \
    ((__qSize(o) - OHDR_SIZE) / sizeof(double))
#endif

struct __WordArray {
	STX_OBJ_HEADER
	unsigned short  s_element[1];
};
#define __WordArrayInstPtr(obj)    ((struct __WordArray *)(__objPtr(obj)))

struct __SignedWordArray {
	STX_OBJ_HEADER
	short   s_element[1];
};
#define __SignedWordArrayInstPtr(obj)   ((struct __SignedWordArray *)(__objPtr(obj)))

struct __IntegerArray {
	STX_OBJ_HEADER
	unsigned int  i_element[1];
};
#define __IntegerArrayInstPtr(obj)    ((struct __IntegerArray *)(__objPtr(obj)))

struct __SignedIntegerArray {
	STX_OBJ_HEADER
	int   i_element[1];
};
#define __SignedIntegerArrayInstPtr(obj)   ((struct __SignedIntegerArray *)(__objPtr(obj)))

struct __LongIntegerArray {
	STX_OBJ_HEADER
#ifdef __NEED_LONGLONG_ALIGN
       __FILLTYPE_LONGLONG        f_filler;
#endif
	__uint64__  i_element[1];
};
#define __LongIntegerArrayInstPtr(obj)    ((struct __LongIntegerArray *)(__objPtr(obj)))

// #define __longIntegerArraySize(o)       ((__qSize(o) - (sizeof(struct __LongIntegerArray) - sizeof(__uint64__))) / sizeof(__uint64__))
// don't do this because "sizeof(struct __FloatArray)" will return the padded size
// but we don't want the padded size (need it for floatArray size computation)
#ifdef __NEED_LONGLONG_ALIGN
# define __longIntegerArraySize(o) \
    ((__qSize(o) - OHDR_SIZE - sizeof(__FILLTYPE_LONGLONG)) / sizeof(__uint64__))
#else
# define __longIntegerArraySize(o) \
    ((__qSize(o) - OHDR_SIZE) / sizeof(__uint64__))
#endif

struct __SignedLongIntegerArray {
	STX_OBJ_HEADER
#ifdef __NEED_LONGLONG_ALIGN
       __FILLTYPE_LONGLONG        f_filler;
#endif
	__int64__   i_element[1];
};
#define __SignedLongIntegerArrayInstPtr(obj)   ((struct __SignedLongIntegerArray *)(__objPtr(obj)))

//#define __signedLongIntegerArraySize(o) ((__qSize(o) - (sizeof(struct __SignedLongIntegerArray) - sizeof(__int64__))) / sizeof(__int64__))
// don't do this because "sizeof(struct __FloatArray)" will return the padded size
// but we don't want the padded size (need it for floatArray size computation)
#ifdef __NEED_LONGLONG_ALIGN
# define __signedLongIntegerArraySize(o) \
    ((__qSize(o) - OHDR_SIZE - sizeof(__FILLTYPE_LONGLONG)) / sizeof(__int64__))
#else
# define __signedLongIntegerArraySize(o) \
    ((__qSize(o) - OHDR_SIZE) / sizeof(__int64__))
#endif

/*
 * fraction objects
 */
struct __Fraction {
	STX_OBJ_HEADER
	OBJ             f_numerator;
	OBJ             f_denominator;
};

#define __FractionInstPtr(obj)   ((struct __Fraction *)(__objPtr(obj)))

/*
 * fixedPoint objects (inherit from fraction; structure must match)
 */
struct __FixedPoint {
	STX_OBJ_HEADER
	OBJ             f_numerator;
	OBJ             f_denominator;
	OBJ             f_scale;
};

#define __FixedPointInstPtr(obj)   ((struct __FixedPoint *)(__objPtr(obj)))

/*
 * largeInt objects
 */
struct __LargeInteger {
	STX_OBJ_HEADER
	OBJ             l_sign;
	OBJ             l_digits;
};
#define __LargeIntegerInstPtr(obj)   ((struct __LargeInteger *)(__objPtr(obj)))

/*
 * externalBytes objects
 */
struct __ExternalBytes {
	STX_OBJ_HEADER
	void            *e_address;
	OBJ              e_size;
};
#define __ExternalBytesInstPtr(obj)   ((struct __ExternalBytes *)(__objPtr(obj)))

struct __ExternalAddress {
	STX_OBJ_HEADER
	void            *e_address;
};
#define __ExternalAddressInstPtr(obj)   ((struct __ExternalAddress *)(__objPtr(obj)))

/*
 * executableFunction objects
 */
struct __ExecutableFunction {
	STX_OBJ_HEADER
	void            *e_address;
};
#define __ExecutableFunctionInstPtr(obj)   ((struct __ExecutableFunction *)(__objPtr(obj)))

/*
 * externalFunction objects
 */
struct __ExternalFunction {
	STX_OBJ_HEADER
	void            *e_address;
	OBJ              e_name;
	OBJ              e_moduleID;
};
#define __ExternalFunctionInstPtr(obj)   ((struct __ExternalFunction *)(__objPtr(obj)))

/*
 * message objects (created for doesNotUnderstand)
 */
struct __Message {
	STX_OBJ_HEADER
	OBJ             m_selector;
	OBJ             m_args;
};
#define __MessageInstPtr(obj)    ((struct __Message *)(__objPtr(obj)))

/*
 * point objects
 */
struct __Point {
	STX_OBJ_HEADER
	OBJ             p_x;
	OBJ             p_y;
};
#define __PointInstPtr(obj)      ((struct __Point *)(__objPtr(obj)))


/* Java support: JavaRef2 objects... */

#define JAVAREF_INSTS                   \
	OBJ jr_resolvedValue;           \
	OBJ jr_constantPool;            \

struct __JavaRef {
	STX_OBJ_HEADER
	JAVAREF_INSTS
};
#define __JavaRefInstPtr(obj)      ((struct __JavaRef *)(__objPtr(obj)))
#define JAVA_REF_RESOLVED_VALUE(r)      (__JavaRefInstPtr(r)->jr_resolvedValue)

#define JAVACLASSMEMBERREF_INSTS        \
	JAVAREF_INSTS                   \
	OBJ jr_classRefIndex;           \
	OBJ jr_nameAndTypeIndex;        \
	OBJ jr_resolvedClass;           \
	OBJ jr_type;                    \

struct __JavaClassRef {
	STX_OBJ_HEADER
	JAVAREF_INSTS
	OBJ     jr_nameIndex;
};
#define __JavaClassRefInstPtr(obj)      ((struct __JavaClassRef *)(__objPtr(obj)))
#define JAVA_CLASSREF_RESOLVED_CLASS(r) JAVA_REF_RESOLVED_VALUE(r)

struct __JavaFieldRef {
	STX_OBJ_HEADER
	JAVACLASSMEMBERREF_INSTS
	OBJ jr_resolvedOffset;
};
#define __JavaFieldRefInstPtr(obj)        ((struct __JavaFieldRef *)(__objPtr(obj)))
#define JAVA_FIELDREF_RESOLVED_FIELD(r)  JAVA_REF_RESOLVED_VALUE(r)
#define JAVA_FIELDREF_RESOLVED_CLASS(r)  (__JavaFieldRefInstPtr(r)->jr_resolvedClass)
#define JAVA_FIELDREF_RESOLVED_OFFSET(r) (__JavaFieldRefInstPtr(r)->jr_resolvedOffset)
#define JAVA_FIELDREF_TYPE(r)            (__JavaFieldRefInstPtr(r)->jr_type)


struct __JavaMethodRef {
	STX_OBJ_HEADER
	JAVACLASSMEMBERREF_INSTS
	OBJ jr_selector;
	OBJ jr_numArgSlots;
};

#define __JavaMethodRefInstPtr(obj)      ((struct __JavaMethodRef *)(__objPtr(obj)))
#define JAVA_METHODREF_RESOLVED_METHOD(r) JAVA_REF_RESOLVED_VALUE(r)
#define JAVA_METHODREF_RESOLVED_CLASS(r)  (__JavaMethodRefInstPtr(r)->jr_resolvedClass)
#define JAVA_METHODREF_SELECTOR(r)        (__JavaMethodRefInstPtr(r)->jr_selector)
#define JAVA_METHODREF_NUMARGSLOTS(r)     (__JavaMethodRefInstPtr(r)->jr_numArgSlots)
#define JAVA_METHODREF_TYPE(r)            (__JavaMethodRefInstPtr(r)->jr_type)



/*
 * representation of objects
 *
 * SmallIntegers are represented by having the TAG_INT bit set;
 * depending on the valid range for pointers in the system, this can
 * be better put into the sign-bit or into bit0
 * (always possible, since all objects are aligned on word boundary).
 *
 * putting it into the sign bit makes the _isSmallInteger macro faster,
 * since it will expand to a 'branch-if-positive' instead of 'bitmask & test'
 * instruction on many machines.
 * But its only possible, if addresses are below 2giga (which may not be true for
 * stack and/or shared libraries.
 *
 * currently high-bit tags are only used on NeXT,
 * all others use low-bit tags.
 */

#ifdef INT_TAG_ZERO

# define TAG_INT        0
# define TAG_OBJ        1
# if __POINTER_SIZE__ == 8
#  define SIGN_BIT       0x8000000000000000L
# else
#  define SIGN_BIT       0x80000000
# endif
# define RESTART_VALUE  ((OBJ)3)
# undef POSITIVE_ADDRESSES
# undef NEGATIVE_ADDRESSES

#else

# ifdef POSITIVE_ADDRESSES
  /*
   * all addresses positive:
   * ints have high bit (TAG-bit) set, value in bits 0 to 30
   */
#  define TAG_OBJ       0
#  if __POINTER_SIZE__ == 8
#   define TAG_INT       0x8000000000000000L
#   define SIGN_BIT      0x4000000000000000L
#  else
#   define TAG_INT       0x80000000
#   define SIGN_BIT      0x40000000
#  endif
#  define RESTART_VALUE ((OBJ)1)
# else
#  ifdef NEGATIVE_ADDRESSES
  /*
   * all addresses negative:
   * ints have high bit (TAG-bit) clear, value in bits 0 to 30
   * (currently only transputer does this)
   */
#   define TAG_OBJ      0x80000000
#   define TAG_INT      0
#   if __POINTER_SIZE__ == 8
#    define SIGN_BIT     0x4000000000000000L
#   else
#    define SIGN_BIT     0x40000000
#   endif
#   define RESTART_VALUE        ((OBJ)1)
#  else
  /*
   * range of addresses not bound (but aligned !):
   * ints have low bit (TAG-bit) set, value in bits 1 to 31
   */
#   define TAG_OBJ     0
#   define TAG_INT     1
#   define TAG_INT_1
#   if __POINTER_SIZE__ == 8
#    define SIGN_BIT     0x8000000000000000L
#   else
#    define SIGN_BIT     0x80000000
#   endif
#   define RESTART_VALUE        ((OBJ)2)
#  endif
# endif
#endif
#define TAG_MASK    TAG_INT

#ifdef NIL_IS_OBJECT
 /*
  * this is currently neither implemented nor tested -
  * just an idea, if dereferencing NULL is ok, we can make nil
  * a real object and get rid of special checks below ...
  */
 extern OBJ nil;
#else
# ifdef NEGATIVE_ADDRESSES
#  define nil (OBJ)(TAG_OBJ)
# else
#  ifdef INT_TAG_ZERO
#   define nil (OBJ)(TAG_OBJ)
#  else
#   define nil (OBJ)(0)
#  endif
# endif
#endif

/*
 * some useful macros
 */

#ifdef POSITIVE_ADDRESSES
# define __isObject(o)           (((INT)(o)) >= 0)
# define __isSmallInteger(o)     (((INT)(o)) < 0)
# ifdef aix
   /* avoid aix's stupid cc-optimizer bug ... */
#  define __isNonNilObject(o)    ((o != nil) && !__isSmallInteger(o))
#  define __QisNonNilObject(o)   (((INT)(o)) > 0)
# else
#  define __isNonNilObject(o)    (((INT)(o)) > 0)
# endif
#else
# ifdef NEGATIVE_ADDRESSES
#  define __isObject(o)          (((INT)(o)) < 0)
#  define __isNonNilObject(o)    ((((INT)(o)) < 0) && ((o) != nil))
#  define __isSmallInteger(o)    (((INT)(o)) >= 0)
# else
#  define __tag(o)               ((INT)(o) & TAG_MASK)
#  define __isObject(o)          (__tag(o)==TAG_OBJ)
#  define __isNonNilObject(o)    ((__tag(o)==TAG_OBJ) && ((o) != nil))
#  define __isSmallInteger(o)    ((INT)(o) & TAG_INT)
# endif
#endif

/*
 * the following does it with a single rotl instruction
 * and a single conditional branch
 * but probably only useful, if rorl is detected by compiler and a rotate
 * insn is generated.
 */
#ifdef __COMPILER_OPTIMIZES_ROTATE__

# define __N_BITS_PER_POINTER__ (__POINTER_SIZE__ * 8)

# define _rotr1(uiVal) \
    (((uiVal) >> 1) | ((uiVal) << (__N_BITS_PER_POINTER__-1)))

# undef __isNonNilObject

# define __isNonNilObject(o) \
    ((INT)(_rotr1( ((unsigned INT)(o)))) > 0)

#endif

/*
 * well, a workaround for AIX's cc-optimizer bug ...
 */
#ifndef __QisNonNilObject
# define __QisNonNilObject(o) __isNonNilObject(o)
#endif

/*
 * comparing two OBJs for being smallInteger can be done faster;
 * the macro below only creates one conditional branch; thus having slightly
 * less effect on instruction pipelines on many machines.
 */
#ifdef TAG_INT_1
# define __areSmallInteger2(o1, o2)     ( (INT)(o1) & (INT)(o2) & TAG_INT )
# define __areSmallInteger3(o1, o2, o3) ( (INT)(o1) & (INT)(o2) & (INT)(o3) & TAG_INT )
#else
# ifdef POSITIVE_ADDRESSES
#  define __areSmallInteger2(o1, o2)    ( ((INT)(o1) & (INT)(o2)) < 0)
#  define __areSmallInteger3(o1, o2)    ( ((INT)(o1) & (INT)(o2) & (INT)(o3)) < 0)
# else
#  define __areSmallInteger2(o1, o2)     (__isSmallInteger(o1) && __isSmallInteger(o2))
#  define __areSmallInteger3(o1, o2, o3) (__isSmallInteger(o1) && __isSmallInteger(o2) && __isSmallInteger(o3))
# endif
#endif
#define __areSmallInteger(o1, o2)      (__areSmallInteger2(o1, o2))
#define __bothSmallInteger(o1, o2)     (__areSmallInteger(o1, o2))

#define __qSpace(o)              (__GET_SPACE(__objPtr(o)))
#define __isRemembered(o)        (__objPtr(o)->o_flags & F_ISREMEMBERED)
#define __isForwarded(o)         (__objPtr(o)->o_flags & F_ISFORWARDED)
#define __markForwarded(o)       (__objPtr(o)->o_flags |= F_ISFORWARDED)
#define __markUnforwarded(o)     (__objPtr(o)->o_flags &= ~F_ISFORWARDED)
#define __isDereferenced(o)      (__objPtr(o)->o_flags & F_DEREFERENCED)
#define __isImmutable(o)         (__objPtr(o)->o_flags & F_IMMUTABLE)
#define __beImmutable(o)         (__objPtr(o)->o_flags |= F_IMMUTABLE)
#define __beMutable(o)           (__objPtr(o)->o_flags &= ~F_IMMUTABLE)

#define __flags(c)               (__ContextInstPtr(c)->c_flags)
#define __specialContext(c)      ((INT)__flags(c) & __MASKSMALLINT(__SPECIAL))

/*
 * initialize __moreFlags when setting __SPECIAL
 * CONPRIVATE data is only available, if context is on stack.
 */
#define __markSpecial2(c, additionalFlags) \
	(((!__specialContext(c) && __isStackCon(c)) ? (CONPRIVATE(c)->__moreFlags = (INT)0) : (INT)0), \
	 (__flags(c) = (OBJ)((INT)__flags(c) | __MASKSMALLINT(__SPECIAL|(additionalFlags)))))

#define __markSpecial(c)         __markSpecial2(c, 0)
#define __markInterrupted(c)     __markSpecial(c)
#define __markNonLIFO(c)         __markSpecial2(c, __NONLIFO)
#define __isNonLIFO(c)           ((INT)(__ContextInstPtr(c)->c_flags) & __MASKSMALLINT(__NONLIFO))
#define __isLazy(c)              ((INT)(__ContextInstPtr(c)->c_flags) & __MASKSMALLINT(__MASK_LAZY))
#define __isLazyMCon(c)          (((INT)(__ContextInstPtr(c)->c_flags) & __MASKSMALLINT(__MASK_LAZY)) == __MASKSMALLINT(__LAZYMCON))
#define __isLazyBCon(c)          (((INT)(__ContextInstPtr(c)->c_flags) & __MASKSMALLINT(__MASK_LAZY)) == __MASKSMALLINT(__LAZYBCON))
#define __isLazyJCon(c)          (((INT)(__ContextInstPtr(c)->c_flags) & __MASKSMALLINT(__MASK_LAZY)) == __MASKSMALLINT(__LAZYJCON))
#define __isStackCon(c)          (__isLazy(c) || __qSpace(c) >= STACKSPACE)

#define __qSize(o)               (__objPtr(o)->o_size)
#define __Size(o)                (__isNonNilObject(o) ? __qSize(o) : 0)

#define __qClass(o)              (OBJ)(__objPtr(o)->o_class)
#define __nClass(o)              (__isSmallInteger(o) ? SmallInteger : __qClass(o))
#define __iClass(o)              ((o == nil) ? UndefinedObject : __qClass(o))
#define __stx_setClass(o,c)      (__objPtr(o)->o_class = ((CLASS_OBJ)(c)))

#define __HASCLASS(o, c)         (__isNonNilObject(o) && (c)==__qClass(o))

#if defined(NIL_IS_OBJECT)
# define __Class(o)              (__isSmallInteger(o) ?               \
				    SmallInteger :                   \
				    __qClass(o)                       \
				)
#else
# if defined(READ_THROUGH_0_OK) && defined(WRITE_THROUGH_0_OK)

#  define __Class(o)             (__isSmallInteger(o) ?               \
				    SmallInteger :                   \
				    __qClass(o)                       \
				 )
# else
#  ifdef XXX__GNUC__
#   define __Class(o)            ({  OBJ __t__ = o;                  \
				 __isSmallInteger(__t__) ?           \
				    SmallInteger :                   \
				    ((__t__ == nil) ?                \
					UndefinedObject :            \
					__qClass(__t__)              \
				    );                               \
				})
#  else
#   ifdef OLD
#    define __Class(o)          (__isSmallInteger(o) ?               \
				    SmallInteger :                   \
				    ((o == nil) ?                    \
					UndefinedObject :            \
					__qClass(o)                  \
				    )                                \
				)
#   else
#    define __Class_probInt(o)  (__isSmallInteger(o) ?               \
				    SmallInteger :                   \
				    ((o == nil) ?                    \
					UndefinedObject :            \
					__qClass(o)                  \
				    )                                \
				)

#    define __Class_probNil(o)  ((o==nil) ?                          \
				    UndefinedObject :                \
				    (__isSmallInteger(o) ?           \
					SmallInteger :               \
					__qClass(o)                  \
				    )                                \
				)

#    define __Class_probObj(o)  (! __isSmallInteger(o) ?             \
				    ((o != nil) ?                    \
					__qClass(o) :                \
					UndefinedObject              \
				    ) :                              \
				    SmallInteger                     \
				)

#    define __Class(o)  __Class_probObj(o)

#   endif
#  endif
# endif
#endif

#include "stxTypeMacros.h"

/*
 * converting integers from object-world to c-world
 */
#ifdef POSITIVE_ADDRESSES
# ifdef SIGNED_SHIFTS
#  define __smallIntegerVal(i)         (((INT)(i)<<N_TAG_BITS)>>N_TAG_BITS)
# else
#  define __smallIntegerVal(i)         (((INT)(i) & SIGN_BIT) ? (INT)(i) : ((INT)(i) &~ TAG_INT))
# endif
#else
# ifdef NEGATIVE_ADDRESSES
#  ifdef SIGNED_SHIFTS
#   define __smallIntegerVal(i)        (((INT)(i)<<N_TAG_BITS)>>N_TAG_BITS)
#  else
#   define __smallIntegerVal(i)        (((INT)(i) & SIGN_BIT) ? ((INT)(i) | TAG_OBJ) : (INT)(i))
#  endif
# else
#  ifdef SIGNED_SHIFTS
#   define __smallIntegerVal(i)         ((INT)(i)>>N_TAG_BITS)
#  else
#   define __smallIntegerVal(i)         (((INT)(i) < 0) ?                  \
					  ((INT)(i)>>N_TAG_BITS) | SIGN_BIT   \
					  : ((INT)(i)>>N_TAG_BITS))
#  endif
# endif
#endif

#define __intVal(i)      __smallIntegerVal(i)

/*
 * converting integers from c-world to object-world
 */
#ifdef POSITIVE_ADDRESSES
# define __mkSmallInteger(i)     (OBJ)(((INT)(i)) | TAG_INT)
# define __MASKSMALLINT(i)       (INT)(i)
#else
# ifdef NEGATIVE_ADDRESSES
#  define __mkSmallInteger(i)    (OBJ)((INT)(i))
#  define __MASKSMALLINT(i)      (INT)(i)
# else
#  define __mkSmallInteger(i)    (OBJ)((((unsigned INT)(i))<<N_TAG_BITS) | TAG_INT)
#  define __MASKSMALLINT(i)      ((unsigned INT)(i)<<N_TAG_BITS)
# endif
#endif
#define __MKSMALLINT(i) __mkSmallInteger(i)

#define __floatVal(f)        (__FloatInstPtr(f)->f_floatvalue)
#define __shortFloatVal(f)   (__ShortFloatInstPtr(f)->f_floatvalue)
#define __characterVal(c)    (__CharacterInstPtr(c)->c_asciivalue)
#define __point_X(p)         (__PointInstPtr(p)->p_x)
#define __point_Y(p)         (__PointInstPtr(p)->p_y)

#define __stringVal(s)          (__StringInstPtr(s)->s_element)
#define __symbolVal(s)          (__SymbolInstPtr(s)->s_element)
#define __twoByteStringVal(s)   (__TwoByteStringInstPtr(s)->s_element)
#define __unicode16StringVal(s) (__Unicode16StringInstPtr(s)->s_element)
#define __unicode32StringVal(s) (__Unicode32StringInstPtr(s)->s_element)

#define __byteArrayVal(o)           (__ByteArrayInstPtr(o)->ba_element)
#define __arrayVal(o)               (__ArrayInstPtr(o)->a_element)
#define __integerArrayVal(o)        (__IntegerArrayInstPtr(o)->i_element)

#define __stringSize(s)                 (__qSize(s) - OHDR_SIZE - 1)
#define __twoByteStringSize(s)          ((__qSize(s) - OHDR_SIZE) / 2)
#define __fourByteStringSize(s)         ((__qSize(s) - OHDR_SIZE) / 4)
#define __unicode16StringSize(s)        ((__qSize(s) - OHDR_SIZE) / 2)
#define __unicode32StringSize(s)        ((__qSize(s) - OHDR_SIZE) / 4)
#define __arraySize(s)                  (__BYTES2OBJS__(__qSize(s) - OHDR_SIZE))
#define __byteArraySize(s)              (__qSize(s) - OHDR_SIZE)
#define __wordArraySize(s)              ((__qSize(s) - OHDR_SIZE) / sizeof(short))
#define __integerArraySize(s)           ((__qSize(s) - OHDR_SIZE) / sizeof(int))

#define __executableFunctionVal(o)  (__ExecutableFunctionInstPtr(o)->e_address)
#define __externalFunctionVal(o)    (__ExternalFunctionInstPtr(o)->e_address)
#define __externalAddressVal(o)     (__ExternalAddressInstPtr(o)->e_address)
#define __externalBytesAddress(o)   (__ExternalBytesInstPtr(o)->e_address)
#define __externalBytesVal(o)       (__ExternalBytesInstPtr(o)->e_address)
#define __externalBytesSize(o)      (__ExternalBytesInstPtr(o)->e_size)

/*
 * Pointer to first indexed instvar
	   and last+1 indexed instvar of obj
 */
#define __IInstVarPtr(o)        (__InstPtr(o)->i_instvars +                            \
				   __smallIntegerVal(__ClassInstPtr(__qClass(o))->c_ninstvars))
#define __IInstVarEnd(o)        ((OBJ)((char *)__objPtr(o) + __qSize(o)))


#ifdef POSITIVE_ADDRESSES
/*
 * tag in high-bit: bit 30 of OBJ reflects sign of integer
 */
# define __isPositiveIfSmallInteger(o) (((INT)o << 1) > 0)
# define __isPositiveSmallInteger(o)   (((INT)o & (SIGN_BIT | TAG_INT)) == (SIGN_BIT | TAG_INT))
# define __isNegativeSmallInteger(o)   (((INT)o & (SIGN_BIT | TAG_INT)) == TAG_INT)
#else
# ifdef NEGATIVE_ADDRESSES
# else
/*
 * tag in low-bit: sign of OBJ reflects sign of integer
 */
#  define __isPositiveIfSmallInteger(o) ((INT)(o) > (INT)(__MKSMALLINT(0)))
#  define __isPositiveSmallInteger(o) (__isSmallInteger(o) && ((INT)(o) > (INT)(__MKSMALLINT(0))))
#  define __isNegativeSmallInteger(o) (__isSmallInteger(o) && ((INT)(o) < (INT)(__MKSMALLINT(0))))
# endif
#endif

#ifndef __isPositiveSmallInteger
# define __isPositiveIfSmallInteger(o)  (__smallIntegerVal(o) > 0)
# define __isPositiveSmallInteger(o)    (__isSmallInteger(o) && (__smallIntegerVal(o) > 0))
# define __isNegativeSmallInteger(o)    (__isSmallInteger(o) && (__smallIntegerVal(o) < 0))
#endif

/*
 *******************************************************************
 * begin of backward compatibility section
 *
 * in early versions, we used _XXX macros.
 * these make problems on some systems.
 * Therefore, we now use __XXX macros.
 *
 * During migration, both macros are supported,
 * but REMEMBER to replace the _XX's by __XX
 *
 * THE FOLLOWING DEFINITIONS WILL BE REMOVED SOON
 * **********************************************
 */
#define xxxTRAP_OBSOLETE_MACROS

#ifdef TRAP_OBSOLETE_MACROS
# define __OBSOLETE    error error
#else
# define __OBSOLETE    /* nothing */
#endif

#define _qSpace(o)                  __OBSOLETE __qSpace(o)

#define _Size(o)                    __OBSOLETE __Size(o)
/* #define _qSize(o)                   __OBSOLETE __qSize(o) */
#define _qClass(o)                  __OBSOLETE __qClass(o)
#define _nClass(o)                  __OBSOLETE __nClass(o)
#define _iClass(o)                  __OBSOLETE __iClass(o)
#define _HASCLASS(o, c)             __OBSOLETE __HASCLASS(o, c)
/* #define _Class(o)                   __OBSOLETE __Class(o) */

#define _markNonLIFO(c)             __OBSOLETE __markNonLIFO(c)
#define _isNonLIFO(c)               __OBSOLETE __isNonLIFO(c)

#ifdef COMPATIBLE_MACROS
# define _isObject(o)                __OBSOLETE __isObject(o)
#endif

#define _isNonNilObject(o)          __OBSOLETE __isNonNilObject(o)
#define _isSmallInteger(o)          __OBSOLETE __isSmallInteger(o)
#define _bothSmallInteger(o1, o2)   __OBSOLETE __bothSmallInteger(o1, o2)

#define _intVal(i)                   __OBSOLETE __smallIntegerVal(i)
#define _floatVal(f)                 __OBSOLETE __floatVal(f)
#define _characterVal(c)             __OBSOLETE __characterVal(c)
#define _point_X(p)                  __OBSOLETE __point_X(p)
#define _point_Y(p)                  __OBSOLETE __point_Y(p)
#define _stringVal(s)                __OBSOLETE __stringVal(s)
#define _symbolVal(s)                __OBSOLETE __symbolVal(s)
#define _stringSize(s)               __OBSOLETE __stringSize(s)
#define _arraySize(s)                __OBSOLETE __arraySize(s)
#define _byteArraySize(s)            __OBSOLETE __byteArraySize(s)

#define _MKSMALLINT(__i__)           __OBSOLETE __MKSMALLINT(__i__)
#define _MASKSMALLINT(__i__)         __OBSOLETE __MASKSMALLINT(__i__)
#define _MKOBJPTR(__x__)             __OBSOLETE __MKOBJPTR(__x__)
#define _MKCHARACTER(__i__)          __OBSOLETE __MKCHARACTER(__i__)
#define _MKLARGEINT(__i__)           __OBSOLETE __MKLARGEINT(__i__)
#define _MKULARGEINT(__u__)          __OBSOLETE __MKULARGEINT(__u__)

#define _objPtr(obj)               __OBSOLETE __objPtr(obj)
#define _InstPtr(obj)              __OBSOLETE __InstPtr(obj)
#define _ClassInstPtr(obj)         __OBSOLETE __ClassInstPtr(obj)
#define _MetaclassInstPtr(obj)     __OBSOLETE __MetaclassInstPtr(obj)
#define _ClassName(cobj)           __OBSOLETE __ClassName(cobj)
#define _ArrayInstPtr(obj)         __OBSOLETE __ArrayInstPtr(obj)
#define _ByteArrayInstPtr(obj)     __OBSOLETE __ByteArrayInstPtr(obj)
#define _MethodInstPtr(obj)        __OBSOLETE __MethodInstPtr(obj)
#define _BlockInstPtr(obj)         __OBSOLETE __BlockInstPtr(obj)
#define _CheapBlockInstPtr(obj)    __OBSOLETE __CheapBlockInstPtr(obj)
#define _ContextInstPtr(obj)       __OBSOLETE __ContextInstPtr(obj)
#define _StringInstPtr(obj)        __OBSOLETE __StringInstPtr(obj)
#define _SymbolInstPtr(obj)        __OBSOLETE __SymbolInstPtr(obj)
#define _CharacterInstPtr(obj)     __OBSOLETE __CharacterInstPtr(obj)
#define _FloatInstPtr(obj)         __OBSOLETE __FloatInstPtr(obj)
#define _ShortFloatInstPtr(obj)    __OBSOLETE __ShortFloatInstPtr(obj)
#define _FractionInstPtr(obj)      __OBSOLETE __FractionInstPtr(obj)
#define _LargeIntegerInstPtr(obj)  __OBSOLETE __LargeIntegerInstPtr(obj)
#define _FloatArrayInstPtr(obj)    __OBSOLETE __FloatArrayInstPtr(obj)
#define _DoubleArrayInstPtr(obj)   __OBSOLETE __DoubleArrayInstPtr(obj)
#define _MessageInstPtr(obj)       __OBSOLETE __MessageInstPtr(obj)
#define _PointInstPtr(obj)         __OBSOLETE __PointInstPtr(obj)
#define _INST(name)                __OBSOLETE __INST(name)
#define _CINST(name)               __OBSOLETE __CINST(name)

#define _MKSTRING(charPtr)         __OBSOLETE __MKSTRING(charPtr)
#define _MKFLOAT(fval)             __OBSOLETE __MKFLOAT(fval)

#ifdef __LSBFIRST__
# define PACK_BB_S(bL, bH)                  ((unsigned short)((bL) | ((bH)<<8)))
# define PACK_BBBB_I(bLL, bLH, bHL, bHH)    ((unsigned int)((bLL) | ((bLH)<<8) | ((bHL)<<16) | ((bHH)<<24)))
#else
# ifdef __MSBFIRST__
#  define PACK_BB_S(bL, bH)                 ((unsigned short)((bH) | ((bL)<<8)))
#  define PACK_BBBB_I(bLL, bLH, bHL, bHH)   ((unsigned int)((bHH) | ((bHL)<<8) | ((bLH)<<16) | ((bLL)<<24)))
# else
#  error "either LSBFIRST or MSBFIRST must be defined"
# endif
#endif


/*
 * end of backward compatibility section
 *******************************************************************/

#ifdef POSITIVE_ADDRESSES
# define _ADD_INT(var, con)     ((OBJ) ((INT)(var) + (con)))
# define _SUB_INT(var, con)     ((OBJ) ((INT)(var) - (con)))
#else
# ifdef NEGATIVE_ADDRESSES
#  define _ADD_INT(var, con)    __MKSMALLINT(__smallIntegerVal(var) + (con))
#  define _SUB_INT(var, con)    __MKSMALLINT(__smallIntegerVal(var) - (con))
# else
#  define _ADD_INT(var, con)    ((OBJ) ((INT)(var) + ((con)<<N_TAG_BITS)))
#  define _SUB_INT(var, con)    ((OBJ) ((INT)(var) - ((con)<<N_TAG_BITS)))
# endif
#endif

/*
 * wrapping C-pointers as smalltalk objects,
 * and extracting the address again
 */
#define __MKOBJ(ptr) __MKEXTERNALADDRESS(ptr)
#define __MKCP(o)    __externalAddressVal(o)

/*
 * extracting a FILE *
 */
#define __FILEVal(o)  (FILE *)__MKCP(o)

/*
 * does not work yet
 */
#undef RETVAL_IN_REGISTER
#define NO_ASM_REGISTER_VARS

#ifndef NO_ASM_REGISTER_VARS

# ifdef THIS_CONTEXT
#  if defined(mc68k) && defined(__GNUC__)
    register OBJ __thisContext asm("a5");
#   define THISCONTEXT_IN_REGISTER
    register OBJ __retValTmp   asm("a4");
#   define RETVAL_IN_REGISTER
#  else
#   if defined(sparc) && defined(__GNUC__)
     register OBJ __thisContext asm("%g5");
#    define THISCONTEXT_IN_REGISTER
     register OBJ __retValTmp   asm("%g6");
#    define RETVAL_IN_REGISTER
#   else
#    undef THISCONTEXT_IN_REGISTER
#   endif
#  endif
# endif

#else /* NO_ASM_REGISTER_VARS */

# ifdef THIS_CONTEXT
#  undef THISCONTEXT_IN_REGISTER
# endif

#endif

#ifndef NO_ASM_REGISTER_VARS
# if defined(mc68k) && defined(__GNUC__)
#  if !defined(__ALL_REGISTERS__)
    register OBJ __d7       asm("d7");
    register OBJ __d6       asm("d6");
    register OBJ __d5       asm("d5");
#   ifndef RETVAL_IN_REGISTER
     register OBJ __a4       asm("a4");
#   endif
#  endif
# endif
#endif

#if defined(sparc) && defined(__GNUC__) && defined(__LOCAL_REGISTERS__)
 register OBJ __Reg_receiver     asm("%l0");
 register OBJ __Reg_selector     asm("%l1");
 register OBJ __Reg_searchclass  asm("%l2");
 register OBJ __Reg_sender       asm("%l3");
 register OBJ __Reg_v0           asm("%l4");
 register OBJ __Reg_v1           asm("%l5");
#endif
#define N_REG_AVAILABLE 6

#if 0
#if defined(hppa) && defined(__GNUC__)
# if !defined(__ALL_REGISTERS__)
 register OBJ __R9              asm("%r9");
 register OBJ __R10             asm("%r10");
 register OBJ __R11             asm("%r11");
 register OBJ __R12             asm("%r12");
 register OBJ __R13             asm("%r13");
 register OBJ __R14             asm("%r14");
 register OBJ __R15             asm("%r15");
 register OBJ __R16             asm("%r16");
 register OBJ __R17             asm("%r17");
 register OBJ __R18             asm("%r18");
# endif
#endif
#endif

#define MAX_IMMEDIATE_CHARACTER     0xFF

extern OBJ __CharacterTable[];
#define __MKCHARACTER(code)      (__CharacterTable[(unsigned INT)(code)])
extern OBJ __MKUCHARACTER();

/*
 * use fastcall for some simple functions
 */
#if defined(WIN32) && defined(__USE_FAST_CALL__)

# define  __FASTCALL    __fastcall
  extern OBJ __fastcall __fast__store();
  extern OBJ __fastcall __fast__storeInst0();
  extern OBJ __fastcall __fast__storeInst1();
  extern OBJ __fastcall __fast__storeInst2();
  extern OBJ __fastcall __fast__storeInst3();
  extern OBJ __fastcall __fast__storeInst4();
  extern OBJ __fastcall __fast__storeInst5();
#else
# define  __FASTCALL    /* nothing */
# define  __fast__store(__d__, __p__)   __store(__d__, __p__)
#endif

extern OBJ __store();

#ifdef __OPTSPACE3__
# define __STORE(dst, obj)      (__isNonNilObject(obj) ? (__fast__store(dst, obj), (obj)) : (obj))
#else
# define __STORE(dst, obj)      ( (__isNonNilObject(obj) && \
				  (__qSpace(dst) < __qSpace(obj))) ? \
				  (__fast__store(dst, obj), (obj)) : (obj) )
#endif

#define __STORE_SPC(dst, obj, dstspc)      ( (__isNonNilObject(obj) && \
				  ((dstspc) < __qSpace(obj))) ? \
				  (__fast__store(dst, obj), (obj)) : (obj) )

#ifdef __OPTSPACE3__
# define __STORESELF(inst)      ( (__isNonNilObject(__INST(inst))) ? \
				  (__fast__store(self, __INST(inst)), \
				  (__INST(inst))) : (__INST(inst)) )
#else
# define __STORESELF(inst)      ( (__isNonNilObject(__INST(inst)) && \
				  (__qSpace(self) < __qSpace(__INST(inst)))) ? \
				  (__fast__store(self, __INST(inst)), \
				  (__INST(inst))) : (__INST(inst)) )
#endif

#ifdef __OPTSPACE3__
# define __qSTORESELF(inst)     (__fast__store(self, __INST(inst)))
#else
# define __qSTORESELF(inst)     ( ((__qSpace(self) < __qSpace(__INST(inst)))) ? \
				  (__fast__store(self, __INST(inst)), \
				  (__INST(inst))) : (__INST(inst)) )
#endif

#define __STOREOINST(o, inst)  ( (__isNonNilObject(__OINST(o, inst)) && \
				  (__qSpace(o) < __qSpace(__OINST(o, inst)))) ? \
				  (__fast__store(o, __OINST(o, inst)), \
				  (__OINST(o, inst))) : (__OINST(o, inst)) )

#define __qSTOREOINST(o, inst)  ( ((__qSpace(o) < __qSpace(__OINST(o, inst)))) ? \
				  (__fast__store(o , __OINST(o, inst)), \
				  (__OINST(o, inst))) : (__OINST(o, inst)) )

#ifdef __OPTSPACE3__
# define __qSTORE(dst, obj)      ( __fast__store(dst, obj) )
#else
# define __qSTORE(dst, obj)      ( ((__qSpace(dst) < __qSpace(obj))) ? \
				  (__fast__store(dst, obj), (obj)) : (obj) )
#endif

#define __GSTORE(obj)           ( (__isNonNilObject(obj) && \
				  (__qSpace(obj))) ? \
				  (__gstore(obj), (obj)) : (obj) )

extern OBJ __gstore(), __gstore2();
#define __GSTORE2(obj)          (__gstore2(obj))

#define __qGSTORE(obj)          ( __qSpace(obj) ? \
				  (__gstore(obj), (obj)) : (obj) )

/*
 * sigh:
 * GCC 2.95 (and others) generate bad code with the following complicated
 * MCSTORE/qMCSTORE macros.
 * Generate a call instead.
 */
#if (defined(__GNUC__) && (__GNUC__ == 2) && (__GNUC_MINOR__ >= 90)) || defined(__OPTSPACE3__)
  extern OBJ __FASTCALL __mcstore();
# define __MCSTORE(con, obj)      (__isNonNilObject(obj) ? __mcstore(con,obj) : (obj))
# define __qMCSTORE(con, obj)     __mcstore(con,obj)
#else
# define __MCSTORE(con, obj)      ( (__isNonNilObject(obj) && \
				    ((! __isLazy(con) && \
				       (__qSpace(con) < STACKSPACE) && \
				       (__qSpace(con) < __qSpace(obj))) \
				    || (__qSpace(obj) & CATCHMARK)) \
				    ) ? __fast__store(con, obj) : (obj) )

# define __qMCSTORE(con, obj)      ( ((! __isLazy(con) && \
					(__qSpace(con) < STACKSPACE) && \
					(__qSpace(con) < __qSpace(obj))) \
				     || (__qSpace(obj) & CATCHMARK)) ? \
				  __fast__store(con, obj) : (obj) )
#endif

#ifdef POLY_CACHE
# define __NP__ ,(void *)0
#else
# define __NP__ /* nothing */
#endif

// #define I_NORMAL    0     /* a normal send */
#define I_SELF    1     /* a send to self */
#define I_SUPER   2     /* a send to super */
#define I_CONST   3     /* a send to a constant (string, float etc.) */
#define I_CLASS   4     /* a send to xxx class */
#define I_RSELF   5     /* a recursive send to self */
#define I_PERF    6     /* a send via #perform */

#ifdef __SUPPORT_DIRECT_ILC
# define I_DIRECT  0x10  /* ORED-in: direct call (JIT special for some architectures) */
#endif
#ifdef __SUPPORT_LDT_TOC_ILC
# define I_LDT_TOC 0x20  /* ORED-in: ptr must be a direct ptr (bit1==0);
			 *          ILC includes LDT/TOC (hpux/aix only) */
#endif

#ifdef METHOD_IN_ILC
# define ILC_FUTURE_METHOD_FIELD        \
	OBJ                 ilc_method; /* experimental - future */
#else
# define ILC_FUTURE_METHOD_FIELD        \
	/* not yet used or needed */
#endif

#define ILC_COMMON_FIELDS \
	OBJFUNC             ilc_func;   \
	CLASS_OBJ           ilc_class;  \
	struct inlineCache *ilc_link;   \
	OBJ                 ilc_lineNo; \
	void               *ilc_poly;   \
	ILC_FUTURE_METHOD_FIELD

struct inlineCache {
	ILC_COMMON_FIELDS
};

/*
 * macros to access lineNo & flags from ilc_linenNo field
 * and compose one from given lineNo & flags ...
 */
#define __MK_ILCLNO(n)              __MKSMALLINT(n)
#define __DEF_ILCLNO(n, flags)      __MKSMALLINT(((n & 0xFFFF)| (flags<<16)))
#define __SET_ILCLNO(pIlc, n)       ((pIlc)->ilc_lineNo = __MKSMALLINT(((n & 0xFFFF)|(__smallIntegerVal((pIlc)->ilc_lineNo) & 0xFF0000))))
#define __ILC_LNO_AS_OBJ(pIlc)      ((pIlc)->ilc_lineNo)
#define __OBJ_AS_ILC_LNO(pIlc, o)   ((pIlc)->ilc_lineNo = (o))
#define __ISVALID_ILC_LNO(pIlc)     (__isSmallInteger((pIlc)->ilc_lineNo) \
				     && ((INT)((pIlc)->ilc_lineNo) & __MASKSMALLINT(0xFFFF)))
#define __ILC_FLAGS(pIlc)           (__smallIntegerVal((pIlc)->ilc_lineNo) >> 16)
#ifdef __SUPPORT_DIRECT_ILC
# define __IS_DIRECT_ILC(pIlc)       ((INT)((pIlc)->ilc_lineNo) & __MASKSMALLINT(I_DIRECT<<16))
#endif
#ifdef __SUPPORT_LDT_TOC_ILC
# define __IS_LDT_TOC_ILC(pIlc)      ((INT)((pIlc)->ilc_lineNo) & __MASKSMALLINT(I_LDT_TOC<<16))
#endif

#ifdef __SUPPORT_DIRECT_ILC
struct inlineCacheForDirectCall {
	ILC_COMMON_FIELDS
	void            *ilc_callInsn;
};
#endif

#ifdef __SUPPORT_LDT_TOC_ILC
struct inlineCacheWithLDT_TOC {
	ILC_COMMON_FIELDS
	void            *ilc_LDT_TOC;
};
#endif

typedef struct inlineCache *inlineCachePtr;

#define _ILC0           { __SEND0ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }
#define _ILC1           { __SEND1ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }
#define _ILC2           { __SEND2ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }
#define _ILC3           { __SEND3ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }
#define _ILC4           { __SEND4ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }
#define _ILC5           { __SEND5ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }
#define _ILC6           { __SEND6ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }
#define _ILC7           { __SEND7ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }
#define _ILC8           { __SEND8ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }
#define _ILC9           { __SEND9ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }
#define _ILC10          { __SEND10ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }
#define _ILC11          { __SEND11ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }
#define _ILC12          { __SEND12ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }
#define _ILC13          { __SEND13ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }
#define _ILC14          { __SEND14ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }
#define _ILC15          { __SEND15ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }
#define _ILC_N          { __SENDNADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(0, 0) __NP__ }

#define __ILC_L(nArg, n, flag, link) { (OBJFUNC)(nArg), nil, link, __DEF_ILCLNO(n, flag) __NP__ }

#define __ILC0(n)       { __SEND0ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }
#define __ILC1(n)       { __SEND1ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }
#define __ILC2(n)       { __SEND2ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }
#define __ILC3(n)       { __SEND3ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }
#define __ILC4(n)       { __SEND4ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }
#define __ILC5(n)       { __SEND5ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }
#define __ILC6(n)       { __SEND6ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }
#define __ILC7(n)       { __SEND7ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }
#define __ILC8(n)       { __SEND8ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }
#define __ILC9(n)       { __SEND9ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }
#define __ILC10(n)      { __SEND10ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }
#define __ILC11(n)      { __SEND11ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }
#define __ILC12(n)      { __SEND12ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }
#define __ILC13(n)      { __SEND13ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }
#define __ILC14(n)      { __SEND14ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }
#define __ILC15(n)      { __SEND15ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }
#define __ILC_N(n)      { __SENDNADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, 0) __NP__ }

#define __ILCSELF0(n)   { __SEND0ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }
#define __ILCSELF1(n)   { __SEND1ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }
#define __ILCSELF2(n)   { __SEND2ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }
#define __ILCSELF3(n)   { __SEND3ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }
#define __ILCSELF4(n)   { __SEND4ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }
#define __ILCSELF5(n)   { __SEND5ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }
#define __ILCSELF6(n)   { __SEND6ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }
#define __ILCSELF7(n)   { __SEND7ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }
#define __ILCSELF8(n)   { __SEND8ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }
#define __ILCSELF9(n)   { __SEND9ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }
#define __ILCSELF10(n)  { __SEND10ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }
#define __ILCSELF11(n)  { __SEND11ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }
#define __ILCSELF12(n)  { __SEND12ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }
#define __ILCSELF13(n)  { __SEND13ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }
#define __ILCSELF14(n)  { __SEND14ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }
#define __ILCSELF15(n)  { __SEND15ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }
#define __ILCSELF_N(n)  { __SENDNADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SELF) __NP__ }

#define __ILCPERF0(n)   { __SEND0ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }
#define __ILCPERF1(n)   { __SEND1ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }
#define __ILCPERF2(n)   { __SEND2ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }
#define __ILCPERF3(n)   { __SEND3ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }
#define __ILCPERF4(n)   { __SEND4ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }
#define __ILCPERF5(n)   { __SEND5ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }
#define __ILCPERF6(n)   { __SEND6ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }
#define __ILCPERF7(n)   { __SEND7ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }
#define __ILCPERF8(n)   { __SEND8ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }
#define __ILCPERF9(n)   { __SEND9ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }
#define __ILCPERF10(n)  { __SEND10ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }
#define __ILCPERF11(n)  { __SEND11ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }
#define __ILCPERF12(n)  { __SEND12ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }
#define __ILCPERF13(n)  { __SEND13ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }
#define __ILCPERF14(n)  { __SEND14ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }
#define __ILCPERF15(n)  { __SEND15ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }
#define __ILCPERF_N(n)  { __SENDNADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_PERF) __NP__ }

#define __ILCSUPER0(n)  { __SEND0ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }
#define __ILCSUPER1(n)  { __SEND1ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }
#define __ILCSUPER2(n)  { __SEND2ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }
#define __ILCSUPER3(n)  { __SEND3ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }
#define __ILCSUPER4(n)  { __SEND4ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }
#define __ILCSUPER5(n)  { __SEND5ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }
#define __ILCSUPER6(n)  { __SEND6ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }
#define __ILCSUPER7(n)  { __SEND7ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }
#define __ILCSUPER8(n)  { __SEND8ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }
#define __ILCSUPER9(n)  { __SEND9ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }
#define __ILCSUPER10(n) { __SEND10ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }
#define __ILCSUPER11(n) { __SEND11ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }
#define __ILCSUPER12(n) { __SEND12ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }
#define __ILCSUPER13(n) { __SEND13ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }
#define __ILCSUPER14(n) { __SEND14ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }
#define __ILCSUPER15(n) { __SEND15ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }
#define __ILCSUPER_N(n) { __SENDNADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_SUPER) __NP__ }

#define __ILCCONST0(n)  { __SEND0ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }
#define __ILCCONST1(n)  { __SEND1ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }
#define __ILCCONST2(n)  { __SEND2ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }
#define __ILCCONST3(n)  { __SEND3ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }
#define __ILCCONST4(n)  { __SEND4ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }
#define __ILCCONST5(n)  { __SEND5ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }
#define __ILCCONST6(n)  { __SEND6ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }
#define __ILCCONST7(n)  { __SEND7ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }
#define __ILCCONST8(n)  { __SEND8ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }
#define __ILCCONST9(n)  { __SEND9ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }
#define __ILCCONST10(n) { __SEND10ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }
#define __ILCCONST11(n) { __SEND11ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }
#define __ILCCONST12(n) { __SEND12ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }
#define __ILCCONST13(n) { __SEND13ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }
#define __ILCCONST14(n) { __SEND14ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }
#define __ILCCONST15(n) { __SEND15ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }
#define __ILCCONST_N(n) { __SENDNADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CONST) __NP__ }

#define __ILCCLASS0(n)   { __SEND0ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }
#define __ILCCLASS1(n)   { __SEND1ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }
#define __ILCCLASS2(n)   { __SEND2ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }
#define __ILCCLASS3(n)   { __SEND3ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }
#define __ILCCLASS4(n)   { __SEND4ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }
#define __ILCCLASS5(n)   { __SEND5ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }
#define __ILCCLASS6(n)   { __SEND6ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }
#define __ILCCLASS7(n)   { __SEND7ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }
#define __ILCCLASS8(n)   { __SEND8ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }
#define __ILCCLASS9(n)   { __SEND9ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }
#define __ILCCLASS10(n)  { __SEND10ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }
#define __ILCCLASS11(n)  { __SEND11ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }
#define __ILCCLASS12(n)  { __SEND12ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }
#define __ILCCLASS13(n)  { __SEND13ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }
#define __ILCCLASS14(n)  { __SEND14ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }
#define __ILCCLASS15(n)  { __SEND15ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }
#define __ILCCLASS_N(n)  { __SENDNADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_CLASS) __NP__ }

#define __ILCRSELF0(n)   { __SEND0ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }
#define __ILCRSELF1(n)   { __SEND1ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }
#define __ILCRSELF2(n)   { __SEND2ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }
#define __ILCRSELF3(n)   { __SEND3ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }
#define __ILCRSELF4(n)   { __SEND4ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }
#define __ILCRSELF5(n)   { __SEND5ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }
#define __ILCRSELF6(n)   { __SEND6ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }
#define __ILCRSELF7(n)   { __SEND7ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }
#define __ILCRSELF8(n)   { __SEND8ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }
#define __ILCRSELF9(n)   { __SEND9ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }
#define __ILCRSELF10(n)  { __SEND10ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }
#define __ILCRSELF11(n)  { __SEND11ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }
#define __ILCRSELF12(n)  { __SEND12ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }
#define __ILCRSELF13(n)  { __SEND13ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }
#define __ILCRSELF14(n)  { __SEND14ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }
#define __ILCRSELF15(n)  { __SEND15ADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }
#define __ILCRSELF_N(n)  { __SENDNADDR__, nil, (struct inlineCache *)0, __DEF_ILCLNO(n, I_RSELF) __NP__ }

#if 1
#define _DUMMYILC0      { __SEND0ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#define _DUMMYILC1      { __SEND1ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#define _DUMMYILC2      { __SEND2ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#define _DUMMYILC3      { __SEND3ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#define _DUMMYILC4      { __SEND4ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#define _DUMMYILC5      { __SEND5ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#define _DUMMYILC6      { __SEND6ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#define _DUMMYILC7      { __SEND7ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#define _DUMMYILC8      { __SEND8ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#define _DUMMYILC9      { __SEND9ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#define _DUMMYILC10     { __SEND10ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#define _DUMMYILC11     { __SEND11ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#define _DUMMYILC12     { __SEND12ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#define _DUMMYILC13     { __SEND13ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#define _DUMMYILC14     { __SEND14ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#define _DUMMYILC15     { __SEND15ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#define _DUMMYILC_N     { __SENDNADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, 0) __NP__ }
#endif

#define __DUMMYILC0(l)      { __SEND0ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }
#define __DUMMYILC1(l)      { __SEND1ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }
#define __DUMMYILC2(l)      { __SEND2ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }
#define __DUMMYILC3(l)      { __SEND3ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }
#define __DUMMYILC4(l)      { __SEND4ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }
#define __DUMMYILC5(l)      { __SEND5ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }
#define __DUMMYILC6(l)      { __SEND6ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }
#define __DUMMYILC7(l)      { __SEND7ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }
#define __DUMMYILC8(l)      { __SEND8ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }
#define __DUMMYILC9(l)      { __SEND9ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }
#define __DUMMYILC10(l)     { __SEND10ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }
#define __DUMMYILC11(l)     { __SEND11ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }
#define __DUMMYILC12(l)     { __SEND12ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }
#define __DUMMYILC13(l)     { __SEND13ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }
#define __DUMMYILC14(l)     { __SEND14ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }
#define __DUMMYILC15(l)     { __SEND15ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }
#define __DUMMYILC_N(l)     { __SENDNADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, 0) __NP__ }

#if 1
#define _DUMMYILCSELF0      { __SEND0ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#define _DUMMYILCSELF1      { __SEND1ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#define _DUMMYILCSELF2      { __SEND2ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#define _DUMMYILCSELF3      { __SEND3ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#define _DUMMYILCSELF4      { __SEND4ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#define _DUMMYILCSELF5      { __SEND5ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#define _DUMMYILCSELF6      { __SEND6ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#define _DUMMYILCSELF7      { __SEND7ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#define _DUMMYILCSELF8      { __SEND8ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#define _DUMMYILCSELF9      { __SEND9ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#define _DUMMYILCSELF10     { __SEND10ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#define _DUMMYILCSELF11     { __SEND11ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#define _DUMMYILCSELF12     { __SEND12ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#define _DUMMYILCSELF13     { __SEND13ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#define _DUMMYILCSELF14     { __SEND14ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#define _DUMMYILCSELF15     { __SEND15ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#define _DUMMYILCSELF_N     { __SENDNADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(0, I_SELF) __NP__ }
#endif

#define __DUMMYILCSELF0(l)      { __SEND0ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }
#define __DUMMYILCSELF1(l)      { __SEND1ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }
#define __DUMMYILCSELF2(l)      { __SEND2ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }
#define __DUMMYILCSELF3(l)      { __SEND3ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }
#define __DUMMYILCSELF4(l)      { __SEND4ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }
#define __DUMMYILCSELF5(l)      { __SEND5ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }
#define __DUMMYILCSELF6(l)      { __SEND6ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }
#define __DUMMYILCSELF7(l)      { __SEND7ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }
#define __DUMMYILCSELF8(l)      { __SEND8ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }
#define __DUMMYILCSELF9(l)      { __SEND9ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }
#define __DUMMYILCSELF10(l)     { __SEND10ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }
#define __DUMMYILCSELF11(l)     { __SEND11ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }
#define __DUMMYILCSELF12(l)     { __SEND12ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }
#define __DUMMYILCSELF13(l)     { __SEND13ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }
#define __DUMMYILCSELF14(l)     { __SEND14ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }
#define __DUMMYILCSELF15(l)     { __SEND15ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }
#define __DUMMYILCSELF_N(l)     { __SENDNADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SELF) __NP__ }

#define __DUMMYILCSUPER0(l)      { __SEND0ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }
#define __DUMMYILCSUPER1(l)      { __SEND1ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }
#define __DUMMYILCSUPER2(l)      { __SEND2ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }
#define __DUMMYILCSUPER3(l)      { __SEND3ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }
#define __DUMMYILCSUPER4(l)      { __SEND4ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }
#define __DUMMYILCSUPER5(l)      { __SEND5ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }
#define __DUMMYILCSUPER6(l)      { __SEND6ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }
#define __DUMMYILCSUPER7(l)      { __SEND7ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }
#define __DUMMYILCSUPER8(l)      { __SEND8ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }
#define __DUMMYILCSUPER9(l)      { __SEND9ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }
#define __DUMMYILCSUPER10(l)     { __SEND10ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }
#define __DUMMYILCSUPER11(l)     { __SEND11ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }
#define __DUMMYILCSUPER12(l)     { __SEND12ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }
#define __DUMMYILCSUPER13(l)     { __SEND13ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }
#define __DUMMYILCSUPER14(l)     { __SEND14ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }
#define __DUMMYILCSUPER15(l)     { __SEND15ADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }
#define __DUMMYILCSUPER_N(l)     { __SENDNADDR__, nil, (struct inlineCache *)1, __DEF_ILCLNO(l, I_SUPER) __NP__ }

#ifdef __LCC__
extern OBJ __SSEND0(OBJ, OBJ, int);
extern OBJ _SEND0(OBJ, OBJ, OBJ, inlineCachePtr);
extern OBJ _SEND1(OBJ, OBJ, OBJ, inlineCachePtr, OBJ);
extern OBJ _SEND2(OBJ, OBJ, OBJ, inlineCachePtr, OBJ, OBJ);
extern OBJ _SEND3(OBJ, OBJ, OBJ, inlineCachePtr, OBJ, OBJ, OBJ);
#endif

extern OBJ __UNLIMITEDSTACKCALL4__(OBJFUNC, INT, INT, INT, INT);
extern OBJFUNC __mcompile(OBJ aMethod, unsigned char *bytecode, int nBytes, int nArgs, OBJ receiver, OBJ selector, OBJ srchClass, OBJ *pArgsOrNull);

struct __customFunctionTable__ {
    int (*func)();
    char *name;
};
typedef struct __customFunctionTable__ CUSTOMFUNCTION;

/*
 * if there is a longrestart function,
 * the check for setjmps retval can be ommitted
 */
#ifdef HAVE_LONGRESTART

# define __MENTRY__                                     \
    if (stx_setjmp(__con.__retvec)) {                   \
	goto doReturn;                                  \
    }                                                   \
    __CONT__

#else

#define __MENTRY__                                      \
    if (stx_setjmp(__con.__retvec)) {                   \
	if (__context->c_retval != RESTART_VALUE)       \
	    goto doReturn;                              \
    }                                                   \
    __CONT__

#endif /* HAVE_LONGRESTART */


#ifdef THIS_CONTEXT

#define __MEXIT__                               \
doReturn:                                       \
    __thisContext = __context->c_sender;        \
    if (__specialContext(__context)) {          \
	__MKREALCONTEXT(__context);             \
    }                                           \
    return __context->c_retval;

#else

#define __MEXIT__                               \
doReturn:                                       \
    if (_isNonLIFO(__context)) {                \
	__MKREALCONTEXT(__context);             \
    }                                           \
    return __context->c_retval;

#endif /* THIS_CONTEXT */

#ifdef THIS_CONTEXT
# define RETURN1(v)     { __context->c_retval = (v); goto doReturn; }
# define RETURN2(v)     { return v; }
# define CONARG         /* nothing */
# define SNDARG         /* nothing */
# define CON_COMMA      /* nothing */
# define SND_COMMA      /* nothing */
# define COMMA_CON      /* nothing */
# define COMMA_SND      /* nothing */
# define SENDER         __thisContext
# define SENDER_DECL    /* nothing */
#else
# define RETURN1(v)     { return v; }
# define RETURN2(v)     { return v; }
# define CONARG         __context
# define SNDARG         __sender
# define CON_COMMA      __context,
# define SND_COMMA      __sender,
# define COMMA_CON      ,__context
# define COMMA_SND      ,__sender
# define SENDER         __sender
# define SENDER_DECL    OBJ __sender;
#endif

#define RETURN RETURN1


# define __ALIGNED__(x) (((unsigned INT)(x) + (__ALIGN__-1)) & ~(__ALIGN__-1))


/*
 * macro to PROTECT/UNPROTECT a variable from scavenger/collector
 * this adds the protected objects temporarily to a list of 'roots'
 * which the collector cares for. Notice, that the size of this
 * list is limited and it should not be used in a recursive/deeply nested fashion.
 */
extern void __internalError(char *);


#define __MAX_NPROTECT__ 100
#define __PROTECT__(a)           { \
				   OBJ *__pp__ = __protectList; \
				   __pp__[__nProtect] = (a); \
				   __nProtect++; \
				   if (__nProtect >= __MAX_NPROTECT__) { \
				      __internalError("protect list overflow"); \
				   } \
				 }
#define __PROTECT2__(a, b)       { \
				   OBJ *__pp__ = __protectList; \
				   __pp__[__nProtect+0] = (a); \
				   __pp__[__nProtect+1] = (b); \
				   __nProtect += 2; \
				 }
#define __PROTECT3__(a, b, c)    { \
				   OBJ *__pp__ = __protectList; \
				   __pp__[__nProtect+0] = (a); \
				   __pp__[__nProtect+1] = (b); \
				   __pp__[__nProtect+2] = (c); \
				   __nProtect += 3; \
				 }

#define __PROTECT4__(a, b, c, d)    { \
				   OBJ *__pp__ = __protectList; \
				   __pp__[__nProtect+0] = (a); \
				   __pp__[__nProtect+1] = (b); \
				   __pp__[__nProtect+2] = (c); \
				   __pp__[__nProtect+3] = (d); \
				   __nProtect += 4; \
				 }

#define __PROTECT5__(a, b, c, d, e)    { \
				   OBJ *__pp__ = __protectList; \
				   __pp__[__nProtect+0] = (a); \
				   __pp__[__nProtect+1] = (b); \
				   __pp__[__nProtect+2] = (c); \
				   __pp__[__nProtect+3] = (d); \
				   __pp__[__nProtect+4] = (e); \
				   __nProtect += 5; \
				 }

#define __UNPROTECT__(a)         { \
				   OBJ *__pp__ = __protectList; \
				   __nProtect = __nProtect-1; \
				   (a) = __pp__[__nProtect]; \
				 }
#define __UNPROTECT2__(b, a)     { \
				   OBJ *__pp__ = __protectList; \
				   (b) = __pp__[__nProtect-1]; \
				   (a) = __pp__[__nProtect-2]; \
				   __nProtect -= 2; \
				 }
#define __UNPROTECT3__(c, b, a)  { \
				   OBJ *__pp__ = __protectList; \
				   (c) = __pp__[__nProtect-1]; \
				   (b) = __pp__[__nProtect-2]; \
				   (a) = __pp__[__nProtect-3]; \
				   __nProtect -= 3; \
				 }
#define __UNPROTECT4__(d, c, b, a)  { \
				   OBJ *__pp__ = __protectList; \
				   (d) = __pp__[__nProtect-1]; \
				   (c) = __pp__[__nProtect-2]; \
				   (b) = __pp__[__nProtect-3]; \
				   (a) = __pp__[__nProtect-4]; \
				   __nProtect -= 4; \
				 }
#define __UNPROTECT5__(e, d, c, b, a)  { \
				   OBJ *__pp__ = __protectList; \
				   (e) = __pp__[__nProtect-1]; \
				   (d) = __pp__[__nProtect-2]; \
				   (c) = __pp__[__nProtect-3]; \
				   (b) = __pp__[__nProtect-4]; \
				   (a) = __pp__[__nProtect-5]; \
				   __nProtect -= 5; \
				 }
#define __FETCHPROTECT__(x,n)    {(x) = __protectList[__nProtect-n];}

#define __PROTECT_CONTEXT__     __PROTECT3__(self, __selector, __searchClass)
#define __UNPROTECT_CONTEXT__   __UNPROTECT3__(__searchClass, __selector, self)

#define __FORGET_CONTEXT__      __nProtect-=3;

/*
 * a quick new (avoids a function call if possible)
 *
 * this is not "good style" but adds performance:
 * directly take an object from newSpace (if it is guaranteed that no
 * scavenge is needed)
 */
#if 0
extern char *__newNextPtr, *__newEndPtr;
extern int __newSpace;
#endif



/**
 * Check if `size` bytes can be allocated from memory chunk
 * starting at `start` and ending at `end`. The `size` must
 * be properly aligned (see macro `__ALIGNED__()`);
 *
 * \return 1 if `size` bytes can be allocated, 0 otherwise.
 */
static inline int __CanDoQuickAllocIn(char* start, char* end, unsigned INT size) {
#if (__GNUC__ >= 5) || defined(__clang__)
    unsigned INT r;
    /*
     * Use an intrinsic to check for overflow. This ought to generate
     * a slightly better code
     */
    if ( __builtin_add_overflow( (unsigned INT)start, (unsigned INT)size, &r ) ) {
        /* overflow */
        return 0;
    } else {
        return r < (unsigned INT)end;
    }
#else
    /*
     * Note that here we're using unsigned arithmetic which wraps around,
     * allowing the overflow check afterwards. Signed arithmetic would lead
     * to undefined behavior.
     */
    unsigned INT r = (unsigned INT)start + size;
    return (unsigned INT)start <= r && r <= (unsigned INT)end;
#endif
}

/*
 * true if size bytes (possibly unaligned) can be quickly allocated
 * without a newSpace overflow
 */
#define __CanDoQuickNew(size)          \
    __CanDoQuickAllocIn(__newNextPtr, __newEndPtr, (unsigned INT)(size) + __ALIGN__-1)

/*
 * true if two objects (withsize1 and size2) can be quickly allocated
 * without a newSpace overflow
 */
#define __CanDoQuickNew2(size1, size2) \
    __CanDoQuickAllocIn(__newNextPtr, __newEndPtr, (unsigned INT)(size1)+__ALIGN__ \
				       + (unsigned INT)(size2)+__ALIGN__)

/*
 * true if a float can be quickly allocated
 * without a newSpace overflow
 */
#define __CanDoQuickNewFloat()                          \
    __CanDoQuickAllocIn(__newNextPtr, __newEndPtr, __ALIGNED__(sizeof(struct __Float)))

/*
 * quickly allocate an object with size (possibly unaligned) bytes
 * Only allowed if CanDoQuickNew returned true previously.
 */
#define __qCheckedNew(newObject, size)                  \
  {                                                     \
    char *nO = __newNextPtr;                            \
    (newObject) = (OBJ)nO;                              \
    __objPtr((OBJ)nO)->o_size = (size);                 \
    o_setAllFlags((OBJ)nO, __newSpace);                 \
    nO += (unsigned INT)(size);                         \
    __newNextPtr = (char *)__ALIGNED__(nO);             \
  }

/*
 * allocate an object with size (possibly unaligned) bytes
 * try quick allocate or fall back into GC if required.
 */
#define __qNew(newObject, size)                         \
  {                                                     \
    if (__CanDoQuickNew(size)) {                        \
	__qCheckedNew(newObject, size);                 \
    } else {                                            \
	newObject = __STX___new(size);                  \
    }                                                   \
  }

/*
 * allocate an object with size (aligned) bytes
 * try quick allocate or fall back into GC if required.
 */
// OBSOLETE
#define __qAlignedNew(newObject, size)                 \
    __qNew(newObject, size)

/*
 * quickly allocate an object with size (aligned) bytes
 * Only allowed if CanDoQuickNew returned true previously.
 */
#define __qCheckedAlignedNew(newObject, size)          \
    __qCheckedNew(newObject, size)

#define __qMKFLOAT(ptr , value)                         \
  {                                                     \
    OBJ nFO;                                            \
							\
    __qNew((nFO), sizeof(struct __Float));              \
    __stx_setClass(nFO, Float);                         \
    __FloatInstPtr(nFO)->f_floatvalue = (value);        \
    ptr = nFO;                                          \
  }

/* some machines (x86_64 on osx) add padding to make the
 * structure a multiple of 8. This breaks code which assumes
 * that a real's basicSize is its number of bytes...
 * (see LimitedPrecisionReal asTrueFraction)
 */
#define __qMKSFLOAT(ptr, value)                         \
  {                                                     \
    OBJ nFO;                                            \
							\
    __qNew((nFO), OHDR_SIZE+sizeof(float));             \
    __stx_setClass(nFO, ShortFloat);                    \
    __ShortFloatInstPtr(nFO)->f_floatvalue = (value);   \
    ptr = nFO;                                          \
  }

// obsolete now
// #define _qMKFLOAT(ptr, val)    __qMKFLOAT(ptr, val)

#if defined(NATIVE_THREADS) || defined(DEBUG_IMMEDIATE_INTERRUPTS)
# ifdef hppa
#  define __HANDLE_INTERRUPTS__   __fHANDLE_INTERRUPTS__()
#  define __BEGIN_INTERRUPTABLE__ __fBEGIN_INTERRUPTABLE__();
#  define __END_INTERRUPTABLE__   __fEND_INTERRUPTABLE__();
# else
#  ifdef WIN32
#   define __HANDLE_INTERRUPTS__   -- error - not needed/used/supported for Win32 --
#   define __BEGIN_INTERRUPTABLE__ -- error - not needed/used/supported for Win32 --
#   define __END_INTERRUPTABLE__   -- error - not needed/used/supported for Win32 --
#  else
   extern void __HANDLE_INTERRUPTS__();
   extern void __BEGIN_INTERRUPTABLE__();
   extern void __END_INTERRUPTABLE__();
#  define __HANDLE_INTERRUPTS__   __HANDLE_INTERRUPTS__()
#  define __BEGIN_INTERRUPTABLE__ __BEGIN_INTERRUPTABLE__();
#  define __END_INTERRUPTABLE__   __END_INTERRUPTABLE__();
#  endif /* not WIN32 */
# endif /* not hppa */

#else /* no native threads AND not debugging */

# define __HANDLE_INTERRUPTS__              \
    if (InterruptPending != nil) {                 \
	if (__immediateInterrupt__) {       \
	    __nestedImmediateInterrupt();   \
	}                                   \
	__immediateInterrupt__ = 1;         \
	__stxHandleInterrupt__();           \
	__immediateInterrupt__ = 0;         \
    }

# define __BEGIN_INTERRUPTABLE__            \
  {                                         \
    if (__immediateInterrupt__) {           \
	__nestedImmediateInterrupt();       \
    }                                       \
    __immediateInterrupt__ = 1;             \
    if (InterruptPending != nil) {          \
	__stxHandleInterrupt__();           \
    }                                       \
  }

# define __END_INTERRUPTABLE__              \
    __immediateInterrupt__ = 0;

#endif

#ifdef THISCONTEXT_IN_REGISTER
    extern OBJ __irqContext;
    /*
     * actually only needed on sparc: since thisContext is
     * in a global register, which gets destroyed by printf,
     * and some other lib functions.
     * manually save it here - very stupid ...
     */
# define __BEGIN_PROTECT_REGISTERS__  \
	__irqContext = __thisContext;

# define __END_PROTECT_REGISTERS__    \
	__thisContext = __irqContext; \
	__irqContext = nil;

#else
#  define __BEGIN_PROTECT_REGISTERS__ /* nothing */
#  define __END_PROTECT_REGISTERS__   /* nothing */
#endif

#endif /* __STC_H__ */

#include "stcVMdata.h"

#if defined(WIN32)
# if defined(__USE_FAST_CALL__)
#  define __storeInst0   __fast__storeInst0
#  define __storeInst1   __fast__storeInst1
#  define __storeInst2   __fast__storeInst2
#  define __storeInst3   __fast__storeInst3
#  define __storeInst4   __fast__storeInst4
#  define __storeInst5   __fast__storeInst5
# endif /* __USE_FAST_CALL__  */
#endif /* WIN32 */

#ifndef console_fprintf
# define console_fprintf        fprintf
#endif
#ifndef console_printf
# define console_printf         printf
#endif
#ifndef console_fflush
# define console_fflush         fflush
#endif

/*
 * on real multithreaded systems, errno must be copied
 * into a thread-switched variable;
 * All code should use __threadErrno to get the per-thread value.
 */
#ifndef __threadErrno
# define __threadErrno errno
#endif

	     /*
	     * the 3rd arg is the number of lits in the low bits (mask: 0xFFFF);
	     * the high bits define the kind of literal-array information that is passed:
	     *      0x010000 ->
	     *      0x020000 ->
	     *      0x030000 ->
	     *      0x040000 ->
	     *      0x050000 ->
	     *
	     *      0x100000 -> 1st slot is direct OOP of externalLibrary function
	     */
#define __INITLIT_DIRECT        0x0000000    /* direct literals */
#define __INITLIT_OFFSET        0x0400000    /* offsets */
#define __INITLIT_DIRECTDATA    0x0300000    /* direct fix data space */
#define __INITLIT_DIRECTDATAO   0x0500000    /* direct fix data space with offsets */
#define __INITLIT_INDIR         0x0100000    /* indirect */
#define __INITLIT_IINDIR        0x0200000    /* double indirect */
#define __INITLIT_EXTLIBFUNC    0x1000000    /* external library function at slot 0 */

/*
 * literal array initializers
 */
#define __L_NIL     0
#define __L_TRUE    1
#define __L_FALSE   2
#define __L_SINT_1  3
#define __L_UINT_1  4
#define __L_SINT_2  5
#define __L_UINT_2  6
#define __L_SINT_4  7
#define __L_UINT_4  8
#define __L_SINT_8  9
#define __L_UINT_8  10
#define __L_SYM0    11
#define __L_STR0    12
#define __L_CHAR_1  13
#define __L_ARR_1   14
#define __L_ARR_2   15
#define __L_CON_4   16
#define __L_CON_8   17
#define __L_SFLT0   18
#define __L_SFLT_4  19
#define __L_INT0    20
#define __L_INT1    21
#define __L_FLT0    22
#define __L_FLT1    23
#define __L_FLT_8   24
#define __L_FLT100  25
#define __L_INT100  26
#define __L_BARR_1  27
#define __L_BARR_2  28
#define __L_BARR_3  29
#define __L_ARR_3   30
#define __L_LNR0    31
#define __L_ARR2    32
#define __L_ARR3    33
#define __L_ARR4    34
#define __L_ARR5    35
#define __L_ARR6    36
#define __L_ARR7    37
#define __L_CHAR_2  38
#define __L_CHAR_3  39
#define __L_CHAR_4  40
#define __L_STRU0   41
#define __L_ARR0    42
#define __L_ARR1    43
#define __L_STR_L0  44
#define __L_STR_L1  45
#define __L_STR_L2  46
#define __L_STR_L3  47
#define __L_STR_L4  48
#define __L_STR_L5  49
#define __L_CHARS_1 50
#define __L_UINTS_1 51
#define __L_SINTS_1 52
#define __L_FXNR0   53
#define __L_FLTM1   55
#define __L_TARR_1  56
#define __L_TARR_2  57
#define __L_TARR_3  58

#define __ARR_S8    1
#define __ARR_S16   2
#define __ARR_S32   2
#define __ARR_S64   3
#define __ARR_U16   4
#define __ARR_U32   5
#define __ARR_U64   6
#define __ARR_F16   7
#define __ARR_F32   8
#define __ARR_F64   9
#define __ARR_U1    10
#define __ARR_BOOL  11

#if 0
typedef struct __Class *CLASS;
typedef struct __Method *METHOD;
typedef struct __STRING10 *STRING;
#endif

extern unsigned INT __oldSpaceSize(), __oldSpaceUsed();

// casts in an asm statement;
// clang does not like them.

# if defined (__CLANG__)
#  define ASM_ULONGCAST
# else
#  define ASM_ULONGCAST (unsigned long)
# endif


#if defined(__TCC__) || defined(__GNUC__) || defined(__clang__) || defined(__CLANG__)
# define __STATIC_CONST_TABLE__
#endif
#if defined(__TCC__) || defined(__GNUC__) || defined(__clang__) || defined(__CLANG__)
# define __STATIC_BLOCK_FUNCTIONS__
#endif
#if defined(__TCC__) || defined(__GNUC__) || defined(__clang__) || defined(__CLANG__)
# define __STATIC_METHOD_FUNCTIONS__
#endif
#if defined(__TCC__) || defined(__GNUC__) || defined(__clang__) || defined(__CLANG__)
# define __STATIC_ILCS__
#endif
