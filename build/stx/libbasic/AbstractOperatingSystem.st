"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2016-2017 Jan Vrany
 COPYRIGHT (c) 2017 Patrik Svestka
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

Object subclass:#AbstractOperatingSystem
	instanceVariableNames:''
	classVariableNames:'ConcreteClass ErrorSignal LastErrorNumber LocaleInfo OSSignals
		PipeFailed Resources Language LanguageTerritory LanguageModifier
		LanguageCodeset'
	poolDictionaries:''
	category:'System-Support'
!

Object subclass:#PrinterInfo
	instanceVariableNames:'printerName attributes documentProperties printerInfo2'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractOperatingSystem
!

Object subclass:#TimeInfo
	instanceVariableNames:'year month day hours minutes seconds utcOffset dst milliseconds
		dayInYear dayInWeek'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractOperatingSystem
!

Object subclass:#TimeZoneInfo
	instanceVariableNames:'bias name standardYear standardMonth standardDay standardWeekDay
		standardHour standardMinute standardBias daylightName
		standardDate daylightDate daylightYear daylightMonth daylightDay
		daylightWeekDay daylightHour daylightMinute daylightBias'
	classVariableNames:''
	poolDictionaries:''
	privateIn:AbstractOperatingSystem
!

!AbstractOperatingSystem primitiveDefinitions!
%{

#include "stxOSDefs.h"

%}
! !

!AbstractOperatingSystem class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2016-2017 Jan Vrany
 COPYRIGHT (c) 2017 Patrik Svestka
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
    this class realizes services common to the supported operating systems;
    typically, services which can be implemented based upon more primitive
    functions, or which can be implemented in a portable way (but probably
    less performant) are implemented here.

    [Class variables:]
	ConcreteClass   <Class>         the real OS class

	LocaleInfo      <Dictionary>    if non nil, that is taken instead of the operating
					systems locale definitions (allows for overwriting
					these, or provide a compatible info on systems which do
					not support locales)

	LastErrorNumber <Integer>       the last value of errno

	OSSignals       <Array>         Array of signals to be raised for corresponding
					OperatingSystem signals.

	PipeFailed      <Boolean>       set if a fork (or popen) has failed;
					ST/X will avoid doing more forks/popens
					if this flag is set, for a slightly
					smoother operation.

	ErrorSignal     <Signal>        Parentsignal of all OS error signals.
					not directly raised.

					misc concrete error reporting signals




    [author:]
	Claus Gittinger

    [see also:]
	OSProcessStatus
	Filename Date Time
	ExternalStream FileStream PipeStream Socket
"
!

examples
"
  various queries
								[exBegin]
    Transcript
	showCR:'hello ' , (OperatingSystem getLoginName)
								[exEnd]

								[exBegin]
    OperatingSystem isUNIXlike ifTrue:[
	Transcript showCR:'this is some UNIX-like OS'
    ] ifFalse:[
	Transcript showCR:'this OS is not UNIX-like'
    ]
								[exEnd]

								[exBegin]
    Transcript
	showCR:'this machine is called ' , OperatingSystem getHostName
								[exEnd]

								[exBegin]
    Transcript
	showCR:('this machine is in the '
	       , OperatingSystem getDomainName
	       , ' domain')
								[exEnd]

								[exBegin]
    Transcript
	showCR:('this machine''s CPU is a '
	       , OperatingSystem getCPUType
	       )
								[exEnd]

								[exBegin]
    Transcript showCR:'executing ls command ...'.
    OperatingSystem executeCommand:'ls'.
    Transcript showCR:'... done.'.
								[exEnd]

  locking a file
  (should be executed on two running smalltalks - not in two threads):
								[exBegin]
    |f|

    f := 'testFile' asFilename readWriteStream.

    10 timesRepeat:[
	'about to lock ...' printCR.
	[
	  OperatingSystem
	    lockFD:(f fileDescriptor)
	    shared:false
	    blocking:false
	] whileFalse:[
	    'process ' print. OperatingSystem getProcessId print. ' is waiting' printCR.
	    Delay waitForSeconds:1
	].
	'LOCKED ...' printCR.
	Delay waitForSeconds:10.
	'unlock ...' printCR.
	(OperatingSystem
	    unlockFD:(f fileDescriptor)) printCR.
	Delay waitForSeconds:3.
    ]
								[exBegin]
"
! !

!AbstractOperatingSystem class methodsFor:'initialization'!

getConcreteClass
    "called at early startup to determine the kind of OS we are running on,
     and assigning a concrete subclass of me (remember: I am abstract) to the
     global 'OperatingSystem'.
     Programs should never refer to any of my concrete classes directly, as
     they may not (will not) be present when ST/X is executed under anther OS."

    |osType|

    osType := self getSystemType.
    osType = 'win32' ifTrue:[
	^ Win32OperatingSystem
    ].
    osType = 'osx' ifTrue:[
	^ OSXOperatingSystem
    ].
    osType = 'os2' ifTrue:[
	^ OS2OperatingSystem
    ].
    osType = 'macos' ifTrue:[
	^ MacOperatingSystem
    ].
    ((osType = 'VMS') or:[osType = 'openVMS']) ifTrue:[
	^ OpenVMSOperatingSystem
    ].
    ^ UnixOperatingSystem
!

initResources
    "/ allow for ResourcePack class to be missing (non-GUI smalltalks)

    ResourcePack notNil ifTrue:[
	Error handle:[:ex |
	    'OS [warning]: error when reading resources for libbasic:' errorPrintCR.
	    'OS [info]: 'errorPrint. ex description errorPrintCR.
	    'OS [info]: backtrace: ' errorPrintCR.
	    self withErrorStreamDo:[:s |
		ex suspendedContext fullPrintAllOn:s.
	    ].
	] do:[
	    Resources := ResourcePack forPackage:(self package).
	].
    ]

    "Modified: / 21-04-2011 / 12:48:02 / cg"
!

initialize
    "initialize the class"

    "/ protect against double initialization
    ErrorSignal isNil ifTrue:[
	self initializeConcreteClass.

	OSErrorHolder initialize.
	ErrorSignal := OsError.
	Smalltalk addDependent:self.    "/ to catch language changes
    ].
!

initializeConcreteClass
    OperatingSystem := ConcreteClass := self getConcreteClass.
!

initializeLocale
    "Initializes locale variables (Language, LanguageTerritory an so on)"

    self subclassResponsibility

    "Created: / 19-11-2017 / 14:53:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractOperatingSystem class methodsFor:'OS signal constants'!

sigABRT
    "return the signal number for SIGABRT - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigALRM
    "return the signal number for SIGALRM - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigBREAK
    "return the signal number for SIGBREAK - 0 if not supported.
     This is an MSDOS specific signal"

    ^ 0
!

sigBUS
    "return the signal number for SIGBUS - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigCHLD
    "return the signal number for SIGCHLD - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigCONT
    "return the signal number for SIGCONT - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigDANGER
    "return the signal number for SIGDANGER - 0 if not supported
     (seems to be an AIX special)"

    ^ 0
!

sigEMT
    "return the signal number for SIGEMT - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigFP
    "return the signal number for SIGFP - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigGRANT
    "return the signal number for SIGGRANT - 0 if not supported
     (seems to be an AIX special)"

    ^ 0
!

sigHUP
    "return the signal number for SIGHUP
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigILL
    "return the signal number for SIGILL - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigINT
    "return the signal number for SIGINT
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigIO
    "return the signal number for SIGIO - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigIOT
    "return the signal number for SIGIOT - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigKILL
    "return the signal number for SIGKILL
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigLOST
    "return the signal number for SIGLOST - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigMIGRATE
    "return the signal number for SIGMIGRATE - 0 if not supported
     (seems to be an AIX special)"

    ^ 0
!

sigMSG
    "return the signal number for SIGMSG - 0 if not supported
     (seems to be an AIX special)"

    ^ 0
!

sigPIPE
    "return the signal number for SIGPIPE - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigPOLL
    "return the signal number for SIGPOLL - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigPRE
    "return the signal number for SIGPRE - 0 if not supported
     (seems to be an AIX special)"

    ^ 0
!

sigPROF
    "return the signal number for SIGPROF - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigPWR
    "return the signal number for SIGPWR - 0 if not supported
     (not available on all systems)"

    ^ 0
!

sigQUIT
    "return the signal number for SIGQUIT
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigRETRACT
    "return the signal number for SIGRETRACT - 0 if not supported
     (seems to be an AIX special)"

    ^ 0
!

sigSAK
    "return the signal number for SIGSAK - 0 if not supported
     (seems to be an AIX special)"

    ^ 0
!

sigSEGV
    "return the signal number for SIGSEGV - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigSOUND
    "return the signal number for SIGSOUND - 0 if not supported
     (seems to be an AIX special)"

    ^ 0
!

sigSTOP
    "return the signal number for SIGSTOP - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigSYS
    "return the signal number for SIGSYS - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigTERM
    "return the signal number for SIGTERM - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigTRAP
    "return the signal number for SIGTRAP - 0 if not supported by OS
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigTSTP
    "return the signal number for SIGTSTP - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigTTIN
    "return the signal number for SIGTTIN - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigTTOU
    "return the signal number for SIGTTOU - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigURG
    "return the signal number for SIGURG - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigUSR1
    "return the signal number for SIGUSR1 - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigUSR2
    "return the signal number for SIGUSR2 - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigVTALRM
    "return the signal number for SIGVTALRM - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigWINCH
    "return the signal number for SIGWINCH - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigXCPU
    "return the signal number for SIGXCPU - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
!

sigXFSZ
    "return the signal number for SIGXFSZ - 0 if not supported
     (the numeric value is not the same across unix-systems)"

    ^ 0
! !

!AbstractOperatingSystem class methodsFor:'Signal constants'!

accessDeniedErrorSignal
    "return the signal raised when a (file-) access is denied."

    ^ OSErrorHolder noPermissionsSignal
!

errorSignal
    "return the parent signal of all OS signals."

    ^ OsError

    "Modified: 22.4.1996 / 13:11:31 / cg"
!

fileNotFoundErrorSignal
    "return the signal raised when a file was not found."

    ^ OSErrorHolder nonexistentSignal
!

invalidArgumentsSignal
    "return the signal which is raised for invalid arguments.
     Currently, this is never raised."

    ^ OsInvalidArgumentsError

    "Created: 13.9.1997 / 10:46:47 / cg"
    "Modified: 13.9.1997 / 10:47:03 / cg"
!

unsupportedOperationSignal
    "return the signal which is raised when an operation
     is attempted, which is not supported by the OS.
     (For example, creating a link on VMS or MSDOS)"

    ^ OSErrorHolder unsupportedOperationSignal.
! !

