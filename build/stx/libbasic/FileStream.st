"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

ExternalStream subclass:#FileStream
	instanceVariableNames:'pathName canPosition removeOnClose'
	classVariableNames:'UserInitiatedFileSaveQuerySignal'
	poolDictionaries:''
	category:'Streams-External'
!

!FileStream primitiveDefinitions!
%{
#include "stxOSDefs.h"

#undef String
#undef Character

#include <stdio.h>
#define _STDIO_H_INCLUDED_

#include <errno.h>
#define _ERRNO_H_INCLUDED_

#ifdef transputer
# include <iocntrl.h>
# ifndef fileno
   /* kludge: inmos forgot fileno */
#  define fileno(f)     ((f)->__file)
# endif

#else /* not transputer */

# include <sys/types.h>
# include <sys/stat.h>

#endif /* not transputer */

#ifdef hpux
# define fileno(f)      ((f->__fileH << 8) | (f->__fileL))
#endif

#ifdef __VMS__
# include <rms.h>
#endif

#define String  __STX_String
#define Character __STX_Character

#ifdef __win32__
# define NO_STDIO
# if defined(__i386__) || defined(__x86__)
#  define _X86_
# endif

# undef INT
# undef UINT
# undef Array
# undef Number
# undef Method
# undef Point
# undef Rectangle
# undef Block
# undef Time
# undef Date
# undef Set
# undef Signal
# undef Delay
# undef Context
# undef Message
# undef Process
# undef Processor
# undef String
# undef Character

# define NOATOM
# define NOGDICAPMASKS
# define NOMETAFILE
# define NOMINMAX
//# define NOOPENFILE
# define NOSOUND
# define NOWH
//# define NOCOMM
# define NOKANJI
# define NOCRYPT
//# define NOMCX
# define WIN32_LEAN_AND_MEAN

# include <windows.h>

# if 1 // defined(__MINGW64__)
#  include <fcntl.h>
# endif

# if defined(__BORLANDC__)
#  include <io.h>
# else
#  define lseek _lseek
# endif

# ifdef __DEF_Array
#  define Array __DEF_Array
# endif
# ifdef __DEF_Number
#  define Number __DEF_Number
# endif
# ifdef __DEF_Method
#  define Method __DEF_Method
# endif
# ifdef __DEF_Point
#  define Point __DEF_Point
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
# ifdef __DEF_String
#  define String __DEF_String
# endif
# ifdef __DEF_Character
#  define Character __DEF_Character
# endif

# define INT  STX_INT
# define UINT STX_UINT

# if 0
# ifndef DO_WRAP_CALLS
#  define STX_C_CALL0(__nm__, __f__)                            __f__((__a1__))
#  define STX_C_CALL1(__nm__, __f__, __a1__)                    __f__((__a1__))
#  define STX_C_CALL2(__nm__, __f__, __a1__, __a2__)            __f__((__a1__), (__a2__))
#  define STX_C_CALL3(__nm__, __f__, __a1__, __a2__, __a3__)    __f__((__a1__), (__a2__), (__a3__))
# else
#  define STX_C_CALL0(__nm__, __f__)                            __STX_C_CALL0(__nm__, (void*)__f__)
#  define STX_C_CALL1(__nm__, __f__, __a1__)                    __STX_C_CALL1(__nm__, (void*)__f__, (void*)(__a1__))
#  define STX_C_CALL2(__nm__, __f__, __a1__, __a2__)            __STX_C_CALL2(__nm__, (void*)__f__, (void*)(__a1__), (void*)(__a2__))
#  define STX_C_CALL3(__nm__, __f__, __a1__, __a2__, __a3__)    __STX_C_CALL3(__nm__, (void*)__f__, (void*)(__a1__), (void*)(__a2__), (void*)(__a3__))
# endif
# endif

/* #  define HFILE HANDLE */
#  define HFILE FILE *
/* #  define fileno(f) f */

#else /* not __win32__ */
# define HFILE FILE *
#endif /* ! __win32__ */

//#define DO_WRAP_CALL_FSEEK

#include "stxOSDefs.h"

#ifndef SEEK_SET
# define SEEK_SET       0
#endif
#ifndef SEEK_CUR
# define SEEK_CUR       1
#endif
#ifndef SEEK_END
# define SEEK_END       2
#endif
%}
! !

!FileStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
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
    This class provides access to the operating systems underlying file
    system (i.e. its an interface to the stdio library).

    Notice, that on some systems, the standard I/O library has performance
    problems when a file is opened for readwrite.
    For best results, open files either readonly or writeonly.

    Also notice, that some OperatingSystems do not fully support
    positioning a file stream.
    For example, poor VMS does not allow positioning onto arbitrary
    byte boundaries if the file is a variable-record-RMS file.
    (stupid enough, this is the default for textfiles as created by some tools ...)
    Therefore, the instance variable canPosition is set according to
    this and an error is raised, if a position: is attemted.
    I know, this is ugly, but what else could we do ?
    Late note: who cares for VMS these days?
	       (and how much useless effort has been put in the past,
		to support lousy operating systems?)

    [instance variables:]
	pathName        <String>        the file's path (if known)
	canPosition     <Boolean>       positionable - read above comment

    [author:]
	Claus Gittinger

    [see also:]
	Filename DirectoryStream PipeStream Socket
"
!

examples
"
  for VMS users only:

    The #openWithMode:attributes: entry allows additional RMS attributes
    to be passed in the second argument, which must be an array of strings
    as described in the 'creat' RTL Library documentation.

    For example, to create a file with fixed records and recordLength of 100,
    use:

	|newFile|

	newFile := FileStream new pathName:'<nameOfFile>'.
	newFile setMode:#writeonly.
	newFile openWithMode:'w' attributes:#('rfm=fix' 'fsz=100').

    since all of the above is private protocol, and it is considered bad style to
    access these from user programs, we recommend subclassing FileStream as
    something like VMSFixedRecordFileStream, and redefine the instance creation
    method(s) there as appropriate.
    This will retain VMS specifics in one place and enhance maintanability.
"
! !

!FileStream class methodsFor:'initialization'!

initialize
    UserInitiatedFileSaveQuerySignal isNil ifTrue:[
	"/
	"/ this is temporary - for now allow an openError to
	"/ be unhandled and proceed by returning a nil from the
	"/ stream creation method.
	"/ In the future, this will be a hard signal.
	"/ THE FUTURE IS NOW!!!!
	"/
"/        OpenErrorSignal := QuerySignal new.
"/        OpenErrorSignal parent:(super openErrorSignal) mayProceed:true.
"/        OpenErrorSignal nameClass:self message:#openErrorSignal.
"/        OpenErrorSignal notifierString:'open error'.

	UserInitiatedFileSaveQuerySignal := QuerySignal new defaultAnswer:true.
	UserInitiatedFileSaveQuerySignal nameClass:self message:#userInitiatedFileSaveQuerySignal.
    ]

    "Modified: 8.10.1997 / 11:56:39 / cg"
! !

!FileStream class methodsFor:'instance creation'!

appendingOldFileNamed:filename
    "return a FileStream for existing file named filename, aString.
     The file is opened for writeonly access."


    |newStream|

    newStream := self new pathName:filename.
    ^ newStream openForAppending.

    "
     FileStream appendingOldFileNamed:'adasdasasd'
    "
!

appendingOldFileNamed:filename in:aDirectory
    "return a FileStream for existing file named filename, aString
     in aDirectory, a FileDirectory.
     The file is opened for writeonly access."

    |newStream|
    newStream := self new pathName:filename in:aDirectory.
    ^ newStream openForAppending.
!

fileNamed:filename
    "return a stream on file filename - if the file does not
     already exist, create it.
     The file is opened for read/write access."

    [
	^ self oldFileNamed:filename.
    ] on:self openErrorSignal do:[:ex| ].

    ^ self newFileNamed:filename
!

fileNamed:filename in:aDirectory
    "return a stream on file filename - if the file does not
     already exist, create it.
     The file is opened for read/write access."

    [
	^ self oldFileNamed:filename in:aDirectory.
    ] on:self openErrorSignal do:[:ex| ].

    ^ self newFileNamed:filename in:aDirectory
