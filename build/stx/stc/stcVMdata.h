/*
 * COPYRIGHT (c) 1995 by Claus Gittinger
 * COPYRIGHT (c) 2015-2018 Jan Vrany
 *              All Rights Reserved
 *
 * This software is furnished under a license and may be used
 * only in accordance with the terms of that license and with the
 * inclusion of the above copyright notice.   This software may not
 * be provided or otherwise made available to, or used by, any
 * hereby transferred.
 *
 *
 * $Header$
 */

/*
 * extracted to avoid recompilation of the whole system
 * if more variables are to be shared between the VM and the
 * class libraries.
 *
 *
 * the following access options are avialable:
 *
 * #define __DIRECTVMDATA__     - directly access (linker binds refs into VM)
 *                                not recommended: ELF systems
 *                                not allowed with: DLLs (Windows)
 *
 * #define __FIXBASE__          - access via shared memory region (at absolute address)
 *                                recommended on systems which support mmap
 *
 * #define __INDIRECTVMCALLS__  - to call VM via pRT table (as opposed to GOT-calls)
 *
 * #define __INDIRECTVMINITCALLS__  - to call VM init functions via pRT table (as opposed to GOT-calls)
 *
 * if none of the above is defined, access is via a shared structure (address passed at startup)
 *
 *
 * In order to not make previous compiled class code obsolete,
 * ONLY ADD NEW SLOTS ADD THE END.
 */

#ifndef __STCVMDATA_H__ /* i.e. already included */

#  define __SEND0ADDR__        _SEND0
#  define __SEND1ADDR__        _SEND1
#  define __SEND2ADDR__        _SEND2
#  define __SEND3ADDR__        _SEND3
#  define __SEND4ADDR__        _SEND4
#  define __SEND5ADDR__        _SEND5
#  define __SEND6ADDR__        _SEND6
#  define __SEND7ADDR__        _SEND7
#  define __SEND8ADDR__        _SEND8
#  define __SEND9ADDR__        _SEND9
#  define __SEND10ADDR__       _SEND10
#  define __SEND11ADDR__       _SEND11
#  define __SEND12ADDR__       _SEND12
#  define __SEND13ADDR__       _SEND13
#  define __SEND14ADDR__       _SEND14
#  define __SEND15ADDR__       _SEND15
#  define __SENDNADDR__        _SENDN
#  define __ySTACK_HANDLER_U__ADDR      __ySTACK_HANDLER_U__
#  define __ySTACK_HANDLER_N__ADDR      __ySTACK_HANDLER_N__
#  define __ySTACK_HANDLER__ADDR        __ySTACK_HANDLER__

# if !defined(__IN_VM__) && !defined(__IN_STC__) && !defined(__INDIRECTGLOBALS__)
#  define xxxx__DIRECTVMDATA__
#  define __DIRECTVMFUNCREFS__
# endif

# if defined(__mc88k__) && defined(__realIX__) && !defined(__NO_VMDATA_REF__)
#  define __VMDATA_REF__
# endif

/*
 * Remember, for backward compatibility:
 * ONLY ADD NEW ENTRIES AT THE END
 */
struct __vmDataObjects__ {
    /*
     * only OBJ's here
     */
    VOLATILE CONTEXT_OBJ     v___thisContext;
    VOLATILE OBJ             v_InterruptPending;

#define v__vmFixObjectsStartMark        v_false         /* for now: only true & false are there */
    VOLATILE OBJ             v_false;
    VOLATILE OBJ             v_true;
#define v__vmFixObjectsEndMark          v_true          /* for now: only true & false are there */

    /*
     * often used classes & objects ...
     */
    VOLATILE OBJ             v_Array;
    VOLATILE OBJ             v_String;
    VOLATILE OBJ             v_Float;
    VOLATILE OBJ             v_Symbol;

    VOLATILE OBJ             v_SmallInteger;
    VOLATILE OBJ             v_UndefinedObject;
    VOLATILE OBJ             v_Character;
    VOLATILE OBJ             v_ByteArray;

    VOLATILE OBJ             v_LargeInteger;
    VOLATILE OBJ             v_FloatArray;
    VOLATILE OBJ             v_DoubleArray;
    VOLATILE OBJ             v_Point;

    VOLATILE OBJ             v_Block;
    VOLATILE OBJ             v_Method;
    VOLATILE OBJ             v_BlockContext;
    VOLATILE OBJ             v_Context;

    VOLATILE OBJ             v_CheapBlock;
    VOLATILE OBJ             v_WeakArray;
    VOLATILE OBJ             v_ExternalBytes;
    VOLATILE OBJ             v_ExternalFunction;
    VOLATILE OBJ             v_ExternalAddress;
    VOLATILE OBJ             v_True;
    VOLATILE OBJ             v_False;
    VOLATILE OBJ             v_Class;
    VOLATILE OBJ             v_Fraction;
    VOLATILE OBJ             v_Metaclass;
    VOLATILE OBJ             v_Message;

    VOLATILE OBJ             v_Smalltalk;
    VOLATILE OBJ             v_Processor;

    VOLATILE OBJ             v___irqContext;
    VOLATILE OBJ             v_StepInterruptPending;
    VOLATILE OBJ             v_InStepInterrupt;
    VOLATILE OBJ             v_InterruptPcLow;
    VOLATILE OBJ             v_InterruptPcHi;
    VOLATILE OBJ             v_InterruptAddrLow;
    VOLATILE OBJ             v_InterruptAddrHi;
    VOLATILE OBJ             v_InterruptCause;

    VOLATILE OBJ             v_STX__float0;                 /*    */
    VOLATILE OBJ             v_STX__float1;                 /*    */
    VOLATILE OBJ             v_STX__float10;                /*    */
    VOLATILE OBJ             v_STX__float0_5;               /*    */
    VOLATILE OBJ             v_STX__float100;               /*    */

    VOLATILE OBJ             v_Character_CharacterTable;                 /*    */
    VOLATILE OBJ             v_ObjectMemory_ChildSignalInterruptHandler; /*    */
    VOLATILE OBJ             v_ObjectMemory_CustomInterruptHandler;      /*    */
    VOLATILE OBJ             v_ObjectMemory_DisposeInterruptHandler;     /*    */
    VOLATILE OBJ             v_ObjectMemory_ErrorInterruptHandler;       /*    */
    VOLATILE OBJ             v_ObjectMemory_ExceptionInterruptHandler;   /*    */
    VOLATILE OBJ             v_ObjectMemory_IOInterruptHandler;          /*    */
    VOLATILE OBJ             v_ObjectMemory_InternalErrorHandler;        /*    */
    VOLATILE OBJ             v_ObjectMemory_InterruptLatencyMonitor;     /*    */
    VOLATILE OBJ             v_ObjectMemory_MemoryInterruptHandler;      /*    */
    VOLATILE OBJ             v_ObjectMemory_RecursionInterruptHandler;   /*    */
    VOLATILE OBJ             v_ObjectMemory_SignalInterruptHandler;      /*    */
    VOLATILE OBJ             v_ObjectMemory_SpyInterruptHandler;         /*    */
    VOLATILE OBJ             v_ObjectMemory_StepInterruptHandler;                /*    */
    VOLATILE OBJ             v_ObjectMemory_TimerInterruptHandler;               /*    */
    VOLATILE OBJ             v_ObjectMemory_UserInterruptHandler;                /*    */
    VOLATILE OBJ             v_ObjectMemory_ImageName;           /*    */
    VOLATILE OBJ             v_Smalltalk_StartupClass;           /*    */
    VOLATILE OBJ             v_Smalltalk_StartupSelector;                /*    */
    VOLATILE OBJ             v_Smalltalk_StandAlone;             /*    */
    VOLATILE OBJ             v_Smalltalk_CommandLineArguments;           /*    */

    VOLATILE OBJ             v_StepInterruptContext;

    VOLATILE OBJ             v_Object;

    VOLATILE OBJ             v_Rectangle;
    VOLATILE OBJ             v_Process;

    VOLATILE OBJ             v_Set;
    VOLATILE OBJ             v_IdentitySet;
    VOLATILE OBJ             v_Dictionary;
    VOLATILE OBJ             v_IdentityDictionary;
    VOLATILE OBJ             v_OrderedCollection;

    VOLATILE OBJ             v_OperatingSystem;
    VOLATILE OBJ             v_Semaphore;
    VOLATILE OBJ             v_Color;
    VOLATILE OBJ             v_View;
    VOLATILE OBJ             v_MethodDictionary;
    VOLATILE OBJ             v_ShortFloat;
    VOLATILE OBJ             v_PrivateMetaclass;
    VOLATILE OBJ             v_JavaContext;

    VOLATILE OBJ             v___minPositiveLargeInteger;
    VOLATILE OBJ             v___maxNegativeLargeInteger;

    VOLATILE OBJ             v_WordArray;
    VOLATILE OBJ             v_SignedWordArray;
    VOLATILE OBJ             v_IntegerArray;
    VOLATILE OBJ             v_SignedIntegerArray;

    VOLATILE OBJ             v_STX__float2;

    VOLATILE OBJ             v_JavaVM;
    VOLATILE OBJ             v_JavaVM_EnteredMonitorObject;
    VOLATILE OBJ             v_JavaVM_EnteredMonitorObjectCount;
    VOLATILE OBJ             v_JavaVM_EnteredMonitorProcess;
    VOLATILE OBJ             v_JavaVM_LeftMonitorObject;

    VOLATILE OBJ             v_Filename;
    VOLATILE OBJ             v_Time;
    VOLATILE OBJ             v_Date;
    VOLATILE OBJ             v_Delay;
    VOLATILE OBJ             v_Signal;

    VOLATILE OBJ             v_STX__sfloat0;
    VOLATILE OBJ             v_NameSpace;

    VOLATILE OBJ             v_TwoByteString;
    VOLATILE OBJ             v_Unicode16String;
    VOLATILE OBJ             v_ExternalLibraryFunction;
    VOLATILE OBJ             v_AutoloadMetaclass;

    VOLATILE OBJ             v_FixedPoint;
    VOLATILE OBJ             v_ImmutableString;
    VOLATILE OBJ             v_ImmutableArray;
    VOLATILE OBJ             v_ImmutableByteArray;

    /* JV @ 2010-12-23: required for fast isJavaString(o) */
    VOLATILE OBJ             v_Java_java_lang_String;
    VOLATILE OBJ             v_JavaObject;
    VOLATILE OBJ             v_JavaMetaclass;

    VOLATILE OBJ             v_SignedLongIntegerArray;
    VOLATILE OBJ             v_JavaArray;
    VOLATILE OBJ             v_STX__sfloat1;
    VOLATILE OBJ             v_STX__sfloat2;

    VOLATILE OBJ             v_JavaBooleanArray;
    VOLATILE OBJ             v_Smalltalk_IgnoreAssertions;           /*    */

    VOLATILE OBJ             v_STX__float0_25;               /*    */
    VOLATILE OBJ             v_STX__float0_75;               /*    */
    VOLATILE OBJ             v_STX__floatM1;                /*    */
    /*
     * for backward compatibility of compiled code:
     * ONLY ADD NEW ENTRIES AT THE END
     */
#define v__vmObjectsEndMark     v_STX__floatM1
};


struct __vmMiscData__ {
    /*
     * only non-collected VM data here
     */
    VOLATILE OBJ   *v___asciiTable__;
    VOLATILE OBJ   *v___CharacterTable;
    int             v___nProtect;
    OBJ            *v___protectList;  // points to a list of OBJs

    char           *v___stackBottom__;
    char           *v___newEndPtr;
    char           *v___newNextPtr;
    int             v___newSpace;

    char           *v___stackTop__;
    char           *v___newStartPtr;
    VOLATILE int    v___immediateInterrupt__;
    VOLATILE int    v___interruptsBlocked;

    int             v___stxNCustomFunctions__;
    CUSTOMFUNCTION *v___stxCustomFunctions__;

    int             v___blockingPrimitiveTimeout__;
    voidFUNC        v___blockingPrimitiveTimoutHandler__;
    OBJ             v___blockingPrimitiveTimeoutArg__;

    int             v___cpuType__;
    int             v___stxThreadErrno;

    unsigned INT    v___activeProcessIdtl;
    /*
     * for backward compatibility of compiled code:
     * ONLY ADD NEW ENTRIES AT THE END
     */
};

struct __vmEntries__ {
    /*
     * only VM function entries here
     */
    voidFUNC        p__interrupt__;

    voidFUNC        p__REGISTER_MODULE__;
    voidFUNC        p__DEFSOURCE;
    voidFUNC        p__PACKAGE__;
    voidFUNC        p__BEGIN_PACKAGE__;
    voidFUNC        p__END_PACKAGE__;
    voidFUNC        p__DEFMETHODCATEGORY;
    voidFUNC        p__DEFMETHOD;
    voidFUNC        p__DEFPMETHOD;
    voidFUNC        p__MAKEINDIRGLOBAL;

    OBJFUNC         p__MKMETHODARRAY;

    OBJFUNC         p__MKPSELFMETHOD_0;
    OBJFUNC         p__MKPMETHOD_0;
    OBJFUNC         p__MKPMETHOD_1;
    OBJFUNC         p__MKPMETHOD_2;
    OBJFUNC         p__MKPMETHOD_3;
    OBJFUNC         p__MKPMETHOD_N;
    OBJFUNC         p__MKPINSTMETHOD_0;
    OBJFUNC         p__MKPSINSTMETHOD_1;
    OBJFUNC         p__MKPTRUEMETHOD_0;
    OBJFUNC         p__MKPFALSEMETHOD_0;

    OBJFUNC         p__MKLITARRAY;

    voidFUNC        p__MKCLASS_META4;
    voidFUNC        p__MKINDIRGLOBAL_LIST;
    voidFUNC        p__MKSTRING_LIST_INIT;

    OBJFUNC         p__MKUNNAMEDCONSTARRAY;
    voidFUNC        p__UNNAMEDGLOBAL;
    OBJFUNC         p__MKCONSTBARRAY;
    OBJFUNC         p__MKCLASS;
    OBJFUNC         p__MKNSYMBOL_INIT;
    OBJFUNC         p__MKLITARRAY1;
    OBJFUNC         p__MKLITARRAY2;
    OBJFUNC         p__MKLITARRAY3;
    OBJFUNC         p__MKLITARRAY4;
    OBJFUNC         p__MKLITARRAY5;
    OBJFUNC         p__MKLITARRAY6;
    OBJFUNC         p__MKLITARRAY7;
    OBJFUNC         p__MKLITARRAY8;
    OBJFUNC         p__MKLITARRAY9;
    OBJFUNC         p__MKLITARRAY10;
    OBJFUNC         p__MKLITARRAY11;
    OBJFUNC         p__MKLITARRAY12;
    voidFUNC        p__NMKCHEAPBLOCK0;
    voidFUNC        p__NMKCHEAPBLOCK1;
    voidFUNC        p__NMKCHEAPBLOCK2;
    voidFUNC        p__NMKCHEAPBLOCK_N;
    OBJFUNC         p__MKPSELFMETHOD_1;
    OBJFUNC         p__MKPSELFMETHOD_2;
    OBJFUNC         p__MKPSELFMETHOD_3;
    OBJFUNC         p__MKPNILMETHOD_0;
    OBJFUNC         p__MKP0METHOD_0;
    OBJFUNC         p__MKARRAY;
    OBJFUNC         p__MKSTRING_INIT;
    OBJPTRFUNC      p__GETCHARACTERTABLE;
    voidFUNC        p__MKCLASS_META3;
    voidFUNC        p__MKINDIRSYMBOL_LIST_INIT;
    OBJFUNC         p__MKIINDIRLITARRAY;
    OBJFUNC         p__MKBARRAY;
    OBJFUNC         p__MKPARG0METHOD_1;
    OBJFUNC         p__MKPARG0METHOD_2;
    OBJFUNC         p__FLOAT_CONSTANT;
    OBJFUNC         p__FRACT_CONSTANT;
    voidFUNC        p__MAKEGLOBAL;
    OBJFUNC         p__MKINDIRLITARRAY;
    voidFUNC        p__MKSYMBOL_LIST_INIT;
    voidFUNC        p__SETGLOBAL_INIT;
    voidFUNC        p__DEFPSELFMETHOD_0;
    voidFUNC        p__METHODSFOR;
    charPTRFUNC     p__GETSYMBASE;
    voidFUNC        p__DEFPKGSOURCE;
    intFUNC         p__NNREGISTER_MODULE__;

    OBJFUNC         p__STACK_HANDLER__;
    OBJFUNC         p__STACK_HANDLER1__;
    OBJFUNC         p__STACK_HANDLER2__;
    OBJFUNC         p__STACK_HANDLER3__;
    OBJFUNC         p__STACK_HANDLER4__;
    OBJFUNC         p__STACK_HANDLER5__;
    OBJFUNC         p__STACK_HANDLER6__;
    OBJFUNC         p__STACK_HANDLER7__;
    OBJFUNC         p__STACK_HANDLER8__;
    OBJFUNC         p__STACK_HANDLER9__;
    OBJFUNC         p__STACK_HANDLER10__;
    OBJFUNC         p__STACK_HANDLER11__;
    OBJFUNC         p__STACK_HANDLER12__;
    OBJFUNC         p__STACK_HANDLER13__;
    OBJFUNC         p__STACK_HANDLER14__;
    OBJFUNC         p__STACK_HANDLER15__;
    OBJFUNC         p__STACK_HANDLER16__;
    OBJFUNC         p__STACK_HANDLER17__;
    OBJFUNC         p__STACK_HANDLER18__;
    OBJFUNC         p__STACK_HANDLER19__;
    OBJFUNC         p__STACK_HANDLER20__;

    OBJFUNC         p__STACK_HANDLER_U__;
    OBJFUNC         p__STACK_HANDLER1_U__;
    OBJFUNC         p__STACK_HANDLER2_U__;
    OBJFUNC         p__STACK_HANDLER3_U__;
    OBJFUNC         p__STACK_HANDLER4_U__;
    OBJFUNC         p__STACK_HANDLER5_U__;
    OBJFUNC         p__STACK_HANDLER6_U__;
    OBJFUNC         p__STACK_HANDLER7_U__;
    OBJFUNC         p__STACK_HANDLER8_U__;
    OBJFUNC         p__STACK_HANDLER9_U__;
    OBJFUNC         p__STACK_HANDLER10_U__;
    OBJFUNC         p__STACK_HANDLER11_U__;
    OBJFUNC         p__STACK_HANDLER12_U__;
    OBJFUNC         p__STACK_HANDLER13_U__;
    OBJFUNC         p__STACK_HANDLER14_U__;
    OBJFUNC         p__STACK_HANDLER15_U__;
    OBJFUNC         p__STACK_HANDLER16_U__;
    OBJFUNC         p__STACK_HANDLER17_U__;
    OBJFUNC         p__STACK_HANDLER18_U__;
    OBJFUNC         p__STACK_HANDLER19_U__;
    OBJFUNC         p__STACK_HANDLER20_U__;

    OBJFUNC         p__STACK_HANDLER_N__;
    OBJFUNC         p__STACK_HANDLER1_N__;
    OBJFUNC         p__STACK_HANDLER2_N__;
    OBJFUNC         p__STACK_HANDLER3_N__;
    OBJFUNC         p__STACK_HANDLER4_N__;
    OBJFUNC         p__STACK_HANDLER5_N__;
    OBJFUNC         p__STACK_HANDLER6_N__;
    OBJFUNC         p__STACK_HANDLER7_N__;
    OBJFUNC         p__STACK_HANDLER8_N__;
    OBJFUNC         p__STACK_HANDLER9_N__;
    OBJFUNC         p__STACK_HANDLER10_N__;
    OBJFUNC         p__STACK_HANDLER11_N__;
    OBJFUNC         p__STACK_HANDLER12_N__;
    OBJFUNC         p__STACK_HANDLER13_N__;
    OBJFUNC         p__STACK_HANDLER14_N__;
    OBJFUNC         p__STACK_HANDLER15_N__;
    OBJFUNC         p__STACK_HANDLER16_N__;
    OBJFUNC         p__STACK_HANDLER17_N__;
    OBJFUNC         p__STACK_HANDLER18_N__;
    OBJFUNC         p__STACK_HANDLER19_N__;
    OBJFUNC         p__STACK_HANDLER20_N__;

    OBJFUNC         p__ySTACK_HANDLER10__;
    OBJFUNC         p__ySTACK_HANDLER20__;

    OBJFUNC         p__MKREALCONTEXT;
    OBJFUNC         p__MKREALCONTEXT2;
    OBJFUNC         p__MKREALCONTEXT3;
    OBJFUNC         p__MKBLOCK;
    OBJFUNC         p__MKBLOCK0;
    OBJFUNC         p__MKBLOCK1;
    OBJFUNC         p__MKBLOCK2;

    OBJFUNC         p__ARRAY_NEW;
    OBJFUNC         p__ARRAY_NEW_INT;
    OBJFUNC         p__STRING_NEW;
    OBJFUNC         p__STRING_NEW_INT;
    OBJFUNC         p__ARRAY_WITH1;
    OBJFUNC         p__ARRAY_WITH2;
    OBJFUNC         p__ARRAY_WITH3;
    OBJFUNC         p__ARRAY_WITH4;
    OBJFUNC         p__ARRAY_WITH5;

    intFUNC         p__LE_IF_;
    intFUNC         p__GR_IF_;
    intFUNC         p__LEEQ_IF_;
    intFUNC         p__GREQ_IF_;

    OBJFUNC         p__storeInst0;
    OBJFUNC         p__storeInst1;
    OBJFUNC         p__storeInst2;
    OBJFUNC         p__storeInst3;
    OBJFUNC         p__storeInst4;
    OBJFUNC         p__storeInst5;
    OBJFUNC         p__storeInstN;
    OBJFUNC         p__gstore;
    OBJFUNC         p__gstore2;

    intFUNC         p__NNNREGISTER_MODULE__;
    OBJFUNC         p__ISKINDOF_;
    voidFUNC        p__INIT_ILC;
#ifdef OLD
    OBJFUNC         p__LARGE_CONSTANT;
#else
    OBJ             (*p__LARGE_CONSTANT)(OBJ *, char *);
#endif
    voidFUNC        p__DEFDOCMETHODS;
    OBJFUNC         p__DLMKPMETHOD_N;
    OBJFUNC         p__DLMKPMETHOD_0;
    OBJFUNC         p__DLMKPMETHOD_1;
    OBJFUNC         p__DLMKPMETHOD_2;
    OBJFUNC         p__DLMKPMETHOD_3;
    OBJFUNC         p__DMKPMETHOD_0;

    OBJFUNC         p__getCopyrightString;
    OBJFUNC         p__getDistributorString;

    OBJFUNC         p__new;
    OBJFUNC         p__newOld;
    OBJFUNC         p__lookup;
    OBJFUNC         p__interpret;
    OBJFUNC         p__threadsAvailable;
    OBJFUNC         p__threadContext;

    OBJFUNC         p__GLOBAL_GET;
    OBJFUNC         p__GLOBAL_SET;
    OBJFUNC         p__GLOBAL_KEYKNOWN;
    OBJFUNC         p__GLOBAL_REMOVE;
    OBJFUNC         p__GLOBAL_GETCELL;
    OBJFUNC         p__KNOWNASSYMBOL;
    OBJFUNC         p__INTERNSYMBOL;

    voidFUNC        p__NMKCHEAPBLOCK3;

    /*
     * the following are not really needed; however,
     * on many shared-lib systems, it is better to not take the address
     * of an external function (SGI: to be quickStartable).
     * On these systems, we access the pointers below, instead of referencing
     * these addresses directly)
     */
    OBJFUNC         p_SEND0;
    OBJFUNC         p_SEND1;
    OBJFUNC         p_SEND2;
    OBJFUNC         p_SEND3;
    OBJFUNC         p_SEND4;
    OBJFUNC         p_SEND5;
    OBJFUNC         p_SEND6;
    OBJFUNC         p_SEND7;
    OBJFUNC         p_SEND8;
    OBJFUNC         p_SEND9;
    OBJFUNC         p_SEND10;
    OBJFUNC         p_SEND11;
    OBJFUNC         p_SEND12;
    OBJFUNC         p_SEND13;
    OBJFUNC         p_SEND14;
    OBJFUNC         p_SEND15;
    OBJFUNC         p_SENDN;

    voidFUNC        p__spyInterrupt;
    voidFUNC        p__signalIoInterrupt;
    voidFUNC        p__signalUserInterrupt;
    voidFUNC        p__signalFpExceptionInterrupt;
    voidFUNC        p__signalPIPEInterrupt;
    voidFUNC        p__signalBUSInterrupt;
    voidFUNC        p__signalInterrupt;
    voidFUNC        p__signalTimerInterrupt;
    voidFUNC        p__signalChildInterrupt;
    voidFUNC        p__signalSEGVInterrupt;

    OBJFUNC         p__bRetTrue;
    OBJFUNC         p__bRetFalse;
    OBJFUNC         p__bRet0;
    OBJFUNC         p__bRetNil;
    OBJFUNC         p__retSubclassResponsibility;
    OBJFUNC         p__1retSubclassResponsibility;

    OBJFUNC         p__MKCLASS2;
    OBJFUNC         p__MKAUTOLOADCLASS;

    voidFUNC        p__MKSTRING_RLIST_INIT;
    OBJFUNC         p__MKUSCONSTARRAY;

    OBJFUNC         p__SSEND0;
    OBJFUNC         p__SSEND1;
    OBJFUNC         p__SSEND2;
    OBJFUNC         p__SSEND3;
    OBJFUNC         p__SSEND4;
    OBJFUNC         p__SSEND5;
    OBJFUNC         p__SSEND6;
    OBJFUNC         p__SSEND7;
    OBJFUNC         p__SSEND8;
    OBJFUNC         p__SSEND9;
    OBJFUNC         p__SSEND10;
    OBJFUNC         p__SSEND11;
    OBJFUNC         p__SSEND12;
    OBJFUNC         p__SSEND13;
    OBJFUNC         p__SSEND14;
    OBJFUNC         p__SSEND15;
    OBJFUNC         p__SSENDN;