!AbstractOperatingSystem class methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Smalltalk notifies us about changes"

    ((something == #Language) or:[something == #LanguageTerritory]) ifTrue:[
	self initResources
    ]
! !

!AbstractOperatingSystem class methodsFor:'dummy shell operations'!

openApplicationForDocument:aFilenameOrString operation:operationSymbol
    "open a windows-shell/mac finder/desktop application to present the document contained in aFilenameOrString.
     This is typically used to present help-files, html documents, pdf documents etc.
     operationSymbol is one of:
	open
	edit
	explore
    "

    self
	openApplicationForDocument:aFilenameOrString
	operation:operationSymbol
	mimeType:nil
!

openApplicationForDocument:aFilenameOrString operation:operationSymbol mimeType:mimeTypeStringArgOrNil
    "open a windows-shell/mac finder/desktop application to present the document contained in aFilenameOrString.
     This is typically used to present help-files, html documents, pdf documents etc.
     operationSymbol is one of:
	open
	edit
	explore
     mimeTypeStringArgOrNil is e.g. 'text/html' or: 'application/pdf'.
     If nil is passed in, the file's suffix is used to guess the mime type.
    "

    self
	openApplicationForDocument:aFilenameOrString
	operation:operationSymbol
	mimeType:mimeTypeStringArgOrNil
	inDirectory:nil
	ifNone:[
	    "/ last resort: use a fileBrowser
	    UserPreferences fileBrowserClass openOn:aFilenameOrString
	].

    "
     self openApplicationForDocument: Filename currentDirectory operation:#open
     self openApplicationForDocument: '..\..\doc\books\ArtOfSmalltalk\artMissing186187Fix1.pdf' asFilename operation:#open

     self openApplicationForDocument: 'C:\WINDOWS\Help\clipbrd.chm' asFilename operation:#open
     self openApplicationForDocument: 'http://www.exept.de' operation:#open mimeType:'text/html'
    "

    "Created: / 29-10-2010 / 12:16:38 / cg"
    "Modified: / 05-02-2011 / 16:13:42 / cg"
!

openApplicationForDocument:aFilenameOrString operation:operationSymbol mimeType:mimeTypeStringArgOrNil ifNone:exceptionBlock
    "open a windows-shell/mac finder/desktop application to present the document contained in aFilenameOrString.
     This is typically used to present help-files, html documents, pdf documents etc.
     operationSymbol is one of:
	open
	edit
	explore
     mimeTypeStringArgOrNil is e.g. 'text/html' or: 'application/pdf';
     if nil is passed in, the file's suffix is used to guess it.
    "

    ^ self
	openApplicationForDocument:aFilenameOrString operation:operationSymbol mimeType:mimeTypeStringArgOrNil
	inDirectory:nil ifNone:exceptionBlock
!

openApplicationForDocument:aFilenameOrString operation:operationSymbol mimeType:mimeTypeStringArgOrNil
    inDirectory:directoryStringOrFilenameOrNil
    "open a windows-shell/mac finder/desktop application to present the document contained in aFilenameOrString.
     This is typically used to present help-files, html documents, pdf documents etc.
     operationSymbol is one of:
	open
	edit
	explore
     mimeTypeStringArgOrNil is e.g. 'text/html' or: 'application/pdf';
     if nil is passed in, the file's suffix is used to guess it.
    "

    |openCommand mimeTypeString|

    mimeTypeString := mimeTypeStringArgOrNil.

    MIMETypes notNil ifTrue:[
	mimeTypeString isNil ifTrue:[
	    mimeTypeString := MIMETypes mimeTypeForFilename:aFilenameOrString.
	].
	mimeTypeString notNil ifTrue:[
	    openCommand := MIMETypes defaultCommandTemplateToOpenMimeType:mimeTypeString.
	].
    ].
    openCommand notEmptyOrNil ifTrue:[
	(openCommand includesSubString:'%1') ifTrue:[
	    openCommand := openCommand bindWith:aFilenameOrString asString.
	] ifFalse:[
	    openCommand := openCommand, ' "', aFilenameOrString asString, '"'.
	].

	(self
		startProcess:openCommand
		inputFrom:nil outputTo:nil
		errorTo:nil auxFrom:nil
		environment:nil inDirectory:directoryStringOrFilenameOrNil) notNil
	ifTrue:[
	    ^ self.
	].
    ].
    ExecutionError raiseErrorString:'execution of command failed: ', openCommand.

    "
     self openApplicationForDocument: Filename currentDirectory operation:#open
     self openApplicationForDocument: '..\..\doc\books\ArtOfSmalltalk\artMissing186187Fix1.pdf' asFilename operation:#open

     self openApplicationForDocument: 'C:\WINDOWS\Help\clipbrd.chm' asFilename operation:#open
    "

    "Created: / 29-10-2010 / 12:16:38 / cg"
    "Modified: / 05-02-2011 / 16:13:42 / cg"
!

openApplicationForDocument:aFilenameOrString operation:operationSymbol mimeType:mimeTypeStringArgOrNil
    inDirectory:directoryStringOrFilenameOrNil ifNone:exceptionBlock
    "open a windows-shell/mac finder/desktop application to present the document contained in aFilenameOrString.
     This is typically used to present help-files, html documents, pdf documents etc.
     operationSymbol is one of:
	open
	edit
	explore
     mimeTypeStringArgOrNil is e.g. 'text/html' or: 'application/pdf';
     if nil is passed in, the file's suffix is used to guess it.
    "

    [
	^ self
	    openApplicationForDocument:aFilenameOrString
	    operation:operationSymbol mimeType:mimeTypeStringArgOrNil
	    inDirectory:directoryStringOrFilenameOrNil.
    ] on:ExecutionError do:[:ex|
	exceptionBlock value.
    ].
! !

!AbstractOperatingSystem class methodsFor:'error messages'!

clearLastErrorNumber
    "return the last errors number.
     See also: #lastErrorSymbol and #lastErrorString.
     Notice: having a single error number is a bad idea in a multithreaded
	     environment - this interface will change."

    LastErrorNumber := nil.

     "
      AbstractOperatingSystem clearLastErrorNumber
     "

    "Created: 12.4.1996 / 09:28:58 / stefan"
    "Modified: 12.4.1996 / 09:38:51 / stefan"
!

currentErrorNumber
    "returns the OS's last error nr (i.e. the value of errno).
     Notice, that the value of this flag is only valid immediately
     after the error occurred - it gets updated with every other
     request to the OS.
     Use lastErrorNumber - currentErrorNumber is invalidated by
     many, many internal calls."

    ^ self lastErrorNumber

     "
      OperatingSystem currentErrorNumber
     "
!

errorHolderForNumber:anInteger
    "return an osErrorHolder for the given error number (as returned by a system call)."

    ^ self subclassResponsibility
!

errorNumberFor:aSymbol
    "given a symbolic error, return the numeric;
     (i.e. errorNumberFor:#EBADF returns EBADF's value).
     Use this, since error numbers are really not standard across unix systems."

    ^ -1
!

errorStringForSymbol:errorSymbol
    "return an errorMessage for an errorSymbol
     (as kept in an osErrorHolder)."

    Resources isNil ifTrue:[
	"/ do not care to load resource strings, if the error happens during early initialization
	Smalltalk isInitialized ifFalse:[
	    ^ errorSymbol
	].
	"/ avoid endless recursion
	Error handle:[:ex |
	] do:[
	    self initResources.
	].
	Resources isNil ifTrue:[
	    ^ errorSymbol
	]
    ].
    ^ Resources at:errorSymbol ifAbsent:errorSymbol

    "
     OperatingSystem errorStringForSymbol:#EPERM
     OperatingSystem errorStringForSymbol:(OperatingSystem errorSymbolForNumber:4)
    "

    "Modified: / 21-04-2011 / 13:13:29 / cg"
!

errorSymbolAndTextForNumber:errNr
    "do not use - temporary for backward compatibility.
     The returned message is in english (as found in /usr/include/errno.h)
     and should be replaced by a resource lookup before being presented to the user."

    |holder errSym|

    holder := self errorHolderForNumber:errNr.
    errSym := holder errorSymbol.
    ^ Array
	with:errSym
	with:(self errorStringForSymbol:errSym)

    "
     OperatingSystem errorSymbolAndTextForNumber:(OperatingSystem errorNumberFor:#EPERM)
     OperatingSystem errorSymbolAndTextForNumber:(OperatingSystem errorNumberFor:#EIO)
     OperatingSystem errorSymbolAndTextForNumber:(OperatingSystem errorNumberFor:#ENXIO)
    "
!

errorSymbolForNumber:errNr
    "return a symbol for a unix errorNumber
     (as returned by a system call)."

    ^ (self errorHolderForNumber:errNr) errorSymbol

    "
     OperatingSystem errorSymbolForNumber:4
     OperatingSystem errorSymbolForNumber:2
    "
!

errorTextForNumber:errNr
    "return a message string from a unix errorNumber
     (as returned by a system call).
     The returned message is in english (as found in /usr/include/errno.h)
     and should be replaced by a resource lookup before being presented to the user."

    ^ (self errorHolderForNumber:errNr) errorString

    "
     OperatingSystem errorTextForNumber:4
     OperatingSystem errorTextForNumber:(OperatingSystem errorNumberFor:#EPERM)
    "
!

lastErrorNumber
    "return the last errors number.
     See also: #lastErrorSymbol and #lastErrorString.
     Notice: having a single error number is a bad idea in a multithreaded
	     environment - this interface will change."

    ^ LastErrorNumber

     "
      OperatingSystem lastErrorNumber
     "
!

lastErrorString
    "return a message string describing the last error.
     See also: #lastErrorNumber and #lastErrorSymbol.
     Notice: having a single error number is a bad idea in a multithreaded
	     environment - this interface will change."

    LastErrorNumber isNil ifTrue:[^ nil].
    ^ self errorTextForNumber:LastErrorNumber

    "
     OperatingSystem lastErrorString
    "
!

lastErrorSymbol
    "return a symbol (such as #EBADF or #EACCESS) describing the last error.
     See also: #lastErrorNumber and #lastErrorString.
     Notice: having a single error number is a bad idea in a multithreaded
	     environment - this interface will change."

    LastErrorNumber isNil ifTrue:[^ nil].
    ^ self errorSymbolForNumber:LastErrorNumber

    "
     OperatingSystem lastErrorSymbol
    "
! !

!AbstractOperatingSystem class methodsFor:'executing OS commands-implementation'!

exec:aCommandPath withArguments:argArray environment:env fileDescriptors:fds fork:doFork
		  newPgrp:newGrp inDirectory:aDirectory showWindow:showWindowBooleanOrNil
    "execute an OS command"

    ^ self subclassResponsibility

    "Created: / 12.11.1998 / 14:46:15 / cg"
!

fork
    "fork a new (HEAVY-weight) Unix process.
     Not supported with MSDOS & VMS systems.
     Do not confuse this with Block>>fork, which creates
     lightweight smalltalk processes. This method will return
     0 to the child process, and a non-zero number (which is the childs
     unix-process-id) to the parent (original) process.

     In normal situations, you do not need to use this low level entry; see
     #startProcess: and #executCommand: for higher level interfaces."

    "/
    "/ not supported by OS
    "/

    ^ self unsupportedOperationSignal raise
!

startProcess:aCommandString inputFrom:anExternalInStream outputTo:anExternalOutStream
    errorTo:anExternalErrStream auxFrom:anAuxiliaryStream
    environment:anEvironmentDictionary inDirectory:dir newPgrp:newPgrp showWindow:showWindowBooleanOrNil

    "start executing the OS command as specified by the argument, aCommandString
     as a separate process; do not wait for the command to finish.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     The command gets stdIn, stdOut and stdErr assigned from the arguments;
     each may be nil.
     Return the processId if successful, nil otherwise.
     Use #monitorPid:action: for synchronization and exec status return,
     or #killProcess: to stop it."

    |nullStream in out err shellAndArgs pid auxFd|

    aCommandString isNil ifTrue:[^ nil].

    (in := anExternalInStream) isNil ifTrue:[
	nullStream := Filename nullDevice readWriteStream.
	in := nullStream.
    ].
    (out := anExternalOutStream) isNil ifTrue:[
	nullStream isNil ifTrue:[nullStream := Filename nullDevice writeStream].
	out := nullStream.
    ].
    (err := anExternalErrStream) isNil ifTrue:[
	err := out
    ].
    anAuxiliaryStream notNil ifTrue:[
	auxFd := anAuxiliaryStream fileHandle.
    ].

    shellAndArgs := self commandAndArgsForOSCommand:aCommandString.

    pid := self
	exec:(shellAndArgs at:1)
	withArguments:(shellAndArgs at:2)
	environment:anEvironmentDictionary
	fileDescriptors:(Array with:in fileHandle
			       with:out fileHandle
			       with:err fileHandle
			       with:auxFd)
	fork:true
	newPgrp:newPgrp
	inDirectory:dir
	showWindow:(showWindowBooleanOrNil ? (shellAndArgs at:3)).

    nullStream notNil ifTrue:[
	nullStream close.
    ].

    ^ pid

    "blocking at current prio (i.e. only higher prio threads execute):

     OperatingSystem executeCommand:'ls -l > out'.
     OperatingSystem executeCommand:#('/bin/ls' '-l') outputTo:Transcript.
    "

    "non-blocking (lower prio threads continue):

     |in out err pid sema|

     in := 'out' asFilename readStream.
     out := 'out2' asFilename writeStream.
     err := 'err' asFilename writeStream.

     sema := Semaphore new.
     pid := OperatingSystem startProcess:'sleep 10; grep drw' inputFrom:in outputTo:out errorTo:err.

     The following will no longer work. monitorPid has disappeared

     pid notNil ifTrue:[
	 Processor monitorPid:pid action:[:osStatus | sema signal ].
     ].
     in close.
     out close.
     err close.
     sema wait.
     Transcript showCR:'finished'
    "

    "
     |pid sema|

     sema := Semaphore new.

     Processor
	    monitor:[
		pid := OperatingSystem startProcess:'(sleep 2; ls -l) > out 2>err'
	    ]
	    action:[:osStatus | sema signal ].

     sema wait.
     Transcript showCR:'finished'
    "

    "
     |pid sema|

     sema := Semaphore new.

     Processor
	    monitor:[
		pid := OperatingSystem startProcess:'(sleep 1; echo 1; sleep 9; ls -l) > out 2>err'
	    ]
	    action:[:osStatus | sema signal ].

     Delay waitForSeconds:2.
     OperatingSystem terminateProcess:pid.
     Transcript showCR:'terminated'
    "

    "======================== WINDOWS: ==================================================================="

     "blocking at current prio (i.e. only higher prio threads execute):

     OperatingSystem executeCommand:'dir > out'.
     OperatingSystem executeCommand:'tree /A' outputTo:Transcript.
     OperatingSystem executeCommand:#('c:\windows\system32\tree.com' '/A' '/F') outputTo:Transcript.
     OperatingSystem executeCommand:#('c:\windows\system32\where.exe' '/T' '*.dll') outputTo:Transcript.
    "

    "non-blocking (lower prio threads continue):

     |in out err pid sema|

     in := 'out' asFilename readStream.
     out := 'out2' asFilename writeStream.
     err := 'err' asFilename writeStream.

     sema := Semaphore new.
     pid := OperatingSystem startProcess:'sleep 10; grep drw' inputFrom:in outputTo:out errorTo:err.

     The following will no longer work. monitorPid has disappeared

     pid notNil ifTrue:[
	 Processor monitorPid:pid action:[:OSstatus | sema signal ].
     ].
     in close.
     out close.
     err close.
     sema wait.
     Transcript showCR:'finished'
    "

    "
     |pid sema|

     sema := Semaphore new.

     Processor
	    monitor:[
		pid := OperatingSystem startProcess:'dir > out 2>err'
	    ]
	    action:[:osStatus | sema signal ].

     sema wait.
     Transcript showCR:'finished'
    "

"<<END
     |pid sema|

     sema := Semaphore new.

     Processor
	    monitor:[
		pid := OperatingSystem startProcess:'(echo 1 & stx --eval "Delay waitForSeconds:100" & dir) >out' withCRs
	    ]
	    action:[:osStatus | sema signal ].

     Delay waitForSeconds:5.
     OperatingSystem terminateProcessGroup:pid.
     Transcript showCR:'terminated'
END"

"<<END
     |pid sema|

     sema := Semaphore new.

     Processor
	    monitor:[
		pid := OperatingSystem startProcess:{ 'C:\Users\cg\work\stx\projects\smalltalk\stx.com' . '--eval' . '"Delay waitForSeconds:100"' }
	    ]
	    action:[:osStatus | sema signal ].

     Delay waitForSeconds:5.
     OperatingSystem terminateProcess:pid.
     Transcript showCR:'terminated'
END"


    "Modified: / 21.3.1997 / 10:04:35 / dq"
    "Modified: / 15.7.1997 / 16:03:51 / stefan"
    "Modified: / 5.6.1998 / 19:03:51 / cg"
    "Created: / 12.11.1998 / 14:39:20 / cg"
! !

!AbstractOperatingSystem class methodsFor:'executing OS commands-public'!

executeCommand:aCommandString
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Blocks until the command has finished.
     Return true if successful, false otherwise."

     ^ self
	executeCommand:aCommandString
	inputFrom:nil
	outputTo:nil
	errorTo:nil
	auxFrom:nil
	environment:nil
	inDirectory:nil
	lineWise:false
	onError:[:status| false]

    "unix:

     OperatingSystem executeCommand:'sleep 30'.
     OperatingSystem executeCommand:'pwd'.
     OperatingSystem executeCommand:'ls -l'.
     OperatingSystem executeCommand:'invalidCommand'.
     OperatingSystem executeCommand:'rm /tmp/foofoofoofoo'.
    "

    "msdos:

     OperatingSystem executeCommand:'dir'
     OperatingSystem executeCommand:'dir /w'
    "

    "vms:

     OperatingSystem executeCommand:'dir'
     OperatingSystem executeCommand:'purge'
     OperatingSystem executeCommand:'cc foo.c'
    "

    "Modified: / 7.1.1997 / 19:29:55 / stefan"
    "Modified: / 10.11.1998 / 20:55:37 / cg"
!

executeCommand:aCommandString errorTo:errorStream
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, false otherwise."

     ^ self
	executeCommand:aCommandString
	inputFrom:nil
	outputTo:nil
	errorTo:errorStream
	auxFrom:nil
	environment:nil
	inDirectory:nil
	lineWise:false
	onError:[:status| false]

    "unix:

     OperatingSystem executeCommand:'ls -l'                 errorTo:Transcript.
     OperatingSystem executeCommand:'invalidCommand'        errorTo:Transcript.
     OperatingSystem executeCommand:'rm /tmp/foofoofoofoo'  errorTo:Transcript.
    "
!

executeCommand:aCommandString errorTo:errorStream inDirectory:aDirectory
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, false otherwise."

     ^ self
	executeCommand:aCommandString
	inputFrom:nil
	outputTo:nil
	errorTo:errorStream
	auxFrom:nil
	environment:nil
	inDirectory:aDirectory
	lineWise:false
	onError:[:status| false]

    "unix:

     OperatingSystem executeCommand:'ls -l'                 errorTo:Transcript.
     OperatingSystem executeCommand:'invalidCommand'        errorTo:Transcript.
     OperatingSystem executeCommand:'rm /tmp/foofoofoofoo'  errorTo:Transcript.
    "

    "Created: / 29-09-2006 / 14:58:30 / cg"
!

executeCommand:aCommandString inDirectory:aDirectory
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, false otherwise."

    ^ self
	executeCommand:aCommandString
	inputFrom:nil
	outputTo:nil
	errorTo:nil
	auxFrom:nil
	environment:nil
	inDirectory:aDirectory
	lineWise:false
	onError:[:exitStatus| false]

    "Modified: / 10.11.1998 / 20:54:37 / cg"
!

executeCommand:aCommandString inDirectory:aDirectory onError:aBlock
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, the value from aBlock if not.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument."

    ^ self
	executeCommand:aCommandString
	inputFrom:nil
	outputTo:nil
	errorTo:nil
	auxFrom:nil
	environment:nil
	inDirectory:aDirectory
	lineWise:false
	onError:aBlock

    "Modified: / 10.11.1998 / 20:54:37 / cg"
!

executeCommand:aCommandString inDirectory:aDirectory showWindow:showWindow
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, false otherwise."

    ^ self
	executeCommand:aCommandString
	inputFrom:nil
	outputTo:nil
	errorTo:nil
	auxFrom:nil
	environment:nil
	inDirectory:aDirectory
	lineWise:false
	showWindow:showWindow
	onError:[:exitStatus| false]

    "Created: / 18-10-2016 / 15:55:29 / cg"
!

executeCommand:aCommandString inputFrom:anInStream outputTo:anOutStream errorTo:anErrStream
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, false if not."

    ^ self
	executeCommand:aCommandString
	inputFrom:anInStream
	outputTo:anOutStream
	errorTo:anErrStream
	auxFrom:nil
	environment:nil
	inDirectory:nil
	lineWise:false
	onError:[:status | false]

    "
	OperatingSystem
	    executeCommand:'ls'
	    inputFrom:nil
	    outputTo:Transcript
	    errorTo:Transcript

	|s|
	s := WriteStream on:''.
	(OperatingSystem
	    executeCommand:'ls'
	    inputFrom:nil
	    outputTo:s
	    errorTo:Transcript) ifTrue:[Transcript showCR:s contents]

	OperatingSystem
	    executeCommand:'dir'
	    inputFrom:nil
	    outputTo:Transcript
	    errorTo:Transcript

	OperatingSystem
	    executeCommand:'foo'
	    inputFrom:Transcript
	    outputTo:Transcript
	    errorTo:nil
    "
    "
	|outStr errStr|

	outStr := '' writeStream.
	errStr := '' writeStream.
	OperatingSystem
	    executeCommand:'ls'
	    inputFrom:nil
	    outputTo:outStr
	    errorTo:errStr
	    onError:[:status | Transcript flash].
	Transcript show:'out:'; showCR:outStr contents.
	Transcript show:'err:'; showCR:errStr contents.
    "
    "
	|outStr errStr|

	outStr := '' writeStream.
	errStr := '' writeStream.
	OperatingSystem
	    executeCommand:'ls /fooBar'
	    inputFrom:nil
	    outputTo:outStr
	    errorTo:errStr
	    onError:[:status | Transcript flash].
	Transcript show:'out:'; showCR:outStr contents.
	Transcript show:'err:'; showCR:errStr contents.
    "

    "Modified: / 10.11.1998 / 20:51:39 / cg"
!

executeCommand:aCommandStringOrArray inputFrom:anInStream outputTo:anOutStream
    errorTo:anErrStream auxFrom:anAuxStream environment:environmentDictionary
    inDirectory:dirOrNil lineWise:lineWise newPgrp:newPgrp showWindow:showWindowBooleanOrNil onError:aBlock

    "execute the unix command specified by the argument, aCommandStringOrArray.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, or the value of aBlock if not.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument.
     The given in, out and err streams may be arbitrary (Smalltalk-) streams;
     if any is not an external stream (which is required by the command),
     extra pipes and shuffler processes are created, which stuff the data into
     those internal stream(s).
     Nil stream args will execute the command connected to ST/X's standard input, output or
     error resp. - i.e. usually, i/o will be from/to the terminal.

     Set lineWise to true, if both error and output is sent to the same stream
     and you don't want lines to be mangled. Set lineWise = false to
     avoid blocking on pipes.

     Special for windows:
	you can control (have to - sigh) if a window should be shown for the command or not.
	This is the OS's H_SHOWWINDOW argument.
	If you pass nil as showWindow-argument, the OS's default is used for the particular
	command, which is correct most of the time: i.e. a notepad will open its window, other (non-UI)
	executables will not.
	However, some command-line executables show a window, even if they should not.
	(and also, there seems to be an inconsistency between windows7 and newer windows: in newer,
	 a shell command opens a cmd-window, whereas in windows7 it did not)
	In this case, pass an explicit false argument to suppress it.
	This argument is ignored on Unix systems.
	See examples below."

	|osProcess|

	osProcess := OSProcess new
	    command:aCommandStringOrArray;
	    inStream:anInStream;
	    outStream:anOutStream;
	    errorStream:anErrStream;
	    auxStream:anAuxStream;
	    environment:environmentDictionary;
	    directory:dirOrNil;
	    lineWise:lineWise;
	    showWindow:showWindowBooleanOrNil.

	osProcess execute ifFalse:[
	    aBlock value:osProcess exitStatus.
	    ^ false.
	].
	^ true.
!

executeCommand:aCommandStringOrArray inputFrom:anInStream outputTo:anOutStream
    errorTo:anErrStream auxFrom:anAuxStream environment:environmentDictionary
    inDirectory:dirOrNil lineWise:lineWise onError:aBlock

    "execute the unix command specified by the argument, aCommandStringOrArray.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, or the value of aBlock if not.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument.
     The given in, out and err streams may be arbitrary (Smalltalk-) streams;
     if any is not an external stream (which is required by the command),
     extra pipes and shuffler processes are created, which stuff the data into
     those internal stream(s).
     Nil stream args will execute the command connected to ST/X's standard input, output or
     error resp. - i.e. usually, i/o will be from/to the terminal.

     Set lineWise to true, if both error and output is sent to the same stream
     and you don't want lines to be mangled. Set lineWise = false to
     avoid blocking on pipes"

    ^ self
	executeCommand:aCommandStringOrArray inputFrom:anInStream outputTo:anOutStream
	errorTo:anErrStream auxFrom:anAuxStream environment:environmentDictionary
	inDirectory:dirOrNil lineWise:lineWise showWindow:false onError:aBlock

    "
	|outStream errStream|

	outStream := '' writeStream.

	OperatingSystem executeCommand:'ls -l'
			inputFrom:'abc' readStream
			outputTo:outStream
			errorTo:nil
			inDirectory:nil
			lineWise:true
			onError:[:exitStatus | ^ false].
	outStream contents
    "

    "
	|outStream errStream|

	outStream := #[] writeStream.

	OperatingSystem executeCommand:'cat'
			inputFrom:(ByteArray new:5000000) readStream
			outputTo:outStream
			errorTo:nil
			inDirectory:nil
			lineWise:false
			onError:[:exitStatus | ^ false].
	outStream size
    "

    "
	|outStream errStream|

	outStream := '' writeStream.

	OperatingSystem executeCommand:'gpg -s --batch --no-tty --passphrase-fd 0 /tmp/passwd'
			inputFrom:'bla' readStream
			outputTo:outStream
			errorTo:nil
			inDirectory:nil
			lineWise:true
			onError:[:exitStatus |  false].
	outStream contents
    "

    "Modified: / 11-02-2007 / 20:54:39 / cg"
!

executeCommand:aCommandStringOrArray inputFrom:anInStream outputTo:anOutStream
    errorTo:anErrStream auxFrom:anAuxStream environment:environmentDictionary
    inDirectory:dirOrNil lineWise:lineWise showWindow:showWindowBooleanOrNil onError:aBlock

    "execute the unix command specified by the argument, aCommandStringOrArray.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, or the value of aBlock if not.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument.
     The given in, out and err streams may be arbitrary (Smalltalk-) streams;
     if any is not an external stream (which is required by the command),
     extra pipes and shuffler processes are created, which stuff the data into
     those internal stream(s).
     Nil stream args will execute the command connected to ST/X's standard input, output or
     error resp. - i.e. usually, i/o will be from/to the terminal.

     Set lineWise to true, if both error and output is sent to the same stream
     and you don't want lines to be mangled. Set lineWise = false to
     avoid blocking on pipes.

     Special for windows:
	you can control (have to - sigh) if a window should be shown for the command or not.
	This is the OS's H_SHOWWINDOW argument.
	If you pass nil as showWindow-argument, the OS's default is used for the particular
	command, which is correct most of the time: i.e. a notepad will open its window, other (non-UI)
	executables will not.
	However, some command-line executables show a window, even if they should not.
	(and also, there seems to be an inconsistency between windows7 and newer windows: in newer,
	 a shell command opens a cmd-window, whereas in windows7 it did not)
	In this case, pass an explicit false argument to suppress it.
	This argument is ignored on Unix systems.
	See examples below."

    ^ self
	executeCommand:aCommandStringOrArray inputFrom:anInStream outputTo:anOutStream
	errorTo:anErrStream auxFrom:anAuxStream environment:environmentDictionary
	inDirectory:dirOrNil lineWise:lineWise newPgrp:true showWindow:showWindowBooleanOrNil onError:aBlock

    "
	|outStream errStream|

	outStream := '' writeStream.

	OperatingSystem executeCommand:'ls -l'
			inputFrom:'abc' readStream
			outputTo:outStream
			errorTo:nil
			inDirectory:nil
			lineWise:true
			onError:[:exitStatus | ^ false].
	outStream contents
    "

    "
	|outStream errStream|

	outStream := #[] writeStream.

	OperatingSystem executeCommand:'cat'
			inputFrom:(ByteArray new:5000000) readStream
			outputTo:outStream
			errorTo:nil
			inDirectory:nil
			lineWise:false
			onError:[:exitStatus | ^ false].
	outStream size
    "

    "
	|outStream errStream|

	outStream := '' writeStream.

	OperatingSystem executeCommand:'gpg -s --batch --no-tty --passphrase-fd 0 /tmp/passwd'
			inputFrom:'bla' readStream
			outputTo:outStream
			errorTo:nil
			inDirectory:nil
			lineWise:true
			onError:[:exitStatus |  false].
	outStream contents
    "

    "Modified: / 08-11-2016 / 21:33:00 / cg"
!

executeCommand:aCommandString inputFrom:anInStream outputTo:anOutStream errorTo:anErrStream auxFrom:anAuxStream inDirectory:dirOrNil lineWise:lineWise onError:aBlock
    ^ self
	executeCommand:aCommandString
	inputFrom:anInStream
	outputTo:anOutStream
	errorTo:anErrStream
	auxFrom:anAuxStream
	environment:nil
	inDirectory:dirOrNil
	lineWise:lineWise
	onError:aBlock
!

executeCommand:aCommandString inputFrom:anInStream outputTo:anOutStream errorTo:anErrStream auxFrom:anAuxStream inDirectory:dirOrNil lineWise:lineWise showWindow:showWindow onError:aBlock
    ^ self
	executeCommand:aCommandString
	inputFrom:anInStream
	outputTo:anOutStream
	errorTo:anErrStream
	auxFrom:anAuxStream
	environment:nil
	inDirectory:dirOrNil
	lineWise:lineWise
	showWindow:showWindow
	onError:aBlock
!

executeCommand:aCommandString inputFrom:anInStream outputTo:anOutStream errorTo:anErrStream environment:env onError:aBlock
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, the value from aBlock if not.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument."

    ^ self
	executeCommand:aCommandString
	inputFrom:anInStream
	outputTo:anOutStream
	errorTo:anErrStream
	auxFrom:nil
	environment:env
	inDirectory:nil
	lineWise:false
	onError:aBlock

    "
	OperatingSystem
	    executeCommand:'dir'
	    inputFrom:nil
	    outputTo:nil
	    errorTo:nil
	    onError:[:status | Transcript flash]

	OperatingSystem
	    executeCommand:'foo'
	    inputFrom:nil
	    outputTo:nil
	    errorTo:nil
	    onError:[:status | Transcript flash]
    "
    "
	|outStr errStr|

	outStr := '' writeStream.
	errStr := '' writeStream.
	OperatingSystem
	    executeCommand:'ls'
	    inputFrom:nil
	    outputTo:outStr
	    errorTo:errStr
	    onError:[:status | Transcript flash].
	Transcript show:'out:'; showCR:outStr contents.
	Transcript show:'err:'; showCR:errStr contents.
    "
    "
	|outStr errStr|

	outStr := '' writeStream.
	errStr := '' writeStream.
	OperatingSystem
	    executeCommand:'ls /fooBar'
	    inputFrom:nil
	    outputTo:outStr
	    errorTo:errStr
	    onError:[:status | Transcript flash].
	Transcript show:'out:'; showCR:outStr contents.
	Transcript show:'err:'; showCR:errStr contents.
    "

    "Modified: / 10.11.1998 / 20:51:39 / cg"
!

executeCommand:aCommandString inputFrom:anInStream outputTo:anOutStream errorTo:anErrStream environment:env showWindow:showWindow onError:aBlock
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, the value from aBlock if not.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument."

    ^ self
	executeCommand:aCommandString
	inputFrom:anInStream
	outputTo:anOutStream
	errorTo:anErrStream
	auxFrom:nil
	environment:env
	inDirectory:nil
	lineWise:false
	showWindow:showWindow
	onError:aBlock

    "
	OperatingSystem
	    executeCommand:'dir'
	    inputFrom:nil
	    outputTo:nil
	    errorTo:nil
	    onError:[:status | Transcript flash]

	OperatingSystem
	    executeCommand:'foo'
	    inputFrom:nil
	    outputTo:nil
	    errorTo:nil
	    onError:[:status | Transcript flash]
    "
    "
	|outStr errStr|

	outStr := '' writeStream.
	errStr := '' writeStream.
	OperatingSystem
	    executeCommand:'ls'
	    inputFrom:nil
	    outputTo:outStr
	    errorTo:errStr
	    onError:[:status | Transcript flash].
	Transcript show:'out:'; showCR:outStr contents.
	Transcript show:'err:'; showCR:errStr contents.
    "
    "
	|outStr errStr|

	outStr := '' writeStream.
	errStr := '' writeStream.
	OperatingSystem
	    executeCommand:'ls /fooBar'
	    inputFrom:nil
	    outputTo:outStr
	    errorTo:errStr
	    onError:[:status | Transcript flash].
	Transcript show:'out:'; showCR:outStr contents.
	Transcript show:'err:'; showCR:errStr contents.
    "

    "Modified: / 10.11.1998 / 20:51:39 / cg"
!

executeCommand:aCommandString inputFrom:inputStreamOrNil outputTo:outStreamOrNil errorTo:errStreamOrNil inDirectory:aDirectory
    "much like #executeCommand:, but changes the current directory
     for the command. Since this is OS specific, use this instead of
     hardwiring any 'cd ..' command strings into your applictions."

     ^ self
	executeCommand:aCommandString
	inputFrom:inputStreamOrNil
	outputTo:outStreamOrNil
	errorTo:errStreamOrNil
	auxFrom:nil
	environment:nil
	inDirectory:aDirectory
	lineWise:false
	onError:[:status| false]

    "
     OperatingSystem executeCommand:'tdump date.obj' inDirectory:'c:\winstx\stx\libbasic\objbc'.
     OperatingSystem executeCommand:'xxdir date.obj' inDirectory:'c:\winstx\stx\libbasic\objbc'.
     OperatingSystem executeCommand:'dir' inDirectory:'c:\'.
     OperatingSystem executeCommand:'dir'
    "

    "Modified: / 20.1.1998 / 17:03:03 / md"
    "Modified: / 10.11.1998 / 20:28:10 / cg"
    "Created: / 10.11.1998 / 21:05:45 / cg"
!

executeCommand:aCommandString inputFrom:anInStream outputTo:anOutStream errorTo:anErrStream inDirectory:dirOrNil lineWise:lineWise onError:aBlock
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, the value from aBlock if not.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument.
     The given in, out and err streams may be arbitrary (Smalltalk-) streams;
     if any is not an external stream (which is required by the command),
     extra pipes and shuffler processes are created, which stuff the data into
     those internal stream(s).
     Nil stream args will execute the command connected to ST/X's standard input, output or
     error resp. - i.e. usually, i/o will be from/to the terminal"

    ^ self
	executeCommand:aCommandString
	inputFrom:anInStream
	outputTo:anOutStream
	errorTo:anErrStream
	auxFrom:nil
	environment:nil
	inDirectory:dirOrNil
	lineWise:lineWise
	onError:aBlock
!

executeCommand:aCommandString inputFrom:anInStream outputTo:anOutStream errorTo:anErrStream inDirectory:dirOrNil lineWise:lineWise showWindow:showWindow onError:aBlock
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, the value from aBlock if not.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument.
     The given in, out and err streams may be arbitrary (Smalltalk-) streams;
     if any is not an external stream (which is required by the command),
     extra pipes and shuffler processes are created, which stuff the data into
     those internal stream(s).
     Nil stream args will execute the command connected to ST/X's standard input, output or
     error resp. - i.e. usually, i/o will be from/to the terminal"

    ^ self
	executeCommand:aCommandString
	inputFrom:anInStream
	outputTo:anOutStream
	errorTo:anErrStream
	auxFrom:nil
	environment:nil
	inDirectory:dirOrNil
	lineWise:lineWise
	showWindow:showWindow
	onError:aBlock
!

executeCommand:aCommandString inputFrom:anInStream outputTo:anOutStream errorTo:anErrStream inDirectory:dirOrNil onError:aBlock
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, the value from aBlock if not.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument.
     The given in, out and err streams may be arbitrary (Smalltalk-) streams;
     if any is not an external stream (which is required by the command),
     extra pipes and shuffler processes are created, which stuff the data into
     those internal stream(s).
     Nil stream args will execute the command connected to ST/X's input, output or
     error resp. - i.e. i/o will be from/to the xterminal"

    ^ self
	executeCommand:aCommandString
	inputFrom:anInStream
	outputTo:anOutStream
	errorTo:anErrStream
	auxFrom:nil
	environment:nil
	inDirectory:dirOrNil
	lineWise:false
	onError:aBlock

    "
     OperatingSystem
	 executeCommand:'dir'
	 inputFrom:nil
	 outputTo:nil
	 errorTo:nil
	 inDirectory:'c:'
	 onError:[:status | Transcript flash]

     OperatingSystem
	 executeCommand:'foo'
	 inputFrom:nil
	 outputTo:nil
	 errorTo:nil
	 inDirectory:'/etc'
	 onError:[:status | Transcript flash]

     |s|
     s := '' writeStream.
     OperatingSystem
	 executeCommand:'ls -l'
	 inputFrom:nil
	 outputTo:s
	 errorTo:nil
	 onError:[:status | Transcript flash].
     Transcript showCR:s contents.

     |s|
     s := '' writeStream.
     OperatingSystem
	 executeCommand:'sh foo'
	 inputFrom:nil
	 outputTo:s
	 errorTo:s
	 onError:[:status | Transcript flash].
     Transcript showCR:s contents.
    "

    "Modified: / 25.3.1997 / 11:02:02 / stefan"
    "Modified: / 28.1.1998 / 14:46:36 / md"
    "Modified: / 10.11.1998 / 20:48:08 / cg"
    "Created: / 10.11.1998 / 20:51:11 / cg"
!

executeCommand:aCommandString inputFrom:anInStream outputTo:anOutStream errorTo:anErrStream inDirectory:dir showWindow:showWindow onError:aBlock
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, the value from aBlock if not.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument."

    ^ self
	executeCommand:aCommandString
	inputFrom:anInStream
	outputTo:anOutStream
	errorTo:anErrStream
	auxFrom:nil
	environment:nil
	inDirectory:dir
	lineWise:false
	showWindow:showWindow
	onError:aBlock

    "
	OperatingSystem
	    executeCommand:'dir'
	    inputFrom:nil
	    outputTo:nil
	    errorTo:nil
	    onError:[:status | Transcript flash]

	OperatingSystem
	    executeCommand:'foo'
	    inputFrom:nil
	    outputTo:nil
	    errorTo:nil
	    onError:[:status | Transcript flash]
    "
    "
	|outStr errStr|

	outStr := '' writeStream.
	errStr := '' writeStream.
	OperatingSystem
	    executeCommand:'ls'
	    inputFrom:nil
	    outputTo:outStr
	    errorTo:errStr
	    onError:[:status | Transcript flash].
	Transcript show:'out:'; showCR:outStr contents.
	Transcript show:'err:'; showCR:errStr contents.
    "
    "
	|outStr errStr|

	outStr := '' writeStream.
	errStr := '' writeStream.
	OperatingSystem
	    executeCommand:'ls /fooBar'
	    inputFrom:nil
	    outputTo:outStr
	    errorTo:errStr
	    onError:[:status | Transcript flash].
	Transcript show:'out:'; showCR:outStr contents.
	Transcript show:'err:'; showCR:errStr contents.
    "

    "Modified: / 10.11.1998 / 20:51:39 / cg"
!

executeCommand:aCommandString inputFrom:anInStream outputTo:anOutStream errorTo:anErrStream onError:aBlock
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, the value from aBlock if not.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument."

    ^ self
	executeCommand:aCommandString
	inputFrom:anInStream
	outputTo:anOutStream
	errorTo:anErrStream
	auxFrom:nil
	environment:nil
	inDirectory:nil
	lineWise:false
	onError:aBlock

    "
	OperatingSystem
	    executeCommand:'dir'
	    inputFrom:nil
	    outputTo:nil
	    errorTo:nil
	    onError:[:status | Transcript flash]

	OperatingSystem
	    executeCommand:'foo'
	    inputFrom:nil
	    outputTo:nil
	    errorTo:nil
	    onError:[:status | Transcript flash]
    "
    "
	|outStr errStr|

	outStr := '' writeStream.
	errStr := '' writeStream.
	OperatingSystem
	    executeCommand:'ls'
	    inputFrom:nil
	    outputTo:outStr
	    errorTo:errStr
	    onError:[:status | Transcript flash].
	Transcript show:'out:'; showCR:outStr contents.
	Transcript show:'err:'; showCR:errStr contents.
    "
    "
	|outStr errStr|

	outStr := '' writeStream.
	errStr := '' writeStream.
	OperatingSystem
	    executeCommand:'ls /fooBar'
	    inputFrom:nil
	    outputTo:outStr
	    errorTo:errStr
	    onError:[:status | Transcript flash].
	Transcript show:'out:'; showCR:outStr contents.
	Transcript show:'err:'; showCR:errStr contents.
    "

    "Modified: / 10.11.1998 / 20:51:39 / cg"
!

executeCommand:aCommandString inputFrom:anInStream outputTo:anOutStream errorTo:anErrStream showWindow:showWindow onError:aBlock
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, the value from aBlock if not.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument."

    ^ self
	executeCommand:aCommandString
	inputFrom:anInStream
	outputTo:anOutStream
	errorTo:anErrStream
	auxFrom:nil
	environment:nil
	inDirectory:nil
	lineWise:false
	showWindow:showWindow
	onError:aBlock

    "
	OperatingSystem
	    executeCommand:'dir'
	    inputFrom:nil
	    outputTo:nil
	    errorTo:nil
	    onError:[:status | Transcript flash]

	OperatingSystem
	    executeCommand:'foo'
	    inputFrom:nil
	    outputTo:nil
	    errorTo:nil
	    onError:[:status | Transcript flash]
    "
    "
	|outStr errStr|

	outStr := '' writeStream.
	errStr := '' writeStream.
	OperatingSystem
	    executeCommand:'ls'
	    inputFrom:nil
	    outputTo:outStr
	    errorTo:errStr
	    onError:[:status | Transcript flash].
	Transcript show:'out:'; showCR:outStr contents.
	Transcript show:'err:'; showCR:errStr contents.
    "
    "
	|outStr errStr|

	outStr := '' writeStream.
	errStr := '' writeStream.
	OperatingSystem
	    executeCommand:'ls /fooBar'
	    inputFrom:nil
	    outputTo:outStr
	    errorTo:errStr
	    onError:[:status | Transcript flash].
	Transcript show:'out:'; showCR:outStr contents.
	Transcript show:'err:'; showCR:errStr contents.
    "

    "Modified: / 10.11.1998 / 20:51:39 / cg"
!

executeCommand:aCommandString onError:aBlock
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, the value from aBlock if not.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument."

    ^ self
	executeCommand:aCommandString
	inputFrom:nil
	outputTo:nil
	errorTo:nil
	auxFrom:nil
	environment:nil
	inDirectory:nil
	lineWise:false
	onError:aBlock

    "unix:

     OperatingSystem executeCommand:'sleep 30' onError:[].
     OperatingSystem executeCommand:'pwd' onError:[:status|status inspect].
     OperatingSystem executeCommand:'ls -l' onError:[].
     OperatingSystem executeCommand:'invalidCommand' onError:[:status| status inspect].
     OperatingSystem executeCommand:'rm /tmp/foofoofoofoo'onError:[:status | status inspect].

     OperatingSystem executeCommand:'dir' onError:[].
     OperatingSystem executeCommand:'foo' onError:[].

    "

    "Modified: / 25.3.1997 / 11:06:43 / stefan"
    "Modified: / 28.1.1998 / 14:46:56 / md"
    "Created: / 5.6.1998 / 19:02:09 / cg"
    "Modified: / 10.11.1998 / 20:55:02 / cg"
!

executeCommand:aCommandString outputTo:anOutStreamOrNil
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, false otherwise."

     ^ self
	executeCommand:aCommandString
	inputFrom:nil
	outputTo:anOutStreamOrNil
	errorTo:nil
	auxFrom:nil
	environment:nil
	inDirectory:nil
	lineWise:false
	onError:[:status| false]

    "
     String streamContents:[:s|OperatingSystem
	executeCommand:'ls'
	outputTo:s
     ]
    "

    "
     String streamContents:[:s|OperatingSystem
	executeCommand:'pwd'
	outputTo:s
     ]
    "
!

executeCommand:aCommandString outputTo:anOutStreamOrNil errorTo:anErrStreamOrNil
    "execute the unix command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command. No shell is invoked in this case.
     Return true if successful, false otherwise."

     ^ self
	executeCommand:aCommandString
	inputFrom:nil
	outputTo:anOutStreamOrNil
	errorTo:anErrStreamOrNil
	auxFrom:nil
	environment:nil
	inDirectory:nil
	lineWise:false
	onError:[:status| false]

    "
     String streamContents:[:s|OperatingSystem
	executeCommand:'ls'
	outputTo:s
     ]
    "

    "
     String streamContents:[:s|OperatingSystem
	executeCommand:'pwd'
	outputTo:s
     ]
    "
!

executeCommand:aCommandString outputTo:outStreamOrNil errorTo:errStreamOrNil inDirectory:aDirectory
    "much like #executeCommand:, but changes the current directory
     for the command. Since this is OS specific, use this instead of
     hardwiring any 'cd ..' command strings into your applictions."

     ^ self
	executeCommand:aCommandString
	inputFrom:nil
	outputTo:outStreamOrNil
	errorTo:errStreamOrNil
	auxFrom:nil
	environment:nil
	inDirectory:aDirectory
	lineWise:false
	onError:[:status| false]

    "
     OperatingSystem executeCommand:'tdump date.obj' inDirectory:'c:\winstx\stx\libbasic\objbc'.
     OperatingSystem executeCommand:'xxdir date.obj' inDirectory:'c:\winstx\stx\libbasic\objbc'.
     OperatingSystem executeCommand:'dir' inDirectory:'c:\'.
     OperatingSystem executeCommand:'dir'
    "

    "Modified: / 20.1.1998 / 17:03:03 / md"
    "Modified: / 10.11.1998 / 20:28:10 / cg"
    "Created: / 10.11.1998 / 21:05:45 / cg"
!

executeCommand:aCommandString outputTo:outStreamOrNil errorTo:errStreamOrNil inDirectory:aDirectory showWindow:showWindowBooleanOrNil
    "much like #executeCommand:, but changes the current directory
     for the command. Since this is OS specific, use this instead of
     hardwiring any 'cd ..' command strings into your applictions.

     Special for windows:
	you can control (have to - sigh) if a window should be shown for the command or not.
	This is the OS's H_SHOWWINDOW argument.
	If you pass nil as showWindow-argument, the OS's default is used for the particular
	command, which is correct most of the time: i.e. a notepad will open its window, other (non-UI)
	executables will not.
	However, some command-line executables show a window, even if they should not.
	(and also, there seems to be an inconsistency between windows7 and newer windows: in newer,
	 a shell command opens a cmd-window, whereas in windows7 it did not)
	In this case, pass an explicit false argument to suppress it.
	This argument is ignored on Unix systems.
	See examples below."

     ^ self
	executeCommand:aCommandString
	inputFrom:nil
	outputTo:outStreamOrNil
	errorTo:errStreamOrNil
	auxFrom:nil
	environment:nil
	inDirectory:aDirectory
	lineWise:false
	newPgrp:true
	showWindow:showWindowBooleanOrNil
	onError:[:status| false]

    "
     OperatingSystem executeCommand:'tdump date.obj' inDirectory:'c:\winstx\stx\libbasic\objbc'.
     OperatingSystem executeCommand:'xxdir date.obj' inDirectory:'c:\winstx\stx\libbasic\objbc'.
     OperatingSystem executeCommand:'dir' inDirectory:'c:\'.
     OperatingSystem executeCommand:'dir'
    "

    "Modified: / 20.1.1998 / 17:03:03 / md"
    "Modified: / 10.11.1998 / 20:28:10 / cg"
    "Created: / 10.11.1998 / 21:05:45 / cg"
!

executeCommand:aCommandString outputTo:outStreamOrNil inDirectory:aDirectory
    "much like #executeCommand:, but changes the current directory
     for the command. Since this is OS specific, use this instead of
     hardwiring any 'cd ..' command strings into your applictions."

     ^ self
	executeCommand:aCommandString
	inputFrom:nil
	outputTo:outStreamOrNil
	errorTo:nil
	auxFrom:nil
	environment:nil
	inDirectory:aDirectory
	lineWise:false
	onError:[:status| false]

    "
     OperatingSystem executeCommand:'tdump date.obj' inDirectory:'c:\winstx\stx\libbasic\objbc'.
     OperatingSystem executeCommand:'xxdir date.obj' inDirectory:'c:\winstx\stx\libbasic\objbc'.
     OperatingSystem executeCommand:'dir' inDirectory:'c:\'.
     OperatingSystem executeCommand:'dir'
    "

    "Modified: / 20-01-1998 / 17:03:03 / md"
    "Created: / 23-01-2012 / 14:07:50 / cg"
!

executeCommand:aCommandString showWindow:aBooleanOrNil
    "execute the OS command specified by the argument, aCommandString.
     If aCommandString is a String, the commandString is passed to a shell for execution
     - see the description of 'sh -c' in your UNIX manual ('cmd.com' in your MSDOS manual).
     If aCommandString is an Array, the first element is the command to be executed,
     and the other elements are the arguments to the command.
     No shell is invoked in this case.
     This blocks the current thread until the command has finished.
     Return true if successful, false otherwise.

     Special for windows:
	you can control (have to - sigh) if a window should be shown for the command or not.
	This is the OS's H_SHOWWINDOW argument.
	If you pass nil as showWindow-argument, the OS's default is used for the particular
	command, which is correct most of the time: i.e. a notepad will open its window, other (non-UI)
	executables will not.
	However, some command-line executables show a window, even if they should not.
	(and also, there seems to be an inconsistency between windows7 and newer windows: in newer,
	 a shell command opens a cmd-window, whereas in windows7 it did not)
	In this case, pass an explicit false argument to suppress it.
	This argument is ignored on Unix systems.
	See examples below.
    "

     ^ self
	executeCommand:aCommandString
	inputFrom:nil
	outputTo:nil
	errorTo:nil
	auxFrom:nil
	environment:nil
	inDirectory:nil
	lineWise:false
	showWindow:aBooleanOrNil
	onError:[:status| false]

    "unix:

     OperatingSystem executeCommand:'sleep 30'.
     OperatingSystem executeCommand:'pwd'.
     OperatingSystem executeCommand:'ls -l'.
     OperatingSystem executeCommand:'invalidCommand'.
     OperatingSystem executeCommand:'rm /tmp/foofoofoofoo'.
    "

    "msdos:

     OperatingSystem executeCommand:'dir'
     OperatingSystem executeCommand:'dir' showWindow:false
     OperatingSystem executeCommand:'dir /w'
    "

    "vms:

     OperatingSystem executeCommand:'dir'
     OperatingSystem executeCommand:'purge'
     OperatingSystem executeCommand:'cc foo.c'
    "

    "Modified: / 7.1.1997 / 19:29:55 / stefan"
    "Modified: / 10.11.1998 / 20:55:37 / cg"
!

getCommandOutputFrom:aCommand
    "execute a simple command (such as hostname) and
     return the commands first line of output as a string (forget stdErr).
     If the command generates multiple output lines, only the first line is returned.
     If the commands does not generate any output, an empty string is returned;
     if the command fails, nil is returned."

    |result|

    result := self getCommandOutputFrom:aCommand maxNumberOfLines:1 errorDisposition:#discard.
    result notNil ifTrue:[
	^ result firstIfEmpty:['']
    ].
    ^ result

    "
     OperatingSystem getCommandOutputFrom:'hostname'
     OperatingSystem getCommandOutputFrom:'pwd'
     OperatingSystem getCommandOutputFrom:'sleep 1'
     OperatingSystem getCommandOutputFrom:'foo'
    "

!

getCommandOutputFrom:aCommand maxNumberOfLines:numLinesOrNil errorDisposition:errorDisposition
    "execute a simple command (such as hostname) and
     return the commands output as a collection of strings,
     but only up to the given number of lines (if non-nil).
     If the command generates more output, only the first nLines are returned
     (but the command is allowed to finish execution).
     If the commands does not generate any output, an empty string is returned;
     if the command fails, nil is returned.
     errorDisposition controls where the stdErr output should go,
     and may be one of #discard, #inline or #stderr (default).
     #discard causes stderr to be discarded (/dev/null),
     #inline causes it to be written to smalltalks own stdout and
     #stderr causes it to be written to smalltalks own stderr.
     Nil is treated like #stderr"

    |result|

    PipeFailed ~~ true ifTrue:[
	PipeStream openErrorSignal handle:[:ex |
	    PipeFailed := true.
	    'OperatingSystem [warning]: cannot fork/popen' errorPrintCR.
	    ex return.
	] do:[
	    |p line|

	    p := PipeStream
		    readingFrom:aCommand
		    errorDisposition:errorDisposition
		    inDirectory:nil.
	    result := StringCollection new.
	    [p atEnd] whileFalse:[
		line := p nextLine.
		(numLinesOrNil isNil
		or:[result size < numLinesOrNil]) ifTrue:[
		    result add:line
		].
	    ].
	    p close.
	    (p exitStatus notNil and:[p exitStatus success]) ifFalse:[
		result := result asNilIfEmpty
	    ].
	].
    ].
    ^ result

    "
     OperatingSystem getCommandOutputFrom:'ls' maxNumberOfLines:1
     OperatingSystem getCommandOutputFrom:'ls' maxNumberOfLines:10
     OperatingSystem getCommandOutputFrom:'ls' maxNumberOfLines:nil
     OperatingSystem getCommandOutputFrom:'foo' maxNumberOfLines:nil
    "

    "Modified: / 19.5.1999 / 14:25:02 / cg"
!

getFullCommandOutputFrom:aCommand
    "execute a command and
     return the commands output as a collection of strings (ignoring stdErr).
     If the commands does not generate any output, an empty string is returned;
     if the command fails, nil is returned."

    ^ self getCommandOutputFrom:aCommand maxNumberOfLines:nil errorDisposition:#discard

    "
     OperatingSystem getFullCommandOutputFrom:'mt status'
    "

! !

!AbstractOperatingSystem class methodsFor:'executing OS commands-queries'!

canExecuteCommand:aCommandString
    "return true, if the OS can execute aCommand.
     For now, this only works with UNIX."

    |fullPath|

    fullPath := self pathOfCommand:aCommandString.
    fullPath isNil ifTrue:[^ false].
    ^ fullPath asFilename isExecutableProgram.

    "
     OperatingSystem canExecuteCommand:'fooBar'
     OperatingSystem canExecuteCommand:'ls'
     OperatingSystem canExecuteCommand:'cvs'
     OperatingSystem canExecuteCommand:'diff'
     OperatingSystem canExecuteCommand:'cvs.exe'
     OperatingSystem canExecuteCommand:'hg'
     OperatingSystem pathOfCommand:'hg'
    "

    "Created: / 04-11-1995 / 19:13:54 / cg"
!

commandAndArgsForOSCommand:aCommandString
    "get a shell and shell arguments for command execution"

    self subclassResponsibility
!

executableFileExtensions
    "return a collection of extensions for executable program files.
     Only req'd for msdos & vms like systems ..."

    ^ #('')

    "Created: 2.5.1997 / 11:42:29 / cg"
!

nameOfSTXExecutable
    "return the name of the running ST/X executable program.
     Usually, 'stx' is returned -
     but may be different for standAlone apps (or winstx.exe)."

%{
    extern char *__stxExecutableName__();

    RETURN (__MKSTRING(__stxExecutableName__()));
%}
    "
     OperatingSystem nameOfSTXExecutable
    "
!

pathOfCommand:aCommand
    "find where aCommand's executable file is;
     return its full pathName if there is such a command, otherwise
     return nil."

    ^ self subclassResponsibility
!

pathOfSTXExecutable
    "return the full path of the running ST/X executable program.
     Usually, '.../stx' is returned -
     but may be different for standAlone apps (or winstx.exe)."

    |path|

    path := self pathOfCommand:(self nameOfSTXExecutable).
    path isNil ifTrue:[
	'./stx' asFilename exists ifTrue:[
	    path := './stx'
	].
	path isNil ifTrue:[
	     'OperatingSystem [warning]: cannot figure out my executable''s path' infoPrintCR.
	].
    ].
    ^ path

    "
     OperatingSystem pathOfSTXExecutable
    "

    "Modified: / 20-01-2012 / 12:52:46 / cg"
! !

!AbstractOperatingSystem class methodsFor:'executing OS commands-wrappers'!

exec:aCommandPath withArguments:argArray
    <resource: #obsolete>
    "execute the OS command specified by the argument, aCommandPath, with
     arguments in argArray (no arguments, if nil).
     If successful, this method does NOT return and smalltalk is gone.
     If not successful, it does return.
     Can be used on UNIX with fork or on other systems to chain to another program."

    ^ self
	exec:aCommandPath
	withArguments:argArray
	environment:nil
	fileDescriptors:#(0 1 2)
	fork:false
	newPgrp:false
	inDirectory:nil
	showWindow:false

    "/ never reached ...

    "Modified: / 12.11.1998 / 14:44:26 / cg"
!

exec:aCommandPath withArguments:argArray environment:env fileDescriptors:fds fork:doFork newPgrp:newGrp inDirectory:aDirectory
    <resource: #obsolete>
    "execute an OS command"

    ^ self
	exec:aCommandPath withArguments:argArray environment:env fileDescriptors:fds fork:doFork
	newPgrp:newGrp inDirectory:aDirectory showWindow:false

    "Created: / 12.11.1998 / 14:46:15 / cg"
!

exec:aCommandPath withArguments:argArray fileDescriptors:fileDescriptors fork:doFork newPgrp:newPgrp inDirectory:aDirectory
    <resource: #obsolete>
    ^ self
	exec:aCommandPath
	withArguments:argArray
	environment:nil
	fileDescriptors:fileDescriptors
	fork:doFork
	newPgrp:newPgrp
	inDirectory:aDirectory
	showWindow:false
!

exec:aCommandPath withArguments:argArray fork:doFork
    <resource: #obsolete>
    "execute an OS command without I/O redirection.
     The command reads its input and writes its output
     from/to whatever terminal device ST/X was started
     (typically, the terminal window)"

    ^ self
	exec:aCommandPath
	withArguments:argArray
	environment:nil
	fileDescriptors:#(0 1 2)
	fork:doFork
	newPgrp:false
	inDirectory:nil
	showWindow:false
    "
     |id|

     id := OperatingSystem fork.
     id == 0 ifTrue:[
	'I am the child'.
	OperatingSystem
	    exec:'/bin/ls'
	    withArguments:#('ls' '/tmp')
	    fork:false.
	'not reached'.
     ]
    "

    "
     |id|

     id := OperatingSystem fork.
     id == 0 ifTrue:[
	'I am the child'.
	OperatingSystem
	    exec:'/bin/sh'
	    withArguments:#('sh' '-c' 'sleep 2;echo 1;sleep 2;echo 2')
	    fork:false.
	'not reached'.
     ].
     id printNL.
     (Delay forSeconds:3.5) wait.
     'killing ...' printNL.
     OperatingSystem sendSignal:(OperatingSystem sigTERM) to:id.
     OperatingSystem sendSignal:(OperatingSystem sigKILL) to:id
    "

    "Modified: / 15.7.1997 / 15:54:32 / stefan"
    "Modified: / 12.11.1998 / 14:44:46 / cg"
!

exec:aCommandPath withArguments:argArray fork:doFork inDirectory:aDirectory
    <resource: #obsolete>
    "execute an OS command without I/O redirection.
     The command reads its input and writes its output
     from/to whatever terminal device ST/X was started
     (typically, the terminal window)"

    ^ self
	exec:aCommandPath
	withArguments:argArray
	environment:nil
	fileDescriptors:#(0 1 2)
	fork:doFork
	newPgrp:false
	inDirectory:aDirectory
	showWindow:false
    "
     |id|

     id := OperatingSystem fork.
     id == 0 ifTrue:[
	'I am the child'.
	OperatingSystem
	    exec:'/bin/ls'
	    withArguments:#('ls' '/tmp')
	    fork:false.
	'not reached'.
     ]
    "

    "
     |id|

     id := OperatingSystem fork.
     id == 0 ifTrue:[
	'I am the child'.
	OperatingSystem
	    exec:'/bin/sh'
	    withArguments:#('sh' '-c' 'sleep 2;echo 1;sleep 2;echo 2')
	    fork:false.
	'not reached'.
     ].
     id printNL.
     (Delay forSeconds:3.5) wait.
     'killing ...' printNL.
     OperatingSystem sendSignal:(OperatingSystem sigTERM) to:id.
     OperatingSystem sendSignal:(OperatingSystem sigKILL) to:id
    "

    "Created: / 28.1.1998 / 14:14:03 / md"
    "Modified: / 28.1.1998 / 14:14:45 / md"
    "Modified: / 12.11.1998 / 14:45:06 / cg"
!

exec:aCommandPath withArguments:argArray showWindow:showWindowBooleanOrNil
    <resource: #obsolete>
    "execute the OS command specified by the argument, aCommandPath, with
     arguments in argArray (no arguments, if nil).
     If successful, this method does NOT return and smalltalk is gone.
     If not successful, it does return.
     Can be used on UNIX with fork or on other systems to chain to another program."

    ^ self
	exec:aCommandPath
	withArguments:argArray
	environment:nil
	fileDescriptors:#(0 1 2)
	fork:false
	newPgrp:false
	inDirectory:nil
	showWindow:showWindowBooleanOrNil

    "/ never reached ...

    "Modified: / 12.11.1998 / 14:44:26 / cg"
!

startProcess:aCommandString
    <resource: #obsolete>

    ^ self
	startProcess:aCommandString inputFrom:nil outputTo:nil
	errorTo:nil auxFrom:nil environment:nil
	inDirectory:nil newPgrp:true showWindow:nil

    "
     |pid|

     pid := OperatingSystem startProcess:'sleep 2; echo 1; sleep 2; echo 2'.
     (Delay forSeconds:3) wait.
     OperatingSystem killProcess:pid.
    "
    "
     |pid|

     pid := OperatingSystem startProcess:'dir/l'.
     (Delay forSeconds:1) wait.
     OperatingSystem killProcess:pid.
    "
    "
     |pid|

     pid := OperatingSystem
		startProcess:'dir/l'
		inputFrom:nil
		outputTo:Stdout
		errorTo:nil
		inDirectory:nil.
     (Delay forSeconds:2) wait.
     OperatingSystem killProcess:pid.
    "

    "Modified: / 21.3.1997 / 10:04:35 / dq"
    "Modified: / 10.11.1998 / 21:03:50 / cg"
!

startProcess:aCommandString inDirectory:aDirectory
    <resource: #obsolete>

    ^ self
	startProcess:aCommandString inputFrom:nil outputTo:nil
	errorTo:nil auxFrom:nil environment:nil
	inDirectory:aDirectory newPgrp:true showWindow:nil
    "
     |pid|

     pid := OperatingSystem startProcess:'sleep 2; echo 1; sleep 2; echo 2'.
     (Delay forSeconds:3) wait.
     OperatingSystem killProcess:pid.
    "

    "Modified: / 21.3.1997 / 10:04:35 / dq"
    "Modified: / 28.1.1998 / 14:13:33 / md"
    "Modified: / 10.11.1998 / 20:59:33 / cg"
!

startProcess:aCommandString inputFrom:anExternalInStream outputTo:anExternalOutStream errorTo:anExternalErrStream
    <resource: #obsolete>

    ^ self
	startProcess:aCommandString inputFrom:anExternalInStream outputTo:anExternalOutStream
	errorTo:anExternalErrStream auxFrom:nil environment:nil
	inDirectory:nil newPgrp:true showWindow:nil
!

startProcess:aCommandString inputFrom:anExternalInStream outputTo:anExternalOutStream
    errorTo:anExternalErrStream auxFrom:anExternalAuxStreamOrNil environment:environment inDirectory:dir
    <resource: #obsolete>

    ^ self
	startProcess:aCommandString inputFrom:anExternalInStream outputTo:anExternalOutStream
	errorTo:anExternalErrStream auxFrom:anExternalAuxStreamOrNil environment:environment
	inDirectory:dir newPgrp:true showWindow:nil
!

startProcess:aCommandString inputFrom:anExternalInStream outputTo:anExternalOutStream
    errorTo:anExternalErrStream auxFrom:anExternalAuxStreamOrNil environment:environment
    inDirectory:dir showWindow:showWindowBooleanOrNil
    <resource: #obsolete>

    ^ self
	startProcess:aCommandString inputFrom:anExternalInStream outputTo:anExternalOutStream
	errorTo:anExternalErrStream auxFrom:anExternalAuxStreamOrNil environment:environment
	inDirectory:dir newPgrp:true showWindow:showWindowBooleanOrNil

    "Modified: / 08-11-2016 / 21:24:27 / cg"
!

startProcess:aCommandString inputFrom:anExternalInStream outputTo:anExternalOutStream
    errorTo:anExternalErrStream auxFrom:anAuxiliaryStream inDirectory:dir
    <resource: #obsolete>

    ^ self
	startProcess:aCommandString inputFrom:anExternalInStream outputTo:anExternalOutStream
	errorTo:anExternalErrStream auxFrom:nil environment:nil
	inDirectory:dir newPgrp:true showWindow:nil
!

startProcess:aCommandString inputFrom:anExternalInStream outputTo:anExternalOutStream errorTo:anExternalErrStream inDirectory:dir
    <resource: #obsolete>

    ^ self
	startProcess:aCommandString inputFrom:anExternalInStream outputTo:anExternalOutStream
	errorTo:anExternalErrStream auxFrom:nil environment:nil
	inDirectory:dir newPgrp:true showWindow:nil
! !

!AbstractOperatingSystem class methodsFor:'file access'!

closeFd:anInteger
    "low level close of a filedescriptor"

    self subclassResponsibility
!

copyFromFd:inFd toFd:outFd startIndex:startIdx count:count
    "directly copy from one FD to another (if supported by the OS)"

    ^ 0 "/ not supported
!

createDirectory:aPathName
    "create a new directory with name 'aPathName', which may be an absolute
     path, or relative to the current directory.
     Return nil if successful (or the directory existed already), an OsErrorHolder otherwise.
     This is a low-level entry - use Filename protocol for compatibility."

    self subclassResponsibility
!

createFileForReadAppend:pathName
    self subclassResponsibility
!

createFileForReadWrite:pathName
    "open a file for reading and writing, return an os specific fileHandle."

    self subclassResponsibility
!

createHardLinkFrom:oldPath to:newPath
    "link the file 'oldPath' to 'newPath'. The link will be a hard link.
     Return nil if successful, an OsErrorHolder if not."

    "/
    "/ assume that this OperatingSystem does not support links
    "/
    ^ OSErrorHolder unsupportedOperation

    "Created: / 13.8.1998 / 21:37:12 / cg"
    "Modified: / 13.8.1998 / 21:38:39 / cg"
!

createSymbolicLinkFrom:oldPath to:newPath
    "make a link from the file 'oldPath' to the file 'newPath'.
     The link will be a soft (symbolic) link.
     Return nil if successful, an OsErrorHolder if not."

    "/
    "/ assume that this OperatingSystem does not support symbolic links
    "/
    ^ OSErrorHolder unsupportedOperation

    "Created: / 13.8.1998 / 21:38:24 / cg"
    "Modified: / 13.8.1998 / 21:38:43 / cg"
!

linkFile:oldPath to:newPath
    <resource: #obsolete>
    "link the file 'oldPath' to 'newPath'. The link will be a hard link.
     Return true if successful, false if not.
     This method has been renamed - it remains in existance for
     backward compatibility."

    ^ self createHardLinkFrom:oldPath to:newPath

    "
     OperatingSystem linkFile:'foo' to:'bar'
    "

    "Modified: / 13.8.1998 / 21:37:24 / cg"
!

openFileForAppend:pathName
    "open a file for appending, return an os specific fileHandle."

    self subclassResponsibility
!

openFileForRead:pathName
    "open a file for reading, return an os specific fileHandle."

    self subclassResponsibility
!

openFileForReadAppend:pathName
    self subclassResponsibility
!

openFileForReadWrite:pathName
    "open a file for reading and writing, return an os specific fileHandle."

    self subclassResponsibility
!

openFileForWrite:pathName
    "open a file for writing, return an os specific fileHandle."

    self subclassResponsibility
!

recursiveCopyDirectory:fullPathName to:destinationPathName
    "copy the directory named 'fullPathName' and all contained
     files/directories recursively to destinationPathName.
     Return true if successful.
     Here, false is returned and the caller should be prepared
     for a fallBack solution.
     Notice:
	this is not a public interface; instead, it is used
	internally by the Filename class, to try a fast copy
	before doing things manually.
	Please use Filename recursiveCopyTo:"

    ^ false

    "
     OperatingSystem recursiveCopyDirectory:'.' to:'/tmp/foo'
     OperatingSystem recursiveRemoveDirectory:'/tmp/foo'
    "

    "Modified: / 5.5.1999 / 13:29:16 / cg"
!

recursiveCreateDirectory:dirName
    "create a directory - with all parent dirs if needed.
     Return nil if successful, an OsErrorHolder otherwise.
     On error, a partial created tree may be left, which is not cleaned-up here."

    |osErrorHolder nextDirName|

    self createDirectory:dirName.
    (self isDirectory:dirName) ifFalse:[
	nextDirName := dirName asFilename directoryName.
	dirName ~= nextDirName ifTrue:[
	    osErrorHolder := self recursiveCreateDirectory:nextDirName.
	    osErrorHolder notNil ifTrue:[
		^ osErrorHolder.
	    ].
	].
	^ self createDirectory:dirName.
    ].
    ^ nil.

    "
     OperatingSystem recursiveCreateDirectory:'foo/bar/baz'
     OperatingSystem recursiveRemoveDirectory:'foo'
     OperatingSystem recursiveCreateDirectory:'k:\bla\quark'
    "

    "Modified: 7.3.1996 / 15:26:22 / cg"
!

recursiveRemoveDirectory:fullPathName
    "remove the directory named 'fullPathName' and all contained files/directories.
     Return true if successful.
     Here, false is returned and the caller should be prepared
     for a fallBack solution.
     Notice:
	this is not a public interface; instead, it is used
	internally by the Filename class, to try a fast remove
	before doing things manually.
	Please use Filename recursiveRemoveDirectory:"

    ^ false

    "
     OperatingSystem recursiveCreateDirectory:'foo/bar/baz'
     OperatingSystem recursiveRemoveDirectory:'foo'
    "

    "Modified: / 5.5.1999 / 13:30:11 / cg"
!

removeDirectory:fullPathName
    "remove the directory named 'fullPathName'.
     The directory must be empty and you must have appropriate access rights.
     return nil if successful, an OSErrorHolder if directory is not empty or no permission.
     This is a lowLevel entry - use Filename protocol for compatibility."

    self subclassResponsibility
!

removeFile:fullPathName
    "remove the file named 'fullPathName'; return nil if successful, an OSErrorHolder on errror.
     This is a lowLevel entry - use Filename protocol for compatibility."

    self subclassResponsibility
!

renameFile:oldPath to:newPath
    "rename the file 'oldPath' to 'newPath'.
     Someone else has to care for the names to be correct and
     correct for the OS used - therefore, this should not be called
     directlt. Instead, use Filename protocol to rename; this cares for
     any invalid names.
     Returns nil if successful, an OsErrorHolder if not"

    self subclassResponsibility
!

sync
    "sync the filesystems - redefined in subclasses"
!

syncFileSystem:handle
    "sync the filesystem where the file represented by handle resides"

    "default is to do a global sync"
    self sync.
!

truncateFile:aPathName to:newSize
    "change a files size return nil on success, an OSErrorHolder on failure.
     This may not be supported on all architectures.

     This is a low-level entry - use Filename protocol."

    self subclassResponsibility
! !

!AbstractOperatingSystem class methodsFor:'file access rights'!

accessMaskFor:aSymbol
    "return the access bits mask for numbers as returned by
     OperatingSystem>>accessModeOf:
     and expected by OperatingSystem>>changeAccessModeOf:to:.
     Since these numbers are OS dependent, always use the mask
     (never hardcode 8rxxx into your code)."

    self subclassResponsibility
!

accessModeOf:aPathName
    "return a number representing access rights rwxrwxrwx for owner,
     group and others. Return nil if such a file does not exist.
     Notice that the returned number is OS dependent - use the
     modeMasks as returned by OperatingSystem>>accessMaskFor:"

    "
     this could have been implemented as:
	(self infoOf:aPathName) at:#mode
     but for huge directory searches the code below is faster
    "

    ^ (self infoOf:aPathName) at:#mode

   "
    (OperatingSystem accessModeOf:'/') printStringRadix:8
   "
!

accessModeOfFd:aFileDescriptor
    "return a number representing access rights rwxrwxrwx for owner,
     group and others. Return nil if such a file does not exist.
     Notice that the returned number is OS dependent - use the
     modeMasks as returned by OperatingSystem>>accessMaskFor:"

    ^ self subclassResponsibility
!

changeAccessModeOf:aPathName to:modeBits
    "change the access rights of aPathName to the OS dependent modeBits.
     You should construct this mask using accessMaskFor, to be OS
     independent. Return nil if changed,
     anOSErrorHolder if such a file does not exist or change was not allowd."

    self subclassResponsibility
!

changeAccessModeOfFd:aFileDescriptor to:modeBits
    "change the access rights of the file referenced by aFileDescriptor
     to the OS dependent modeBits.
     You should construct this mask using accessMaskFor, to be OS
     independent. Return true if changed,
     false if such a file does not exist or change was not allowd."

    ^ self subclassResponsibility
! !

!AbstractOperatingSystem class methodsFor:'file locking'!

lockFD:aFileDescriptor shared:isSharedReadLock blocking:blockIfLocked
   "set a lock on the file represented by aFileDescriptor.
    (such as returned by ExternalStream>>fileDescriptor).
    On some systems, only advisory locks are available -
    these depends on other accessors to also perform the locking operation.
    If they do not, they may still access the file
    (on some systems, locks are mandatory, on others, they are advisory).
    The isSharedReadLock argument (if true) specifies if multiple readers
    are to be allowed - if false, they are not.
    On some systems, all locks are non-exclusive locks.

    Returns true, if the lock was acquired, false otherwise.

    Notice, that not all OS's support these locks;
    on some, this may simply be a no-op.
    Also notice, that some systems block the process, to wait for the lock.
    This can (again: on some systems) be avoided by passing a false blockIfLocked
    argument."

    ^ false
!

supportsFileLinks
    "return true, if the OS supports file links (hard links).
     Typically, only unix returns true here."

    ^ false
!

supportsFileLocks
    "return true, if the OS supports file locking"

    ^ false

    "
     OperatingSystem supportsFileLocks
    "
!

supportsNonBlockingFileLocks
    "return true, if the OS supports nonBlocking file locking
     (i.e. with immediate return instead of waiting for the lock)"

    ^ false

    "
     OperatingSystem supportsNonBlockingFileLocks
    "
!

supportsSharedLocks
    "return true, if the OS supports shared (i.e. multiple reader)
     file locking. Assume false here - redefined in concrete classes."

    ^ false

    "
     OperatingSystem supportsNonBlockingFileLocks
    "

    "Modified: / 5.5.1999 / 01:08:03 / cg"
!

supportsSymbolicLinks
    "return true, if the OS supports symbolic links on files/directories.
     Typically, only Unix returns true here"

    ^ false
!

unlockFD:aFileDescriptor
    "clear a file lock on the file represented by aFileDescriptor,
     which was previously acquired by #lockFD:.
     Return false, if the unlock failed
     (which may happens when a wrong fd is passed,
      no lock was set previously, or the systsem does not support locks).
     Notice, that not all OS's support file locks;
     on some, this may simply be a no-op."

    ^ false

    "Modified: / 10.9.1998 / 17:54:15 / cg"
! !

!AbstractOperatingSystem class methodsFor:'file queries'!

caseSensitiveFilenames
    "return true, if the OS has caseSensitive file naming.
     On MSDOS, this will return false;
     on a real OS, we return true.
     Be aware, that OSX can be configured to be either.
     Also, that it actually depends on the mounted volume"

    "/ actually, this query is too general, as it may depend on the mounted volume;
    "/ so we need a query for a particular directory (and/or volume).
    self subclassResponsibility
!

caseSensitiveFilenamesIn:aFolderPath
    "return true, if the OS has caseSensitive file naming inside a folderPath.
     Be aware, that it actually depends on the mounted volume,
     so some concrete subclass may redefine this query."

    ^ self caseSensitiveFilenames
!

compressPath:pathName
    "return the pathName compressed - that is, remove all ..-entries
     and . entries. This does not always (in case of symbolic links)
     return the true pathName and is therefore used as a fallback
     if realPath and popen failed."

    self subclassResponsibility
!

directoryNameOf:aPath
    <resource:#obsolete>

    self obsoleteMethodWarning:'use asFilename directoryName'.
    ^ aPath asFilename directoryName
!

fileSeparator
    "return the character used to separate names in a path.
     This character differs for MSDOS and other systems,
     (but those are currently not supported - so this is some
      preparation for the future)"

    ^ $/   "/ must be redefined for systems, where this is not true (i.e. MSDOS)
!

getCurrentDirectory
    "get the current directory of the ST/X OS process"

    ^ self subclassResponsibility
!

getDiskInfoOf:aDirectoryPath
    "return some disk info.
     The amount of information returned depends upon the OS, and is
     not guaranteed to be consistent across architectures.
     On unix and msdos, the information returned is (at least):
	freeBytes
	totalBytes
     Do not depend on any information being present in the returned dictionary;
     users of this method should always use #at:ifAbsent:, and care for the absent case.
     Nil is returned if no such information can be obtained.
    "

    ^ nil

    "
     OperatingSystem getDiskInfoOf:'/'
     OperatingSystem getDiskInfoOf:'.'
    "

    "Modified: / 22.5.1999 / 00:36:06 / cg"
!

getDriveList
    "return a list of volumes in the system.
     On unix, no such thing like a volume exists
     - there, a syntetic list with root, home & current is returned.
     On MSDOS, a list of drive letters is (eventually) returned.
     On VMS, a list of volumes is (eventually) returned."

    "/
    "/ default: return an array filled with
    "/ root, home and current directories.
    "/
    ^ Array
	with:'/'
	with:(self getHomeDirectory)
	with:(Filename currentDirectory pathName)

    "Modified: / 5.5.1999 / 01:06:26 / cg"
!

getMountedVolumes
    "return info about mounted volumes.
     The amount of information returned depends upon the OS, and is
     not guaranteed to be consistent across architectures.
     On unix, the information returned is (at least):
	mountPoint - mount point
	fileSystem - device or NFS-remotePath
    "

    ^ #()

    "
     OperatingSystem getMountedVolumes
    "

    "Modified: / 22.5.1999 / 00:36:06 / cg"
!

getNullDevice
    "get the name of the null-device. Nil is returned if not supported"

    ^ nil

    "Created: / 19.5.1999 / 12:24:59 / cg"
!

getObjectFileInfoFor: aStringOrFilename
    "Return an info object for a given executable or shared object
     or throw an error if given file is not a valid an executable now
     shared object.

     The info object returned is OS-specific, however it responds to at
     least
	#isFor32BitArchitecture
	#isFor64BitArchitecture ... returns true, if the given object is for
				     32bit, 64bit architecture respectively
    "
    ^ self subclassResponsibility

    "Modified: / 26-03-2015 / 11:28:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getTrashDirectory
    "get the name of a trash folder (if the OS supports it),
     or nil, if not.
     Must be redefined to return non nil in concrete operating systems"

    ^ nil
!

idOf:aPathName
    "return the fileNumber (i.e. inode number) of a file.

     Not all operatingSystems may provide this - on those that do not,
     some dummy id will be returned.
     On unix, this information can be used to check for two files being
     physically identical, even if found in different directories
     (i.e. if they are hardLinked)."

    |i id|

    id := self primIdOf:aPathName.
    id notNil ifTrue:[^ id].

    i := self infoOf:aPathName.
    i notNil ifTrue:[^ i id].
    ^ nil.

    "
     OperatingSystem idOf:'/'
    "
!

infoOf:aPathName
    "return some object filled with info for the file 'aPathName';
     the info (for which corresponding access methods are understood by
     the returned object) is:
	 type            - a symbol giving the file's type
	 mode            - numeric access mode
	 uid             - owners user id
	 gid             - owners group id
	 size            - files size
	 id              - files number (i.e. inode number)
	 accessed        - last access time (as Timestamp)
	 modified        - last modification time (as Timestamp)
	 statusChanged   - last status change time (as Timestamp)
	 alternativeName - (windows only: the MSDOS name of the file)

     Some of the fields may be returned as nil on systems which do not provide
     all of the information.
     Return nil if such a file does not exist.
     For symbolic links (if supported by the OS),
     the info of the pointed-to-file (i.e. the target) is returned;
     use #linkInfoOf: to get info about the link itself.
    "

    self subclassResponsibility
!

isDirectory:aPathName
    "return true, if 'aPathName' is a valid directory path name.
     (i.e. exists and is a directory).
     This also returns true for symbolic links pointing to a directory;
     if you need to check for this, use #linkInfo:."

    ^ (self infoOf:aPathName) type == #directory
!

isExecutable:aPathName
    "return true, if the given file is executable.
     For symbolic links, the pointed-to-file is checked."

    self subclassResponsibility
!

isMountPoint:aPathName
    "return true, if the given file is a mounted fileSystems mountPoint"

    ^ self mountPoints contains:[:mountInfo | mountInfo mountPointPath = aPathName].

    "
     OperatingSystem isMountPoint:'/phys/qnx'
     OperatingSystem isMountPoint:'/proc'
     OperatingSystem isMountPoint:'/'
    "
!

isReadable:aPathName
    "return true, if the file/dir 'aPathName' is readable.
     For symbolic links, the pointed-to-file is checked."

    self subclassResponsibility
!

isSymbolicLink:aPathName
    "return true, if the given file is a symbolic link"

    |info|

    info := self linkInfoOf:aPathName.
    ^ info notNil and:[info isSymbolicLink]

    "
     OperatingSystem isSymbolicLink:'Makefile'
     OperatingSystem isSymbolicLink:'/usr/tmp'
    "
!

isValidPath:aPathName
    "return true, if 'aPathName' is a valid path name
     (i.e. the file or directory exists)"

    self subclassResponsibility
!

isWritable:aPathName
    "return true, if the given file is writable.
     For symbolic links, the pointed-to-file is checked."

    self subclassResponsibility
!

linkInfoOf:aPathName
    "return a dictionary filled with info for the file 'aPathName',
     IFF aPathName is a symbolic link.
     If aPathName is invalid, nil is returned.
     If aPathName is NOT a symbolic link, the #infoOf: aPathname itself is returned.
     (which means, that systems like VMS or MSDOS always return the info here.)

     The contents of the dictionary gives info about the link itself,
     on contrast to #infoOf:, which returns the info of the pointed to file
     in case of a symbolic link."

    self subclassResponsibility
!

mimeTypeForFilename:aFilename
    "given a filename, return a corresponding mimeType.
     This is placed here, to allow for OS-specific configuration
     files and/or the win32 registry to be consultet.
     Returns nil if no mimeType for the given name is known."

    ^ nil
!

mimeTypeForSuffix:aFileSuffix
    "given a file suffix, return a corresponding mimeType.
     This is placed here, to allow for OS-specific configuration
     files and/or the win32 registry to be consultet.
     Returns nil if no mimeType for the given suffix is known."

    ^ nil
!

mountPoints
    "return a collection of mountPoints (aka. topDirectories of mounted file systems)"

    ^ #()  "/ don't know here
!

parentDirectoryName
    "return the name used to refer to parent directories.
     In MSDOS, Unix and other systems this is '..', but maybe different
     for other systems.
     (but those are currently not supported - so this is some
      preparation for the future)"

    ^ '..'
!

pathNameForDrive:driveName
    "given a drive name, return the pathname to open it as a directory.
     For Windows, this is the driveName itself.
     For OSX, '/Volumes' is prepended.
     Other OSs might prepent the pount point (i.e. /mnt/)"

    ^ driveName
!

pathNameOf:pathName
    "return the pathName of the argument, aPathString,
     - that's the full pathname of the directory, starting at '/'.
     This method needs the path to be valid
     (i.e. all directories must exist, be readable and executable).
     Notice: if symbolic links are involved, the result may look different
     from what you expect."

    self subclassResponsibility
!

primIdOf:aPathName
    "the actual code to return the fileNumber (i.e. inode number) of a file."

    self subclassResponsibility
!

timeOfLastAccess:aPathName
    "return the time, when the file was last accessed.
     For nonexistent files, nil is returned."

    ^ (self infoOf:aPathName) accessTime
!

timeOfLastChange:aPathName
    "return the time, when the file was last changed.
     For nonexistent files, nil is returned."

    ^ (self infoOf:aPathName) modificationTime
!

typeOf:aPathName
    "return the type of a file as a symbol; for nonexistent files,
     nil is returned.
     Notice: for symbolic links, the type of the pointed-to file is returned."

    ^ (self infoOf:aPathName) type
!

volumeNameOf:aPathString
    "return the volumeName of the argument, aPath
     - that's the name of the volume where aPath is.
     Not all OperatingSystems support/use volumes; on unix,
     this always returns an empty string."

    ^ ''
! !

!AbstractOperatingSystem class methodsFor:'interprocess communication'!

createCOMFileForVMSCommand:aCommandString in:aDirectory
    "this is only implemented/required for VMS systems, to execute commands"

    ^ self unsupportedOperationSignal raise

    "Created: / 19.5.1999 / 12:16:31 / cg"
    "Modified: / 19.5.1999 / 14:22:05 / cg"
!

createMailBox
    "this is only implemented/required for VMS systems, to emulate pipes"

    ^ self unsupportedOperationSignal raise

    "Created: / 19.5.1999 / 12:14:56 / cg"
    "Modified: / 19.5.1999 / 14:22:22 / cg"
!

destroyMailBox:mbx
    "this is only implemented/required for VMS systems, to emulate pipes"

    ^ self unsupportedOperationSignal raise

    "Created: / 19.5.1999 / 12:16:43 / cg"
    "Modified: / 19.5.1999 / 14:22:33 / cg"
!

mailBoxNameOf:mbx
    "this is only implemented/required for VMS systems, to emulate pipes"

    ^ self unsupportedOperationSignal raise

    "Created: / 19.5.1999 / 12:14:56 / cg"
    "Modified: / 19.5.1999 / 14:22:40 / cg"
!

makeBidirectionalPipe
    "answer an array with 2 filedescriptors representing
     the two ends of a bidirectional pipe - see also #makePipe"

    ^ self subclassResponsibility
!

makePipe
    "answer an array with 2 filedescriptors representing
     the two ends of a unidirectional pipe- see also #makeSocketPair"

    ^ self subclassResponsibility
!

shutdownBidirectionalPipeOutput:fileDescriptor
    "inform the other end of the bidirectional pipe represented by fileDescriptor, that
     we will send no more data to the pipe, i.e. EOF is reached"

    ^ self subclassResponsibility
! !

!AbstractOperatingSystem class methodsFor:'interrupts & signals'!

blockInterrupts
    "disable interrupt processing - if disabled, incoming
     interrupts will be registered and handled as soon as
     interrupts are reenabled by OperatingSystemclass>>unblockInterrupts.
     Returns the previous blocking status i.e. true if interrupts
     where already blocked. You need this information for proper
     unblocking, in case of nested block/unblock calls."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return __c__._RETURN( __c__.blockInterrupts() ? STObject.True : STObject.False);
#else
    RETURN ( __BLOCKINTERRUPTS() );
#endif /* not SCHTEAM */
%}
!

defaultSignal:signalNumber
    "revert to the default action on arrival of a (Unix-)signal.
     Do not confuse Unix signals with smalltalk signals.
     WARNING: for some signals, it is no good idea to revert to default;
     for example, the default for SIGINT (i.e. ^C) is to exit; while the
     default for SIGQUIT (^ \) is to dump core.
     Also, NOTICE that signal numbers are not portable between Unix
     systems - use OperatingSystem sigXXX to get the numeric value for
     a signal."

    self subclassResponsibility
!

disableChildSignalInterrupts
    "disable childSignal interrupts
     (SIGCHLD, if the architecture supports it).
     We have to set the signal back to default, because ignoring
     SIGCHLD breaks wait & co"

    ^ self defaultSignal:(self sigCHLD)

    "Created: 5.1.1996 / 15:45:28 / stefan"
!

disableIOInterruptsOn:fd
    "turn off IO interrupts for a filedescriptor"

    self subclassResponsibility
!

disableSignal:signalNumber
    "disable (Unix-) signal processing for signalNumber.
     Do not confuse Unix signals with smalltalk signals.
     WARNING: for some signals, it is no good idea to disable
     them; for example, disabling the SIGINT signal turns off ^C
     handling.
     Also, NOTICE that signal numbers are not portable between Unix
     systems - use OperatingSystem sigXXX to get the numeric value for
     a signal.
     Use only for fully debugged stand alone applications."

    self subclassResponsibility
!

disableTimer
    "disable timer interrupts.
     WARNING:
	the system will not operate correctly with timer interrupts
	disabled, because no scheduling or timeouts are possible."

    self subclassResponsibility
!

disableUserInterrupts
    "disable userInterrupt processing;
     when disabled, no ^C processing takes place.
     WARNING:
	 If at all, use this only for debugged stand-alone applications, since
	 no exit to the debugger is possible with user interrupts disabled.
	 We recommend setting up a handler for the signal instead of disabling it."

    self disableSignal:(self sigBREAK).
    self disableSignal:(self sigINT).
!

enableAbortInterrupts
    "enable SIGABRT signal handling, and make it a regular signalInterrupt.
     (the default will dump core and exit - which is not a good idea for
      end-user applications ...).
     After enabling, these exceptions will send the message
     'signalInterrupt' to the SignalInterruptHandler object.
     This is especially useful, if linked-in C-libraries call abort() ..."

    self enableSignal:(self sigABRT)

    "
     OperatingSystem enableAbortInterrupts
    "
!

enableChildSignalInterrupts
    "enable child process interrupts
     (SIGCHLD, if the architecture supports it).
     After enabling, these signals will send the message
     'childSignalInterrupt' to the ChildSignalInterruptHandler object."

    self enableSignal:(self sigCHLD)
!

enableCrashSignalInterrupts
    "enable powerFail signal exception interrupts (sigPWR).
     After enabling, this signal will trigger the writing of a crash-image"

    self enableSignal:(self sigPWR).
    self enableSignal:(self sigHUP)
!

enableFpExceptionInterrupts
    "enable floating point exception interrupts (if the architecture supports it).
     After enabling, fpu-exceptions will send the message
     'fpuExceptionInterrupt' to the FPUExceptionInterruptHandler object."

    self enableSignal:(self sigFP)
!

enableHardSignalInterrupts
    "enable hard signal exception interrupts (trap, bus error & segm. violation).
     After enabling, these exceptions will send the message
     'signalInterrupt' to the SignalInterruptHandler object."

    "/ leads to trouble ...
    "/    self enableSignal:(self sigPIPE).
    "/ ... better to ignore them, and let it be handled as a writeErrorSignal.

    self disableSignal:(self sigPIPE).

    self enableSignal:(self sigILL).
    self enableSignal:(self sigBUS).
    self enableSignal:(self sigSEGV).
    self enableSignal:(self sigFP).
    self enableSignal:(self sigEMT).
!

enableIOInterruptsOn:fd
    "turn on IO interrupts for a filedescriptor"

    self subclassResponsibility
!

enableQuitInterrupts
    "enable quitInterrupt (usually ^\) handling, and make it a userInterrupt.
     (the default will dump core and exit - which is not a good idea for
      end-user applications ...)"

    self enableSignal:(self sigQUIT)
!

enableSignal:signalNumber
    "enable (Unix-)signal processing for signalNumber.
     Don't confuse Unix signals with smalltalk signals.
     The signal will be delivered to one of the standard handlers
     (SIGINT, SIGQUIT, etc) or to a general handler, which
     sends #signalInterrupt:.

     NOTICE that signal numbers are not portable between unix
     systems - use OperatingSystem sigXXX to get the numeric value for
     a signal."

    self subclassResponsibility
!

enableTimer:milliSeconds
    "setup for a timerInterrupt, to be signalled after some (real) time."

    self subclassResponsibility
!

enableUserInterrupts
    "enable userInterrupt (^C) handling;
     when enabled, ^C in the terminal window will send the message
     'userInterrupt' to the UserInterruptHandler object."

    self enableSignal:(self sigINT).
    self enableSignal:(self sigBREAK).
!

interruptPending
    "return true, if an interrupt is pending. The returned value is
     invalid if interrupts are not currently blocked, since otherwise
     the interrupt is usually already handled before arriving here,
     or may be served while returning from here."

%{  /* NOCONTEXT */
    extern OBJ __INTERRUPTPENDING();

    RETURN ( __INTERRUPTPENDING() );
%}
!

interruptProcess:processId
    "interrupt an OS process (CTRL-C)."

    self subclassResponsibility
!

interruptProcessGroup:processGroupId
    "interrupt an OS process group (CTRL-C)."

    self subclassResponsibility
!

interruptsBlocked
    "return true, if interrupt handling is currently disabled;
     false otherwise."

%{  /* NOCONTEXT */
    extern OBJ __INTERRUPTS_BLOCKED();

    RETURN ( __INTERRUPTS_BLOCKED() );
%}
!

isFatalSignal:aNumber
   "return true if a signal with number aNumber is a fatal signal,
    i.e. some severe internal error occurred"

   ^ self subclassResponsibility
!

killProcess:processId
    "kill an OS process.
     The process has a no chance to do some cleanup.

     WARNING: in order to avoid zombie processes (on unix),
	      you may have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId."

    self subclassResponsibility

    "Modified: / 10.6.1998 / 12:00:07 / cg"
!

killProcessGroup:processGroupId
    "kill an OS process group.
     The process has NO chance to do some cleanup.

     WARNING: in order to avoid zombie processes (on unix),
	      you may have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId."

    self subclassResponsibility

    "Created: / 10.6.1998 / 12:00:26 / cg"
!

nameForSignal:aSignalNumber
    "for a given Unix signalnumber, return a descriptive string"

    aSignalNumber == self sigHUP    ifTrue:[^ 'hangup'].
    aSignalNumber == self sigINT    ifTrue:[^ 'interrupt'].
    aSignalNumber == self sigKILL   ifTrue:[^ 'kill'].
    aSignalNumber == self sigQUIT   ifTrue:[^ 'quit'].
    aSignalNumber == self sigILL    ifTrue:[^ 'illegal instruction'].
    aSignalNumber == self sigTRAP   ifTrue:[^ 'trap'].
    aSignalNumber == self sigABRT   ifTrue:[^ 'abort'].
    aSignalNumber == self sigIOT    ifTrue:[^ 'iot trap'].
    aSignalNumber == self sigEMT    ifTrue:[^ 'emt trap'].
    aSignalNumber == self sigFP     ifTrue:[^ 'fp exception'].
    aSignalNumber == self sigBUS    ifTrue:[^ 'bus error'].
    aSignalNumber == self sigSEGV   ifTrue:[^ 'segmentation violation'].
    aSignalNumber == self sigSYS    ifTrue:[^ 'bad system call'].
    aSignalNumber == self sigPIPE   ifTrue:[^ 'broken pipe'].
    aSignalNumber == self sigALRM   ifTrue:[^ 'alarm timer'].
    aSignalNumber == self sigTERM   ifTrue:[^ 'termination'].
    aSignalNumber == self sigSTOP   ifTrue:[^ 'stop'].
    aSignalNumber == self sigTSTP   ifTrue:[^ 'tty stop'].
    aSignalNumber == self sigCONT   ifTrue:[^ 'continue'].
    aSignalNumber == self sigCHLD   ifTrue:[^ 'child death'].
    aSignalNumber == self sigTTIN   ifTrue:[^ 'background tty input'].
    aSignalNumber == self sigTTOU   ifTrue:[^ 'background tty output'].
    aSignalNumber == self sigIO     ifTrue:[^ 'io available'].
    aSignalNumber == self sigXCPU   ifTrue:[^ 'cpu time expired'].
    aSignalNumber == self sigXFSZ   ifTrue:[^ 'file size limit'].
    aSignalNumber == self sigVTALRM ifTrue:[^ 'virtual alarm timer'].
    aSignalNumber == self sigPROF   ifTrue:[^ 'profiling timer'].
    aSignalNumber == self sigWINCH  ifTrue:[^ 'winsize changed'].
    aSignalNumber == self sigLOST   ifTrue:[^ 'resource lost'].
    aSignalNumber == self sigUSR1   ifTrue:[^ 'user signal 1'].
    aSignalNumber == self sigUSR2   ifTrue:[^ 'user signal 2'].
    aSignalNumber == self sigMSG    ifTrue:[^ 'HFT message'].
    aSignalNumber == self sigPWR    ifTrue:[^ 'power-fail'].
    aSignalNumber == self sigPRE    ifTrue:[^ 'programming exception'].
    aSignalNumber == self sigGRANT  ifTrue:[^ 'HFT access wanted'].
    aSignalNumber == self sigRETRACT ifTrue:[^ 'HFT access relinquish'].
    aSignalNumber == self sigSOUND   ifTrue:[^ 'HFT sound complete'].
    aSignalNumber == self sigDANGER  ifTrue:[^ 'low on paging space'].

    "notice: many systems map SIGPOLL and/or SIGUSR onto SIGIO
	     therefore, keep SIGIO always above the two below"
    aSignalNumber == self sigPOLL   ifTrue:[^ 'io available'].
    aSignalNumber == self sigURG    ifTrue:[^ 'urgent'].

    ^ 'unknown signal'

    "
     OperatingSystem nameForSignal:9
     OperatingSystem nameForSignal:(OperatingSystem sigPOLL)
    "
!

operatingSystemSignal:signalNumber
    "return the signal to be raised when an
     operatingSystem-signal occurs, or nil"

    OSSignals notNil ifTrue:[
	^ OSSignals at:signalNumber ifAbsent:[nil]
    ].
    ^ nil
!

operatingSystemSignal:signalNumber install:aSignal
    "install a signal to be raised when an operatingSystem-signal occurs"

    OSSignals isNil ifTrue:[
	OSSignals := Array new:32
    ].
    OSSignals at:signalNumber put:aSignal
!

sendSignal:signalNumber to:processId
    "send a unix signal to some process (maybe myself).
     Returns false if any error occurred, true otherwise.

     Do not confuse UNIX signals with Smalltalk-Signals."

    self subclassResponsibility
!

sendSignal:signalNumber to:processId toGroup:toGroupBoolean toAll:toAllBoolean
    "send a unix signal to some process (maybe myself).
     Returns false if any error occurred, true otherwise.

     Do not confuse UNIX signals with Smalltalk-Signals."

    self subclassResponsibility
!

startSpyTimer
    "trigger a spyInterrupt, to be signalled after some short (virtual) time.
     Return true, if the spy-timerInterrupt was enabled.
     This was used by the old MessageTally for profiling.
     On systems, where no virtual timer is available, use the real timer
     (which is of course less correct).
     OBSOLETE: the new messageTally runs as a high prio process, not using
	       spy interrupts."

    ^ false
!

stopSpyTimer
    "stop spy timing - disable spy timer.
     OBSOLETE: the new messageTally runs as a high prio process, not using
	       spy interrupts."

    ^ false
!

terminateProcess:processId
    "terminate a unix process.
     The process has a chance to do some cleanup.

     WARNING: in order to avoid zombie processes (on unix),
	      you may have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId."

    self subclassResponsibility
!

terminateProcessGroup:processGroupId
    "terminate a unix process group.
     The process has a chance to do some cleanup.

     WARNING: in order to avoid zombie processes (on unix),
	      you may have to fetch the processes exitstatus with
	      OperatingSystem>>getStatusOfProcess:aProcessId."

    self subclassResponsibility
!

unblockInterrupts
    "enable interrupt processing - if any interrupts are pending,
     these will be handled immediately.
     When unblocking interrupts, take care of nested block/unblock
     calls - you must only unblock after a blockcall if they where
     really not blocked before. See OperatingSystemclass>>blockInterrupts."
%{
#ifdef __SCHTEAM__
    return __c__._RETURN( __c__.unblockInterrupts() ? STObject.True : STObject.False);
#else
    RETURN(__UNBLOCKINTERRUPTS());
#endif
%}
! !

!AbstractOperatingSystem class methodsFor:'misc'!

closePid:pid
    "free pid resource.
     Not required for Unix, but Windoze requires it."

    ^ true.

    "Created: / 28.1.1998 / 14:23:04 / md"
    "Modified: / 28.1.1998 / 14:27:18 / md"
    "Modified: / 5.6.1998 / 18:38:46 / cg"
!

exit
    "shutdown smalltalk immediately - this method does not return.
     Return 'good'-status (0) to the parent unix process."

    self exit:0.

    "OperatingSystem exit - don't evaluate this"
!

exit:exitCode
    "shutdown smalltalk immediately -
     returning an exit-code to the parent unix process."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    int code = 1;

    if (exitCode.isSmallInteger()) {
	code = exitCode.intValue();
    }
    STMain.mainExit(code);
#else
    int code = 1;

    if (__isSmallInteger(exitCode)) {
	code = __intVal(exitCode);
    }
    __mainExit(code);
#endif
%}
    "OperatingSystem exit:1 - don't evaluate this"
!

exitWithCoreDump
    "shutdown smalltalk immediately - dumping core.
     This always returns 'bad'-status to the parent unix process.
     Notice, that no cleanup is performed at all - you may have to
     manually remove any tempfiles.
     Use this only for debugging ST/X itself"

%{  /* NOCONTEXT */
    extern void abort();

    abort();
%}.
    "/ fall back for systems without primitive C code
    self exit:1

    "
     OperatingSystem exitWithCoreDump - don't evaluate this
    "
!

getAllProcesses
   "get a list of the running OS processes.
    Some OperatingSystems (Windows) support this.
    The default is to answer an empty list."

   ^ #().
!

getVMSSymbol:aSymbolString
    "get a symbols value, or nil if there is none"

    ^ nil

    "Created: / 5.6.1998 / 19:02:50 / cg"
    "Modified: / 5.6.1998 / 19:03:15 / cg"
!

playSound:fileName
    "unsupported - simply stay silent"

    ^ self.
!

playSound:fileName mode:modeInteger
    "unsupported - simply stay silent"

    ^ self.
! !

!AbstractOperatingSystem class methodsFor:'obsolete'!

baseNameOf:aPath
    <resource:#obsolete>

    self obsoleteMethodWarning:'use asFilename baseName'.
    ^ aPath asFilename baseName
!

executeCommand:aCommandString onError:aBlock inDirectory:aDirectory
    "OBSOLETE for backward compatibility.
     execute the unix command specified by the argument, aCommandString.
     The commandString is passed to a shell for execution - see the description of
     'sh -c' in your UNIX manual.
     Return true if successful, the value from aBlock if not.
     If not successfull, aBlock is called with an OsProcessStatus
     (containing the exit status) as argument."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use executeCommand:inDirectory:onError:'.

    ^ self
	executeCommand:aCommandString
	inputFrom:nil
	outputTo:nil
	errorTo:nil
	auxFrom:nil
	environment:nil
	inDirectory:aDirectory
	lineWise:false
	onError:aBlock

    "Modified: / 10.11.1998 / 20:54:37 / cg"
! !

!AbstractOperatingSystem class methodsFor:'os queries'!

getCCDefine
    <resource: #obsolete>

    "return a string which was used to identify the C-Compiler used
     when STX was compiled, and which should be passed down when compiling methods.
     For example, on linux, this is '__GNUC__';
     on windows, this could be '__VISUALC__', '__BORLANDC__' or '__MINGW__'"

    self obsoleteMethodWarning.
    ^ STCCompilerInterface getCCDefine

    "
     OperatingSystem getCCDefine
    "
!

getCPUDefine
    <resource: #obsolete>
    "return a string which was used to identify this CPU type when STX was
     compiled, and which should be passed down when compiling methods.
     For example, on linux, this may be '-D__x86__'; on a vax, this would be '-D__vax__'.
     This is normally not of interest to 'normal' users; however, it is passed
     down to the c-compiler when methods are incrementally compiled to machine code."

    self obsoleteMethodWarning.
    ^ STCCompilerInterface getCPUDefine

    "
     OperatingSystem getCPUDefine
    "
!

getCPUType
    "return a string giving the type of machine we're running on.
     Here, the machine for which ST/X was compiled is returned
     (i.e. for all x86's, the same i386 is returned).
     This may normally not be of any interest to you ..."

    |cpu|

%{  /* NOCONTEXT */

#   ifdef __vax__
#    define CPU_SYMBOL @symbol(vax)
#   endif
#   ifdef __mips__
#    define CPU_SYMBOL @symbol(mips)
#   endif
#   if defined(__x86__)
#    define CPU_SYMBOL @symbol(x86)
#   elif defined(__i386__) // old style
#    define CPU_SYMBOL @symbol(i386)
#   endif
#   ifdef __x86_64__
#    define CPU_SYMBOL @symbol(x86_64)
#   endif
#   ifdef __i860__
#    define CPU_SYMBOL @symbol(i860)
#   endif
#   ifdef __ns32k__
#    define CPU_SYMBOL @symbol(ns32k)
#   endif
#   ifdef __mc68k__
#    define CPU_SYMBOL @symbol(mc68k)
#   endif
#   ifdef __mc88k__
#    define CPU_SYMBOL @symbol(mc88k)
#   endif
#   ifdef __sparc__
#    define CPU_SYMBOL @symbol(sparc)
#   endif
#   ifdef __hppa__
#    define CPU_SYMBOL @symbol(hppa)
#   endif
#   ifdef __rs6000__
#    define CPU_SYMBOL @symbol(rs6000)
#   endif
#   ifdef __powerPC__
#    define CPU_SYMBOL @symbol(powerPC)
#   endif
#   ifdef __alpha__
#    define CPU_SYMBOL @symbol(alpha)
#   endif
#   ifdef __transputer__
#    define CPU_SYMBOL @symbol(transputer)
#   endif
#   ifdef __ibm370__
#    define CPU_SYMBOL @symbol(ibm370)
#   endif
#   ifdef __s390__
#    define CPU_SYMBOL @symbol(s390)
#   endif
#   ifdef __arm__
#    define CPU_SYMBOL @symbol(arm)
#   endif
#   ifdef __ia64__
#    define CPU_SYMBOL @symbol(ia64)
#   endif

#   ifndef CPU_SYMBOL
#    define CPU_SYMBOL @symbol(unknown)
#   endif

    cpu = CPU_SYMBOL;
#   undef CPU_SYMBOL
%}.
    ^ cpu

    "
     OperatingSystem getCPUType
    "

    "examples: are we running on a ss-10/solaris ?"
    "
     (OperatingSystem getCPUType = 'sparc')
     and:[OperatingSystem getOSType = 'solaris']
    "

    "or on a pc/solaris ?"
    "
     (OperatingSystem getCPUType = 'i386')
     and:[OperatingSystem getOSType = 'solaris']
    "
!

getDomainName
    "return the domain this host is in.
     Notice:
	not all systems support this; on some, 'unknown' is returned."

    self subclassResponsibility
!

getEnvironment
    "get all environment variables as a key-value dictionary"

    ^ self subclassResponsibility

    "Created: / 15-11-2016 / 16:34:10 / cg"
!

getEnvironment:aStringOrSymbol
    "get an environment string"

    ^ self subclassResponsibility
!

getHostName
    "return the hostname we are running on -
     a fully qalified hostname at best.

     Notice:
	not all systems support this; on some, 'unknown' is returned."

    self subclassResponsibility
!

getLanguage
    Language isNil ifTrue:[ 
        self initializeLocale.
    ].
    ^ Language

    "Created: / 19-11-2017 / 14:21:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getLanguageTerritory
    LanguageTerritory isNil ifTrue:[ 
        self initializeLocale.
    ].   
    ^ LanguageTerritory

    "Created: / 19-11-2017 / 14:22:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getLocaleInfo
    "return a dictionary filled with values from the locale information;
     Not all fields may be present, depending on the OS's setup and capabilities.
     Possible fields are:
	decimalPoint                    <String>

	thousandsSep                    <String>

	internationalCurrencySymbol     <String>

	currencySymbol                  <String>

	monetaryDecimalPoint            <String>

	monetaryThousandsSeparator      <String>

	positiveSign                    <String>

	negativeSign                    <String>

	internationalFractionalDigits   <Integer>

	fractionalDigits                <Integer>

	positiveSignPrecedesCurrencySymbol      <Boolean>

	negativeSignPrecedesCurrencySymbol      <Boolean>

	positiveSignSeparatedBySpaceFromCurrencySymbol  <Boolean>

	negativeSignSeparatedBySpaceFromCurrencySymbol  <Boolean>

	positiveSignPosition                            <Symbol>
							one of: #parenthesesAround,
								#signPrecedes,
								#signSuceeds,
								#signPrecedesCurrencySymbol,
								#signSuceedsCurrencySymbol

	negativeSignPosition                            <like above>

     it is up to the application to deal with undefined values.

     Notice, that (for now), the system does not use this information;
     it should be used by applications as required.
    "

    self subclassResponsibility
!

getNetworkAddressInfo
    "return a Dictionary of network interface information.
	key -> name of interface
	value -> a Set of network address
		information for the interface - a dictionaries containing the
		information about the configuration of each interface in the system.
		The dictionary keys are:
		    #address
		    #netmask
		    #flags
		    #destAddress"

    ^ self subclassResponsibility
!

getNetworkAddresses
    "return a dictionary with key:name of interface and
			    value:the network address for each interface"

    self subclassResponsibility
!

getNetworkMACAddresses
    "return a dictionary with key:name of interface and
			    value:the MAC address for each interface"

    self subclassResponsibility
!

getNetworkMACAddressesForIf:ifName
    "return the MAC address for interface ifName"

    ^ self getNetworkMACAddresses at:ifName ifAbsent:nil

    "Modified: / 17-11-2004 / 01:43:35 / cg"
!

getNumberOfProcessors
    "answer the number of physical processors in the system"

    self subclassResponsibility
!

getOSDefine
    <resource: #obsolete>

    "return a string which was used to identify this machine when stx was
     compiled, and which should be passed down when compiling methods.
     For example, on linux, this is '-D__linux__'."

    self obsoleteMethodWarning.
    ^ STCCompilerInterface getOSDefine

    "
     OperatingSystem getOSDefine
    "
!

getOSType
    "return a string giving the type of OS we're running on.
     This can be used to adapt programs to certain environment
     differences (for example: mail-lock strategy ...)"

    |os|

%{  /* NOCONTEXT */

    // do not do this; all win sytems are counted as win32 (for now);
    // see the detailed getSystemType / getSytemInfo for that
    // #   ifdef __win64__
    // #    define OS_SYMBOL @symbol(win64)
    // #   endif

#   ifdef __win32__
#    define OS_SYMBOL @symbol(win32)
#   endif

#   ifdef __MSWINDOWS__
#    define OS_SYMBOL @symbol(mswindows)
#   endif

#   ifdef __OS2__
#    define OS_SYMBOL @symbol(os2)
#   endif

#   ifdef __BEOS__
#    define OS_SYMBOL @symbol(beos)
#   endif

#   ifdef __MSDOS__
#    define OS_SYMBOL @symbol(msdos)
#   endif

#   ifdef __VMS__
#    ifdef __openVMS__
#     define OS_SYMBOL @symbol(openVMS)
#    else
#     define OS_SYMBOL @symbol(VMS)
#    endif
#   endif

#   ifdef __MVS__ /* ;-) */
#    define OS_SYMBOL @symbol(mvs)
#   endif

#   ifdef __sinix__
#    define OS_SYMBOL @symbol(sinix)
#   endif

#   ifdef __ultrix__
#    define OS_SYMBOL @symbol(ultrix)
#   endif

#   ifdef __sco__
#    define OS_SYMBOL @symbol(sco)
#   endif

#   ifdef __hpux__
#    define OS_SYMBOL @symbol(hpux)
#   endif

#   ifdef __linux__
#    define OS_SYMBOL @symbol(linux)
#   endif

#   ifdef __FREEBSD__
#    define OS_SYMBOL @symbol(freeBSD)
#   endif

#   ifdef __sunos__
#    define OS_SYMBOL @symbol(sunos)
#   endif

#   ifdef __solaris__
#    define OS_SYMBOL @symbol(solaris)
#   endif

#   ifdef __IRIS__
#    define OS_SYMBOL @symbol(irix)
#   endif

#   ifdef __aix__
#    define OS_SYMBOL @symbol(aix)
#   endif

#   ifdef __realIX__
#    define OS_SYMBOL @symbol(realIX)
#   endif

#   ifdef __osf__
#    define OS_SYMBOL @symbol(osf)
#   endif

#   ifdef __osx__
#    define OS_SYMBOL @symbol(osx)
#   endif

    /*
     * no concrete info; become somewhat vague ...
     */
#   ifndef OS_SYMBOL
#    ifdef MACH
#     define OS_SYMBOL @symbol(mach)
#    endif
#   endif

#   ifndef OS_SYMBOL
#    ifdef __BSD__
#     define OS_SYMBOL @symbol(bsd)
#    endif

#    ifdef __SYSV__
#     ifdef __SYSV3__
#      define OS_SYMBOL @symbol(sys5_3)
#     else
#      ifdef __SYSV4__
#       define OS_SYMBOL @symbol(sys5_4)
#      else
#       define OS_SYMBOL @symbol(sys5)
#      endif
#     endif
#    endif
#   endif

    /*
     * become very vague ...
     */
#   ifndef OS_SYMBOL
#    ifdef __UNIX__
#     define OS_SYMBOL @symbol(unix)
#    endif
#   endif
#   ifndef OS_SYMBOL
#    ifdef __POSIX__
#     define OS_SYMBOL @symbol(posix)
#    endif
#   endif

#   ifndef OS_SYMBOL
#    define OS_SYMBOL @symbol(unknown)
#   endif

    os = OS_SYMBOL;

#   undef OS_SYMBOL
%}.
    ^ os

    "
     OperatingSystem getOSType
    "
!

getPlatformDefine
    <resource: #obsolete>

    "return a string which defines the platform,
     and which should be passed down when compiling methods.
     For example, on all unices, this is '-DUNIX'."

%{  /* NOCONTEXT */

#ifndef PLATFORM_DEFINE
# ifdef __win32__
#  define PLATFORM_DEFINE "-D__win32__"
# endif
# ifdef __OS2__
#  define PLATFORM_DEFINE "-D__OS2__"
# endif
# ifdef __BEOS__
#  define PLATFORM_DEFINE "-D__BEOS__"
# endif
# ifdef __MACOS__
#  define PLATFORM_DEFINE "-D__MACOS__"
# endif
# ifdef __VMS__
#  define PLATFORM_DEFINE "-D__VMS__"
# endif
# ifdef __osx__
#  define PLATFORM_DEFINE "-D__osx__"
# endif
// # ifdef OSX
// #  define PLATFORM_DEFINE "-DOSX"
// # endif
# ifndef PLATFORM_DEFINE
#  ifdef __UNIX__
#   define PLATFORM_DEFINE "-D__UNIX__"
#  endif
# endif
# ifndef PLATFORM_DEFINE
#   define PLATFORM_DEFINE "-DunknownPlatform"
# endif
#endif

    RETURN ( __MKSTRING(PLATFORM_DEFINE));
%}
    "
     OperatingSystem getPlatformDefine
    "
!

getProcessId
    "return the (unix-)processId"

    self subclassResponsibility
!

getSystemID
    "if supported by the OS, return the systemID;
     a unique per machine identification.
     WARNING:
	not all systems support this; on some, 'unknown' is returned."

    ^ 'unknown'

    "
     OperatingSystem getSystemID
    "
!

getSystemInfo
    "return info on the system weare running on.
     If the system supports the uname system call, that info is returned;
     otherwise, some simulated info is returned.

     WARNING:
       Do not depend on the amount and contents of the returned information, some
       systems may return more/less than others. Also, the contents depends on the
       OS, for example, linux returns 'ix86', while WIN32 returns 'x86'.

       This method is mainly provided to augment error reports with some system
       information.
       (in case of system/version specific OS errors, conditional workarounds and patches
	may be based upon this info).
       Your application should NOT depend upon this in any way.

     The returned info may (or may not) contain:
	#system -> some operating system identification (irix, Linux, nt, win32s ...)
	#version -> OS version (some os version identification)
	#release -> OS release (3.5, 1.2.1 ...)
	#node   -> some host identification (hostname)
	#domain  -> domain name (hosts domain)
	#machine -> type of machine (i586, mips ...)
    "

    |info|

    info := IdentityDictionary new.
    info at:#system put:(self getSystemType).
    info at:#node put:(self getHostName).
    info at:#machine put:(self getCPUType).
    info at:#architecture put:'unknown'.
    info at:#domain put:self getDomainName.
    info at:#osType put:(self getOSType).
    ^ info

    "
     OperatingSystem getSystemInfo
    "
!

getSystemType
    "return a string giving the type of system we're running on.
     This is almost the same as getOSType, but the returned string
     is slightly different for some systems (i.e. iris vs. irix).
     Do not depend on this - use getOSType. I don't really see a point
     here ...
     (except for slight differences between next/mach and other machs)"

    ^ self getOSType

    "
     OperatingSystem getSystemType
    "
!

getWindowsDirectory
    "internal interface - only for Windows based systems.
     Return the windows directory, which, depending on the system,
     may be
	'\WINNT', '\WINDOWS'
     or whatever.
     On non-windows systems, nil is returned."

    ^ nil

    "
     OperatingSystem getWindowsDirectory
    "
!

getWindowsSystemDirectory
    "internal interface - only for Windows based systems.
     Return the windows system directory, which, depending on the system,
     may be
	'\WINNT\SYSTEM32', '\WINDOWS\SYSTEM'
     or whatever.
     On non-windows systems, nil is returned."

    ^ nil

    "
     OperatingSystem getWindowsSystemDirectory
    "
!

hasConsole
    "return true, if there is some kind of console available
     (i.e. for proper stdIn, stdOut and stdErr handling).
     This only returns false when running under windows, and
     the system is running as a pure windows application.
     If false, the miniDebugger is useless and not used."

    ^ true
!

isBSDlike
    "return true, if the OS we're running on is a 'real' unix."

    ^ false
!

isLinuxLike
    "return true, if the OS we're running on is a linux."

    ^ false
!

isMAClike
    "return true, if running on a macOS (but not on A/UX or OS/X)"

    ^ false
!

isMSDOSlike
    "return true, if the OS we're running on is msdos like (in contrast to unix-like).
     This returns true for any of msdos, win32s, win95, winNT and os/2."

    ^ false
!

isMSWINDOWSNTlike
    "This returns true if running in a Windows-NT system."

     ^ false.
!

isMSWINDOWSlike
    "return true, if running on a MS-Windows like system.
     This returns true for any of win32s, win95 and winNT."

    ^ false
!

isOS2like
    "return true, if the OS we're running on is OS2 like.
     Only returns true for a plain OS/2 system."

    ^ false
!

isOSXlike
    "return true, if the OS we're running on is a mac OSX like (but not A/UX or OS9)."

    ^ false
!

isProcessIdPresent:pid
    "answer true, if a process with process id pid is present, false if not.
     Raise an error, if an exception occurs"

    ^ self subclassResponsibility
!

isUNIXlike
    "return true, if the OS we're running on is a unix like."

    ^ false
!

isVMSlike
    "return true, if the OS we're running in is VMS (or openVMS)."

    ^ false
!

knownPlatformNames
    "return a collection of strings as possibly returned by getPlatformName.
     Should be used instead of getOSType or getSystemType if multiple choice
     dialogs are presented to the user."

    ^#(
	win32
	osx      "/ yes!! it is supported
	unix

	os2      "/ actually - this is no longer true (OS/2 not supported)
	macos    "/ actually - this is no longer true (old MACOS not supported)
	vms      "/ actually - this is no longer true (VMS no longer supported)
	qnx      "/ actually - this is no longer true (qny no longer supported)
	beos     "/ actually - this was never true (beos not supported)
    )

    "
     OperatingSystem knownPlatformNames
     OperatingSystem platformName
     OperatingSystem getPlatformDefine
    "

    "Modified: 20.6.1997 / 17:37:26 / cg"
!

maxFileNameLength
    "return the max number of characters in a filename.
     CAVEAT:
	 Actually, the following is somewhat wrong - some systems
	 support different sizes, depending on the volume.
	 We return a somewhat conservative number here.
	 Another entry, to query for volume specific max
	 will be added in the future."

    self subclassResponsibility
!

maxNumberOfOpenFiles
    "answer the maximum number of open files for this process"

    ^ self subclassResponsibility
!

maxPathLength
    "return the max number of characters in a pathName."

    self subclassResponsibility
!

osName
    "return a string describing the OS platform very we're running on.
     This returns #unix for all unix derivatives.
     I.e. it is much less specific than getOSType or getSystemType."

    |info|

    info := self getSystemInfo.
    ^ ((info at:#system) ? '?')
      ,
      ((info at:#version) ? '?')

    "
     OperatingSystem getSystemInfo
     OperatingSystem osName
    "

    "Modified: / 20-06-1997 / 17:37:26 / cg"
    "Created: / 05-08-2011 / 18:18:53 / cg"
!

pathSeparator
    "return the character which separates items in the PATH variable"

    self subclassResponsibility
!

platformDefineForPlatformName:osID
    "return a c-define for a particular platform (use only for makefile generation etc.)"

    osID = #win32 ifTrue:[ ^ '-D__win32__'].
    osID = #os2 ifTrue:[ ^ '-D__OS2__'].
    osID = #macos ifTrue:[ ^ '-D__MACOS__'].
    osID = #beos ifTrue:[ ^ '-D__beos__'].
    osID = #vms ifTrue:[ ^ '-D__VMS__'].
    osID = #unix ifTrue:[ ^ '-D__UNIX__'].
    osID = #osx ifTrue:[ ^ '-D__OSX__'].
    self error:'unknown os'.

    "
     OperatingSystem platformDefineForName:(OperatingSystem platformName)
    "

    "Modified: 20.6.1997 / 17:37:26 / cg"
!

platformName
    "return a string describing the OS platform very we're running on.
     Except for osx, this returns #unix for all other unix derivatives.
     I.e. it is much less specific than getOSType or getSystemType."

    |os|

    os := self getSystemType.
    os = #osx ifTrue:[ ^ #osx].
    os = #win32 ifTrue:[ ^ #win32].

    os = #os2 ifTrue:[ ^ #os2].
    os = #macos ifTrue:[ ^ #macos].

    os = #VMS ifTrue:[ ^ #vms].
    os = #openVMS ifTrue:[ ^ #vms].
    ^ #unix

    "
     OperatingSystem knownPlatformNames
     OperatingSystem platformName
    "

    "Modified: 20.6.1997 / 17:37:26 / cg"
!

randomBytesInto:bufferOrInteger
    "If bufferOrInteger is a String or a ByteArray,
	fill a given buffer with random bytes from the RtlGenRandom function
	and answer the buffer.

     If bufferOrInteger is a SmallInteger,
	return this many bytes (max 4) as a SmallInteger.

     Return nil on error (may raise PrimitiveFailure, too).

     NOTE: This is a private interface, please use RandomGenerator!!

     Subclasses should implement this, if the OperatingSystem supports a random generator."

    ^ nil  "not implemented"
!

setEnvironment:aStringOrSymbol to:newValueString
    "set an environment variable"

    ^ self subclassResponsibility
!

setLocaleInfo:anInfoDictionary
    "set the locale information; if set, this oerrides the OS's settings.
     (internal in ST/X only - the OS's settings remain unaffected)
     See description of fields in #getLocaleInfo.

     Notice, that (for now), the system does not use this information;
     it should be used by applications as required."

    LocaleInfo := anInfoDictionary

    "
     |d|

     d := IdentityDictionary new.
     d at:#decimalPoint                 put:'.'         .
     d at:#thousandsSeparator           put:','         .
     d at:#currencySymbol               put:'USD'       .
     d at:#monetaryDecimalPoint         put:'.'         .
     d at:#monetaryThousandsSeparator   put:'.'         .
     d at:#fractionalDigits             put:2           .
     d at:#positiveSign                 put:'+'         .
     d at:#negativeSign                 put:'-'         .
     d at:#positiveSignPrecedesCurrencySymbol put:true          .
     d at:#negativeSignPrecedesCurrencySymbol put:false         .
     OperatingSystem setLocaleInfo:d
    "
!

supportsChildInterrupts
    "return true, if the OS supports childProcess termination signalling
     through interrupts (i.e. SIGCHILD)"

    ^ false

    "
     OperatingSystem supportsChildInterrupts
    "
!

supportsFileOwnerGroups
    "return true, if the OS's file system supports file
     group ownership - here, we are optimistic assuming that
     we are running under a real OS.
     Redefined in Win32OS to return false."

    ^ true

    "Modified: / 10.9.1998 / 17:48:20 / cg"
    "Created: / 10.9.1998 / 17:56:28 / cg"
!

supportsFileOwners
    "return true, if the OS's file system supports file
     ownership - here, we are optimistic assuming that
     we are running under a real OS.
     Redefined in Win32OS to return false."

    ^ true

    "Modified: / 10.9.1998 / 17:48:20 / cg"
    "Created: / 10.9.1998 / 17:56:11 / cg"
!

supportsIOInterrupts
    "return true, if the OS supports IO availability interrupts
     (i.e. SIGPOLL/SIGIO)."

    ^ false

    "
     OperatingSystem supportsIOInterrupts
    "
!

supportsNonBlockingIO
    "return true, if the OS supports nonblocking IO."

    ^ false

    "
     OperatingSystem supportsNonBlockingIO
    "
!

supportsSelect
    "return true, if the OS supports selecting on multiple
     filedescriptors via select.
     If false is returned, ProcessorScheduler will poll in 50ms
     intervals for I/O becoming ready."

    ^ true

    "
     OperatingSystem supportsSelect
    "
!

supportsSelectOnPipes
    "return true, if the OS supports selecting on pipe
     filedescriptors via select.
     If false is returned, ProcessorScheduler will poll in 50ms
     intervals for I/O becoming ready."

    ^ true

    "
     OperatingSystem supportsSelectOnPipes
    "

    "Modified: / 14.12.1999 / 19:40:32 / cg"
    "Created: / 14.12.1999 / 19:43:43 / cg"
!

supportsSelectOnSockets
    "return true, if the OS supports selecting on socket
     filedescriptors via select.
     If false is returned, ProcessorScheduler will poll in 50ms
     intervals for I/O becoming ready."

    ^ true

    "
     OperatingSystem supportsSelectOnSockets
    "

    "Modified: / 14.12.1999 / 19:40:32 / cg"
!

supportsTTYs
    "Return true if OS supports PTYs / TTYs. UNIX do, other 
     OSes usually don't"

    ^ false

    "Created: / 31-05-2017 / 10:37:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

supportsVolumes
    "return true, if the OS supports disk volumes.
     False is returned for UNIX, true for MSDOS, VMS and OSX (which treats /Volumes as such)"

    ^ false

    "Created: / 29.10.1998 / 13:20:37 / cg"
! !

!AbstractOperatingSystem class methodsFor:'path queries'!

decodePath:encodedPathNameOrOutputLine
    "decode the encodedPathNameOrOutputLine as returned by system calls or output by system commands.
     E.g. linux system calls return single byte strings only,
     so pathNames have been UTF-8 encoded."

    ^ self decodePathOrCommandOutput:encodedPathNameOrOutputLine
!

decodePathOrCommandOutput:encodedPathNameOrOutputLine
    "decode the encodedPathNameOrOutputLine as returned by system calls or output by system commands.
     This takes care for any specific OS encodings or specific command encodings.

     E.g. linux system calls return single byte strings only,
     so pathNames have been UTF-8 encoded."

    "/ fallback here: no encoding
    ^ encodedPathNameOrOutputLine
!

defaultPackagePath
    "Return a default packagePath - that's a collection of
     dirnames, where ST/X searches for packages.

     The default package path contains

        * $STX_PACKAGEPATH (directories specified in environment variable)
        * $HOME/.smalltalk/packages (on Windows %USERPROFILE%\.smalltalk\packages)
        * OperatingSystem pathOfSTXExecutable / '..' / '..' / '..' (only when running from build tree)


     This method might be redefined in concrete OS's to add
     OS-specific directory names."

    |packagePath execPath directories|

    packagePath := OrderedCollection new.


    "/ Add all directories from $STX_PACKAGEPATH environment
    (directories := OperatingSystem getEnvironment:'STX_PACKAGEPATH') notNil ifTrue:[
        directories := directories asCollectionOfSubstringsSeparatedBy:self pathSeparator.
        directories reverseDo:[:each|
            (packagePath includes:each) ifFalse:[
                packagePath addFirst:each.
            ].
	].
    ].

    "/ $HOME/.smalltalk/packages (on Windows %USERPROFILE%\.smalltalk\packages)
    packagePath add: (Filename homeDirectory / '.smalltalk' / 'packages') pathName.

    "/ If and only if running in build tree, add
    "/
    "/    OperatingSystem pathOfSTXExecutable / '..' / '..' / '..' (only when running from build tree)
    "/
    execPath := self pathOfSTXExecutable.
    execPath notNil ifTrue:[
        (self isUNIXlike and:[ execPath endsWith: '/stx/projects/smalltalk/stx' ]) ifTrue:[ 
            packagePath add: (execPath copyTo: execPath size - '/stx/projects/smalltalk/stx' size)
        ] ifFalse:[
        	self isMSWINDOWSlike ifTrue:[
        		((execPath endsWith: '\stx\projects\smalltalk\stx.com') or:[execPath endsWith: '\stx\projects\smalltalk\stx.exe']) ifTrue:[
        			packagePath add: (execPath copyTo: execPath size - '\stx\projects\smalltalk\stx.exe' size)
        		]
        	]
        ]
    ].

    ^ packagePath

    "
     OperatingSystem defaultPackagePath
    "

    "Modified: / 04-02-2011 / 16:27:15 / cg"
    "Modified: / 26-06-2016 / 06:26:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultSystemPath
    "return a default systemPath - that's a collection of
     dirnames, where ST/X searches for its files.
     This method is redefined in concrete OS's to add
     OS-specific directory names."

    |sysPath p appDir homePath priv userPrivateSTXDir appPath|

    "
     the path is set to search files first locally
     - this allows private stuff to override global stuff
    "
    sysPath := OrderedCollection new.

    "/
    "/ the current (default) directory
    "/
    sysPath add:('.' "Filename currentDirectory pathName").

    "/
    "/ the executable's directory
    "/    and the executables parent directory (if it is an installed version)
    "/
    appPath := self pathOfSTXExecutable.
    appPath notNil ifTrue:[
        appDir := appPath asFilename directory.
        appPath := appDir pathName.
        (sysPath includes:appPath) ifFalse:[
            sysPath add:appPath.
        ].
        appDir baseName = 'bin' ifTrue:[
            appPath := appDir directory pathName.
            (sysPath includes:appPath) ifFalse:[
                sysPath add:appPath.
            ].
        ].
    ].

    "/
    "/ the users home (login) directory
    "/
    homePath := self getHomeDirectory.
    homePath notNil ifTrue:[
        "/
        "/ a users private smalltalk directory in its home (login) directory
        "/
        OperatingSystem isUNIXlike ifTrue:[
            priv := #('.smalltalk')
        ] ifFalse:[
            priv := #('smalltalk' '.smalltalk')
        ].
        priv do:[:p |
            userPrivateSTXDir := homePath asFilename construct:p.
            (userPrivateSTXDir isDirectory) ifTrue:[
                userPrivateSTXDir := userPrivateSTXDir pathName.
                (sysPath includes:userPrivateSTXDir) ifFalse:[
                    sysPath add:userPrivateSTXDir
                ]
            ].
        ].
    ].

    "/
    "/ SMALLTALK_LIBDIR, STX_LIBDIR and STX_TOPDIR from the environment
    "/
    #(
        'SMALLTALK_LIBDIR'
        'STX_LIBDIR'
        'STX_TOPDIR'
     ) do:[:each |
        p := OperatingSystem decodePath:(OperatingSystem getEnvironment:each).
        p notNil ifTrue:[
            p := p asFilename pathName.
            (p asFilename isDirectory) ifTrue:[
                (sysPath includes:p) ifFalse:[
                     sysPath add:p
                ]
            ]
        ].
    ].
    ^ sysPath

    "
        OperatingSystem defaultSystemPath
    "

    "Modified: / 24-12-1999 / 00:30:27 / cg"
    "Modified: / 22-04-2016 / 21:11:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

encodePath:pathName
    "encode the pathName for use with system calls.
     E.g. linux system calls accept single byte strings only,
     so the pathName has been UTF-8 encoded, before using it in a system call."

    ^ pathName
! !

!AbstractOperatingSystem class methodsFor:'printing support'!

getPrinters
    "return a collection of PrinterInfos"

    self subclassResponsibility

    "Created: / 27-07-2006 / 12:17:31 / fm"
! !

!AbstractOperatingSystem class methodsFor:'private'!

osProcessStatusClass
    ^ self subclassResponsibility

    "Created: / 12.6.1998 / 16:30:29 / cg"
! !

!AbstractOperatingSystem class methodsFor:'queries-sockets'!

domainCodeOf:aSymbolOrInteger
    "return the numeric AF_xxx code of a given symbolic domain name.
     Return nil for invalid or unsupported domains.
     For backward compatibility, the obsolete (non-AF-prefixed) names
     are still supported for a while - this support will vanish."

    |domainCode|

%{  /*NOCONTEXT*/

    if (__isSmallInteger(aSymbolOrInteger) || aSymbolOrInteger == nil) {
	RETURN (aSymbolOrInteger);
    }

#ifdef AF_INET
    else if ((aSymbolOrInteger == @symbol(AF_INET)) || (aSymbolOrInteger == @symbol(inet)))
       domainCode = __mkSmallInteger(AF_INET);
#endif
#ifdef AF_INET6
    else if ((aSymbolOrInteger == @symbol(AF_INET6)) || (aSymbolOrInteger == @symbol(inet6)))
       domainCode = __mkSmallInteger(AF_INET6);
#endif
#ifdef AF_UNIX
    else if ((aSymbolOrInteger == @symbol(AF_UNIX)) || (aSymbolOrInteger == @symbol(unix)))
       domainCode = __mkSmallInteger(AF_UNIX);
#endif
#ifdef AF_APPLETALK
    else if ((aSymbolOrInteger == @symbol(AF_APPLETALK)) || (aSymbolOrInteger == @symbol(appletalk)))
       domainCode = __mkSmallInteger(AF_APPLETALK);
#endif
#ifdef AF_DECnet
    else if ((aSymbolOrInteger == @symbol(AF_DECnet)) || (aSymbolOrInteger == @symbol(decnet)))
       domainCode = __mkSmallInteger(AF_DECnet);
#endif
#ifdef AF_NS
    else if ((aSymbolOrInteger == @symbol(AF_NS)) || (aSymbolOrInteger == @symbol(ns)))
       domainCode = __mkSmallInteger(AF_NS);
#endif
#ifdef AF_X25
    else if ((aSymbolOrInteger == @symbol(AF_X25)) || (aSymbolOrInteger == @symbol(x25)))
       domainCode = __mkSmallInteger(AF_X25);
#endif
#ifdef AF_SNA
    else if (aSymbolOrInteger == @symbol(AF_SNA))
       domainCode = __mkSmallInteger(AF_SNA);
#endif
#ifdef AF_RAW
    else if ((aSymbolOrInteger == @symbol(AF_RAW)) || (aSymbolOrInteger == @symbol(raw)))
       domainCode = __mkSmallInteger(AF_RAW);
#endif
#ifdef AF_ISO
    else if ((aSymbolOrInteger == @symbol(AF_ISO)) || (aSymbolOrInteger == @symbol(iso)))
       domainCode = __mkSmallInteger(AF_ISO);
#endif
#ifdef AF_ECMA
    else if (aSymbolOrInteger == @symbol(AF_ECMA))
       domainCode = __mkSmallInteger(AF_ECMA);
#endif
#ifdef AF_NETBIOS
    else if ((aSymbolOrInteger == @symbol(AF_NETBIOS)) || (aSymbolOrInteger == @symbol(netbios)))
       domainCode = __mkSmallInteger(AF_NETBIOS);
#endif
#ifdef AF_NETBEUI
    else if (aSymbolOrInteger == @symbol(AF_NETBEUI))
       domainCode = __mkSmallInteger(AF_NETBEUI);
#endif
#ifdef AF_IPX
    else if (aSymbolOrInteger == @symbol(AF_IPX))
       domainCode = __mkSmallInteger(AF_IPX);
#endif
#ifdef AF_AX25
    else if (aSymbolOrInteger == @symbol(AF_AX25))
       domainCode = __mkSmallInteger(AF_AX25);
#endif
#ifdef AF_NETROM
    else if (aSymbolOrInteger == @symbol(AF_NETROM))
       domainCode = __mkSmallInteger(AF_NETROM);
#endif
#ifdef AF_BRIDGE
    else if (aSymbolOrInteger == @symbol(AF_BRIDGE))
       domainCode = __mkSmallInteger(AF_BRIDGE);
#endif
#ifdef AF_BSC
    else if (aSymbolOrInteger == @symbol(AF_BSC))
       domainCode = __mkSmallInteger(AF_BSC);
#endif
#ifdef AF_ROSE
    else if (aSymbolOrInteger == @symbol(AF_ROSE))
       domainCode = __mkSmallInteger(AF_ROSE);
#endif
#ifdef AF_IRDA
    else if ((aSymbolOrInteger == @symbol(AF_IRDA)) || (aSymbolOrInteger == @symbol(irda)))
       domainCode = __mkSmallInteger(AF_IRDA);
#endif
#ifdef AF_BAN
    else if (aSymbolOrInteger == @symbol(AF_BAN))
       domainCode = __mkSmallInteger(AF_BAN);
#endif
#ifdef AF_VOICEVIEW
    else if (aSymbolOrInteger == @symbol(AF_VOICEVIEW))
       domainCode = __mkSmallInteger(AF_VOICEVIEW);
#endif
#ifdef AF_ATM
    else if (aSymbolOrInteger == @symbol(AF_ATM))
       domainCode = __mkSmallInteger(AF_ATM);
#endif
#ifdef AF_ATMPVC
    else if (aSymbolOrInteger == @symbol(AF_ATMPVC))
       domainCode = __mkSmallInteger(AF_ATMPVC);
#endif
#ifdef AF_ATMSVC
    else if (aSymbolOrInteger == @symbol(AF_ATMSVC))
       domainCode = __mkSmallInteger(AF_ATMSVC);
#endif
#ifdef AF_SECURITY
    else if (aSymbolOrInteger == @symbol(AF_SECURITY))
       domainCode = __mkSmallInteger(AF_SECURITY);
#endif
#ifdef AF_KEY
    else if (aSymbolOrInteger == @symbol(AF_KEY))
       domainCode = __mkSmallInteger(AF_KEY);
#endif
#ifdef AF_NETLINK
    else if (aSymbolOrInteger == @symbol(AF_NETLINK))
       domainCode = __mkSmallInteger(AF_NETLINK);
#endif
#ifdef AF_PACKET
    else if (aSymbolOrInteger == @symbol(AF_PACKET))
       domainCode = __mkSmallInteger(AF_PACKET);
#endif
#ifdef AF_ASH
    else if (aSymbolOrInteger == @symbol(AF_ASH))
       domainCode = __mkSmallInteger(AF_ASH);
#endif
#ifdef AF_ECONET
    else if (aSymbolOrInteger == @symbol(AF_ECONET))
       domainCode = __mkSmallInteger(AF_ECONET);
#endif
#ifdef AF_IMPLINK
    else if (aSymbolOrInteger == @symbol(AF_IMPLINK))
       domainCode = __mkSmallInteger(AF_IMPLINK);
#endif
#ifdef AF_PUP
    else if (aSymbolOrInteger == @symbol(AF_PUP))
       domainCode = __mkSmallInteger(AF_PUP);
#endif
#ifdef AF_CHAOS
    else if (aSymbolOrInteger == @symbol(AF_CHAOS))
       domainCode = __mkSmallInteger(AF_CHAOS);
#endif
#ifdef AF_DLI
    else if (aSymbolOrInteger == @symbol(AF_DLI))
       domainCode = __mkSmallInteger(AF_DLI);
#endif
#ifdef AF_LAT
    else if (aSymbolOrInteger == @symbol(AF_LAT))
       domainCode = __mkSmallInteger(AF_LAT);
#endif
#ifdef AF_HYLINK
    else if (aSymbolOrInteger == @symbol(AF_HYLINK))
       domainCode = __mkSmallInteger(AF_HYLINK);
#endif
#ifdef AF_FIREFOX
    else if (aSymbolOrInteger == @symbol(AF_FIREFOX))
       domainCode = __mkSmallInteger(AF_FIREFOX);
#endif
#ifdef AF_CLUSTER
    else if (aSymbolOrInteger == @symbol(AF_CLUSTER))
       domainCode = __mkSmallInteger(AF_CLUSTER);
#endif
#ifdef AF_12844
    else if (aSymbolOrInteger == @symbol(AF_12844))
       domainCode = __mkSmallInteger(AF_12844);
#endif
#ifdef AF_NETDES
    else if (aSymbolOrInteger == @symbol(AF_NETDES))
       domainCode = __mkSmallInteger(AF_NETDES);
#endif
#ifdef AF_CCITT
    else if (aSymbolOrInteger == @symbol(AF_CCITT))
       domainCode = __mkSmallInteger(AF_CCITT);
#endif
#ifdef AF_ISDN
    else if (aSymbolOrInteger == @symbol(AF_ISDN))
       domainCode = __mkSmallInteger(AF_ISDN);
#endif
#ifdef AF_SYSTEM
    else if (aSymbolOrInteger == @symbol(AF_SYSTEM))
       domainCode = __mkSmallInteger(AF_SYSTEM);
#endif
%}.

    ^ domainCode.

    "
     self domainCodeOf:#AF_INET
     self domainCodeOf:#AF_INET6
     self domainCodeOf:#AF_UNIX
     self domainCodeOf:#AF_APPLETALK
     self domainCodeOf:#AF_DECNET
    "
    "for backward compatibility only:
     self domainCodeOf:#inet
     self domainCodeOf:#inet6
     self domainCodeOf:#unix
     self domainCodeOf:#appletalk
     self domainCodeOf:#decnet
    "
!

domainSymbolOf:anInteger
    "return the symbolic domainName of a given numeric AF_xxx code.
     Return nil for invalid or unsupported domains."

    |domainSymbol|

%{ /*NOCONTEXT*/

    if (__isSmallInteger(anInteger)) {
	switch(__intVal(anInteger)) {
#ifdef AF_INET
	case AF_INET:
	    domainSymbol = @symbol(AF_INET);
	    break;
#endif
#ifdef AF_INET6
	case AF_INET6:
	    domainSymbol = @symbol(AF_INET6);
	    break;
#endif
#ifdef AF_UNIX
	case AF_UNIX:
	    domainSymbol = @symbol(AF_UNIX);
	    break;
#endif
#ifdef AF_APPLETALK
	case AF_APPLETALK:
	    domainSymbol = @symbol(AF_APPLETALK);
	    break;
#endif
#ifdef AF_DECnet
	case AF_DECnet:
	    domainSymbol = @symbol(AF_DECnet);
	    break;
#endif
#ifdef AF_NS
	case AF_NS:
	    domainSymbol = @symbol(AF_NS);
	    break;
#endif
#ifdef AF_X25
	case AF_X25:
	    domainSymbol = @symbol(AF_X25);
	    break;
#endif
#ifdef AF_SNA
	case AF_SNA:
	    domainSymbol = @symbol(AF_SNA);
	    break;
#endif
#ifdef AF_RAW
	case AF_RAW:
	    domainSymbol = @symbol(AF_RAW);
	    break;
#endif
#ifdef AF_ISO
	case AF_ISO:
	    domainSymbol = @symbol(AF_ISO);
	    break;
#endif
#ifdef AF_ECMA
	case AF_ECMA:
	    domainSymbol = @symbol(AF_ECMA);
	    break;
#endif
#ifdef AF_NETBIOS
	case AF_NETBIOS:
	    domainSymbol = @symbol(AF_NETBIOS);
	    break;
#endif
#ifdef AF_IPX
# if defined(AF_NS) && (AF_NS == AF_IPX)
//      alias
# else
	case AF_IPX:
	    domainSymbol = @symbol(AF_IPX);
	    break;
# endif
#endif
#ifdef AF_AX25
	case AF_AX25:
	    domainSymbol = @symbol(AF_AX25);
	    break;
#endif
#ifdef AF_NETROM
	case AF_NETROM:
	    domainSymbol = @symbol(AF_NETROM);
	    break;
#endif
#ifdef AF_BRIDGE
	case AF_BRIDGE:
	    domainSymbol = @symbol(AF_BRIDGE);
	    break;
#endif
#ifdef AF_BSC
	case AF_BSC:
	    domainSymbol = @symbol(AF_BSC);
	    break;
#endif
#ifdef AF_ROSE
	case AF_ROSE:
	    domainSymbol = @symbol(AF_ROSE);
	    break;
#endif
#ifdef AF_IRDA
	case AF_IRDA:
	    domainSymbol = @symbol(AF_IRDA);
	    break;
#endif
#ifdef AF_BAN
	case AF_BAN:
	    domainSymbol = @symbol(AF_BAN);
	    break;
#endif
#ifdef AF_VOICEVIEW
	case AF_VOICEVIEW:
	    domainSymbol = @symbol(AF_VOICEVIEW);
	    break;
#endif
#ifdef AF_ATM
	case AF_ATM:
	    domainSymbol = @symbol(AF_ATM);
	    break;
#endif
#ifdef AF_ATMPVC
	case AF_ATMPVC:
	    domainSymbol = @symbol(AF_ATMPVC);
	    break;
#endif
#ifdef AF_ATMSVC
	case AF_ATMSVC:
	    domainSymbol = @symbol(AF_ATMSVC);
	    break;
#endif
#ifdef AF_SECURITY
	case AF_SECURITY:
	    domainSymbol = @symbol(AF_SECURITY);
	    break;
#endif
#ifdef AF_KEY
	case AF_KEY:
	    domainSymbol = @symbol(AF_KEY);
	    break;
#endif
#ifdef AF_NETLINK
	case AF_NETLINK:
	    domainSymbol = @symbol(AF_NETLINK);
	    break;
#endif
#ifdef AF_PACKET
	case AF_PACKET:
	    domainSymbol = @symbol(AF_PACKET);
	    break;
#endif
#ifdef AF_LINK
# if AF_LINK != AF_PACKET
	case AF_LINK:
	    domainSymbol = @symbol(AF_LINK);
	    break;
# endif
#endif
#ifdef AF_ASH
	case AF_ASH:
	    domainSymbol = @symbol(AF_ASH);
	    break;
#endif
#ifdef AF_ECONET
	case AF_ECONET:
	    domainSymbol = @symbol(AF_ECONET);
	    break;
#endif
#ifdef AF_IMPLINK
	case AF_IMPLINK:
	    domainSymbol = @symbol(AF_IMPLINK);
	    break;
#endif
#ifdef AF_PUP
	case AF_PUP:
	    domainSymbol = @symbol(AF_PUP);
	    break;
#endif
#ifdef AF_CHAOS
	case AF_CHAOS:
	    domainSymbol = @symbol(AF_CHAOS);
	    break;
#endif
#ifdef AF_DLI
	case AF_DLI:
	    domainSymbol = @symbol(AF_DLI);
	    break;
#endif
#ifdef AF_LAT
	case AF_LAT:
	    domainSymbol = @symbol(AF_LAT);
	    break;
#endif
#ifdef AF_HYLINK
	case AF_HYLINK:
	    domainSymbol = @symbol(AF_HYLINK);
	    break;
#endif
#ifdef AF_FIREFOX
	case AF_FIREFOX:
	    domainSymbol = @symbol(AF_FIREFOX);
	    break;
#endif
#ifdef AF_CLUSTER
	case AF_CLUSTER:
	    domainSymbol = @symbol(AF_CLUSTER);
	    break;
#endif
#ifdef AF_12844
	case AF_12844:
	    domainSymbol = @symbol(AF_12844);
	    break;
#endif
#ifdef AF_NETDES
	case AF_NETDES:
	    domainSymbol = @symbol(AF_NETDES);
	    break;
#endif
#ifdef AF_CCITT
	case AF_CCITT:
	    domainSymbol = @symbol(AF_CCITT);
	    break;
#endif
#ifdef AF_ISDN
	case AF_ISDN:
	    domainSymbol = @symbol(AF_ISDN);
	    break;
#endif
#ifdef AF_SYSTEM
	case AF_SYSTEM:
	    domainSymbol = @symbol(AF_SYSTEM);
	    break;
#endif
	}
    }
%}.

    ^ domainSymbol.

    "
     self domainSymbolOf:(self domainCodeOf:#inet)
     self domainSymbolOf:(self domainCodeOf:#inet6)
     self domainSymbolOf:(self domainCodeOf:#unix)
     self domainSymbolOf:(self domainCodeOf:#appletalk)
     self domainSymbolOf:(self domainCodeOf:#decnet)
     self domainSymbolOf:(self domainCodeOf:#raw)
    "
!

protocolCodeOf:aSymbolOrInteger
    "return the numeric IPPROTO_xxx code of a given symbolic protocol name.
     Return nil for invalid or unsupported protocols.
     For backward compatibility, the obsolete (non-IPPROTO-prefixed) names
     are still supported for a while - this support will vanish."

    |protocolCode|

%{  /*NOCONTEXT*/

    if (__isSmallInteger(aSymbolOrInteger) || aSymbolOrInteger == nil) {
	RETURN (aSymbolOrInteger);
    }

#ifdef IPPROTO_IP
    else if ((aSymbolOrInteger == @symbol(IPPROTO_IP)) || (aSymbolOrInteger == @symbol(ip)))
       protocolCode = __mkSmallInteger(IPPROTO_IP);
#endif
#ifdef IPPROTO_ICMP
    else if ((aSymbolOrInteger == @symbol(IPPROTO_ICMP)) || (aSymbolOrInteger == @symbol(icmp)))
       protocolCode = __mkSmallInteger(IPPROTO_ICMP);
#endif
#ifdef IPPROTO_IGMP
    else if ((aSymbolOrInteger == @symbol(IPPROTO_IGMP)) || (aSymbolOrInteger == @symbol(igmp)))
       protocolCode = __mkSmallInteger(IPPROTO_IGMP);
#endif
#ifdef IPPROTO_GGP
    else if ((aSymbolOrInteger == @symbol(IPPROTO_GGP)) || (aSymbolOrInteger == @symbol(ggp)))
       protocolCode = __mkSmallInteger(IPPROTO_GGP);
#endif
#ifdef IPPROTO_TCP
    else if ((aSymbolOrInteger == @symbol(IPPROTO_TCP)) || (aSymbolOrInteger == @symbol(tcp)))
       protocolCode = __mkSmallInteger(IPPROTO_TCP);
#endif
#ifdef IPPROTO_UDP
    else if ((aSymbolOrInteger == @symbol(IPPROTO_UDP)) || (aSymbolOrInteger == @symbol(udp)))
       protocolCode = __mkSmallInteger(IPPROTO_UDP);
#endif
#ifdef IPPROTO_IDP
    else if ((aSymbolOrInteger == @symbol(IPPROTO_IDP)) || (aSymbolOrInteger == @symbol(idp)))
       protocolCode = __mkSmallInteger(IPPROTO_IDP);
#endif
#ifdef IPPROTO_ND
    else if ((aSymbolOrInteger == @symbol(IPPROTO_ND)) || (aSymbolOrInteger == @symbol(nd)))
       protocolCode = __mkSmallInteger(IPPROTO_ND);
#endif
#ifdef IPPROTO_RAW
    else if ((aSymbolOrInteger == @symbol(IPPROTO_RAW)) || (aSymbolOrInteger == @symbol(raw)))
       protocolCode = __mkSmallInteger(IPPROTO_RAW);
#endif
%}.

    ^ protocolCode.

    "
     self protocolCodeOf:#IPPROTO_UDP
     self protocolCodeOf:#IPPROTO_TCP
    "
    "for backward compatibility only:
     self protocolCodeOf:#udp
     self protocolCodeOf:#tcp
    "
!

protocolSymbolOf:anInteger
    "return the symbolic protocolName of a given numeric IPPROTO_xxx code.
     Return nil for invalid or unsupported protocols."

    |protocolSymbol|

%{ /*NOCONTEXT*/

    if (__isSmallInteger(anInteger)) {
	switch(__intVal(anInteger)) {
#ifdef IPPROTO_IP
	case IPPROTO_IP:
	    // protocolSymbol = @symbol(IPPROTO_IP);
	    protocolSymbol = @symbol(ip);
	    break;
#endif
#ifdef IPPROTO_ICMP
	case IPPROTO_ICMP:
	    // protocolSymbol = @symbol(IPPROTO_ICMP);
	    protocolSymbol = @symbol(icmp);
	    break;
#endif
#ifdef IPPROTO_IGMP
	case IPPROTO_IGMP:
	    // protocolSymbol = @symbol(IPPROTO_IGMP);
	    protocolSymbol = @symbol(igmp);
	    break;
#endif
#ifdef IPPROTO_GGP
	case IPPROTO_GGP:
	    // protocolSymbol = @symbol(IPPROTO_GGP);
	    protocolSymbol = @symbol(ggp);
	    break;
#endif
#ifdef IPPROTO_TCP
	case IPPROTO_TCP:
	    // protocolSymbol = @symbol(IPPROTO_TCP);
	    protocolSymbol = @symbol(tcp);
	    break;
#endif
#ifdef IPPROTO_PUP
	case IPPROTO_PUP:
	    // protocolSymbol = @symbol(IPPROTO_PUP);
	    protocolSymbol = @symbol(pup);
	    break;
#endif
#ifdef IPPROTO_UDP
	case IPPROTO_UDP:
	    // protocolSymbol = @symbol(IPPROTO_UDP);
	    protocolSymbol = @symbol(udp);
	    break;
#endif
#ifdef IPPROTO_IDP
	case IPPROTO_IDP:
	    // protocolSymbol = @symbol(IPPROTO_IDP);
	    protocolSymbol = @symbol(idp);
	    break;
#endif
#ifdef IPPROTO_ND
	case IPPROTO_ND:
	    // protocolSymbol = @symbol(IPPROTO_ND);
	    protocolSymbol = @symbol(nd);
	    break;
#endif
#ifdef IPPROTO_RAW
	case IPPROTO_RAW:
	    // protocolSymbol = @symbol(IPPROTO_RAW);
	    protocolSymbol = @symbol(raw);
	    break;
#endif
	}
    }
%}.

    ^ protocolSymbol.

    "
     self protocolSymbolOf:(self protocolCodeOf:#tcp)
     self protocolSymbolOf:(self protocolCodeOf:#udp)
     self protocolSymbolOf:(self protocolCodeOf:#raw)
    "
!

socketAddressSizeOfDomain:aSymbolOrInteger
    "Return the os-specific size of a socket address for a domain aSymbolOrInteger.
     Return nil, if unknown or unsupported."

    |socketSize domainCode|

    domainCode := OperatingSystem domainCodeOf:aSymbolOrInteger.

%{
    if (__isSmallInteger(domainCode)) {
	switch (__intVal(domainCode)) {
#ifdef WANT__AF_INET
	    case AF_INET:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_in) );
		break;
#endif
#ifdef WANT__AF_INET6
	    case AF_INET6:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_in6) );
		break;
#endif
#ifdef WANT__AF_UNIX
	    case AF_UNIX:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_un) );
		break;
#endif
#ifdef WANT__AF_APPLETALK
	    case AF_APPLETALK:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_at) );
		break;
#endif
#ifdef WANT__AF_DECnet
	    case AF_DECnet:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_dn) );
		break;
#endif
#ifdef WANT__AF_NS
	    case AF_NS:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_ns) );
		break;
#endif
#ifdef WANT__AF_X25
	    case AF_X25:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_x25) );
		break;
#endif
#ifdef WANT__AF_SNA
	    case AF_SNA:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_sna) );
		break;
#endif
#ifdef WANT__AF_RAW
	    case AF_RAW:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_raw) );
		break;
#endif
#ifdef WANT__AF_ISO
	    case AF_ISO:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_iso) );
		break;
