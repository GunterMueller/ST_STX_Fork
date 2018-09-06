"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2016-2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ObjectFileLoader
	instanceVariableNames:''
	classVariableNames:'ActuallyLoadedObjects CopyLibrariesWhenLoading ErrorPrinting
		LastError LastErrorNumber LinkErrorMessage LoadedObjects
		MySymbolTable NextHandleID OldSpaceReserve
		PreviouslyLoadedObjects Verbose'
	poolDictionaries:''
	category:'System-Compiler'
!

Error subclass:#ObjectFileLoadError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ObjectFileLoader
!

Notification subclass:#ObjectFileLoadErrorNotification
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ObjectFileLoader
!

ObjectFileLoader::ObjectFileLoadErrorNotification subclass:#RegistrationFailedErrorNotification
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ObjectFileLoader
!

ObjectFileLoader::ObjectFileLoadErrorNotification subclass:#SuperClassMissingErrorNotification
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ObjectFileLoader
!

!ObjectFileLoader primitiveDefinitions!
%{

#undef true
#undef false

/*
 * by default, use whatever the system provides
 */
#if defined(SYSV4) || defined(HAS_DLOPEN)   /* sys5.4 dlopen interface */
# define SYSV4_DL
# define HAS_DL
#endif

#ifdef __VMS__
# undef __new
#endif

#ifdef DL1_6    /* dl1.6 COFF loader */
# define HAS_DL
#endif

#include <stdio.h>

#ifdef NEXT_DL
# ifndef _RLD_H_
#  define _RLD_H_
#  ifdef __NEXT3__
#   include <mach-o/rld.h>
#  else
#   include <rld.h>
#  endif
# endif
#endif /* NEXT_DL */

#ifdef SYSV4_DL
# ifndef dlfcn_h
#  include <dlfcn.h>
#  define dlfcn_h
# endif
#endif

#ifdef GNU_DL
#  ifndef dld_h
#   include "dld.h"
#   define dld_h
#  endif
#endif

#ifdef DL1_6
#  ifndef dl_h
#   include "dl.h"
#   define dl_h
#  endif
#endif

#ifdef AIX_DL
# include <nlist.h>
# include <sys/ldr.h>
# include <errno.h>
#endif

#ifdef HPUX10_DL
# ifndef dl_h
#  include <dl.h>
#  define dl_h
# endif
# include <errno.h>
#endif

#ifdef BEOS_DL
# include <be/kernel/image.h>
#endif

#ifdef WIN_DL
# undef INT
# undef UINT
# undef Array
# undef Number
# undef Method
# undef Block
# undef Time
# undef Date
# undef Set
# undef Delay
# undef Signal
# undef Context
# undef Message
# undef Process
# undef Processor
# undef Rectangle
# undef String
# undef Character
# undef Point
# undef Object

# ifdef __i386__
#  ifndef _X86_
#   define _X86_
#  endif
# endif

# ifdef __BORLANDC__
#  define NOATOM
#  define NOUSER
#  define NOGDI
#  define NOGDICAPMASKS
#  define NOMETAFILE
#  define NOMINMAX
#  define NOMSG
#  define NOOPENFILE
#  define NORASTEROPS
#  define NOSCROLL
#  define NOSOUND
#  define NOSYSMETRICS
#  define NOTEXTMETRIC
#  define NOWH
#  define NOCOMM
#  define NOKANJI
#  define NOCRYPT
#  define NOMCX
#  define WIN32_LEAN_AND_MEAN
#  include <windows.h>
// #  include <windef.h>
// #  include <winbase.h>
# else
#  ifdef __VISUALC__
// #  include <windows.h>
#   include <windef.h>
#   include <winbase.h>
#  else
#   include <windows.h>
#  endif
# endif /* BORLANDC */

# include <psapi.h>

# ifdef __DEF_Array
#  define Array __DEF_Array
# endif
# ifdef __DEF_Number
#  define Number __DEF_Number
# endif
# ifdef __DEF_Method
#  define Method __DEF_Method
# endif
# ifdef __DEF_Block
#  define Block __DEF_Block
# endif
# ifdef __DEF_Time
#  define Time __DEF_Time
# endif
# ifdef __DEF_Date
#  define Date __DEF_Date
# endif
# ifdef __DEF_Set
#  define Set __DEF_Set
# endif
# ifdef __DEF_Signal
#  define Signal __DEF_Signal
# endif
# ifdef __DEF_Delay
#  define Delay __DEF_Delay
# endif
# ifdef __DEF_Context
#  define Context __DEF_Context
# endif
# ifdef __DEF_Message
#  define Message __DEF_Message
# endif
# ifdef __DEF_Process
#  define Process __DEF_Process
# endif
# ifdef __DEF_Processor
#  define Processor __DEF_Processor
# endif
# ifdef __DEF_Rectangle
#  define Rectangle __DEF_Rectangle
# endif
# ifdef __DEF_String
#  define String __DEF_String
# endif
# ifdef __DEF_Character
#  define Character __DEF_Character
# endif
# ifdef __DEF_Point
#  define Point __DEF_Point
# endif
# ifdef __DEF_Object
#  define Object __DEF_Object
# endif


# define INT STX_INT
# define UINT STX_UINT

#endif /* WIN_DL */

#undef true
#define true __STX_true

#undef false
#define false __STX_false

%}
! !

!ObjectFileLoader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2016-2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    This class knowns how to dynamically load in external object-modules.

    WARNING:
      As to date, this is still experimental and WITHOUT ANY WARRANTY.
      It is still being developed and the code may need some cleanup and more
      robustness.

    There are basically two totally different mechanisms to do this:
	a) if there exists some dynamic-link facility such as:
	   GNU-DL, dlopen (sparc, SYS5.4), rld_open (NeXT),
	   or LoadLibrary (Win32), this is used

	b) if no such facility exists, the normal linker is used to
	   link the module to text/data address as previously malloced,
	   and the object file is loaded into that space.

    Not all mechanisms work fully satisfying.
    For example, the sun dl*-functions do an exit on link-errors
    (which is certainly not what we want here :-(;
    the NeXT mechanism does not allow for selective unloading
    (only all or the last loaded module).

    The only really useful packages are the GNU-dl package,
    the SGI/Unixware/sys5.4/linux/osx libdl packages and the win32 dll's.
    The GNU-dl package is only available for a.out file formats
    (which is more or less obsolete);

    For the above reasons, dynamic object loading is only
    officially released for SYS5.4-based, linux, osx and win32 systems.

    When stable, the functionality contained herein will be moved into the VM.
    (It is needed there, to allow reloading of objectfiles upon
     image restart; i.e. before any class is reinitialilized).

    Right now, reloading of object files is done by Smalltalk code,
    which fails, if code is to be loaded which is required before the
    load takes place, or which is used by the loader itself.
    (i.e. for now, many primitives from libbasic cannot be dynamically
    loaded at image restart time).
    This will fix itself, once we do object file loading in the VM.

    [author:]
	Claus Gittinger
"
! !

!ObjectFileLoader class methodsFor:'initialization'!

initialize
    |systemType libDir linkCommand linkArgs libPath searchedLibraries|

    Verbose := false.
    "/ Verbose := true.

    OperatingSystem isMSDOSlike ifTrue:[
	"/ default setup for msc
	ParserFlags useBorlandC ifTrue:[
	    libDir := '..\lib\bc'.
	    libDir asFilename exists ifFalse:[
		libDir := '..\lib\lib\bc'.
		libDir asFilename exists ifFalse:[
		    libDir := '..\lib'.
		]
	    ].

	    linkCommand isNil ifTrue:[
		"/ linkCommand := 'tlink32'.
		linkCommand := 'ilink32'.
	    ].
	    linkArgs isNil ifTrue:[
		"/ linkArgs := '-L',libDir,' -L\Programme\Borland\CBuilder3\lib -c -ap -Tpd -s -Gi -v -w-dup ',libDir,'\librun.lib'.
		linkArgs := '-L',libDir,' -L\Programme\Borland\CBuilder3\lib -r -c -ap -Tpd -Gi -w-dup'.
	    ].
	    searchedLibraries := #(
				    'import32.lib'
				  ).
	] ifFalse:[
	    linkCommand isNil ifTrue:[
		linkCommand := 'link'
	    ].
	    linkArgs isNil ifTrue:[
		linkArgs := '/NOPACK /NOLOGO /DEBUG /MACHINE:I386 /DLL /OUT:%1.dll /DEF:%1.def'
	    ].
	].
    ].

    MySymbolTable isNil ifTrue:[
	NextHandleID := 1.
	ObjectMemory addDependent:self.

	OperatingSystem isMSDOSlike ifTrue:[
	    searchedLibraries := #(
				    'import32.lib'
				  ).
	].

	OperatingSystem isUNIXlike ifTrue:[
	    |ldLibraryPath|

	    systemType := OperatingSystem getOSType.

	    "/ name of object file, where initial symbol table is found
	    "/ not req'd for all architectures.

	    MySymbolTable := 'stx'.

	    searchedLibraries := #().

	    "/ default libraryPath where shared objects are expected
	    "/ when a sharedObject load requires other objects to be loaded.
	    "/ For more compatibility with ELF systems, look for a shell variable
	    "/ named LD_LIBRARY_PATH, and - if present - take that instead if a default.
	    "/ Can (should) be set in the smalltalk.rc file.

	    ldLibraryPath := OperatingSystem getEnvironment:'LD_LIBRARY_PATH'.
	    ldLibraryPath isEmptyOrNil ifTrue:[
		libPath := '.:lib:/usr/local/smalltalk/lib:/usr/local/lib:/usr/lib:/lib'.
	    ] ifFalse:[
		"/ only needed for AIX - the dynamic linker of other Unixes use LD_LIBRARY_PATH implicitly
		systemType = #aix ifTrue:[
		    libPath := ldLibraryPath.
		].
	    ]
	]
    ].

    ParserFlags linkCommand:linkCommand.
    ParserFlags linkArgs:linkArgs.
    ParserFlags libPath:libPath ? ''.
    ParserFlags searchedLibraries:searchedLibraries.

    "
     LinkArgs := LinkCommand := nil.
     ObjectFileLoader initialize
    "

    "Modified: / 28-09-2012 / 18:19:28 / cg"
!

lastError
    ^ LastError ? 'unknown error'

    "Modified: / 30.9.1998 / 17:21:23 / cg"
!

libPath
    "see comment in #libPath:"

    ^ ParserFlags libPath
!

libPath:aSharedLibraryPath
    "set the pathnames of directories, where other shared objects
     are searched, in case a loaded module requires another module shared
     library object to be loaded.
     Currently, this is only required to be set for AIX systems;
     ELF based linux and solaris systems specify the libPath in the
     LD_LIBRARY_PATH environment variable."

    ParserFlags libPath:aSharedLibraryPath

    "
     ObjectFileLoader libPath:'.:/usr/lib:/usr/local/lib'
    "
!

linkErrorMessage
    ^ LinkErrorMessage
!

searchedLibraries
    "see comment in #searchedLibraries:"

    ^ ParserFlags searchedLibraries
!

searchedLibraries:aCollectionOfArchivePathNames
    "set the pathnames of archives which are to be searched
     when unresolved references occur while loading in an object
     file. On systems which support shared libraries (all SYS5.4 based
     systems), this is usually not required. Instead, modules which are to
     be filed in (.so files) are to be prelinked with the appropriate
     shared libraries. The dynamic loader then cares about loading those
     modules (keeping track of which modules are already loaded).
     Only systems in which the dynamic load is done 'manually' by st/x
     (i.e. currently only linux and a.out-sunos) need to set this."

    ParserFlags searchedLibraries:aCollectionOfArchivePathNames
!

verbose
    "return true, if debug traces are turned on"

    ^ Verbose
!

verbose:aBoolean
    "turn on/off debug traces"

    Verbose := aBoolean

    "ObjectFileLoader verbose:true"
! !

!ObjectFileLoader class methodsFor:'accessing'!

copyLibrariesWhenLoading
    "under windows, a library file (dll) which has been loaded cannot be overwritten.
     This makes it troublesome, to recompile a new lib while a smalltalk is being executed.
     When CopyLibrariesWhenLoading is true, ddl files are copied to a tempdir before loading,
     so that the original can still be recompiled.
     Makes loading a bit slower (due to copying and less sharing/caching of already loaded dlls),
     so it is of by default and must be turned on explicitly during development."

    ^ CopyLibrariesWhenLoading ? false

    "
     self copyLibrariesWhenLoading
     self copyLibrariesWhenLoading:true
    "
!

copyLibrariesWhenLoading:aBoolean
    "under windows, a library file (dll) which has been loaded cannot be overwritten.
     This makes it troublesome, to recompile a new lib while a smalltalk is being executed.
     When CopyLibrariesWhenLoading is true, ddl files are copied to a tempdir before loading,
     so that the original can still be recompiled.
     Makes loading a bit slower (due to copying and less sharing/caching of already loaded dlls),
     so it is of by default and must be turned on explicitly during development."

    CopyLibrariesWhenLoading := aBoolean.

    "
     self copyLibrariesWhenLoading:true
    "
! !

!ObjectFileLoader class methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "sent, when image is saved or restarted"

    (something == #aboutToSnapshot) ifTrue:[
	self invalidateAndRememberAllObjectFiles
    ].
    (something == #finishedSnapshot) ifTrue:[
	self revalidateAllObjectFiles
    ].
"/    (something == #restarted) ifTrue:[
"/        self reloadAllRememberedObjectFiles
"/    ].

    "Modified: 5.10.1995 / 15:49:14 / claus"
    "Modified: 8.3.1996 / 23:34:29 / cg"
    "Created: 21.6.1996 / 19:50:01 / cg"
! !

!ObjectFileLoader class methodsFor:'defaults'!

hasValidBinaryExtension:aFilename
    "return true, if aFilename looks ok for binary loading.
     This checks only the extension - not its contents.
     (So an attempt to load the file may fail due to format errors or unresolved symbols)
     This is very machine specific."

    |suffix|

    suffix := aFilename asFilename suffix.
    ^ self validBinaryExtensions includes:suffix.
"/    |fn|
"/
"/    fn := aFilename asFilename.
"/    self validBinaryExtensions do:[:ext |
"/        (fn hasSuffix:ext) ifTrue:[^ true].
"/    ].
"/    ^ false

    "
     ObjectFileLoader hasValidBinaryExtension:'foo.st'
     ObjectFileLoader hasValidBinaryExtension:'foo.o'
     ObjectFileLoader hasValidBinaryExtension:'foo.so'
     ObjectFileLoader hasValidBinaryExtension:'foo.dll'
     ObjectFileLoader hasValidBinaryExtension:'foo.DLL'
     ObjectFileLoader hasValidBinaryExtension:'foo.obj'
     ObjectFileLoader hasValidBinaryExtension:'foo.sl'
    "

    "Modified: / 1.10.1998 / 12:47:01 / cg"
!

linkArgs
    ^ ParserFlags linkArgs

    "Created: / 12.8.1998 / 21:41:16 / cg"
    "Modified: / 12.8.1998 / 21:42:50 / cg"
!

linkArgs:anArgString
    ParserFlags linkArgs:anArgString

    "
     MSC:
	ParserFlags linkCommand:'link32'.
	ParserFlags linkArgs:' /NOPACK /NOLOGO /DEBUG /MACHINE:I386 /DLL /OUT:%1.dll /DEF:%1.def'

     Borland:
	ParserFlags linkCommand:'ilink32'.
	ParserFlags linkArgs:'-ap -E0 -Tpd -s -c -L\Programme\Borland\CBuilder3\lib -L..\libbc librun.lib import32.lib'
'
'/NOPACK /NOLOGO /DEBUG /MACHINE:I386 /DLL /OUT:%1.dll /DEF:%1.def'

     Unix:
	ParserFlags linkCommand:'ld'
	ParserFlags linkArgs:'-shared'
    "

    "Created: / 12.8.1998 / 21:43:16 / cg"
    "Modified: / 4.9.1998 / 00:33:46 / cg"
!

linkCommand
    ^ ParserFlags linkCommand

    "Created: / 12.8.1998 / 21:41:16 / cg"
!

linkCommand:aCommand
    ParserFlags linkCommand:aCommand

    "Created: / 12.8.1998 / 21:40:44 / cg"
!

linkSharedArgs
    ^ ParserFlags linkSharedArgs
!

linkSharedArgs:anArgString
    ParserFlags linkSharedArgs:anArgString

    "
     Linux on AMD64 in 32bit mode:
	LinkSharedArgs := '-shared -m elf_i386'
    "
!

loadableBinaryObjectFormat
    "return a symbol describing the expected binary format
     for object files to be loadable.
     This is very machine specific."

%{  /* NOCONTEXT */

#ifdef HAS_DL
# if defined(SYSV4) || defined(ELF)
    RETURN ( @symbol(elf));
# endif
# if defined(__alpha__) && defined(__osf__)
    RETURN ( @symbol(coff));
# endif
# if defined(GNU_DL)
    RETURN ( @symbol(aout));
# endif
# if defined(AIX_DL)
    RETURN ( @symbol(xcoff));
# endif
# if defined(HPUX10_DL)
    RETURN ( @symbol(hpcoff));
# endif
# if defined(DL1_6)
    RETURN ( @symbol(coff));
# endif
# if defined(WIN_DL)
    RETURN ( @symbol(dll));
# endif
# if defined(BEOS_DL)
    RETURN ( @symbol(beobj));
# endif
# if defined(__VMS__)
    RETURN ( @symbol(exe));
# endif
# if defined(__osx__)
    RETURN ( @symbol(macho));
# endif
#endif

%}.
    ^ nil

    "
     ObjectFileLoader loadableBinaryObjectFormat
    "
!