!

newFileForWritingNamed:filename
    "return a FileStream for new file named filename, aString.
     If the file exists, it is truncated, otherwise created.
     The file is opened for writeonly access."

    |newStream|
    newStream := self new pathName:filename.
    ^ newStream createForWriting.
!

newFileForWritingNamed:filename in:aDirectory
    "return a FileStream for new file named filename, aString
     in aDirectory, a FileDirectory.
     If the file exists, it is truncated, otherwise created.
     The file is opened for writeonly access."

    |newStream|
    newStream := self new pathName:filename in:aDirectory.
    ^ newStream createForWriting.
!

newFileNamed:filename
    "return a FileStream for new file named filename, aString.
     If the file exists, it is truncated, otherwise created.
     The file is opened for read/write access."

    |newStream|
    newStream := self new pathName:filename.
    ^ newStream createForReadWrite.

    "Modified: / 28.10.1997 / 14:28:08 / cg"
!

newFileNamed:filename in:aDirectory
    "return a FileStream for new file named filename, aString
     in aDirectory, a FileDirectory.
     If the file exists, it is truncated, otherwise created.
     The file is opened for read/write access."

    |newStream|
    newStream := self new pathName:filename in:aDirectory.
    ^ newStream createForReadWrite.
!

newTemporary
    "create atomically a new file and return the file stream - use this for temporary files.
     The created file has the name '/tmp/stxtmp_xx_nn' where xx is our
     unix process id, and nn is a unique number, incremented with every call to this method.
     If any of the environment variables ST_TMPDIR or TMPDIR is set,
     its value defines the temp directory."

    ^ self newTemporaryIn:Filename tempDirectory

    "
     FileStream newTemporary
     FileStream newTemporary
    "
!

newTemporaryIn:aDirectoryOrNil
    "create atomically a new file and return the file stream - use this for temporary files.
     The created file is in aDirectoryPrefix and named 'stxtmp_xx_nn',
     where xx is our unix process id, and nn is a unique number, incremented
     with every call to this method."

    ^ self newTemporaryIn:aDirectoryOrNil nameTemplate:Filename tempFileNameTemplate

    "temp files in '/tmp':

     FileStream newTemporary
    "

    "temp files somewhere
     (not recommended - use above since it can be controlled via shell variables):

     FileStream newTemporaryIn:'/tmp'
     FileStream newTemporaryIn:'/tmp'
     FileStream newTemporaryIn:'/usr/tmp'
     FileStream newTemporaryIn:'/'
    "

    "a local temp file:

     FileStream newTemporaryIn:''
     FileStream newTemporaryIn:nil
     FileStream newTemporaryIn:'.'
     FileStream newTemporaryIn:('source' asFilename)
    "
!

newTemporaryIn:aDirectoryOrNil nameTemplate:template
    "create atomically a new file and return the file stream - use this for temporary files.
     The created file is in aDirectoryOrNil and named after the given template,
     in which %1 and %2 are expanded to the unix process id, and a unique number, incremented
     with every call to this method respectively.
     See also: #newTemporary which looks for a good temp directory."

    |nameString random prevRandom prevNameString newTempFilename stream|

    [
	prevRandom := random.
	prevNameString := nameString.

	"Use random numbers in order to improve the security
	 by making the generated names less predictable"
	[
	    random := RandomGenerator nextLettersOrDigits:4.
	] doWhile:[random = prevRandom].

	nameString := template bindWith:(OperatingSystem getProcessId) with:random.

	aDirectoryOrNil isNil ifTrue:[
	    newTempFilename := nameString.
	] ifFalse:[
	    newTempFilename := aDirectoryOrNil asFilename constructString:nameString.
	].

	[
	    stream := self open:newTempFilename withMode:#(CREATE_NEW GENERIC_READ_WRITE).
	] on:OpenError do:[:ex|
	   ex errorCategory ~~ #existingReferentSignal ifTrue:[
		"some fundamental error, raise exception"
		ex reject.
	    ].
	    prevNameString = nameString ifTrue:[
		"no more names - probably a bad template"
		ex reject.
	    ].
	    "file exists, retry another one"
	].
    ] doWhile:[
	stream isNil and:[prevNameString ~= nameString]   "/ if namestring didn't change, the template is bad
    ].
    ^ stream

    "temp files in '/tmp':

	FileStream newTemporaryIn:'/tmp' asFilename nameTemplate:'foo%1_%2'

     This must fail on the second try:
	FileStream newTemporaryIn:'/tmp' asFilename nameTemplate:'foo'
	FileStream newTemporaryIn:'c:\temp' asFilename nameTemplate:'foo'
    "

    "temp files somewhere
     (not recommended - use above since it can be controlled via shell variables):

     FileStream newTemporaryIn:'/tmp'     nameTemplate:'foo%1_%2'
     FileStream newTemporaryIn:'/tmp'     nameTemplate:'foo%1_%2'
     FileStream newTemporaryIn:'/usr/tmp' nameTemplate:'foo%1_%2'
     FileStream newTemporaryIn:'/'        nameTemplate:'foo%1_%2'
    "

    "a local temp file:

     FileStream newTemporaryIn:''             nameTemplate:'foo%1_%2'
     FileStream newTemporaryIn:nil            nameTemplate:'foo%1_%2'
     FileStream newTemporaryIn:'.'            nameTemplate:'foo%1_%2'
     FileStream newTemporaryIn:('source' asFilename) nameTemplate:'foo%1_%2'
    "
!

newTemporaryIn:aDirectoryOrNil withSuffix:aSuffixString
    "create atomically a new file and return the file stream - use this for temporary files.
     The created file is in aDirectoryPrefix and named 'stxtmp_xx_nn',
     where xx is our unix process id, and nn is a unique number, incremented
     with every call to this method."

    ^ self
	newTemporaryIn:aDirectoryOrNil
	nameTemplate:(Filename tempFileNameTemplate asFilename
					withSuffix:aSuffixString) asString

    "
     FileStream newTemporaryWithSuffix:'txt'
     FileStream newTemporaryIn:'/tmp' withSuffix:'txt'
    "
!

newTemporaryWithSuffix:aString
    "create atomically a new file and return the file stream - use this for temporary files.
     The created file has the name '/tmp/stxtmp_xx_nn' where xx is our
     unix process id, and nn is a unique number, incremented with every call to this method.
     If any of the environment variables ST_TMPDIR or TMPDIR is set,
     its value defines the temp directory."

    ^ self newTemporaryIn:Filename tempDirectory withSuffix:aString

    "
     FileStream newTemporaryWithSuffix:'txt'
    "
!

oldFileNamed:filename
    "return a FileStream for existing file named filename, aString.
     The file is opened for read/write access.
     Raises an error if the file does not exist."

    |newStream|

"/ We can do the following, but is is an extra OS-systemcall:
"/    (OperatingSystem isReadable:filename) ifFalse:[^ self new openError].

    newStream := self new pathName:filename.
    newStream readwrite.
    ^ newStream openForReadWrite.

    "
     '/tmp/dAsGiBtEsNiChT' asFilename remove.
     FileStream oldFileNamed:'/tmp/dAsGiBtEsNiChT'
    "
!

oldFileNamed:filename in:aDirectory
    "return a FileStream for existing file named filename, aString
     in aDirectory, a FileDirectory.
     The file is opened for read/write access.
     Raises an error if the file does not exist."

    |newStream|
    newStream := self new pathName:filename in:aDirectory.
    ^ newStream openForReadWrite.

    "
     FileStream oldFileNamed:'dAsGiBtEsNiChT' in:'/'
    "
!

open:aFilenameString withMode:anArrayOrString
    "The argument de
     The file is opened for read/write access."

    |stream|

    stream := self new pathName:aFilenameString.
    stream
	readwrite;        "/ assume read/write mode, but this depends on the args
	openWithMode:anArrayOrString attributes:nil.

    ^ stream
!

readonlyFileNamed:filename
    "Return a readonly FileStream for existing file named filename, a String.
     Raises an error if the file does not exist."

    |newStream|