#endif
#ifdef WANT__AF_ECMA
# if 0
	    case AF_ECMA:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_ecma) );
		break;
# endif
#endif
#ifdef WANT__AF_NETBIOS
	    case AF_NETBIOS:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_netbios) );
		break;
#endif
#ifdef WANT__AF_NETBEUI
	    case AF_NETBEUI:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_netbeui) );
		break;
#endif
#ifdef WANT__AF_IPX
	    case AF_IPX:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_ipx) );
		break;
#endif
#ifdef WANT__AF_AX25
	    case AF_AX25:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_ax25) );
		break;
#endif
#ifdef WANT__AF_NETROM
	    case AF_NETROM:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_netrom) );
		break;
#endif
#ifdef WANT__AF_BRIDGE
	    case AF_BRIDGE:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_bridge) );
		break;
#endif
#ifdef WANT__AF_BSC
	    case AF_BSC:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_bsc) );
		break;
#endif
#ifdef WANT__AF_ROSE
	    case AF_ROSE:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_rose) );
		break;
#endif
#ifdef WANT__AF_IRDA
	    case AF_IRDA:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_irda) );
		break;
#endif
#ifdef WANT__AF_BAN
	    case AF_BAN:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_ban) );
		break;
#endif
#ifdef WANT__AF_VOICEVIEW
	    case AF_VOICEVIEW:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_voiceview) );
		break;