    OBJFUNC         p__ySTACK_HANDLER__;
    OBJFUNC         p__ySTACK_HANDLER_N__;
    OBJFUNC         p__ySTACK_HANDLER_U__;

    OBJFUNC         p__MKREALCONTEXT4;
    OBJFUNC         p__MKREALCONTEXT5;

    intFUNC         (*p__REGISTER_CLS_MODULE__)(char *, voidFUNC, char *,int, int, int, unsigned,
			OBJFUNC, OBJFUNC *, OBJFUNC *,
			OBJ **, char *, char *,  int, OBJ *, char *, int, int);

    voidFUNC        p__MKULITARRAY0;
    voidFUNC        p__MKULITARRAY1;
    voidFUNC        p__MKULITARRAY2;
    voidFUNC        p__MKULITARRAY3;
    voidFUNC        p__MKULITARRAY4;
    voidFUNC        p__MKULITARRAY5;
    voidFUNC        p__MKULITARRAY6;
    voidFUNC        p__MKULITARRAY7;
    voidFUNC        p__MKULITARRAY8;
    voidFUNC        p__MKULITARRAY9;
    voidFUNC        p__MKULITARRAY10;
    voidFUNC        p__MKULITARRAY11;
    voidFUNC        p__MKULITARRAY12;

    OBJFUNC         p__ILC_CHECK0__;
    OBJFUNC         p__ILC_CHECK1__;
    OBJFUNC         p__ILC_CHECK2__;
    OBJFUNC         p__ILC_CHECK3__;
    OBJFUNC         p__ILC_CHECK4__;
    OBJFUNC         p__ILC_CHECK5__;
    OBJFUNC         p__ILC_CHECK6__;
    OBJFUNC         p__ILC_CHECK7__;
    OBJFUNC         p__ILC_CHECK8__;
    OBJFUNC         p__ILC_CHECK9__;
    OBJFUNC         p__ILC_CHECK10__;
    OBJFUNC         p__ILC_CHECK11__;
    OBJFUNC         p__ILC_CHECK12__;
    OBJFUNC         p__ILC_CHECK13__;
    OBJFUNC         p__ILC_CHECK14__;
    OBJFUNC         p__ILC_CHECK15__;

    OBJFUNC         p__ILC_CHECK0s__;
    OBJFUNC         p__ILC_CHECK1s__;
    OBJFUNC         p__ILC_CHECK2s__;
    OBJFUNC         p__ILC_CHECK3s__;
    OBJFUNC         p__ILC_CHECK4s__;
    OBJFUNC         p__ILC_CHECK5s__;
    OBJFUNC         p__ILC_CHECK6s__;
    OBJFUNC         p__ILC_CHECK7s__;
    OBJFUNC         p__ILC_CHECK8s__;
    OBJFUNC         p__ILC_CHECK9s__;
    OBJFUNC         p__ILC_CHECK10s__;
    OBJFUNC         p__ILC_CHECK11s__;
    OBJFUNC         p__ILC_CHECK12s__;
    OBJFUNC         p__ILC_CHECK13s__;
    OBJFUNC         p__ILC_CHECK14s__;
    OBJFUNC         p__ILC_CHECK15s__;

    OBJFUNC         p__MKPSUBMETHOD_0;
    OBJFUNC         p__MKPSUBMETHOD_1;
    OBJFUNC         p__MKPRSUBMETHOD_0;
    OBJFUNC         p__MKPRSUBMETHOD_1;

    OBJFUNC         p__STRING_CONSTANT;
    OBJFUNC         p__MKBARRAY8;
    OBJFUNC         p__MKSYMBOL;
    OBJFUNC         p__MKFRACT;
    OBJFUNC         p__MKFLOAT;
    OBJFUNC         p__MKINT;
    OBJFUNC         p__MKUINT;
    OBJFUNC         p__MKLARGEINT;
    OBJFUNC         p__MKULARGEINT;
    OBJFUNC         p__MKSTRING;
    OBJFUNC         p__MKSTRING_L;
    OBJFUNC         p__BASICNEW;
    OBJFUNC         p__BASICNEW_INT;
    OBJFUNC         p__NEW;
    OBJFUNC         p__NEW_INT;
    OBJFUNC         p__RESUMECONTEXT__;
    OBJFUNC         p__RESUMECONTEXT1__;
    voidFUNC        p__PATCHUPCONTEXT;
    voidFUNC        p__PATCHUPCONTEXTS;
    OBJFUNC         p__AT_;
    OBJFUNC         p__AT_PUT_;

    OBJFUNC         p__retGlob0;
    OBJFUNC         p__blockRefCatch;

    voidFUNC        p__interruptL;
    OBJFUNC         p__integerCheck;
    OBJFUNC         p__integerCheckL;
    OBJFUNC         p__typeCheck;
    OBJFUNC         p__typeCheckL;
    OBJFUNC         p__pointCheck;
    OBJFUNC         p__pointCheckL;
    voidFUNC        p__nestedImmediateInterrupt;
    voidFUNC        p__stxHandleInterrupt__;

    OBJFUNC         p__store;

    intFUNC         p__LE_IF2_;
    intFUNC         p__GR_IF2_;
    intFUNC         p__LEEQ_IF2_;
    intFUNC         p__GREQ_IF2_;

    OBJFUNC         p__MKEXTERNALADDRESS;
    OBJFUNC         p__MKEXTERNALBYTES;
    OBJFUNC         p__MKEXTERNALFUNCTION;

    OBJFUNC         p__SEND_AT;
    OBJFUNC         p__MKSCONSTARRAY;
    OBJFUNC         p__MKCONSTARRAY;

    OBJFUNC         p__LMKPMETHOD_0;
    OBJFUNC         p__LMKPMETHOD_1;
    OBJFUNC         p__LMKPMETHOD_2;
    OBJFUNC         p__LMKPMETHOD_3;
    OBJFUNC         p__LMKPMETHOD_N;

    voidFUNC        p__ADDMETHOD;
    intFUNC         p__REGISTER_MMODULE__;

    OBJFUNC         p__NDLMKPMETHOD_0;
    OBJFUNC         p__NDLMKPMETHOD_1;
    OBJFUNC         p__NDLMKPMETHOD_2;
    OBJFUNC         p__NDLMKPMETHOD_3;
    OBJFUNC         p__NDLMKPMETHOD_N;

    voidFUNC        p__MKCLASS_META3__;
    voidFUNC        p__MKCLASS_META4__;

    intFUNC         p__REGISTER_PRIVATE_CLS__;
    OBJFUNC         p__MKUSuCONSTARRAY;
    OBJFUNC         p__MKUBCONSTARRAY;
    OBJFUNC         p__MKUBuCONSTARRAY;
    OBJFUNC         p__MKSuCONSTARRAY;
    OBJFUNC         p__MKBCONSTARRAY;
    OBJFUNC         p__MKBuCONSTARRAY;

    OBJFUNC         p__LARGE_ICONSTANT;
    OBJFUNC         p__MAKENAMESPACE;

    UINTLFUNC       p__longIntVal;
    INTLFUNC        p__signedLongIntVal;
    OBJ             (*p__MKSFLOAT)(float);
    OBJFUNC         p__MKEMPTYSTRING;
    OBJFUNC         p__MKSTRING_ST;
    OBJFUNC         p__MKSTRING_ST_L;
    OBJFUNC         p__MKLARGEINT128;
    OBJFUNC         p__MKLARGEINT64;

    voidFUNC        p__UNNAMEDGLOBAL_BLOCK;
    OBJFUNC         p__NDMKPMETHOD_0;
    OBJFUNC         p__MKBYTEARRAY;
    voidFUNC        p__MKINDIRGLOBAL_LIST_NS;
    voidFUNC        p__MAKEINDIRGLOBAL_NS;
    OBJFUNC         p__BYTEARRAY_NEW_INT;

    voidFUNC        p__DEFPTRUEMETHOD_0;
    voidFUNC        p__DEFPFALSEMETHOD_0;
    voidFUNC        p__ADDPMETHOD;
    voidFUNC        p__BEGIN_PACKAGE2__;
    OBJFUNC         p__NMKPNILMETHOD_0;

    intFUNC         p__REGISTER_MMODULE2__;
    OBJFUNC         p__MKEXTERNALBYTES_N;
    OBJFUNC         p__MKEMPTYU16STRING;

    OBJFUNC         p__bRetInst0;
    OBJFUNC         p__bRetInst1;
    OBJFUNC         p__bRetInst2;
    OBJFUNC         p__bRetInst3;
    OBJFUNC         p__bRetInst4;
    OBJFUNC         p__bRetInst5;
    OBJFUNC         p__bRetInst6;
    OBJFUNC         p__bRetInst7;
    OBJFUNC         p__bRetInst8;
    OBJFUNC         p__bRetInst9;

    voidFUNC        p__initClass__;
    OBJFUNC         p__nMKARRAY;
    OBJFUNC         p__nUMKARRAY;

    OBJFUNC         p__MKINT64;
    OBJFUNC         p__MKUINT64;
    OBJFUNC         p__BLOCKINTERRUPTS;
    OBJFUNC         p__UNBLOCKINTERRUPTS;
    OBJFUNC         p__NMKPSELFMETHOD_0;
    OBJFUNC         p__NMKPMETHOD_N;

    OBJFUNC         p__SEND0S;
    OBJFUNC         p__SEND1S;
    OBJFUNC         p__SEND2S;
    OBJFUNC         p__SEND3S;
    OBJFUNC         p__SEND4S;
    OBJFUNC         p__SEND5S;
    OBJFUNC         p__SEND6S;
    OBJFUNC         p__SEND7S;
    OBJFUNC         p__SEND8S;
    OBJFUNC         p__SEND9S;
    OBJFUNC         p__SEND10S;
    OBJFUNC         p__SEND11S;
    OBJFUNC         p__SEND12S;
    OBJFUNC         p__SEND13S;
    OBJFUNC         p__SEND14S;
    OBJFUNC         p__SEND15S;

    OBJFUNC         p__retSelf;
    OBJFUNC         p__retSelf1;
    OBJFUNC         p__retSelf2;
    OBJFUNC         p__retSelf3;
    OBJFUNC         p__retNil;
    OBJFUNC         p__retTrue;
    OBJFUNC         p__retFalse;
    OBJFUNC         p__ret0;
    OBJFUNC         p__ret1;
    OBJFUNC         p__retArg0;
    OBJFUNC         p__retArg1_0;
    OBJFUNC         p__retArg2_0;
    OBJFUNC         p__retArg2_1;
    OBJFUNC         p__retInst0;
    OBJFUNC         p__retInst1;
    OBJFUNC         p__retInst2;
    OBJFUNC         p__retInst3;
    OBJFUNC         p__retInst4;
    OBJFUNC         p__retInst5;
    OBJFUNC         p__retInst6;
    OBJFUNC         p__retInst7;
    OBJFUNC         p__retInst8;
    OBJFUNC         p__retInst9;
    OBJFUNC         p__retInst10;
    OBJFUNC         p__retInst11;
    OBJFUNC         p__retInst12;
    OBJFUNC         p__retInst13;
    OBJFUNC         p__retInst14;
    OBJFUNC         p__retInst15;
    OBJFUNC         p__retInst16;
    OBJFUNC         p__retInst17;
    OBJFUNC         p__retInst18;
    OBJFUNC         p__retInst19;
    OBJFUNC         p__retInst20;
    OBJFUNC         p__retInst21;
    OBJFUNC         p__retInst22;
    OBJFUNC         p__retInst23;
    OBJFUNC         p__retInst24;
    OBJFUNC         p__retInst25;
    OBJFUNC         p__retInst26;
    OBJFUNC         p__retInst27;
    OBJFUNC         p__retInst28;
    OBJFUNC         p__retInst29;
    OBJFUNC         p__retInst30;
    OBJFUNC         p__setInst0;
    OBJFUNC         p__setInst1;
    OBJFUNC         p__setInst2;
    OBJFUNC         p__setInst3;
    OBJFUNC         p__setInst4;
    OBJFUNC         p__setInst5;
    OBJFUNC         p__setInst6;
    OBJFUNC         p__setInst7;
    OBJFUNC         p__setInst8;
    OBJFUNC         p__setInst9;
    OBJFUNC         p__setInst10;
    OBJFUNC         p__setInst11;
    OBJFUNC         p__setInst12;
    OBJFUNC         p__setInst13;
    OBJFUNC         p__setInst14;
    OBJFUNC         p__setInst15;
    OBJFUNC         p__setInst16;
    OBJFUNC         p__setInst17;
    OBJFUNC         p__setInst18;
    OBJFUNC         p__setInst19;
    OBJFUNC         p__setInst20;
    OBJFUNC         p__setInst21;
    OBJFUNC         p__setInst22;
    OBJFUNC         p__setInst23;
    OBJFUNC         p__setInst24;
    OBJFUNC         p__setInst25;
    OBJFUNC         p__setInst26;
    OBJFUNC         p__setInst27;
    OBJFUNC         p__setInst28;
    OBJFUNC         p__setInst29;
    OBJFUNC         p__setInst30;

    OBJFUNC         p__MKUCHARACTER;
    OBJFUNC         p__MKUTF8STRING;
    OBJFUNC         p__MKUTF8STRING_INIT;
    OBJFUNC         p__UTF8STRING_CONSTANT;
    voidFUNC        p__MKUTF8STRING_RLIST_INIT;
    voidFUNC        p__MKUTF8STRING_LIST_INIT;
    intFUNC         p__REGISTER_MMODULE3__;
    OBJFUNC         p__NMKPINSTMETHOD_0;
    OBJFUNC         p__NMKPSINSTMETHOD_1;
    OBJFUNC         p__SYMBOL_OR_NIL;
    OBJFUNC         p__mcstore;
    OBJFUNC         p__NMKPFALSEMETHOD_0;
    OBJFUNC         p__NMKPTRUEMETHOD_0;
    intFUNC         p__REGISTER_MMODULE4__;
    OBJFUNC         p__NMKPSELFMETHOD_1;
    OBJFUNC         p__NMKPSELFMETHOD_2;
    OBJFUNC         p__NMKPSELFMETHOD_3;
    OBJFUNC         p__NDMKPMETHOD_1;
    OBJFUNC         p__NDMKPMETHOD_2;
    OBJFUNC         p__NDMKPMETHOD_3;
    OBJFUNC         p__NDMKPMETHOD_N;
    OBJFUNC         p__MKEXTERNALLIBRARYFUNCTION;
    OBJFUNC         p__MKEXTERNALLIBRARYFUNCTION_V;
    OBJFUNC         p__BYTEARRAY_UNINITIALIZED_NEW_INT;

    OBJFUNC         p__NMKPSUBMETHOD_0;
    OBJFUNC         p__NMKPSUBMETHOD_1;
    OBJFUNC         p__NMKPRSUBMETHOD_0;
    OBJFUNC         p__NMKPRSUBMETHOD_1;

    OBJFUNC         p__MKPARG1METHOD_2;
    voidFUNC        p__ADD_REFCELL;
    voidFUNC        p__REMOVE_REFCELL;

    OBJFUNC         p__FIXEDPOINT_CONSTANT;
    OBJFUNC         p__NLMKPMETHOD_0;
    OBJFUNC         p__NLMKPMETHOD_1;
    OBJFUNC         p__NLMKPMETHOD_2;
    OBJFUNC         p__NLMKPMETHOD_3;
    OBJFUNC         p__NLMKPMETHOD_N;
    OBJFUNC         p__NMKPARG0METHOD_1;
    OBJFUNC         p__NMKPARG0METHOD_2;
    OBJFUNC         p__NMKPARG1METHOD_2;

    OBJFUNC         p__NMKP0METHOD_0;
    OBJ             (*p__MKU16STRING)(short*);
    OBJ             (*p__MKU16STRING_MAXLEN)(short*, int);

    voidFUNC        p__MKINDIRGLOBAL_LIST3;
    voidFUNC        p__MKINDIRGLOBAL_LIST_NS3;

    OBJFUNC         p__MKSTRING_ST_OL;
    OBJ             (*p__mkAnyString_maxlen)(short*, OBJ, int);
    OBJ             (*p__mkStringOrU16String_maxlen)(short*, int);

    voidFUNC        p__NMKCHEAPBLOCK0_P;
    voidFUNC        p__NMKCHEAPBLOCK1_P;
    voidFUNC        p__NMKCHEAPBLOCK2_P;
    voidFUNC        p__NMKCHEAPBLOCK3_P;
    voidFUNC        p__NMKCHEAPBLOCK_N_P;

    OBJFUNC         p__MKBLOCK_P;
    OBJFUNC         p__MKBLOCK0_P;
    OBJFUNC         p__MKBLOCK1_P;
    OBJFUNC         p__MKBLOCK2_P;

    OBJFUNC         p__MKBLOCK_P_H;
    OBJFUNC         p__MKBLOCK0_P_H;
    OBJFUNC         p__MKBLOCK1_P_H;
    OBJFUNC         p__MKBLOCK2_P_H;

    OBJFUNC         p__SSELFSEND0;
    OBJFUNC         p__SSELFSEND1;
    OBJFUNC         p__SSELFSEND2;
    OBJFUNC         p__SSELFSEND3;
    OBJFUNC         p__SSELFSEND4;
    OBJFUNC         p__SSELFSEND5;
    OBJFUNC         p__SSELFSEND6;
    OBJFUNC         p__SSELFSEND7;
    OBJFUNC         p__SSELFSEND8;
    OBJFUNC         p__SSELFSEND9;
    OBJFUNC         p__SSELFSEND10;
    OBJFUNC         p__SSELFSEND11;
    OBJFUNC         p__SSELFSEND12;
    OBJFUNC         p__SSELFSEND13;
    OBJFUNC         p__SSELFSEND14;
    OBJFUNC         p__SSELFSEND15;
    OBJFUNC         p__SSELFSENDN;

    OBJFUNC         p__BYTEARRAY_NEW;
    OBJ             (*p__MKSTRING_2L_INIT)(const char* str1, const size_t len1, const char* str2, const size_t len2);

    /*
     * for backward compatibility of compiled code:
     * ONLY ADD NEW ENTRIES AT THE END
     * but before the line below (i.e. above this comment)
     */
    unsigned int    __vmEntriesEndMark__;
};

/*
 * Remember,for backward compatibility:
 * ONLY ADD NEW ENTRIES AT THE END
 */
struct __vmJumps__ {
    char                jmp_SEND0[16];
    char                jmp_SEND1[16];
    char                jmp_SEND2[16];
    char                jmp_SEND3[16];
    char                jmp_SEND4[16];
    char                jmp_SEND5[16];
    char                jmp_SEND6[16];
    char                jmp_SEND7[16];
    char                jmp_SEND8[16];
    char                jmp_SEND9[16];
    char                jmp_SEND10[16];
    char                jmp_SEND11[16];
    char                jmp_SEND12[16];
    char                jmp_SEND13[16];
    char                jmp_SEND14[16];
    char                jmp_SEND15[16];
    char                jmp_SENDN[16];

    char                jmp__ySTACK_HANDLER__[16];
    char                jmp__ySTACK_HANDLER_N__[16];
    char                jmp__ySTACK_HANDLER_U__[16];
};

/*
 * Remember,for backward compatibility:
 * ONLY ADD NEW ENTRIES AT THE END
 */
struct __vmStructures__ {
    struct __instance   s_true;
    struct __instance   s_false;

    struct __Class      s_UndefinedObject;
    struct __Class      s_SmallInteger;
    struct __Class      s_Character;
    struct __Class      s_String;
    struct __Class      s_Float;
    struct __Class      s_Fraction;
    struct __Class      s_Array;
    struct __Class      s_Symbol;
    struct __Class      s_ByteArray;
    struct __Class      s_Block;
    struct __Class      s_CheapBlock;
    struct __Class      s_Method;
    struct __Class      s_Context;

    /*
     * Remember,for backward compatibility:
     * ONLY ADD NEW ENTRIES AT THE END
     */
};

/*
 * recompile everything if these numbers are changed
 */
#define __N_VM_DATA__           2048    // max # of vmData entries
#define __N_VM_MISC__           256     // max # of vmMisc entries
#define __N_VM_ENTRIES__        1024    // max # of vmEntries entries
#define __N_VM_JUMPS__          1024    // max # of vmJumps entries

// sigh: cannot use sizeof(INT) here, because defs may also be used by assembly code
#if __POINTER_SIZE_ == 4
# define __SZ_VM_DATA__          (__N_VM_DATA__*4)
# define __SZ_VM_MISC__          (__N_VM_MISC__*4)
# define __SZ_VM_ENTRIES__       (__N_VM_ENTRIES__*4)
# define __SZ_VM_JUMPS__         (__N_VM_JUMPS__)
#else
# define __SZ_VM_DATA__          (__N_VM_DATA__*8)
# define __SZ_VM_MISC__          (__N_VM_MISC__*8)
# define __SZ_VM_ENTRIES__       (__N_VM_ENTRIES__*8)
# define __SZ_VM_JUMPS__         (__N_VM_JUMPS__)
#endif

struct __vmData__ {
    union {
	struct __vmDataObjects__ byName;
	OBJ                      byIndex[__N_VM_DATA__];        /* also serves as filler */
    } ____u1____;

    union {
	struct __vmMiscData__ byName;
	char                 *filler[__N_VM_MISC__];
    } ____u2____;

    union {
	struct __vmEntries__ byName;
	char                 *filler[__N_VM_ENTRIES__];
    } ____u3____;

    union {
	struct __vmJumps__   byName;
	char             filler[__N_VM_JUMPS__];
    } ____u4____;

    struct __vmStructures__ __vmStructures__;
};

#define __vmObjects__   ____u1____.byName
#define __vmMisc__      ____u2____.byName
#define __vmEntries__   ____u3____.byName
#define __vmJumps__     ____u4____.byName

#ifndef __IN_GENOFFSETS__
# include "stcVMoffsets.h"
#endif

#if !defined(__DIRECTVMDATA__) || defined(__IN_VM__) || defined(__FIXBASE__)
 /*
  * no direct access to VM data (NT)
  */
# if defined(__IN_VM__)
#  define __VMOBJS__    (__VMDATA__.__vmObjects__)
#  define __VMMISC__    (__VMDATA__.__vmMisc__)
#  define __VMSTRUCTS__ (__VMDATA__.__vmStructures__)

#  if defined __FIXBASE__
#   define false                (OBJ)(&(__VMSTRUCTS__.s_false))
#   define __STX_false          (OBJ)(&(__VMSTRUCTS__.s_false))
#   define true                 (OBJ)(&(__VMSTRUCTS__.s_true))
#   define __STX_true           (OBJ)(&(__VMSTRUCTS__.s_true))
#  else
#   define false                (__VMOBJS__.v_false)
#   define __STX_false          (__VMOBJS__.v_false)
#   define true                 (__VMOBJS__.v_true)
#   define __STX_true           (__VMOBJS__.v_true)
#  endif