"/ We can do the following, but it is an extra system call:
"/    (OperatingSystem isReadable:filename) ifFalse:[^ self new openError].

    newStream := self new pathName:filename.
    ^ newStream openForReading.

    "
     FileStream readonlyFileNamed:'dAsGiBtEsNiChT'
    "
!

readonlyFileNamed:filename in:aDirectory
    "return a readonly FileStream for existing file named filename, aString
     in aDirectory, a fileName or string instance representing a directory.
     Raises an error if the file does not exist."

    |newStream|
    newStream := self new pathName:filename in:aDirectory.
    ^ newStream openForReading.

    "
     FileStream readonlyFileNamed:'dAsGiBtEsNiChT' in:'/'
     FileStream readonlyFileNamed:'dAsGiBtEsNiChT' in:'/' asFilename
    "
! !

!FileStream class methodsFor:'Compatibility-ANSI'!

write:filename
    "return a FileStream for new file named filename, aString.
     If the file exists, it is truncated, otherwise created.
     The file is opened for read/write access.
     Same as newFileNamed: for ANSI compatibilily"

    ^ self newFileNamed:filename
! !

!FileStream class methodsFor:'Compatibility-Dolphin'!

read:filename text:text
    "return a readonly FileStream for the existing file named filename, aString.
     If the argument, text is false, the stream is setup to read binary bytes,
     if false, it reads characters."

    |s|

    s := self readOnlyFileNamed:filename.
    text ifTrue:[
	s text
    ] ifFalse:[
	s binary
    ].
    ^ s
!

write:filename mode:modeSymbol
    "return a writable FileStream for the file named filename, aString.
     The modeSymbol controls how the file is opened; currently supported are:
	#append
    "

    modeSymbol == #append ifTrue:[
	^ self appendingOldFileNamed:filename
    ].
    "/ self openErrorSignal is a Notification. This will change..
    "/ We want to raise a real error here
    super openErrorSignal raiseRequestErrorString:' - unsupported mode'.
    ^ nil
!

write:filename text:textModeBoolean
    "return a writable FileStream for the file named filename, aString.
     If the argument, text is false, the stream is setup to write binary bytes,
     if false, it writes characters."

    |s|

    s := self newFileNamed:filename.
    s notNil ifTrue:[
	textModeBoolean ifTrue:[
	    s text
	] ifFalse:[
	    s binary
	]
    ].
    ^ s
! !

!FileStream class methodsFor:'Compatibility-Squeak'!

fileIn:aPath
    aPath asFilename fileIn
!

forceNewFileNamed:filename
    "return a writing FileStream for new file named filename, aString.
     If it already exists, it is overwritten silently."

    ^ self newFileNamed:filename
!

readOnlyFileNamed:filename
    "return a readonly FileStream for the existing file named filename, aString."

    ^ self readonlyFileNamed:filename
! !

!FileStream class methodsFor:'Compatibility-VW'!

badArgumentsSignal
    ^ Error
! !

!FileStream class methodsFor:'Signal constants'!

userInitiatedFileSaveQuerySignal
    "return the query signal, which is raised before a user-initiated
     file-save / file-saveAs operation is performed.
     The query will be invoked with the fileName which is about to be
     written to.
     The default signal here returnes true, which will grant the save.
     End-user applications may want to catch this signal,
     and only return true for certain directories."

    ^ UserInitiatedFileSaveQuerySignal

! !

!FileStream methodsFor:'Compatibility-Squeak'!

fullName
    "Squeak compatibility: return the full pathname"

    ^ pathName asFilename pathName

    "Created: 17.10.1997 / 17:04:12 / cg"
    "Modified: 20.10.1997 / 19:22:44 / cg"
! !

!FileStream methodsFor:'access rights'!

accessRights
    "return the access rights of the file as opaque data
     (SmallInteger in unix/linux)"

    ^ OperatingSystem accessModeOfFd:self fileDescriptor.

    "
      'Make.proto' asFilename readingFileDo:[:s|
	  s accessRights
      ]
    "
!

accessRights:opaqueData
    "set the access rights of the file to opaqueData,
     which is normally retrieved by Filename>>#accessRights
     or FileStreamm>>#accessRights."

    (OperatingSystem changeAccessModeOfFd:self fileHandle to:opaqueData) ifFalse:[
        OperatingSystem accessDeniedErrorSignal
            raiseRequestWith:self
            errorString:(' - cannot change access rights: ' , self pathName).
    ].

    "
      'Make.proto' asFilename readingFileDo:[:s|
          s accessRights:s accessRights
      ]
    "

    "
      '/' asFilename readingFileDo:[:s|
          s accessRights:s accessRights
      ]
    "
! !

!FileStream methodsFor:'accessing'!

asFilename
    "return the file name"

    ^ pathName asFilename
!

contentsOfEntireFile
    "ST-80 compatibility: return contents as a String (or byteArray, if in binary mode).
     See also #contents, which returns the lines as stringCollection for text files."

    position == 0 ifTrue:[
	^ self next:(self fileSize)
    ].

    ^ super contentsOfEntireFile

    "Created: / 18-07-2010 / 22:17:49 / cg"
!

directoryName
    "return the name of the directory I'm in as a string"

    ^ pathName asFilename directoryName
!

fileName
    "return the file name - same as pathName for compatibility with
     other smalltalks"

    ^ pathName asFilename
!

name
    "return my name without leading direcory-path (i.e. the plain fileName)
     as a string"

    ^ pathName asFilename baseName
!

pathName
    "return the pathname"

    ^ pathName
!

removeOnClose:aBoolean
    "set/clear the removeOnClose flag.
     If set, the file will be removed when closed.
     Provided mostly for OS's which do not allow an
     open file to be removed (i.e. non unixes),
     when a fileStream for a tempFile is used.
     Especially, the CVS-SourceCodeManager returns
     this kind of file-handles occasionally.
     This is an ST/X special feature which is not portable
     to other systems."

    removeOnClose := aBoolean.
    self reRegisterForFinalization.

    "Modified: / 13.8.1998 / 12:10:07 / cg"
!

store:something
    "what really should this do"

    self nextPutAll:something storeString
! !

!FileStream methodsFor:'error handling'!

openError:errorNumber
    "report an error, that file open failed"

    "This has changed from previous releases:
     in earlier versions of ST/X, failed file open operations
     returned nil - now, an error is raised.
     The old behavior is simulated by providing an exception
     handler, which proceeds with nil:

	OpenError ignoreIn:[
	    'old code expecting nil return values on errors when doing an open'.

	    ('/dasGIBtEsbeStimmtNiChT' asFilename readStream) isNil ifTrue:[
		self warn:'open failed'.
	    ].
	]
    "

    "{ Pragma: +optSpace }"

    LastErrorNumber := errorNumber.
    ^ super openError:errorNumber.

    "
     '/dasGIBtEsbeStimmtNiChT' asFilename readStream
    "
! !

!FileStream methodsFor:'finalization'!

executor
    |executor|

    executor := super executor.
    "keep the pathname for any FileStream"
    executor setPathName:pathName removeOnClose:removeOnClose.
    ^ executor
! !


!FileStream methodsFor:'misc functions'!

copyToEndInto:outStream bufferSize:bufferSize
    "copy the data into another stream."

    |pos n nWritten|

    "the sendfile() system call currently (2004-05-07) handles only descriptors that
     support mmap-like operations as from-fd.
     Therefore, this method is reimplemented here (from ExternalStream)"

    outStream isExternalStream ifTrue:[
        pos := self position.
        n := self size - pos.
        nWritten := OperatingSystem
                        copyFromFd:self fileHandle
                        toFd:outStream fileHandle
                        startIndex:pos
                        count:n.
        nWritten > 0 ifTrue:[
            self position:pos+nWritten.
        ].
        nWritten = n ifTrue:[
            ^ self
        ].
    ].
    ^ super copyToEndInto:outStream bufferSize:bufferSize.

    "
     |in out|

     in := 'Makefile' asFilename readStream.
     out := Stdout.
     in copyToEndInto:out.
     in close.
    "
!

syncFileSystem
    "sync the filesystem containing this FileStream"

    OperatingSystem syncFileSystem:handle.
!

truncateTo:newSize
    "truncate the underlying OS file to newSize.
     Warning: this may not be implemented on all platforms."