#endif
#ifdef WANT__AF_ATM
	    case AF_ATM:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_atm) );
		break;
#endif
#ifdef WANT__AF_ATMPVC
	    case AF_ATMPVC:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_atmpvc) );
		break;
#endif
#ifdef WANT__AF_ATMSVC
	    case AF_ATMSVC:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_atmsvc) );
		break;
#endif
#ifdef WANT__AF_NETLINK
	    case AF_NETLINK:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_netlink) );
		break;
#endif
#ifdef WANT__AF_PACKET
	    case AF_PACKET:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_packet) );
		break;
#endif
#ifdef WANT__AF_ASH
	    case AF_ASH:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_ash) );
		break;
#endif
#ifdef WANT__AF_ECONET
	    case AF_ECONET:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_eco) );
		break;
#endif
#ifdef WANT__AF_IMPLINK
	    case AF_IMPLINK:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_implink) );
		break;
#endif
#ifdef WANT__AF_PUP
# if 0
	    case AF_PUP:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_pup) );
		break;
# endif
#endif
#ifdef WANT__AF_CHAOS
	    case AF_CHAOS:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_chaos) );
		break;
#endif
#ifdef WANT__AF_DLI
	    case AF_DLI:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_dli) );
		break;
#endif
#ifdef WANT__AF_LAT
	    case AF_LAT:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_lat) );
		break;