#  define UndefinedObject       (__VMOBJS__.v_UndefinedObject)
#  define __STX_UndefinedObject (__VMOBJS__.v_UndefinedObject)
#  define Array                 (__VMOBJS__.v_Array)
#  define __STX_Array           (__VMOBJS__.v_Array)
#  define ImmutableArray        (__VMOBJS__.v_ImmutableArray)
#  define __STX_ImmutableArray  (__VMOBJS__.v_ImmutableArray)
#  define Float                 (__VMOBJS__.v_Float)
#  define __STX_Float           (__VMOBJS__.v_Float)
#  define Point                 (__VMOBJS__.v_Point)
#  define __STX_Point           (__VMOBJS__.v_Point)
#  define SmallInteger          (__VMOBJS__.v_SmallInteger)
#  define __STX_SmallInteger    (__VMOBJS__.v_SmallInteger)
#  define String                (__VMOBJS__.v_String)
#  define __STX_String          (__VMOBJS__.v_String)
#  define ImmutableString       (__VMOBJS__.v_ImmutableString)
#  define __STX_ImmutableString (__VMOBJS__.v_ImmutableString)
#  define TwoByteString         (__VMOBJS__.v_TwoByteString)
#  define __STX_TwoByteString   (__VMOBJS__.v_TwoByteString)
#  define Unicode16String       (__VMOBJS__.v_Unicode16String)
#  define __STX_Unicode16String (__VMOBJS__.v_Unicode16String)
#  define Symbol                (__VMOBJS__.v_Symbol)
#  define __STX_Symbol          (__VMOBJS__.v_Symbol)
#  define Character             (__VMOBJS__.v_Character)
#  define __STX_Character       (__VMOBJS__.v_Character)
#  define ByteArray             (__VMOBJS__.v_ByteArray)
#  define __STX_ByteArray       (__VMOBJS__.v_ByteArray)
#  define ImmutableByteArray    (__VMOBJS__.v_ImmutableByteArray)
#  define __STX__ImmutableByteArray (__VMOBJS__.v_ImmutableByteArray)
#  define LargeInteger          (__VMOBJS__.v_LargeInteger)
#  define __STX_LargeInteger    (__VMOBJS__.v_LargeInteger)
#  define Method                (__VMOBJS__.v_Method)
#  define __STX_Method          (__VMOBJS__.v_Method)
#  define Block                 (__VMOBJS__.v_Block)
#  define __STX_Block           (__VMOBJS__.v_Block)
#  define CheapBlock            (__VMOBJS__.v_CheapBlock)
#  define __STX_CheapBlock      (__VMOBJS__.v_CheapBlock)
#  define BlockContext          (__VMOBJS__.v_BlockContext)
#  define __STX_BlockContext    (__VMOBJS__.v_BlockContext)
#  define Context               (__VMOBJS__.v_Context)
#  define __STX_Context         (__VMOBJS__.v_Context)
#  define WeakArray             (__VMOBJS__.v_WeakArray)
#  define __STX_WeakArray       (__VMOBJS__.v_WeakArray)
#  define WordArray                     (__VMOBJS__.v_WordArray)
#  define __STX_WordArray               (__VMOBJS__.v_WordArray)
#  define SignedWordArray               (__VMOBJS__.v_SignedWordArray)
#  define __STX_SignedWordArray         (__VMOBJS__.v_SignedWordArray)
#  define IntegerArray                  (__VMOBJS__.v_IntegerArray)
#  define __STX_IntegerArray            (__VMOBJS__.v_IntegerArray)
#  define SignedIntegerArray            (__VMOBJS__.v_SignedIntegerArray)
#  define __STX_SignedIntegerArray      (__VMOBJS__.v_SignedIntegerArray)
#  define SignedLongIntegerArray        (__VMOBJS__.v_SignedLongIntegerArray)
#  define __STX_SignedLongIntegerArray  (__VMOBJS__.v_SignedLongIntegerArray)
#  define FloatArray            (__VMOBJS__.v_FloatArray)
#  define __STX_FloatArray      (__VMOBJS__.v_FloatArray)
#  define DoubleArray           (__VMOBJS__.v_DoubleArray)
#  define __STX_DoubleArray     (__VMOBJS__.v_DoubleArray)
#  define ExternalBytes         (__VMOBJS__.v_ExternalBytes)
#  define __STX_ExternalBytes   (__VMOBJS__.v_ExternalBytes)
#  define ExternalFunction      (__VMOBJS__.v_ExternalFunction)
#  define __STX_ExternalFunction      (__VMOBJS__.v_ExternalFunction)
#  define ExternalAddress       (__VMOBJS__.v_ExternalAddress)
#  define __STX_ExternalAddress (__VMOBJS__.v_ExternalAddress)
#  define True                  (__VMOBJS__.v_True)
#  define __STX_True            (__VMOBJS__.v_True)
#  define False                 (__VMOBJS__.v_False)
#  define __STX_False           (__VMOBJS__.v_False)
#  define Class                 (__VMOBJS__.v_Class)
#  define __STX_Class           (__VMOBJS__.v_Class)
#  define Fraction              (__VMOBJS__.v_Fraction)
#  define __STX_Fraction        (__VMOBJS__.v_Fraction)
#  define FixedPoint              (__VMOBJS__.v_FixedPoint)
#  define __STX_FixedPoint        (__VMOBJS__.v_FixedPoint)
#  define Metaclass             (__VMOBJS__.v_Metaclass)
#  define __STX_Metaclass       (__VMOBJS__.v_Metaclass)
#  define PrivateMetaclass      (__VMOBJS__.v_PrivateMetaclass)
#  define __STX_PrivateMetaclass (__VMOBJS__.v_PrivateMetaclass)
#  define AutoloadMetaclass      (__VMOBJS__.v_AutoloadMetaclass)
#  define __STX_AutoloadMetaclass (__VMOBJS__.v_AutoloadMetaclass)
#  define Message               (__VMOBJS__.v_Message)
#  define __STX_Message         (__VMOBJS__.v_Message)

#  define Smalltalk             (__VMOBJS__.v_Smalltalk)
#  define __STX_Smalltalk       (__VMOBJS__.v_Smalltalk)
#  define Processor             (__VMOBJS__.v_Processor)
#  define __STX_Processor       (__VMOBJS__.v_Processor)

#  define Object                (__VMOBJS__.v_Object)
#  define __STX_Object          (__VMOBJS__.v_Object)
#  define Rectangle             (__VMOBJS__.v_Rectangle)
#  define __STX_Rectangle       (__VMOBJS__.v_Rectangle)
#  define Process               (__VMOBJS__.v_Process)
#  define __STX_Process         (__VMOBJS__.v_Process)

#  define Set                   (__VMOBJS__.v_Set)
#  define __STX_Set             (__VMOBJS__.v_Set)
#  define IdentitySet           (__VMOBJS__.v_IdentitySet)
#  define __STX_IdentitySet     (__VMOBJS__.v_IdentitySet)
#  define Dictionary            (__VMOBJS__.v_Dictionary)
#  define __STX_Dictionary      (__VMOBJS__.v_Dictionary)
#  define IdentityDictionary    (__VMOBJS__.v_IdentityDictionary)
#  define __STX_IdentityDictionary    (__VMOBJS__.v_IdentityDictionary)
#  define OrderedCollection     (__VMOBJS__.v_OrderedCollection)
#  define __STX_OrderedCollection     (__VMOBJS__.v_OrderedCollection)
#  define OperatingSystem       (__VMOBJS__.v_OperatingSystem)
#  define __STX_OperatingSystem (__VMOBJS__.v_OperatingSystem)
#  define Semaphore             (__VMOBJS__.v_Semaphore)
#  define __STX_Semaphore       (__VMOBJS__.v_Semaphore)
#  define Color                 (__VMOBJS__.v_Color)
#  define __STX_Color           (__VMOBJS__.v_Color)
#  define View                  (__VMOBJS__.v_View)
#  define __STX_View            (__VMOBJS__.v_View)
#  define MethodDictionary          (__VMOBJS__.v_MethodDictionary)
#  define __STX_MethodDictionary    (__VMOBJS__.v_MethodDictionary)
#  define ExternalLibraryFunction       (__VMOBJS__.v_ExternalLibraryFunction)
#  define __STX_ExternalLibraryFunction (__VMOBJS__.v_ExternalLibraryFunction)
#  define ShortFloat            (__VMOBJS__.v_ShortFloat)
#  define __STX_ShortFloat      (__VMOBJS__.v_ShortFloat)
#  define JavaContext           (__VMOBJS__.v_JavaContext)
#  define __STX_JavaContext     (__VMOBJS__.v_JavaContext)
#  define JavaArray             (__VMOBJS__.v_JavaArray)
#  define __STX_JavaArray       (__VMOBJS__.v_JavaArray)
#  define NameSpace             (__VMOBJS__.v_NameSpace)
#  define __STX_NameSpace       (__VMOBJS__.v_NameSpace)

#  define InterruptPending      (__VMOBJS__.v_InterruptPending)
#  define StepInterruptPending  (__VMOBJS__.v_StepInterruptPending)
#  define StepInterruptContext  (__VMOBJS__.v_StepInterruptContext)
#  define InterruptAddrLow      (__VMOBJS__.v_InterruptAddrLow)
#  define InterruptAddrHi       (__VMOBJS__.v_InterruptAddrHi)
#  define InterruptPcLow        (__VMOBJS__.v_InterruptPcLow)
#  define InterruptPcHi         (__VMOBJS__.v_InterruptPcHi)
#  define InStepInterrupt       (__VMOBJS__.v_InStepInterrupt)
#  define InterruptCause        (__VMOBJS__.v_InterruptCause)
#  define STX__float0              (__VMOBJS__.v_STX__float0)
#  define STX__float1              (__VMOBJS__.v_STX__float1)
#  define STX__floatM1              (__VMOBJS__.v_STX__floatM1)
#  define STX__float2              (__VMOBJS__.v_STX__float2)
#  define STX__float10             (__VMOBJS__.v_STX__float10)
#  define STX__float0_5            (__VMOBJS__.v_STX__float0_5)
#  define STX__float0_25            (__VMOBJS__.v_STX__float0_25)
#  define STX__float0_75            (__VMOBJS__.v_STX__float0_75)
#  define STX__float100            (__VMOBJS__.v_STX__float100)
#  define STX__sfloat0             (__VMOBJS__.v_STX__sfloat0)
#  define STX__sfloat1             (__VMOBJS__.v_STX__sfloat1)
#  define STX__sfloat2             (__VMOBJS__.v_STX__sfloat2)
#  define __minPositiveLargeInteger (__VMOBJS__.v___minPositiveLargeInteger)
#  define __maxNegativeLargeInteger (__VMOBJS__.v___maxNegativeLargeInteger)

#  define Character_CharacterTable                      (__VMOBJS__.v_Character_CharacterTable)
#  define ObjectMemory_ChildSignalInterruptHandler      (__VMOBJS__.v_ObjectMemory_ChildSignalInterruptHandler)
#  define ObjectMemory_CustomInterruptHandler           (__VMOBJS__.v_ObjectMemory_CustomInterruptHandler)
#  define ObjectMemory_DisposeInterruptHandler          (__VMOBJS__.v_ObjectMemory_DisposeInterruptHandler)
#  define ObjectMemory_ErrorInterruptHandler            (__VMOBJS__.v_ObjectMemory_ErrorInterruptHandler)
#  define ObjectMemory_ExceptionInterruptHandler        (__VMOBJS__.v_ObjectMemory_ExceptionInterruptHandler)
#  define ObjectMemory_IOInterruptHandler               (__VMOBJS__.v_ObjectMemory_IOInterruptHandler)
#  define ObjectMemory_InternalErrorHandler             (__VMOBJS__.v_ObjectMemory_InternalErrorHandler)
#  define ObjectMemory_InterruptLatencyMonitor          (__VMOBJS__.v_ObjectMemory_InterruptLatencyMonitor)
#  define ObjectMemory_MemoryInterruptHandler           (__VMOBJS__.v_ObjectMemory_MemoryInterruptHandler)
#  define ObjectMemory_RecursionInterruptHandler        (__VMOBJS__.v_ObjectMemory_RecursionInterruptHandler)
#  define ObjectMemory_SignalInterruptHandler           (__VMOBJS__.v_ObjectMemory_SignalInterruptHandler)
#  define ObjectMemory_SpyInterruptHandler              (__VMOBJS__.v_ObjectMemory_SpyInterruptHandler)
#  define ObjectMemory_StepInterruptHandler             (__VMOBJS__.v_ObjectMemory_StepInterruptHandler)
#  define ObjectMemory_TimerInterruptHandler            (__VMOBJS__.v_ObjectMemory_TimerInterruptHandler)
#  define ObjectMemory_UserInterruptHandler             (__VMOBJS__.v_ObjectMemory_UserInterruptHandler)
#  define ObjectMemory_ImageName                        (__VMOBJS__.v_ObjectMemory_ImageName)
#  define Smalltalk_StartupClass                        (__VMOBJS__.v_Smalltalk_StartupClass)
#  define Smalltalk_StartupSelector                     (__VMOBJS__.v_Smalltalk_StartupSelector)
#  define Smalltalk_StandAlone                          (__VMOBJS__.v_Smalltalk_StandAlone)
#  define Smalltalk_CommandLineArguments                (__VMOBJS__.v_Smalltalk_CommandLineArguments)
#  define __STX_Smalltalk_CommandLineArguments          (__VMOBJS__.v_Smalltalk_CommandLineArguments)
#  define Smalltalk_IgnoreAssertions                    (__VMOBJS__.v_Smalltalk_IgnoreAssertions)
#  define __STX_Smalltalk_IgnoreAssertions              (__VMOBJS__.v_Smalltalk_IgnoreAssertions)

#  define JavaVM                                        (__VMOBJS__.v_JavaVM)
#  define JavaObject                                    (__VMOBJS__.v_JavaObject)
#  define JavaMetaclass                                 (__VMOBJS__.v_JavaMetaclass)
#  define JavaArray                                     (__VMOBJS__.v_JavaArray)
#  define JavaBooleanArray                              (__VMOBJS__.v_JavaBooleanArray)
#  define JavaVM_EnteredMonitorObject                   (__VMOBJS__.v_JavaVM_EnteredMonitorObject)
#  define JavaVM_EnteredMonitorObjectCount              (__VMOBJS__.v_JavaVM_EnteredMonitorObjectCount)
#  define JavaVM_EnteredMonitorProcess                  (__VMOBJS__.v_JavaVM_EnteredMonitorProcess)
#  define JavaVM_LeftMonitorObject                      (__VMOBJS__.v_JavaVM_LeftMonitorObject)

#  define Java_java_lang_String                         (__VMOBJS__.v_Java_java_lang_String)

#  define Filename                                      (__VMOBJS__.v_Filename)
#  define __STX_Filename                                (__VMOBJS__.v_Filename)
#  define Time                                          (__VMOBJS__.v_Time)
#  define __STX_Time                                    (__VMOBJS__.v_Time)
#  define Date                                          (__VMOBJS__.v_Date)
#  define __STX_Date                                    (__VMOBJS__.v_Date)
#  define Delay                                         (__VMOBJS__.v_Delay)
#  define __STX_Delay                                   (__VMOBJS__.v_Delay)
#  define Signal                                        (__VMOBJS__.v_Signal)
#  define __STX_Signal                                  (__VMOBJS__.v_Signal)

#  define __thisContext         (__VMOBJS__.v___thisContext)
#  define __irqContext          (__VMOBJS__.v___irqContext)

#  define __asciiTable          (__VMMISC__.v___asciiTable__)
#  define __CharacterTable      (__VMMISC__.v___CharacterTable)
#  define __stackBottom__       (__VMMISC__.v___stackBottom__)
#  define __stackTop__          (__VMMISC__.v___stackTop__)

#  define __newStartPtr         (__VMMISC__.v___newStartPtr)
#  define __newEndPtr           (__VMMISC__.v___newEndPtr)
#  define __newNextPtr          (__VMMISC__.v___newNextPtr)
#  define __newSpace            (__VMMISC__.v___newSpace)
#  define __nProtect            (__VMMISC__.v___nProtect)
#  define __protectList         (__VMMISC__.v___protectList)

#  define __immediateInterrupt__  (__VMMISC__.v___immediateInterrupt__)
#  define __interruptsBlocked     (__VMMISC__.v___interruptsBlocked)
#  define __stxNCustomFunctions__ (__VMMISC__.v___stxNCustomFunctions__)
#  define __stxCustomFunctions__  (__VMMISC__.v___stxCustomFunctions__)

#  define __blockingPrimitiveTimeout__          (__VMMISC__.v___blockingPrimitiveTimeout__)
#  define __blockingPrimitiveTimoutHandler__    (__VMMISC__.v___blockingPrimitiveTimoutHandler__)
#  define __blockingPrimitiveTimeoutArg__       (__VMMISC__.v___blockingPrimitiveTimeoutArg__)
#  define __cpuType__                           (__VMMISC__.v___cpuType__)
#  define __stxThreadErrno                      (__VMMISC__.v___stxThreadErrno)
#  define __activeProcessIdtl                   (__VMMISC__.v___activeProcessIdtl)

# else /* not in VM */

   /*
    * the __VM_xxx defines can be used after inclusion
    * of some alien header file, which (re)defined those critical
    * names; one example is the Xt library, which defines its own String
    * after inclusion of such a file, restore the original definition
    * with #define String __VM_String
    * (see Xt classlib as an example)
    */
#  ifdef __FIXBASE__
#   define __VMPTR__    ((struct __vmData__ *)(__FIXBASE__))
#  else
#   ifdef __VMDATA_REF__
     extern struct __vmData__ __VMDATA__;
#    define __VMPTR__   (&__VMDATA__)
#   else
#    define __VMPTR__    __pRT__
#   endif
#  endif

#  define __VMOBJS__    (__VMPTR__->____u1____.byName)
#  define __VMMISC__    (__VMPTR__->____u2____.byName)
#  define __VMSTRUCTS__ (__VMPTR__->__vmStructures__)

#  if defined(__FIXBASE__) && defined(__VM_SEND_TABLE__)
#   undef __SEND0ADDR__
#   undef __SEND1ADDR__
#   undef __SEND2ADDR__
#   undef __SEND3ADDR__
#   undef __SEND4ADDR__
#   undef __SEND5ADDR__
#   undef __SEND6ADDR__
#   undef __SEND7ADDR__
#   undef __SEND8ADDR__
#   undef __SEND9ADDR__
#   undef __SEND10ADDR__
#   undef __SEND11ADDR__
#   undef __SEND12ADDR__
#   undef __SEND13ADDR__
#   undef __SEND14ADDR__
#   undef __SEND15ADDR__
#   undef __SENDNADDR__

#   define __SEND0ADDR__        ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SEND0))
#   define __SEND1ADDR__        ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SEND1))
#   define __SEND2ADDR__        ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SEND2))
#   define __SEND3ADDR__        ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SEND3))
#   define __SEND4ADDR__        ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SEND4))
#   define __SEND5ADDR__        ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SEND5))
#   define __SEND6ADDR__        ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SEND6))
#   define __SEND7ADDR__        ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SEND7))
#   define __SEND8ADDR__        ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SEND8))
#   define __SEND9ADDR__        ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SEND9))
#   define __SEND10ADDR__       ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SEND10))
#   define __SEND11ADDR__       ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SEND11))
#   define __SEND12ADDR__       ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SEND12))
#   define __SEND13ADDR__       ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SEND13))
#   define __SEND14ADDR__       ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SEND14))
#   define __SEND15ADDR__       ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SEND15))
#   define __SENDNADDR__        ((OBJFUNC)(__VMPTR__->__vmJumps__.jmp_SENDN))
#  endif /* FIXBASE & VM_SEND_TABLE */

#  define UndefinedObject (__VMOBJS__.v_UndefinedObject)
#  define __VM_UndefinedObject (__VMOBJS__.v_UndefinedObject)
#  define __DEF_UndefinedObject (__VMOBJS__.v_UndefinedObject)
#  define __STX_UndefinedObject (__VMOBJS__.v_UndefinedObject)

#  define Array (__VMOBJS__.v_Array)
#  define __VM_Array (__VMOBJS__.v_Array)
#  define __DEF_Array (__VMOBJS__.v_Array)
#  define __STX_Array (__VMOBJS__.v_Array)

#  define ImmutableArray (__VMOBJS__.v_ImmutableArray)
#  define __VM_ImmutableArray (__VMOBJS__.v_ImmutableArray)
#  define __DEF_ImmutableArray (__VMOBJS__.v_ImmutableArray)
#  define __STX_ImmutableArray (__VMOBJS__.v_ImmutableArray)

#  define Float (__VMOBJS__.v_Float)
#  define __VM_Float (__VMOBJS__.v_Float)
#  define __DEF_Float (__VMOBJS__.v_Float)
#  define __STX_Float (__VMOBJS__.v_Float)

#  define ShortFloat (__VMOBJS__.v_ShortFloat)
#  define __VM_ShortFloat (__VMOBJS__.v_ShortFloat)
#  define __DEF_ShortFloat (__VMOBJS__.v_ShortFloat)
#  define __STX_ShortFloat (__VMOBJS__.v_ShortFloat)

#  define Point (__VMOBJS__.v_Point)
#  define __VM_Point (__VMOBJS__.v_Point)
#  define __DEF_Point (__VMOBJS__.v_Point)
#  define __STX_Point (__VMOBJS__.v_Point)

#  define SmallInteger (__VMOBJS__.v_SmallInteger)
#  define __VM_SmallInteger (__VMOBJS__.v_SmallInteger)
#  define __DEF_SmallInteger (__VMOBJS__.v_SmallInteger)
#  define __STX_SmallInteger (__VMOBJS__.v_SmallInteger)

#  define String (__VMOBJS__.v_String)
#  define __VM_String (__VMOBJS__.v_String)
#  define __DEF_String (__VMOBJS__.v_String)
#  define __STX_String (__VMOBJS__.v_String)

#  define ImmutableString (__VMOBJS__.v_ImmutableString)
#  define __VM_ImmutableString (__VMOBJS__.v_ImmutableString)
#  define __DEF_ImmutableString (__VMOBJS__.v_ImmutableString)
#  define __STX_ImmutableString (__VMOBJS__.v_ImmutableString)

#  define TwoByteString (__VMOBJS__.v_TwoByteString)
#  define __VM_TwoByteString (__VMOBJS__.v_TwoByteString)
#  define __DEF_TwoByteString (__VMOBJS__.v_TwoByteString)
#  define __STX_TwoByteString (__VMOBJS__.v_TwoByteString)

#  define Unicode16String (__VMOBJS__.v_Unicode16String)
#  define __VM_Unicode16String (__VMOBJS__.v_Unicode16String)
#  define __DEF_Unicode16String (__VMOBJS__.v_Unicode16String)
#  define __STX_Unicode16String (__VMOBJS__.v_Unicode16String)

#  define Symbol (__VMOBJS__.v_Symbol)
#  define __VM_Symbol (__VMOBJS__.v_Symbol)
#  define __DEF_Symbol (__VMOBJS__.v_Symbol)
#  define __STX_Symbol (__VMOBJS__.v_Symbol)

#  define Character (__VMOBJS__.v_Character)
#  define __VM_Character (__VMOBJS__.v_Character)
#  define __DEF_Character (__VMOBJS__.v_Character)
#  define __STX_Character (__VMOBJS__.v_Character)

#  define ByteArray (__VMOBJS__.v_ByteArray)
#  define __VM_ByteArray (__VMOBJS__.v_ByteArray)
#  define __DEF_ByteArray (__VMOBJS__.v_ByteArray)
#  define __STX_ByteArray (__VMOBJS__.v_ByteArray)

#  define ImmutableByteArray (__VMOBJS__.v_ImmutableByteArray)
#  define __VM_ImmutableByteArray (__VMOBJS__.v_ImmutableByteArray)
#  define __DEF_ImmutableByteArray (__VMOBJS__.v_ImmutableByteArray)
#  define __STX_ImmutableByteArray (__VMOBJS__.v_ImmutableByteArray)

#  define LargeInteger (__VMOBJS__.v_LargeInteger)
#  define __VM_LargeInteger (__VMOBJS__.v_LargeInteger)
#  define __DEF_LargeInteger (__VMOBJS__.v_LargeInteger)
#  define __STX_LargeInteger (__VMOBJS__.v_LargeInteger)

#  define Method (__VMOBJS__.v_Method)
#  define __VM_Method (__VMOBJS__.v_Method)
#  define __DEF_Method (__VMOBJS__.v_Method)
#  define __STX_Method (__VMOBJS__.v_Method)

#  define Block (__VMOBJS__.v_Block)
#  define __VM_Block (__VMOBJS__.v_Block)
#  define __DEF_Block (__VMOBJS__.v_Block)
#  define __STX_Block (__VMOBJS__.v_Block)

#  define CheapBlock (__VMOBJS__.v_CheapBlock)
#  define __VM_CheapBlock (__VMOBJS__.v_CheapBlock)
#  define __DEF_CheapBlock (__VMOBJS__.v_CheapBlock)
#  define __STX_CheapBlock (__VMOBJS__.v_CheapBlock)

#  define BlockContext (__VMOBJS__.v_BlockContext)
#  define __VM_BlockContext (__VMOBJS__.v_BlockContext)
#  define __DEF_BlockContext (__VMOBJS__.v_BlockContext)
#  define __STX_BlockContext (__VMOBJS__.v_BlockContext)

#  define JavaContext (__VMOBJS__.v_JavaContext)
#  define __VM_JavaContext (__VMOBJS__.v_JavaContext)
#  define __DEF_JavaContext (__VMOBJS__.v_JavaContext)
#  define __STX_JavaContext (__VMOBJS__.v_JavaContext)

#  define Context (__VMOBJS__.v_Context)
#  define __VM_Context (__VMOBJS__.v_Context)
#  define __DEF_Context (__VMOBJS__.v_Context)
#  define __STX_Context (__VMOBJS__.v_Context)

#  define WeakArray (__VMOBJS__.v_WeakArray)
#  define __VM_WeakArray (__VMOBJS__.v_WeakArray)
#  define __DEF_WeakArray (__VMOBJS__.v_WeakArray)
#  define __STX_WeakArray (__VMOBJS__.v_WeakArray)

#  define WordArray (__VMOBJS__.v_WordArray)
#  define __VM_WordArray (__VMOBJS__.v_WordArray)
#  define __DEF_WordArray (__VMOBJS__.v_WordArray)
#  define __STX_WordArray (__VMOBJS__.v_WordArray)

#  define SignedWordArray (__VMOBJS__.v_SignedWordArray)
#  define __VM_SignedWordArray (__VMOBJS__.v_SignedWordArray)
#  define __DEF_SignedWordArray (__VMOBJS__.v_SignedWordArray)
#  define __STX_SignedWordArray (__VMOBJS__.v_SignedWordArray)

#  define IntegerArray (__VMOBJS__.v_IntegerArray)
#  define __VM_IntegerArray (__VMOBJS__.v_IntegerArray)
#  define __DEF_IntegerArray (__VMOBJS__.v_IntegerArray)
#  define __STX_IntegerArray (__VMOBJS__.v_IntegerArray)

#  define SignedIntegerArray (__VMOBJS__.v_SignedIntegerArray)
#  define __VM_SignedIntegerArray (__VMOBJS__.v_SignedIntegerArray)
#  define __DEF_SignedIntegerArray (__VMOBJS__.v_SignedIntegerArray)
#  define __STX_SignedIntegerArray (__VMOBJS__.v_SignedIntegerArray)

#  define FloatArray (__VMOBJS__.v_FloatArray)
#  define __VM_FloatArray (__VMOBJS__.v_FloatArray)
#  define __DEF_FloatArray (__VMOBJS__.v_FloatArray)
#  define __STX_FloatArray (__VMOBJS__.v_FloatArray)

#  define DoubleArray (__VMOBJS__.v_DoubleArray)
#  define __VM_DoubleArray (__VMOBJS__.v_DoubleArray)
#  define __DEF_DoubleArray (__VMOBJS__.v_DoubleArray)
#  define __STX_DoubleArray (__VMOBJS__.v_DoubleArray)

#  define ExternalBytes (__VMOBJS__.v_ExternalBytes)
#  define __VM_ExternalBytes (__VMOBJS__.v_ExternalBytes)
#  define __DEF_ExternalBytes (__VMOBJS__.v_ExternalBytes)
#  define __STX_ExternalBytes (__VMOBJS__.v_ExternalBytes)

#  define ExternalFunction (__VMOBJS__.v_ExternalFunction)
#  define __VM_ExternalFunction (__VMOBJS__.v_ExternalFunction)
#  define __DEF_ExternalFunction (__VMOBJS__.v_ExternalFunction)
#  define __STX_ExternalFunction (__VMOBJS__.v_ExternalFunction)