%{
#ifdef HAS_FTRUNCATE
    OBJ fp = __INST(handle);
    FILE *f;
    off_t truncateSize;

    if ((fp != nil) && (__INST(mode) != @symbol(readonly))) {
	if (__isSmallInteger(newSize)) {
	    truncateSize = __intVal(newSize);
	    if (truncateSize < 0) {
		goto getOutOfHere;
	    }
	} else {
	    truncateSize = __signedLongIntVal(newSize);
	    if (truncateSize < 0) {
		goto getOutOfHere;
	    }
	    if (truncateSize == 0) {
		if (sizeof(truncateSize) == 8) {
		    if (__signedLong64IntVal(newSize, &truncateSize) == 0 || truncateSize < 0) {
			goto getOutOfHere;
		    }
		} else {
		    goto getOutOfHere;
		}
	    }
	}

	f = __FILEVal(fp);

	if (__INST(buffered) == true) {
	    fflush(f);
	    fseek(f, 0L, SEEK_END); /* needed in stdio */
	}
	ftruncate(fileno(f), truncateSize);
	RETURN (self);
    }
getOutOfHere: ;
#endif
%}.
    handle isNil ifTrue:[self errorNotOpen. ^ self].
    (mode == #readonly) ifTrue:[self errorReadOnly. ^ self].
    newSize < 0 ifTrue:[
	self error:'wrong arg'.
    ].
    self errorUnsupportedOperation

    "
     |f s|

     f := 'testTTTT' asFilename.
     s := f writeStream.
     s next:1000 put:$a.
     s truncateTo:100.
     s close.

     Transcript showCR:(f fileSize).
     f remove.
    "
! !

!FileStream methodsFor:'positioning'!

position
    "return the read/write position in the file"

    |error|
%{
    HFILE f;
    off_t currentPosition;

    if (__INST(handle) != nil) {
	do {
	    f = __FILEVal(__INST(handle));
#ifdef __win32__
	    __threadErrno = 0;
	    if (__INST(buffered) == true) {
# if 0
		currentPosition = STX_C_CALL1( "ftell", ftell, f);
# else
		currentPosition = ftell(f);
		__threadErrno = errno;
# endif
	    } else {
		OBJ rA = __INST(readAhead);
		off_t offs = 0;

		if (rA != nil) {
		    __INST(readAhead) = nil;
		    offs = -1;
		}
# if 0
		currentPosition = STX_C_CALL3( "lseek", lseek, fileno(f), offs, SEEK_CUR);
# else
		currentPosition = lseek(fileno(f), offs, SEEK_CUR);
		__threadErrno = errno;
# endif
	    }
#else /* !__win32__ */
	    if (__INST(buffered) == true) {
#ifdef _LFS_LARGEFILE
		currentPosition = ftello(f);
#else
		currentPosition = ftell(f);
#endif /* ! _LFS_LARGEFILE */
	    } else {
		if (sizeof(off_t) == 8) {
                    currentPosition = lseek64(fileno(f), (off_t)0, SEEK_CUR);
                } else {
                    currentPosition = lseek(fileno(f), (off_t)0, SEEK_CUR);
                }
            }
#endif /* !WIN32 */
	} while ((currentPosition < 0) && (__threadErrno == EINTR));

	if (currentPosition >= 0) {
	    OBJ rslt;

	    if (sizeof(currentPosition) == 8) {
		rslt = __MKINT64 (&currentPosition);
	    } else {
		rslt = __MKINT(currentPosition);
	    }
	    RETURN ( rslt );
	}
	error = __mkSmallInteger(__threadErrno);
    }
%}.
    error notNil ifTrue:[
	lastErrorNumber := error.
	^ self ioError:error.
    ].
    handle isNil ifTrue:[^ self errorNotOpen].
    ^ self primitiveFailed
!

position:newPos
    "set the read/write position in the file"

    |rslt error|
%{
    HFILE f;
    long ret;
    OBJ fp;

    if ((__INST(canPosition) != false) || (newPos == __mkSmallInteger(0))) {
	if ((fp = __INST(handle)) != nil) {

#if defined(_LFS_LARGE_FILE) && !defined(__win32__)
# define FSEEK fseeko
	    off_t nP;
#else
#define FSEEK fseek
	    long nP;
#endif

	    if (__isSmallInteger(newPos)) {
		nP = __intVal(newPos);
		if (nP < 0) {
		    __INST(lastErrorNumber) = __mkSmallInteger(EINVAL);
		    goto getOutOfHere;
		}
	    } else {
		nP = __signedLongIntVal(newPos);
		if (nP < 0) {
		    __INST(lastErrorNumber) = __mkSmallInteger(EINVAL);
		    goto getOutOfHere;
		}
		if (nP == 0) {
		    if (sizeof(nP) == 8) {
			if (__signedLong64IntVal(newPos, &nP) == 0 || nP < 0) {
			    __INST(lastErrorNumber) = __mkSmallInteger(EINVAL);
			    goto getOutOfHere;
			}
		    } else {
			__INST(lastErrorNumber) = __mkSmallInteger(EINVAL);
			goto getOutOfHere;
		    }
		}
	    }

	    f = __FILEVal(fp);

	    do {
#if defined(DO_WRAP_CALL_FSEEK)
		__threadErrno = 0;
		if (__INST(buffered) == true) {
		    ret = STX_C_CALL3( "fseek", fseek, f, nP, SEEK_SET);
		} else {
		    __INST(readAhead) = nil;
		    ret = STX_C_CALL3( "lseek", lseek, fileno(f), nP, SEEK_SET);
		}
#else
		if (__INST(buffered) == true) {
		    ret = FSEEK(f, nP, SEEK_SET);
		} else {
 #if !defined(__BORLANDC__)                
                    if (sizeof(nP) == 8)
                        ret = lseek64(fileno(f), nP, SEEK_SET);
                    else
#endif
		    ret = lseek(fileno(f), nP, SEEK_SET);
		}
		__threadErrno = errno;
#endif
	    } while ((ret < 0) && (__threadErrno == EINTR));
	    if (ret >= 0) {
		__INST(position) = newPos; __STORE(self, newPos);
		/*
		 * just to make certain ...
		 */
		__INST(hitEOF) = false;
		RETURN ( self );
	    }
	    error = __mkSmallInteger(__threadErrno);
	}
    }
    getOutOfHere: ;
#undef FSEEK
%}.
    canPosition == false ifTrue:[
	"/ position by rewinding & re-reading everything up-to
	"/ that point.
	^ self slowPosition:newPos
    ].
    error notNil ifTrue:[
	lastErrorNumber := error.
	(OperatingSystem errorSymbolForNumber:error) == #EINVAL ifTrue:[
	    "/ invalid position
	    ^ self positionError.
	].
	"/ assume I/O error
	^ self ioError:error.
    ].
    handle isNil ifTrue:[^ self errorNotOpen].

    rslt := self positionFile:handle position:newPos.
    rslt >= 0 ifTrue:[
	position := newPos.
    ] ifFalse:[
	hitEOF := true.
    ]
!

reset
    "additionaly to setting the position to the beginning of the file,
     re-open a previously closed file. This behavior is compatible
     with other Smalltalk dialects"

    handle isNil ifTrue:[
	"reopen the file"
	mode == #readonly ifTrue: [
	    self openForReading
	] ifFalse:[mode == #writeonly ifTrue: [
	    self openForWriting.
	] ifFalse:[
	    self openForReadWrite.
	]].
    ] ifFalse:[
	super reset.
    ].
!

setToEnd
    "set the read/write position in the file to be at the end of the file"

    |error|