#endif
#ifdef WANT__AF_HYLINK
	    case AF_HYLINK:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_hylink) );
		break;
#endif
#ifdef WANT__AF_FIREFOX
	    case AF_FIREFOX:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_firefox) );
		break;
#endif
#ifdef WANT__AF_CLUSTER
	    case AF_CLUSTER:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_cluster) );
		break;
#endif
#ifdef WANT__AF_12844
	    case AF_12844:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_12844) );
		break;
#endif
#ifdef WANT__AF_NETDES
	    case AF_NETDES:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_netdes) );
		break;
#endif
#ifdef WANT__AF_CCITT
	    case AF_CCITT:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_ccitt) );
		break;
#endif
#ifdef WANT__AF_ISDN
	    case AF_ISDN:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_isdn) );
		break;
#endif
#ifdef WANT__AF_PACKET
	    case AF_PACKET:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_ll) );
		break;
#endif
#ifdef WANT__AF_LINK
	    case AF_LINK:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_dl) );
		break;
#endif
#ifdef WANT__AF_SYSTEM
	    case AF_SYSTEM:
		socketSize = __mkSmallInteger( sizeof(struct sockaddr_sys) );
		break;
#endif

	}
    }
%}.
    ^ socketSize

    "
     self socketAddressSizeOfDomain:#'AF_INET'
     self socketAddressSizeOfDomain:#'AF_UNIX'
     self socketAddressSizeOfDomain:#'Foo'
    "