#  define ExternalAddress (__VMOBJS__.v_ExternalAddress)
#  define __VM_ExternalAddress (__VMOBJS__.v_ExternalAddress)
#  define __DEF_ExternalAddress (__VMOBJS__.v_ExternalAddress)
#  define __STX_ExternalAddress (__VMOBJS__.v_ExternalAddress)

#  define True (__VMOBJS__.v_True)
#  define __VM_True (__VMOBJS__.v_True)
#  define __DEF_True (__VMOBJS__.v_True)
#  define __STX_True (__VMOBJS__.v_True)

#  define False (__VMOBJS__.v_False)
#  define __VM_False (__VMOBJS__.v_False)
#  define __DEF_False (__VMOBJS__.v_False)
#  define __STX_False (__VMOBJS__.v_False)

#  define Class (__VMOBJS__.v_Class)
#  define __VM_Class (__VMOBJS__.v_Class)
#  define __DEF_Class (__VMOBJS__.v_Class)
#  define __STX_Class (__VMOBJS__.v_Class)

#  define Fraction (__VMOBJS__.v_Fraction)
#  define __VM_Fraction (__VMOBJS__.v_Fraction)
#  define __DEF_Fraction (__VMOBJS__.v_Fraction)
#  define __STX_Fraction (__VMOBJS__.v_Fraction)

#  define FixedPoint (__VMOBJS__.v_FixedPoint)
#  define __VM_FixedPoint (__VMOBJS__.v_FixedPoint)
#  define __DEF_FixedPoint (__VMOBJS__.v_FixedPoint)
#  define __STX_FixedPoint (__VMOBJS__.v_FixedPoint)

#  define Metaclass (__VMOBJS__.v_Metaclass)
#  define __VM_Metaclass (__VMOBJS__.v_Metaclass)
#  define __DEF_Metaclass (__VMOBJS__.v_Metaclass)
#  define __STX_Metaclass (__VMOBJS__.v_Metaclass)

#  define PrivateMetaclass (__VMOBJS__.v_PrivateMetaclass)
#  define __VM_PrivateMetaclass (__VMOBJS__.v_PrivateMetaclass)
#  define __DEF_PrivateMetaclass (__VMOBJS__.v_PrivateMetaclass)
#  define __STX_PrivateMetaclass (__VMOBJS__.v_PrivateMetaclass)

#  define AutoloadMetaclass (__VMOBJS__.v_AutoloadMetaclass)
#  define __VM_AutoloadMetaclass (__VMOBJS__.v_AutoloadMetaclass)
#  define __DEF_AutoloadMetaclass (__VMOBJS__.v_AutoloadMetaclass)
#  define __STX_AutoloadMetaclass (__VMOBJS__.v_AutoloadMetaclass)

#  define Message (__VMOBJS__.v_Message)
#  define __VM_Message (__VMOBJS__.v_Message)
#  define __DEF_Message (__VMOBJS__.v_Message)
#  define __STX_Message (__VMOBJS__.v_Message)

#  define Object (__VMOBJS__.v_Object)
#  define __VM_Object (__VMOBJS__.v_Object)
#  define __DEF_Object (__VMOBJS__.v_Object)
#  define __STX_Object (__VMOBJS__.v_Object)

#  define Rectangle (__VMOBJS__.v_Rectangle)
#  define __VM_Rectangle (__VMOBJS__.v_Rectangle)
#  define __DEF_Rectangle (__VMOBJS__.v_Rectangle)
#  define __STX_Rectangle (__VMOBJS__.v_Rectangle)

#  define Process (__VMOBJS__.v_Process)
#  define __VM_Process (__VMOBJS__.v_Process)
#  define __DEF_Process (__VMOBJS__.v_Process)
#  define __STX_Process (__VMOBJS__.v_Process)

#  define Set (__VMOBJS__.v_Set)
#  define __VM_Set (__VMOBJS__.v_Set)
#  define __DEF_Set (__VMOBJS__.v_Set)
#  define __STX_Set (__VMOBJS__.v_Set)

#  define IdentitySet (__VMOBJS__.v_IdentitySet)
#  define __VM_IdentitySet (__VMOBJS__.v_IdentitySet)
#  define __DEF_IdentitySet (__VMOBJS__.v_IdentitySet)
#  define __STX_IdentitySet (__VMOBJS__.v_IdentitySet)

#  define Dictionary (__VMOBJS__.v_Dictionary)
#  define __VM_Dictionary (__VMOBJS__.v_Dictionary)
#  define __DEF_Dictionary (__VMOBJS__.v_Dictionary)
#  define __STX_Dictionary (__VMOBJS__.v_Dictionary)

#  define IdentityDictionary (__VMOBJS__.v_IdentityDictionary)
#  define __VM_IdentityDictionary (__VMOBJS__.v_IdentityDictionary)
#  define __DEF_IdentityDictionary (__VMOBJS__.v_IdentityDictionary)
#  define __STX_IdentityDictionary (__VMOBJS__.v_IdentityDictionary)

#  define OrderedCollection (__VMOBJS__.v_OrderedCollection)
#  define __VM_OrderedCollection (__VMOBJS__.v_OrderedCollection)
#  define __DEF_OrderedCollection (__VMOBJS__.v_OrderedCollection)
#  define __STX_OrderedCollection (__VMOBJS__.v_OrderedCollection)

#  define OperatingSystem (__VMOBJS__.v_OperatingSystem)
#  define __VM_OperatingSystem (__VMOBJS__.v_OperatingSystem)
#  define __DEF_OperatingSystem (__VMOBJS__.v_OperatingSystem)
#  define __STX_OperatingSystem (__VMOBJS__.v_OperatingSystem)

#  define Semaphore (__VMOBJS__.v_Semaphore)
#  define __VM_Semaphore (__VMOBJS__.v_Semaphore)
#  define __DEF_Semaphore (__VMOBJS__.v_Semaphore)
#  define __STX_Semaphore (__VMOBJS__.v_Semaphore)

#  define Color (__VMOBJS__.v_Color)
#  define __VM_Color (__VMOBJS__.v_Color)
#  define __DEF_Color (__VMOBJS__.v_Color)
#  define __STX_Color (__VMOBJS__.v_Color)

#  define View (__VMOBJS__.v_View)
#  define __VM_View (__VMOBJS__.v_View)
#  define __DEF_View (__VMOBJS__.v_View)
#  define __STX_View (__VMOBJS__.v_View)

#  define MethodDictionary      (__VMOBJS__.v_MethodDictionary)
#  define __VM_MethodDictionary (__VMOBJS__.v_MethodDictionary)
#  define __DEF_MethodDictionary (__VMOBJS__.v_MethodDictionary)
#  define __STX_MethodDictionary (__VMOBJS__.v_MethodDictionary)

#  define ExternalLibraryFunction       (__VMOBJS__.v_ExternalLibraryFunction)
#  define __VM_ExternalLibraryFunction  (__VMOBJS__.v_ExternalLibraryFunction)
#  define __DEF_ExternalLibraryFunction (__VMOBJS__.v_ExternalLibraryFunction)
#  define __STX_ExternalLibraryFunction (__VMOBJS__.v_ExternalLibraryFunction)

#  define NameSpace      (__VMOBJS__.v_NameSpace)
#  define __VM_NameSpace (__VMOBJS__.v_NameSpace)
#  define __DEF_NameSpace (__VMOBJS__.v_NameSpace)
#  define __STX_NameSpace (__VMOBJS__.v_NameSpace)

#  define Smalltalk (__VMOBJS__.v_Smalltalk)
#  define __VM_Smalltalk (__VMOBJS__.v_Smalltalk)
#  define __DEF_Smalltalk (__VMOBJS__.v_Smalltalk)
#  define __STX_Smalltalk (__VMOBJS__.v_Smalltalk)

#  define Processor (__VMOBJS__.v_Processor)
#  define __VM_Processor (__VMOBJS__.v_Processor)
#  define __DEF_Processor (__VMOBJS__.v_Processor)
#  define __STX_Processor (__VMOBJS__.v_Processor)

#  define Smalltalk_CommandLineArguments (__VMOBJS__.v_Smalltalk_CommandLineArguments)
#  define __VM_Smalltalk_CommandLineArguments (__VMOBJS__.v_Smalltalk_CommandLineArguments)
#  define __DEF_Smalltalk_CommandLineArguments (__VMOBJS__.v_Smalltalk_CommandLineArguments)
#  define __STX_Smalltalk_CommandLineArguments (__VMOBJS__.v_Smalltalk_CommandLineArguments)

#  define Smalltalk_IgnoreAssertions (__VMOBJS__.v_Smalltalk_IgnoreAssertions)
#  define __VM_Smalltalk_IgnoreAssertions (__VMOBJS__.v_Smalltalk_IgnoreAssertions)
#  define __DEF_Smalltalk_IgnoreAssertions (__VMOBJS__.v_Smalltalk_IgnoreAssertions)
#  define __STX_Smalltalk_IgnoreAssertions (__VMOBJS__.v_Smalltalk_IgnoreAssertions)

#  define InterruptPending (__VMOBJS__.v_InterruptPending)
#  define __VM_InterruptPending (__VMOBJS__.v_InterruptPending)
#  define __DEF_InterruptPending (__VMOBJS__.v_InterruptPending)
#  define __STX_InterruptPending (__VMOBJS__.v_InterruptPending)

#  define StepInterruptPending (__VMOBJS__.v_StepInterruptPending)
#  define __VM_StepInterruptPending (__VMOBJS__.v_StepInterruptPending)
#  define __DEF_StepInterruptPending (__VMOBJS__.v_StepInterruptPending)
#  define __STX_StepInterruptPending (__VMOBJS__.v_StepInterruptPending)

#  define StepInterruptContext (__VMOBJS__.v_StepInterruptContext)
#  define __VM_StepInterruptContext (__VMOBJS__.v_StepInterruptContext)
#  define __DEF_StepInterruptContext (__VMOBJS__.v_StepInterruptContext)
#  define __STX_StepInterruptContext (__VMOBJS__.v_StepInterruptContext)

#  define JavaVM (__VMOBJS__.v_JavaVM)
#  define __VM_JavaVM (__VMOBJS__.v_JavaVM)
#  define __DEF_JavaVM (__VMOBJS__.v_JavaVM)
#  define __STX_JavaVM (__VMOBJS__.v_JavaVM)

#  define JavaVM_EnteredMonitorObject (__VMOBJS__.v_JavaVM_EnteredMonitorObject)
#  define __VM_JavaVM_EnteredMonitorObject (__VMOBJS__.v_JavaVM_EnteredMonitorObject)
#  define __DEF_JavaVM_EnteredMonitorObject (__VMOBJS__.v_JavaVM_EnteredMonitorObject)
#  define __STX_JavaVM_EnteredMonitorObject (__VMOBJS__.v_JavaVM_EnteredMonitorObject)

#  define JavaVM_EnteredMonitorObjectCount (__VMOBJS__.v_JavaVM_EnteredMonitorObjectCount)
#  define __VM_JavaVM_EnteredMonitorObjectCount (__VMOBJS__.v_JavaVM_EnteredMonitorObjectCount)
#  define __DEF_JavaVM_EnteredMonitorObjectCount (__VMOBJS__.v_JavaVM_EnteredMonitorObjectCount)
#  define __STX_JavaVM_EnteredMonitorObjectCount (__VMOBJS__.v_JavaVM_EnteredMonitorObjectCount)

#  define JavaVM_EnteredMonitorProcess (__VMOBJS__.v_JavaVM_EnteredMonitorProcess)
#  define __VM_JavaVM_EnteredMonitorProcess (__VMOBJS__.v_JavaVM_EnteredMonitorProcess)
#  define __DEF_JavaVM_EnteredMonitorProcess (__VMOBJS__.v_JavaVM_EnteredMonitorProcess)
#  define __STX_JavaVM_EnteredMonitorProcess (__VMOBJS__.v_JavaVM_EnteredMonitorProcess)

#  define JavaVM_LeftMonitorObject (__VMOBJS__.v_JavaVM_LeftMonitorObject)
#  define __VM_JavaVM_LeftMonitorObject (__VMOBJS__.v_JavaVM_LeftMonitorObject)
#  define __DEF_JavaVM_LeftMonitorObject (__VMOBJS__.v_JavaVM_LeftMonitorObject)
#  define __STX_JavaVM_LeftMonitorObject (__VMOBJS__.v_JavaVM_LeftMonitorObject)

#  define Filename (__VMOBJS__.v_Filename)
#  define __VM_Filename (__VMOBJS__.v_Filename)
#  define __DEF_Filename (__VMOBJS__.v_Filename)
#  define __STX_Filename (__VMOBJS__.v_Filename)

#  define Time (__VMOBJS__.v_Time)
#  define __VM_Time (__VMOBJS__.v_Time)
#  define __DEF_Time (__VMOBJS__.v_Time)
#  define __STX_Time (__VMOBJS__.v_Time)

#  define Date (__VMOBJS__.v_Date)
#  define __VM_Date (__VMOBJS__.v_Date)
#  define __DEF_Date (__VMOBJS__.v_Date)
#  define __STX_Date (__VMOBJS__.v_Date)

#  define Delay (__VMOBJS__.v_Delay)
#  define __VM_Delay (__VMOBJS__.v_Delay)
#  define __DEF_Delay (__VMOBJS__.v_Delay)
#  define __STX_Delay (__VMOBJS__.v_Delay)

#  define Signal (__VMOBJS__.v_Signal)
#  define __VM_Signal (__VMOBJS__.v_Signal)
#  define __DEF_Signal (__VMOBJS__.v_Signal)
#  define __STX_Signal (__VMOBJS__.v_Signal)

#  define __thisContext (__VMOBJS__.v___thisContext)
#  define __irqContext  (__VMOBJS__.v___irqContext)

#  define STX__float0                  (__VMOBJS__.v_STX__float0)
#  define STX__float1                  (__VMOBJS__.v_STX__float1)
#  define STX__floatM1                 (__VMOBJS__.v_STX__floatM1)
#  define STX__float2                  (__VMOBJS__.v_STX__float2)
#  define STX__float10                 (__VMOBJS__.v_STX__float10)
#  define STX__float0_5                (__VMOBJS__.v_STX__float0_5)
#  define STX__float0_25               (__VMOBJS__.v_STX__float0_25)
#  define STX__float0_75               (__VMOBJS__.v_STX__float0_75)
#  define STX__float100                (__VMOBJS__.v_STX__float100)
#  define STX__sfloat0                 (__VMOBJS__.v_STX__sfloat0)
#  define STX__sfloat1                 (__VMOBJS__.v_STX__sfloat1)
#  define STX__sfloat2                 (__VMOBJS__.v_STX__sfloat2)
#  define __minPositiveLargeInteger (__VMOBJS__.v___minPositiveLargeInteger)
#  define __maxNegativeLargeInteger (__VMOBJS__.v___maxNegativeLargeInteger)

#  define __CharacterTable        (__VMMISC__.v___CharacterTable)
#  define __newStartPtr           (__VMMISC__.v___newStartPtr)
#  define __newEndPtr             (__VMMISC__.v___newEndPtr)
#  define __newNextPtr            (__VMMISC__.v___newNextPtr)
#  define __newSpace              (__VMMISC__.v___newSpace)
#  define __nProtect              (__VMMISC__.v___nProtect)
#  define __protectList           (__VMMISC__.v___protectList)
#  define __immediateInterrupt__  (__VMMISC__.v___immediateInterrupt__)
#  define __interruptsBlocked     (__VMMISC__.v___interruptsBlocked)
#  define __stxNCustomFunctions__ (__VMMISC__.v___stxNCustomFunctions__)
#  define __stxCustomFunctions__  (__VMMISC__.v___stxCustomFunctions__)
#  define __blockingPrimitiveTimeout__  (__VMMISC__.v___blockingPrimitiveTimeout__)
#  define __blockingPrimitiveTimoutHandler__  (__VMMISC__.v___blockingPrimitiveTimoutHandler__)
#  define __blockingPrimitiveTimeoutArg__  (__VMMISC__.v___blockingPrimitiveTimeoutArg__)
#  define __cpuType__                      (__VMMISC__.v___cpuType__)
#  define __stxThreadErrno                 (__VMMISC__.v___stxThreadErrno)
#  define __activeProcessIdtl              (__VMMISC__.v___activeProcessIdtl)     

#  define __stackBottom__ (__VMMISC__.v___stackBottom__)
#  define __stackTop__ (__VMMISC__.v___stackTop__)

#  if defined(__INDIRECT_BOOL_ACCESS__) || !defined(__FIXBASE__)
#   define false (__VMOBJS__.v_false)
#   define __VM_false (__VMOBJS__.v_false)
#   define __DEF_false (__VMOBJS__.v_false)
#   define __STX_false (__VMOBJS__.v_false)
#   define true (__VMOBJS__.v_true)
#   define __VM_true (__VMOBJS__.v_true)
#   define __DEF_true (__VMOBJS__.v_true)
#   define __STX_true (__VMOBJS__.v_true)
#  else
#   define false (OBJ)(&(__VMSTRUCTS__.s_false))
#   define __VM_false (OBJ)(&(__VMSTRUCTS__.s_false))
#   define __DEF_false (OBJ)(&(__VMSTRUCTS__.s_false))
#   define __STX_false (OBJ)(&(__VMSTRUCTS__.s_false))
#   define true (OBJ)(&(__VMSTRUCTS__.s_true))
#   define __VM_true (OBJ)(&(__VMSTRUCTS__.s_true))
#   define __DEF_true (OBJ)(&(__VMSTRUCTS__.s_true))
#   define __STX_true (OBJ)(&(__VMSTRUCTS__.s_true))
#  endif

# endif /* not in VM */

#else /* __DIRECTVMDATA__ && !__IN_VM__ && !__FIXBASE__ --- direct VM data access */

# ifndef __IN_VM__
   extern OBJ true, false;
   extern OBJ STX__float0, STX__float0_5, STX__float1, STX__float2, STX__float10, STX__float100;
   extern OBJ STX__floatM1, STX__float0_25, STX__float0_75;
   extern OBJ STX__sfloat0, STX__sfloat1, STX__sfloat2, __minPositiveLargeInteger, __maxNegativeLargeInteger;
   extern OBJ SmallInteger, UndefinedObject, Float, Fraction, FixedPoint, Character, String;
   extern OBJ TwoByteString, Unicode16String;
   extern OBJ ByteArray, Array, Symbol, Smalltalk, Context, BlockContext;
   extern OBJ Class, ClassDescription, Metaclass, PrivateMetaclass, AutoloadMetaclass, Block, Point;
   extern OBJ LargeInteger, FloatArray, DoubleArray, ShortFloat;
   extern OBJ WordArray, SignedWordArray, IntegerArray, SignedIntegerArray;
   extern OBJ InterruptPending;
   extern OBJ ExternalBytes, ExternalFunction, ExternalLibraryFunction, ExternalAddress;
   extern OBJ Object, Process, Rectangle, Set, IdentitySet, Dictionary, IdentityDictionary, OrderedCollection;
   extern OBJ OperatingSystem, Semaphore, Color, View;
   extern OBJ Filename, Time, Date, Delay, Signal;
   extern OBJ ImmutableString, ImmutableArray, ImmutableByteArray;
   extern OBJ JavaContext, JavaVM;
   extern OBJ JavaVM_EnteredMonitorObject,
	      JavaVM_EnteredMonitorObjectCount,
	      JavaVM_EnteredMonitorProcess,
	      JavaVM_LeftMonitorObject;

   extern OBJ _asc_00,_asc_01,_asc_02,_asc_03,_asc_04,_asc_05,_asc_06,_asc_07;
   extern OBJ _asc_08,_asc_09,_asc_0a,_asc_0b,_asc_0c,_asc_0d,_asc_0e,_asc_0f;
   extern OBJ _asc_10,_asc_11,_asc_12,_asc_13,_asc_14,_asc_15,_asc_16,_asc_17;
   extern OBJ _asc_18,_asc_19,_asc_1a,_asc_1b,_asc_1c,_asc_1d,_asc_1e,_asc_1f;
   extern OBJ _asc_20,_asc_21,_asc_22,_asc_23,_asc_24,_asc_25,_asc_26,_asc_27;
   extern OBJ _asc_28,_asc_29,_asc_2a,_asc_2b,_asc_2c,_asc_2d,_asc_2e,_asc_2f;
   extern OBJ _asc_30,_asc_31,_asc_32,_asc_33,_asc_34,_asc_35,_asc_36,_asc_37;
   extern OBJ _asc_38,_asc_39,_asc_3a,_asc_3b,_asc_3c,_asc_3d,_asc_3e,_asc_3f;
   extern OBJ _asc_40,_asc_41,_asc_42,_asc_43,_asc_44,_asc_45,_asc_46,_asc_47;
   extern OBJ _asc_48,_asc_49,_asc_4a,_asc_4b,_asc_4c,_asc_4d,_asc_4e,_asc_4f;
   extern OBJ _asc_50,_asc_51,_asc_52,_asc_53,_asc_54,_asc_55,_asc_56,_asc_57;
   extern OBJ _asc_58,_asc_59,_asc_5a,_asc_5b,_asc_5c,_asc_5d,_asc_5e,_asc_5f;
   extern OBJ _asc_60,_asc_61,_asc_62,_asc_63,_asc_64,_asc_65,_asc_66,_asc_67;
   extern OBJ _asc_68,_asc_69,_asc_6a,_asc_6b,_asc_6c,_asc_6d,_asc_6e,_asc_6f;
   extern OBJ _asc_70,_asc_71,_asc_72,_asc_73,_asc_74,_asc_75,_asc_76,_asc_77;
   extern OBJ _asc_78,_asc_79,_asc_7a,_asc_7b,_asc_7c,_asc_7d,_asc_7e,_asc_7f;
   extern OBJ _asc_80,_asc_81,_asc_82,_asc_83,_asc_84,_asc_85,_asc_86,_asc_87;
   extern OBJ _asc_88,_asc_89,_asc_8a,_asc_8b,_asc_8c,_asc_8d,_asc_8e,_asc_8f;
   extern OBJ _asc_90,_asc_91,_asc_92,_asc_93,_asc_94,_asc_95,_asc_96,_asc_97;
   extern OBJ _asc_98,_asc_99,_asc_9a,_asc_9b,_asc_9c,_asc_9d,_asc_9e,_asc_9f;
   extern OBJ _asc_a0,_asc_a1,_asc_a2,_asc_a3,_asc_a4,_asc_a5,_asc_a6,_asc_a7;
   extern OBJ _asc_a8,_asc_a9,_asc_aa,_asc_ab,_asc_ac,_asc_ad,_asc_ae,_asc_af;
   extern OBJ _asc_b0,_asc_b1,_asc_b2,_asc_b3,_asc_b4,_asc_b5,_asc_b6,_asc_b7;
   extern OBJ _asc_b8,_asc_b9,_asc_ba,_asc_bb,_asc_bc,_asc_bd,_asc_be,_asc_bf;
   extern OBJ _asc_c0,_asc_c1,_asc_c2,_asc_c3,_asc_c4,_asc_c5,_asc_c6,_asc_c7;
   extern OBJ _asc_c8,_asc_c9,_asc_ca,_asc_cb,_asc_cc,_asc_cd,_asc_ce,_asc_cf;
   extern OBJ _asc_d0,_asc_d1,_asc_d2,_asc_d3,_asc_d4,_asc_d5,_asc_d6,_asc_d7;
   extern OBJ _asc_d8,_asc_d9,_asc_da,_asc_db,_asc_dc,_asc_dd,_asc_de,_asc_df;
   extern OBJ _asc_e0,_asc_e1,_asc_e2,_asc_e3,_asc_e4,_asc_e5,_asc_e6,_asc_e7;
   extern OBJ _asc_e8,_asc_e9,_asc_ea,_asc_eb,_asc_ec,_asc_ed,_asc_ee,_asc_ef;
   extern OBJ _asc_f0,_asc_f1,_asc_f2,_asc_f3,_asc_f4,_asc_f5,_asc_f6,_asc_f7;
   extern OBJ _asc_f8,_asc_f9,_asc_fa,_asc_fb,_asc_fc,_asc_fd,_asc_fe,_asc_ff;

   extern OBJ __CharacterTable[256];
   extern char *__newStartPtr, *__newEndPtr, *__newNextPtr;
   extern int __newSpace;
   extern char *__stackBottom__, *__stackTop__;
   extern int __nProtect;
   extern OBJ __protectList[]; // is a list of OBJs
   extern VOLATILE int __immediateInterrupt__, __interruptsBlocked;
   extern int __stxNCustomFunctions__;
   extern CUSTOMFUNCTION *__stxCustomFunctions__;
   extern int __blockingPrimitiveTimeout__;
   extern voidFUNC __blockingPrimitiveTimoutHandler__;
   extern OBJ __blockingPrimitiveTimeoutArg__;
   extern int __cpuType__, __stxThreadErrno;

   extern OBJ __irqContext;

#  ifndef THISCONTEXT_IN_REGISTER
#   ifdef __DIRECTVMDATA__
      extern OBJ __thisContext;
#   endif
#  endif

# endif /* not in VM */
#endif /* __DIRECTVMDATA__ */


#if defined(__INDIRECTVMCALLS__) && !defined(__IN_VM__)

# define __VMENTRIES__          (__VMPTR__->__vmEntries__)