%{
    HFILE f;
    off_t ret;

    if (__INST(handle) != nil) {
	f = __FILEVal(__INST(handle));
	__INST(position) = nil;    /* i.e. unknown */
	do {
#ifdef __win32__
	    __threadErrno = 0;
	    if (__INST(buffered) == true) {
		ret = STX_C_CALL3( "fseek", fseek, f, 0L, SEEK_END);
	    } else {
		__INST(readAhead) = nil;
		ret = STX_C_CALL3( "lseek", lseek, fileno(f), 0L, SEEK_END);
	    }
#else
	    if (__INST(buffered) == true) {
# ifdef _LFS_LARGE_FILE
		ret = fseeko(f, (off_t)0, SEEK_END);
# else
		ret = fseek(f, 0L, SEEK_END);
# endif
	    } else {
                if (sizeof(off_t) == 8) {
                    ret = lseek64(fileno(f), (off_t)0, SEEK_END);
                } else {
		ret = lseek(fileno(f), (off_t)0, SEEK_END);
                }
	    }
#endif
	} while ((ret < 0) && (__threadErrno == EINTR));
	if (ret >= 0) {
	    RETURN ( self );
	}
	error = __mkSmallInteger(__threadErrno);
    }
%}.
    error notNil ifTrue:[
	lastErrorNumber := error.
	self ioError:error.
	^ self.
    ].
    handle isNil ifTrue:[^ self errorNotOpen].
    ^ self primitiveFailed
!

slowPosition:newPos
    "position the file by re-reading everything up-to newPos.
     The effect is the same as that of #position:, but its much slower.
     This is required to reposition nonPositionable streams, such
     as tape-streams or variable-record-RMS files under VMS.
     Caveat:
	 This should really be done transparently by the stdio library."

    |buffer amount pos0Based|

    self isReadable ifFalse:[
	"/ sorry
	^ self positionError
    ].

    buffer := ByteArray new:8*1024.

    (position isNil "/ i.e. unknown
    or:[newPos < (pos0Based := self position)]) ifTrue:[
	self reset.
	pos0Based := self position.
    ].
    [pos0Based < newPos] whileTrue:[
	amount := (buffer size) min:(newPos-pos0Based).
	(self nextBytes:amount into:buffer startingAt:1) ~~ amount ifTrue:[
	    ^ self positionError
	].
	pos0Based := self position.
    ].
    "/ ('FileStream [info]: slow position - please convert ''' , pathName printString , ''' to streamLF format') infoPrintCR.
! !

!FileStream methodsFor:'printing & storing'!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    aStream nextPutAll:self className,'(for: '.
    pathName printOn:aStream.
    aStream nextPut:$).

    "
	'/' asFilename readStream printString
    "
!

storeOn:aStream
    "append a representation of the receiver to aStream,
     from which a copy can be reconstructed later."

    aStream nextPutAll:'(FileStream oldFileNamed:'.
    aStream nextPutAll:pathName storeString.
    (self position ~~ 0) ifTrue:[
	aStream nextPutAll:'; position:'.
	self position storeOn:aStream
    ].
    aStream nextPut:$)

    "Modified: 30.7.1997 / 16:43:50 / cg"
! !

!FileStream protectedMethodsFor:'private'!

closeFile
    "low level close - may be redefined in subclasses.
     Don't send this message, send #close instead"

    super closeFile.
    removeOnClose == true ifTrue:[
	pathName asFilename remove.
    ]

    "Created: / 13.8.1998 / 12:11:22 / cg"
! !

!FileStream methodsFor:'private'!

createForReadWrite
    "create/truncate the file for read/write.
     If the file existed, it's truncated; otherwise it's created."

    mode := #readwrite.
    ^ self openWithMode:CreateReadWriteMode
!

createForWriting
    "create/truncate the file for writeonly.
     If the file existed, it's truncated; otherwise it's created."

    mode := #writeonly.
    didWrite := true.
    ^ self openWithMode:WriteMode
!

openFile:pathName withMode:openmode attributes:attributeSpec
    "open the file;
     openmode is the string defining the way to open as defined by the stdio library
     (i.e. the 2nd fopen argument).

     attributeSpec is an additional argument, only used with VMS - it allows a file to
     be created as fixedRecord, variableRecord, streamLF, streamCR, ...
     In VMS, if nonNil, it must consist of an array of strings (max:10), giving additional
     attributes (see fopen description).
     Passing a nil specifies the default format (streamLF) - ST/X always invokes this with nil.
     This argument is ignored in UNIX & MSDOS systems.

     This is a private entry, but maybe useful to open/create a file in a special mode,
     which is proprietrary to the operatingSystem."

    |wasBlocked encodedPathName error|

    encodedPathName := OperatingSystem encodePath:pathName.