!

socketTypeCodeOf:aSymbolOrInteger
    "return the numeric SOCK_xxx code of a given symbolic socket type name.
     Return nil for invalid or unsupported socket types."

    |typeCode|

%{   /*NOCONTEXT*/

     if (__isSmallInteger(aSymbolOrInteger) || aSymbolOrInteger == nil) {
	typeCode = aSymbolOrInteger;
     }

#ifdef SOCK_STREAM
     else if ((aSymbolOrInteger == @symbol(stream)) || (aSymbolOrInteger == @symbol(SOCK_STREAM)))
	typeCode = __mkSmallInteger(SOCK_STREAM);
#endif
#ifdef SOCK_DGRAM
     else if ((aSymbolOrInteger == @symbol(datagram)) || (aSymbolOrInteger == @symbol(SOCK_DGRAM)))
	typeCode = __mkSmallInteger(SOCK_DGRAM);
#endif
#ifdef SOCK_RAW
     else if ((aSymbolOrInteger == @symbol(raw)) || (aSymbolOrInteger == @symbol(SOCK_RAW)))
	typeCode = __mkSmallInteger(SOCK_RAW);
#endif
#ifdef SOCK_RDM
     else if ((aSymbolOrInteger == @symbol(rdm)) || (aSymbolOrInteger == @symbol(SOCK_RDM)))
	typeCode = __mkSmallInteger(SOCK_RDM);
#endif
#ifdef SOCK_SEQPACKET
     else if ((aSymbolOrInteger == @symbol(seqpacket)) || (aSymbolOrInteger == @symbol(SOCK_SEQPACKET)))
	typeCode = __mkSmallInteger(SOCK_SEQPACKET);
#endif
#ifdef SOCK_PACKET
     else if ((aSymbolOrInteger == @symbol(packet)) || (aSymbolOrInteger == @symbol(SOCK_PACKET)))
	typeCode = __mkSmallInteger(SOCK_PACKET);
#endif
%}.

    ^ typeCode.

    "
     self socketTypeCodeOf:#stream
     self socketTypeCodeOf:#datagram
     self socketTypeCodeOf:#raw
    "
!

socketTypeSymbolOf:anInteger
    "return the symbolic typeName of a given numeric SOCK_xxx socket type code.
     Return nil for invalid or unsupported socket types."

    |socketTypeSymbol|

%{  /*NOCONTEXT*/

    if (__isSmallInteger(anInteger)) {
	switch(__intVal(anInteger)) {
#ifdef SOCK_STREAM
	case SOCK_STREAM:
	    socketTypeSymbol = @symbol(SOCK_STREAM);
	    break;
#endif
#ifdef SOCK_DGRAM
	case SOCK_DGRAM:
	    socketTypeSymbol = @symbol(SOCK_DGRAM);
	    break;
#endif
#ifdef SOCK_RAW
	case SOCK_RAW:
	    socketTypeSymbol = @symbol(SOCK_RAW);
	    break;
#endif
#ifdef SOCK_RDM
	case SOCK_RDM:
	    socketTypeSymbol = @symbol(SOCK_RDM);
	    break;
#endif
#ifdef SOCK_SEQPACKET
	case SOCK_SEQPACKET:
	    socketTypeSymbol = @symbol(SOCK_SEQPACKET);
	    break;
#endif
#ifdef SOCK_PACKET
	case SOCK_PACKET:
	    socketTypeSymbol = @symbol(SOCK_PACKET);
	    break;
#endif
	}
    }
%}.
    ^ socketTypeSymbol.
!

supportedProtocolFamilies
    "return a collection of supported protocol families.
     This list specifies what the Socket class supports -
     socket creation may still fail, if your system was built without it.
     For backward compatibility, the returned list includes the old
     (non-AF-prefixed) symbols; these will vanish."

    ^ #(
	#AF_INET
	#AF_UNIX
	#AF_INET6
	#AF_APPLETALK
	#AF_DECnet
	#AF_NS
	#AF_X25
	#AF_SNA
	#AF_RAW
	#AF_ISO
	#AF_ECMA
	#AF_NETBIOS
	#AF_IPX
	#AF_AX25
	#AF_NETROM
	#AF_BRIDGE
	#AF_BSC
	#AF_ROSE
	#AF_IRDA
	#AF_NETLINK
	#AF_NETLINK
	#AF_NETBEUI
	#AF_ATM
	#AF_ATMPVC
	#AF_ATMSVC
	#AF_BAN
	#AF_VOICEVIEW
	#AF_ECONET
	#AF_IMPLINK
	#AF_PUP
	#AF_CHAOS
	#AF_DLI
	#AF_LAT
	#AF_HYLINK
	#AF_FIREFOX
	#AF_CLUSTER
	#AF_12844
	#AF_NETDES
	#AF_PACKET
	#AF_LINK
       ) select:[:sym | (AbstractOperatingSystem domainCodeOf:sym) isInteger ]

    "
     AbstractOperatingSystem supportedProtocolFamilies
    "
!

supportedSocketTypes
    "return the symbolic typeName of a given numeric SOCK_xxx socket type code.
     Return nil for invalid or unsupported socket types."

    ^ #(
	#SOCK_STREAM
	#SOCK_DGRAM
	#SOCK_RAW
	#SOCK_RDM
	#SOCK_SEQPACKET
	#SOCK_PACKET
       ) select:[:sym | (AbstractOperatingSystem socketTypeCodeOf:sym) isNumber ]

    "
     AbstractOperatingSystem supportedSocketTypes
    "
! !

!AbstractOperatingSystem class methodsFor:'shared memory access'!

shmAttach:id address:addr flags:flags
    "low level entry to shmat()-system call.
     Not supported on all operatingSystems"

    ^ self unsupportedOperationSignal raise

    "Modified: / 19.5.1999 / 14:21:35 / cg"
!

shmDetach:addr
    "low level entry to shmdt()-system call.
     Not supported on all operatingSystems"

    ^ self unsupportedOperationSignal raise

    "Modified: / 19.5.1999 / 14:21:37 / cg"
!

shmGet:key size:size flags:flags
    "low level entry to shmget()-system call.
     This is not for public use and not supported with all operatingSystems.
     - use the provided wrapper class SharedExternalBytes instead."

    ^ self unsupportedOperationSignal raise

    "Modified: / 19.5.1999 / 14:21:41 / cg"
! !

!AbstractOperatingSystem class methodsFor:'time and date'!

computeDatePartsOf:osTime for:aBlock
    "compute year, month and day from the OS time, osTime
     and evaluate the argument, a 3-arg block with these.
     Conversion is to localtime including any daylight saving adjustments."

    <resource:#obsolete>

    |i|

    self obsoleteMethodWarning:'use #computeTimeAndDateFrom:osTime'.

    i := self computeTimeAndDateFrom:osTime.
    aBlock value:i year value:i month value:i day

    "
     OperatingSystem computeDatePartsOf:0 for:[:y :m :d |
	y printCR. m printCR. d printCR
     ]
    "
!

computeOSTimeFromUTCYear:y month:m day:d hour:h minute:min second:s millisecond:millis
    "return the OS-dependent time for the given time and day.
     The arguments are assumed to be in UTC time."

    ^ self
	computeOSTimeFromYear:y month:m day:d hour:h minute:min second:s millisecond:millis
	utc:true

    "
     OperatingSystem computeOSTimeFromUTCYear:1970 month:1 day:1 hour:0 minute:0 second:0 millisecond:0
    invalid:
     OperatingSystem computeOSTimeFromUTCYear:1970 month:1 day:1 hour:24 minute:0 second:0 millisecond:0
    "

    "Modified: / 07-07-2010 / 16:56:21 / cg"
!

computeOSTimeFromYear:y month:m day:d hour:h minute:min second:s millisecond:millis
    "return the OS-dependent time for the given time and day.
     The arguments are assumed to be in localtime including
     any daylight saving adjustings."

    ^ self
	computeOSTimeFromYear:y month:m day:d hour:h minute:min second:s millisecond:millis
	utc:false

    "
     OperatingSystem computeOSTimeFromYear:1970 month:1 day:1 hour:0 minute:0 second:0 millisecond:0
    invalid:
     OperatingSystem computeOSTimeFromYear:1970 month:1 day:1 hour:24 minute:0 second:0 millisecond:0
    "

    "Modified: / 07-07-2010 / 16:56:21 / cg"
!

computeOSTimeFromYear:y month:m day:d hour:h minute:min second:s millisecond:millis utc:utcBoolean
    "return the OS-dependent time for the given time and day.
     If utcBoolean is true, the arguments are assumed to be in UTC Time;
     otherwise in localtime including any daylight saving adjustings."

    self subclassResponsibility
!