# undef __MKREALCONTEXT3
# define __MKREALCONTEXT3       (*__VMENTRIES__.p__MKREALCONTEXT3)
# define __MKREALCONTEXT2       (*__VMENTRIES__.p__MKREALCONTEXT2)
# define __MKREALCONTEXT        (*__VMENTRIES__.p__MKREALCONTEXT)
# define __MKREALCONTEXT4       (*__VMENTRIES__.p__MKREALCONTEXT4)
# define __MKREALCONTEXT5       (*__VMENTRIES__.p__MKREALCONTEXT5)
# undef __ARRAY_NEW
# define __ARRAY_NEW            (*__VMENTRIES__.p__ARRAY_NEW)
# undef __ARRAY_NEW_INT
# define __ARRAY_NEW_INT        (*__VMENTRIES__.p__ARRAY_NEW_INT)
# undef __ARRAY_WITH1
# define __ARRAY_WITH1          (*__VMENTRIES__.p__ARRAY_WITH1)
# undef __ARRAY_WITH2
# define __ARRAY_WITH2          (*__VMENTRIES__.p__ARRAY_WITH2)
# undef __ARRAY_WITH3
# define __ARRAY_WITH3          (*__VMENTRIES__.p__ARRAY_WITH3)
# undef __ARRAY_WITH4
# define __ARRAY_WITH4          (*__VMENTRIES__.p__ARRAY_WITH4)
# undef __ARRAY_WITH5
# define __ARRAY_WITH5          (*__VMENTRIES__.p__ARRAY_WITH5)
# undef __STRING_NEW
# define __STRING_NEW           (*__VMENTRIES__.p__STRING_NEW)
# undef __STRING_NEW_INT
# define __STRING_NEW_INT       (*__VMENTRIES__.p__STRING_NEW_INT)
# define __MKBLOCK0_P_H         (*__VMENTRIES__.p__MKBLOCK0_P_H)
# define __MKBLOCK1_P_H         (*__VMENTRIES__.p__MKBLOCK1_P_H)
# define __MKBLOCK2_P_H         (*__VMENTRIES__.p__MKBLOCK2_P_H)
# define __MKBLOCK_P_H          (*__VMENTRIES__.p__MKBLOCK_P_H)



# define __storeInst0           (*__VMENTRIES__.p__storeInst0)
# define __storeInst1           (*__VMENTRIES__.p__storeInst1)
# define __storeInst2           (*__VMENTRIES__.p__storeInst2)
# define __storeInst3           (*__VMENTRIES__.p__storeInst3)
# define __storeInst4           (*__VMENTRIES__.p__storeInst4)
# define __storeInst5           (*__VMENTRIES__.p__storeInst5)
# define __storeInstN           (*__VMENTRIES__.p__storeInstN)
# define __store                (*__VMENTRIES__.p__store)
# define __gstore               (*__VMENTRIES__.p__gstore)
# define __gstore2              (*__VMENTRIES__.p__gstore2)
# define __GREQ_IF_             (*__VMENTRIES__.p__GREQ_IF_)
# define __GR_IF_               (*__VMENTRIES__.p__GR_IF_)
# define __LEEQ_IF_             (*__VMENTRIES__.p__LEEQ_IF_)
# define __LE_IF_               (*__VMENTRIES__.p__LE_IF_)
# define __GREQ_IF2_            (*__VMENTRIES__.p__GREQ_IF2_)
# define __GR_IF2_              (*__VMENTRIES__.p__GR_IF2_)
# define __LEEQ_IF2_            (*__VMENTRIES__.p__LEEQ_IF2_)
# define __LE_IF2_              (*__VMENTRIES__.p__LE_IF2_)
# undef __ISKINDOF_
# define __ISKINDOF_            (*__VMENTRIES__.p__ISKINDOF_)
# define __getCopyrightString      (*__VMENTRIES__.p__getCopyrightString)
# define __getDistributorString    (*__VMENTRIES__.p__getDistributorString)
# ifdef NEED___NEW
#  define __new                     (*__VMENTRIES__.p__new)
# endif
# undef __STX___new
# define __STX___new               (*__VMENTRIES__.p__new)
# define __newOld                  (*__VMENTRIES__.p__newOld)
# define __lookup                  (*__VMENTRIES__.p__lookup)
# define __interpret               (*__VMENTRIES__.p__interpret)
# define __threadsAvailable        (*__VMENTRIES__.p__threadsAvailable)
# define __threadContext           (*__VMENTRIES__.p__threadContext)
# undef __GLOBAL_GET
# define __GLOBAL_GET              (*__VMENTRIES__.p__GLOBAL_GET)
# undef __GLOBAL_SET
# define __GLOBAL_SET              (*__VMENTRIES__.p__GLOBAL_SET)
# undef __GLOBAL_KEYKNOWN
# define __GLOBAL_KEYKNOWN         (*__VMENTRIES__.p__GLOBAL_KEYKNOWN)
# undef __GLOBAL_REMOVE
# define __GLOBAL_REMOVE           (*__VMENTRIES__.p__GLOBAL_REMOVE)
# undef __GLOBAL_GETCELL
# define __GLOBAL_GETCELL          (*__VMENTRIES__.p__GLOBAL_GETCELL)
# undef __KNOWNASSYMBOL
# define __KNOWNASSYMBOL           (*__VMENTRIES__.p__KNOWNASSYMBOL)
# undef __INTERNSYMBOL
# define __INTERNSYMBOL            (*__VMENTRIES__.p__INTERNSYMBOL)
# define __SEND_AT                 (*__VMENTRIES__.p__SEND_AT)

# undef __MKSYMBOL
# define __MKSYMBOL                (*__VMENTRIES__.p__MKSYMBOL)
# define __MKFRACT                 (*__VMENTRIES__.p__MKFRACT)
# undef __MKFLOAT
# define __MKFLOAT                 (*__VMENTRIES__.p__MKFLOAT)
# define __MKSFLOAT                (*__VMENTRIES__.p__MKSFLOAT)
# undef __MKEMPTYSTRING
# define __MKEMPTYSTRING           (*__VMENTRIES__.p__MKEMPTYSTRING)
# define __MKEMPTYUSTRING          (*__VMENTRIES__.p__MKEMPTYU16STRING)
# undef __MKEMPTYU16STRING
# define __MKEMPTYU16STRING        (*__VMENTRIES__.p__MKEMPTYU16STRING)
# undef __MKU16STRING
# define __MKU16STRING             (*__VMENTRIES__.p__MKU16STRING)
# undef __MKU16STRING_MAXLEN
# define __MKU16STRING_MAXLEN              (*__VMENTRIES__.p__MKU16STRING_MAXLEN)
# define __bRetInst0               (*__VMENTRIES__.p__bRetInst0)
# define __bRetInst1               (*__VMENTRIES__.p__bRetInst1)
# define __bRetInst2               (*__VMENTRIES__.p__bRetInst2)
# define __bRetInst3               (*__VMENTRIES__.p__bRetInst3)
# define __bRetInst4               (*__VMENTRIES__.p__bRetInst4)
# define __bRetInst5               (*__VMENTRIES__.p__bRetInst5)
# define __bRetInst6               (*__VMENTRIES__.p__bRetInst6)
# define __bRetInst7               (*__VMENTRIES__.p__bRetInst7)
# define __bRetInst8               (*__VMENTRIES__.p__bRetInst8)
# define __bRetInst9               (*__VMENTRIES__.p__bRetInst9)
# define __initClass__             (*__VMENTRIES__.p__initClass__)

# undef __MKSTRING_ST
# define __MKSTRING_ST             (*__VMENTRIES__.p__MKSTRING_ST)
# undef __MKSTRING_ST_L
# define __MKSTRING_ST_L           (*__VMENTRIES__.p__MKSTRING_ST_L)
# undef __MKSTRING_ST_OL
# define __MKSTRING_ST_OL          (*__VMENTRIES__.p__MKSTRING_ST_OL)

# define __mkAnyString_maxlen           (*__VMENTRIES__.p__mkAnyString_maxlen)
# define __mkStringOrU16String_maxlen   (*__VMENTRIES__.p__mkStringOrU16String_maxlen)

# undef __MKLARGEINT128
# define __MKLARGEINT128           (*__VMENTRIES__.p__MKLARGEINT128)
# undef __MKLARGEINT64
# define __MKLARGEINT64            (*__VMENTRIES__.p__MKLARGEINT64)
# undef __MKINT
# define __MKINT                   (*__VMENTRIES__.p__MKINT)
# undef __MKUINT
# define __MKUINT                  (*__VMENTRIES__.p__MKUINT)
# undef __MKLARGEINT
# define __MKLARGEINT              (*__VMENTRIES__.p__MKLARGEINT)
# undef __MKULARGEINT
# define __MKULARGEINT             (*__VMENTRIES__.p__MKULARGEINT)
# undef __MKSTRING
# define __MKSTRING                (*__VMENTRIES__.p__MKSTRING)
# undef __MKSTRING_L
# define __MKSTRING_L              (*__VMENTRIES__.p__MKSTRING_L)
# undef __MKEXTERNALADDRESS
# define __MKEXTERNALADDRESS       (*__VMENTRIES__.p__MKEXTERNALADDRESS)
# undef __MKEXTERNALBYTES
# define __MKEXTERNALBYTES         (*__VMENTRIES__.p__MKEXTERNALBYTES)
# undef __MKEXTERNALBYTES_N
# define __MKEXTERNALBYTES_N       (*__VMENTRIES__.p__MKEXTERNALBYTES_N)
# undef __MKEXTERNALFUNCTION
# define __MKEXTERNALFUNCTION      (*__VMENTRIES__.p__MKEXTERNALFUNCTION)
# undef __MKEXTERNALLIBRARYFUNCTION
# define __MKEXTERNALLIBRARYFUNCTION    (*__VMENTRIES__.p__MKEXTERNALLIBRARYFUNCTION)
# undef __MKEXTERNALLIBRARYFUNCTION_V
# define __MKEXTERNALLIBRARYFUNCTION_V  (*__VMENTRIES__.p__MKEXTERNALLIBRARYFUNCTION_V)
# undef __BASICNEW
# define __BASICNEW                (*__VMENTRIES__.p__BASICNEW)
# undef __BASICNEW_INT
# define __BASICNEW_INT            (*__VMENTRIES__.p__BASICNEW_INT)
# undef __NEW
# define __NEW                     (*__VMENTRIES__.p__NEW)
# undef __NEW_INT
# define __NEW_INT                 (*__VMENTRIES__.p__NEW_INT)
# undef __RESUMECONTEXT__
# define __RESUMECONTEXT__         (*__VMENTRIES__.p__RESUMECONTEXT__)
# define __RESUMECONTEXT1__        (*__VMENTRIES__.p__RESUMECONTEXT1__)
# define __STACK_HANDLER__         (*__VMENTRIES__.p__STACK_HANDLER__)
# define __STACK_HANDLER1__        (*__VMENTRIES__.p__STACK_HANDLER1__)
# define __STACK_HANDLER2__        (*__VMENTRIES__.p__STACK_HANDLER2__)
# define __STACK_HANDLER3__        (*__VMENTRIES__.p__STACK_HANDLER3__)
# define __STACK_HANDLER4__        (*__VMENTRIES__.p__STACK_HANDLER4__)
# define __STACK_HANDLER5__        (*__VMENTRIES__.p__STACK_HANDLER5__)
# define __STACK_HANDLER6__        (*__VMENTRIES__.p__STACK_HANDLER6__)
# define __STACK_HANDLER7__        (*__VMENTRIES__.p__STACK_HANDLER7__)
# define __STACK_HANDLER8__        (*__VMENTRIES__.p__STACK_HANDLER8__)
# define __STACK_HANDLER9__        (*__VMENTRIES__.p__STACK_HANDLER9__)
# define __STACK_HANDLER10__       (*__VMENTRIES__.p__STACK_HANDLER10__)
# define __STACK_HANDLER11__       (*__VMENTRIES__.p__STACK_HANDLER11__)
# define __STACK_HANDLER12__       (*__VMENTRIES__.p__STACK_HANDLER12__)
# define __STACK_HANDLER13__       (*__VMENTRIES__.p__STACK_HANDLER13__)
# define __STACK_HANDLER14__       (*__VMENTRIES__.p__STACK_HANDLER14__)
# define __STACK_HANDLER15__       (*__VMENTRIES__.p__STACK_HANDLER15__)
# define __STACK_HANDLER16__       (*__VMENTRIES__.p__STACK_HANDLER16__)
# define __STACK_HANDLER17__       (*__VMENTRIES__.p__STACK_HANDLER17__)
# define __STACK_HANDLER18__       (*__VMENTRIES__.p__STACK_HANDLER18__)
# define __STACK_HANDLER19__       (*__VMENTRIES__.p__STACK_HANDLER19__)
# define __STACK_HANDLER20__       (*__VMENTRIES__.p__STACK_HANDLER20__)
# define __STACK_HANDLER_U__       (*__VMENTRIES__.p__STACK_HANDLER_U__)
# define __STACK_HANDLER1_U__      (*__VMENTRIES__.p__STACK_HANDLER1_U__)
# define __STACK_HANDLER2_U__      (*__VMENTRIES__.p__STACK_HANDLER2_U__)
# define __STACK_HANDLER3_U__      (*__VMENTRIES__.p__STACK_HANDLER3_U__)
# define __STACK_HANDLER4_U__      (*__VMENTRIES__.p__STACK_HANDLER4_U__)
# define __STACK_HANDLER5_U__      (*__VMENTRIES__.p__STACK_HANDLER5_U__)
# define __STACK_HANDLER6_U__      (*__VMENTRIES__.p__STACK_HANDLER6_U__)
# define __STACK_HANDLER7_U__      (*__VMENTRIES__.p__STACK_HANDLER7_U__)
# define __STACK_HANDLER8_U__      (*__VMENTRIES__.p__STACK_HANDLER8_U__)
# define __STACK_HANDLER9_U__      (*__VMENTRIES__.p__STACK_HANDLER9_U__)
# define __STACK_HANDLER10_U__     (*__VMENTRIES__.p__STACK_HANDLER10_U__)
# define __STACK_HANDLER11_U__     (*__VMENTRIES__.p__STACK_HANDLER11_U__)
# define __STACK_HANDLER12_U__     (*__VMENTRIES__.p__STACK_HANDLER12_U__)
# define __STACK_HANDLER13_U__     (*__VMENTRIES__.p__STACK_HANDLER13_U__)
# define __STACK_HANDLER14_U__     (*__VMENTRIES__.p__STACK_HANDLER14_U__)
# define __STACK_HANDLER15_U__     (*__VMENTRIES__.p__STACK_HANDLER15_U__)
# define __STACK_HANDLER16_U__     (*__VMENTRIES__.p__STACK_HANDLER16_U__)
# define __STACK_HANDLER17_U__     (*__VMENTRIES__.p__STACK_HANDLER17_U__)
# define __STACK_HANDLER18_U__     (*__VMENTRIES__.p__STACK_HANDLER18_U__)
# define __STACK_HANDLER19_U__     (*__VMENTRIES__.p__STACK_HANDLER19_U__)
# define __STACK_HANDLER20_U__     (*__VMENTRIES__.p__STACK_HANDLER20_U__)
# define __STACK_HANDLER_N__       (*__VMENTRIES__.p__STACK_HANDLER_N__)
# define __STACK_HANDLER1_N__      (*__VMENTRIES__.p__STACK_HANDLER1_N__)
# define __STACK_HANDLER2_N__      (*__VMENTRIES__.p__STACK_HANDLER2_N__)
# define __STACK_HANDLER3_N__      (*__VMENTRIES__.p__STACK_HANDLER3_N__)
# define __STACK_HANDLER4_N__      (*__VMENTRIES__.p__STACK_HANDLER4_N__)
# define __STACK_HANDLER5_N__      (*__VMENTRIES__.p__STACK_HANDLER5_N__)
# define __STACK_HANDLER6_N__      (*__VMENTRIES__.p__STACK_HANDLER6_N__)
# define __STACK_HANDLER7_N__      (*__VMENTRIES__.p__STACK_HANDLER7_N__)
# define __STACK_HANDLER8_N__      (*__VMENTRIES__.p__STACK_HANDLER8_N__)
# define __STACK_HANDLER9_N__      (*__VMENTRIES__.p__STACK_HANDLER9_N__)
# define __STACK_HANDLER10_N__     (*__VMENTRIES__.p__STACK_HANDLER10_N__)
# define __STACK_HANDLER11_N__     (*__VMENTRIES__.p__STACK_HANDLER11_N__)
# define __STACK_HANDLER12_N__     (*__VMENTRIES__.p__STACK_HANDLER12_N__)
# define __STACK_HANDLER13_N__     (*__VMENTRIES__.p__STACK_HANDLER13_N__)
# define __STACK_HANDLER14_N__     (*__VMENTRIES__.p__STACK_HANDLER14_N__)
# define __STACK_HANDLER15_N__     (*__VMENTRIES__.p__STACK_HANDLER15_N__)
# define __STACK_HANDLER16_N__     (*__VMENTRIES__.p__STACK_HANDLER16_N__)
# define __STACK_HANDLER17_N__     (*__VMENTRIES__.p__STACK_HANDLER17_N__)
# define __STACK_HANDLER18_N__     (*__VMENTRIES__.p__STACK_HANDLER18_N__)
# define __STACK_HANDLER19_N__     (*__VMENTRIES__.p__STACK_HANDLER19_N__)
# define __STACK_HANDLER20_N__     (*__VMENTRIES__.p__STACK_HANDLER20_N__)
# define __ySTACK_HANDLER10__      (*__VMENTRIES__.p__ySTACK_HANDLER10__)
# define __ySTACK_HANDLER20__      (*__VMENTRIES__.p__ySTACK_HANDLER20__)
# undef __PATCHUPCONTEXT
# define __PATCHUPCONTEXT          (*__VMENTRIES__.p__PATCHUPCONTEXT)
# undef __PATCHUPCONTEXTS
# define __PATCHUPCONTEXTS         (*__VMENTRIES__.p__PATCHUPCONTEXTS)
# define __AT_                     (*__VMENTRIES__.p__AT_)
# define __AT_PUT_                 (*__VMENTRIES__.p__AT_PUT_)
# define __blockRefCatch           (*__VMENTRIES__.p__blockRefCatch)
# define __interruptL              (*__VMENTRIES__.p__interruptL)
# define __integerCheck            (*__VMENTRIES__.p__integerCheck)
# define __integerCheckL           (*__VMENTRIES__.p__integerCheckL)
# define __typeCheck               (*__VMENTRIES__.p__typeCheck)
# define __typeCheckL              (*__VMENTRIES__.p__typeCheckL)
# define __pointCheck              (*__VMENTRIES__.p__pointCheck)
# define __pointCheckL             (*__VMENTRIES__.p__pointCheckL)
# define __nestedImmediateInterrupt        (*__VMENTRIES__.p__nestedImmediateInterrupt)
# define __stxHandleInterrupt__            (*__VMENTRIES__.p__stxHandleInterrupt__)

# define __SSEND0                  (*__VMENTRIES__.p__SSEND0)
# define __SSEND1                  (*__VMENTRIES__.p__SSEND1)
# define __SSEND2                  (*__VMENTRIES__.p__SSEND2)
# define __SSEND3                  (*__VMENTRIES__.p__SSEND3)
# define __SSEND4                  (*__VMENTRIES__.p__SSEND4)
# define __SSEND5                  (*__VMENTRIES__.p__SSEND5)
# define __SSEND6                  (*__VMENTRIES__.p__SSEND6)
# define __SSEND7                  (*__VMENTRIES__.p__SSEND7)
# define __SSEND8                  (*__VMENTRIES__.p__SSEND8)
# define __SSEND9                  (*__VMENTRIES__.p__SSEND9)
# define __SSEND10                 (*__VMENTRIES__.p__SSEND10)
# define __SSEND11                 (*__VMENTRIES__.p__SSEND11)
# define __SSEND12                 (*__VMENTRIES__.p__SSEND12)
# define __SSEND13                 (*__VMENTRIES__.p__SSEND13)
# define __SSEND14                 (*__VMENTRIES__.p__SSEND14)
# define __SSEND15                 (*__VMENTRIES__.p__SSEND15)

# define __SSELFSEND0                  (*__VMENTRIES__.p__SSELFSEND0)
# define __SSELFSEND1                  (*__VMENTRIES__.p__SSELFSEND1)
# define __SSELFSEND2                  (*__VMENTRIES__.p__SSELFSEND2)
# define __SSELFSEND3                  (*__VMENTRIES__.p__SSELFSEND3)
# define __SSELFSEND4                  (*__VMENTRIES__.p__SSELFSEND4)
# define __SSELFSEND5                  (*__VMENTRIES__.p__SSELFSEND5)
# define __SSELFSEND6                  (*__VMENTRIES__.p__SSELFSEND6)
# define __SSELFSEND7                  (*__VMENTRIES__.p__SSELFSEND7)
# define __SSELFSEND8                  (*__VMENTRIES__.p__SSELFSEND8)
# define __SSELFSEND9                  (*__VMENTRIES__.p__SSELFSEND9)
# define __SSELFSEND10                 (*__VMENTRIES__.p__SSELFSEND10)
# define __SSELFSEND11                 (*__VMENTRIES__.p__SSELFSEND11)
# define __SSELFSEND12                 (*__VMENTRIES__.p__SSELFSEND12)
# define __SSELFSEND13                 (*__VMENTRIES__.p__SSELFSEND13)
# define __SSELFSEND14                 (*__VMENTRIES__.p__SSELFSEND14)
# define __SSELFSEND15                 (*__VMENTRIES__.p__SSELFSEND15)
# define __SSELFSENDN                  (*__VMENTRIES__.p__SSELFSENDN)

#else /* DIRECTVMCALLS or in_VM */

  OBJ __MKREALCONTEXT3(), __MKREALCONTEXT2(), __MKREALCONTEXT();
  OBJ __MKREALCONTEXT4(), __MKREALCONTEXT5();

  OBJ __ARRAY_NEW(), __ARRAY_NEW_INT();
  OBJ __STRING_NEW(), __STRING_NEW_INT();
  OBJ __MKBLOCK_P_H(), __MKBLOCK0_P_H(), __MKBLOCK1_P_H(), __MKBLOCK2_P_H();
  OBJ __storeInst0(), __storeInst1(), __storeInst2(), __storeInst3();
  OBJ __storeInst4(), __storeInst5(), __storeInstN();
  OBJ __gstore(), __gstore2(), __store();
  int __GREQ_IF_(), __GR_IF_(), __LEEQ_IF_(), __LE_IF_();
  int __GREQ_IF2_(), __GR_IF2_(), __LEEQ_IF2_(), __LE_IF2_();
  OBJ __ARRAY_WITH1(), __ARRAY_WITH2(), __ARRAY_WITH3(), __ARRAY_WITH4(), __ARRAY_WITH5();
  OBJ __getCopyrightString(), __getDistributorString();
  OBJ __STX___new(), __newOld(), __lookup(), __interpret();
  OBJ __threadsAvailable(), __threadContext();
  OBJ __GLOBAL_GET(), __GLOBAL_SET(), __GLOBAL_KEYKNOWN();
  OBJ __GLOBAL_REMOVE(), __GLOBAL_GETCELL();
  OBJ __KNOWNASSYMBOL(), __INTERNSYMBOL();

  OBJ __SEND_AT();
  OBJ __ISKINDOF_();

  OBJ __MKSYMBOL(char *cp, OBJ* refP);
  OBJ __MKFRACT();
  OBJ __MKFLOAT(double);
  OBJ __MKSFLOAT(float);
  OBJ __MKU16STRING(short *), __MKU16STRING_MAXLEN(short *, int);
  OBJ __MKEMPTYSTRING(), __MKEMPTYU16STRING(), __MKSTRING_ST(), __MKSTRING_ST_L(), __MKSTRING_ST_OL();
  OBJ __mkAnyString_maxlen(short*, OBJ, int);
  OBJ __mkStringOrU16String_maxlen(short*, int);
  OBJ __MKLARGEINT128(), __MKLARGEINT64();
  OBJ __bRetInst0(), __bRetInst1(), __bRetInst2(), __bRetInst3(), __bRetInst4();
  OBJ __bRetInst5(), __bRetInst6(), __bRetInst7(), __bRetInst8(), __bRetInst9();
  void __initClass__();
  OBJ __MKINT(INT);
  OBJ __MKUINT(unsigned INT);
  OBJ __MKLARGEINT(INT);
  OBJ __MKULARGEINT(unsigned INT);
  OBJ __MKSTRING(char *);
  OBJ __MKSTRING_L(char *, int);
  OBJ __MKEXTERNALADDRESS();
  OBJ __MKEXTERNALBYTES();
  OBJ __MKEXTERNALBYTES_N();
  OBJ __MKEXTERNALFUNCTION();
  OBJ __MKEXTERNALLIBRARYFUNCTION();
  OBJ __MKEXTERNALLIBRARYFUNCTION_V();
  OBJ __RESUMECONTEXT__();
  OBJ __RESUMECONTEXT1__();
  void __PATCHUPCONTEXT();
  void __PATCHUPCONTEXTS();
  OBJ __AT_();
  OBJ __AT_PUT_();

  OBJ __BASICNEW(), __NEW(), __NEW_INT(), __BASICNEW_INT();

  void __interruptL();
  OBJ __integerCheck(), __typeCheck(), __integerCheckL(), __typeCheckL();
  OBJ __pointCheckL(), __pointCheck(), __pointCheckLReg(), __pointCheckReg();
  OBJ __blockRefCatch();
  void __nestedImmediateInterrupt(), __stxHandleInterrupt__();

  OBJ __STACK_HANDLER__();
  OBJ __STACK_HANDLER1__();
  OBJ __STACK_HANDLER2__();
  OBJ __STACK_HANDLER3__();
  OBJ __STACK_HANDLER4__();
  OBJ __STACK_HANDLER5__();
  OBJ __STACK_HANDLER6__();
  OBJ __STACK_HANDLER7__();
  OBJ __STACK_HANDLER8__();
  OBJ __STACK_HANDLER9__();
  OBJ __STACK_HANDLER10__();
  OBJ __STACK_HANDLER11__();
  OBJ __STACK_HANDLER12__();
  OBJ __STACK_HANDLER13__();
  OBJ __STACK_HANDLER14__();
  OBJ __STACK_HANDLER15__();
  OBJ __STACK_HANDLER16__();
  OBJ __STACK_HANDLER17__();
  OBJ __STACK_HANDLER18__();
  OBJ __STACK_HANDLER19__();
  OBJ __STACK_HANDLER20__();

  OBJ __STACK_HANDLER_U__();
  OBJ __STACK_HANDLER1_U__();
  OBJ __STACK_HANDLER2_U__();
  OBJ __STACK_HANDLER3_U__();
  OBJ __STACK_HANDLER4_U__();
  OBJ __STACK_HANDLER5_U__();
  OBJ __STACK_HANDLER6_U__();
  OBJ __STACK_HANDLER7_U__();
  OBJ __STACK_HANDLER8_U__();
  OBJ __STACK_HANDLER9_U__();
  OBJ __STACK_HANDLER10_U__();
  OBJ __STACK_HANDLER11_U__();
  OBJ __STACK_HANDLER12_U__();
  OBJ __STACK_HANDLER13_U__();
  OBJ __STACK_HANDLER14_U__();
  OBJ __STACK_HANDLER15_U__();
  OBJ __STACK_HANDLER16_U__();
  OBJ __STACK_HANDLER17_U__();
  OBJ __STACK_HANDLER18_U__();
  OBJ __STACK_HANDLER19_U__();
  OBJ __STACK_HANDLER20_U__();

  OBJ __STACK_HANDLER_N__();
  OBJ __STACK_HANDLER1_N__();
  OBJ __STACK_HANDLER2_N__();
  OBJ __STACK_HANDLER3_N__();
  OBJ __STACK_HANDLER4_N__();
  OBJ __STACK_HANDLER5_N__();
  OBJ __STACK_HANDLER6_N__();
  OBJ __STACK_HANDLER7_N__();
  OBJ __STACK_HANDLER8_N__();
  OBJ __STACK_HANDLER9_N__();
  OBJ __STACK_HANDLER10_N__();
  OBJ __STACK_HANDLER11_N__();
  OBJ __STACK_HANDLER12_N__();
  OBJ __STACK_HANDLER13_N__();
  OBJ __STACK_HANDLER14_N__();
  OBJ __STACK_HANDLER15_N__();
  OBJ __STACK_HANDLER16_N__();
  OBJ __STACK_HANDLER17_N__();
  OBJ __STACK_HANDLER18_N__();
  OBJ __STACK_HANDLER19_N__();
  OBJ __STACK_HANDLER20_N__();

  OBJ __SSEND0(), __SSEND1(), __SSEND2(), __SSEND3();
  OBJ __SSEND4(), __SSEND5(), __SSEND6(), __SSEND7();
  OBJ __SSEND8(), __SSEND9(), __SSEND10(), __SSEND11();
  OBJ __SSEND12(), __SSEND13(), __SSEND14(), __SSEND15();
  OBJ __SSELFSEND0(), __SSELFSEND1(), __SSELFSEND2(), __SSELFSEND3();
  OBJ __SSELFSEND4(), __SSELFSEND5(), __SSELFSEND6(), __SSELFSEND7();
  OBJ __SSELFSEND8(), __SSELFSEND9(), __SSELFSEND10(), __SSELFSEND11();
  OBJ __SSELFSEND12(), __SSELFSEND13(), __SSELFSEND14(), __SSELFSEND15(), __SSELFSENDN();

  OBJ __ySTACK_HANDLER__();
  OBJ __ySTACK_HANDLER10__();
  OBJ __ySTACK_HANDLER20__();