%{
    HFILE f = NULL;
    enum {
    	PASS_INITIAL = 1,
    	PASS_RETRY_AFTER_SCAVENGE = 2,
    	PASS_RETRY_AFTER_GARBAGE_COLLECT = 3,
    	PASS_FINAL = PASS_RETRY_AFTER_GARBAGE_COLLECT
    } pass = PASS_INITIAL;

    if (!__isNonNilObject(encodedPathName)
        || !(__isStringLike(openmode) || __isArrayLike(openmode)))
            goto badArgument;

retry:
#ifdef __VMS__
      if (__isStringLike(encodedPathName)) {
        do {
            /*
             * allow passing additional RMS arguments.
             * stupid: DEC does not seem to offer an interface for passing a char **.
             */
            __threadErrno = 0;

            {
                if (__isArray(attributeSpec)) {
                    OBJ *ap = __ArrayInstPtr(attributeSpec)->a_element;
                    int numAttrib = 0;
                    int i;

                    numAttrib = __arraySize(attributeSpec);
                    for (i=0; i<numAttrib;i++) {
                        if (! __isStringLike(ap[i])) {
                            __threadErrno = EINVAL; /* invalid argument */
                            goto getOutOfHere;
                        }
                    }
                    switch (numAttrib) {
                        case 0:
                            __BEGIN_INTERRUPTABLE__
                            f = fopen((char *)__stringVal(pathName), (char *)__stringVal(openmode));
                            __END_INTERRUPTABLE__
                            break;
                        case 1:
                            __BEGIN_INTERRUPTABLE__
                            f = fopen((char *)__stringVal(pathName), (char *)__stringVal(openmode),
                                      __stringVal(ap[0]));
                            __END_INTERRUPTABLE__
                            break;
                        case 2:
                            __BEGIN_INTERRUPTABLE__
                            f = fopen((char *)__stringVal(pathName), (char *)__stringVal(openmode),
                                      __stringVal(ap[0]), __stringVal(ap[1]));
                            __END_INTERRUPTABLE__
                            break;
                        case 3:
                            __BEGIN_INTERRUPTABLE__
                            f = fopen((char *)__stringVal(pathName), (char *)__stringVal(openmode),
                                      __stringVal(ap[0]), __stringVal(ap[1]), __stringVal(ap[2]));
                            __END_INTERRUPTABLE__
                            break;
                        case 4:
                            __BEGIN_INTERRUPTABLE__
                            f = fopen((char *)__stringVal(pathName), (char *)__stringVal(openmode),
                                      __stringVal(ap[0]), __stringVal(ap[1]), __stringVal(ap[2]),
                                      __stringVal(ap[3]));
                            __END_INTERRUPTABLE__
                            break;
                        case 5:
                            __BEGIN_INTERRUPTABLE__
                            f = fopen((char *)__stringVal(pathName), (char *)__stringVal(openmode),
                                      __stringVal(ap[0]), __stringVal(ap[1]), __stringVal(ap[2]),
                                      __stringVal(ap[3]), __stringVal(ap[4]));
                            __END_INTERRUPTABLE__
                            break;
                        case 6:
                            __BEGIN_INTERRUPTABLE__
                            f = fopen((char *)__stringVal(pathName), (char *)__stringVal(openmode),
                                      __stringVal(ap[0]), __stringVal(ap[1]), __stringVal(ap[2]),
                                      __stringVal(ap[3]), __stringVal(ap[4]), __stringVal(ap[5]));
                            __END_INTERRUPTABLE__
                            break;
                        case 7:
                            __BEGIN_INTERRUPTABLE__
                            f = fopen((char *)__stringVal(pathName), (char *)__stringVal(openmode),
                                      __stringVal(ap[0]), __stringVal(ap[1]), __stringVal(ap[2]),
                                      __stringVal(ap[3]), __stringVal(ap[4]), __stringVal(ap[5]),
                                      __stringVal(ap[6]));
                            __END_INTERRUPTABLE__
                            break;
                        case 8:
                            __BEGIN_INTERRUPTABLE__
                            f = fopen((char *)__stringVal(pathName), (char *)__stringVal(openmode),
                                      __stringVal(ap[0]), __stringVal(ap[1]), __stringVal(ap[2]),
                                      __stringVal(ap[3]), __stringVal(ap[4]), __stringVal(ap[5]),
                                      __stringVal(ap[6]), __stringVal(ap[7]));
                            __END_INTERRUPTABLE__
                            break;
                        case 9:
                            __BEGIN_INTERRUPTABLE__
                            f = fopen((char *)__stringVal(pathName), (char *)__stringVal(openmode),
                                      __stringVal(ap[0]), __stringVal(ap[1]), __stringVal(ap[2]),
                                      __stringVal(ap[3]), __stringVal(ap[4]), __stringVal(ap[5]),
                                      __stringVal(ap[6]), __stringVal(ap[7]), __stringVal(ap[8]));
                            __END_INTERRUPTABLE__
                            break;
                        case 10:
                            __BEGIN_INTERRUPTABLE__
                            f = fopen((char *)__stringVal(pathName), (char *)__stringVal(openmode),
                                      __stringVal(ap[0]), __stringVal(ap[1]), __stringVal(ap[2]),
                                      __stringVal(ap[3]), __stringVal(ap[4]), __stringVal(ap[5]),
                                      __stringVal(ap[6]), __stringVal(ap[7]), __stringVal(ap[8]),
                                      __stringVal(ap[9]));
                            __END_INTERRUPTABLE__
                            break;
                        default:
                            __threadErrno = E2BIG; /* too many args */
                            goto getOutOfHere;
                    }
                } else if (attributeSpec != nil) {
                    __threadErrno = EINVAL; /* invalid argument */
                    goto getOutOfHere;
                } else {
                    /*
                     * create file as sequential streamLF by default.
                     */
                    __BEGIN_INTERRUPTABLE__
                    f = fopen((char *)__stringVal(pathName), (char *)__stringVal(openmode), "rfm=stmlf");
                    __END_INTERRUPTABLE__
                }
            }
        } while ((f == NULL) && (__threadErrno == EINTR));
      }
#else /* not VMS */

# ifdef __win32__
    {
          DWORD share = 0, access = 0, create = 0, attr = 0;
          char * __openmode;
          HANDLE handle;
          SECURITY_ATTRIBUTES sa;

          if (__isStringLike(openmode)) {
              share = FILE_SHARE_READ|FILE_SHARE_WRITE;
              __openmode = __stringVal(openmode);
              if (strcmp(__openmode, "rb") == 0) {
                  access = GENERIC_READ;
                  create = OPEN_EXISTING;
              } else if (strcmp(__openmode, "rb+") == 0) {
                  access = GENERIC_READ | GENERIC_WRITE;
                  create = OPEN_EXISTING;
              } else if (strcmp(__openmode, "wb") == 0) {
                  access = GENERIC_WRITE;
                  create = CREATE_ALWAYS;
              } else if (strcmp(__openmode, "wb+") == 0) {
                  access = GENERIC_READ | GENERIC_WRITE;
                  create = CREATE_ALWAYS;
              } else if (strcmp(__openmode, "ab") == 0) {
                  access = FILE_APPEND_DATA|FILE_WRITE_ATTRIBUTES|FILE_WRITE_EA|
                                STANDARD_RIGHTS_WRITE|SYNCHRONIZE;
                  create = OPEN_ALWAYS;
              } else if (strcmp(__openmode, "ab+") == 0) {
                  access = GENERIC_READ |FILE_APPEND_DATA|FILE_WRITE_ATTRIBUTES|FILE_WRITE_EA|
                                STANDARD_RIGHTS_WRITE|SYNCHRONIZE;
                  create = OPEN_ALWAYS;
              } else {
                  console_fprintf(stderr, "Win32OS [warning]: unsupported open mode\n");
              }
          } else if (__isArrayLike(openmode)) {
              OBJ *ap = __arrayVal(openmode);
              int numAttrib = __arraySize(openmode);
              int i;

              __openmode = "rb+";

              for (i=0; i<numAttrib; i++) {
                  OBJ attrSym = ap[i];

                  if (attrSym == @symbol(FILE_SHARE_READ)) {
                      share |= FILE_SHARE_READ;
                  } else if (attrSym == @symbol(FILE_SHARE_WRITE)) {
                      share |= FILE_SHARE_WRITE;

                  } else if (attrSym == @symbol(GENERIC_READ)) {
                      access |= GENERIC_READ;
                  } else if (attrSym == @symbol(GENERIC_WRITE)) {
                      access |= GENERIC_WRITE;
                  } else if (attrSym == @symbol(GENERIC_READ_WRITE)) {
                      access |= GENERIC_READ|GENERIC_WRITE;

                  } else if (attrSym == @symbol(CREATE_NEW)) {
                      create |= CREATE_NEW;
                  } else if (attrSym == @symbol(CREATE_ALWAYS)) {
                      create |= CREATE_ALWAYS;
                  } else if (attrSym == @symbol(OPEN_EXISTING)) {
                      create |= OPEN_EXISTING;
                  } else if (attrSym == @symbol(OPEN_ALWAYS)) {
                      create |= OPEN_ALWAYS;
                  } else if (attrSym == @symbol(TRUNCATE_EXISTING)) {
                      create |= TRUNCATE_EXISTING;

                  } else if (attrSym == @symbol(FILE_ATTRIBUTE_HIDDEN)) {
                      attr |= FILE_ATTRIBUTE_HIDDEN;
                  } else if (attrSym == @symbol(FILE_ATTRIBUTE_READONLY)) {
                      attr |= FILE_ATTRIBUTE_READONLY;
                  } else if (attrSym == @symbol(FILE_FLAG_WRITE_THROUGH)) {
                      attr |= FILE_FLAG_WRITE_THROUGH;
                  } else if (attrSym == @symbol(FILE_FLAG_SEQUENTIAL_SCAN)) {
                      attr |= FILE_FLAG_SEQUENTIAL_SCAN;
                  } else if (attrSym == @symbol(FILE_FLAG_DELETE_ON_CLOSE)) {
                      attr |= FILE_FLAG_DELETE_ON_CLOSE;
                  } else if (!__isSymbol(attrSym) && __isStringLike(attrSym)) {
                      __openmode = __stringVal(attrSym);
                  } else {
                      console_fprintf(stderr, "Win32OS [warning]: unsupported open mode\n");
                  }
              }
          }
          if (create == 0) {
//              argumentError = @symbol(missingCreateMode);
              goto badArgument;
          }
          if (attr == 0) {
              attr = FILE_ATTRIBUTE_NORMAL;
          }

          /*
           * create security attributes - make handle inheritable by subprocesses
           */
          memset(&sa, 0, sizeof (sa));
          sa.nLength = sizeof( sa );
          // sa.bInheritHandle = TRUE;
          sa.bInheritHandle = FALSE;

          if (__isStringLike(pathName)) {
                char _aPathName[MAXPATHLEN];

                strncpy(_aPathName, __stringVal(pathName), MAXPATHLEN-1); _aPathName[MAXPATHLEN-1] = '\0';
                do {
                    __threadErrno = 0;
                    handle = STX_API_NOINT_CALL7( "CreateFileA", CreateFileA, _aPathName, access, share, &sa, create, attr, 0 /* hTempl */);
                    if (__threadErrno == EINTR) {
                        handle = INVALID_HANDLE_VALUE;
                    }
                } while ((handle == INVALID_HANDLE_VALUE) && (__threadErrno == EINTR));
          } else if (__isUnicode16String(pathName)) {
                wchar_t _aPathName[MAXPATHLEN+1];
                int i, l;

                l = __unicode16StringSize(pathName);
                if (l > MAXPATHLEN) l = MAXPATHLEN;
                for (i=0; i<l; i++) {
                    _aPathName[i] = __unicode16StringVal(pathName)[i];
                }
                _aPathName[i] = 0;

                do {
                    __threadErrno = 0;
                    handle = STX_API_NOINT_CALL7( "CreateFileW", CreateFileW, _aPathName, access, share, &sa, create, attr, 0 /* hTempl */);
                    if (__threadErrno == EINTR) {
                        handle = INVALID_HANDLE_VALUE;
                    }
                } while ((handle == INVALID_HANDLE_VALUE) && (__threadErrno == EINTR));
          }
          if (handle != INVALID_HANDLE_VALUE) {
              int fd;
              extern void __stxWrapApiEnterCritical(), __stxWrapApiLeaveCritical();

              __stxWrapApiEnterCritical();
              fd = _open_osfhandle((long)handle, O_BINARY);
              if (fd < 0) {
                  if (__threadErrno == 0) {
                      // no more file descriptors
                      __threadErrno = EMFILE;
                  }
                  CloseHandle(handle);
              } else {
                  f = fdopen(fd, __openmode);
              }
              __stxWrapApiLeaveCritical();
          }  else {
            __threadErrno = __WIN32_ERR(GetLastError());
          }
      }
# else /* not WIN32 */

      if (__isStringLike(encodedPathName)) {
          int accessMode = 0666;        // default access mode of fopen(), relies on umask()
          int flags = 0;
          int fd;
          char * __openmode;

          if (__isStringLike(openmode)) {
              __openmode = __stringVal(openmode);
              if (strcmp(__openmode, "r") == 0) {
                  flags = O_RDONLY;
              } else if (strcmp(__openmode, "r+") == 0) {
                  flags = O_RDWR;
              } else if (strcmp(__openmode, "w") == 0) {
                  flags = O_WRONLY | O_CREAT | O_TRUNC;
              } else if (strcmp(__openmode, "w+") == 0) {
                  flags = O_RDWR | O_CREAT | O_TRUNC;
              } else if (strcmp(__openmode, "a") == 0) {
                  flags = O_WRONLY | O_CREAT | O_APPEND;
              } else if (strcmp(__openmode, "a+") == 0) {
                  flags = O_RDWR | O_CREAT| O_APPEND;
              } else {
                  console_fprintf(stderr, "UNIXOS [warning]: unsupported open mode\n");
              }
          } else if (__isArrayLike(openmode)) {
              OBJ *ap = __arrayVal(openmode);
              int numAttrib = __arraySize(openmode);
              int i;

              __openmode = "r+";

              for (i=0; i<numAttrib; i++) {
                  OBJ attrSym = ap[i];

                  if (attrSym == @symbol(FILE_SHARE_READ)) {
                      // ignore
                  } else if (attrSym == @symbol(FILE_SHARE_WRITE)) {
                     // ignore
                  } else if (attrSym == @symbol(GENERIC_READ)) {
                      flags |= O_RDONLY;
                      __openmode = "r";
                  } else if (attrSym == @symbol(GENERIC_WRITE)) {
                      flags |= O_WRONLY;
                      __openmode = "w";
                  } else if (attrSym == @symbol(GENERIC_READ_WRITE)) {
                      flags |= O_RDWR;
                      __openmode = "r+";
                  } else if (attrSym == @symbol(CREATE_NEW)) {
                      flags |= O_CREAT|O_EXCL;
                      accessMode = 0600;     // simulate mkstemp()
                  } else if (attrSym == @symbol(CREATE_ALWAYS)) {
                      flags |= O_CREAT|O_TRUNC;
                  } else if (attrSym == @symbol(OPEN_EXISTING)) {
                      // nothing to be set
                  } else if (attrSym == @symbol(OPEN_ALWAYS)) {
                      flags |= O_CREAT;
                  } else if (attrSym == @symbol(TRUNCATE_EXISTING)) {
                      flags |= O_TRUNC;

                  } else if (attrSym == @symbol(FILE_ATTRIBUTE_HIDDEN)) {
                      // ignore
                  } else if (attrSym == @symbol(FILE_ATTRIBUTE_READONLY)) {
                      accessMode &= 0444;
                  } else if (attrSym == @symbol(FILE_FLAG_WRITE_THROUGH)) {
#ifdef O_DIRECT
                      flags |= O_DIRECT;
#endif
                  } else if (attrSym == @symbol(FILE_FLAG_SEQUENTIAL_SCAN)) {
                      // ignore
                  } else if (attrSym == @symbol(FILE_FLAG_DELETE_ON_CLOSE)) {
                      // ignore;
                  } else if (!__isSymbol(attrSym) && __isStringLike(attrSym)) {
                      __openmode = __stringVal(attrSym);
                  } else {
                      console_fprintf(stderr, "UNIXOS [warning]: unsupported open mode\n");
                  }
              }
          }
          do {
              __BEGIN_INTERRUPTABLE__
              fd = open((char *) __stringVal(encodedPathName), flags, accessMode);
              __END_INTERRUPTABLE__
          } while ((fd < 0) && (__threadErrno == EINTR));

          if (fd >= 0) {
              __threadErrno = 0;
              f = fdopen(fd, __openmode);
              if (f == NULL) {
                  close(fd);            // fdopen failed, close before retry.
              }
          }
      }

# endif /* not WIN32 */
#endif /* not VMS */


    if (f == NULL) {
        /*
         * If no filedescriptors available, try to finalize
         * possibly collected fd's and try again.
         */
        if ((__threadErrno == ENFILE || __threadErrno == EMFILE) && pass < PASS_FINAL) {
            switch (pass) {
            	case PASS_INITIAL:
            	    {
            	        pass = PASS_RETRY_AFTER_SCAVENGE;
            	        __SSEND0(@global(ObjectMemory), @symbol(scavenge), 0);	    
            	        __SSEND0(@global(ObjectMemory), @symbol(finalize), 0);
            	    }
            	    goto retry;
                case PASS_RETRY_AFTER_SCAVENGE:
                    {
            	        pass = PASS_RETRY_AFTER_GARBAGE_COLLECT;
            	        __SSEND0(@global(ObjectMemory), @symbol(garbageCollect), 0);	    
            	        __SSEND0(@global(ObjectMemory), @symbol(finalize), 0);
            	    }
            	    goto retry;
            	case PASS_RETRY_AFTER_GARBAGE_COLLECT:
            	    /* Should never be reached */
            	    goto getOutOfHere;
            }            
        }
    badArgument:
    getOutOfHere:
        error = __mkSmallInteger(__threadErrno);
        __INST(position) = nil;
    } else {
#ifdef __VMS__
        /*
         * check to see if this is positionable ...
         */
        __INST(canPosition) = false;
# ifndef _POSIX_C_SOURCE
        {
            struct stat statBuffer;

            if (fstat(fileno(f), &statBuffer) >= 0) {
                switch (statBuffer.st_fab_rfm) {
                    case FAB$C_UDF: /* undefined (also stream binary)   */
                    case FAB$C_VAR: /* variable length records          */
                    case FAB$C_VFC: /* variable fixed control           */
                    case FAB$C_STM: /* RMS-11 stream (valid only for sequen) */
                    default:
                        __INST(canPosition) = false;
                        break;

                    case FAB$C_FIX: /* fixed length records             */
                    case FAB$C_STMLF: /* LF stream (valid only for sequential) */
                    case FAB$C_STMCR: /* CR stream (valid only for sequential) */
                        __INST(canPosition) = true;
                        break;
                }
            }
        }
# endif
#else /* not VMS */
        __INST(canPosition) = true;
#endif /* not VMS */

        if (@global(FileOpenTrace) == true) {
            console_fprintf(stderr, "fopen %s [FileStream] -> %"_lx_"\n", __stringVal(pathName), (INT)f);
        }
        if (f != NULL) {
            OBJ fp;

            wasBlocked = __BLOCKINTERRUPTS();
#if 0
            // The original code was:
            __INST(handle) = fp = __MKEXTERNALADDRESS(f); __STORE(self, fp);
            // but for that, gcc generates wrong code, which loads self (volatile) into
            // a register (bp), then calls __MKEXTERNALADDRESS, then stores indirect bp.
            // That is wrong if a scavenge occurs in __MKEXTERNALADDRESS, as bp is now still pointing to the old
            // object.
#else
            fp = __MKEXTERNALADDRESS(f);
            __INST(handle) = fp;
            __STORE(self, fp);
#endif
        }
    }
%}.
    error notNil ifTrue:[
        lastErrorNumber := error.
        ^ self openError:error.
    ].
    handle isNil ifTrue:[
        ^ self openError:0.
    ].

    buffered := true.   "default is buffered"
    position := 0.
    handleType := #filePointer.
    self registerForFinalization.
    wasBlocked == false ifTrue:[OperatingSystem unblockInterrupts].
    ^ handle