nm:file
   "this should return a string to list the namelist of file.
    The output of the command should be one line for each symbol,
    formatted as:
	addr  segment  name
    This is parsed and read by #namesMatching:segment:in:.

    If your default nm command cannot produce this, write a little
    shell or awk script, to generate this and return a corresponding command
    below.
    This entry is obsolete (no longer req'd) and will vanish."

    |os|

    os := OperatingSystem getOSType.
    (os = #irix or:[os = #osf]) ifTrue:[
	^ 'nm -B ' , file
    ].
    (os = #solaris) ifTrue:[
	^ 'nm -p ' , file
    ].
    ^ 'nm ' , file

    "Modified: / 4.5.1998 / 12:18:47 / cg"
!

objectFileExtension
    "return the fileName extension used for objects,
     as generated by myself (output of cc).
     This is very machine specific."

    OperatingSystem isMSDOSlike ifTrue:[
	"/ includes all of win32s, win95, winNT & os/2
	^ '.obj'
    ].
    OperatingSystem isVMSlike ifTrue:[
	^ '.obj'
    ].

    ^ '.o'

    "
     ObjectFileLoader objectFileExtension
    "

    "Modified: / 4.5.1998 / 12:17:34 / cg"
!

sharedLibraryExtension
    "return the fileName extension used for dynamic loadable objects,
     as generated by myself (output of linker).
     This is very machine specific."

    |suff|

    suff := self sharedLibrarySuffix.
    suff notNil ifTrue:[^ '.' , suff].
    ^ suff

    "
     ObjectFileLoader sharedLibraryExtension
    "

    "Modified: / 4.5.1998 / 12:17:34 / cg"
!

sharedLibrarySuffix
    "return the fileName suffix used for dynamic loadable objects,
     (as generated by myself - output of linker/makefiles).
     This is very os/machine specific."

    |suffixes|

    suffixes := self sharedLibrarySuffixes.
    suffixes notEmptyOrNil ifTrue:[
	^ suffixes first
    ].
    ^ 'so'

    "
     ObjectFileLoader sharedLibrarySuffix
    "

    "Modified (comment): / 12-02-2017 / 21:44:13 / cg"
!

sharedLibrarySuffixes
    "return a collection of possible fileName suffixes used for dynamic loadable objects.
     If multiple suffixes are possible, the first one should be the suffix generated by myself,
     when I create loadable modules (methods with primitive code).
     This is very os/machine specific."

    |os|

    OperatingSystem isMSDOSlike ifTrue:[
	"/ includes all Windows systems & os/2
	^ #( 'dll' )
    ].
    OperatingSystem isVMSlike ifTrue:[
	^ #( 'exe' )
    ].
    OperatingSystem isOSXlike ifTrue:[
	^ #( 'so' 'dylib' )
    ].

    os := OperatingSystem getSystemType.
    "/ are we really still supporting that old stuff?
    (self loadableBinaryObjectFormat == #aout) ifTrue:[
	"/ not really shared, but loadable
	^ #( 'o' )
    ].
    (os = #hpux) ifTrue:[
	^ #( 'sl' )
    ].

    ^ #( 'so' )

    "
     ObjectFileLoader sharedLibrarySuffixes
    "

    "Created: / 12-02-2017 / 21:41:18 / cg"
    "Modified: / 13-02-2017 / 20:17:31 / cg"
!

useBorlandC
    ^ ParserFlags useBorlandC

    "Created: / 15-03-2007 / 13:32:29 / cg"
!

validBinaryExtensions
    "return a collection of valid filename extension for binary files.
     This is very machine specific."

    |os|

    OperatingSystem isMSDOSlike ifTrue:[
	"/ includes all of win32s, win95, winNT & os/2
	^ #('dll')
    ].
    OperatingSystem isVMSlike ifTrue:[
	^ #('exe')
    ].

    os := OperatingSystem getSystemType.
    (os = 'linux') ifTrue:[
	"/ are we really still supporting that old stuff?
	self loadableBinaryObjectFormat == #aout ifTrue:[
	    ^ #('o' 'obj' 'a')
	].
	^ #('so')
    ].
    (os = 'hpux') ifTrue:[^ #('sl') ].
    (os = 'sunos') ifTrue:[^ #('o' 'obj' 'a') ].
    (os = 'ultrix') ifTrue:[^ #('o' 'obj' 'ld' 'obj.ld') ].

    "/ a useful default

    ^ #('so')

    "
     ObjectFileLoader validBinaryExtensions
    "

    "Modified: / 1.10.1998 / 12:46:03 / cg"
! !

!ObjectFileLoader class methodsFor:'dynamic object loading'!

loadCPlusPlusObjectFile:aFileName
    "load a c++ object file (.o-file) into the image.
     This method is not maintained (name mangling and static
     initialization is so different among systems ...)"

    |handle initAddr list|

    handle := self loadDynamicObject:aFileName.
    handle isNil ifTrue:[
	^ nil
    ].

    list := self namesMatching:'__GLOBAL_$I*' segment:'[tT?]' in:aFileName.
list size == 1 ifTrue:[
"/    (self isCPlusPlusObject:handle) ifTrue:[
	Verbose ifTrue:[
	    'a c++ object file' errorPrintCR.
	].
	"
	 what I would like to get is the CTOR_LIST,
	 and call each function.
	 But dld cannot (currently) handle SET-type symbols, therefore
	 we search (using nm) for all __GLOBAL_$I* syms, get their values
	 and call them each
	"
"/        list := self namesMatching:'__GLOBAL_$I*' segment:'[tT?]' in:aFileName.

"/        initAddr := self getFunction:'__CTOR_LIST__' from:handle.
"/        Verbose ifTrue:[
"/            ('calling CTORs at:' , (initAddr printStringRadix:16)) errorPrintCR
"/        ].

	initAddr := self getFunction:list first from:handle.
	initAddr isNil ifTrue:[
	    "
	     try with added underscore
	    "
	    initAddr := self getFunction:('_' , list first) from:handle.
	].
	(initAddr isNil and:[list first startsWith:'_']) ifTrue:[
	    "
	     try with removed underscore
	    "
	    initAddr := self getFunction:(list first copyFrom:2) from:handle.
	].
	initAddr isNil ifTrue:[
	    Verbose ifTrue:[
		('no CTOR-func found (' , list first , ')') errorPrintCR.
	    ].
	    self unloadDynamicObject:handle.
	    ^ nil
	].
	Verbose ifTrue:[
	    ('calling CTORs at:' , (initAddr printStringRadix:16)) errorPrintCR
	].
	self
	    saveCallInitFunctionAt:initAddr
	    in:aFileName
	    specialInit:false
	    forceOld:false
	    interruptable:false
	    argument:0
	    identifyAs:nil
	    returnsObject:false.

	Verbose ifTrue:[
	    'done with CTORs.' errorPrintCR
	].

	"
	 cannot create a CPlusPlus class automatically (there could be more than
	 one classes in it too ...)
	"
	^ handle
    ].


    Verbose ifTrue:[
	'unknown object file' errorPrintCR
    ].
    self unloadDynamicObject:handle.
    ^ nil

    "Modified: / 15-11-2010 / 13:19:06 / cg"
!

loadClass:aClassName fromObjectFile:aFileName
    "load a compiled class (.o-file) into the image.
     Returns the class or nil."

    |handle initAddr symName newClass moreHandles info status
     otherClass knownToBeOk|

    handle := self loadDynamicObject:aFileName.
    handle isNil ifTrue:[
	^ nil
    ].

    "
     get the Init-function; let the class install itself
    "
    symName := '_' , aClassName , '_Init'.
    initAddr := self getFunction:symName from:handle.
    initAddr isNil ifTrue:[
	"try with added underscore"
	symName := '__' , aClassName , '_Init'.
	initAddr := self getFunction:symName from:handle.
    ].

    knownToBeOk := true.

"/    knownToBeOk ifFalse:[
"/        |list|
"/
"/        Verbose ifTrue:[
"/            'looking for undefs ...' errorPrintCR.
"/        ].
"/
"/        "
"/         if there are any undefined symbols, we may have to load more
"/         files (libs, other modules)
"/        "
"/        list := self getListOfUndefinedSymbolsFrom:handle.
"/        list notNil ifTrue:[
"/            moreHandles := self loadModulesFromListOfUndefined:list.
"/
"/            "
"/             now, try again
"/            "
"/            symName := '_' , aClassName , '_Init'.
"/            initAddr := self getFunction:symName from:handle.
"/            initAddr isNil ifTrue:[
"/                "try with added underscore"
"/                symName := '__' , aClassName , '_Init'.
"/                initAddr := self getFunction:symName from:handle.
"/            ].
"/        ]
"/    ].

    initAddr notNil ifTrue:[
	Verbose ifTrue:[
	    ('calling init at: ' , (initAddr printStringRadix:16)) errorPrintCR.
	].
	info := self performModuleInitAt:initAddr for:aClassName identifyAs:handle.
	status := info at:1.
	"
	 if any classes are missing ...
	"
	(status == #missingClass) ifTrue:[
	    "
	     ... and we are loading a module ...
	    "
	    Transcript showCR:'ObjectFileLoader [info]: try for missing class in same object ...'.
	    Verbose ifTrue:[
		'try for missing class:' errorPrint. (info at:2) errorPrintCR.
	    ].
	    otherClass := self loadClass:(info at:2) fromObjectFile:aFileName.
	    otherClass notNil ifTrue:[
		"
		 try again ...
		"
		Transcript showCR:'ObjectFileLoader [info]: missing class is here; try again ...'.
		info := self performModuleInitAt:initAddr for:aClassName identifyAs:handle.
		status := info at:1.
	    ]
	].

	Verbose ifTrue:[
	    'done init status=' errorPrint. info errorPrintCR.
	].
	(status == #unregisteredSuperclass) ifTrue:[
	    Transcript showCR:'ObjectFileLoader [info]: superclass is not registered'.
	].

	(Symbol hasInterned:aClassName) ifTrue:[
	    newClass := Smalltalk at:aClassName asSymbol ifAbsent:[nil].
	    Verbose ifTrue:[
		'newClass is: ' errorPrint. newClass errorPrintCR
	    ].
	    newClass notNil ifTrue:[
		Smalltalk at:aClassName asSymbol put:newClass.

		(newClass includesSelector:#initialize) ifTrue:[
		    Verbose ifTrue:[
			'initialize newClass ...' errorPrintCR
		    ].
		    newClass initialize.
		].
		"force cache flush"
		Smalltalk isInitialized ifTrue:[
		    Smalltalk changed.
		]
	    ].
	] ifFalse:[
	    'ObjectFileLoader [warning]: class ' errorPrint. aClassName errorPrint.
	    ' did not define itself' errorPrintCR
	    "
	     do not unload - could have installed other classes/methods ...
	    "
	].
	^ newClass
    ].

    Verbose ifTrue:[
	('no symbol: ', symName,' in ',aFileName) errorPrintCR.
    ].

    "
     unload
    "
    Verbose ifTrue:[
	'unloading due to init failure:' errorPrint. handle pathName errorPrintCR.
    ].

"/    moreHandles notNil ifTrue:[
"/        moreHandles do:[:eachHandle |
"/            Verbose ifTrue:[
"/                ('unloading: ', eachHandle printString) errorPrintCR.
"/            ].
"/            self unloadDynamicObject:eachHandle.
"/        ]
"/    ].

    Verbose ifTrue:[
	('unloading: ', handle printString) errorPrintCR.
    ].
    self unloadDynamicObject:handle.
    ^ nil

    "
     ObjectFileLoader loadClass:'Tetris'      fromObjectFile:'../clients/Tetris/Tetris.o'
     ObjectFileLoader loadClass:'TetrisBlock' fromObjectFile:'../clients/Tetris/TBlock.o'
     ObjectFileLoader loadClass:'Foo'         fromObjectFile:'classList.o'
    "

    "Modified: 6.7.1997 / 12:34:48 / cg"
!

loadLibrary:aLibraryFileName
    "load a library; search in some standard places and using
     standard suffixes (i.e. no suffix should be given in the arg).
     Returns a handle or nil.
     Use this to attach C-libraries."

    |s suffixes handle libFilename libPath|

    Verbose ifTrue:[
	('loadLibrary:' , aLibraryFileName) errorPrintCR.
    ].
    libFilename := aLibraryFileName asFilename.
    (s := libFilename suffix) isEmpty ifTrue:[
	suffixes := self validBinaryExtensions
    ] ifFalse:[
	suffixes := Array with:s
    ].

    "/ try each suffix ...
    suffixes do:[:aSuffix |
	|fn f|

	aSuffix isEmptyOrNil ifTrue:[
	    fn := libFilename.
	] ifFalse:[
	    fn := libFilename withSuffix:aSuffix.
	].

	Verbose ifTrue:[
	    ('loadLibrary try:' , fn asString) errorPrintCR.
	].

	handle := self loadObjectFile:fn asString.
	handle notNil ifTrue:[^ handle].

	(libFilename isAbsolute
	 or:[(aLibraryFileName startsWith:'./')
	 or:[(aLibraryFileName startsWith:'../')]]) ifTrue:[
	    "/ already tried...
	] ifFalse:[
	    "/ try to load it by name - maybe someone else knows
	    "/ how to find it (the system itself)

	    "/ try each directory in libPath
	    libPath := self libPath.
	    libPath notEmptyOrNil ifTrue:[
		libPath asCollectionOfSubCollectionsSeparatedBy:$: do:[:eachSinglePath |
		    f := eachSinglePath asFilename construct:fn.
		    f exists ifTrue:[
			handle := self loadObjectFile:f pathName.
			handle notNil ifTrue:[^ handle].
		    ]
		]
	    ].
	]
    ].

    ^ nil

    "
     ObjectFileLoader loadLibrary:'libjpeg'
     ObjectFileLoader loadLibrary:'odbc32'
    "

    "Modified: / 04-05-1999 / 17:01:47 / cg"
    "Modified: / 20-09-2017 / 20:10:15 / stefan"
!

loadMethodObjectFile:aFileName
    "load an object file (.o-file) for a single method into the image;
     This does a slightly different initialization.
     Return an object handle; nil on error"

    |handle initAddr initName m|

    "/
    "/ load the objectfile
    "/
    handle := self loadDynamicObject:aFileName.
    handle isNil ifTrue:[
	^ nil
    ].

    "/
    "/ find the entry function
    "/
    initName := aFileName asFilename withoutSuffix baseName.

    initAddr := self getFunction:'__' , initName , '_Init' from:handle.
    initAddr isNil ifTrue:[
	initAddr := self getFunction:'_' , initName , '_Init' from:handle.
	initAddr isNil ifTrue:[
	    (self getListOfUndefinedSymbolsFrom:handle) size > 0 ifTrue:[
		self listUndefinedSymbolsIn:handle.
		'ObjectFileLoader [info]: undefined symbols in primitive code' errorPrintCR.
	    ] ifFalse:[
		('ObjectFileLoader [info]: ' , initName , '_Init() lookup failed') errorPrintCR
	    ].

	    "/
	    "/ not found - unload
	    "/
	    self unloadDynamicObject:handle.
	    ^ nil
	]
    ].

    OSSignalInterrupt handle:[:ex |
	('ObjectFileLoader [warning]: hard error in initFunction: ' , initName , ' of method-module ' , aFileName) errorPrintCR.
	self unloadDynamicObject:handle.
	^ nil
    ] do:[
	"/
	"/ call it - it returns the new method object
	"/
	self                              "/ registration
	    saveCallInitFunctionAt:initAddr
	    in:aFileName
	    specialInit:true
	    forceOld:true
	    interruptable:false
	    argument:0
	    identifyAs:handle
	    returnsObject:false.

	self
	    saveCallInitFunctionAt:initAddr   "/ global setup
	    in:aFileName
	    specialInit:true
	    forceOld:true
	    interruptable:false
	    argument:1
	    identifyAs:handle
	    returnsObject:false.

	m := self
	    saveCallInitFunctionAt:initAddr   "/ initialization
	    in:aFileName
	    specialInit:true
	    forceOld:true
	    interruptable:false
	    argument:2
	    identifyAs:handle
	    returnsObject:true.
    ].

    handle method:m.
    ^ handle

    "Created: / 05-12-1995 / 20:59:46 / cg"
    "Modified: / 15-11-2010 / 13:20:36 / cg"
!

loadObjectFile:aFileName
    "load an object file (.o-file) into the image;
     the class name is not needed (multiple definitions may be in the file).
     This may be either a smalltalk object or a C-object file.
     The object files init function (if any) is called, and the module
     is unloaded if it returns failure (use lowLevel load, to load a file
     without automatic initialization).
     Return nil on error, an objectFile handle if ok."

    ^ self
	loadObjectFile:aFileName
	invokeInitializeMethods:true
!

loadObjectFile:pathNameOrFilename invokeInitializeMethods:invokeInitializeMethods
    "load an object file (.dll or .so-file) into the image;
     the class name is not needed (multiple definitions may be in the file).
     This may be either a smalltalk object or a C-object file.
     The object file's init function (if any) is called, and the module
     is unloaded if it returns failure (use lowLevel load, to load a file
     without automatic initialization).
     Returns nil on error, or the objectFile's handle if ok."

    |filename pathName handle initAddr initDefinitionAddr initFunctionName initNames didInit info status
     dummyHandle msg isCModule doNotUnload definitionClassName definitionClass cRetVal|

    filename := pathNameOrFilename asFilename.
    pathName := filename pathName.

    handle := self handleForDynamicObject:filename.
    handle notNil ifTrue:[
	"already loaded"
	^ handle.
    ].

    handle := self loadDynamicObject:filename.
    handle isNil ifTrue:[
	^ nil
    ].

    didInit := false.
    isCModule := false.

    "with dld, load may have worked, even if undefined symbols
     are to be resolved. If that's the case, load all libraries ..."

    ParserFlags searchedLibraries notEmptyOrNil ifTrue:[
	(self hasUndefinedSymbolsIn:handle) ifTrue:[
	    self initializeLoader.

	    ParserFlags searchedLibraries do:[:libName |
		(self hasUndefinedSymbolsIn:handle) ifTrue:[
		    Logger info:'   ... trying  %1 to resolve undefined symbols ...' with:libName.
		    dummyHandle := Array new:4.
		    dummyHandle := self primLoadDynamicObject:libName into:dummyHandle.
"/                    dummyHandle isNil ifTrue:[
"/                        Transcript showCR:'   ... load of library ' , libName , ' failed.'.
"/                    ]
		]
	    ].
	    (self hasUndefinedSymbolsIn:handle) isNil ifTrue:[
		Logger info:'still undefined symbols in %1.' with:pathName.
	    ].
	]
    ].

    "
     first, expect the classes-name to be the fileNames-baseName
     (if it's not, it may be a method or function module;
      in this case, the Init function is supposed to use that naming
      scheme as well)
    "
    initFunctionName := self initFunctionBasenameForFile:filename.

    "look for explicit initDefinition (xxx_InitDefinition) function
     This is used in ST packaged classLib object files"

    (initFunctionName startsWith:'lib') ifTrue:[
	definitionClassName := initFunctionName copyFrom:4.
	definitionClass := Smalltalk classNamed:definitionClassName.
    ].
    (definitionClass isNil or:[definitionClass isLoaded not]) ifTrue:[
	"the project definition class has not been loaded yet.
	 initialize and load it"

	initDefinitionAddr := self findInitDefinitionFunction:initFunctionName in:handle.
	initDefinitionAddr isNil ifTrue:[
            Logger warning: 'no init definitions for: %1' with: pathName.
	] ifFalse:[
	    Verbose ifTrue:[
                Logger info: 'calling initDefinition at: %1' with: (initDefinitionAddr printStringRadix:16).
	    ].
	    info := self
			performModuleInitAt:initDefinitionAddr
			invokeInitializeMethods:false
			for:definitionClassName
			identifyAs:handle.
	    status := info at:1.
	    status == #ok ifTrue:[
		"/ now, we have only loaded and installed the projectDefinition class.
		"/ (but no containing classes or extensions, yet).
		"/ let the projectDefinition load any prereqs
	       definitionClassName notNil ifTrue:[
		    definitionClass := Smalltalk classNamed:definitionClassName.
		    definitionClass notNil ifTrue:[
"/                        "if projectDefinition denies loading, unload"
"/                            self unloadDynamicObject:handle.

			definitionClass
			    checkForLoad;                           "/ raise exception if not supported on platform / not licensed
			    initialize;
			    preLoadAction;
			    loadMandatoryPreRequisitesAsAutoloaded:false.
		    ].
		].
	    ]
	].
    ].
    "look for explicit init (xxx_Init) function
     This is used in ST object files"

    initAddr := self findInitFunction:initFunctionName in:handle.
    initAddr notNil ifTrue:[
	Verbose ifTrue:[
            Logger info: ' calling init at: %1' with: (initAddr printStringRadix:16).
	].
	info := self
		    performModuleInitAt:initAddr
		    invokeInitializeMethods:invokeInitializeMethods
		    for:nil
		    identifyAs:handle.
	status := info at:1.
	status == #ok ifTrue:[
	    didInit := true.
	    definitionClassName notNil ifTrue:[
		definitionClass := Smalltalk classNamed:definitionClassName.
	    ]
	]
    ] ifFalse:[
	"look for explicit C-init (xxx__Init) function
	 This is used in C object files"

	initAddr := self findFunction:initFunctionName suffix:'__Init' in:handle.
	initAddr notNil ifTrue:[
	    isCModule := true.

	    OSSignalInterrupt handle:[:ex |
		Logger error:'hard error in initFunction of class-module: %1' with:pathName.
		status := #initFailed.
	    ] do:[
		cRetVal := self
		    saveCallInitFunctionAt:initAddr
		    in:pathNameOrFilename
		    specialInit:false
		    forceOld:true
		    interruptable:false
		    argument:0
		    identifyAs:handle
		    returnsObject:false.
		(cRetVal < 0) ifTrue:[
		    Verbose ifTrue:[
                        Logger info: 'init function returns failure ... unload'.
		    ].
		    status := #initFailed.
		] ifFalse:[
		    didInit := true.
		]
	    ]
	] ifFalse:[
	    status := #noInitFunction.

	    "look for any init-function(s); call them all"
	    Verbose ifTrue:[
                Logger info: 'no good init functions found; looking for candidates ...'.
	    ].
	    initNames := self namesMatching:'*_Init' segment:'[tT?]' in:pathName.
	    initNames notNil ifTrue:[
		initNames do:[:aName |
		    initAddr := self getFunction:aName from:handle.
		    initAddr isNil ifTrue:[
			(aName startsWith:'_') ifTrue:[
			    initAddr := self getFunction:(aName copyFrom:2) from:handle.
			].
		    ].
		    initAddr isNil ifTrue:[
			Transcript showCR:('no symbol: ',aName,' in ', pathName).
		    ] ifFalse:[
			Verbose ifTrue:[
                            Logger info: ' calling init at: %1' with: (initAddr printStringRadix:16)
			].
			self
			    performModuleInitAt:initAddr
			    invokeInitializeMethods:invokeInitializeMethods
			    for:nil
			    identifyAs:handle.
			didInit := true.
		    ]
		].
	    ].
	]
    ].

    (invokeInitializeMethods and:[didInit not]) ifTrue:[
	status == #noInitFunction ifTrue:[
	    msg := 'no classLib init function found; assume load ok'
	] ifFalse:[
	    (status ~~ #registrationFailed
		and:[status ~~ #initFailed
		and:[status ~~ #missingClass
		and:[status ~~ #versionMismatch]]])
	    ifTrue:[
		self listUndefinedSymbolsIn:handle.
	    ].

	    Verbose ifTrue:[
                Logger info: ': unloading, since init failed ...'.
	    ].

	    "/ give caller a chance to prevent unloading (to register later, when a prerequisite class comes)
	    status == #missingClass ifTrue:[
		doNotUnload := (SuperClassMissingErrorNotification query ? false).
	    ] ifFalse:[
		status == #registrationFailed ifTrue:[
		    doNotUnload := (RegistrationFailedErrorNotification query ? false).
		] ifFalse:[
		    doNotUnload := false.
		].
	    ].
	    doNotUnload ifFalse:[
		self unloadDynamicObject:handle.
		Verbose ifTrue:[
                    Logger info: 'unloaded'.
		].
		handle := nil.
	    ].

	    status == #initFailed ifTrue:[
		msg := 'module not loaded (init function signaled failure).'
	    ] ifFalse:[
		status == #missingClass ifTrue:[
		    msg := 'module not loaded (superclass missing: ' , (info at:2) , ').'
		] ifFalse:[
		    status == #registrationFailed ifTrue:[
			msg :=  'module registration failed (incompatible object or missing superclass)'
		    ] ifFalse:[
			status == #versionMismatch ifTrue:[
			    msg :=  'module registration failed (class version mismatch ' , (info at:2) printString , ')'
			] ifFalse:[
			    (self namesMatching:'*__sepInitCode__*' segment:'[tT?]' in:pathName) notNil ifTrue:[
				msg := 'module not loaded (unknown error reason).'
			    ] ifFalse:[
				msg := 'module not loaded (no _Init entry in object file ?).'
			    ]
			]
		    ].
		].
	    ].
	].
	Verbose ifTrue:[
	    Logger debug:'%1: %2' with:pathNameOrFilename asFilename baseName with:msg.
	].
    ].

    isCModule ifFalse:[
	Smalltalk flushCachedClasses.
	Class flushSubclassInfo.

	(definitionClass notNil and:[definitionClass isLoaded]) ifTrue:[
            definitionClass checkForLoad.               "/ raise exception if not supported on platform / not licensed
            Smalltalk changed: #aboutToLoadPackage with: definitionClass.
	    definitionClass
		loadAllClassesAsAutoloaded:true;
		loadPreRequisitesAsAutoloaded:true;     "/ load non-mandatory prerequisites
		projectIsLoaded:true.                   "/ this performs the postLoadAction, too.
            Smalltalk changed: #packageLoaded with: definitionClass.
	].
	Smalltalk isInitialized ifTrue:[
	    "really don't know, if and what has changed ...
	     ... but assume, that new classes have been installed."
	    Smalltalk changed:#postLoad.
	].
    ].
    ^ handle

    "Modified: / 15-11-2010 / 13:19:26 / cg"
    "Modified: / 20-09-2016 / 00:02:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 13-02-2017 / 20:27:55 / cg"