#endif /* DIRECTVMCALLS or in_VM */

OBJ __BLOCKINTERRUPTS();
OBJ __UNBLOCKINTERRUPTS();

#if defined(__INDIRECTVMINITCALLS__) && !defined(__IN_VM__)

# ifndef __VMPTR__
#  define __VMPTR__     __pRT__
# endif

# ifndef __VMENTRIES__
#  define __VMENTRIES__          (__VMPTR__->__vmEntries__)
# endif

# define __MKMETHODARRAY           (*__VMENTRIES__.p__MKMETHODARRAY)
# define __MKLITARRAY1             (*__VMENTRIES__.p__MKLITARRAY1)
# define __MKLITARRAY2             (*__VMENTRIES__.p__MKLITARRAY2)
# define __MKLITARRAY3             (*__VMENTRIES__.p__MKLITARRAY3)
# define __MKLITARRAY4             (*__VMENTRIES__.p__MKLITARRAY4)
# define __MKLITARRAY5             (*__VMENTRIES__.p__MKLITARRAY5)
# define __MKLITARRAY6             (*__VMENTRIES__.p__MKLITARRAY6)
# define __MKLITARRAY7             (*__VMENTRIES__.p__MKLITARRAY7)
# define __MKLITARRAY8             (*__VMENTRIES__.p__MKLITARRAY8)
# define __MKLITARRAY9             (*__VMENTRIES__.p__MKLITARRAY9)
# define __MKLITARRAY10            (*__VMENTRIES__.p__MKLITARRAY10)
# define __MKLITARRAY11            (*__VMENTRIES__.p__MKLITARRAY11)
# define __MKLITARRAY12            (*__VMENTRIES__.p__MKLITARRAY12)
# define __PACKAGE__               (*__VMENTRIES__.p__PACKAGE__)
# define __DEFSOURCE               (*__VMENTRIES__.p__DEFSOURCE)
# define __BEGIN_PACKAGE__         (*__VMENTRIES__.p__BEGIN_PACKAGE__)
# define __BEGIN_PACKAGE2__        (*__VMENTRIES__.p__BEGIN_PACKAGE2__)
# define __END_PACKAGE__           (*__VMENTRIES__.p__END_PACKAGE__)
# undef __MKSTRING_INIT
# define __MKSTRING_INIT           (*__VMENTRIES__.p__MKSTRING_INIT)
# undef __MKSTRING_2L_INIT
# define __MKSTRING_2L_INIT        (*__VMENTRIES__.p__MKSTRING_2L_INIT)
# undef __MKUTF8STRING_INIT
# define __MKUTF8STRING_INIT       (*__VMENTRIES__.p__MKUTF8STRING_INIT)
# undef __MKUTF8STRING
# define __MKUTF8STRING            (*__VMENTRIES__.p__MKUTF8STRING)
# define __MKCONSTBARRAY           (*__VMENTRIES__.p__MKCONSTBARRAY)
# define __MKCONSTARRAY            (*__VMENTRIES__.p__MKCONSTARRAY)
# define __MKUSCONSTARRAY          (*__VMENTRIES__.p__MKUSCONSTARRAY)
# define __MKUSuCONSTARRAY         (*__VMENTRIES__.p__MKUSuCONSTARRAY)
# define __MKUBCONSTARRAY          (*__VMENTRIES__.p__MKUBCONSTARRAY)
# define __MKUBuCONSTARRAY         (*__VMENTRIES__.p__MKUBuCONSTARRAY)
# define __MKSCONSTARRAY           (*__VMENTRIES__.p__MKSCONSTARRAY)
# define __MKSuCONSTARRAY          (*__VMENTRIES__.p__MKSuCONSTARRAY)
# define __MKBCONSTARRAY           (*__VMENTRIES__.p__MKBCONSTARRAY)
# define __MKBuCONSTARRAY          (*__VMENTRIES__.p__MKBuCONSTARRAY)
# define __MKCLASS                 (*__VMENTRIES__.p__MKCLASS)
# define __MKCLASS2                (*__VMENTRIES__.p__MKCLASS2)
# define __MKAUTOLOADCLASS         (*__VMENTRIES__.p__MKAUTOLOADCLASS)
# define __DMKPMETHOD_0            (*__VMENTRIES__.p__DMKPMETHOD_0)
# define __DEFDOCMETHODS           (*__VMENTRIES__.p__DEFDOCMETHODS)
# define __DLMKPMETHOD_N           (*__VMENTRIES__.p__DLMKPMETHOD_N)
# define __DLMKPMETHOD_0           (*__VMENTRIES__.p__DLMKPMETHOD_0)
# define __DLMKPMETHOD_1           (*__VMENTRIES__.p__DLMKPMETHOD_1)
# define __DLMKPMETHOD_2           (*__VMENTRIES__.p__DLMKPMETHOD_2)
# define __DLMKPMETHOD_3           (*__VMENTRIES__.p__DLMKPMETHOD_3)
# define __LMKPMETHOD_N            (*__VMENTRIES__.p__LMKPMETHOD_N)
# define __LMKPMETHOD_0            (*__VMENTRIES__.p__LMKPMETHOD_0)
# define __LMKPMETHOD_1            (*__VMENTRIES__.p__LMKPMETHOD_1)
# define __LMKPMETHOD_2            (*__VMENTRIES__.p__LMKPMETHOD_2)
# define __LMKPMETHOD_3            (*__VMENTRIES__.p__LMKPMETHOD_3)
# define __MKCLASS_META4           (*__VMENTRIES__.p__MKCLASS_META4)
# define __MKCLASS_META3           (*__VMENTRIES__.p__MKCLASS_META3)
# define __MKCLASS_META4__         (*__VMENTRIES__.p__MKCLASS_META4__)
# define __MKCLASS_META3__         (*__VMENTRIES__.p__MKCLASS_META3__)
# define __MKUNNAMEDCONSTARRAY     (*__VMENTRIES__.p__MKUNNAMEDCONSTARRAY)
# define __NNNREGISTER_MODULE__    (*__VMENTRIES__.p__NNNREGISTER_MODULE__)
# define __REGISTER_CLS_MODULE__   (*__VMENTRIES__.p__REGISTER_CLS_MODULE__)
# define __REGISTER_MMODULE__      (*__VMENTRIES__.p__REGISTER_MMODULE__)
# define __REGISTER_MMODULE2__     (*__VMENTRIES__.p__REGISTER_MMODULE2__)
# define __REGISTER_MMODULE3__     (*__VMENTRIES__.p__REGISTER_MMODULE3__)
# undef __REGISTER_MMODULE4__
# define __REGISTER_MMODULE4__     (*__VMENTRIES__.p__REGISTER_MMODULE4__)
# define __REGISTER_PRIVATE_CLS__  (*__VMENTRIES__.p__REGISTER_PRIVATE_CLS__)
# define __NDLMKPMETHOD_N          (*__VMENTRIES__.p__NDLMKPMETHOD_N)
# define __NDLMKPMETHOD_0          (*__VMENTRIES__.p__NDLMKPMETHOD_0)
# define __NDLMKPMETHOD_1          (*__VMENTRIES__.p__NDLMKPMETHOD_1)
# define __NDLMKPMETHOD_2          (*__VMENTRIES__.p__NDLMKPMETHOD_2)
# define __NDLMKPMETHOD_3          (*__VMENTRIES__.p__NDLMKPMETHOD_3)
# define __NDMKPMETHOD_0           (*__VMENTRIES__.p__NDMKPMETHOD_0)
# define __NDMKPMETHOD_1           (*__VMENTRIES__.p__NDMKPMETHOD_1)
# define __NDMKPMETHOD_2           (*__VMENTRIES__.p__NDMKPMETHOD_2)
# define __NDMKPMETHOD_3           (*__VMENTRIES__.p__NDMKPMETHOD_3)
# define __NDMKPMETHOD_N           (*__VMENTRIES__.p__NDMKPMETHOD_N)
# undef __MKBYTEARRAY
# define __MKBYTEARRAY             (*__VMENTRIES__.p__MKBYTEARRAY)
# undef __BYTEARRAY_NEW_INT
# define __BYTEARRAY_NEW_INT       (*__VMENTRIES__.p__BYTEARRAY_NEW_INT)
# undef __BYTEARRAY_NEW
# define __BYTEARRAY_NEW           (*__VMENTRIES__.p__BYTEARRAY_NEW)
# undef __BYTEARRAY_UNINITIALIZED_NEW_INT
# define __BYTEARRAY_UNINITIALIZED_NEW_INT       (*__VMENTRIES__.p__BYTEARRAY_UNINITIALIZED_NEW_INT)
# define __MKINDIRGLOBAL_LIST_NS   (*__VMENTRIES__.p__MKINDIRGLOBAL_LIST_NS)
# define __MKINDIRGLOBAL_LIST_NS3  (*__VMENTRIES__.p__MKINDIRGLOBAL_LIST_NS3)
# define __MAKEINDIRGLOBAL_NS      (*__VMENTRIES__.p__MAKEINDIRGLOBAL_NS)
# define __MKPINSTMETHOD_0         (*__VMENTRIES__.p__MKPINSTMETHOD_0)
# define __NMKPNILMETHOD_0         (*__VMENTRIES__.p__NMKPNILMETHOD_0)
# define __NMKPFALSEMETHOD_0       (*__VMENTRIES__.p__NMKPFALSEMETHOD_0)
# define __NMKPTRUEMETHOD_0        (*__VMENTRIES__.p__NMKPTRUEMETHOD_0)
# define __NMKPINSTMETHOD_0        (*__VMENTRIES__.p__NMKPINSTMETHOD_0)
# define __NMKPSINSTMETHOD_1       (*__VMENTRIES__.p__NMKPSINSTMETHOD_1)
# undef __SYMBOL_OR_NIL
# define __SYMBOL_OR_NIL           (*__VMENTRIES__.p__SYMBOL_OR_NIL)
# define __mcstore                 (*__VMENTRIES__.p__mcstore)
# define __DEFMETHODCATEGORY       (*__VMENTRIES__.p__DEFMETHODCATEGORY)
# define __DEFPKGSOURCE            (*__VMENTRIES__.p__DEFPKGSOURCE)
# define __MKSTRING_LIST_INIT      (*__VMENTRIES__.p__MKSTRING_LIST_INIT)
# define __MKUTF8STRING_LIST_INIT  (*__VMENTRIES__.p__MKUTF8STRING_LIST_INIT)
# define __MKSTRING_RLIST_INIT     (*__VMENTRIES__.p__MKSTRING_RLIST_INIT)
# define __MKUTF8STRING_RLIST_INIT (*__VMENTRIES__.p__MKUTF8STRING_RLIST_INIT)
# define __MKINDIRGLOBAL_LIST      (*__VMENTRIES__.p__MKINDIRGLOBAL_LIST)
# define __MKINDIRGLOBAL_LIST3     (*__VMENTRIES__.p__MKINDIRGLOBAL_LIST3)
# define __MKINDIRSYMBOL_LIST_INIT (*__VMENTRIES__.p__MKINDIRSYMBOL_LIST_INIT)
# define __MKSYMBOL_LIST_INIT      (*__VMENTRIES__.p__MKSYMBOL_LIST_INIT)
# define __MAKEINDIRGLOBAL         (*__VMENTRIES__.p__MAKEINDIRGLOBAL)
# define __DEFPMETHOD              (*__VMENTRIES__.p__DEFPMETHOD)
# define __DEFPSELFMETHOD_0        (*__VMENTRIES__.p__DEFPSELFMETHOD_0)
# define __DEFPTRUEMETHOD_0        (*__VMENTRIES__.p__DEFPTRUEMETHOD_0)
# define __DEFPFALSEMETHOD_0       (*__VMENTRIES__.p__DEFPFALSEMETHOD_0)
# define __ADDMETHOD               (*__VMENTRIES__.p__ADDMETHOD)
# define __ADDPMETHOD              (*__VMENTRIES__.p__ADDPMETHOD)
# define __FLOAT_CONSTANT          (*__VMENTRIES__.p__FLOAT_CONSTANT)
# define __FRACT_CONSTANT          (*__VMENTRIES__.p__FRACT_CONSTANT)
# define __LARGE_CONSTANT          (*__VMENTRIES__.p__LARGE_CONSTANT)
# define __LARGE_ICONSTANT         (*__VMENTRIES__.p__LARGE_ICONSTANT)
# define __FIXEDPOINT_CONSTANT     (*__VMENTRIES__.p__FIXEDPOINT_CONSTANT)
# define __NLMKPMETHOD_0           (*__VMENTRIES__.p__NLMKPMETHOD_0)
# define __NLMKPMETHOD_1           (*__VMENTRIES__.p__NLMKPMETHOD_1)
# define __NLMKPMETHOD_2           (*__VMENTRIES__.p__NLMKPMETHOD_2)
# define __NLMKPMETHOD_3           (*__VMENTRIES__.p__NLMKPMETHOD_3)
# define __NLMKPMETHOD_N           (*__VMENTRIES__.p__NLMKPMETHOD_N)
# define __NMKP0METHOD_0           (*__VMENTRIES__.p__NMKP0METHOD_0)
# define __NMKPARG0METHOD_1        (*__VMENTRIES__.p__NMKPARG0METHOD_1)
# define __NMKPARG0METHOD_2        (*__VMENTRIES__.p__NMKPARG0METHOD_2)
# define __NMKPARG1METHOD_2        (*__VMENTRIES__.p__NMKPARG1METHOD_2)
# define __MAKENAMESPACE           (*__VMENTRIES__.p__MAKENAMESPACE)
# define __MKPFALSEMETHOD_0        (*__VMENTRIES__.p__MKPFALSEMETHOD_0)
# define __MKPSELFMETHOD_0         (*__VMENTRIES__.p__MKPSELFMETHOD_0)
# define __MKPSELFMETHOD_1         (*__VMENTRIES__.p__MKPSELFMETHOD_1)
# define __MKPSELFMETHOD_2         (*__VMENTRIES__.p__MKPSELFMETHOD_2)
# define __MKPSELFMETHOD_3         (*__VMENTRIES__.p__MKPSELFMETHOD_3)
# define __MKPTRUEMETHOD_0         (*__VMENTRIES__.p__MKPTRUEMETHOD_0)
# undef __UNNAMEDGLOBAL
# define __UNNAMEDGLOBAL           (*__VMENTRIES__.p__UNNAMEDGLOBAL)
# define __UNNAMEDGLOBAL_BLOCK     (*__VMENTRIES__.p__UNNAMEDGLOBAL_BLOCK)
# define __MKPMETHOD_0             (*__VMENTRIES__.p__MKPMETHOD_0)
# define __MKPMETHOD_1             (*__VMENTRIES__.p__MKPMETHOD_1)
# define __MKPMETHOD_2             (*__VMENTRIES__.p__MKPMETHOD_2)
# define __MKPMETHOD_3             (*__VMENTRIES__.p__MKPMETHOD_3)
# define __MKPMETHOD_N             (*__VMENTRIES__.p__MKPMETHOD_N)
# define __MKPSINSTMETHOD_1        (*__VMENTRIES__.p__MKPSINSTMETHOD_1)
# define __MKPNILMETHOD_0          (*__VMENTRIES__.p__MKPNILMETHOD_0)
# define __MKPARG0METHOD_1         (*__VMENTRIES__.p__MKPARG0METHOD_1)
# define __MKPARG0METHOD_2         (*__VMENTRIES__.p__MKPARG0METHOD_2)
# define __MKPARG1METHOD_2         (*__VMENTRIES__.p__MKPARG1METHOD_2)
# define __NMKCHEAPBLOCK0          (*__VMENTRIES__.p__NMKCHEAPBLOCK0)
# define __NMKCHEAPBLOCK1          (*__VMENTRIES__.p__NMKCHEAPBLOCK1)
# define __NMKCHEAPBLOCK2          (*__VMENTRIES__.p__NMKCHEAPBLOCK2)
# define __NMKCHEAPBLOCK3          (*__VMENTRIES__.p__NMKCHEAPBLOCK3)
# define __NMKCHEAPBLOCK_N         (*__VMENTRIES__.p__NMKCHEAPBLOCK_N)
# define __NMKCHEAPBLOCK0_P        (*__VMENTRIES__.p__NMKCHEAPBLOCK0_P)
# define __NMKCHEAPBLOCK1_P        (*__VMENTRIES__.p__NMKCHEAPBLOCK1_P)
# define __NMKCHEAPBLOCK2_P        (*__VMENTRIES__.p__NMKCHEAPBLOCK2_P)
# define __NMKCHEAPBLOCK3_P        (*__VMENTRIES__.p__NMKCHEAPBLOCK3_P)
# define __NMKCHEAPBLOCK_N_P       (*__VMENTRIES__.p__NMKCHEAPBLOCK_N_P)
# define __MKP0METHOD_0            (*__VMENTRIES__.p__MKP0METHOD_0)
# define __ADD_REFCELL             (*__VMENTRIES__.p__ADD_REFCELL)
# define __REMOVE_REFCELL          (*__VMENTRIES__.p__REMOVE_REFCELL)
# define __GETSYMBASE              (*__VMENTRIES__.p__GETSYMBASE)
# define __MKULITARRAY0            (*__VMENTRIES__.p__MKULITARRAY0)
# define __MKULITARRAY1            (*__VMENTRIES__.p__MKULITARRAY1)
# define __MKULITARRAY2            (*__VMENTRIES__.p__MKULITARRAY2)
# define __MKULITARRAY3            (*__VMENTRIES__.p__MKULITARRAY3)
# define __MKULITARRAY4            (*__VMENTRIES__.p__MKULITARRAY4)
# define __MKULITARRAY5            (*__VMENTRIES__.p__MKULITARRAY5)
# define __MKULITARRAY6            (*__VMENTRIES__.p__MKULITARRAY6)
# define __MKULITARRAY7            (*__VMENTRIES__.p__MKULITARRAY7)
# define __MKULITARRAY8            (*__VMENTRIES__.p__MKULITARRAY8)
# define __MKULITARRAY9            (*__VMENTRIES__.p__MKULITARRAY9)
# define __MKULITARRAY10           (*__VMENTRIES__.p__MKULITARRAY10)
# define __MKULITARRAY11           (*__VMENTRIES__.p__MKULITARRAY11)
# define __MKULITARRAY12           (*__VMENTRIES__.p__MKULITARRAY12)
# define __MKARRAY                 (*__VMENTRIES__.p__MKARRAY)
# define __nMKARRAY                (*__VMENTRIES__.p__nMKARRAY)
# define __nUMKARRAY               (*__VMENTRIES__.p__nUMKARRAY)
# undef __MKINT64
# define __MKINT64                 (*__VMENTRIES__.p__MKINT64)
# undef __MKUINT64
# define __MKUINT64                (*__VMENTRIES__.p__MKUINT64)
# undef __BLOCKINTERRUPTS
# define __BLOCKINTERRUPTS         (*__VMENTRIES__.p__BLOCKINTERRUPTS)
# undef __UNBLOCKINTERRUPTS
# define __UNBLOCKINTERRUPTS       (*__VMENTRIES__.p__UNBLOCKINTERRUPTS)
# define __NMKPSELFMETHOD_0        (*__VMENTRIES__.p__NMKPSELFMETHOD_0)
# define __NMKPSELFMETHOD_1        (*__VMENTRIES__.p__NMKPSELFMETHOD_1)
# define __NMKPSELFMETHOD_2        (*__VMENTRIES__.p__NMKPSELFMETHOD_2)
# define __NMKPSELFMETHOD_3        (*__VMENTRIES__.p__NMKPSELFMETHOD_3)
# define __NMKPMETHOD_N            (*__VMENTRIES__.p__NMKPMETHOD_N)
# define __SEND0S                  (*__VMENTRIES__.p__SEND0S)
# define __SEND1S                  (*__VMENTRIES__.p__SEND1S)
# define __SEND2S                  (*__VMENTRIES__.p__SEND2S)
# define __SEND3S                  (*__VMENTRIES__.p__SEND3S)
# define __SEND4S                  (*__VMENTRIES__.p__SEND4S)
# define __SEND5S                  (*__VMENTRIES__.p__SEND5S)
# define __SEND6S                  (*__VMENTRIES__.p__SEND6S)
# define __SEND7S                  (*__VMENTRIES__.p__SEND7S)
# define __SEND8S                  (*__VMENTRIES__.p__SEND8S)
# define __SEND9S                  (*__VMENTRIES__.p__SEND9S)
# define __SEND10S                 (*__VMENTRIES__.p__SEND10S)
# define __SEND11S                 (*__VMENTRIES__.p__SEND11S)
# define __SEND12S                 (*__VMENTRIES__.p__SEND12S)
# define __SEND13S                 (*__VMENTRIES__.p__SEND13S)
# define __SEND14S                 (*__VMENTRIES__.p__SEND14S)
# define __SEND15S                 (*__VMENTRIES__.p__SEND15S)
# define __MKBARRAY                (*__VMENTRIES__.p__MKBARRAY)
# define __MKBARRAY8               (*__VMENTRIES__.p__MKBARRAY8)
# undef __MAKEGLOBAL
# define __MAKEGLOBAL              (*__VMENTRIES__.p__MAKEGLOBAL)
# define __MKPSUBMETHOD_0          (*__VMENTRIES__.p__MKPSUBMETHOD_0)
# define __MKPSUBMETHOD_1          (*__VMENTRIES__.p__MKPSUBMETHOD_1)
# define __MKPRSUBMETHOD_0         (*__VMENTRIES__.p__MKPRSUBMETHOD_0)
# define __MKPRSUBMETHOD_1         (*__VMENTRIES__.p__MKPRSUBMETHOD_1)
# define __NMKPSUBMETHOD_0         (*__VMENTRIES__.p__NMKPSUBMETHOD_0)
# define __NMKPSUBMETHOD_1         (*__VMENTRIES__.p__NMKPSUBMETHOD_1)
# define __NMKPRSUBMETHOD_0        (*__VMENTRIES__.p__NMKPRSUBMETHOD_0)
# define __NMKPRSUBMETHOD_1        (*__VMENTRIES__.p__NMKPRSUBMETHOD_1)
# define __STRING_CONSTANT         (*__VMENTRIES__.p__STRING_CONSTANT)
# define __UTF8STRING_CONSTANT     (*__VMENTRIES__.p__UTF8STRING_CONSTANT)
# define __longIntVal              (*__VMENTRIES__.p__longIntVal)
# define __signedLongIntVal        (*__VMENTRIES__.p__signedLongIntVal)
# define __interrupt__             (*__VMENTRIES__.p__interrupt__)