!

openForAppending
    "open the file for writeonly appending to the end.
     If the file does not exist, raise OpenError;
     otherwise return the receiver."

    mode := #writeonly.
    didWrite := true.
    ^ self openWithMode:AppendMode
!

openForReadWrite
    "open the file for read/write.
     If the file does not exist, raise OpenError;
     otherwise return the receiver."

    mode := #readwrite.
    ^ self openWithMode:ReadWriteMode
!

openForReading
    "open the file for readonly.
     If the file does not exist, raise OpenError;
     otherwise return the receiver."

    mode := #readonly.
    didWrite := false.
    ^ self openWithMode:ReadMode
!

openForWriting
    "open the file writeonly. The contents of the file is preserved.
     If the file does not exist, raise OpenError;
     otherwise return the receiver."

    mode := #writeonly.
    didWrite := true.
    "we must not truncate the file!! So do not use WriteMode"
    ^ self openWithMode:ReadWriteMode
!

openWithMode:openmode
    "open the file;
     openmode is the string defining the way to open as defined by the stdio library
     (i.e. the 2nd fopen argument).

     This is a private entry, but maybe useful to open a file in a special mode,
     which is proprietrary to the operatingSystem."

    ^ self openWithMode:openmode attributes:nil
!

openWithMode:openmode attributes:attributeSpec
    "open the file;
     openmode is the string defining the way to open as defined by the stdio library
     (i.e. the 2nd fopen argument).

     attributeSpec is an additional argument, only used with VMS - it allows a file to
     be created as fixedRecord, variableRecord, streamLF, streamCR, ...
     In VMS, if nonNil, it must consist of an array of strings (max:10), giving additional
     attributes (see fopen description).
     Passing a nil specifies the default format (streamLF) - ST/X always invokes this with nil.
     This argument is ignored in UNIX & MSDOS systems.

     This is a private entry, but maybe useful to open/create a file in a special mode,
     which is proprietrary to the operatingSystem."

    handle notNil ifTrue:[^ self errorAlreadyOpen].

    handle := self openFile:pathName withMode:openmode attributes:attributeSpec.
    handle isNil ifTrue:[
        "this happens, if proceeding from an OpenError raised in #openFile..."
        ^ nil.
    ].