!

unloadAllObsoleteObjectFiles
    "unload all dynamically loaded object files for which the classes/method
     has been already garbage collected."

    LoadedObjects notNil ifTrue:[
	LoadedObjects values copy do:[:eachHandle |
	    (eachHandle notNil and:[eachHandle isObsolete]) ifTrue:[
		self unloadDynamicObject:eachHandle
	    ]
	]
    ].

    "
     ObjectFileLoader unloadAllObsoleteObjectFiles
    "

    "Modified: 5.12.1995 / 18:16:52 / cg"
!

unloadObjectFile:aFileName
    "unload an object file (.o-file) from the image.
     DANGER ALERT: currently, you have to make sure that no references to
     objects of this module exist - in future versions, the system will keep
     track of these. For now, use at your own risk.
     (especially critical are blocks-functions)."

    |handle|

    LoadedObjects notNil ifTrue:[
	handle := LoadedObjects at:aFileName ifAbsent:nil
    ].
    handle isNil ifTrue:[
	('ObjectFileLoader [info]: oops - file to be unloaded was not loaded dynamically (', aFileName , ')') infoPrintCR.
	^ self
    ].

    "/ call the modules deInit-function and unload...
    self unloadDynamicObject:handle

    "Modified: / 06-12-2006 / 18:19:13 / cg"
!

unloadObjectFileAndRemoveClasses:aFileName
    "unload an object file (.o-file) from the image and remove all
     corresponding classes from the system.
     DANGER ALERT: currently, you have to make sure that no references to
     objects of this module exist - in future versions, the system will keep
     track of these. For now, use at your own risk.
     (especially critical are blocks-functions)."

    |handle|

    LoadedObjects notNil ifTrue:[
	handle := LoadedObjects at:aFileName ifAbsent:nil
    ].
    handle isNil ifTrue:[
	('ObjectFileLoader [info]: oops - file to be unloaded was not loaded dynamically (', (aFileName ? 'unknown-file') , ')') infoPrintCR.
	^ self
    ].
    handle isClassLibHandle ifFalse:[
	self error:'Module is not a classLib module. Proceed to unload anyway' mayProceed:true.
    ].

    "/ remove the classes ...
    Class withoutUpdatingChangesDo:[
	handle classes do:[:eachClass |
	    (eachClass notNil and:[eachClass isMeta not]) ifTrue:[
		eachClass removeFromSystem.
	    ]
	]
    ].

    "/ call the modules deInit-function and unload...
    self unloadDynamicObject:handle

    "Modified: / 06-12-2006 / 18:19:19 / cg"
! !

!ObjectFileLoader class methodsFor:'dynamic object queries'!

findFunction:functionName suffix:suffix in:handle
    "look for the init function and returns its address"

    |initAddr className nm|

    "/ care for colons, as found in nameSpace classes ...
    nm := functionName asString.
    nm := nm copyReplaceAll:$: with:$_ ifNone:nm.

    "
     look for explicit init function
    "
    initAddr := self getFunction:(nm , suffix) from:handle.
    initAddr notNil ifTrue:[^ initAddr].

    initAddr := self getFunction:('_' , nm , suffix) from:handle.
    initAddr notNil ifTrue:[^ initAddr].

    "/
    "/ special for broken ultrix nlist
    "/ (will not find symbol with single underscore)
    "/ workaround: add another underscore and retry
    "/
    initAddr := self getFunction:('__' , nm , suffix) from:handle.
    initAddr notNil ifTrue:[^ initAddr].

    (functionName startsWith:'lib') ifTrue:[
	className := functionName
    ] ifFalse:[
	"
	 look for reverse abbreviation - slow, because abbrevs are recursively read
	"
	className := functionName. "/ Smalltalk classNameForFile:functionName.
    ].
    className notNil ifTrue:[
	initAddr := self getFunction:(className , suffix) from:handle.
	initAddr notNil ifTrue:[^ initAddr].

	initAddr := self getFunction:('_' , className , suffix) from:handle.
	initAddr isNil ifTrue:[
	    "/
	    "/ special for broken ultrix nlist
	    "/ (will not find symbol with single underscore)
	    "/ workaround: add another underscore and retry
	    "/
	    initAddr := self getFunction:('__' , className , suffix) from:handle.
	].
    ].
    ^ initAddr

    "Created: / 13-07-1996 / 00:38:01 / cg"
    "Modified: / 16-01-2012 / 19:57:11 / cg"
!

findInitDefinitionFunction:functionName in:handle
    "look for the initDefinition function and return its address or nil"

    ^ self findFunction:functionName suffix:'_InitDefinition' in:handle

    "Modified: 13.7.1996 / 00:38:33 / cg"
!

findInitFunction:functionName in:handle
    "look for the init function and return its address or nil"

    ^ self findFunction:functionName suffix:'_Init' in:handle

    "Modified: 13.7.1996 / 00:38:33 / cg"
!

getFunction:aStringOrSymbol from:handle
    "return the address of a function from a dynamically loaded object file.
     Handle must be the one returned previously from loadDynamicObject.
     Return the address of the function, or nil on any error."

    ^ self getSymbol:aStringOrSymbol asString function:true from:handle
!

getListOfUndefinedSymbolsFrom:aHandle
    "return a collection of undefined symbols in a dynamically loaded object file.
     Handle must be the one returned previously from loadDynamicObject.
     Not all systems allow an object with undefined symbols to be
     loaded (actually, only dld does)."

    |list|

%{  /* STACK: 20000 */
#ifdef GNU_DL
    void (*func)();
    unsigned long addr;
    char *name;
    int nMax;
    char **undefNames;

    undefNames = dld_list_undefined_sym();
    if (dld_undefined_sym_count > 0) {
	char **nm;
	int index;
	int count = dld_undefined_sym_count;

	if (count > 100) count = 100;
	list = __ARRAY_NEW_INT(count);
	if (list) {
	    nm = undefNames;
	    for (index = 0; index < count; index++) {
		OBJ s;

		s = __MKSTRING(*nm);
		__ArrayInstPtr(list)->a_element[index] = s;
		__STORE(list, s);
		nm++;
	    }
	    free(undefNames);
	}
    }
#endif

#ifdef DL1_6
    /*
     * don't know how to do it
     */
#endif

#ifdef SYSV4_DL
    /*
     * don't know how to do it
     */
#endif

#ifdef SUN_DL
    /*
     * don't know how to do it
     */
#endif

#ifdef NEXT_DL
    /*
     * don't know how to do it
     */
#endif

#ifdef WIN_DL
    /*
     * don't know how to do it
     */
#endif

#ifdef BEOS_DL
    /*
     * don't know how to do it
     */
#endif

%}.
    ^ list
!

getSymbol:aString function:isFunction from:aHandle
    "return the address of a symbol/function from a dynamically loaded object file.
     Handle must be the one returned previously from loadDynamicObject.
     Return the address of the symbol, or nil on any error."

    |sysHandle1 sysHandle2 pathName address|

    sysHandle1 := aHandle sysHandle1.
    sysHandle2 := aHandle sysHandle2.
    pathName := aHandle pathName.