#if defined(__osx__) && defined(__STATIC_LINK__)
# define _SEND0                  (*__VMENTRIES__.p_SEND0)
# define _SEND1                  (*__VMENTRIES__.p_SEND1)
# define _SEND2                  (*__VMENTRIES__.p_SEND2)
# define _SEND3                  (*__VMENTRIES__.p_SEND3)
# define _SEND4                  (*__VMENTRIES__.p_SEND4)
# define _SEND5                  (*__VMENTRIES__.p_SEND5)
# define _SEND6                  (*__VMENTRIES__.p_SEND6)
# define _SEND7                  (*__VMENTRIES__.p_SEND7)
# define _SEND8                  (*__VMENTRIES__.p_SEND8)
# define _SEND9                  (*__VMENTRIES__.p_SEND9)
# define _SEND10                 (*__VMENTRIES__.p_SEND10)
# define _SEND11                 (*__VMENTRIES__.p_SEND11)
# define _SEND12                 (*__VMENTRIES__.p_SEND12)
# define _SEND13                 (*__VMENTRIES__.p_SEND13)
# define _SEND14                 (*__VMENTRIES__.p_SEND14)
# define _SEND15                 (*__VMENTRIES__.p_SEND15)
#endif

#else /* DIRECTVMINITCALLS or in_VM */

  OBJ  __MKMETHODARRAY();
  OBJ  __MKLITARRAY1();
  OBJ  __MKLITARRAY2();
  OBJ  __MKLITARRAY3();
  OBJ  __MKLITARRAY4();
  OBJ  __MKLITARRAY5();
  OBJ  __MKLITARRAY6();
  OBJ  __MKLITARRAY7();
  OBJ  __MKLITARRAY8();
  OBJ  __MKLITARRAY9();
  OBJ  __MKLITARRAY10();
  OBJ  __MKLITARRAY11();
  OBJ  __MKLITARRAY12();
  void __MKULITARRAY0();
  void __MKULITARRAY1();
  void __MKULITARRAY2();
  void __MKULITARRAY3();
  void __MKULITARRAY4();
  void __MKULITARRAY5();
  void __MKULITARRAY6();
  void __MKULITARRAY7();
  void __MKULITARRAY8();
  void __MKULITARRAY9();
  void __MKULITARRAY10();
  void __MKULITARRAY11();
  void __MKULITARRAY12();
  OBJ  __MKSTRING_INIT();
  OBJ  __MKSTRING_2L_INIT(const char* str1, const size_t len1, const char* str2, const size_t len2);
  OBJ  __MKUTF8STRING();
  OBJ  __MKUTF8STRING_INIT();
  OBJ  __MKCONSTBARRAY();
  OBJ  __MKUSCONSTARRAY(), __MKSCONSTARRAY();
  OBJ  __MKUSuCONSTARRAY(), __MKSuCONSTARRAY();
  OBJ  __MKUBCONSTARRAY(), __MKBCONSTARRAY();
  OBJ  __MKUBuCONSTARRAY(), __MKBuCONSTARRAY();
  OBJ  __MKCONSTARRAY();
  OBJ  __MKCLASS(), __MKCLASS2(), __MKAUTOLOADCLASS();
  OBJ  __DMKPMETHOD_0();
  void __DEFDOCMETHODS();
  OBJ  __DLMKPMETHOD_N();
  OBJ  __DLMKPMETHOD_0();
  OBJ  __DLMKPMETHOD_1();
  OBJ  __DLMKPMETHOD_2();
  OBJ  __DLMKPMETHOD_3();
  OBJ  __LMKPMETHOD_N();
  OBJ  __LMKPMETHOD_0();
  OBJ  __LMKPMETHOD_1();
  OBJ  __LMKPMETHOD_2();
  OBJ  __LMKPMETHOD_3();
  OBJ  __NDLMKPMETHOD_N();
  OBJ  __NDLMKPMETHOD_0();
  OBJ  __NDLMKPMETHOD_1();
  OBJ  __NDLMKPMETHOD_2();
  OBJ  __NDLMKPMETHOD_3();
  void __MKCLASS_META4();
  void __MKCLASS_META3();
  void __MKCLASS_META4__();
  void __MKCLASS_META3__();

  void __BEGIN_PACKAGE__();
  void __BEGIN_PACKAGE2__();
  void __END_PACKAGE__();
  OBJ  __MKUNNAMEDCONSTARRAY();
  int  __NNNREGISTER_MODULE__();
  OBJ  __MKPINSTMETHOD_0();
  OBJ  __NMKPNILMETHOD_0();
  OBJ  __NMKPFALSEMETHOD_0();
  OBJ  __NMKPTRUEMETHOD_0();
  OBJ  __NMKPINSTMETHOD_0();
  OBJ  __NMKPSINSTMETHOD_1();
  OBJ  __SYMBOL_OR_NIL();
  OBJ  __mcstore();
  void __DEFMETHODCATEGORY();
  void __DEFPKGSOURCE();
  void __MKSTRING_LIST_INIT();
  void __MKUTF8STRING_LIST_INIT();
  void __MKSTRING_RLIST_INIT();
  void __MKUTF8STRING_RLIST_INIT();
  void __MKINDIRGLOBAL_LIST();
  void __MKINDIRGLOBAL_LIST3();
  void __MAKEINDIRGLOBAL();
  void __DEFPMETHOD();
  void __DEFPSELFMETHOD_0();
  void __DEFPTRUEMETHOD_0();
  void __DEFPFALSEMETHOD_0();
  void __ADDMETHOD();
  void __ADDPMETHOD();
  OBJ  __FLOAT_CONSTANT();
  OBJ  __FRACT_CONSTANT();
  OBJ  __LARGE_CONSTANT();
  OBJ  __LARGE_ICONSTANT();
  OBJ __FIXEDPOINT_CONSTANT();
  OBJ __NLMKPMETHOD_0();
  OBJ __NLMKPMETHOD_1();
  OBJ __NLMKPMETHOD_2();
  OBJ __NLMKPMETHOD_3();
  OBJ __NLMKPMETHOD_N();
  OBJ __NMKP0METHOD_0();
  OBJ __NMKPARG0METHOD_1();
  OBJ  __NMKPARG0METHOD_2();
  OBJ  __NMKPARG1METHOD_2();
  OBJ  __MAKENAMESPACE();
  OBJ  __MKPFALSEMETHOD_0();
  OBJ  __MKPSELFMETHOD_0();
  OBJ  __MKPSELFMETHOD_1();
  OBJ  __MKPSELFMETHOD_2();
  OBJ  __MKPSELFMETHOD_3();
  OBJ  __MKPTRUEMETHOD_0();
  void __UNNAMEDGLOBAL();
  void __UNNAMEDGLOBAL_BLOCK();
  OBJ  __MKPMETHOD_0();
  OBJ  __MKPMETHOD_1();
  OBJ  __MKPMETHOD_2();
  OBJ  __MKPMETHOD_3();
  OBJ  __MKPMETHOD_N();
  OBJ  __NDMKPMETHOD_0();
  OBJ  __NDMKPMETHOD_1();
  OBJ  __NDMKPMETHOD_2();
  OBJ  __NDMKPMETHOD_3();
  OBJ  __NDMKPMETHOD_N();
  OBJ  __MKBYTEARRAY(char *, INT);
  OBJ  __BYTEARRAY_NEW_INT(int);
  OBJ  __BYTEARRAY_NEW(OBJ);
  OBJ  __BYTEARRAY_UNINITIALIZED_NEW_INT(int);
  OBJ  __ARRAY_UNINITIALIZED_NEW_INT(int);
  void __MKINDIRGLOBAL_LIST_NS();
  void __MKINDIRGLOBAL_LIST_NS3();
  void __MAKEINDIRGLOBAL_NS();
  OBJ  __MKPSINSTMETHOD_1();
  OBJ  __MKPNILMETHOD_0();
  OBJ  __MKPARG0METHOD_1();
  OBJ  __MKPARG0METHOD_2();
  OBJ  __MKPARG1METHOD_2();
  void __NMKCHEAPBLOCK0();
  void __NMKCHEAPBLOCK1();
  void __NMKCHEAPBLOCK2();
  void __NMKCHEAPBLOCK3();
  void __NMKCHEAPBLOCK_N();
  void __NMKCHEAPBLOCK0_P();
  void __NMKCHEAPBLOCK1_P();
  void __NMKCHEAPBLOCK2_P();
  void __NMKCHEAPBLOCK3_P();
  void __NMKCHEAPBLOCK_N_P();
  void __ADD_REFCELL();
  void __REMOVE_REFCELL();
  OBJ  __MKP0METHOD_0();
  char *__GETSYMBASE();
  int  __REGISTER_CLS_MODULE__();
  int  __REGISTER_PRIVATE_CLS__();
  int  __REGISTER_MMODULE__();
  int  __REGISTER_MMODULE2__();
  int  __REGISTER_MMODULE3__();
  int  __REGISTER_MMODULE4__();
  OBJ  __MKARRAY();
  OBJ  __nMKARRAY();
  OBJ  __nUMKARRAY();
  OBJ  __MKINT64();
  OBJ  __MKUINT64();
  OBJ  __BLOCKINTERRUPTS();
  OBJ  __UNBLOCKINTERRUPTS();
  OBJ  __NMKPSELFMETHOD_0();
  OBJ  __NMKPSELFMETHOD_1();
  OBJ  __NMKPSELFMETHOD_2();
  OBJ  __NMKPSELFMETHOD_3();
  OBJ  __NMKPMETHOD_N();
  OBJ  __SEND0S();
  OBJ  __SEND1S();
  OBJ  __SEND2S();
  OBJ  __SEND3S();
  OBJ  __SEND4S();
  OBJ  __SEND5S();
  OBJ  __SEND6S();
  OBJ  __SEND7S();
  OBJ  __SEND8S();
  OBJ  __SEND9S();
  OBJ  __SEND10S();
  OBJ  __SEND11S();
  OBJ  __SEND12S();
  OBJ  __SEND13S();
  OBJ  __SEND14S();
  OBJ  __SEND15S();
  OBJ  __MKBARRAY();
  OBJ  __MKBARRAY8();
  void __MAKEGLOBAL();
  OBJ  __MKPSUBMETHOD_0();
  OBJ  __MKPSUBMETHOD_1();
  OBJ  __MKPRSUBMETHOD_0();
  OBJ  __MKPRSUBMETHOD_1();
  OBJ  __NMKPSUBMETHOD_0();
  OBJ  __NMKPSUBMETHOD_1();
  OBJ  __NMKPRSUBMETHOD_0();
  OBJ  __NMKPRSUBMETHOD_1();
  OBJ  __STRING_CONSTANT();
  OBJ  __UTF8STRING_CONSTANT();

  OBJ __STACK_HANDLER__();
  OBJ __STACK_HANDLER1__();
  OBJ __STACK_HANDLER2__();
  OBJ __STACK_HANDLER3__();
  OBJ __STACK_HANDLER4__();
  OBJ __STACK_HANDLER5__();
  OBJ __STACK_HANDLER6__();
  OBJ __STACK_HANDLER7__();
  OBJ __STACK_HANDLER8__();
  OBJ __STACK_HANDLER9__();
  OBJ __STACK_HANDLER10__();
  OBJ __STACK_HANDLER11__();
  OBJ __STACK_HANDLER12__();
  OBJ __STACK_HANDLER13__();
  OBJ __STACK_HANDLER14__();
  OBJ __STACK_HANDLER15__();
  OBJ __STACK_HANDLER16__();
  OBJ __STACK_HANDLER17__();
  OBJ __STACK_HANDLER18__();
  OBJ __STACK_HANDLER19__();
  OBJ __STACK_HANDLER20__();

  OBJ __STACK_HANDLER_U__();
  OBJ __STACK_HANDLER1_U__();
  OBJ __STACK_HANDLER2_U__();
  OBJ __STACK_HANDLER3_U__();
  OBJ __STACK_HANDLER4_U__();
  OBJ __STACK_HANDLER5_U__();
  OBJ __STACK_HANDLER6_U__();
  OBJ __STACK_HANDLER7_U__();
  OBJ __STACK_HANDLER8_U__();
  OBJ __STACK_HANDLER9_U__();
  OBJ __STACK_HANDLER10_U__();
  OBJ __STACK_HANDLER11_U__();
  OBJ __STACK_HANDLER12_U__();
  OBJ __STACK_HANDLER13_U__();
  OBJ __STACK_HANDLER14_U__();
  OBJ __STACK_HANDLER15_U__();
  OBJ __STACK_HANDLER16_U__();
  OBJ __STACK_HANDLER17_U__();
  OBJ __STACK_HANDLER18_U__();
  OBJ __STACK_HANDLER19_U__();
  OBJ __STACK_HANDLER20_U__();

  OBJ __STACK_HANDLER_N__();
  OBJ __STACK_HANDLER1_N__();
  OBJ __STACK_HANDLER2_N__();
  OBJ __STACK_HANDLER3_N__();
  OBJ __STACK_HANDLER4_N__();
  OBJ __STACK_HANDLER5_N__();
  OBJ __STACK_HANDLER6_N__();
  OBJ __STACK_HANDLER7_N__();
  OBJ __STACK_HANDLER8_N__();
  OBJ __STACK_HANDLER9_N__();
  OBJ __STACK_HANDLER10_N__();
  OBJ __STACK_HANDLER11_N__();
  OBJ __STACK_HANDLER12_N__();
  OBJ __STACK_HANDLER13_N__();
  OBJ __STACK_HANDLER14_N__();
  OBJ __STACK_HANDLER15_N__();
  OBJ __STACK_HANDLER16_N__();
  OBJ __STACK_HANDLER17_N__();
  OBJ __STACK_HANDLER18_N__();
  OBJ __STACK_HANDLER19_N__();
  OBJ __STACK_HANDLER20_N__();

  OBJ __SSEND0(), __SSEND1(), __SSEND2(), __SSEND3();
  OBJ __SSEND4(), __SSEND5(), __SSEND6(), __SSEND7();
  OBJ __SSEND8(), __SSEND9(), __SSEND10(), __SSEND11();
  OBJ __SSEND12(), __SSEND13(), __SSEND14(), __SSEND15();

  OBJ __SSELFSEND0(), __SSELFSEND1(), __SSELFSEND2(), __SSELFSEND3();
  OBJ __SSELFSEND4(), __SSELFSEND5(), __SSELFSEND6(), __SSELFSEND7();
  OBJ __SSELFSEND8(), __SSELFSEND9(), __SSELFSEND10(), __SSELFSEND11();
  OBJ __SSELFSEND12(), __SSELFSEND13(), __SSELFSEND14(), __SSELFSEND15(), __SSELFSENDN();

  OBJ _SEND0(), _SEND1(), _SEND2(), _SEND3();
  OBJ _SEND4(), _SEND5(), _SEND6(), _SEND7();
  OBJ _SEND8(), _SEND9(), _SEND10(), _SEND11();
  OBJ _SEND12(), _SEND13(), _SEND14(), _SEND15();
  OBJ _SENDN();

  unsigned INT __longIntVal();
  INT __signedLongIntVal();
  void __interrupt__();

#endif /* not __INDIRECTVMINITCALLS__ */

#if !defined(__DIRECTVMFUNCREFS__) && !defined(__IN_VM__)

# define __spyInterrupt                 (*__VMENTRIES__.p__spyInterrupt)
# define __signalIoInterrupt            (*__VMENTRIES__.p__signalIoInterrupt)
# define __signalUserInterrupt          (*__VMENTRIES__.p__signalUserInterrupt)
# define __signalFpExceptionInterrupt   (*__VMENTRIES__.p__signalFpExceptionInterrupt)
# define __signalPIPEInterrupt          (*__VMENTRIES__.p__signalPIPEInterrupt)
# define __signalBUSInterrupt           (*__VMENTRIES__.p__signalBUSInterrupt)
# define __signalInterrupt              (*__VMENTRIES__.p__signalInterrupt)
# define __signalTimerInterrupt         (*__VMENTRIES__.p__signalTimerInterrupt)
# define __signalChildInterrupt         (*__VMENTRIES__.p__signalChildInterrupt)
# define __signalSEGVInterrupt          (*__VMENTRIES__.p__signalSEGVInterrupt)

# define __bRetTrue                     (*__VMENTRIES__.p__bRetTrue)
# define __bRetFalse                    (*__VMENTRIES__.p__bRetFalse)
# define __bRetNil                      (*__VMENTRIES__.p__bRetNil)
# define __bRet0                        (*__VMENTRIES__.p__bRet0)
# define __retSubclassResponsibility    (*__VMENTRIES__.p__retSubclassResponsibility)
# define __1retSubclassResponsibility   (*__VMENTRIES__.p__1retSubclassResponsibility)
# define __retGlob0                     (*__VMENTRIES__.p__retGlob0)
# define __retSelf                      (*__VMENTRIES__.p__retSelf)
# define __retSelf1                     (*__VMENTRIES__.p__retSelf1)
# define __retSelf2                     (*__VMENTRIES__.p__retSelf2)
# define __retSelf3                     (*__VMENTRIES__.p__retSelf3)
# define __retNil                       (*__VMENTRIES__.p__retNil)
# define __retTrue                      (*__VMENTRIES__.p__retTrue)
# define __retFalse                     (*__VMENTRIES__.p__retFalse)
# define __ret0                         (*__VMENTRIES__.p__ret0)
# define __ret1                         (*__VMENTRIES__.p__ret1)
# define __retArg0                      (*__VMENTRIES__.p__retArg0)
# define __retArg1_0                    (*__VMENTRIES__.p__retArg1_0)
# define __retArg2_0                    (*__VMENTRIES__.p__retArg2_0)
# define __retArg2_1                    (*__VMENTRIES__.p__retArg2_1)
# define __retInst0                     (*__VMENTRIES__.p__retInst0)
# define __retInst1                     (*__VMENTRIES__.p__retInst1)
# define __retInst2                     (*__VMENTRIES__.p__retInst2)
# define __retInst3                     (*__VMENTRIES__.p__retInst3)
# define __retInst4                     (*__VMENTRIES__.p__retInst4)
# define __retInst5                     (*__VMENTRIES__.p__retInst5)
# define __retInst6                     (*__VMENTRIES__.p__retInst6)
# define __retInst7                     (*__VMENTRIES__.p__retInst7)
# define __retInst8                     (*__VMENTRIES__.p__retInst8)
# define __retInst9                     (*__VMENTRIES__.p__retInst9)
# define __retInst10                    (*__VMENTRIES__.p__retInst10)
# define __retInst11                    (*__VMENTRIES__.p__retInst11)
# define __retInst12                    (*__VMENTRIES__.p__retInst12)
# define __retInst13                    (*__VMENTRIES__.p__retInst13)
# define __retInst14                    (*__VMENTRIES__.p__retInst14)
# define __retInst15                    (*__VMENTRIES__.p__retInst15)
# define __retInst16                    (*__VMENTRIES__.p__retInst16)
# define __retInst17                    (*__VMENTRIES__.p__retInst17)
# define __retInst18                    (*__VMENTRIES__.p__retInst18)
# define __retInst19                    (*__VMENTRIES__.p__retInst19)
# define __retInst20                    (*__VMENTRIES__.p__retInst20)
# define __retInst21                    (*__VMENTRIES__.p__retInst21)
# define __retInst22                    (*__VMENTRIES__.p__retInst22)
# define __retInst23                    (*__VMENTRIES__.p__retInst23)
# define __retInst24                    (*__VMENTRIES__.p__retInst24)
# define __retInst25                    (*__VMENTRIES__.p__retInst25)
# define __retInst26                    (*__VMENTRIES__.p__retInst26)
# define __retInst27                    (*__VMENTRIES__.p__retInst27)
# define __retInst28                    (*__VMENTRIES__.p__retInst28)
# define __retInst29                    (*__VMENTRIES__.p__retInst29)
# define __retInst30                    (*__VMENTRIES__.p__retInst30)
# define __setInst0                     (*__VMENTRIES__.p__setInst0)
# define __setInst1                     (*__VMENTRIES__.p__setInst1)
# define __setInst2                     (*__VMENTRIES__.p__setInst2)
# define __setInst3                     (*__VMENTRIES__.p__setInst3)
# define __setInst4                     (*__VMENTRIES__.p__setInst4)
# define __setInst5                     (*__VMENTRIES__.p__setInst5)
# define __setInst6                     (*__VMENTRIES__.p__setInst6)
# define __setInst7                     (*__VMENTRIES__.p__setInst7)
# define __setInst8                     (*__VMENTRIES__.p__setInst8)
# define __setInst9                     (*__VMENTRIES__.p__setInst9)
# define __setInst10                    (*__VMENTRIES__.p__setInst10)
# define __setInst11                    (*__VMENTRIES__.p__setInst11)
# define __setInst12                    (*__VMENTRIES__.p__setInst12)
# define __setInst13                    (*__VMENTRIES__.p__setInst13)
# define __setInst14                    (*__VMENTRIES__.p__setInst14)
# define __setInst15                    (*__VMENTRIES__.p__setInst15)
# define __setInst16                    (*__VMENTRIES__.p__setInst16)
# define __setInst17                    (*__VMENTRIES__.p__setInst17)
# define __setInst18                    (*__VMENTRIES__.p__setInst18)
# define __setInst19                    (*__VMENTRIES__.p__setInst19)
# define __setInst20                    (*__VMENTRIES__.p__setInst20)
# define __setInst21                    (*__VMENTRIES__.p__setInst21)
# define __setInst22                    (*__VMENTRIES__.p__setInst22)
# define __setInst23                    (*__VMENTRIES__.p__setInst23)
# define __setInst24                    (*__VMENTRIES__.p__setInst24)
# define __setInst25                    (*__VMENTRIES__.p__setInst25)
# define __setInst26                    (*__VMENTRIES__.p__setInst26)
# define __setInst27                    (*__VMENTRIES__.p__setInst27)
# define __setInst28                    (*__VMENTRIES__.p__setInst28)
# define __setInst29                    (*__VMENTRIES__.p__setInst29)
# define __setInst30                    (*__VMENTRIES__.p__setInst30)
# define __MKUCHARACTER                 (*__VMENTRIES__.p__MKUCHARACTER)

# ifndef __interpret
#  define __interpret                   (*__VMENTRIES__.p__interpret)
# endif

# undef _SEND0
# undef _SEND1
# undef _SEND2
# undef _SEND3
# undef _SEND4
# undef _SEND5
# undef _SEND6
# undef _SEND7
# undef _SEND8
# undef _SEND9
# undef _SEND10
# undef _SEND11
# undef _SEND12
# undef _SEND13
# undef _SEND14
# undef _SEND15

# define _SEND0                         (*__VMENTRIES__.p_SEND0)
# define _SEND1                         (*__VMENTRIES__.p_SEND1)
# define _SEND2                         (*__VMENTRIES__.p_SEND2)
# define _SEND3                         (*__VMENTRIES__.p_SEND3)
# define _SEND4                         (*__VMENTRIES__.p_SEND4)
# define _SEND5                         (*__VMENTRIES__.p_SEND5)
# define _SEND6                         (*__VMENTRIES__.p_SEND6)
# define _SEND7                         (*__VMENTRIES__.p_SEND7)
# define _SEND8                         (*__VMENTRIES__.p_SEND8)
# define _SEND9                         (*__VMENTRIES__.p_SEND9)
# define _SEND10                        (*__VMENTRIES__.p_SEND10)
# define _SEND11                        (*__VMENTRIES__.p_SEND11)
# define _SEND12                        (*__VMENTRIES__.p_SEND12)
# define _SEND13                        (*__VMENTRIES__.p_SEND13)
# define _SEND14                        (*__VMENTRIES__.p_SEND14)
# define _SEND15                        (*__VMENTRIES__.p_SEND15)

#else /* __DIRECTVMFUNCREFS__ */

  void __spyInterrupt(), __signalIoInterrupt(), __signalUserInterrupt();
  void __signalFpExceptionInterrupt(), __signalPIPEInterrupt(), __signalBUSInterrupt();
  void __signalInterrupt(), __signalTimerInterrupt(), __signalChildInterrupt();
  void __signalSEGVInterrupt();
# ifndef __interpret
  OBJ __interpret();
# endif
  OBJ __retGlob0();
  OBJ __bRetTrue();
  OBJ __bRetFalse();
  OBJ __bRet0();
  OBJ __bRetNil();
  OBJ __retSelf();
  OBJ __retSelf1();
  OBJ __retSelf2();
  OBJ __retSelf3();
  OBJ __retNil();
  OBJ __retTrue();
  OBJ __retFalse();
  OBJ __ret0();
  OBJ __ret1();
  OBJ __retArg0();
  OBJ __retArg1_0();
  OBJ __retArg2_0();
  OBJ __retArg2_1();
  OBJ __retInst0();
  OBJ __retInst1();
  OBJ __retInst2();
  OBJ __retInst3();
  OBJ __retInst4();
  OBJ __retInst5();
  OBJ __retInst6();
  OBJ __retInst7();
  OBJ __retInst8();
  OBJ __retInst9();
  OBJ __retInst10();
  OBJ __retInst11();
  OBJ __retInst12();
  OBJ __retInst13();
  OBJ __retInst14();
  OBJ __retInst15();
  OBJ __retInst16();
  OBJ __retInst17();
  OBJ __retInst18();
  OBJ __retInst19();
  OBJ __retInst20();
  OBJ __retInst21();
  OBJ __retInst22();
  OBJ __retInst23();
  OBJ __retInst24();
  OBJ __retInst25();
  OBJ __retInst26();
  OBJ __retInst27();
  OBJ __retInst28();
  OBJ __retInst29();
  OBJ __retInst30();
  OBJ __setInst0();
  OBJ __setInst1();
  OBJ __setInst2();
  OBJ __setInst3();
  OBJ __setInst4();
  OBJ __setInst5();
  OBJ __setInst6();
  OBJ __setInst7();
  OBJ __setInst8();
  OBJ __setInst9();
  OBJ __setInst10();
  OBJ __setInst11();
  OBJ __setInst12();
  OBJ __setInst13();
  OBJ __setInst14();
  OBJ __setInst15();
  OBJ __setInst16();
  OBJ __setInst17();
  OBJ __setInst18();
  OBJ __setInst19();
  OBJ __setInst20();
  OBJ __setInst21();
  OBJ __setInst22();
  OBJ __setInst23();
  OBJ __setInst24();
  OBJ __setInst25();
  OBJ __setInst26();
  OBJ __setInst27();
  OBJ __setInst28();
  OBJ __setInst29();
  OBJ __setInst30();
  OBJ __MKUCHARACTER();