!

pathName:filename
    "set the pathname"

    pathName := filename asString

    "Modified: / 28.10.1997 / 14:29:01 / cg"
!

pathName:filename in:aDirectory
    "set the pathname starting at aDirectory, a FileDirectory"

    pathName := aDirectory asFilename constructString:filename

    "Modified: / 28.10.1997 / 14:28:54 / cg"
!

reOpen
    "USERS WILL NEVER INVOKE THIS METHOD
     sent after snapin to reopen streams."

    handle notNil ifTrue:[
	"it was open, when snapped-out"
	handle := nil.
	self unregisterForFinalization.
	pathName isNil ifTrue:[
	    ^ self.
	].
	[
	    |oldPos|

	    "should take care of appending files and open them for
	     append / position them to the end"

	    oldPos := position.

	    mode == #readonly ifTrue: [
		self openForReading
	    ] ifFalse:[mode == #writeonly ifTrue: [
		self openForWriting.
	    ] ifFalse:[
		self openForReadWrite.
	    ]].

	    oldPos notNil ifTrue:[
		self position:oldPos.
	    ]
	] on:OpenError do:[:ex|
	    "this happens, if after a restart,
	     the file is no longer present or accessible ..."

	    (self class name , ' [warning]: could not reopen file: ', pathName) errorPrintCR.
	].
    ]

    "Modified: 10.1.1997 / 17:50:51 / cg"
!

setMode:aModeSymbol
    mode := aModeSymbol
!

setPathName:pathNameString removeOnClose:aBoolean
    pathName := pathNameString.
    removeOnClose := aBoolean.
! !

!FileStream methodsFor:'private fileIn'!

fileInNotifying:notifiedLoader passChunk:passChunk
    "central method to file in from the receiver, i.e. read chunks and evaluate them -
     return the value of the last chunk.
     Someone (which is usually some codeView) is notified of errors."

    ^ self fileInNotifying:notifiedLoader passChunk:passChunk inDirectory:(self pathName asFilename directory).
!

fileInNotifying:notifiedLoader passChunk:passChunk inDirectory:aDirectory
    "central method to file in from the receiver, i.e. read chunks and evaluate them -
     return the value of the last chunk.
     Someone (which is usually some codeView) is notified of errors.
     Add aDirectory to the search path for classes, while performing the fileIn."

    |oldPath val thisDirectory thisDirectoryPathName|

    thisDirectory := aDirectory asFilename.
    thisDirectoryPathName := thisDirectory pathName.
    oldPath := Smalltalk systemPath.

    [
	Smalltalk systemPath:(oldPath copy addFirst:thisDirectoryPathName; yourself).
	self class currentFileInDirectoryQuerySignal answer:thisDirectory do:[
	    self class currentSourceContainerQuery answer:self do:[
		val := self basicFileInNotifying:notifiedLoader passChunk:passChunk.
	    ].
	]
    ] ensure:[
	"take care, someone could have changed SystemPath during fileIn!!"
	(Smalltalk systemPath copyFrom:2) = oldPath ifTrue:[
	    Smalltalk systemPath:oldPath.
	] ifFalse:[
	    (oldPath includes:thisDirectoryPathName) ifFalse:[
		Smalltalk systemPath remove:thisDirectoryPathName ifAbsent:[].
		Smalltalk flushPathCaches.
	    ].
	].
    ].
    ^ val

    "Modified: / 23-10-2006 / 16:35:10 / cg"
! !

!FileStream methodsFor:'queries'!

collectionSize
    "common stream protocol: return the size of the stream;
     that's the number of bytes of the file."

    ^ self fileSize.
!

fileSize
    "return the size in bytes of the file"

    |error|
%{
    HFILE f;

#ifdef transputer
    unsigned int size;

    if (__INST(handle) != nil) {
	f = __FILEVal(__INST(handle));
	if ((size = filesize(fileno(f))) >= 0) {
	    RETURN ( __MKUINT(size) );
	}
    }
#else
    struct stat buf;
    int ret;
    int fd;

    if (__INST(handle) != nil) {
	f = __FILEVal(__INST(handle));
	fd = fileno(f);
	do {
	    ret = fstat(fd, &buf);
	} while ((ret < 0) && (__threadErrno == EINTR));
	if (ret >= 0) {
	    OBJ rslt;

	    if (sizeof(buf.st_size) == 8) {
		rslt = __MKINT64(&buf.st_size);
	    } else {
		rslt = __MKINT(buf.st_size);
	    }
	    RETURN(rslt);
	}
	error = __mkSmallInteger(__threadErrno);
    }
#endif
%}.

    "could add a fall-back here:

	oldPosition := self position.
	self setToEnd.
	sz := self position.
	self position:oldPosition.
	^ sz
    "
    error notNil ifTrue:[
	lastErrorNumber := error.
	self ioError:error.
	^ self.
    ].
    handle isNil ifTrue:[^ self errorNotOpen].
    ^ self primitiveFailed
!

isDirectory
    ^ OperatingSystem isDirectory:pathName
!

isEmpty
    "common stream protocol: are there no bytes in the file?"

    ^ self fileSize == 0.
!

remainingSize
    "return the number of remaining elements in the streamed collection."

    ^ self fileSize - self position.
!

size
    "common stream protocol: return the size of the stream;
     that's the number of bytes of the file."

    ^ self fileSize.

    "Modified: 4.10.1997 / 18:01:09 / cg"
! !

!FileStream methodsFor:'rel5 protocol'!

positionFile:handle position:newPos
    "for migration to rel5 only"

    self primitiveFailed
! !

!FileStream methodsFor:'testing'!

isFileStream
    "return true, if the receiver is some kind of fileStream.
     redefined from Object"

    ^ true
! !

!FileStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


FileStream initialize!