computeTimeAndDateFrom:osTime
    "given an OS-dependent time in osTime, return an Array
     containing (full-) year, month, day, hour, minute and seconds,
     offset to UTC, daylight savings time flag, milliseconds,
     dayInYear (1..) and dayInWeek (1..).
     Conversion is to localtime including any daylight saving adjustments."

    ^ self timeInfoFromSeconds:(osTime // 1000) milliseconds:(osTime \\ 1000) localTime:true.

    "
     OperatingSystem computeTimeAndDateFrom:0
     OperatingSystem computeTimeAndDateFrom:1011
    "
!

computeTimePartsOf:osTime for:aBlock
    "compute hours, minutes, seconds and milliseconds from the local osTime
     and evaluate the argument, a 4-arg block with these.
     Conversion is to localtime including any daylight saving adjustments."

    <resource:#obsolete>

    |hours minutes seconds millis i|

    self obsoleteMethodWarning:'use #computeTimeAndDateFrom:osTime'.

    i := self computeTimeAndDateFrom:osTime.
    hours := i hours.
    minutes := i minutes.
    seconds := i seconds.
    millis := i milliseconds.

    aBlock value:hours value:minutes value:seconds value:millis

    "
     OperatingSystem computeTimePartsOf:100 for:[:h :m :s :milli |
	Transcript show:h; space; show:m; space; show:s; space; showCR:milli.
     ]
    "
!

computeUTCTimeAndDateFrom:osTime
    "given an OS-dependent time in osTime, return an Array
     containing:
	(full-) year,
	month,                          (1..)
	day,                            (1..)
	hour,                           (0..23)
	minute                          (0..59)
	seconds,                        (0..59)
	offset to UTC,                  (seconds)
	daylight savings time flag,
	milliseconds,                   (0..999)
	dayInYear                       (1..)
	dayInWeek                       (1..).
     Conversion is to utc."

    ^ self timeInfoFromSeconds:(osTime // 1000) milliseconds:(osTime \\ 1000)  localTime:false.

    "
     OperatingSystem computeUTCTimeAndDateFrom:0
     OperatingSystem computeUTCTimeAndDateFrom:1011
    "
!

computeUTCTimePartsOf:osTime for:aBlock
    "compute hours, minutes, seconds and milliseconds from the osTime
     and evaluate the argument, a 4-arg block with these.
     Conversion is to UTC."

    <resource:#obsolete>

    |hours minutes seconds millis i|

    self obsoleteMethodWarning:'use #computeTimeAndDateFrom:osTime'.

    i := self computeUTCTimeAndDateFrom:osTime.
    hours := i hours.
    minutes := i minutes.
    seconds := i seconds.
    millis := i milliseconds.

    aBlock value:hours value:minutes value:seconds value:millis
!

epochEndOSTime
    "private interface for timestamp to ask the OS what the maximum time
     (in milliseconds since the Unix epoch, 1.1.1970) is.
     32bit Unix systems will return 0x7FFFFFFF here; other OS's may return a higher number to indicate,
     that they can deal with timestamps after 2038 (especially: win32 will do so).
     Notice that timestamp is prepared to compensate for any OS limitation by computing the timeInfo
     components itself.
     So it is usually (except for a little performance) no problem to return a range too small here."

    ^ (SmallInteger maxVal * 2 + 1) * 1000
!

epochStartOSTime
    "private interface for timestamp to ask the OS what the minimum time
     (in milliseconds since the Unix epoch, 1.1.1970) is.
     Unix systems will return 0 here; other OS's may return a negative number to indicate,
     that they can deal with timestamps before 1970 (especially: win32 will do so).
     Notice that timestamp is prepared to compensate for any OS limitation by computing the timeInfo
     components itself.
     So it is usually (except for a little performane) no problem to return a reange too small here."

    ^ 0
!

getCPUCycleCount
    "get a CPU specific cycle counter value.
     Can be used for exact timing & performance measurements.
     Notice, that the # of cycles has to be multiplied by the cycle time (1/cpu-frequency).

     For x86:
	the CPU cycle count register value is returned (RDTSC instruction).
	answer 0 if RDTSC instruction is not supported (which is unlikely, nowadays).
     For others:
	answer 0"

%{  /* NOCONTEXT */
    unsigned INT low, high;

#if defined(__x86_64__) && (defined(__GNUC__) || defined(__CLANG__) || defined(__MINGW64__))
    asm volatile("rdtsc" : "=a"(low), "=d"(high));
    RETURN ( __MKUINT(low + (high << 32)) );
#endif

#ifdef i386
    // use RDTSC instruction (retrieves 64bit cycle count; hi in EDX, lo in EAX)

# if defined(__BORLANDC__)
    _asm { push edx };
    __emit__(0x0F,0x31);            /* RDTSC instruction */
    _asm { mov low,eax };
    _asm { mov high,edx };
    _asm { pop edx };
# elif defined(__MINGW_H) || defined(__MINGW32__) || defined(__GNUC__)
    asm volatile("rdtsc" : "=a"(low), "=d"(high));
# else
    goto unsupported;
# endif
    RETURN ( __MKLARGEINT64(1, low, high) );
#endif /* i386 */

unsupported: ;
%}.
    ^ 0

    "
     OperatingSystem getCPUCycleCount
    "

    "Created: / 05-01-2012 / 13:23:31 / cg"
!

getMicrosecondTime
    "This returns the microsecond timers value - if available.
     On some machines, times with this precision may not be available,
     on those, the returned value may be rounded towards some internal
     clock resolution value."

    "/ fallBack - use getMillisecondTime, which must be implemented
    "/ for all OS's

    ^ self getMillisecondTime * 1000

    "Created: / 30.7.1998 / 16:38:26 / cg"
!

getMillisecondTime
    "This returns the millisecond timers value.
     The range is limited to 0..1fffffff (i.e. the SmallInteger range) to avoid
     LargeInteger arithmetic when doing timeouts and delays.
     Since this value is wrapping around in regular intervals, this can only be used for
     short relative time deltas.
     Use the millisecondTimeXXX:-methods to compare and add time deltas - these know about the wrap.

     BAD DESIGN:
	This should be changed to return some instance of RelativeTime,
	and these computations moved there.

     Do not use this method in application code since it is an internal (private)
     interface. For compatibility with ST-80, use Time millisecondClockValue.
    "

    self subclassResponsibility
!

getOSTime
    "This returns the OS time.
     The base of the returned value is not consistent across
     different OS's - some return the number of millis since jan, 1st 1970;
     others since 1900. The Time classes are prepared for this, and
     converts as appropriate (by using my fromOSTime: conversion methods).

     Do not use this method in application code since it is an internal (private)
     interface. For compatibility with ST-80, use Time>>millisecondClockValue.
     or use instances of Time, Date or Timestamp to work with.
    "

    self subclassResponsibility
!

maximumMillisecondTimeDelta
    "this returns the maximum delta supported by millisecondCounter
     based methods. The returned value is half the value at which the
     timer wraps."

%{  /* NOCONTEXT */
    RETURN ( __mkSmallInteger(_MAX_INT >> 2) );
%}
!

millisecondDelay:millis
    "delay execution for millis milliseconds or until the next event arrives.
     All other threads proceed as usual.
     Better use a Delay, however, a delay cannot be used in the event handler or scheduler."

    |now then delta|

    now := self getMillisecondTime.
    then := self millisecondTimeAdd:now and:millis.

    [(delta := self millisecondTimeDeltaBetween:then and:now) > 0] whileTrue:[
	self
	    selectOnAnyReadable:nil writable:nil exception:nil
	    readableInto:nil writableInto:nil exceptionInto:nil
	    withTimeOut:delta.
	now := self getMillisecondTime.
    ]

    "
     OperatingSystem millisecondDelay:5000
    "
!

millisecondTime:msTime1 isAfter:msTime2
    "return true if msTime1 is after msTime2, false if not.
     The two arguments are supposed to be millisecond times
     (such as returned getMillisecondTime) which wrap at 16r1FFFFFFF.

     This should really be moved to some RelativeTime class."

    (msTime1 > msTime2) ifTrue:[
	^ (msTime1 - msTime2) <= (SmallInteger maxVal // 4).
    ] ifFalse:[
	^ (msTime2 - msTime1) > ((SmallInteger maxVal // 4) + 1)
    ].
!

millisecondTimeAdd:msTime1 and:msTime2
    "Add two millisecond times (such as returned getMillisecondTime).
     The returned value is msTime1 + msTime2 where a wrap occurs
     at:16r1FFFFFFF (32-bit systems) or:16r1FFFFFFFFFFFFFFF (64-bit systems).

     This should really be moved to some RelativeTime class."

    |sum|

    sum := msTime1 + msTime2.
    (sum > (SmallInteger maxVal // 2)) ifTrue:[
	self assert:(sum <= SmallInteger maxVal) message:'overflow in timer computation'.
	^ sum - (SmallInteger maxVal // 2 + 1).
    ].
    (sum < 0) ifTrue:[^ sum + (SmallInteger maxVal // 2 + 1)].
    ^ sum
!

millisecondTimeDeltaBetween:msTime1 and:msTime2
    "subtract two millisecond times (such as returned getMillisecondTime)
     and return the difference. Since milli-times wrap (at 16r01FFFFFFF),
     some special handling is built-in here.
     The returned value is msTime1 - msTime2. The returned value is invalid
     if the delta is >= 0x10000000.

     This should really be moved to some RelativeTime class;
     better yet: create a subclass of Integer named LimitedRangeInteger."

    |diff|

    diff := msTime1 - msTime2.

    diff < (SmallInteger maxVal // -4) ifTrue:[
	^ diff + (SmallInteger maxVal // 2) + 1.
    ].

    diff <= (SmallInteger maxVal // 4) ifTrue:[
	^ diff.
    ] ifFalse:[
	^ diff - (SmallInteger maxVal // 2 + 1).
    ].


    "
     OperatingSystem millisecondTimeAdd:16r0FFFFFFF and:1
     OperatingSystem millisecondTimeAdd:16r0FFFFFFF and:(16 / 3)
     OperatingSystem millisecondTimeAdd:16r0FFFFFFF and:1000

     OperatingSystem millisecondTimeDeltaBetween:0 and:16r0FFFFFFF
     OperatingSystem millisecondTimeDeltaBetween:0 and:16r1FFFFFFF
     OperatingSystem millisecondTimeDeltaBetween:16r1FFFFFFF and:0

     OperatingSystem millisecondTimeDeltaBetween:(13/3) and:16r0FFFFFFF
     OperatingSystem millisecondTimeDeltaBetween:999 and:16r0FFFFFFF

     OperatingSystem millisecondTime:0 isAfter:16r0FFFFFFF
     OperatingSystem millisecondTime:0 isAfter:16r1FFFFFFF
     OperatingSystem millisecondTime:(13/3) isAfter:16r0FFFFFFF
     OperatingSystem millisecondTime:999 isAfter:16r0FFFFFFF

     OperatingSystem millisecondTime:0 isAfter:0
     OperatingSystem millisecondTime:(13/3) isAfter:0
     OperatingSystem millisecondTime:999 isAfter:0

     OperatingSystem millisecondTime:1 isAfter:0
     OperatingSystem millisecondTime:(13/3) isAfter:2
     OperatingSystem millisecondTime:999 isAfter:900

     |t1 t2|

     t1 := Time millisecondClockValue.
     (Delay forMilliseconds:1) wait.
     t2 := Time millisecondClockValue.
     OperatingSystem millisecondTimeDeltaBetween:t2 and:t1
    "
!

sleep:numberOfSeconds
    "{ Pragma: +optSpace }"

    "cease ANY action for some time. This suspends the whole smalltalk
     (unix-) process for some time.
     Not really useful since not even low-prio processes and interrupt
     handling will run during the sleep.
     Use either OperatingSystem>>millisecondDelay: (which makes all
     threads sleep, but handles interrupts) or use a Delay (which makes
     only the calling thread sleep)."

    self subclassResponsibility
!

timeInfoClass
    ^ TimeInfo
!

timeInfoFromSeconds:osSeconds localTime:isLocalTime
    "return a timeInfo structure containing values for the given OS-second value.
     An internal helper"

    ^ self timeInfoFromSeconds:osSeconds milliseconds:0 localTime:isLocalTime
!

timeInfoFromSeconds:osSeconds milliseconds:osMilliSeconds localTime:isLocalTime
    "return a timeInfo structure containing values for the given OS-second value.
     An internal helper"

    self subclassResponsibility
!

timeZoneInfoClass
    ^ TimeZoneInfo
!

utcOffset
    ^ (self computeTimeAndDateFrom:0) utcOffset

    "
     OperatingSystem utcOffset
    "
! !

!AbstractOperatingSystem class methodsFor:'users & groups'!

getApplicationDataDirectoryFor:appName
    "return the directory, where user-and-application-specific private files are to be
     located (ini-files, preferences etc.).
     Under windows, something like 'C:\Users\Administrator\AppData\Roaming\<appName>'
     is returned, here, the fallback ~/.<appName> is returned.
     Notice that only the name is returned; the directory is not guaranteed to exist."

    "{ Pragma: +optSpace }"

    ^ self getHomeDirectory asFilename constructString:('.',appName)

    "
     OperatingSystem getApplicationDataDirectoryFor:'expecco'
    "

    "Created: / 29-07-2010 / 12:07:25 / sr"
!

getDesktopDirectory
    "{ Pragma: +optSpace }"

    "return the name of the user's desktop directory.
     The fallback here returns the user's home directory."

    ^ self getHomeDirectory

    "
     OperatingSystem getDesktopDirectory
    "

    "Created: / 16-05-2007 / 13:20:53 / cg"
!

getDocumentsDirectory
    "return your documents directory.
     Under windows, that's the real 'Documents' or 'My Documents'.
     The fallback here returns the users home directory."

    "{ Pragma: +optSpace }"

    ^ self getHomeDirectory

    "
     OperatingSystem getDocumentsDirectory
    "
!

getEffectiveGroupID
    "{ Pragma: +optSpace }"

    "return the current users (that's you) effective numeric group id.
     This is only different from getGroupID, if you have ST/X running
     as a setuid program (of which you should think about twice)."

    ^ self getGroupID

    "
     OperatingSystem getEffectiveGroupID
    "
!

getEffectiveUserID
    "{ Pragma: +optSpace }"

    "return the current users (that's you) effective numeric user id.
     This is only different from getUserID, if you have ST/X running
     as a setuid program (of which you should think about twice)."

    ^ self getUserID

    "
     OperatingSystem getEffectiveUserID
    "
!

getFullUserName
    "{ Pragma: +optSpace }"

    "return a string with the users full name (that's you) - if available.
     If not, return the login name as a fallBack."

    ^ self getFullUserNameFromID:(self getUserID)

    "
     OperatingSystem getFullUserName
    "

    "Modified: 24.1.1997 / 11:31:55 / cg"
!

getFullUserNameFromID:userID
    "{ Pragma: +optSpace }"

    "return a string with the users full name - if available.
     If not, return the login name as a fallBack."

    ^ self getUserNameFromID:userID

    "
     OperatingSystem getFullUserNameFromID:0
     OperatingSystem getFullUserNameFromID:(OperatingSystem getUserID)

     OperatingSystem getUserNameFromID:(OperatingSystem getUserID)
    "

    "Modified: 15.7.1996 / 12:44:21 / cg"
!

getGroupID
    "{ Pragma: +optSpace }"

    "return the current users (that's you) numeric group id"

    ^ 1 "/ just a dummy for systems which do not have userIDs

    "
     OperatingSystem getGroupID
    "
!

getGroupNameFromID:aNumber
    "{ Pragma: +optSpace }"

    "return the group-name-string for a given numeric group-id"

    ^ '???' "/ just a dummy for systems which do not have groups

    "
     OperatingSystem getGroupNameFromID:0
     OperatingSystem getGroupNameFromID:10
    "
!

getHomeDirectory
    "return the name of the users home directory
     (i.e. yours)"

    ^ self subclassResponsibility

    "
     OperatingSystem getHomeDirectory
    "

    "Modified: 24.1.1997 / 11:32:13 / cg"
!

getLoginName
    "{ Pragma: +optSpace }"

    "return a string with the users login name (that's yours)"

    self subclassResponsibility
!

getUserID
    "{ Pragma: +optSpace }"

    "return the current users (that's you) numeric user id"

    ^ 1 "just a dummy for systems which do not have userIDs"

    "
     OperatingSystem getUserID
    "
!

getUserNameFromID:aNumber
    "{ Pragma: +optSpace }"

    "return the user-name-string for a given numeric user-id.
     This is the login name, not the fullName."

    "/ fallBack dummy

    aNumber == self getUserID ifTrue:[
	^ self getLoginName
    ].

    ^ '? (' , aNumber printString , ')'

    "
     OperatingSystem getUserNameFromID:0
     OperatingSystem getUserNameFromID:100
     OperatingSystem getUserNameFromID:9991
     OperatingSystem getUserNameFromID:(OperatingSystem getUserID)
    "
!

isRunningWithElevatedRootOrAdminRights
    ^ false     "/ actually: don't know
!

isRunningWithRootOrAdminRights
    ^ false     "/ actually: don't know
!

userInfoOf:aNameOrID
    "{ Pragma: +optSpace }"

    "return a dictionary filled with userinfo. The argument can be either
     a string with the users name or its numeric id.
     Notice, that not all systems provide (all of) this info;
     DOS systems return nothing;
     non-SYSV4 systems have no age/comment.
     Portable applications may want to check the systemType and NOT depend
     on all keys to be present in the returned dictionary.
     Another notice: on some systems (SYSV4), the gecos field includes multiple
     entries (i.e. not just the name), separated by commas. You may want to
     extract any substring, up to the first comma to get the real life name."

    |info|

    "/ fallBack dummy
    info := IdentityDictionary new.
    info at:#name put:(self getLoginName).
    info at:#dir put:(self getHomeDirectory).
    ^ info

    "
     OperatingSystem userInfoOf:'root'
     OperatingSystem userInfoOf:1
     OperatingSystem userInfoOf:'claus'
     OperatingSystem userInfoOf:'fooBar'
     OperatingSystem userInfoOf:(OperatingSystem getUserID)
    "
! !

!AbstractOperatingSystem class methodsFor:'waiting for events'!

blockingChildProcessWait
     "return true, if childProcessWait: blocks, if no children are ready.
      On those systems, we must be somewhat careful when looking out for
      a subprocesses status (to avoid blocking)."

    ^ true
!

childProcessWait:blocking pid:pidToWait
    "{ Pragma: +optSpace }"

    "get status changes from child processes.
     Return an OSProcessStatus or nil, if no process has terminated.
     If blocking is true, we wait until a process changed state,
     otherwise we return immediately.
     Note that win32 needs to know the HANDLE of the process on which
     it waits.  In case of an error, THIS ALWAYS WAITS and then times out."

    self subclassResponsibility
!

isBlockingOn:fd
    "{ Pragma: +optSpace }"

    "return the blocking attribute - if set (which is the default)
     a read on the fileDescriptor will block until data is available.
     If clear, a read operation will immediately return with a value nil.
     Also affects write operations, which may perform partial writes when
     blocking is off"

    self subclassResponsibility
!

numAvailableForReadOn:fd
    "return the number of bytes available for reading, without blocking."

    "/ fallBack for systems which do not provide this info
    ^ (self readCheck:fd) ifTrue:[1] ifFalse:[0]
!

readCheck:fd
    "return true, if a read is possible without blocking.
     This is the case if data is available on a filedescriptor
     or the read would return an error.
     This depends on a working select or FIONREAD to be provided by the OS."

    |result|

    self supportsSelect ifFalse:[
	"/ mhmh - what should we do then ?
	"/ For now, return true as if data was present,
	"/ and let the thread fall into the read.
	"/ It will then (hopefully) be descheduled there and
	"/ effectively polling for input.

	^ true
    ].

    result := self
		selectOnAnyReadable:(Array with:fd) writable:nil exception:nil
		readableInto:nil writableInto:nil exceptionInto:nil
		withTimeOut:0.

    "on select error, a read will immediately return, so answer true"
    ^ result ~~ 0.
!

readWriteCheck:fd
    "return true, if filedescriptor can be read or written without blocking.
     This is the case if data is available on a filedescriptor
     or the read or write would return an error.
     This is actually only used with sockets, to wait for a connect to
     be finished."

    |result fdArray|

    self supportsSelect ifFalse:[
	"/ mhmh - what should we do then ?
	"/ For now, return true as if data was present,
	"/ and let the thread fall into the write.
	"/ It will then (hopefully) be desceduled there and
	"/ effectively polling for output.
	^ true
    ].

    result := self
		selectOnAnyReadable:(fdArray := Array with:fd) writable:fdArray exception:nil
		readableInto:nil writableInto:nil exceptionInto:nil
		withTimeOut:0.

    "on select error, a read will immediately return, so answer true"
    ^ result > 0.
!

selectOn:fd1 and:fd2 withTimeOut:millis
    "wait for any fd to become ready; timeout after t milliseconds.
     A zero timeout-time will immediately return (i.e. poll).
     Return fd if i/o ok, nil if timed-out or interrupted.
     Obsolete:
	This is a leftover method and will vanish."
    <resource: #obsolete>

    |fdArray|

     ^ (self
	   selectOnAnyReadable:(fdArray := Array with:fd1 with:fd2) writable:fdArray exception:nil
	   readableInto:nil writableInto:nil exceptionInto:nil
	   withTimeOut:millis) > 0.
!

selectOn:fd withTimeOut:millis
    "wait for aFileDesriptor to become ready; timeout after t milliseconds.
     Return true, if i/o ok, false if timed-out or interrupted.
     With 0 as timeout argument, this can be used to check for availability
     of read-data.
     Experimental."

    |fdArray|

    ^ (self
	selectOnAnyReadable:(fdArray := Array with:fd) writable:fdArray exception:nil
	readableInto:nil writableInto:nil exceptionInto:nil
	withTimeOut:millis) > 0.
!

selectOnAny:fdArray withTimeOut:millis
    "wait for any fd in fdArray (an Array of integers) to become ready;
     timeout after t milliseconds. An empty set will always wait.
     Return first ready fd if i/o ok, nil if timed-out or interrupted.
     Experimental."

    |resultFdArray nReady|

    resultFdArray := Array new:1.  "/ I am only interested in the first fd

    nReady := self
		selectOnAnyReadable:fdArray writable:fdArray exception:nil
		readableInto:resultFdArray writableInto:resultFdArray exceptionInto:nil
		withTimeOut:millis.
    nReady > 0 ifTrue:[
	^ resultFdArray first.
    ].

    ^ nil
!

selectOnAnyReadable:fdArray withTimeOut:millis
    "wait for any fd in fdArray (an Array of integers) to become ready for
     reading. Timeout after t milliseconds. An empty set will always wait.
     A zero timeout-time will immediately return (i.e. poll).
     Return first ready fd if i/o ok, nil if timed-out or interrupted.
     Experimental."

    |resultFdArray nReady|

    resultFdArray := Array new:1.  "/ I am only interested in the first fd

    nReady := self
		selectOnAnyReadable:fdArray writable:nil exception:nil
		readableInto:resultFdArray writableInto:nil exceptionInto:nil
		withTimeOut:millis.
    nReady > 0 ifTrue:[
	^ resultFdArray first.
    ].

    ^ nil
!

selectOnAnyReadable:readFdArray writable:writeFdArray exception:exceptFdArray
	readableInto:readableResultFdArray writableInto:writableResultFdArray
	exceptionInto:exceptionResultFdArray
	withTimeOut:millis

    "wait for any fd in readFdArray (an Array of integers) to become ready for reading,
     writeFdArray to become ready for writing,
     or exceptFdArray to arrive exceptional data (i.e. out-of-band data).
     Timeout after t milliseconds or - if the timeout time is 0 - immediately..
     Empty fd-sets will always wait. Zero time can be used to poll file-
     descriptors (i.e. to check if I/O possible without blocking).
     The corresponding filedescriptors which are ready are returned in readableResultFdArray,
     writableResultFdArray and exceptionResultFdArray respectively.

     Return the (overall) number of selected filedescriptors.
     readableResultFdArray, writableResultFdArray and exceptionResultFdArray will
     get a nil-value stored into the slot after the last valid fileDescriptor;
     Thus, the caller can simply scan these arrays upTo the end or a nil value."

    self subclassResponsibility
!

selectOnAnyReadable:readFdArray writable:writeFdArray exception:exceptFdArray withTimeOut:millis
    "wait for any fd in readFdArray (an Array of integers) to become ready for
     reading, writeFdArray to become ready for writing, or exceptFdArray to
     arrive exceptional data (i.e. out-of-band data).
     Timeout after t milliseconds or, if the timeout time is 0, immediately..
     Empty fd-sets will always wait. Zero time can be used to poll file-
     descriptors (i.e. to check if I/O possible without blocking).
     Return first ready fd if I/O ok, nil if timed-out or interrupted."

    |resultFdArray nReady|

    resultFdArray := Array new:1.  "/ I am only interested in the first fd

    nReady := self
		selectOnAnyReadable:readFdArray writable:writeFdArray exception:exceptFdArray
		readableInto:resultFdArray writableInto:resultFdArray exceptionInto:resultFdArray
		withTimeOut:millis.
    nReady > 0 ifTrue:[
	^ resultFdArray first.
    ].

    ^ nil
!

setBlocking:aBoolean on:fd
    "set/clear the blocking attribute - if set (which is the default)
     a read on the fileDescriptor will block until data is available.
     If cleared, a read operation will immediately return with a value of nil.
     Also affects write operations, which may perform partial writes when
     blocking is off. Answer the previous blocking status."

    "{ Pragma: +optSpace }"

    self subclassResponsibility
!

writeCheck:fd
    "return true, if filedescriptor can be written without blocking.
     This is the case if data can be written to a filedescriptor
     or the write would return an error."

    |result|

    self supportsSelect ifFalse:[
	"/ mhmh - what should we do then ?
	"/ For now, return true as if data was present,
	"/ and let the thread fall into the write.
	"/ It will then (hopefully) be desceduled there and
	"/ effectively polling for output.
	^ true
    ].

    result := self
		selectOnAnyReadable:nil writable:(Array with:fd) exception:nil
		readableInto:nil writableInto:nil exceptionInto:nil
		withTimeOut:0.

    "on select error, a read will immediately return, so answer true"
    ^ result > 0.
!

writeExceptionCheck:fd
    "return true, if filedescriptor can be written without blocking
     or has an exception event pending.
     This is the case if data can be written to a filedescriptor
     or the write would return an error.
     This is actually only used with sockets, to wait for a connect to
     be finished."

    |result fdArray|

    self supportsSelect ifFalse:[
	"/ mhmh - what should we do then ?
	"/ For now, return true as if data was present,
	"/ and let the thread fall into the write.
	"/ It will then (hopefully) be desceduled there and
	"/ effectively polling for output.
	^ true
    ].

    result := self
		selectOnAnyReadable:nil writable:(fdArray := Array with:fd) exception:fdArray
		readableInto:nil writableInto:nil exceptionInto:nil
		withTimeOut:0.

    "on select error, a read will immediately return, so answer true"
    ^ result > 0.
! !

!AbstractOperatingSystem::PrinterInfo class methodsFor:'constants'!

paperSizeNameForNumber:aNumber
    ^ self paperSizeNumberToNameMapping at:aNumber

    "
     self paperSizeNameForNumber:1
    "

    "Created: / 31-07-2006 / 15:35:36 / fm"
!

paperSizeNameForNumber:aNumber ifAbsent: aBlock
    ^ self paperSizeNumberToNameMapping at:aNumber ifAbsent: aBlock

    "
     self paperSizeNameForNumber:11212 ifAbsent: [nil]
    "

    "Created: / 31-07-2006 / 15:35:36 / fm"
!

paperSizeNames
    |codes|
    codes := self paperSizeNumberToNameTable values asSortedCollection:[:a :b | a < b].
    ^codes collect:[:each | self paperSizeNameForNumber: each]

    "Created: / 31-07-2006 / 15:35:36 / fm"
    "Modified: / 16-04-2007 / 12:03:55 / cg"
!

paperSizeNumberForName:aName
    ^ self paperSizeNumberToNameMapping at:aName

    "
     self paperSizeNumberForName:'Letter, 8 1/2- by 11-inches'
    "

    "Created: / 31-07-2006 / 15:35:37 / fm"
!

paperSizeNumberToNameMapping
    |d|

    d := self paperSizeNumberToNameTable.

    d keys copy do:[:k | d at:(d at:k) put:k].
    ^ d.

    "Created: / 31-07-2006 / 15:35:37 / fm"
!

paperSizeNumberToNameTable

    ^Dictionary withKeysAndValues:
	#(
	    'Letter, 8 1/2- by 11-inches'                   1       "/ Letter
	    'Legal 8 1/2- by 14-inches'                     5       "/ Legal
	    '10- by 14-inch sheet'                          16       "/ 10x14
	    '11- by 17-inch sheet'                          17       "/ 11x17
	    "/ '12X11'             "/ Windows 98/Me, Windows NT 4.0 and later: 12- by 11-inch sheet
	    'A3 sheet, 297- by 420-millimeters'             8       "/ A3
	    'A3 rotated sheet, 420- by 297-millimeters'     67      "/ A3_rotated
	    'A4 sheet, 210- by 297-millimeters'             9       "/ A4
	    'A4 rotated sheet, 297- by 210-millimeters'     55      "/ A4_rotated
	    'A4 small sheet, 210- by 297-millimeters'       10      "/ A4 small
	    'A5 sheet, 148- by 210-millimeters'             11      "/ A5
	    'A5 rotated sheet, 210- by 148-millimeters'     61      "/ A5 rotated
"/            'a6'                "/ Windows 98/Me, Windows NT 4.0 and later: A6 sheet, 105- by 148-millimeters
"/          'a6_rotated'          "/ Windows 98/Me, Windows NT 4.0 and later: A6 rotated sheet, 148- by 105-millimeters
	    'B4 sheet, 250- by 354-millimeters'             12      "/ B4
"/ b4_jis_rotated  Windows 98/Me, Windows NT 4.0 and later: B4 (JIS) rotated sheet, 364- by 257-millimeters
	    'B5 sheet, 182- by 257-millimeter paper'        13      "/ B5
"/ b5_jis_rotated  Windows 98/Me, Windows NT 4.0 and later: B5 (JIS) rotated sheet, 257- by 182-millimeters
"/ b6_jis  Windows 98/Me, Windows NT 4.0 and later: B6 (JIS) sheet, 128- by 182-millimeters
"/ b6_jis_rotated  Windows 98/Me, Windows NT 4.0 and later: B6 (JIS) rotated sheet, 182- by 128-millimeters
"/ csheet  C Sheet, 17- by 22-inches
"/ dbl_japanese_postcard   Windows 98/Me, Windows NT 4.0 and later: Double Japanese Postcard, 200- by 148-millimeters
"/ dbl_japanese_postcard_rotated   Windows 98/Me, Windows NT 4.0 and later: Double Japanese Postcard Rotated, 148- by 200-millimeters
"/ dsheet  D Sheet, 22- by 34-inches
	    '#9 Envelope, 3 7/8- by 8 7/8-inches'           19     "/  env_9
	    '#10 Envelope, 4 1/8- by 9 1/2-inches'          20     "/  env_10
	    '#11 Envelope, 4 1/2- by 10 3/8-inches'         21     "/  env_11
	    '#12 Envelope, 4 3/4- by 11-inches'             22     "/  env_12
	    '#14 Envelope, 5- by 11 1/2-inches'             23     "/  env_15
	    'C5 Envelope, 162- by 229-millimeters'          28     "/  env_c5
	    'C3 Envelope, 324- by 458-millimeters'          29      "/ env_c3
	    'C4 Envelope, 229- by 324-millimeters'          30      "/ env_c4
	    'C6 Envelope, 114- by 162-millimeters'          31      "/ env_c6
	    'C65 Envelope, 114- by 229-millimeters'         32      "/ env_c65
	    'B4 Envelope, 250- by 353-millimeters'          33      "/ env_b4
	    'B5 Envelope, 176- by 250-millimeters'          34      "/  env_b5
	    'B6 Envelope, 176- by 125-millimeters'          35      "/  env_b6
	    'DL Envelope, 110- by 220-millimeters'          27      "/  env_dl
	    'Italy Envelope, 110- by 230-millimeters'       36      "/  env_italy
	    'Monarch Envelope, 3 7/8- by 7 1/2-inches'      37      "/   env_monarch
"/ env_personal    6 3/4 Envelope, 3 5/8- by 6 1/2-inches
"/ esheet  E Sheet, 34- by 44-inches
"/ executive   Executive, 7 1/4- by 10 1/2-inches
"/ fanfold_us  US Std Fanfold, 14 7/8- by 11-inches
"/ fanfold_std_german  German Std Fanfold, 8 1/2- by 12-inches
"/ fanfold_lgl_german  German Legal Fanfold, 8 - by 13-inches
"/ folio   Folio, 8 1/2- by 13-inch paper
"/ japanese_postcard_rotated   Windows 98/Me, Windows NT 4.0 and later: Japanese Postcard Rotated, 148- by 100-millimeters
"/ jenv_chou3  Windows 98/Me, Windows NT 4.0 and later: Japanese Envelope Chou #3
"/ jenv_chou3_rotated  Windows 98/Me, Windows NT 4.0 and later: Japanese Envelope Chou #3 Rotated
"/ jenv_chou4  Windows 98/Me, Windows NT 4.0 and later: Japanese Envelope Chou #4
"/ jenv_chou4_rotated  Windows 98/Me, Windows NT 4.0 and later: Japanese Envelope Chou #4 Rotated
"/ jenv_kaku2  Windows 98/Me, Windows NT 4.0 and later: Japanese Envelope Kaku #2
"/ jenv_kaku2_rotated  Windows 98/Me, Windows NT 4.0 and later: Japanese Envelope Kaku #2 Rotated
"/ jenv_kaku3  Windows 98/Me, Windows NT 4.0 and later: Japanese Envelope Kaku #3
"/ jenv_kaku3_rotated  Windows 98/Me, Windows NT 4.0 and later: Japanese Envelope Kaku #3 Rotated
"/ jenv_you4   Windows 98/Me, Windows NT 4.0 and later: Japanese Envelope You #4
"/ jenv_you4_rotated   Windows 98/Me, Windows NT 4.0 and later: Japanese Envelope You #4 Rotated
"/ last    Windows 2000/XP: PENV_10_ROTATED
	    'Ledger, 17- by 11-inches'                      4    "/   ledger
	    'Letter Rotated 11 by 8 1/2 11 inches'          54      "/    letter_rotated
"/ lettersmall     Letter Small, 8 1/2- by 11-inches
"/ note    Note, 8 1/2- by 11-inches
"/ p16k    Windows 98/Me, Windows NT 4.0 and later: PRC 16K, 146- by 215-millimeters
"/ p16k_rotated    Windows 98/Me, Windows NT 4.0 and later: PRC 16K Rotated, 215- by 146-millimeters
"/ p32k    Windows 98/Me, Windows NT 4.0 and later: PRC 32K, 97- by 151-millimeters
"/ p32k_rotated    Windows 98/Me, Windows NT 4.0 and later: PRC 32K Rotated, 151- by 97-millimeters
"/ p32kbig     Windows 98/Me, Windows NT 4.0 and later: PRC 32K(Big) 97- by 151-millimeters
"/ p32kbig_rotated     Windows 98/Me, Windows NT 4.0 and later: PRC 32K(Big) Rotated, 151- by 97-millimeters
"/ penv_1  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #1, 102- by 165-millimeters
"/ penv_1_rotated  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #1 Rotated, 165- by 102-millimeters
"/ penv_2  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #2, 102- by 176-millimeters
"/ penv_2_rotated  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #2 Rotated, 176- by 102-millimeters
"/ penv_3  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #3, 125- by 176-millimeters
"/ penv_3_rotated  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #3 Rotated, 176- by 125-millimeters
"/ penv_4  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #4, 110- by 208-millimeters
"/ penv_4_rotated  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #4 Rotated, 208- by 110-millimeters
"/ penv_5  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #5, 110- by 220-millimeters
"/ penv_5_rotated  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #5 Rotated, 220- by 110-millimeters
"/ penv_6  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #6, 120- by 230-millimeters
"/ penv_6_rotated  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #6 Rotated, 230- by 120-millimeters
"/ penv_7  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #7, 160- by 230-millimeters
"/ penv_7_rotated  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #7 Rotated, 230- by 160-millimeters
"/ penv_8  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #8, 120- by 309-millimeters
"/ penv_8_rotated  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #8 Rotated, 309- by 120-millimeters
"/ penv_9  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #9, 229- by 324-millimeters
"/ penv_9_rotated  Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #9 Rotated, 324- by 229-millimeters
"/ penv_10     Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #10, 324- by 458-millimeters
"/ penv_10_rotated     Windows 98/Me, Windows NT 4.0 and later: PRC Envelope #10 Rotated, 458- by 324-millimeters
"/ quarto  Quarto, 215- by 275-millimeter paper
"/ statement   Statement, 5 1/2- by 8 1/2-inches
"/ tabloid     Tabloid, 11- by 17-inches
	).

    "Created: / 31-07-2006 / 15:35:37 / fm"
!

statusNumberToDescriptionForNumber:aNumber
    ^ self statusNumberToDescriptionMapping at:aNumber ifAbsent:[('Unknown (%1)' bindWith:aNumber printString)]

    "
     self statusNumberToDescriptionForNumber:1
    "

    "Created: / 01-08-2006 / 14:31:18 / fm"
!

statusNumberToDescriptionMapping
    |d|

    d := self statusNumberToDescriptionTable.

    d keys copy do:[:k | d at:(d at:k) put:k].
    ^ d.

    "Created: / 01-08-2006 / 14:31:05 / fm"
!

statusNumberToDescriptionTable

    ^Dictionary withKeysAndValues:
	#( 'Ready'                     0                           "/ PRINTER_STATUS_READY
	   'Paused'                    1                           "/ PRINTER_STATUS_PAUSED
	   'Error'                     2                           "/ PRINTER_STATUS_ERROR
	   'Deleting...'               4                           "/ PRINTER_STATUS_PENDING_DELETION
	   'Paper Jam'                 8                           "/ PRINTER_STATUS_PAPER_JAM
	   'Paper Out'                 16                          "/ PRINTER_STATUS_PAPER_OUT
	   'Manual Feed Required'      32                          "/ PRINTER_STATUS_MANUAL_FEED
	   'Paper Problem'             64                          "/ PRINTER_STATUS_PAPER_PROBLEM
	   'Offline'                   128                         "/ PRINTER_STATUS_OFFLINE
	   'Downloading Job'           256                         "/ PRINTER_STATUS_IO_ACTIVE
	   'Busy'                      512                         "/ PRINTER_STATUS_BUSY
	   'Printing'                  1024                        "/ PRINTER_STATUS_PRINTING
	   'Output Bill Full'          2048                        "/ PRINTER_STATUS_OUTPUT_BIN_FULL
	   'Not Available'             4096                         "/ PRINTER_STATUS_NOT_AVAILABLE
	   'Waiting'                   8192                         "/ PRINTER_STATUS_WAITING
	   'Processing Job'            16384                         "/ PRINTER_STATUS_PROCESSING
	   'Initializing'              32768                         "/ PRINTER_STATUS_INITIALIZING
	   'Warming Up'                65536                         "/ PRINTER_STATUS_WARMING_UP
	   'Toner Low'                 131072                         "/ PRINTER_STATUS_TONER_LOW
	   'Toner Out'                 262144                         "/ PRINTER_STATUS_NO_TONER
	   'Page too Complex'          524288                         "/ PRINTER_STATUS_PAGE_PUNT
	   'User Intervention Required'1048576                         "/ PRINTER_STATUS_USER_INTERVENTION
	   'Out of Memory'             2097152                         "/ PRINTER_STATUS_OUT_OF_MEMORY
	   'Door Open'                 4194304                         "/ PRINTER_STATUS_DOOR_OPEN
	   'Unable to connect'         8388608                         "/ PRINTER_STATUS_SERVER_UNKNOWN
	   'Power Save Mode'           16777216                         "/ PRINTER_STATUS_POWER_SAVE
	    ).

    "Created: / 01-08-2006 / 14:23:33 / fm"
! !

!AbstractOperatingSystem::PrinterInfo methodsFor:'accessing'!

attributes
    ^ attributes

    "Created: / 27-07-2006 / 12:16:59 / fm"
!

collate
    |properties|

    properties := self documentProperties.
    ^ properties isNil ifTrue:[ nil ] ifFalse:[ properties collate = 1 ]

    "Created: / 01-08-2006 / 09:56:14 / fm"
    "Modified: / 01-08-2006 / 11:49:18 / fm"
    "Modified: / 18-10-2006 / 12:02:29 / User"
!

collate: aBoolean
    |integer|

    integer:= aBoolean
		ifTrue:[1]      "DMCOLLATE_TRUE"
		ifFalse:[0].    "DMCOLLATE_FALSE"
    self documentProperties collate: integer

    "Created: / 01-08-2006 / 09:56:01 / fm"
    "Modified: / 16-04-2007 / 12:01:30 / cg"
!

comment
    ^self printerInfo2 pComment

    "Created: / 01-08-2006 / 15:06:20 / fm"
    "Modified: / 16-04-2007 / 12:01:42 / cg"
!

copies
    |properties|

    properties := self documentProperties.
    ^ properties isNil ifTrue:[ nil ] ifFalse:[ properties copies ]

    "Created: / 31-07-2006 / 13:46:53 / fm"
    "Modified: / 18-10-2006 / 12:02:14 / User"
!

copies: anInteger
    self documentProperties copies: anInteger

    "Created: / 31-07-2006 / 13:54:55 / fm"
    "Modified: / 16-04-2007 / 12:01:48 / cg"
!

documentProperties

    ^documentProperties

    "Created: / 28-07-2006 / 11:50:04 / fm"
    "Modified: / 31-07-2006 / 13:06:24 / fm"
!

documentProperties: aDevModeStructure

    documentProperties := aDevModeStructure.

    "Created: / 28-07-2006 / 11:47:31 / fm"
!

driverName

    ^self attributes at:#driverName

    "Created: / 01-08-2006 / 15:33:08 / fm"
    "Modified: / 16-04-2007 / 12:01:53 / cg"
!

location

    ^self printerInfo2 pLocation

    "Created: / 01-08-2006 / 15:06:28 / fm"
    "Modified: / 16-04-2007 / 12:02:07 / cg"
!

longName
    ^attributes at:#longName ifAbsent:['']

    "Created: / 28-07-2006 / 12:06:32 / fm"
    "Modified: / 16-04-2007 / 12:02:11 / cg"
!

medium

    ^self attributes at:#medium

    "Created: / 01-08-2006 / 15:34:26 / fm"
    "Modified: / 16-04-2007 / 12:02:14 / cg"
!

orientation
    |properties|

    properties := self documentProperties.
    ^ properties isNil ifTrue:[ nil ] ifFalse:[ properties orientation ]

    "Created: / 28-07-2006 / 16:44:26 / fm"
    "Modified: / 18-10-2006 / 12:01:36 / User"
!

orientation:anInteger
    |properties|

    properties := self documentProperties.
    properties notNil ifTrue:[
	properties orientation:anInteger
    ]

    "Created: / 28-07-2006 / 17:22:44 / fm"
    "Modified: / 18-10-2006 / 12:01:40 / User"
!

pDriverName

    ^self printerInfo2 pDriverName

    "Created: / 01-08-2006 / 15:33:08 / fm"
    "Modified: / 16-04-2007 / 12:02:21 / cg"
!

paperSize
    |properties|

    properties := self documentProperties.
    ^ properties isNil ifTrue:[ nil ] ifFalse:[ properties paperSize ]

    "Created: / 31-07-2006 / 15:23:29 / fm"
    "Modified: / 31-07-2006 / 16:25:58 / fm"
    "Modified: / 18-10-2006 / 12:01:45 / User"
!

paperSize:anInteger
    |properties|

    properties := self documentProperties.
    properties notNil ifTrue:[
	properties paperSize:anInteger
    ]

    "Created: / 31-07-2006 / 15:23:20 / fm"
    "Modified: / 18-10-2006 / 12:01:48 / User"
!

paperSizeName
    ^ self class paperSizeNameForNumber:self paperSize ifAbsent:[nil].

    "Created: / 31-07-2006 / 15:35:12 / fm"
!

paperSizeName:aString
    self paperSize:(self class paperSizeNumberForName:aString)

    "Modified: / 18-10-2006 / 12:01:56 / User"
!

printQuality
    ^self documentProperties printQuality

    "Created: / 04-08-2006 / 13:10:06 / fm"
!

printerName
    ^ printerName

    "Created: / 27-07-2006 / 12:16:59 / fm"
!

printerName:printerNameArg attributes:attributesArg

    printerName := printerNameArg.
    attributes := attributesArg.

    "Created: / 27-07-2006 / 12:29:18 / fm"
!

remotePrinterHost
    ^attributes at:#remotePrinterHost ifAbsent:['']

    "Created: / 28-07-2006 / 16:30:13 / fm"
    "Modified: / 16-04-2007 / 12:02:32 / cg"
!

remotePrinterName
    ^attributes at:#remotePrinterName ifAbsent:['']

    "Created: / 28-07-2006 / 16:30:06 / fm"
    "Modified: / 16-04-2007 / 12:03:23 / cg"
!

status
    self isAvailable ifFalse:[^''].
    ^self class statusNumberToDescriptionForNumber: self getPrinterInfo2 status

    "Created: / 01-08-2006 / 13:48:58 / fm"
    "Modified: / 16-04-2007 / 12:03:41 / cg"
!

userFriendlyName
    ^self remotePrinterName isEmpty
	ifTrue:[self printerName]
	ifFalse:[self remotePrinterName, ' on ', self remotePrinterHost]

    "Created: / 03-08-2006 / 12:50:09 / fm"
! !

!AbstractOperatingSystem::PrinterInfo methodsFor:'dc creation'!

createDC
     |driverName pName|

     driverName := self driverName.
     pName := self printerName.
     "/ Transcript show:driverName; show:' '; showCR:printerName.

     ^OperatingSystem createPrinterDC:driverName
			device:pName
			output:self medium
			initData:self documentProperties.

    "Created: / 02-08-2006 / 16:51:02 / fm"
    "Modified: / 16-04-2007 / 13:56:56 / cg"
! !

!AbstractOperatingSystem::PrinterInfo methodsFor:'dialogs'!

openPropertiesDialog
    "Returns true if the documentProperties have been accepted. Otherwise, returns false"

    |h newDocumentProperties|

    h := OperatingSystem openPrinter: self printerName.
    newDocumentProperties := OperatingSystem documentPropertiesDialogFor:nil
	    hPrinter:h
	    pDeviceName: self printerName
	    devModeInput:self documentProperties.
    (newDocumentProperties contains:[:el | el ~= 0])
	ifFalse:[^false].
    self documentProperties: newDocumentProperties.
    OperatingSystem closePrinter:h.
    ^true

    "Created: / 28-07-2006 / 11:44:01 / fm"
    "Modified: / 01-08-2006 / 11:55:49 / fm"
    "Modified: / 13-09-2006 / 11:36:10 / cg"
! !

!AbstractOperatingSystem::PrinterInfo methodsFor:'modifying'!

setLandscapeOrientation
    "DMORIENT_LANDSCAPE = 2"
    self documentProperties orientation: 2

    "Created: / 28-07-2006 / 15:53:35 / fm"
    "Modified: / 16-04-2007 / 12:03:30 / cg"
!

setNumberOfCopies: n

    self documentProperties copies: n

    "Created: / 28-07-2006 / 16:04:04 / fm"
    "Modified: / 16-04-2007 / 12:03:33 / cg"
!

setPortraitOrientation
    "DMORIENT_PORTRAIT = 1"
    self documentProperties orientation: 1

    "Created: / 28-07-2006 / 15:49:45 / fm"
    "Modified: / 16-04-2007 / 12:03:36 / cg"
! !

!AbstractOperatingSystem::PrinterInfo methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:(self class name); nextPutAll:'('.
    printerName printOn:aStream.
    aStream nextPutAll:')'.

    "Created: / 27-07-2006 / 12:30:28 / fm"
! !

!AbstractOperatingSystem::PrinterInfo methodsFor:'private'!

getDocumentProperties
    "Returns a aDevModeStructure"

    |h devMode |

     h := OperatingSystem openPrinter: self printerName.
     devMode := OperatingSystem getDocumentProperties:nil
			    hPrinter:h
			    pDeviceName: self printerName.
     OperatingSystem closePrinter: h.
     ^devMode

    "Created: / 28-07-2006 / 11:49:33 / fm"
    "Modified: / 31-07-2006 / 10:33:04 / fm"
    "Modified: / 16-04-2007 / 12:02:00 / cg"
!

getPrinterInfo2
    "Returns a aPrinterInfo2 structure"

    printerInfo2 := OperatingSystem getPrinterInfo2:self printerName.
    ^ printerInfo2

    "Created: / 01-08-2006 / 13:50:55 / fm"
    "Modified: / 01-08-2006 / 15:11:03 / fm"
    "Modified: / 18-10-2006 / 12:03:54 / User"
!

printerInfo2
    "Returns a aPrinterInfo2 structure"

    printerInfo2 isNil ifTrue:[
	self getPrinterInfo2.
    ].
    ^ printerInfo2

    "Created: / 01-08-2006 / 15:10:18 / fm"
    "Modified: / 18-10-2006 / 12:03:57 / User"
!

setDocumentProperties
    "Sets a aDevModeStructure or nil if the printer is not available"

   self documentProperties: self getDocumentProperties

    "Created: / 31-07-2006 / 13:04:58 / fm"
! !

!AbstractOperatingSystem::PrinterInfo methodsFor:'queries'!

isAvailable

    ^self documentProperties notNil

    "Created: / 31-07-2006 / 13:08:58 / fm"
    "Modified: / 16-04-2007 / 12:02:05 / cg"
! !

!AbstractOperatingSystem::TimeInfo methodsFor:'accessing'!

at:index
    "backward compatibility"

    <resource: #obsolete>
    self obsoleteMethodWarning:'use accessor for index ', index printString.

    index == 1 ifTrue:[
	^ self year.
    ].
    index == 2 ifTrue:[
	^ self month.
    ].
    index == 3 ifTrue:[
	^ self day.
    ].
    index == 4 ifTrue:[
	^ self hours.
    ].
    index == 5 ifTrue:[
	^ self minutes.
    ].
    index == 6 ifTrue:[
	^ self seconds.
    ].
    index == 7 ifTrue:[
	^ self utcOffset.
    ].
    index == 8 ifTrue:[
	^ self dst.
    ].
    index == 9 ifTrue:[
	^ self milliseconds.
    ].
    index == 10 ifTrue:[
	^ self dayInYear.
    ].
    index == 11 ifTrue:[
	^ self dayInWeek.
    ].
    self subscriptBoundsError:index
!

day
    ^ day
!

dayInWeek
    <resource: #obsolete>
    ^ dayInWeek
!

dayInYear
    <resource: #obsolete>
    "answer of compute the day of the year - if necessary
     (it is not set in windows)"

    |dayCount|

    dayInYear notNil ifTrue:[
	^ dayInYear.
    ].

    dayCount := #(0 31 59 90 120 151 181 212 243 273 304 334) at:month.
    (month > 2
     and:[(year \\ 4 == 0)
     and:[(year \\ 100 ~~ 0)
     and:[(year \\ 400 == 0)]]]) ifTrue:[
	"leap year and month after February"
	dayCount := dayCount + 1.
    ].

    ^ dayCount + day.


    "
      |daysSoFar|

      daysSoFar := 0.
      #(0 31 28 31 30 31 30 31 31 30 31 30) collect:[:daysInMonth| daysSoFar := daysSoFar + daysInMonth. daysSoFar]
    "
!

dst
    ^ dst
!

hours
    ^ hours
!

milliseconds
    ^ milliseconds
!

milliseconds:something
    milliseconds := something.
!

minutes
    ^ minutes
!

month
    ^ month
!

seconds
    ^ seconds
!

utcOffset
    "return the difference between UTC (Greenwich Mean Time) and the local time in seconds.
     If daylight saving time applies to ourself, take that into account.
     Add utcOffset to convert from local time to UTC time.
     Subtract utcOffset to convert from UTC time to local time.

     If utcOffset is negative, the local timezone is east of Greenwich.
     If utcOffset is positive, the local timezone is west of Greenwich."

    ^ utcOffset

    "
     (OperatingSystem timeInfoFromSeconds:Timestamp now utcSecondsSince1970 milliseconds:0 localTime:true)
	utcOffset
    "
!

utcOffset:something
    utcOffset := something.
!

year
    ^ year
!

year:yearArg month:monthArg day:dayArg hours:hoursArg minutes:minutesArg seconds:secondsArg milliseconds:millisecondsArg utcOffset:utcOffsetArg dst:dstArg dayInYear:dayInYearArg dayInWeek:dayInWeekArg
    "set instance variables (automatically generated)"

    year := yearArg.
    month := monthArg.
    day := dayArg.
    hours := hoursArg.
    minutes := minutesArg.
    seconds := secondsArg.
    milliseconds := millisecondsArg.
    utcOffset := utcOffsetArg.
    dst := dstArg.
    dayInYear := dayInYearArg.
    dayInWeek := dayInWeekArg.
!

year:yearArg month:monthArg day:dayArg hours:hoursArg minutes:minutesArg seconds:secondsArg utcOffset:utcOffsetArg dst:dstArg dayInYear:dayInYearArg dayInWeek:dayInWeekArg
    "set instance variables (automatically generated)"

    year := yearArg.
    month := monthArg.
    day := dayArg.
    hours := hoursArg.
    minutes := minutesArg.
    seconds := secondsArg.
    utcOffset := utcOffsetArg.
    dst := dstArg.
    dayInYear := dayInYearArg.
    dayInWeek := dayInWeekArg.
! !

!AbstractOperatingSystem::TimeInfo methodsFor:'converting'!

asDate
    ^ Date new year:year month:month day:day.
!

asTime
    ^ Time hours:hours minutes:minutes seconds:seconds
! !

!AbstractOperatingSystem::TimeZoneInfo class methodsFor:'documentation'!

documentation
"
Bias
    The current bias for local time translation on this computer, in minutes.
    The bias is the difference, in minutes, between Coordinated Universal Time (UTC)
    and local time.
    All translations between UTC and local time are based on the following formula:

	UTC = local time + bias

StandardName
    A description for standard time. For example, 'EST' could indicate Eastern Standard Time.
    The string will be returned unchanged by the GetTimeZoneInformation function.
    This string can be empty.
    This is for information only - do not depend on the value of the string.

StandardDate
    A Timestamp that contains a date and local time when the transition from daylight saving
    time to standard time occurs on this operating system.
    If the time zone does not support daylight saving time or if the caller needs to disable
    daylight saving time, the standardDate is nil.
    If this date is specified, the DaylightDate member of this structure must also be specified.
    Otherwise, the system assumes the time zone data is invalid and no changes will be applied.

    To select the correct day in the month, set the wYear member to zero, the wHour and wMinute members
    to the transition time, the wDayOfWeek member to the appropriate weekday, and the wDay member to indicate
    the occurrence of the day of the week within the month (1 to 5, where 5 indicates the final occurrence
    during the month if that day of the week does not occur 5 times).

    Using this notation, specify 02:00 on the first Sunday in April as follows:
	wHour = 2, wMonth = 4, wDayOfWeek = 0, wDay = 1.
    Specify 02:00 on the last Thursday in October as follows:
	wHour = 2, wMonth = 10, wDayOfWeek = 4, wDay = 5.

    If the wYear member is not zero, the transition date is absolute; it will only occur one time.
    Otherwise, it is a relative date that occurs yearly.

StandardBias
    The bias value to be used during local time translations that occur during standard time.
    This member is ignored if a value for the StandardDate member is not supplied.

    This value is added to the value of the Bias member to form the bias used during standard time.
    In most time zones, the value of this member is zero.

DaylightName
    A description for daylight saving time. For example, 'PDT' could indicate Pacific Daylight Time.
    The string will be returned unchanged by the GetTimeZoneInformation function. This string can be empty.
    This is for information only - do not depend on the value of the string.

DaylightDate
    A Timestamp structure that contains a date and local time when the transition from standard time
    to daylight saving time occurs on this operating system.
    If the time zone does not support daylight saving time or if the caller needs to disable daylight
    saving time, this entry is nil.
    If this date is specified, the StandardDate member in this structure must also be specified.
    Otherwise, the system assumes the time zone data is invalid and no changes will be applied.

    To select the correct day in the month, set the wYear member to zero, the wHour and wMinute members to
    the transition time, the wDayOfWeek member to the appropriate weekday, and the wDay member to indicate
    the occurrence of the day of the week within the month (1 to 5, where 5 indicates the final occurrence
    during the month if that day of the week does not occur 5 times).

    If the wYear member is not zero, the transition date is absolute; it will only occur one time.
    Otherwise, it is a relative date that occurs yearly.

DaylightBias
    The bias value to be used during local time translations that occur during daylight saving time.
    This member is ignored if a value for the DaylightDate member is not supplied.

    This value is added to the value of the Bias member to form the bias used during daylight saving time.
    In most time zones, the value of this member is -60
"
! !

!AbstractOperatingSystem::TimeZoneInfo methodsFor:'accessing'!

bias
    ^ bias
!

bias:something
    bias := something.
!

bias:biasArg name:nameArg standardBias:standardBiasArg daylightName:daylightNameArg daylightBias:daylightBiasArg
    bias := biasArg.
    name := nameArg.
    standardBias := standardBiasArg.
    daylightName := daylightNameArg.
    daylightBias := daylightBiasArg.
!

bias:biasArg name:nameArg standardDate:standardDateArg standardBias:standardBiasArg daylightName:daylightNameArg daylightDate:daylightDateArg daylightBias:daylightBiasArg
    bias := biasArg.
    name := nameArg.
    standardDate := standardDateArg.
    standardBias := standardBiasArg.
    daylightName := daylightNameArg.
    daylightDate := daylightDateArg.
    daylightBias := daylightBiasArg.
!

daylightBias
    ^ daylightBias
!

daylightBias:something
    daylightBias := something.
!

daylightDay
    ^ daylightDay
!

daylightDay:something
    daylightDay := something.
!

daylightHour
    ^ daylightHour
!

daylightHour:something
    daylightHour := something.
!

daylightMinute
    ^ daylightMinute
!

daylightMinute:something
    daylightMinute := something.
!

daylightMonth
    ^ daylightMonth
!

daylightMonth:something
    daylightMonth := something.
!

daylightName
    ^ daylightName
!

daylightName:something
    daylightName := something.
!

daylightWeekDay
    ^ daylightWeekDay
!

daylightWeekDay:something
    daylightWeekDay := something.
!

daylightYear
    ^ daylightYear
!

daylightYear:something
    daylightYear := something.
!

daylightYear:daylightYearArg daylightMonth:daylightMonthArg daylightDay:daylightDayArg daylightWeekDay:daylightWeekDayArg daylightHour:daylightHourArg daylightMinute:daylightMinuteArg
    daylightYear := daylightYearArg.
    daylightMonth := daylightMonthArg.
    daylightDay := daylightDayArg.
    daylightWeekDay := daylightWeekDayArg.
    daylightHour := daylightHourArg.
    daylightMinute := daylightMinuteArg.
!

name
    ^ name
!

name:something
    name := something.
!

standardBias
    ^ standardBias
!

standardBias:something
    standardBias := something.
!

standardDay
    ^ standardDay
!

standardDay:something
    standardDay := something.
!

standardHour
    ^ standardHour
!

standardHour:something
    standardHour := something.
!

standardMinute
    ^ standardMinute
!

standardMinute:something
    standardMinute := something.
!

standardMonth
    ^ standardMonth
!

standardMonth:something
    standardMonth := something.
!

standardWeekDay
    ^ standardWeekDay
!

standardWeekDay:something
    standardWeekDay := something.
!

standardYear
    ^ standardYear
!

standardYear:something
    standardYear := something.
!

standardYear:standardYearArg standardMonth:standardMonthArg standardDay:standardDayArg standardWeekDay:standardWeekDayArg standardHour:standardHourArg standardMinute:standardMinuteArg
    standardYear := standardYearArg.
    standardMonth := standardMonthArg.
    standardDay := standardDayArg.
    standardWeekDay := standardWeekDayArg.
    standardHour := standardHourArg.
    standardMinute := standardMinuteArg.
! !

!AbstractOperatingSystem class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


AbstractOperatingSystem initialize!