#ifdef xx__osx__
DLL_IMPORT OBJ _SEND0(), _SEND1(), _SEND2(), _SEND3(), _SEND4(), _SEND5();
DLL_IMPORT OBJ _SEND6(), _SEND7(), _SEND8(), _SEND9(), _SEND10(), _SEND11();
DLL_IMPORT OBJ _SEND12(), _SEND13(), _SEND14(), _SEND15(), _SENDN();
#endif

#endif


/*
 * for now, these are not indirected (they could, however)
 */
DLL_IMPORT OBJ _Q_MKBLOCK(), _Q_MKBLOCK0(), _Q_MKBLOCK1(), _Q_MKBLOCK2();

DLL_IMPORT OBJ __SIZE(OBJ);
DLL_IMPORT OBJ _PLUS_(OBJ, OBJ), _MINUS_(OBJ, OBJ), _MU_(OBJ, OBJ);
DLL_IMPORT OBJ _PLUS1(OBJ), _MINUS1(OBJ);
DLL_IMPORT OBJ __LE_(OBJ, OBJ), __LEEQ_(OBJ, OBJ), __GR_(OBJ, OBJ), __GREQ_(OBJ, OBJ);

DLL_IMPORT OBJ __MKPOINT_INT(INT, INT), __MKPOINT_DOUBLE(double, double);
DLL_IMPORT OBJ __ARRAY_UNITITIALIZED_NEW_INT();
DLL_IMPORT OBJ __stArrayFromCIntArray(int *, INT), __stArrayFromCUIntArray(unsigned int *, INT);
DLL_IMPORT OBJ __stArrayFromCShortArray(short *, INT), __stArrayFromCUShortArray(unsigned short *, INT);
DLL_IMPORT OBJ __stArrayFromCFloatArray(float *, INT), __stArrayFromCDoubleArray(double *, INT);
DLL_IMPORT OBJ __stFloatArrayFromCFloatArray(float *, INT), __stDoubleArrayFromCDoubleArray(double *, INT);
DLL_IMPORT OBJ __WEAK_READ__(OBJ, OBJ);
DLL_IMPORT unsigned INT __unsignedLongIntVal(OBJ);


DLL_IMPORT void __flushPolyCache();
DLL_IMPORT int __primBecome(OBJ, OBJ);
DLL_IMPORT int __primBecomeNil(OBJ);
DLL_IMPORT int __primBecomeSameAs(OBJ, OBJ);
DLL_IMPORT void __mainExit(int);
DLL_IMPORT void __CONTEXTLINENOS(OBJ);
DLL_IMPORT void __UNFIXCONTEXTS(OBJ, int);
DLL_IMPORT int __continuationResume(int);
DLL_IMPORT int __continuationDestroy(int);
DLL_IMPORT void __threadDestroy(INT);
DLL_IMPORT void __threadInterrupt(int);
DLL_IMPORT void __ilcBind(OBJ, OBJ, OBJ, OBJ);
DLL_IMPORT int __addTrapOnAccess(OBJ, int);
DLL_IMPORT int __removeAllAccessTraps();
DLL_IMPORT int __removeTrapOnAccess(OBJ);
DLL_IMPORT void __flushMethodCache();
DLL_IMPORT void __flushAllInlineCaches();
DLL_IMPORT void __flushInlineCaches(int);
DLL_IMPORT void __flushMethodCacheFor(OBJ);
DLL_IMPORT void __flushMethodCacheForSelector(OBJ);
DLL_IMPORT void __flushInlineCachesFor(OBJ);
DLL_IMPORT void __flushInlineCachesForAndNargs(OBJ, int);
DLL_IMPORT void __flushInlineCachesForSelector(OBJ);
DLL_IMPORT void __bumpSnapshotID();
DLL_IMPORT int __snapshotID();
DLL_IMPORT int __setTrapRestrictedMethods(int);
DLL_IMPORT void __dumpObject__(OBJ, int);
DLL_IMPORT void __dumpContext__(OBJ);
DLL_IMPORT void __printRefChain(OBJ, OBJ);
DLL_IMPORT void __checkConsistency(char *);
DLL_IMPORT void __dumpILCCaches();
DLL_IMPORT void __printStack(OBJ);
DLL_IMPORT void __dumpSymbols();
DLL_IMPORT void __setMessageTrace__(int);
DLL_IMPORT void __nonTenuringScavenge();
DLL_IMPORT void __tenure();
DLL_IMPORT void __scavenge();
DLL_IMPORT void __collectOldSpace(OBJ);
DLL_IMPORT int __garbageCollect(OBJ);
DLL_IMPORT void __markAndSweep();
DLL_IMPORT void __markAndSweepIfUseful();
DLL_IMPORT int __incrementalSweep(int);
DLL_IMPORT void __reclaimSymbols();
DLL_IMPORT void __avoidTenure(int, int);
DLL_IMPORT void __lockTenure(int);
DLL_IMPORT int __moveToOldSpace(OBJ, OBJ, int);
DLL_IMPORT int __moreOldSpace(OBJ, INT);
DLL_IMPORT void __tenureParams(OBJ);
DLL_IMPORT int __allocForceSpace(int);
DLL_IMPORT void __watchTenure(int);
DLL_IMPORT int __garbageCollectCount();
DLL_IMPORT int __incrementalGCCount();
DLL_IMPORT void __compressOldSpace();
DLL_IMPORT int __allInstancesOfDo(VOLATILE OBJ *, VOLATILE OBJ *, VOLATILE OBJ *);
DLL_IMPORT void __allChangedShadowObjectsDo(VOLATILE OBJ *);
DLL_IMPORT void __WEAK_WRITE__(OBJ, OBJ);
DLL_IMPORT void __WEAK_WRITE__(OBJ, OBJ);
DLL_IMPORT OBJ __WEAK_READ__(OBJ, OBJ);
DLL_IMPORT int __compiledCodeCounter();
DLL_IMPORT int __compiledCodeSpaceUsed();
DLL_IMPORT int __setDynamicCodeLimit(int);

# define __STCVMDATA_H__
#endif /* __STCVMDATA_H__ */

#ifdef __INCLUDE_VMENTRIES__
    /*
     * preinitialized vmData contents as initialized struct values;
     * (for inclusion in classes.c)
     * Remember, for backward compatibility:
     * ONLY ADD NEW ENTRIES AT THE END
     */
    __interrupt__,

    __REGISTER_MODULE__,
    __DEFSOURCE,
    __PACKAGE__,
    __BEGIN_PACKAGE__,
    __END_PACKAGE__,
    __DEFMETHODCATEGORY,
    __DEFMETHOD,
    __DEFPMETHOD,
    __MAKEINDIRGLOBAL,

    __MKMETHODARRAY,

    __MKPSELFMETHOD_0,
    __MKPMETHOD_0,
    __MKPMETHOD_1,
    __MKPMETHOD_2,
    __MKPMETHOD_3,
    __MKPMETHOD_N,
    __MKPINSTMETHOD_0,
    __MKPSINSTMETHOD_1,
    __MKPTRUEMETHOD_0,
    __MKPFALSEMETHOD_0,

    __MKLITARRAY,

    __MKCLASS_META4,
    __MKINDIRGLOBAL_LIST,
    __MKSTRING_LIST_INIT,

    __MKUNNAMEDCONSTARRAY,
    __UNNAMEDGLOBAL,
    __MKCONSTBARRAY,
    __MKCLASS,
    __MKNSYMBOL_INIT,
    __MKLITARRAY1,
    __MKLITARRAY2,
    __MKLITARRAY3,
    __MKLITARRAY4,
    __MKLITARRAY5,
    __MKLITARRAY6,
    __MKLITARRAY7,
    __MKLITARRAY8,
    __MKLITARRAY9,
    __MKLITARRAY10,
    __MKLITARRAY11,
    __MKLITARRAY12,
    __NMKCHEAPBLOCK0,
    __NMKCHEAPBLOCK1,
    __NMKCHEAPBLOCK2,
    __NMKCHEAPBLOCK_N,
    __MKPSELFMETHOD_1,
    __MKPSELFMETHOD_2,
    __MKPSELFMETHOD_3,
    __MKPNILMETHOD_0,
    __MKP0METHOD_0,
    __MKARRAY,
    __MKSTRING_INIT,
    __GETCHARACTERTABLE,
    __MKCLASS_META3,
    __MKINDIRSYMBOL_LIST_INIT,
    __MKIINDIRLITARRAY,
    __MKBARRAY,
    __MKPARG0METHOD_1,
    __MKPARG0METHOD_2,
    __FLOAT_CONSTANT,
    __FRACT_CONSTANT,
    __MAKEGLOBAL,
    __MKINDIRLITARRAY,
    __MKSYMBOL_LIST_INIT,
    __SETGLOBAL_INIT,
    __DEFPSELFMETHOD_0,
    __METHODSFOR,
    __GETSYMBASE,
    __DEFPKGSOURCE,
    __NNREGISTER_MODULE__,

    __STACK_HANDLER__,
    __STACK_HANDLER1__,
    __STACK_HANDLER2__,
    __STACK_HANDLER3__,
    __STACK_HANDLER4__,
    __STACK_HANDLER5__,
    __STACK_HANDLER6__,
    __STACK_HANDLER7__,
    __STACK_HANDLER8__,
    __STACK_HANDLER9__,
    __STACK_HANDLER10__,
    __STACK_HANDLER11__,
    __STACK_HANDLER12__,
    __STACK_HANDLER13__,
    __STACK_HANDLER14__,
    __STACK_HANDLER15__,
    __STACK_HANDLER16__,
    __STACK_HANDLER17__,
    __STACK_HANDLER18__,
    __STACK_HANDLER19__,
    __STACK_HANDLER20__,

    __STACK_HANDLER_U__,
    __STACK_HANDLER1_U__,
    __STACK_HANDLER2_U__,
    __STACK_HANDLER3_U__,
    __STACK_HANDLER4_U__,
    __STACK_HANDLER5_U__,
    __STACK_HANDLER6_U__,
    __STACK_HANDLER7_U__,
    __STACK_HANDLER8_U__,
    __STACK_HANDLER9_U__,
    __STACK_HANDLER10_U__,
    __STACK_HANDLER11_U__,
    __STACK_HANDLER12_U__,
    __STACK_HANDLER13_U__,
    __STACK_HANDLER14_U__,
    __STACK_HANDLER15_U__,
    __STACK_HANDLER16_U__,
    __STACK_HANDLER17_U__,
    __STACK_HANDLER18_U__,
    __STACK_HANDLER19_U__,
    __STACK_HANDLER20_U__,

    __STACK_HANDLER_N__,
    __STACK_HANDLER1_N__,
    __STACK_HANDLER2_N__,
    __STACK_HANDLER3_N__,
    __STACK_HANDLER4_N__,
    __STACK_HANDLER5_N__,
    __STACK_HANDLER6_N__,
    __STACK_HANDLER7_N__,
    __STACK_HANDLER8_N__,
    __STACK_HANDLER9_N__,
    __STACK_HANDLER10_N__,
    __STACK_HANDLER11_N__,
    __STACK_HANDLER12_N__,
    __STACK_HANDLER13_N__,
    __STACK_HANDLER14_N__,
    __STACK_HANDLER15_N__,
    __STACK_HANDLER16_N__,
    __STACK_HANDLER17_N__,
    __STACK_HANDLER18_N__,
    __STACK_HANDLER19_N__,
    __STACK_HANDLER20_N__,

    __ySTACK_HANDLER10__,
    __ySTACK_HANDLER20__,

    __MKREALCONTEXT,
    __MKREALCONTEXT2,
    __MKREALCONTEXT3,
    (OBJFUNC)0x0,
    (OBJFUNC)0x0,
    (OBJFUNC)0x0,
    (OBJFUNC)0x0,

    __ARRAY_NEW,
    __ARRAY_NEW_INT,
    __STRING_NEW,
    __STRING_NEW_INT,
    __ARRAY_WITH1,
    __ARRAY_WITH2,
    __ARRAY_WITH3,
    __ARRAY_WITH4,
    __ARRAY_WITH5,

    __LE_IF_,
    __GR_IF_,
    __LEEQ_IF_,
    __GREQ_IF_,

    __storeInst0,
    __storeInst1,
    __storeInst2,
    __storeInst3,
    __storeInst4,
    __storeInst5,
    __storeInstN,
    __gstore2,
    __gstore,

    __NNNREGISTER_MODULE__,
    __ISKINDOF_,
    __INIT_ILC,
    __LARGE_CONSTANT,

    __DEFDOCMETHODS,
    __DLMKPMETHOD_N,
    __DLMKPMETHOD_0,
    __DLMKPMETHOD_1,
    __DLMKPMETHOD_2,
    __DLMKPMETHOD_3,
    __DMKPMETHOD_0,

    __getCopyrightString,
    __getDistributorString,

    __STX___new,
    __newOld,
    __lookup,
    __interpret,
    __threadsAvailable,
    __threadContext,

    __GLOBAL_GET,
    __GLOBAL_SET,
    __GLOBAL_KEYKNOWN,
    __GLOBAL_REMOVE,
    __GLOBAL_GETCELL,
    __KNOWNASSYMBOL,
    __INTERNSYMBOL,

    __NMKCHEAPBLOCK3,

    _SEND0,
    _SEND1,
    _SEND2,
    _SEND3,
    _SEND4,
    _SEND5,
    _SEND6,
    _SEND7,
    _SEND8,
    _SEND9,
    _SEND10,
    _SEND11,
    _SEND12,
    _SEND13,
    _SEND14,
    _SEND15,
    _SENDN,

    __spyInterrupt,
    __signalIoInterrupt,
    __signalUserInterrupt,
    __signalFpExceptionInterrupt,
    __signalPIPEInterrupt,
    __signalBUSInterrupt,
    __signalInterrupt,
    __signalTimerInterrupt,
    __signalChildInterrupt,
    __signalSEGVInterrupt,

    __bRetTrue,
    __bRetFalse,
    __bRet0,
    __bRetNil,
    __retSubclassResponsibility,
    __1retSubclassResponsibility,

    __MKCLASS2,
    __MKAUTOLOADCLASS,

    __MKSTRING_RLIST_INIT,
    __MKUSCONSTARRAY,

    __SSEND0,
    __SSEND1,
    __SSEND2,
    __SSEND3,
    __SSEND4,
    __SSEND5,
    __SSEND6,
    __SSEND7,
    __SSEND8,
    __SSEND9,
    __SSEND10,
    __SSEND11,
    __SSEND12,
    __SSEND13,
    __SSEND14,
    __SSEND15,
    __SSENDN,

    __ySTACK_HANDLER__,
    __ySTACK_HANDLER_N__,
    __ySTACK_HANDLER_U__,

    __MKREALCONTEXT4,
    __MKREALCONTEXT5,

    __REGISTER_CLS_MODULE__,

    __MKULITARRAY0,
    __MKULITARRAY1,
    __MKULITARRAY2,
    __MKULITARRAY3,
    __MKULITARRAY4,
    __MKULITARRAY5,
    __MKULITARRAY6,
    __MKULITARRAY7,
    __MKULITARRAY8,
    __MKULITARRAY9,
    __MKULITARRAY10,
    __MKULITARRAY11,
    __MKULITARRAY12,

    __ILC_CHECK0__,
    __ILC_CHECK1__,
    __ILC_CHECK2__,
    __ILC_CHECK3__,
    __ILC_CHECK4__,
    __ILC_CHECK5__,
    __ILC_CHECK6__,
    __ILC_CHECK7__,
    __ILC_CHECK8__,
    __ILC_CHECK9__,
    __ILC_CHECK10__,
    __ILC_CHECK11__,
    __ILC_CHECK12__,
    __ILC_CHECK13__,
    __ILC_CHECK14__,
    __ILC_CHECK15__,

    __ILC_CHECK0s__,
    __ILC_CHECK1s__,
    __ILC_CHECK2s__,
    __ILC_CHECK3s__,
    __ILC_CHECK4s__,
    __ILC_CHECK5s__,
    __ILC_CHECK6s__,
    __ILC_CHECK7s__,
    __ILC_CHECK8s__,
    __ILC_CHECK9s__,
    __ILC_CHECK10s__,
    __ILC_CHECK11s__,
    __ILC_CHECK12s__,
    __ILC_CHECK13s__,
    __ILC_CHECK14s__,
    __ILC_CHECK15s__,

    __MKPSUBMETHOD_0,
    __MKPSUBMETHOD_1,
    __MKPRSUBMETHOD_0,
    __MKPRSUBMETHOD_1,

    __STRING_CONSTANT,
    __MKBARRAY8,

    __MKSYMBOL,
    __MKFRACT,
    __MKFLOAT,
    __MKINT,
    __MKUINT,
    __MKLARGEINT,
    __MKULARGEINT,
    __MKSTRING,
    __MKSTRING_L,
    __BASICNEW,
    __BASICNEW_INT,
    __NEW,
    __NEW_INT,
    __RESUMECONTEXT__,
    __RESUMECONTEXT1__,
    __PATCHUPCONTEXT,
    __PATCHUPCONTEXTS,
    __AT_,
    __AT_PUT_,

    __retGlob0,
    __blockRefCatch,

    __interruptL,
    __integerCheck,
    __integerCheckL,
    __typeCheck,
    __typeCheckL,
    __pointCheck,
    __pointCheckL,
    __nestedImmediateInterrupt,
    __stxHandleInterrupt__,

    __store,
    __LE_IF2_,
    __GR_IF2_,
    __LEEQ_IF2_,
    __GREQ_IF2_,

    __MKEXTERNALADDRESS,
    __MKEXTERNALBYTES,
    __MKEXTERNALFUNCTION,

    __SEND_AT,
    __MKSCONSTARRAY,
    __MKCONSTARRAY,

    __LMKPMETHOD_0,
    __LMKPMETHOD_1,
    __LMKPMETHOD_2,
    __LMKPMETHOD_3,
    __LMKPMETHOD_N,

    __ADDMETHOD,
    __REGISTER_MMODULE__,

    __NDLMKPMETHOD_0,
    __NDLMKPMETHOD_1,
    __NDLMKPMETHOD_2,
    __NDLMKPMETHOD_3,
    __NDLMKPMETHOD_N,

    __MKCLASS_META3__,
    __MKCLASS_META4__,

    __REGISTER_PRIVATE_CLS__,
    __MKUSuCONSTARRAY,
    __MKUBCONSTARRAY,
    __MKUBuCONSTARRAY,
    __MKSuCONSTARRAY,
    __MKBCONSTARRAY,
    __MKBuCONSTARRAY,

    __LARGE_ICONSTANT,
    __MAKENAMESPACE,

    __longIntVal,
    __signedLongIntVal,
    __MKSFLOAT,
    __MKEMPTYSTRING,
    __MKSTRING_ST,
    __MKSTRING_ST_L,
    __MKLARGEINT128,
    __MKLARGEINT64,
    __UNNAMEDGLOBAL_BLOCK,
    __NDMKPMETHOD_0,
    __MKBYTEARRAY,
    __MKINDIRGLOBAL_LIST_NS,
    __MAKEINDIRGLOBAL_NS,
    __BYTEARRAY_NEW_INT,

    __DEFPTRUEMETHOD_0,
    __DEFPFALSEMETHOD_0,
    __ADDPMETHOD,
    __BEGIN_PACKAGE2__,
    __NMKPNILMETHOD_0,

    __REGISTER_MMODULE2__,
    __MKEXTERNALBYTES_N,
    __MKEMPTYU16STRING,

    __bRetInst0,
    __bRetInst1,
    __bRetInst2,
    __bRetInst3,
    __bRetInst4,
    __bRetInst5,
    __bRetInst6,
    __bRetInst7,
    __bRetInst8,
    __bRetInst9,

    __initClass__,
    __nMKARRAY,
    __nUMKARRAY,
    __MKINT64,
    __MKUINT64,
    __BLOCKINTERRUPTS,
    __UNBLOCKINTERRUPTS,
    __NMKPSELFMETHOD_0,
    __NMKPMETHOD_N,

    __SEND0S,
    __SEND1S,
    __SEND2S,
    __SEND3S,
    __SEND4S,
    __SEND5S,
    __SEND6S,
    __SEND7S,
    __SEND8S,
    __SEND9S,
    __SEND10S,
    __SEND11S,
    __SEND12S,
    __SEND13S,
    __SEND14S,
    __SEND15S,

    __retSelf,
    __retSelf1,
    __retSelf2,
    __retSelf3,
    __retNil,
    __retTrue,
    __retFalse,
    __ret0,
    __ret1,
    __retArg0,
    __retArg1_0,
    __retArg2_0,
    __retArg2_1,
    __retInst0,
    __retInst1,
    __retInst2,
    __retInst3,
    __retInst4,
    __retInst5,
    __retInst6,
    __retInst7,
    __retInst8,
    __retInst9,
    __retInst10,
    __retInst11,
    __retInst12,
    __retInst13,
    __retInst14,
    __retInst15,
    __retInst16,
    __retInst17,
    __retInst18,
    __retInst19,
    __retInst20,
    __retInst21,
    __retInst22,
    __retInst23,
    __retInst24,
    __retInst25,
    __retInst26,
    __retInst27,
    __retInst28,
    __retInst29,
    __retInst30,
    __setInst0,
    __setInst1,
    __setInst2,
    __setInst3,
    __setInst4,
    __setInst5,
    __setInst6,
    __setInst7,
    __setInst8,
    __setInst9,
    __setInst10,
    __setInst11,
    __setInst12,
    __setInst13,
    __setInst14,
    __setInst15,
    __setInst16,
    __setInst17,
    __setInst18,
    __setInst19,
    __setInst20,
    __setInst21,
    __setInst22,
    __setInst23,
    __setInst24,
    __setInst25,
    __setInst26,
    __setInst27,
    __setInst28,
    __setInst29,
    __setInst30,
    __MKUCHARACTER,
    __MKUTF8STRING,
    __MKUTF8STRING_INIT,
    __UTF8STRING_CONSTANT,
    __MKUTF8STRING_RLIST_INIT,
    __MKUTF8STRING_LIST_INIT,
    __REGISTER_MMODULE3__,
    __NMKPINSTMETHOD_0,
    __NMKPSINSTMETHOD_1,
    __SYMBOL_OR_NIL,
    __mcstore,
    __NMKPFALSEMETHOD_0,
    __NMKPTRUEMETHOD_0,
    __REGISTER_MMODULE4__,
    __NMKPSELFMETHOD_1,
    __NMKPSELFMETHOD_2,
    __NMKPSELFMETHOD_3,
    __NDMKPMETHOD_1,
    __NDMKPMETHOD_2,
    __NDMKPMETHOD_3,
    __NDMKPMETHOD_N,
    __MKEXTERNALLIBRARYFUNCTION,
    __MKEXTERNALLIBRARYFUNCTION_V,
    __BYTEARRAY_UNINITIALIZED_NEW_INT,

    __NMKPSUBMETHOD_0,
    __NMKPSUBMETHOD_1,
    __NMKPRSUBMETHOD_0,
    __NMKPRSUBMETHOD_1,

    __MKPARG1METHOD_2,
    __ADD_REFCELL,
    __REMOVE_REFCELL,

    __FIXEDPOINT_CONSTANT,
    __NLMKPMETHOD_0,
    __NLMKPMETHOD_1,
    __NLMKPMETHOD_2,
    __NLMKPMETHOD_3,
    __NLMKPMETHOD_N,
    __NMKPARG0METHOD_1,
    __NMKPARG0METHOD_2,
    __NMKPARG1METHOD_2,

    __NMKP0METHOD_0,
    __MKU16STRING,
    __MKU16STRING_MAXLEN,

     __MKINDIRGLOBAL_LIST3,
    __MKINDIRGLOBAL_LIST_NS3,

    __MKSTRING_ST_OL,
    __mkAnyString_maxlen,
    __mkStringOrU16String_maxlen,

    __NMKCHEAPBLOCK0_P,
    __NMKCHEAPBLOCK1_P,
    __NMKCHEAPBLOCK2_P,
    __NMKCHEAPBLOCK3_P,
    __NMKCHEAPBLOCK_N_P,

    (OBJFUNC)0x0,
    (OBJFUNC)0x0,
    (OBJFUNC)0x0,
    (OBJFUNC)0x0,

    __MKBLOCK_P_H,
    __MKBLOCK0_P_H,
    __MKBLOCK1_P_H,
    __MKBLOCK2_P_H,

    __SSELFSEND0,
    __SSELFSEND1,
    __SSELFSEND2,
    __SSELFSEND3,
    __SSELFSEND4,
    __SSELFSEND5,
    __SSELFSEND6,
    __SSELFSEND7,
    __SSELFSEND8,
    __SSELFSEND9,
    __SSELFSEND10,
    __SSELFSEND11,
    __SSELFSEND12,
    __SSELFSEND13,
    __SSELFSEND14,
    __SSELFSEND15,
    __SSELFSENDN,

    __BYTEARRAY_NEW,
    __MKSTRING_2L_INIT,
    /*
     * for backward compatibility:
     * ONLY ADD NEW ENTRIES AT THE END
     * but before the line below (i.e. above this comment)
     */
    0xFEEDBEEF,  /* magic integer end mark (for validation) */

#endif /* __INCLUDE_VMDATA__ */