%{  /* STACK: 20000 */

#ifdef GNU_DL
  {
    void (*func)();
    unsigned INT addr;
    char *name;

    if (__isStringLike(aString)) {
	name = (char *) __stringVal(aString);
	if (isFunction == false) {
	    addr = dld_get_symbol(name);
	    if (addr) {
		if (@global(Verbose) == true) {
		    console_printf("addr of %s = %x\n", name, addr);
		}
		address = __MKUINT( addr );
	    }
	} else {
	    func = (void (*) ()) dld_get_func(name);
	    if (func) {
		if (@global(Verbose) == true) {
		    console_printf("addr of %s = %x\n", name, (INT)func);
		}
		if (dld_function_executable_p(name)) {
		    address = __MKUINT( (INT)func );
		} else {
		    char **undefNames;
		    char **nm;
		    int i;

		    if (@global(Verbose) == true) {
			console_printf ("function %s not executable\n", name);
			dld_perror("not executable");

			console_printf("undefined:\n");
			nm = undefNames = dld_list_undefined_sym();
			for (i=dld_undefined_sym_count; i; i--) {
			    console_printf("    %s\n", *nm++);
			}
			free(undefNames);
		    }
		}
	    } else {
		if (@global(Verbose) == true) {
		    console_printf ("function %s not found\n", name);
		    dld_perror("get_func");
		}
	    }
	}
    }
  }
#endif /* GNU_DL */

#ifdef WIN_DL
  {
    void *h;
    void *addr;
    INT val;
    FARPROC entry;
    HMODULE handle;

    if (__bothSmallInteger(sysHandle1, sysHandle2)) {
# if __POINTER_SIZE__ == 8
	val = (_intVal(sysHandle2) << 32) + _intVal(sysHandle1);
# else
	val = (_intVal(sysHandle2) << 16) + _intVal(sysHandle1);
# endif
	handle = (HMODULE)(val);
	if (__isStringLike(aString)) {
	    if (@global(Verbose) == true)
		console_printf("get sym <%s> handle = %"_lx_"\n", __stringVal(aString), (INT)handle);
            /*
             * Unlike POSIX.1-2001 dlopen(), Windows has no such handle that
             * would, when passed to GetProcAddress(), search current loaded image
             * (i.e., all loaded .dlls and .exes). To allow this, when #primLoadObjectFile
             * is asked to return a such a handle, it returns a fake handle with value 0. 
             *
             * In this case we have to loop over all loaded modules (HINSTANCEs) and 
             * try to GetProcAddress() from each of them. If we find only one, then return
             * it. 
             *
             * What a hack!
             */
            if (handle == 0) {
            	HMODULE modules[256];
            	DWORD   modules_needed;
		if (EnumProcessModules(GetCurrentProcess(), modules, sizeof(modules), &modules_needed)) {
		    int i;
		    entry = NULL;
		    for (i = 0; i < modules_needed / sizeof(HMODULE); i++) {
			FARPROC entry_found = GetProcAddress(modules[i], (char *) __stringVal(aString));
			if (entry_found != NULL) {
			    if (entry == NULL) {
			        entry = entry_found;
			    } else {
				if (@global(Verbose) == true) {
				    console_printf("Multiple symbols found for %s: %"_lx_" and %"_lx_"\n", __stringVal(aString), entry, entry_found);
				}
				entry = NULL;
				break;
			    }
			}
		    }
		}
            } else {
	        entry = GetProcAddress(handle, (char *) __stringVal(aString));
	    }
	    if (entry != NULL) {
		addr = (void *)entry;
		if (@global(Verbose) == true) {
		    console_printf("GetProcAddr %s ok; addr = %"_lx_"\n", __stringVal(aString), (INT)addr);
		}
		address = __MKUINT( (INT)addr );
	    } else {
		if (@global(Verbose) == true) {
		    console_printf("GetProcAddr %s error: %x\n", __stringVal(aString), GetLastError());
		}
	    }
	}
    }
  }
#endif

#ifdef BEOS_DL
  {
    void *h;
    void *addr;
    INT val;
    void *handle;

    if (__bothSmallInteger(sysHandle1, sysHandle2)) {
# if __POINTER_SIZE__ == 8
	val = (_intVal(sysHandle2) << 32) + _intVal(sysHandle1);
# else
	val = (_intVal(sysHandle2) << 16) + _intVal(sysHandle1);
# endif
	handle = (void *)(val);

	if (__isStringLike(aString)) {
	    if (@global(Verbose) == true)
		console_printf("get sym <%s> handle = %"_lx_"\n", __stringVal(aString), (INT)handle);
	    entry = NULL;
	    get_image_symbol((image_id) handle, (char *) __stringVal(aString), B_SYMBOL_TYPE_TEXT, &entry);
	    if (entry != NULL) {
		addr = (void *)entry;
		if (@global(Verbose) == true) {
		    console_printf("get_image_symbol %s ok; addr = %x\n", __stringVal(aString), addr);
		}
		address = __MKUINT( (INT)addr );
	    } else {
		if (@global(Verbose) == true) {
		    console_printf("get_image_symbol %s error\n", __stringVal(aString));
		}
	    }
	}
    }
  }
#endif

#ifdef DL1_6
  {
    void *h;
    void *addr;
    INT val;

    if (__isStringLike(aString)) {
	if (__isStringLike(sysHandle1)) {
	    if (@global(Verbose) == true)
		console_printf("get sym <%s> handle = %x\n",
			__stringVal(aString), __stringVal(sysHandle1));
	    addr = dl_getsymbol(__stringVal(sysHandle1), __stringVal(aString));
	    if (addr) {
		if (@global(Verbose) == true)
		    console_printf("addr = %x\n", addr);
		address = __MKUINT( (INT)addr );
	    } else {
		if (@global(Verbose) == true)
		    console_printf("dl_getsymbol %s failed\n", __stringVal(aString));
	    }
	}
    }
  }
#endif

#ifdef SYSV4_DL
  {
    void *h;
    void *addr;
    INT val;
    OBJ low = sysHandle1, hi = sysHandle2;
    extern void *dlsym();

    if (__bothSmallInteger(low, hi)) {
# if __POINTER_SIZE__ == 8
	val = (__intVal(hi) << 32) + __intVal(low);
# else
	val = (__intVal(hi) << 16) + __intVal(low);
# endif
	h = (void *)(val);
	if (__isStringLike(aString)) {
	    if (@global(Verbose) == true) {
		console_printf("get sym <%s> handle = %"_lx_"\n", __stringVal(aString), (INT)h);
	    }
	    addr = dlsym(h, (char *) __stringVal(aString));
	    if (addr) {
		if (@global(Verbose) == true) {
		    console_printf("dlsym %s ok; addr = %"_lx_"\n", __stringVal(aString), (INT)addr);
		}
		address = __MKUINT( (INT)addr );
	    } else {
		if (@global(Verbose) == true) {
		    console_printf("dlsym %s error: %s\n", __stringVal(aString), dlerror());
		}
	    }
	}
    }
  }
#endif

#ifdef HPUX10_DL
  {
    void *h;
    void *addr;
    INT val, ret;
    OBJ low = sysHandle1, hi = sysHandle2;

    if (__bothSmallInteger(low, hi)) {
# if __POINTER_SIZE__ == 8
	val = (__intVal(hi) << 32) + __intVal(low);
# else
	val = (_intVal(hi) << 16) + _intVal(low);
# endif
	h = (void *)(val);
	if (__isStringLike(aString)) {
	    if (@global(Verbose) == true) {
		console_printf("get sym <%s> handle = %x\n", __stringVal(aString), h);
	    }
	    ret = shl_findsym(h, __stringVal(aString), TYPE_UNDEFINED, &addr);
	    if (ret != 0) {
		if (@global(Verbose) == true) {
		    console_printf("dlsym %s error; errno=%d\n", __stringVal(aString), errno);
		}
	    } else {
		if (@global(Verbose) == true) {
		    console_printf("dlsym %s ok; addr = %x\n", __stringVal(aString), addr);
		}
		address = __MKUINT( (INT)addr );
	    }
	}
    }
  }
#endif


#ifdef AIX_DL
  {
    void *h;
    void *addr;
    INT val;
    struct nlist nl[2];
    OBJ low = sysHandle1, hi = sysHandle2;
    char nameBuffer[256];
    static struct funcDescriptor {
	unsigned vaddr;
	unsigned long2;
	unsigned long3;
    } descriptor;

    if (__bothSmallInteger(low, hi)
     && __isStringLike(aString) && __isStringLike(pathName)) {
# if __POINTER_SIZE__ == 8
	val = (__intVal(hi) << 32) + __intVal(low);
# else
	val = (__intVal(hi) << 16) + __intVal(low);
# endif
	h = (void *)(val);

	if (@global(Verbose) == true) {
	    console_printf("get sym <%s> handle = %x path= %s\n",
			__stringVal(aString), h, __stringVal(pathName));
	}

#define USE_ENTRY
#ifdef USE_ENTRY
	/*
	 * only works, if the entry-function is the Init function
	 * (i.e. linked with -e _xxx_Init)
	 */
	if (@global(Verbose) == true) {
	    console_printf("returned handle as addr = %x\n", h);
	}
	address = __MKUINT( (INT)(h) );
#else

# ifdef USE_DESCRIPTOR
	if (isFunction == true) {
# else
	if (0) {
# endif
	    nameBuffer[0] = '.';
	    strcpy(nameBuffer+1, aString);
	    nl[0].n_name = nameBuffer;
	} else {
	    nl[0].n_name = __stringVal(aString);
	}
	nl[1].n_name = "";

	if (nlist(__stringVal(pathName), &nl) == -1) {
	    if (@global(Verbose) == true) {
		console_printf("nlist error\n");
	    }
	} else {
	    addr = (void *)((unsigned)nl[0].n_value + (unsigned)h);

	    if (isFunction == true) {
# ifdef USE_DESCRIPTOR
		console_printf("daddr = %x\n", addr);
		console_printf("daddr[0] = %x\n", ((long *)addr)[0]);
		console_printf("daddr[1] = %x\n", ((long *)addr)[1]);
		console_printf("daddr[2] = %x\n", ((long *)addr)[2]);
# endif
	    }

	    if (@global(Verbose) == true) {
		console_printf("value=%x section=%d type=%x sclass=%d\n",
			nl[0].n_value, nl[0].n_scnum, nl[0].n_type, nl[0].n_sclass);
		console_printf("vaddr = %x\n", addr);
	    }
# ifdef DOES_NOT_WORK
	    address = __MKUINT( (INT)addr );
# else
	    descriptor.vaddr = (unsigned INT) addr;
	    descriptor.long2 = 0;
	    descriptor.long3 = 0;
	    address = __MKUINT( (INT)(&descriptor) );
# endif
	}
#endif /* don't USE_ENTRY */
    }
  }
#endif /* AIX_DL */


#ifdef SUN_DL
  {
    void *h;
    void *addr;
    INT val;
    OBJ low = sysHandle1, hi = sysHandle2;

    if (__bothSmallInteger(low, hi)) {
	val = (_intVal(hi) << 16) + _intVal(low);
	h = (void *)(val);
	if (__isStringLike(aString)) {
	    if (@global(Verbose) == true) {
		console_printf("get sym <%s> handle = %x\n", __stringVal(aString), h);
	    }
	    addr = dlsym(h, __stringVal(aString));
	    if (addr) {
		if (@global(Verbose) == true) {
		    console_printf("addr = %x\n", addr);
		}
		address = __MKUINT( (INT)addr );
	    } else {
		if (@global(Verbose) == true) {
		    console_printf("dlsym %s error: %s\n", __stringVal(aString), dlerror());
		}
	    }
	}
    }
  }
#endif


#ifdef NEXT_DL
  {
    unsigned long addr;
    long result;
    NXStream *errOut;

    if (__isStringLike(aString)) {
	if (@global(Verbose) == true) {
	    console_printf("get sym <%s>\n", __stringVal(aString));
	}
	errOut = NXOpenFile(2, 2);
	result = rld_lookup(errOut,
			    (char *) __stringVal(aString),
			    &addr);
	NXClose(errOut);
	if (result) {
	    if (@global(Verbose) == true) {
		console_printf("addr = %x\n", addr);
	    }
	    address = __MKUINT( (INT)addr );
	}
    }
  }
#endif

%}.
    ^ address
!

hasUndefinedSymbolsIn:handle
    "return true, if a module has undefined symbols in it.
     This is only possible if the system supports loading
     modules with undefined things in it - most do not"

    ^ (self getListOfUndefinedSymbolsFrom:handle) size > 0

    "Modified: 25.4.1996 / 09:47:27 / cg"
!

initFunctionBasenameForFile:pathNameOrFilename
    "return the expected initFunction's name, given a fileName"

    |fileName name suffixLen|

    "
     first, expect the classes-name to be the fileName-base
    "
    fileName := pathNameOrFilename asFilename.
    suffixLen := 0.
    self validBinaryExtensions do:[:suffix |
	suffixLen == 0 ifTrue:[
	    (fileName hasSuffix:suffix) ifTrue:[
		suffixLen := suffix size + 1
	    ]
	]
    ].
    name := fileName baseName.

    suffixLen ~~ 0 ifTrue:[
	name := name copyButLast:suffixLen
    ] ifFalse:[
	('ObjectFileLoader [warning]: invalid binary object file suffix in: ',fileName name) infoPrintCR.
	name := fileName withoutSuffix baseName
    ].
    ^ name.

    "
     ObjectFileLoader initFunctionBasenameForFile:'libstx_libbasic.so'  (unix)
     ObjectFileLoader initFunctionBasenameForFile:'libstx_libbasic.dll' (msdos)
     ObjectFileLoader initFunctionBasenameForFile:'demo.so'
     ObjectFileLoader initFunctionBasenameForFile:'demo.o'
     ObjectFileLoader initFunctionBasenameForFile:'demo.obj'
    "

    "Created: / 13.7.1996 / 00:01:54 / cg"
    "Modified: / 1.10.1998 / 12:47:50 / cg"
!

isCPlusPlusObject:handle
    "return true, if the loaded object is a c++ object module.
     This is not yet fully implemented/supported."

    (self getSymbol:'__gnu_compiled_cplusplus' function:true from:handle) notNil ifTrue:[^ true].
    (self getSymbol:'__CTOR_LIST__' function:true from:handle) notNil ifTrue:[^ true].
    (self getSymbol:'__CTOR_LIST__' function:false from:handle) notNil ifTrue:[^ true].
    (self getSymbol:'__gnu_compiled_cplusplus' function:false from:handle) notNil ifTrue:[^ true].
    ^ false

    "Modified: 25.4.1996 / 09:48:19 / cg"
!

isObjectiveCObject:handle
    "return true, if the loaded object is an objective-C object module.
     This is not yet implemented/supported"

    ^ false

    "Modified: 25.4.1996 / 09:47:59 / cg"
!

isSmalltalkObject:handle
    "return true, if the loaded object is a smalltalk object module"

    "not yet implemented - stc_compiled_smalltalk is a static symbol,
     not found in list - need nm-interface, or nlist-walker
    "
    ^ true.

"/    (self getSymbol:'__stc_compiled_smalltalk' function:true from:handle) notNil ifTrue:[^ true].
"/    (self getSymbol:'__stc_compiled_smalltalk' function:false from:handle) notNil ifTrue:[^ true].
"/    ^ false
!

listUndefinedSymbolsIn:handle
    "list undefined objects in a module on the transcript"

    |undefinedNames|

    undefinedNames := self getListOfUndefinedSymbolsFrom:handle.
    undefinedNames size > 0 ifTrue:[
	Transcript showCR:'ObjectFileLoader [info]: undefined:'.
	undefinedNames do:[:aName |
	    Transcript showCR:'    ' , aName
	]
    ].

    "Modified: 18.5.1996 / 15:43:45 / cg"
!

namesMatching:aPattern segment:segmentPattern in:aPathName
    "search for entries which match a pattern.
     This is obsolete & rubbish - it will vanish soon"

    |p l s addr segment name entry|

    OperatingSystem isVMSlike ifTrue:[
	"/ no nm command
	^ nil
    ].
    OperatingSystem isMSDOSlike ifTrue:[
	"/ no nm command
	^ nil
    ].
    OperatingSystem getOSType = 'aix' ifTrue:[
	"/ no useful nm info
	^ nil
    ].

    l := OrderedCollection new.
    p := PipeStream readingFrom:(self nm:aPathName).
    p isNil ifTrue:[
	('ObjectFileLoader [info]: cannot read names from ' , aPathName) infoPrintCR.
	^ nil
    ].
    [p atEnd] whileFalse:[
	entry := p nextLine.
	Verbose ifTrue:[
	    entry errorPrintCR.
	].
	entry notNil ifTrue:[
	    s := ReadStream on:entry.
	    addr := s nextAlphaNumericWord.
	    s skipSeparators.
	    segment := s upToSeparator.
	    s skipSeparators.
	    name := s upToEnd withoutSeparators.
	    (addr notNil and:[segment notNil and:[name notNil]]) ifTrue:[
		(aPattern match:name) ifTrue:[
		    (segmentPattern isNil or:[segmentPattern match:segment]) ifTrue:[
			l add:name.
			Verbose ifTrue:[
			    ('found name: ' , name) errorPrintCR.
			]
		    ] ifFalse:[
			Verbose ifTrue:[
			    name errorPrint. ' segment mismatch ' errorPrint.
			    segmentPattern errorPrint. ' ' errorPrint. segment errorPrintCR.
			]
		    ]
		]
	    ]
	]
    ].
    p close.
    ^ l

    "Modified: / 27.7.1998 / 20:10:57 / cg"
!

releaseSymbolTable
    "this is needed on NeXT to forget loaded names. If this wasnt done,
     the same class could not be loaded in again due to multiple defines.
     On other architectures, this is not needed and therefore a noop."

%{
#ifdef NEXT_DL
    NXStream *errOut;

    errOut = NXOpenFile(2, 2);
    rld_unload_all(errOut, (long)0);
    rld_load_basefile(errOut, "smalltalk");
    NXClose(errOut);
#endif
%}
! !

!ObjectFileLoader class methodsFor:'image save/restart'!

invalidateAndRememberAllObjectFiles
    "invalidate code refs into all dynamically loaded object files.
     Required before writing a snapshot image."

    LoadedObjects notNil ifTrue:[
	ActuallyLoadedObjects := LoadedObjects.
	self rememberAllObjectFiles.
	ActuallyLoadedObjects keys do:[:aFileName |
	    |handle|

	    handle := ActuallyLoadedObjects at:aFileName.
	    handle isNil ifTrue:[
		self error:'oops, no handle'.
	    ] ifFalse:[
		(handle isClassLibHandle or:[handle isMethodHandle]) ifTrue:[
		    self invalidateModule:handle
		]
	    ]
	].
	LoadedObjects := nil.
    ].

    "Created: 5.10.1995 / 15:48:56 / claus"
    "Modified: 5.10.1995 / 16:48:51 / claus"
    "Modified: 12.7.1996 / 17:13:45 / cg"
!

reloadAllRememberedObjectFiles
    "reload all object modules as were loaded when the image was saved.
     Some care has to be taken, if files are missing or otherwise corrupted."

    |oldDummyMethod who newHandle
     savedOldClasses functions saveOldMethodsPerClass anyModulesToInitialize m|

    PreviouslyLoadedObjects notNil ifTrue:[
	anyModulesToInitialize := false.

	PreviouslyLoadedObjects do:[:entry |
	    |fileName handle cls sel|

	    fileName := entry key.
	    handle := entry value.
	    handle moduleID:nil.

	    handle isClassLibHandle ifTrue:[
		"/ ('ObjectFileLoader [info]: reloading classes in ' , fileName , ' ...') infoPrintCR.

		"/
		"/ remember all byteCode methods (as added in the session)
		"/
		savedOldClasses := IdentitySet new.
		saveOldMethodsPerClass := IdentityDictionary new.

		handle classes do:[:eachClass |
		    (eachClass notNil and:[eachClass ~~ 0]) ifTrue:[
			saveOldMethodsPerClass at:eachClass put:eachClass methodDictionary copy.
			savedOldClasses add:eachClass.
		    ].
		].
		"/
		"/ load the class binary
		"/
		handle := self loadObjectFile:fileName invokeInitializeMethods:false.
		handle notNil ifTrue:[
		    anyModulesToInitialize := true
		].

		"/ after reloading of the objectFile,
		"/ some of the changes made in the previous life have to be
		"/ redone here - otherwise, we will be left with the
		"/ state contained in the loaded objectModule - instead of
		"/ what we had when saving the image ...


		"/
		"/ re-remove removed methods
		"/ and re-change method categories
		"/
		savedOldClasses do:[:oldClass |
		    |newClass oldMethods newMethodDict newMthd
		     oldCat oldClassVarString oldClassCategory|

		    newClass := Smalltalk classNamed:(oldClass name).
		    newClass notNil ifTrue:[
			oldClassVarString := oldClass classVariableString.
			newClass classVariableString ~= oldClassVarString ifTrue:[
			    "/ there is no need to recreate the variable
			    "/ (its in the smalltalk dictionary)
			    newClass setClassVariableString:oldClassVarString
			].
			newClass isMeta ifFalse:[
			    newClass setSharedPoolNames:(oldClass sharedPoolNames).
			    oldClassCategory := oldClass category.
			    newClass category ~= oldClassCategory ifTrue:[
				newClass setCategory:oldClassCategory
			    ]
			].
			oldMethods := saveOldMethodsPerClass at:oldClass.
			newMethodDict := newClass methodDictionary.
			oldMethods keysAndValuesDo:[:selector :oldMethod|
			    oldMethod
				code:nil;
				mclass:newClass.
			    oldMethod byteCode isNil ifTrue:[
				"a compiled method, load the new code (addresses may have been changed)"
				newMthd := newMethodDict at:selector ifAbsent:nil.
				newMthd notNil ifTrue:[
				     oldMethod code:newMthd code.
				] ifFalse:[
				    ('ObjectFileLoader [warning]: ' , oldClass name , ' missing method: ', selector, '.') errorPrintCR.
				].
			    ].
			].
			newClass setMethodDictionary:oldMethods.
		    ].
		].

		"/
		"/ validate old-classes vs. new classes.
		"/ and if things look ok, get rid of old stuff
		"/ and make instances become instances of the new class
		"/
"/                ('ObjectFileLoader [info]: migrating classes ...') infoPrintCR.

		savedOldClasses do:[:oldClass |
		    |newClass oldCat oldCVars|

		    newClass := Smalltalk classNamed:(oldClass name).
		    newClass == oldClass ifTrue:[
"/                        ('ObjectFileLoader [info]: class ' , oldClass name , ' reloaded.') infoPrintCR.
		    ] ifFalse:[
			(newClass isNil or:[newClass == oldClass]) ifTrue:[
			    ('ObjectFileLoader [warning]: reload of ' , oldClass name , ' seemed to fail.') errorPrintCR.
			] ifFalse:[
"/'oldSize: ' print. oldClass instSize print. ' (' print. oldClass instSize class name print. ') ' print.
"/'newSize: ' print. newClass instSize print. ' (' print. oldClass instSize class name print. ') ' printCR.

			    oldClass instSize ~~ newClass instSize ifTrue:[
				('ObjectFileLoader [warning]: ' , oldClass name , ' has changed its size.') errorPrintCR.
			    ] ifFalse:[
				oldClass class instSize ~~ newClass class instSize ifTrue:[
				    ('ObjectFileLoader [warning]: ' , oldClass name , ' class has changed its size.') errorPrintCR.
				] ifFalse:[
"/                                    ('ObjectFileLoader [info]: migrating ' , oldClass name) infoPrintCR.
				    (oldCat := oldClass category) ~= newClass category ifTrue:[
					newClass setCategory:oldCat.
				    ].
				    (oldCVars := oldClass classVariableString) ~= newClass classVariableString ifTrue:[
					newClass setClassVariableString:oldCVars
				    ].
				    "/ copy over the oldClasses class-instVars
				    (Class instSize + 1) to:(oldClass class instSize) do:[:idx |
					newClass instVarAt:idx put:(oldClass instVarAt:idx)
				    ].
				    oldClass becomeSameAs:newClass
"/                                    oldClass become:newClass
				]
			    ]
			]
		    ]
		]

	    ] ifFalse:[
		handle isMethodHandle ifTrue:[
		    oldDummyMethod := handle method.
		    (oldDummyMethod isMethod) ifFalse:[
			('ObjectFileLoader [info]: ignore obsolete (already collected) method in ' , fileName) infoPrintCR
		    ] ifTrue:[
			('ObjectFileLoader [info]: reloading method in ' , fileName , ' ...') infoPrintCR.
			who := oldDummyMethod who.
			newHandle := self loadMethodObjectFile:fileName.
			newHandle isNil ifTrue:[
			    ('ObjectFileLoader [warning]: failed to reload method in ' , fileName , ' ...') errorPrintCR.
			    handle moduleID:nil.
			] ifFalse:[
			    m := newHandle method.
			    oldDummyMethod sourceFilename notNil ifTrue:[
				m sourceFilename:(oldDummyMethod sourceFilename)
				  position:(oldDummyMethod sourcePosition).
			    ] ifFalse:[
				m source:(oldDummyMethod source).
			    ].
			    m setPackage:(oldDummyMethod package).
			    who notNil ifTrue:[
				cls := who methodClass.
				sel := who methodSelector.
				m == (cls compiledMethodAt:sel) ifFalse:[
				    'ObjectFileLoader [warning]: oops - loaded method installed wrong' errorPrintCR.
				] ifTrue:[
"/                                  cls changed:#methodDictionary with:(Array with:sel with:oldDummyMethod).
				]
			    ].
			]
		    ]
		] ifFalse:[
		    handle isFunctionObjectHandle ifTrue:[
			functions := handle functions.
			functions isEmpty ifTrue:[
			    ('ObjectFileLoader [info]: ignore obsolete (unreferenced) functions in ' , fileName) infoPrintCR
			] ifFalse:[
			    newHandle := self loadDynamicObject:fileName.
			    newHandle isNil ifTrue:[
				('ObjectFileLoader [warning]: failed to reload ' , fileName , ' ...') errorPrintCR.
				handle moduleID:nil.
			    ] ifFalse:[
				('ObjectFileLoader [info]: reloading ' , fileName , ' ...') infoPrintCR.
				functions do:[:eachFunction |  |addr|
				    addr := newHandle getFunctionAddress:(eachFunction name) into:eachFunction.
				    addr isNil ifTrue:[
					('ObjectFileLoader [info]: function: ''' , eachFunction name , ''' no longer present.') errorPrintCR.
					eachFunction invalidate.
				    ] ifFalse:[
					eachFunction setModuleHandle:newHandle.
					('ObjectFileLoader [info]: rebound function: ''' , eachFunction name , '''.') infoPrintCR.
				    ]
				].
				handle becomeSameAs:newHandle.      "/ the old handle is now void
			    ]
			]
		    ] ifFalse:[
			('ObjectFileLoader [info]: ignore invalid (obsolete) objectFile handle: ' , handle printString) infoPrintCR.
		    ]
		]
	    ]
	].
	PreviouslyLoadedObjects := nil.

	"/ now, as we hopefully have all loaded,
	"/ send #reinitializeAfterLoad to each of them
	anyModulesToInitialize ifTrue:[
	    AbortOperationRequest catch:[
		self moduleInit:4 forceOld:false interruptable:true.
	    ]
	]
    ]

    "Modified: / 18-01-2011 / 20:42:57 / cg"
!

rememberAllObjectFiles
    "remember all loaded objectModules in the
     PreviouslyLoadedObjects classVariable.
     Called when an image is restarted to reload all modules which
     were loaded in the previous life"

    LoadedObjects notNil ifTrue:[
	PreviouslyLoadedObjects := OrderedCollection new.
	LoadedObjects keysAndValuesDo:[:name :handle |
	    handle isObsolete ifTrue:[
		('ObjectFileLoader [info]: ignore object for already collected objects in ' , name) infoPrintCR
	    ] ifFalse:[
		PreviouslyLoadedObjects add:(name -> handle)
	    ]
	].
	PreviouslyLoadedObjects sort:[:a :b |
		|h1 h2|

		h1 := a value moduleID.
		h2 := b value moduleID.
		h1 isNil
		    ifTrue:[true]
		    ifFalse:[
			h2 isNil
			    ifTrue:[false]
			    ifFalse:[
				h1 < h2
			    ]
		    ]
	].
    ]

    "Created: 5.12.1995 / 20:51:07 / cg"
    "Modified: 10.1.1997 / 15:06:25 / cg"
!

revalidateAllObjectFiles
    "revalidate code refs into all dynamically loaded object files.
     Required after writing a snapshot image."

    ActuallyLoadedObjects notNil ifTrue:[
	ActuallyLoadedObjects keys do:[:aFileName |
	    |handle|

	    handle := ActuallyLoadedObjects at:aFileName.
	    handle isNil ifTrue:[
		self error:'oops, no handle'.
	    ] ifFalse:[
		(handle isClassLibHandle or:[handle isMethodHandle]) ifTrue:[
		    self revalidateModule:handle
		]
	    ]
	].
	LoadedObjects := ActuallyLoadedObjects.
	ActuallyLoadedObjects := PreviouslyLoadedObjects := nil.
    ].

    "Created: 5.10.1995 / 15:49:08 / claus"
    "Modified: 5.10.1995 / 16:49:18 / claus"
    "Modified: 12.7.1996 / 17:14:48 / cg"
!

unloadAllObjectFiles
    "unload all dynamically loaded object files from the image.
     see DANGER ALERT in ObjectFileLoader>>unloadObjectFile:"

    LoadedObjects notNil ifTrue:[
	LoadedObjects values copy do:[:eachHandle |
	    eachHandle notNil ifTrue:[
		self unloadDynamicObject:eachHandle.
	    ].
	]
    ].

    "
     ObjectFileLoader unloadAllObjectFiles
    "
!

unloadAndRememberAllObjectFiles
    "remember all modules and unload them"

    LoadedObjects notNil ifTrue:[
	self rememberAllObjectFiles.
	self unloadAllObjectFiles
    ]

    "Modified: 25.4.1996 / 09:46:27 / cg"
! !

!ObjectFileLoader class methodsFor:'linking objects'!

createLoadableObjectFor:baseFileName
    "given an oFile, arrange for it to be loadable.
     On ELF systems, this means that it has to be linked with the
     -shared option into a .so file;
     DLD based loaders (linux a.out) can directly load a .o file;
     Other systems may require more ..."

    |osType oFileName soFileName expFileName librunExpFileName
     needSharedObject ld ldArg expFile ok outfile output libDir libDirBasename
     errorMessage homeDir fmt|

    osType := OperatingSystem getOSType.

    osType = #win32 ifTrue:[
        self activityNotification:'generating shared object'.
        ParserFlags linkArgs isNil ifTrue:[
            ld := self linkCommand , ' ' , baseFileName , '.obj'.
            ld := ld
               , ' /NOPACK /NOLOGO /DEBUG /MACHINE:I386 /DLL'
               , ' /OUT:' , baseFileName , '.dll '
"/               , ' /DEF:' , baseFileName , '.def'.
        ] ifFalse:[
"/            libDir := ParserFlags libDirectory.
"/            (libDir notNil and:[libDir asFilename exists]) ifFalse:[
                ParserFlags useBorlandC ifTrue:[
                    libDirBasename := 'lib\bc'
                ] ifFalse:[
                    ParserFlags useVisualC ifTrue:[
                        libDirBasename := 'lib\vc'
                    ] ifFalse:[
                        (ParserFlags useMingw32 or:[ParserFlags useMingw64]) ifTrue:[
                            libDirBasename := 'lib\mingw'
                        ] ifFalse:[
                            libDirBasename := 'lib\vc'
                        ]
                    ]
                ].
                homeDir := Smalltalk packagePath detect:[:p | (p asFilename / 'stx' / libDirBasename) exists] ifNone:nil.
                homeDir notNil ifTrue:[
                    libDir := (homeDir asFilename / 'stx' / libDirBasename) pathName
                ].
                libDir isNil ifTrue:[
                    "/ some fallback
                    libDir := #( '..'
                                 '..\..'
                                 '..\..\..'
                                 '..\..\stx'
                                 '..\..\..\stx'
                               ) detect:[:p | (p asFilename / libDirBasename) exists] ifNone:nil.

                    libDir isNil ifTrue:[
                        LastError := errorMessage := 'could not locate directory where .lib files are (',libDirBasename,')'.
                        ObjectFileLoadError raiseRequestErrorString:errorMessage.
                        ^ nil
                    ].
                ].
"/            ].

            ParserFlags useBorlandC ifTrue:[
                ld := self linkCommand , ' ' , (ParserFlags linkArgs bindWith:baseFileName).
                ld := ld , ' c0d32.obj ' , baseFileName , '.obj '.
                ld := ld , ',' , baseFileName , '.dll,,',libDir,'\librun.lib '.
                ld := ld , (ParserFlags searchedLibraries asStringCollection asStringWith: $ ).
                ld := ld , ' ',libDir,'\cs32i.lib,,'.
            ] ifFalse:[
                ParserFlags useVisualC ifTrue:[
                    "/ todo: fix for correct link libs
                    ld := self linkCommand , ' ' , (ParserFlags linkArgs bindWith:baseFileName).
                    ld := ld , ' c0d32.obj ' , baseFileName , '.obj '.
                    ld := ld , ',' , baseFileName , '.dll,,',libDir,'\librun.lib '.
                    ld := ld , (ParserFlags searchedLibraries asStringCollection asStringWith: $ ).
                    ld := ld , ' ',libDir,'\cs32i.lib,,'.
                ] ifFalse:[
                    (ParserFlags useMingw64 or:[ParserFlags useMingw32]) ifTrue:[
                        ld := self linkCommand , ' ' , (ParserFlags linkArgs bindWith:baseFileName).
                        ld := ld , ' -shared -o ',baseFileName,'.dll '.
                        ld := ld , baseFileName,'.obj '.
                        ld := ld , libDir,'\librun.lib '.
                        ld := ld , (ParserFlags searchedLibraries asStringCollection asStringWith: $ ).
                    ] ifFalse:[
                        ObjectFileLoadError raiseRequestErrorString:'for dynamic objects, only borlandC is (currently) supported'.
                        LastError := 'for dynamic objects, only borlandC is (currently) supported'.
                        ^ nil
                    ]
                ]
            ]
        ].

        outfile := (baseFileName , '.out').
        (Verbose or:[ STCCompilerInterface verbose ]) ifTrue:[
            Transcript showCR:('executing: ',ld).
        ].

        ok := OperatingSystem executeCommand:(ld , ' >' , outfile, ' 2>&1') showWindow:false.
        ok ifFalse:[
            output := (baseFileName , '.out') asFilename contentsOfEntireFile.
            Transcript showCR:'********************'.
            Transcript showCR:'Failed linkCommand:'.
            Transcript showCR:ld.
            Transcript showCR:'ParserFlags are:'.
            Transcript showCR:ParserFlags.
            Transcript showCR:'--------------------'.
            Transcript showCR:output; endEntry.
            Transcript showCR:'********************'.
        ].

        #('.obj' '.out' '.tds' '.ilc' '.ild'
          '.ilf' '.ils' '.lib' '.map' '.def' '.o') do:[:eachSuffix|
            (baseFileName , eachSuffix) asFilename remove.
        ].

        ok ifFalse:[
            LastError := output.
            "/ ObjectFileLoadError raiseRequestErrorString:'link failed'.
            ^ nil
        ].
        oFileName := (baseFileName , self sharedLibraryExtension) asFilename name.
        ^ oFileName
    ].

    "/ UNIX systems

    ld := self linkCommand ? 'ld'.
    needSharedObject := false.

    fmt := self loadableBinaryObjectFormat.
    (fmt == #elf
    or:[ fmt == #macho ]) ifTrue:[
        "
         link it to a shared object with 'ld -shared'
        "
        needSharedObject := true.
        ld := self linkCommand ? 'cc'.
        ldArg := self linkSharedArgs.
        ldArg isNil ifTrue:[
            "/ some default
            ExternalAddress pointerSize == 4 ifTrue:[
                ldArg := '-m32 -shared'.
            ] ifFalse:[
                ldArg := '--shared'.
            ]
        ]
    ].

    osType = #irix ifTrue:[
        "
         link it to a shared object with 'ld -shared'
        "
        needSharedObject := true.
        ldArg := self linkSharedArgs ? '-shared'.
    ].

    osType = #'sys5_4' ifTrue:[
        "
         link it to a shared object with 'ld -G'
        "
        needSharedObject := true.
        ldArg := self linkSharedArgs ? '-G'.
    ].

    osType = #solaris ifTrue:[
        "
         link it to a shared object with 'ld -G -B dynamic'
        "
        needSharedObject := true.
        ldArg := self linkSharedArgs ? '-G -Bdynamic'.
    ].

    osType = #hpux ifTrue:[
        "
         link it to a shared object with 'ld -b -B immediate'
        "
        needSharedObject := true.
        ldArg := self linkSharedArgs ? '-b -B immediate'.
    ].

    osType = #aix ifTrue:[
        self activityNotification:'create export file'.

        "/ create an exports file.
        expFileName := './' , baseFileName , '.exp'.
        [
            expFile := expFileName asFilename writeStream.
            expFile nextPutAll:'#!! ./' , baseFileName , (self sharedLibraryExtension).
            expFile cr.
            expFile nextPutAll:'_' , baseFileName , '_Init'.
            expFile close.
        ] on:FileStream openErrorSignal do:[:ex| "do nothing"].

        self activityNotification:'generating shared object'.

        "
         link it to a shared object with 'cc -bI:...librun.exp -bE -bMSRE'
        "
        needSharedObject := true.
        ld := 'cc'.
        librunExpFileName := Smalltalk getSystemFileName:'lib/librun_aix.exp'.
        librunExpFileName isNil ifTrue:[
            LastError := 'missing exports file: ''lib/librun_aix.exp'' - cannot link'.
            ^ nil
        ].

        ldArg := '-bI:' , librunExpFileName ,
                ' -bE:' , baseFileName , '.exp' ,
                ' -bM:SRE -e _' , baseFileName , '_Init'.
    ].

    oFileName := baseFileName , self objectFileExtension.
    needSharedObject ifTrue:[
        self activityNotification:'generating shared object'.

        soFileName := baseFileName , self sharedLibraryExtension.
        OperatingSystem removeFile:soFileName.
        ld := ld , ' ' , ldArg , ' ', (ParserFlags linkArgs ? '') ,
                 ' -o ' , soFileName , ' ' , oFileName , ' ',
                 ((ParserFlags searchedLibraries  ? #()) asStringCollection asStringWith: $ ).

        (Verbose or:[ STCCompilerInterface verbose ]) ifTrue:[
            Transcript showCR:('linking with: ',ld).
        ].
        ok := OperatingSystem executeCommand:(ld , ' >errorOutput 2>&1').

        ok ifFalse:[
            output := 'errorOutput' asFilename contentsOfEntireFile.
            Transcript showCR:'********************'.
            Transcript showCR:'linker command:'.
            Transcript showCR:ld; endEntry.
            Transcript showCR:'--------------------'.
            Transcript showCR:'linker error message:'.
            Transcript showCR:output.
            Transcript showCR:'********************'.
        ].

        OperatingSystem removeFile:oFileName.
        expFileName notNil ifTrue:[
            OperatingSystem removeFile:expFileName
        ].
        ^ soFileName.
    ].

    "
     assume we can load an ordinary binary
    "
    ^ oFileName

    "Modified: / 29-07-2004 / 17:29:44 / stefan"
    "Modified: / 25-02-2017 / 09:18:42 / cg"
! !

!ObjectFileLoader class methodsFor:'lowlevel object loading'!

initializeLoader
    "initialize dynamic loader if required"

    |stxName stxPathName|

    stxPathName := OperatingSystem pathOfSTXExecutable.
%{
#ifdef GNU_DL
  {
    static alreadyInitialized = 0;
    extern dld_ignore_redefinitions;

    if (! alreadyInitialized) {
	alreadyInitialized = 1;

	if (@global(Verbose) == true) {
	    console_printf ("dld_init(%s)\n", __stringVal(stxPathName));
	}
	/*
	 * dld requires the running executables name,
	 * to resolve symbols.
	 */
	(void) dld_init (__stringVal(stxPathName));
	dld_ignore_redefinitions = 1;
    }
  }
#endif
%}.
!

loadDynamicObject:pathNameOrFilename
    "load an object-file (load/map into my address space).
     Return a non-nil handle if ok, nil otherwise.
     No bindings or automatic initializations are done
     - only a pure (low-level) load is performed.
     For class-files or C-objects to be loaded with this method,
     it is your responsibility to fetch any init-functions and
     call them as appropriate.
     This function is not supported on all architectures.

     The `pathNameOrFilename may be nil, then resulting
     handle is for the main program itself.
    "

    |fn handle buffer pathName tempFile encodedPathName|

    pathNameOrFilename notNil ifTrue:[
        fn := pathNameOrFilename asFilename.
        fn exists ifTrue:[
            pathName := fn pathName.
            self copyLibrariesWhenLoading ifTrue:[
                fn copyTo:(tempFile := ParserFlags stcModulePath asFilename construct:fn baseName).
                pathName := tempFile pathName.
            ].
        ] ifFalse:[
            "/ something like "kernel32.dll"; must be along the PATH setting
            pathName := pathNameOrFilename asString.
        ].
    ].

    Verbose ifTrue:[
	('loadDynamic: ',pathNameOrFilename asString,' (',pathName asString,')...') errorPrintCR
    ].
    encodedPathName := OperatingSystem encodePath:pathName.

    "/ already loaded ?
    handle := self handleForDynamicObject:encodedPathName.
    handle notNil ifTrue:[
	Verbose ifTrue:[
            ('... ' , pathName asString , ' already loaded.') errorPrintCR.
	].
	^ handle
    ].

    Verbose ifTrue:[
	('initializeLoader...') errorPrintCR
    ].
    self initializeLoader.

    "/
    "/ the 1st two entries are system dependent;
    "/ entry 3 is the pathName
    "/ entry 4 is a unique ID
    "/
    buffer := Array new:4.
    buffer at:3 put:pathName.
    buffer at:4 put:NextHandleID. NextHandleID := NextHandleID + 1.

    Verbose ifTrue:[
	('primLoadDynamicObject...') errorPrintCR
    ].

    buffer := self primLoadDynamicObject:encodedPathName into:buffer.
    Verbose ifTrue:[
	('done') errorPrintCR
    ].

    buffer isNil ifTrue:[
	LastError == #notImplemented ifTrue:[
	    'ObjectFileLoader [warning]: no dynamic load facility present.' infoPrintCR.
	] ifFalse:[
	    LastError == #linkError ifTrue:[
		LinkErrorMessage notNil ifTrue:[
		    ('ObjectFileLoader [warning]: load error:' , LinkErrorMessage) infoPrintCR.
		] ifFalse:[
		    ('ObjectFileLoader [warning]: load error') infoPrintCR.
		].
	    ].
	].
        Logger warning: 'failed to load ''%1''' with: pathName.
	^ nil
    ].

    "
     remember loaded object for later unloading
    "
    handle := ObjectFileHandle new.
    handle sysHandle1:(buffer at:1).
    handle sysHandle2:(buffer at:2).
    handle pathName:(buffer at:3).
    handle moduleID:(buffer at:4).

    LoadedObjects isNil ifTrue:[
	LoadedObjects := Dictionary new.
    ].
    LoadedObjects at:pathName put:handle.
    "/ Smalltalk flushCachedClasses.

    Verbose ifTrue:[
	('loadDynamic ok; handle is: ' , handle printString) errorPrintCR.
    ].
    "/ ObjectMemory garbageCollect.

    ^ handle

    "sys5.4:
     |handle|
     handle := ObjectFileLoader loadDynamicObject:'../stc/mod1.so'.
     ObjectFileLoader getFunction:'module1' from:handle
    "
    "next:
     |handle|
     handle := ObjectFileLoader loadDynamicObject:'../goodies/Path/AbstrPath.o'.
     ObjectFileLoader getFunction:'__AbstractPath_Init' from:handle
    "
    "GLD:
     |handle|
     handle := ObjectFileLoader loadDynamicObject:'../clients/Tetris/Tetris.o'.
     ObjectFileLoader getFunction:'__TetrisBlock_Init' from:handle
    "

    "Modified: / 06-12-2011 / 15:42:16 / cg"
    "Modified: / 06-09-2016 / 17:24:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

loadModulesFromListOfUndefined:list
    "try to figure out what has to be loaded to resolve symbols from list.
     return a list of handles of loaded objects
    "
    |inits classNames|

    inits := list select:[:symbol | symbol notNil and:[symbol endsWith:'_Init']].
    inits notNil ifTrue:[
	classNames := inits collect:[:symbol |
	    (symbol startsWith:'___') ifTrue:[
		symbol copyFrom:4 to:(symbol size - 5)
	    ] ifFalse:[
		(symbol startsWith:'__') ifTrue:[
		    symbol copyFrom:3 to:(symbol size - 5)
		] ifFalse:[
		    (symbol startsWith:'_') ifTrue:[
			symbol copyFrom:2 to:(symbol size - 5)
		    ] ifFalse:[
			symbol
		    ]
		]
	    ]
	].
	"
	 autoload those classes
	"
	classNames do:[:aClassName |
	    |cls|

	    (cls := Smalltalk classNamed:aClassName) notNil ifTrue:[
		'ObjectFileLoader [info]: autoloading ' infoPrint. aClassName infoPrintCR.
		cls autoload
	    ]
	]
    ].
    ^ nil

    "Modified: 10.1.1997 / 17:58:23 / cg"
!

primLoadDynamicObject:pathName into:anInfoBuffer
    "Load an object-file (map into my address space).
     Return an OS-handle (whatever that is) - where some space
     (a 3-element array) has to be passed in for this.
     The first two entries are used in a machine dependent way,
     and callers may not depend on what is found there
     (instead, only pass around handles transparently).
     This function is not supported on all architectures.

     `pathName` is a path to the object file. If nil, 
     a special handle capable to resolve symbols in
     'currenty loaded image' ir returned. 
    "

%{  /* CALLSUNLIMITEDSTACK(noWIN32) */

    if (! __isArray(anInfoBuffer)
     || (__arraySize(anInfoBuffer) < 3)) {
	RETURN(nil);
    }

#ifdef GNU_DL
  {
    if (__isStringLike(pathName)) {
	if (dld_link(__stringVal(pathName))) {
	    if (@global(Verbose) == true) {
		console_printf ("link file %s failed\n", __stringVal(pathName));
	    }
	    if (@global(ErrorPrinting) == true) {
		dld_perror("ObjectFileLoader - DLD error cant link");
	    }
	    @global(LastError) = @symbol(linkError);
	    @global(LinkErrorMessage) = __MKSTRING("DLD error");
	    RETURN ( nil );
	}
	__ArrayInstPtr(anInfoBuffer)->a_element[0] = pathName;
	__STORE(anInfoBuffer, pathName);
	RETURN ( anInfoBuffer );
    }
    RETURN ( nil );
  }
#endif

#ifdef WIN_DL
  {
    HINSTANCE handle;
    int err;

    if (__isStringLike(pathName)) {
	if (@global(Verbose) == true) {
	    console_fprintf(stderr, "ObjectFileLoader [info]: loading dll: %s...\n", __stringVal(pathName));
	    console_fflush(stderr);
	}
	//
	// LOAD_WITH_ALTERED_SEARCH_PATH causes follow-up dlls to be looked up also
	// in the directory of the loaded library, if an absolute path to
	// the library has been provided.
	// Note: this does not work for redirected library symbols, since they are
	//       resolved ad symbol lookup time and not at library load time
	//
	handle = LoadLibraryEx(__stringVal(pathName), NULL, LOAD_WITH_ALTERED_SEARCH_PATH);
	if (@global(Verbose) == true) {
	    console_fprintf(stderr, "ObjectFileLoader [info]: handle: %"_lx_"\n", (INT)handle);
	    console_fflush(stderr);
	}
	if (handle == NULL) {
	    char *msg;

	    err = GetLastError();
	    if ((@global(ErrorPrinting) == true)
	     || (@global(Verbose) == true)) {
		console_fprintf (stderr,
				 "ObjectFileLoader [warning]: LoadLibrary %s failed; error: %x\n",
				 __stringVal(pathName), err);
	    }
	    @global(LastError) = @symbol(loadError);;
	    @global(LastErrorNumber) = __MKINT(__WIN32_ERR(err));
	    switch (err) {
		case ERROR_BAD_FORMAT:
		    msg = "LoadLibrary error - bad format";
		default:
		    msg = "LoadLibrary error";
		    break;
	    }
	    @global(LinkErrorMessage) = __MKSTRING(msg);
	    RETURN ( nil );
	}
# if __POINTER_SIZE__ == 8
	__ArrayInstPtr(anInfoBuffer)->a_element[0] = __MKSMALLINT( (INT)handle & 0xFFFFFFFFL );
	__ArrayInstPtr(anInfoBuffer)->a_element[1] = __MKSMALLINT( ((INT)handle >> 32) & 0xFFFFFFFFL );
# else
	__ArrayInstPtr(anInfoBuffer)->a_element[0] = __MKSMALLINT( (INT)handle & 0xFFFF );
	__ArrayInstPtr(anInfoBuffer)->a_element[1] = __MKSMALLINT( ((INT)handle >> 16) & 0xFFFF );
# endif
	RETURN ( anInfoBuffer );
    }
    /*
     * Unlike POSIX.1-2001 dlopen(), Windows has no such handle that
     * would, when passed to GetProcAddress(), search current loaded image
     * (i.e., all loaded .dlls and .exes). This has to be done by enumerating
     * all loaded modules (HMODULE) and searching there. 
     *
     * Hence here we return a special 0 handle. This 0-handle is detected in
     * #getSymbol:function:from: and handled there.
     */
    if (pathName == nil) {
	__ArrayInstPtr(anInfoBuffer)->a_element[0] = __MKSMALLINT( 0 );
	__ArrayInstPtr(anInfoBuffer)->a_element[1] = __MKSMALLINT( 0 );
	RETURN ( anInfoBuffer );
    }
    RETURN ( nil );
  }
#endif

#ifdef BEOS_DL
  {
    void *handle;
    int err;

    if (__isStringLike(pathName)) {
	if (@global(Verbose) == true) {
	    console_fprintf(stderr, "ObjectFileLoader [info]: loading : %s...\n", __stringVal(pathName));
	    console_fflush(stderr);
	}
	handle = load_add_on(__stringVal(pathName));
	if (@global(Verbose) == true) {
	    console_fprintf(stderr, "ObjectFileLoader [info]: handle: %x\n", handle);
	    console_fflush(stderr);
	}
	if (handle == NULL) {
	    char *msg;

	    @global(LastError) = @symbol(linkError);
	    @global(LinkErrorMessage) = __MKSTRING("unknown error");
	    RETURN ( nil );
	}
# if __POINTER_SIZE__ == 8
	__ArrayInstPtr(anInfoBuffer)->a_element[0] = __MKSMALLINT( (INT)handle & 0xFFFFFFFF );
	__ArrayInstPtr(anInfoBuffer)->a_element[1] = __MKSMALLINT( ((INT)handle >> 32) & 0xFFFFFFFF );
# else
	__ArrayInstPtr(anInfoBuffer)->a_element[0] = __MKSMALLINT( (INT)handle & 0xFFFF );
	__ArrayInstPtr(anInfoBuffer)->a_element[1] = __MKSMALLINT( ((INT)handle >> 16) & 0xFFFF );
	RETURN ( anInfoBuffer );
# endif
    }
    RETURN ( nil );
  }
#endif

#ifdef DL1_6
  {
    extern char *__myName__;
    char *ldname;
    OBJ tmpName;

    if (__isStringLike(pathName)) {
	if ( dl_loadmod_only(__myName__, __stringVal(pathName), &ldname) == 0 ) {
	    if (@global(Verbose) == true) {
		console_printf ("link file %s failed\n", __stringVal(pathName));
	    }
	    @global(LinkErrorMessage) = __MKSTRING("dl_load error");
	    RETURN ( nil );
	}
	/*
	 * returns the name of the temporary ld-file
	 * use that as handle ...
	 */
	tmpName = __MKSTRING(ldname);
	__ArrayInstPtr(anInfoBuffer)->a_element[0] = tmpName;
	__STORE(anInfoBuffer, tmpName);
	RETURN ( anInfoBuffer );
    }
    RETURN ( nil );
  }
#endif

#ifdef AIX_DL
  {
    char *objName, *libPath;
    int *handle;
    extern errno;

    if (__isStringLike(pathName)) {
	objName = __stringVal(pathName);

	if (__isStringLike(@global(LibPath))) {
	    libPath = __stringVal(@global(LibPath));
	} else {
	    libPath = (char *)0;
	}
	if ( (handle = (int *) load(objName, 0, libPath)) == 0 ) {
	    if (@global(Verbose) == true) {
		char *messages[64];
		int i;

		console_fprintf (stderr,
			 "ObjectFileLoader [info]: load file %s failed errno=%d\n",
			 objName, errno);

		switch (errno) {
		    case ENOEXEC:
			console_fprintf(stderr, "   load messages:\n");
			loadquery(L_GETMESSAGES, messages, sizeof(messages));
			for (i=0; messages[i]; i++) {
			    console_fprintf(stderr, "      %s\n", messages[i]);
			}
			break;
		}
	    } else {
		if (@global(ErrorPrinting) == true) {
		    console_fprintf (stderr,
			     "ObjectFileLoader [warning]: load file %s failed errno=%d\n",
			     objName, errno);
		}
	    }
	    @global(LinkErrorMessage) = __MKSTRING("load error");
	    RETURN ( nil );
	}
	if (@global(Verbose) == true) {
	    console_fprintf(stderr, "ObjectFIleLoader [info]: load %s handle = %x\n", objName, handle);
	}

# if __POINTER_SIZE__ == 8
	__ArrayInstPtr(anInfoBuffer)->a_element[0] = __MKSMALLINT( (INT)handle & 0xFFFFFFFF );
	__ArrayInstPtr(anInfoBuffer)->a_element[1] = __MKSMALLINT( ((INT)handle >> 32) & 0xFFFFFFFF );
# else
	__ArrayInstPtr(anInfoBuffer)->a_element[0] = __MKSMALLINT( (INT)handle & 0xFFFF );
	__ArrayInstPtr(anInfoBuffer)->a_element[1] = __MKSMALLINT( ((INT)handle >> 16) & 0xFFFF );
# endif
	RETURN (anInfoBuffer);
    }
    RETURN ( nil );
  }
#endif


#ifdef SYSV4_DL
  {
    void *handle;
    char *nm;
    char *errMsg;

    if ((pathName == nil) || __isStringLike(pathName)) {
	INT lowHandle, hiHandle;

	handle = (void *)dlopen(pathName == nil ? 0 : __stringVal(pathName), RTLD_NOW);

	if (! handle) {
	    errMsg = (char *) dlerror();
	    if (@global(ErrorPrinting) == true) {
                console_fprintf(stderr, "ObjectFileLoader [warning]: dlopen %s error:\n", pathName == nil ? "(nil)" : __stringVal(pathName));
		console_fprintf(stderr, "    <%s>\n", errMsg);
	    }
	    @global(LastError) = @symbol(linkError);
	    @global(LinkErrorMessage) = __MKSTRING(errMsg);
	    RETURN (nil);
	}

	if (@global(Verbose) == true) {
            console_fprintf(stderr, "ObjectFileLoader [info]: open %s handle = %"_lx_"\n",  pathName == nil ? "(nil)" : __stringVal(pathName), (INT)handle);
	}

#if __POINTER_SIZE__ == 8
	lowHandle = (INT)handle & 0xFFFFFFFFL;
	hiHandle = ((INT)handle >> 32) & 0xFFFFFFFFL;
#else
	lowHandle = (INT)handle & 0xFFFF;
	hiHandle = ((INT)handle >> 16) & 0xFFFF;
#endif
	__ArrayInstPtr(anInfoBuffer)->a_element[0] = __MKSMALLINT(lowHandle);
	__ArrayInstPtr(anInfoBuffer)->a_element[1] = __MKSMALLINT(hiHandle);
	RETURN (anInfoBuffer);
    }
  }
#endif


#ifdef HPUX10_DL
  {
    void *handle;
    char *nm;
    char *errMsg;

    if (__isStringLike(pathName)) {
	handle = (void *)shl_load(__stringVal(pathName),
				  BIND_IMMEDIATE, 0L /* address */);

	if (! handle) {
	    if (@global(ErrorPrinting) == true) {
		console_fprintf(stderr, "shl_load %s error:\n", __stringVal(pathName));
	    }
	    @global(LastError) = @symbol(linkError);
	    switch (errno) {
		case ENOEXEC:
		    errMsg = "not a shared library";
		    break;
		case ENOSYM:
		    errMsg = "undefined symbols";
		    break;
		case ENOMEM:
		    errMsg = "out of memory";
		    break;
		case ENOENT:
		    errMsg = "non existing library";
		    break;
		case EACCES:
		    errMsg = "permission denied";
		    break;
		default:
		    errMsg = "unspecified error";
		    break;
	    }
	    @global(LinkErrorMessage) = __MKSTRING(errMsg);
	    RETURN (nil);
	}

	if (@global(Verbose) == true) {
	    console_printf("open %s handle = %"_lx_"\n", __stringVal(pathName), (INT)handle);
	}

# if __POINTER_SIZE__ == 8
	__ArrayInstPtr(anInfoBuffer)->a_element[0] = __MKSMALLINT( (INT)handle & 0xFFFFFFFF );
	__ArrayInstPtr(anInfoBuffer)->a_element[1] = __MKSMALLINT( ((INT)handle >> 32) & 0xFFFFFFFF );
# else
	__ArrayInstPtr(anInfoBuffer)->a_element[0] = __MKSMALLINT( (INT)handle & 0xFFFF);
	__ArrayInstPtr(anInfoBuffer)->a_element[1] = __MKSMALLINT( ((INT)handle >> 16) & 0xFFFF );
	RETURN (anInfoBuffer);
# endif
    }
  }
#endif


#ifdef SUN_DL
  {
    void *handle;

    if ((pathName == nil) || __isStringLike(pathName)) {
	if (pathName == nil)
	    handle = dlopen((char *)0, 1);
	else
	    handle = dlopen(__stringVal(pathName), 1);

	if (! handle) {
	    if (@global(ErrorPrinting) == true) {
		console_fprintf(stderr, "dlopen %s error: <%s>\n",
				__stringVal(pathName), dlerror());
	    }
	    @global(LastError) = @symbol(linkError);
	    @global(LinkErrorMessage) = __MKSTRING("dlopen error");
	    RETURN (nil);
	}

	if (@global(Verbose) == true) {
	    console_printf("open %s handle = %"_lx_"\n", __stringVal(pathName), (INT)handle);
	}

	__ArrayInstPtr(anInfoBuffer)->a_element[0] = __MKSMALLINT( (int)handle & 0xFFFF );
	__ArrayInstPtr(anInfoBuffer)->a_element[1] = __MKSMALLINT( ((int)handle >> 16) & 0xFFFF );
	RETURN (anInfoBuffer);
    }
  }
#endif

#ifdef NEXT_DL
  {
    long result;
    char *files[2];
    NXStream *errOut;

    if (__isStringLike(pathName)) {
	files[0] = (char *) __stringVal(pathName);
	files[1] = (char *) 0;
	errOut = NXOpenFile(2, 2);
	result = rld_load(errOut,
			  (struct mach_header **)0,
			  files,
			  (char *)0);
	NXClose(errOut);
	if (! result) {
	    @global(LinkErrorMessage) = __MKSTRING("rld_load error");
	    @global(LastError) = @symbol(linkError);
	    if (@global(ErrorPrinting) == true) {
		console_fprintf(stderr, "rld_load %s failed\n", __stringVal(pathName));
	    }
	    RETURN (nil);
	}

	if (@global(Verbose) == true)
	    console_printf("rld_load %s ok\n", __stringVal(pathName));

	__ArrayInstPtr(anInfoBuffer)->a_element[0] = pathName;
	__STORE(anInfoBuffer, pathName);
	RETURN ( anInfoBuffer );
    }
  }
#endif
%}.
    LastError := #notImplemented.
    ^ nil

    "Modified: / 24-01-2016 / 22:06:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

primUnloadDynamicObject:aHandle
    "unload an object-file (unmap from my address space).
     This is a low-level entry, which does not care if there are
     still any code references (from blocks or methods) to this
     module. Calling it for still living classes will definitely
     lead to some fatal conditions to occur later."

    |sysHandle1 sysHandle2|

    sysHandle1 := aHandle sysHandle1.
    sysHandle2 := aHandle sysHandle2.

%{ /* CALLSUNLIMITEDSTACK(noWIN32) */
#ifdef GNU_DL
    if (__isStringLike(sysHandle1)) {
	if (dld_unlink_by_file(__stringVal(sysHandle1), 1)) {
	    if (@global(Verbose) == true) {
		console_printf ("unlink file %s failed\n", __stringVal(sysHandle1));
		dld_perror("cant unlink");
	    }
	    RETURN (false);
	}
	RETURN (true);
    }
    RETURN (false);
#endif

#ifdef WIN_DL
    INT val;
    HINSTANCE handle;
    int err;
    jmp_buf exitJmpBuf;

    if (__bothSmallInteger(sysHandle1, sysHandle2)) {
# if __POINTER_SIZE__ == 8
	val = (_intVal(sysHandle2) << 32) + _intVal(sysHandle1);
# else
	val = (_intVal(sysHandle2) << 16) + _intVal(sysHandle1);
# endif
	handle = (HINSTANCE)(val);

	if (setjmp(exitJmpBuf)) {
	    __setAtExitLongJmp(exitJmpBuf);
	    if (@global(Verbose) == true) {
		console_fprintf (stderr,
				 "ObjectFileLoader [info]: FreeLibrary %s handle: %"_lx_"\n",
				 __stringVal(sysHandle1), (INT)handle);
	    }
	    if (FreeLibrary(handle) != TRUE) {
	       __setAtExitLongJmp(0);
		err = GetLastError();
		if (@global(Verbose) == true) {
		    console_fprintf (stderr,
				     "ObjectFileLoader [warning]: FreeLibrary %s failed; error: %x\n",
				     __stringVal(sysHandle1), err);
		}
		@global(LastErrorNumber) = __MKINT(__WIN32_ERR(err));
		RETURN (false);
	    }
       } else {
	   __setAtExitLongJmp(0);
	   console_fprintf(stderr, "ObjectFileLoader [warning]: FreeLibrary called exit() - ignored\n");
       }
	RETURN (true);
    }
    RETURN (false);
#endif

#ifdef BEOS_DL
    int val;
    void *handle;
    int ok, err;
    jmp_buf exitJmpBuf;

    if (__bothSmallInteger(sysHandle1, sysHandle2)) {
	val = (_intVal(sysHandle2) << 16) + _intVal(sysHandle1);
	handle = (HINSTANCE)(val);

	if (setjmp(exitJmpBuf)) {
	    __setAtExitLongJmp(exitJmpBuf);
	    ok = unload_add_on((image_id) handle);
	    __setAtExitLongJmp(0);
	    if (ok != 0) {
		@global(LastErrorNumber) = __MKSMALLINT(ok);
		RETURN (false);
	    }
	} else {
	    __setAtExitLongJmp(0);
	    console_fprintf(stderr, "ObjectFileLoader [warning]: FreeLibrary called exit() - ignored\n");
	}
	RETURN (true);
    }
    RETURN (false);
#endif

#ifdef SYSV4_DL
  {
    void *h;
    INT val;
    OBJ low = sysHandle1, hi = sysHandle2;

    if (__bothSmallInteger(low, hi)) {
#if __POINTER_SIZE__ == 8
	val = (__intVal(hi) << 32) + __intVal(low);
#else
	val = (_intVal(hi) << 16) + _intVal(low);
#endif
	h = (void *)(val);
	if (@global(Verbose) == true)
	    console_printf("close handle = %"_lx_"\n", (INT)h);
	if (dlclose(h) != 0) {
	    console_fprintf(stderr, "dlclose failed with:<%s>\n", dlerror());
	    RETURN (false);
	}
	RETURN (true);
    }
  }
#endif

#ifdef SUN_DL
  {
    void *h;
    int val;
    OBJ low = sysHandle1, hi = sysHandle2;

    if (__bothSmallInteger(low, hi)) {
	val = (_intVal(hi) << 16) + _intVal(low);
	h = (void *)(val);
	if (@global(Verbose) == true) {
	    console_printf("close handle = %x\n", h);
	}
	dlclose(h);
	RETURN (true);
    }
  }
#endif

#ifdef HPUX10_DL
  {
    int *h;
    int val;
    OBJ low = sysHandle1, hi = sysHandle2;

    if (__bothSmallInteger(low, hi)) {
	val = (_intVal(hi) << 16) + _intVal(low);
	h = (void *)(val);
	if (@global(Verbose) == true) {
	    console_printf("unload handle = %x\n", h);
	}
	shl_unload(h);
	RETURN (true);
    }
  }
#endif

#ifdef AIX_DL
  {
    int *h;
    int val;
    OBJ low = sysHandle1, hi = sysHandle2;

    if (__bothSmallInteger(low, hi)) {
	val = (_intVal(hi) << 16) + _intVal(low);
	h = (int *)(val);
	if (@global(Verbose) == true) {
	    console_printf("unload handle = %x\n", h);
	}
	if ( unload(h) != 0) {
	    console_fprintf(stderr, "unload failed\n");
	    RETURN (false);
	}
	RETURN (true);
    }
  }
#endif

#ifdef NEXT_DL
  {
    console_fprintf(stderr, "ObjectFileLoader [warning]: Sorry, NeXTStep does not support selective unloading\n");
  }
#endif
%}.
    ^ false
!

unloadDynamicObject:handle
    "close an object-file (unmap from my address space)
     and remove the entry from the remembered object file set.
     This is a low-level entry, which does not care if there are
     still any code references (from blocks or methods) to this
     module. Calling it for still living classes will definitely
     lead to some fatal conditions to occur later."

    |key fileName functionName deInitAddr m|

    Verbose ifTrue:[
	'unload module name=' errorPrint. handle pathName errorPrintCR.
    ].

    handle isUnknownHandle ifTrue:[
	Verbose ifTrue:[
	    'module type is not known - assume uninitialized classLib' errorPrintCR.
	].
	self unregisterModule:handle.
	handle makeClassLibHandle.
    ] ifFalse:[
	handle isClassLibHandle ifTrue:[
	    Verbose ifTrue:[
		'a classLib - deinit classes' errorPrintCR.
	    ].
	    self deinitializeClassesFromModule:handle.
	    Verbose ifTrue:[
		'unregister' errorPrintCR.
	    ].
	    self unregisterModule:handle.
	] ifFalse:[
	    handle isMethodHandle ifTrue:[
		Verbose ifTrue:[
		    'a methodHandle - unregister' errorPrintCR.
		].
		self unregisterModule:handle.
	    ] ifFalse:[
		handle isFunctionObjectHandle ifTrue:[
		    Verbose ifTrue:[
			'a functionObject - fixup functionRefs' errorPrintCR.
		    ].
		    handle functions do:[:f |
				    f notNil ifTrue:[
					f invalidate
				    ]
				].
		].

		"/
		"/ call its deInit function (if present)
		"/
		Verbose ifTrue:[
		    'search for deInit function...' errorPrintCR.
		].
		fileName := handle pathName asFilename baseName.
		functionName := self initFunctionBasenameForFile:fileName.

		deInitAddr := self findFunction:functionName suffix:'__deInit' in:handle.
		deInitAddr notNil ifTrue:[
		    Verbose ifTrue:[
			'invoke deInit function...' errorPrintCR.
		    ].
		    self
			saveCallInitFunctionAt:deInitAddr
			in:fileName
			specialInit:false
			forceOld:true
			interruptable:false
			argument:0
			identifyAs:handle
			returnsObject:false.
		]
	    ]
	].
    ].

    Verbose ifTrue:[
	'cleanup done - now unload...' errorPrintCR.
    ].

    "/
    "/ now, really unload
    "/
    (self primUnloadDynamicObject:handle) ifFalse:[
	^ self error:'unloadDynamic failed' mayProceed:true
    ].

    Verbose ifTrue:[
	'unload done ...' errorPrintCR.
    ].

    "/
    "/ remove from loaded objects
    "/
    LoadedObjects notNil ifTrue:[
	key := LoadedObjects keyAtEqualValue:handle.
	key notNil ifTrue:[
	    LoadedObjects removeKey:key
	]
    ].

    "
     for individual methods, we keep the methodObject,
     but make it unexecutable. Its still visible in the browser.
    "
    handle isMethodHandle ifTrue:[
	((m := handle method) notNil
	and:[m ~~ 0]) ifTrue:[
	    m makeUnloaded.
	]
    ].

    handle isClassLibHandle ifTrue:[
	Smalltalk flushCachedClasses.
	Class flushSubclassInfo.
    ].
    handle isMethodHandle ifTrue:[
	ObjectMemory flushCaches.
    ].

    handle moduleID:nil.
    handle sysHandle1:nil.
    handle sysHandle2:nil.

    "Modified: / 15-11-2010 / 13:20:20 / cg"
! !

!ObjectFileLoader class methodsFor:'queries'!

binaryClassFilenameForPackage:aPackageId inDirectory:packageDirOrNil
    |tryAction shLibName exePath exeDir|

    "Is there a shared library (.dll or .so) ?"
    shLibName := aPackageId asPackageId libraryName asFilename
			withSuffix:(self sharedLibrarySuffix).

    tryAction :=
	[:dir |
	    |binaryClassLibraryFilename|

	    binaryClassLibraryFilename := dir / shLibName.
	    binaryClassLibraryFilename exists ifFalse:[
		"/ mhmh - is this a good idea ? (temporary kludge)
		ExternalAddress pointerSize == 4 ifTrue:[
		    binaryClassLibraryFilename := dir / 'objbc' / shLibName.
		    binaryClassLibraryFilename exists ifFalse:[
			binaryClassLibraryFilename := dir / 'objvc' / shLibName.
                                    binaryClassLibraryFilename exists ifFalse:[
                                        binaryClassLibraryFilename := dir / 'objmingw' / shLibName.
                                    ]
		    ]
		] ifFalse:[
		    binaryClassLibraryFilename := dir / 'objmingw' / shLibName.
		].
	    ].
	    (binaryClassLibraryFilename notNil and:[binaryClassLibraryFilename exists]) ifTrue:[
		^ binaryClassLibraryFilename
	    ].
	].

    packageDirOrNil notNil ifTrue:[
	tryAction value:packageDirOrNil.
	^ nil
    ].

    exePath := OperatingSystem pathOfSTXExecutable.
    exePath notNil ifTrue:[
	exeDir := exePath asFilename directory.
	tryAction value:exeDir.
	exeDir baseName = 'bin' ifTrue:[
	    tryAction value:(exeDir directory / 'lib').
	].
	tryAction value:(exeDir directory / 'plugin').
    ].
    ^ nil

    "
    ObjectFileLoader binaryClassFilenameForPackage:'stx:goodies/libcairo' inDirectory: (Smalltalk getPackageDirectoryForPackage: 'stx:goodies/libcairo')

    "

    "Modified: / 19-02-2016 / 15:24:25 / jv"
    "Modified: / 17-10-2017 / 23:15:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canLoadObjectFiles
    "return true, if dynamic loading is possible.
     Currently, only ELF based systems, AIX and linux a.out can do this."

    self primCanLoadObjectFiles ifTrue:[^true].

    "/ can add a return true here, if I ever get manual loading to work
    "/ for some specific machine
    ^ false

    "
     ObjectFileLoader canLoadObjectFiles
    "

    "Modified: 8.1.1997 / 18:13:01 / cg"
!

handleForDynamicObject:pathNameOrFilename
    "answer the handle of pathName (or nil if it has not been loaded)"

    |pathName|

    LoadedObjects isNil ifTrue:[
        ^ nil.
    ].
    pathNameOrFilename notNil ifTrue:[ 
        pathName := pathNameOrFilename asFilename pathName.
    ] ifFalse:[ 
        pathName := nil.
    ].
    ^ LoadedObjects at:pathName ifAbsent:nil.

    "Modified: / 24-01-2016 / 21:59:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handleFromID:id
    "given an id, return the pathName, or nil for static modules"

    LoadedObjects notNil ifTrue:[
	LoadedObjects keysAndValuesDo:[:name :handle |
	    handle moduleID == id ifTrue:[
		^ handle
	    ]
	].
    ].
    ^ nil

    "
     ObjectFileLoader handleFromID:1
    "

    "Modified: 28.8.1995 / 18:08:28 / claus"
!

loadedObjectFiles
    "return a collection containing the names of all
     dynamically loaded objects."

    LoadedObjects isNil ifTrue:[^ #()].
    ^ LoadedObjects keys copy

    "
     ObjectFileLoader loadedObjectFiles
    "
!

loadedObjectHandles
    "return a collection of all handles"

    LoadedObjects isNil ifTrue:[^ #()].
    ^ LoadedObjects

    "
     ObjectFileLoader loadedObjectHandles
    "

    "Created: 17.9.1995 / 14:28:55 / claus"
    "Modified: 17.9.1995 / 16:13:48 / claus"
!

loadedObjectHandlesDo:aBlock
    "enumerate all handles"

    LoadedObjects notNil ifTrue:[
	LoadedObjects copy do:aBlock.
    ].

    "
     ObjectFileLoader loadedObjectHandlesDo:[:h | h pathName printNL]
    "

    "Created: 14.9.1995 / 22:03:13 / claus"
    "Modified: 14.9.1995 / 22:32:48 / claus"
!

moduleNamed:aNameString
    "return the module named aNameString"

    |moduleDescriptor|

    moduleDescriptor :=
	ObjectMemory binaryModuleInfo
	    detect:[:eachModuleDescriptor | eachModuleDescriptor libraryName = aNameString]
	    ifNone:[^ nil].

    ^ LoadedObjects at:(moduleDescriptor pathName) ifAbsent:[].

    "
     ObjectFileLoader moduleNamed:'ctypes'
    "
!

pathNameFromID:id
    "given an id, return the pathName, or nil for static modules"

    LoadedObjects notNil ifTrue:[
	LoadedObjects keysAndValuesDo:[:name :handle |
	    handle moduleID == id ifTrue:[
		^ handle pathName
	    ]
	].
    ].
    ^ nil

    "
     ObjectFileLoader pathNameFromID:1
    "

    "Modified: 28.8.1995 / 18:08:28 / claus"
!

primCanLoadObjectFiles
    "return true, if loading is possible using a standard mechanism"

%{  /* NOCONTEXT */
#ifdef HAS_DL
# if !defined(OS_DEFINE) || defined(unknownOS)
    console_fprintf(stderr, "*** OS_DEFINE not correct\n");
# else
#  if !defined(CPU_DEFINE) || defined(unknownCPU)
    console_fprintf(stderr, "*** CPU_DEFINE not correct\n");
#  else
    RETURN (true);
#  endif
# endif
#endif
%}.
    ^ false

    "
     ObjectFileLoader primCanLoadObjectFiles
    "
! !

!ObjectFileLoader class methodsFor:'signal access'!

objectFileLoadErrorNotification
    ^ ObjectFileLoadErrorNotification
! !

!ObjectFileLoader class methodsFor:'st object file handling'!

callInitFunctionAt:address specialInit:special forceOld:forceOld interruptable:interruptable argument:argument identifyAs:handle returnsObject:returnsObject
    "call a function at address - a very dangerous operation.
     This is needed to call the classes init-function after loading in a
     class-object file or to call the CTORS when c++ modules are loaded.
     ForceOld (if true) will have the memory manager
     allocate things in oldSpace instead of newSpace.
     If special is true, this is a smalltalk moduleInit (i.e. pass the vm-entries table);
     otherwise, its called without arguments.
     If it's a smalltalk-moduleInit, it may be either for a classPackage (which should
     install all of its classes) or for a single incrementally compiled methdod
     (it should then NOT install it, but return the method object instead).

     DANGER: Internal & highly specialized. Don't use in your programs.
	     This interface may change without notice."

    |moduleID retVal oldSpaceReserve|

    handle notNil ifTrue:[
	moduleID := handle moduleID
    ].
    "/
    "/ for various reasons, classes, methods, literals, methodDicts etc.
    "/ must be allocated in oldSpace when coming from a compiled
    "/ classLibrary, and no compressing garbage collect is allowed during
    "/ the creation of those.
    "/ Therefore, we must ensure, that enough oldSpace reserve is available ...
    "/ (how much is enough ?)
    "/
    oldSpaceReserve := OldSpaceReserve ? (1024*1024).

%{  /* CALLSSTACK: 128000 */
    OBJ (*addr)();
    int prevSpace, force;
    INT arg = 0, ret = 0;
    int wasBlocked = 1;

    if (__isInteger(address)) {
	if (_isSmallInteger(argument)) {
	    arg = __intVal(argument);

	    addr = (OBJFUNC)(__longIntVal(address));

	    /*
	     * allow function to be interrupted
	     */
	    if (interruptable != true) {
		wasBlocked = (__BLOCKINTERRUPTS() == true);
	    }

	    force = (forceOld == true);
	    if (force) {
		int reserve = __intVal(oldSpaceReserve);
		if ((__oldSpaceSize() - __oldSpaceUsed()) < reserve) {
		    __moreOldSpace(__thisContext, reserve);
		}
		prevSpace = __allocForceSpace(OLDSPACE);
	    }

	    if (@global(Verbose) == true) {
		console_printf("calling initfunc %lx(%lx) ...\n", (long)addr, (long)arg);
	    }

	    if (special == true) {
		if (__isSmallInteger(moduleID)) {
		    __SET_MODULE_ID(__intVal(moduleID));
		}
		retVal = (*addr)(arg, __pRT__);
		__SET_MODULE_ID(0);
		if (returnsObject != true) {
		    retVal = nil;
		}
	    } else {
		if (returnsObject == true) {
		    retVal = (*addr)(arg);
		} else {
		    ret = (INT) ((*addr)(arg));
		    retVal = __mkSmallInteger(ret);
	       }
	    }

	    if (force) {
		__allocForceSpace(prevSpace);
	    }

	    if (! wasBlocked) {
		__UNBLOCKINTERRUPTS();
	    }
	    RETURN (retVal);
	}
    }
%}.
    self primitiveFailed

    "Modified (comment): / 13-02-2017 / 20:27:51 / cg"
!

classPresentCheck:aClassOrClassName
    "callBack from class registration code in VM:
     make certain, that aClassOrClassName is loaded too ...
     (req'd if a subclass of an autoloaded class has been loaded).
    This is now invoked both for superClasses AND preRequisite classnames (for extensions)"

    |className class|

    aClassOrClassName isBehavior ifTrue:[
	class := aClassOrClassName.
	className := aClassOrClassName name.
    ] ifFalse:[
	aClassOrClassName isString ifTrue:[
	    className := aClassOrClassName.
	    class := Smalltalk classNamed:aClassOrClassName.
	] ifFalse:[
	    'ObjectFileLoader [warning]: check failed - no behavior' errorPrintCR.
	    ^ false
	]
    ].

    class isNil ifTrue:[
	Verbose ifTrue:[
	    ('ObjectFileLoader [info]: missing class: ' , className) errorPrintCR.
	].
	"/ how can I find this missing class - need some package info
	^ false.
    ].

    class notNil ifTrue:[
	Verbose ifTrue:[
	    ('ObjectFileLoader [info]: check for ' , className , ' being loaded') errorPrintCR.
	].

	class autoload.
	(class isBehavior and:[class isLoaded]) ifTrue:[
	    Verbose ifTrue:[
		('ObjectFileLoader [info]: ok, loaded. continue registration of actual class') errorPrintCR.
	    ].
	    class signature.       "/ req'd in VM for validation
	    ^ true
	].
    ].

    ('ObjectFileLoader [warning]: superclass not loaded; registration of ' , className , ' fails') errorPrintCR.
    ^ false

    "Modified: 10.1.1997 / 17:58:48 / cg"
!

deinitializeClassesFromModule:handle
    "send #deinitialize and an #aboutToUnload notification
     to all classes of a module."

    |classes|

    classes := handle classes.
    classes notNil ifTrue:[
	classes do:[:aClass |
	    aClass notNil ifTrue:[
		aClass isMeta ifFalse:[
		    Verbose ifTrue:[
			'send #deinitialize to:' errorPrint. aClass name errorPrintCR.
		    ].
		    aClass deinitialize.
		    aClass update:#aboutToUnload with:nil from:self
		]
	    ]
	]
    ]

    "Modified: 10.1.1997 / 17:56:50 / cg"
!

invalidateModule:handle
    "invalidate all of the classes code objects ..."

    |id|

    Verbose ifTrue:[
	'invalidate module; name=' errorPrint. handle pathName errorPrint.
	' id=' errorPrint. handle moduleID errorPrintCR.
    ].

    id := handle moduleID.
%{
    __INVALIDATE_BY_ID(__intVal(id));
%}
!

loadStatusFor:className
    "ask VM if class-hierarchy has been completely loaded, and return the status.
     If className is non-nil, check the load status of this class only,
     otherwise check the status of all known classes.

     Answer an array with the status symbol and optionally the name of
     a class with a bad status."

    |checker checkSymbol statusCode status badClassName1 badClassName2|

    checker := self.
    checkSymbol := #classPresentCheck:.

%{  /* NOREGISTER */
    char *badName1 = NULL;
    char *badName2 = NULL;
    char interestingClassName[512], *classNameP = 0;

    if (__isStringLike(className)) {
	strncpy(interestingClassName, __stringVal(className), sizeof(interestingClassName));
	classNameP = interestingClassName;
    }
    statusCode = __MKSMALLINT(__check_registration__(classNameP,
						     &checker, &checkSymbol,
						     &badName1, &badName2));
    if (badName1) {
	badClassName1 = __MKSTRING(badName1);
    }
    if (badName2) {
	badClassName2 = __MKSTRING(badName2);
    }
%}.
    statusCode == 0 ifTrue:[
	status := #ok
    ] ifFalse:[ statusCode == -1 ifTrue:[
	status := #missingClass
    ] ifFalse:[ statusCode == -2 ifTrue:[
	status := #versionMismatch
    ] ifFalse:[ statusCode == -3 ifTrue:[
	status := #unregisteredSuperclass
    ] ifFalse:[ statusCode == -4 ifTrue:[
	status := #tryAgain
    ] ifFalse:[
	status := #loadFailed
    ] ] ] ] ].

    ^ Array with:status with:badClassName1 with:badClassName2.

    "Modified: / 21-02-2017 / 14:24:55 / mawalch"
!

moduleInit:phase forceOld:forceOld interruptable:interruptable
    "initialization phases after registration.
     DANGER: Pure magic; internal only -> don't use in your programs."

    self primModuleInit:phase forceOld:forceOld interruptable:interruptable

    "Modified: / 06-12-2006 / 13:09:43 / cg"
!

performModuleInitAt:initAddr for:className identifyAs:handle
    "Initialize a loaded smalltalk module."

    ^ self
	performModuleInitAt:initAddr invokeInitializeMethods:true for:className identifyAs:handle.

!

performModuleInitAt:initAddr invokeInitializeMethods:invokeInitializeMethods for:className identifyAs:handle
    "Initialize a loaded smalltalk module."

    |status badClassName1 badClassName2 infoCollection info classNames classes
     stillTrying|

    "
     need 4 passes to init: 0: let module register itself & create its pools/globals
			    0b check if modules superclasses are all loaded
			    1: let it get var-refs to other pools/globals
			    2: let it install install class, methods and literals
			    3: let it send #initialize to its class object
    "

    Verbose ifTrue:[
	'start' errorPrintCR
    ].

    [
	stillTrying := false.

	"/
	"/ let it register itself
	"/ and define its globals
	"/
	Verbose ifTrue:[
	    'phase 0 (module registration) ...' errorPrintCR
	].
	self
	    saveCallInitFunctionAt:initAddr
	    in:nil
	    specialInit:true
	    forceOld:true
	    interruptable:false
	    argument:0
	    identifyAs:handle
	    returnsObject:false.

	"/
	"/ check if superclasses are present
	"/
	info := self loadStatusFor:className.
	status := info at:1.
	badClassName1 := info at:2.
	badClassName2 := info at:3.

	Verbose ifTrue:[
	    '... info is ' errorPrint. info errorPrintCR
	].

	(status ~~ #ok) ifTrue:[
	    (status == #missingClass) ifTrue:[
		('ObjectFileLoader [error]: load failed - missing class: ' , badClassName1) infoPrintCR.
		^ info
	    ].
	    (status == #versionMismatch) ifTrue:[
		('ObjectFileLoader [error]: load failed - version mismatch: ',badClassName1,' vs. ',badClassName2) infoPrintCR.
		^ info
	    ].
	    (status == #unregisteredSuperclass) ifTrue:[
		('ObjectFileLoader [error]: load failed - unregistered: ' , badClassName1) infoPrintCR.
		^ info
	    ].
	    (status == #tryAgain) ifTrue:[
		"/ tryAgain:
		"/   must retry after initialization, to initialize
		"/   sub-subclasses of autoloaded classes
		"/   (sigh - class objects are created in phase 3,
		"/    so we must first complete the initialization cycle,
		"/    then do all again, for remaining modules)
		stillTrying := true.
		'ObjectFileLoader [info]: retry registration of: ' infoPrint.
		(className ? 'a classLib') infoPrint. ' after init' infoPrintCR.
	    ] ifFalse:[
		'ObjectFileLoader [error]: load failed: ' infoPrint. className infoPrintCR.
		^ #(loadFailed nil)
	    ].
	].

	Smalltalk flushCachedClasses.
	Class flushSubclassInfo.
	"/
	"/ remaining initialization
	"/

	"/ module exports: declare module-globals & symbols ...
	Verbose ifTrue:[
	    'phase 1 (resolve globals) ...' errorPrintCR
	].
	self moduleInit:1 forceOld:true interruptable:false.

	"/ module-imports: resolve globals ...
	"/ create methods & install ...
	Verbose ifTrue:[
	    'phase 2 (create objects) ...' errorPrintCR
	].
	self moduleInit:2 forceOld:true interruptable:false.

	Verbose ifTrue:[
	    'stillTrying is ' errorPrint. stillTrying errorPrintCR
	].
    ] doWhile:[stillTrying].

    Verbose ifTrue:[
	'end' errorPrintCR
    ].

    ObjectMemory flushCaches.

    invokeInitializeMethods ifTrue:[
	Verbose ifTrue:[
	    'phase 3 (send #initialize) ...' errorPrintCR
	].
	"/ initialize ...
	self moduleInit:3 forceOld:false interruptable:true.
    ].

    "/ ask objectMemory for the classes we have just loaded
    "/ and register them in the handle

    infoCollection := ObjectMemory binaryModuleInfo.
    info := infoCollection at:handle moduleID ifAbsent:nil.
    info isNil ifTrue:[
	"/ mhmh registration failed -
	'ObjectFileLoader [error]: registration failed: ' infoPrint.
	(className ? 'some classLib') infoPrintCR.
	^ #(registrationFailed nil)
    ].

    classNames := info classNames.
    classNames notEmptyOrNil ifTrue:[
	classes := OrderedCollection new:classNames size.
	classNames do:[:eachClassName | |class|
	    class := Smalltalk classNamed:eachClassName.
	    class notNil ifTrue:[
		classes add:class.
	    ].
	].
    ].
    classes notEmptyOrNil ifTrue:[
	classes := classes asArray.
	classes := classes , (classes collect:[:aClass | aClass class]).
    ].
    handle classes:classes.

"/    invokeinitializemethods iftrue:[
"/        verbose iftrue:[
"/            'phase 3 (send #initialize) ...' errorPrintCR
"/        ].
"/        "/ INITIALIZE ...
"/        self moduleinit:3 forceold:false interruptable:true.
"/    ].

    ^ #(ok nil)

    "Modified: / 29-07-2004 / 17:12:28 / stefan"
    "Modified: / 15-11-2010 / 13:20:11 / cg"
!

primModuleInit:phase forceOld:forceOld interruptable:interruptable
    "initialization phases after registration.
     DANGER: Pure magic; internal only -> don't use in your programs."

%{
    int prevSpace, force;
    int wasBlocked = 1;

    if (__isSmallInteger(phase)) {
	if (interruptable != true) {
	    wasBlocked = (__BLOCKINTERRUPTS() == true);
	}

	force = (forceOld == true);
	if (force) {
	    prevSpace = __allocForceSpace(OLDSPACE);
	}

	__init_registered_modules__(__intVal(phase));

	if (force) {
	    __allocForceSpace(prevSpace);
	}

	if (! wasBlocked) {
	    __UNBLOCKINTERRUPTS();
	}
	RETURN (self);
    }
%}.
    self primitiveFailed

    "Created: / 06-12-2006 / 13:09:24 / cg"
!

revalidateModule:handle
    "revalidate all of the classes code objects ..."

    |id|

    Verbose ifTrue:[
	'revalidate module; name=' errorPrint. handle pathName errorPrint.
	' id=' errorPrint. handle moduleID errorPrintCR.
    ].

    id := handle moduleID.
%{
    __REVALIDATE_BY_ID(__intVal(id));
%}
!

saveCallInitFunctionAt:address in:aFilenameOrNil specialInit:special forceOld:forceOld interruptable:interruptable argument:argument identifyAs:handle returnsObject:returnsObject
    OSSignalInterrupt handle:[:ex |
	aFilenameOrNil notNil ifTrue:[
	    ('ObjectFileLoader [warning]: SignalInterrupt from initFunction in %1' bindWith:(aFilenameOrNil asFilename pathName)) errorPrintCR.
	] ifFalse:[
	    'ObjectFileLoader [warning]: SignalInterrupt from initFunction' errorPrintCR.
	].
    ] do:[
	^ self
	    callInitFunctionAt:address
	    specialInit:special
	    forceOld:forceOld
	    interruptable:interruptable
	    argument:argument
	    identifyAs:handle
	    returnsObject:returnsObject
    ].

    "Created: / 15-11-2010 / 13:21:59 / cg"
!

unregisterModule:handle
    "unregister classes in the VM.
     This invalidates all of the classes code objects ..."

    |id|

    Verbose ifTrue:[
	'unregister module; name=' errorPrint. handle pathName errorPrint.
	' id=' errorPrint. handle moduleID errorPrintCR.
    ].

    id := handle moduleID.
%{
    __UNREGISTER_BY_ID(__intVal(id));
%}
! !

!ObjectFileLoader class methodsFor:'under test - loading dlls'!

loadObjectFiles:aSeqOfFiles
    "load a sequence of DLLs... first load all dlls with #moduleInit:0
     then call #moduleInit:1, #moduleInit:2 and #moduleInit:3 for all loaded DLLs.

     *** UNDER TEST ...
	used by ExpeccoStartup under windows.

     not supported is C,...
    "

    |filename handle initAddr className infoCollection handles info|

    aSeqOfFiles isEmptyOrNil ifTrue:[^ self].

    handles := OrderedCollection new.

    Smalltalk flushCachedClasses.
    Class flushSubclassInfo.

    aSeqOfFiles do:[:each|
	filename := each asFilename.
	handle   := self handleForDynamicObject:filename.

	handle isNil ifTrue:[
	    Smalltalk showSplashMessage:('loading ', filename baseName).
	    handle := self loadDynamicObject:filename.

	    handle notNil ifTrue:[
		className := self initFunctionBasenameForFile:filename.
		initAddr := self findInitFunction:className in:handle.

		initAddr notNil ifTrue:[
		    [
			self
			    saveCallInitFunctionAt:initAddr
			    in:filename
			    specialInit:true
			    forceOld:true
			    interruptable:false
			    argument:0
			    identifyAs:handle
			    returnsObject:false.

			info := self loadStatusFor:nil.
			(info first == #tryAgain)
		    ] whileTrue.

		    info first == #ok ifTrue:[
			handles add:handle
		    ] ifFalse:[
			( '%1: error during init: %2' bindWith:each with:info) errorPrintCR.
		    ].
		].
	    ].
	].
    ].
    Smalltalk showSplashMessage:('initializing modules-1...').
    self moduleInit:1 forceOld:true interruptable:false.
    Smalltalk showSplashMessage:('initializing modules-2...').
    self moduleInit:2 forceOld:true interruptable:false.
    ObjectMemory flushCaches.
    Smalltalk showSplashMessage:('initializing modules-3...').
    self moduleInit:3 forceOld:false interruptable:true.

    infoCollection := ObjectMemory binaryModuleInfo.

    handles do:[:each|
	|classNames classes|

	info := infoCollection at:(handle moduleID) ifAbsent:nil.

	info isNil ifTrue:[
	    ('error - nil info: %1' bindWith:handle ) errorPrintCR.
	] ifFalse:[
	    classNames := info classNames.

	    classNames notEmptyOrNil ifTrue:[
		classes := OrderedCollection new:classNames size.

		classNames do:[:eachClassName | |class|
		    class := Smalltalk classNamed:eachClassName.
		    class notNil ifTrue:[
			classes add:class.
		    ].
		].
		classes notEmptyOrNil ifTrue:[
		    classes := classes asArray.
		    classes := classes , (classes collect:[:aClass | aClass class]).
		].
		handle classes:classes.
	    ].
	].
    ].
    Smalltalk showSplashMessage:('done loading modules.').

"
    |directory filename dlls|

    directory := 'C:\Dokumente und Einstellungen\Steffen Jung\work\exept\expecco\application' asFilename.
    filename := directory construct:'modules.stx'.

    dlls := OrderedCollection new.

    filename readingLinesDo:[:aLine|
	|line dllFile|

	line := aLine withoutSeparators.

	line size > 3 ifTrue:[
	    line first ~~ $# ifTrue:[
		dllFile := directory construct:(line, '.dll').

		dllFile exists ifTrue:[
		    dlls add:dllFile.
		].
	    ]
	]
    ].
    ObjectFileLoader loadObjectFiles:dlls.
"

    "Modified: / 11-08-2011 / 17:25:52 / cg"
! !

!ObjectFileLoader class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


ObjectFileLoader initialize!
