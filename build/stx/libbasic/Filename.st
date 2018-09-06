"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1992 by Claus Gittinger
 COPYRIGHT (c) 2009 Jan Vrany
 COPYRIGHT (c) 2016 Jan Vrany
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

Object subclass:#Filename
	instanceVariableNames:'nameString'
	classVariableNames:'ConcreteClass DefaultTempDirectory TempDirectory'
	poolDictionaries:''
	category:'System-Support'
!

!Filename class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
 COPYRIGHT (c) 2009 Jan Vrany
 COPYRIGHT (c) 2016 Jan Vrany
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
    Filenames; originally added for ST-80 compatibility, is
    taking over functionality from other classes (FileDirectory).

    Instances of Filename do not nescessarily represent valid or existing
    files - i.e. it is possible (and useful) to have instances for non-existing
    files around. In other words: the name-string is not checked automatically
    for being correct or existing.
    Thus, it is possible to do queries such as:

        '/fee/foo/foe' asFilename exists
        '/not_existing' asFilename isDirectory
        '/foo/bar' asFilename isReadable

    (all of the above examples will probably return false on your machine ;-).

    examples:

        'Makefile' asFilename readStream

        'newFile' asFilename writeStream

        Filename newTemporary writeStream

    Beside lots of protocol to query for a files attributes, the class
    protocol offers methods for filename completion, to construct paths
    (in an OS-independent way) and to create temporary files.
    Especially the path-construction methods (i.e. #construct:) are highly
    recommended in order to avoid having OS details (like directory separators
    being slash or backslash) spreaded in your application.

    Since Filenames have different semantics under different operating systems,
    class methods are delegated to concrete implementations in various subclasses like
    UnixFilename, PCFilename, ...
    The delegation is implemented in a way, so that some methods of
    specific OS Filenames might be used, even if ST/X is currently running
    on a different OS (as long as the method does not depend on the OperatingSystem class).

    [author:]
        Claus Gittinger

    [see also:]
        String
        FileStream DirectoryStream PipeStream Socket
        OperatingSystem
        Date Time
"
!

examples
"
    does a file/directory exist ?:
									[exBegin]
	|f|

	f := 'foobar' asFilename.
	^ f exists
									[exEnd]


    is it a directory ?:
									[exBegin]
	|f|

	f := '/tmp' asFilename.
	^ f isDirectory.
									[exEnd]


    get the working directory:
									[exBegin]
	^ Filename defaultDirectory
									[exEnd]


    get a files full pathname
    (caring for relative names or symbolic links):
									[exBegin]
	|f|

	f := '..' asFilename.
	^ f pathName
									[exEnd]


    get a directories directory:
									[exBegin]
	|f|

	f := Filename defaultDirectory.
	^ f directory
									[exEnd]


    get a files directory:
									[exBegin]
	|f|

	f := './smalltalk' asFilename.
	^ f directory
									[exEnd]


    getting access & modification times:
									[exBegin]
	|f|

	f := '/tmp' asFilename.
	^ f dates
									[exEnd]

    access time only:
									[exBegin]
	|f|

	f := '/tmp' asFilename.
	^ f dates at:#accessed
									[exEnd]


    getting all information on a file/directory:
									[exBegin]
	|f|

	f := '/tmp' asFilename.
	^ f info
									[exEnd]


    getting a temporary file (unique name):
									[exBegin]
	|f|

	f := Filename newTemporary.
	^ f
									[exEnd]

    creating, writing, reading and removing a temporary file:
									[exBegin]
	|f writeStream readStream|

	f := Filename newTemporary.
	writeStream := f writeStream.
	writeStream nextPutAll:'hello world'.
	writeStream cr.
	writeStream close.

	'contents (as seen by unix''s cat command:' printNL.
	OperatingSystem executeCommand:('cat ' , f pathName).

	readStream := f readStream.
	Transcript showCR:'contents as seen by smalltalk:'.
	Transcript showCR:(readStream upToEnd).
	readStream close.

	f delete.
									[exEnd]


    getting a directories contents:
									[exBegin]
	|f files|

	f := Filename currentDirectory.
	files := f directoryContents.
	Transcript showCR:'the files are:'.
	Transcript showCR:(files printString).
									[exEnd]


    editing a file:
									[exBegin]
	|f|

	f := Filename newTemporary.
	(f writeStream) nextPutAll:'hello world'; close.

	f edit
									[exEnd]
"
! !

!Filename class methodsFor:'initialization'!

initialize
    "initialize for the OS we are running on"

    ConcreteClass isNil ifTrue:[
	self initializeConcreteClass
    ].

    "
     self initialize
    "

    "Created: 7.9.1997 / 23:32:55 / cg"
!

initializeConcreteClass
    "initialize for the OS we are running on"

    OperatingSystem isUNIXlike ifTrue:[
	ConcreteClass := UnixFilename
    ] ifFalse:[OperatingSystem isMSDOSlike ifTrue:[
	ConcreteClass := PCFilename
    ] ifFalse:[OperatingSystem isVMSlike ifTrue:[
	ConcreteClass := OpenVMSFilename
    ] ifFalse:[
	self error:'Filename: unknown OperatingSystem when initializing concrete Filename class'.
    ]]].

    ConcreteClass isNil ifTrue:[
	self error:'Filename: Missing concrete Filename class'.
    ].

    "
     self initializeConcreteClass
    "

    "Modified: 7.9.1997 / 23:32:37 / cg"
!

reinitialize
    "initialize for the OS we are running on (after a restart)"

    TempDirectory := nil.
    self initializeConcreteClass.

    "
     self reinitialize
    "

    "Created: / 07-09-1997 / 23:33:02 / cg"
    "Modified: / 29-08-2006 / 12:40:28 / cg"
! !

!Filename class methodsFor:'instance creation'!

applicationDataDirectory
    "return the directory, where user-and-application-specific private files are to be
     located (ini-files, preferences etc.).
     Under windows, something like 'C:\Users\Administrator\AppData\Roaming\<appName>'
     is returned, under unix, we use ~/.<appName> (but see details in UnixOS).
     For smalltalk itself (the IDE), 'smalltalk' is used as appName.
     If the directory does not exist, it is created"

    |exeName|

    Smalltalk isStandAloneApp ifTrue:[
	exeName := OperatingSystem nameOfSTXExecutable.
    ] ifFalse:[
	exeName := 'smalltalk'
    ].
    ^ self applicationDataDirectoryFor:exeName

    "
     Filename applicationDataDirectory
    "
!

applicationDataDirectoryFor:appName
    "return the directory, where user-and-application-specific private files are to be
     located (ini-files, preferences etc.).
     Under windows, something like 'C:\Users\Administrator\AppData\Roaming\<appName>'
     is returned, under unix, we use ~/.<appName> (but see details in UnixOS).
     If the directory does not exist, it is created"

    |s dir|

    s := OperatingSystem getApplicationDataDirectoryFor:appName.
    s isNil ifTrue:[
	^ self homeDirectory
    ].
    dir := self named:s.
    dir exists ifFalse:[
	dir makeDirectory
    ].
    ^ dir

    "
     Filename applicationDataDirectoryFor:'smalltalk'
     Filename applicationDataDirectoryFor:'expecco'
      applicationDataDirectoryFor:'expecco'
    "

    "Created: / 29-07-2010 / 12:05:35 / sr"
!

currentDirectory
    "return a filename for the current directory"

    ^ self named:(OperatingSystem getCurrentDirectory).

    "
     Filename currentDirectory
    "
!

defaultDirectory
    "ST80 compatibility: same as currentDirectory"

    ^ self currentDirectory

    "
     Filename defaultDirectory
    "
!

defaultTempDirectory
    "return the default temp directory as a filename.
     That is the same as TempDirectory, except that TempDirectory can be changed
     from the outside (via tempDirectory:) whereas this is the OS's original default.
     Use this for files which MUST remain the same (stx_sourceCache)"

    DefaultTempDirectory isNil ifTrue:[
	self tempDirectory.  "/ actually sets DefaultTempDirectory as side effect
	DefaultTempDirectory isNil ifTrue:[
	    DefaultTempDirectory := TempDirectory
	].
    ].

    DefaultTempDirectory exists ifFalse:[
	DefaultTempDirectory
	    makeDirectory;
	    addAccessRights:#(readUser readGroup readOthers
			      writeUser writeGroup writeOthers
			      executeUser executeGroup executeOthers
			      removeOnlyByOwner).
    ].
    ^ DefaultTempDirectory

    "
     Filename tempDirectory
     Filename defaultTempDirectory
    "

    "Created: / 07-03-1996 / 14:51:18 / cg"
    "Modified: / 29-08-2006 / 12:57:16 / cg"
!

desktopDirectory
    "return your desktop directory.
     Under windows, that's the real desktop directory;
     under other OperatingSystems, the home directory is returned."

    |s|

    s := OperatingSystem getDesktopDirectory.
    s isNil ifTrue:[
        ^ self homeDirectory
    ].
    ^ self named:s

    "
     Filename desktopDirectory
    "

    "Created: / 16-05-2007 / 13:18:34 / cg"
!

documentsDirectory
    "return your documents directory.
     Under windows, that's the real 'Documents' or 'My Documents';
     under other OperatingSystems, the home directory is returned."

    |s|

    s := OperatingSystem getDocumentsDirectory.
    s isNil ifTrue:[
        ^ self homeDirectory
    ].
    ^ self named:s

    "
     Filename documentsDirectory
    "

    "Created: / 16-05-2007 / 13:18:34 / cg"
!

findDefaultDirectory
    "same as #defaultDirectory for ST80 compatibility"

    ^ self defaultDirectory

    "Created: 20.6.1997 / 17:00:29 / cg"
!

fromComponents:aCollectionOfDirectoryNames
    "create & return a new filename from components given in
     aCollectionOfDirectoryNames. If the first component is the name of the
     root directory (i.e. '/') an absolute path-filename is returned."

    self isAbstract ifTrue:[
	^ ConcreteClass fromComponents:aCollectionOfDirectoryNames
    ].

    ^ self named:(self nameFromComponents:aCollectionOfDirectoryNames)

    "
     Filename fromComponents:#('/' 'foo' 'bar' 'baz')
     PCFilename fromComponents:#('/' 'foo' 'bar' 'baz')
     UnixFilename fromComponents:#('/' 'foo' 'bar' 'baz')
     OpenVMSFilename fromComponents:#('foo' 'bar' 'baz')

     Filename fromComponents:#('foo' 'bar' 'baz')
     Filename fromComponents:#('/')

     Filename fromComponents:
	 (Filename components:('.' asFilename pathName))

     Filename fromComponents:
	 (Filename components:('.' asFilename name))
    "

    "Modified: 8.9.1997 / 00:23:16 / cg"
!

fromUser
    "show a box to enter a filename.
     Return a filename instance or nil (if cancel was pressed)."

    |name|

    name := Dialog
	requestFileName:'filename:'
	default:nil
	fromDirectory:(FileSelectionBox lastFileSelectionDirectory).

    name notEmptyOrNil ifTrue:[
	^ self named:name
    ].
    ^ nil

    "
     Filename fromUser
    "

    "Modified: 19.4.1996 / 13:57:44 / cg"
!

homeDirectory
    "return your homeDirectory.
     Some OperatingSystems do not support this - on those, the defaultDirectory
     (which is the currentDirectory) is returned.
     Notice: services under windows also do not have a home directory."

    |s|

    s := OperatingSystem getHomeDirectory.
    s isNil ifTrue:[
	^ self defaultDirectory
    ].
    ^ self named:s

    "
     Filename homeDirectory
    "

    "Modified: 8.9.1997 / 00:25:23 / cg"
!

named:aString
    "return a filename for a directory named aString.
     This is the same as 'aString asFilename'."

    self isAbstract ifTrue:[
	^ ConcreteClass named:aString
    ].
    ^ self basicNew setName:aString

    "
     Filename named:'/tmp/fooBar'
    "

    "Modified: 7.9.1997 / 23:30:06 / cg"
!

newTemporary
    "return a new unique filename - use this for temporary files.
     The filenames returned are '/tmp/stxtmp_xx_nn' where xx is our
     unix process id, and nn is a unique number, incremented with every
     call to this method.
     If any of the environment variables ST_TMPDIR or TMPDIR is set,
     its value defines the temp directory.
     Notice, that no file is created by this - only a unique name
     is generated.

     DO NOT USE THIS FOR PLAIN FILES - IT IS UNSECURE use FileStream>>#newTemporary
     (the insecurity is due to a small chance for some other program to open/create
      the file, as only a name is generated here. However, chances are small as the name
      is reasonably random - but for security relevant applications, this may be relevant)
    "

    ^ self newTemporaryIn:(self tempDirectory)

    "
     Filename newTemporary
     Filename newTemporary
    "

    "Modified: 7.9.1995 / 10:48:31 / claus"
    "Modified: 7.3.1996 / 14:51:33 / cg"
!

newTemporaryDirectory
    "return a new unique temporary directory - use this for temporary files.
     The directories returned are '/tmp/stxtmp_xx_nn' where xx is our
     unix process id, and nn is a unique number, incremented with every
     call to this method.
     If any of the environment variables ST_TMPDIR or TMPDIR is set,
     its value defines the temp directory."

    ^ self newTemporaryDirectoryIn:(self tempDirectory)
!

newTemporaryDirectoryIn:aDirectoryOrNil
    "return a new unique temporary directory in another directory, or the current dir.
     Use this for temporary files.
     The directories returned are '/tmp/stxtmp_xx_nn' where xx is our
     unix process id, and nn is a unique number, incremented with every
     call to this method.
     If any of the environment variables ST_TMPDIR or TMPDIR is set,
     its value defines the temp directory."

    |tempdir|

    tempdir := self newTemporaryIn:aDirectoryOrNil.
    tempdir exists ifTrue:[
	tempdir recursiveRemove.
    ].
    tempdir makeDirectory.
    ^ tempdir
!

newTemporaryIn:aDirectoryOrNil
    "return a new unique filename - use this for temporary files.
     The filenames returned are in aDirectoryPrefix and named 'stxtmp_xx_nn',
     where xx is our unix process id, and nn is a unique number, incremented
     with every call to this method.
     Notice: only a unique filename object is created and returned - no physical
     file is created by this method (i.e. you have to send #writeStream or
     whatever to it in order to really create something).
     See also: #newTemporary which looks for a good temp directory.

     DO NOT USE THIS FOR PLAIN FILES - IT IS UNSECURE use FileStream>>#newTemporaryIn:"

    ^ self newTemporaryIn:aDirectoryOrNil nameTemplate:(self tempFileNameTemplate)

    "temp files in '/tmp':

     Filename newTemporary
     Filename newTemporaryIn:(Filename tempDirectory)
    "

    "temp files somewhere
     (not recommended - use above since it can be controlled via shell variables):

     UnixFilename newTemporaryIn:'/tmp'
     UnixFilename newTemporaryIn:'/tmp'
     UnixFilename newTemporaryIn:'/usr/tmp'
     UnixFilename newTemporaryIn:'/'
    "

    "a local temp file:

     Filename newTemporaryIn:''
     Filename newTemporaryIn:nil
     Filename newTemporaryIn:'.'
     Filename newTemporaryIn:('source' asFilename)
    "

    "Modified: / 7.9.1995 / 10:48:31 / claus"
    "Modified: / 11.8.1998 / 22:51:43 / cg"
!

newTemporaryIn:aDirectoryOrNil nameTemplate:template
    "return a new unique filename - use this for temporary files.
     The filenames returned are in aDirectoryOrNil and named after the given template,
     in which %1 and %2 are expanded to the unix process id, and a unique number, incremented
     with every call to this method respectively.
     If the template does not contain %-meta characters, and the file already exists,
     a sequence of _1, _2,... is appended to the name. This is dangerous, as it does not prevent race
     conditions (if two such files are created at the same time).
     
     Notice: only a unique filename object is created and returned - no physical
     file is created by this method (i.e. you have to send #writeStream or
     whatever to it in order to really create something).
     See also: #newTemporary which looks for a good temp directory.

     DO NOT USE THIS FOR PLAIN FILES - IT IS UNSECURE use FileStream>>#newTemporaryIn:nameTemplate:"

    |newTempFilename oldNameString nextSeqNr|

    self isAbstract ifTrue:[
        ^ ConcreteClass newTemporaryIn:aDirectoryOrNil nameTemplate:template
    ].

    "although the above allows things to be redefined in concrete classes,
     the following should work on all systems ..."

    [
        |nameString fn|
        
        "Use random numbers in order to improve the security
         by making the generated names less predictable"
        nameString := template bindWith:(OperatingSystem getProcessId) with:(RandomGenerator nextLettersOrDigits:4).
        (oldNameString = nameString) ifTrue:[
            "/ ouch - the given template seems to not generate unique file names.
            "/ append a sequence number
            nextSeqNr := (nextSeqNr ? 0) + 1.
            fn := nameString asFilename.
            nameString := fn withoutSuffix name,'_',nextSeqNr asString,'.' , fn suffix.
        ].    

        aDirectoryOrNil isNil ifTrue:[
            newTempFilename := self named:nameString
        ] ifFalse:[
            newTempFilename := aDirectoryOrNil asFilename construct:nameString
        ].
        oldNameString := nameString.
    ] doWhile:[
        "care for existing leftOver tempFiles
         from a previous boot of the OS
         i.e. my pid could be the same as when executed
         the last time before system reboot ...)"

        newTempFilename exists
    ].
    ^ newTempFilename

    "temp files in '/tmp':

     Filename newTemporary
     Filename newTemporaryIn:nil nameTemplate:'out_%1_%2.txt'
     Filename newTemporaryIn:(Filename tempDirectory) nameTemplate:'out_%1_%2.txt'
    "

    "temp files somewhere
     (not recommended - use above since it can be controlled via shell variables):

     UnixFilename newTemporaryIn:'/tmp'     nameTemplate:'foo%1_%2'
     UnixFilename newTemporaryIn:'/tmp'     nameTemplate:'foo%1_%2'
     UnixFilename newTemporaryIn:'/usr/tmp' nameTemplate:'foo%1_%2'
     UnixFilename newTemporaryIn:'/'        nameTemplate:'foo%1_%2'
    "

    "a local temp file:

     Filename newTemporaryIn:''             nameTemplate:'foo%1_%2'
     Filename newTemporaryIn:nil            nameTemplate:'foo%1_%2'
     Filename newTemporaryIn:'.'            nameTemplate:'foo%1_%2'
     Filename newTemporaryIn:('source' asFilename) nameTemplate:'foo%1_%2'
    "

    "Modified: / 07-09-1995 / 10:48:31 / claus"
    "Modified: / 07-05-2010 / 11:46:05 / cg"
!

nullDevice
    "return the filename of the nullDevice (if available).
     returns nil, if the OperatingSystem does not support this."

    |s|

    s := self nullFilename.
    s isNil ifTrue:[
	^ nil
    ].
    ^ self named:s

    "
     Filename nullDevice
     UnixFilename nullDevice
     PCFilename nullDevice
    "

    "Created: / 19.5.1999 / 12:24:26 / cg"
!

remoteHost:remoteHostString rootComponents:aCollectionOfDirectoryNames
    "create & return a new filename from components given in
     aCollectionOfDirectoryNames on a host named remoteHostString.
     An absolute network-filename is returned."

    self isAbstract ifTrue:[
	^ ConcreteClass remoteHost:remoteHostString
			rootComponents:aCollectionOfDirectoryNames
    ].

    remoteHostString notEmptyOrNil ifTrue:[
	self error:'remote hosts are not supported by OS'
    ].

    ^ self rootComponents:aCollectionOfDirectoryNames

    "
      'file:///tmp/test' asURI asFilename
    "
!

rootComponents:aCollectionOfDirectoryNames
    "create & return a new filename from components given in
     aCollectionOfDirectoryNames.
     An absolute path-filename is returned."

    |sep s|

    self isAbstract ifTrue:[
	^ ConcreteClass rootComponents:aCollectionOfDirectoryNames
    ].

    "/ fallBack - works on Unix & MSDOS

    sep := self separatorString.
    s := CharacterWriteStream new.
    aCollectionOfDirectoryNames do:[:component |
	component ~= sep ifTrue:[
	    s nextPutAll:sep; nextPutAll:component
	]
    ].
    s := s contents.
    s size == 0 ifTrue:[s := sep].
    ^ self named:s

    "
     Filename rootComponents:#('/' 'foo' 'bar' 'baz')

     Filename rootComponents:#('foo' 'bar' 'baz')
     PCFilename rootComponents:#('foo' 'bar' 'baz')
     UnixFilename rootComponents:#('foo' 'bar' 'baz')

     Filename rootComponents:#('/')

     Filename rootComponents:
	 (Filename components:('.' asFilename pathName))

     Filename rootComponents:
	 (Filename components:('.' asFilename name))
    "

    "Modified: 8.9.1997 / 00:23:16 / cg"
!

rootDirectory
    "return a filename for the root directory"

    self isAbstract ifTrue:[
	^ ConcreteClass rootDirectory
    ].

    "/ fallBack - works on Unix & MSDOS (but not on VMS)

    ^ self named:(self separatorString)

    "
     Filename rootDirectory
    "

    "Modified: 8.9.1997 / 00:24:15 / cg"
!

rootDirectoryOnVolume:aVolumeName
    "return a filename for the root directory on some volume"

    self isAbstract ifTrue:[
	^ ConcreteClass rootDirectoryOnVolume:aVolumeName
    ].

    "/ fallBack - works on Unix (not on MSDOS or VMS)

    ^ self rootDirectory

    "
     Filename rootDirectoryOnVolume:'/phys/idefix'
     Filename rootDirectoryOnVolume:'d:'
    "

    "Modified: / 5.10.1998 / 12:45:39 / cg"
!

tempDirectory
    "return the temp directory as a filename.
     If any of the environment variables STX_TMPDIR, ST_TMPDIR,
     TMPDIR or TEMPDIR is set, its value defines the name,
     otherwise, '/tmp' is used. (at least on unix ...).

     Notice: do not hardcode '/tmp' into your programs - things may be
             different on other operating systems. Also, the user may want to set the
             TMPDIR environment variable to have her temp files somewhere else."

    |tempDir|

    TempDirectory isNil ifTrue:[
        tempDir := self named:(self defaultTempDirectoryName pathName).
        tempDir exists ifFalse:[
            tempDir
                makeDirectory;
                addAccessRights:#(readUser readGroup readOthers
                                  writeUser writeGroup writeOthers
                                  executeUser executeGroup executeOthers
                                  removeOnlyByOwner).
        ].
        TempDirectory := DefaultTempDirectory := tempDir construct:('stx_tmp_' , OperatingSystem getLoginName)
    ].

    "Make sure, that the TempDirectory exists - it might have been removed
     by a cleanup (cron) job.
     Since it is shared between users, it must be accessible by all users."

    TempDirectory exists ifFalse:[
        TempDirectory
            makeDirectory;
            addAccessRights:#(readUser readGroup readOthers
                              writeUser writeGroup writeOthers
                              executeUser executeGroup executeOthers
                              removeOnlyByOwner).
    ].
    ^ TempDirectory

    "
     Filename tempDirectory
     Filename tempDirectory pathName
     Filename tempDirectory exists
     Filename tempDirectory isWritable
     (Filename tempDirectory construct:'foo') makeDirectory
     (Filename tempDirectory construct:'foo') remove
    "

    "Created: / 07-03-1996 / 14:51:18 / cg"
    "Modified: / 07-10-2011 / 18:39:25 / cg"
    "Modified: / 27-10-2016 / 23:06:51 / jv"
!

tempDirectory:aFilename
    "set the default temporary directory.
     This allows overwriting the automatically determined tmpDirectory
     by a knowledgable stand alone startup program.
     Do not use elsewhere (and only if absolutely required)"

    |temp|

    aFilename isNil ifTrue:[
	TempDirectory := nil.
	^ self.
    ].

    temp := aFilename asFilename.
    self assert:temp isDirectory.
    TempDirectory := temp.
!

trashDirectoryOrNil
    "if the underlying OS uses/supports a trash folder,
     return it. Otherwise return nil.
     Asks the OS for the pathname; for example, on OSX, '~/.Trash' is returned."

    |s|

    s := OperatingSystem getTrashDirectory.
    s isNil ifTrue:[
	^ nil
    ].
    ^ self named:s

    "
     Filename desktopDirectory
    "

    "Created: / 16-05-2007 / 13:18:34 / cg"
!

usersPrivateSmalltalkDirectory
    ^ Filename homeDirectory / '.smalltalk'

    "
     Filename usersPrivateSmalltalkDirectory
    "
! !

!Filename class methodsFor:'defaults'!

concreteClass
    "different subclasses of Filename are used for different
     OperatingSystems; concreteClass is supposed to return an appropriate class."

    ^ ConcreteClass ? self

    "Created: 14.2.1997 / 16:36:13 / cg"
    "Modified: 7.9.1997 / 23:29:20 / cg"
!

defaultClass
    "different subclasses of Filename are used for different
     OperatingSystems; defaultClass is supposed to return an appropriate class"

    ^ ConcreteClass

    "Modified: 8.9.1997 / 00:36:01 / cg"
!

defaultTempDirectoryName
    "return the default temp directory as a filename.
     This is used, if no special preferences were defined in
     any of the TEMP-environment variables (see tempDirectory)."

    self isAbstract ifTrue:[
	^ ConcreteClass defaultTempDirectoryName
    ].

    ^ '/tmp' asFilename

    "
     Filename defaultTempDirectoryName
    "

    "Modified: 7.9.1995 / 10:48:31 / claus"
    "Created: 7.3.1996 / 14:51:18 / cg"
    "Modified: 8.9.1997 / 00:24:53 / cg"
!

defaultVolumeName
    ^ '/'
! !

!Filename class methodsFor:'misc'!

filterSeps:aFilenameString
    "ST80 compatibility:
     filter out (invalid) separators in aFilenameString.
     We recommend using #makeLegalFilename"

    ^ aFilenameString copyReplaceAll:(Character space) with:$_ ifNone:aFilenameString.

    "Created: / 1.11.1997 / 12:39:50 / cg"
    "Modified: / 18.7.1998 / 22:53:24 / cg"
!

nameWithSpecialExpansions:aString
    "return the nameString, expanding any OS specific macros.
     Here, a ~/ or ~user/ prefix is expanded to the users home dir (as in csh)"

    |dir user cutIdx idx userInfo|

    (aString startsWith:$~) ifFalse:[
        ^ aString.
    ].

    aString size > 1 ifTrue:[
        idx := aString indexOf:self separator.
        idx == 0 ifTrue:[
            "aString is '~user'"
            user := aString copyFrom:2.
            cutIdx := aString size + 1.
        ] ifFalse:[
            "aString is '~user/something'"
            user := aString copyFrom:2 to:(idx - 1).
            cutIdx := idx.
        ].
        user notEmpty ifTrue:[
            userInfo := OperatingSystem userInfoOf:user.
            userInfo notNil ifTrue:[
                dir := userInfo at:#dir ifAbsent:nil.
            ].
            dir isNil ifTrue:[
"/                 ('Filename [info]: unknown user: ' , user) infoPrintCR.
                ^ aString
            ].
        ].
    ].
    dir isNil ifTrue:[
        "aString is '~' or '~/'"
        dir := OperatingSystem getHomeDirectory.
        cutIdx := 2.
    ].

    ^ dir , (aString copyFrom:cutIdx)

    "
     Filename nameWithSpecialExpansions:'~'
     Filename nameWithSpecialExpansions:'~\work'
     Filename nameWithSpecialExpansions:'~stefan'
     Filename nameWithSpecialExpansions:'~stefan\work'
     Filename nameWithSpecialExpansions:'~foo'
     Filename nameWithSpecialExpansions:'~foo\bar'
    "

    "
     UnixFilename nameWithSpecialExpansions:'~'
     UnixFilename nameWithSpecialExpansions:'~/work'
     UnixFilename nameWithSpecialExpansions:'~stefan'
     UnixFilename nameWithSpecialExpansions:'~stefan/work'
     UnixFilename nameWithSpecialExpansions:'~foo'
     UnixFilename nameWithSpecialExpansions:'~foo/bar'
    "

    "
     PCFilename nameWithSpecialExpansions:'~'
     PCFilename nameWithSpecialExpansions:'~\work'
     PCFilename nameWithSpecialExpansions:'~stefan'
     PCFilename nameWithSpecialExpansions:'~stefan\work'
     PCFilename nameWithSpecialExpansions:'~foo'
     PCFilename nameWithSpecialExpansions:'~foo\bar'
    "
!

possiblyQuotedPathname:aPath
    "return a filename path usable as command line argument,
     by quoting in double quotes if there are any embedded special characters.
     On Unix systems, special characters might also be prefixed by a backslash character."

    (aPath startsWith:$") ifFalse:[
        (aPath includes:Character space) ifTrue:[
            ^ '"',aPath,'"'
        ].
    ].
    ^ aPath


    "
     Filename possiblyQuotedPathname:'/tmp/bla'
     Filename possiblyQuotedPathname:'/tmp directory/bla'
     Filename possiblyQuotedPathname:'/tmp directory/bla file'
    "
!

suggest:aFilenameString
    "return a fileNamestring based on the argument,
     which is legal on the current platform."

    ^ self canonicalize:aFilenameString

    "Created: / 1.11.1997 / 12:42:39 / cg"
! !

!Filename class methodsFor:'queries'!

currentDirectoryName
    "return a filename for the current directory"

    self isAbstract ifTrue:[
	^ ConcreteClass currentDirectoryName
    ].

    "/ fallBack - works on Unix & MSDOS (but not on VMS)

    ^ '.'

    "
     Filename currentDirectoryName
    "

    "Modified: / 8.9.1997 / 00:24:15 / cg"
    "Created: / 21.10.1998 / 17:49:57 / cg"
!

defaultDirectoryName
    "ST80 compatibility: return the defaultDirectories name (as a string)"

    ^ self defaultDirectory name

    "
     Filename defaultDirectoryName
    "
!

directorySuffix
    "Return the OS dependent directory suffix string, or nil if there is none.
     The default is nil here, redefined for VMS"

    self isAbstract ifTrue:[
	^ ConcreteClass directorySuffix
    ].

    ^ nil
!

errorReporter
    "who knows the signals to report errors?"

    ^ FileStream

    "Created: 2.7.1996 / 12:30:25 / stefan"
!

filenameCompletionFor:aString directory:inDirectory directoriesOnly:directoriesOnly filesOnly:filesOnly ifMultiple:aBlock
    "perform filename completion on aString in some directory;
     return the longest matching filename prefix as a string.
     The boolean directoriesOnly and filesOnly control respectively,
     if only directories or only regular files are to be considered for completion.
     If multiple files match, the exception block aBlock is evaluated with a
     filename representing the directory (where the match was done) as argument.
     (this may be different from the inDirectory argument, if aString is absolute
      or starts with ../)"

    self isAbstract ifTrue:[
	^ ConcreteClass
	    filenameCompletionFor:aString
	    directory:inDirectory
	    directoriesOnly:directoriesOnly
	    filesOnly:filesOnly
	    ifMultiple:aBlock
    ].
    ^ self filenameCompletionFor:aString directory:inDirectory directoriesOnly:directoriesOnly filesOnly:filesOnly ifMultiple:aBlock forMultipleDo:nil
!

filenameCompletionFor:aString directory:inDirectory directoriesOnly:directoriesOnly filesOnly:filesOnly ifMultiple:aBlock forMultipleDo:aMultipleBlock
    "perform filename completion on aString in some directory;
     return the longest matching filename prefix as a string.
     The boolean directoriesOnly and filesOnly control respectively,
     if only directories or only regular files are to be considered for completion.
     If multiple files match, the exception block aBlock is evaluated with a
     filename representing the directory (where the match was done) as argument and the aMultipleBlock
     is evaluated with both the directory (where the match was done) and the matchSet
     (list of matched filenames)  as arguments.
     (this may be different from the inDirectory argument, if aString is absolute
      or starts with ../)"

    |s f matchSet nMatch name dir isAbsolute sep|

    aString size == 0 ifTrue:[
	aBlock value:(self named:'.').
	^ ''
    ].

    sep := self separator.

    "/ the following works on Unix & MSDOS (but not on openVMS)

    f := self named:aString.
    isAbsolute := f isAbsolute.
    matchSet := f filenameCompletionIn:inDirectory.  "/ BAD DESIGN: has side effect on f
    dir := f directory.

    matchSet := matchSet select:[:aFilename |
	|f isDir|

	isAbsolute ifTrue:[
	    f := aFilename asFilename
	] ifFalse:[
	    f := (dir construct:aFilename).
	].
	isDir := f isDirectory.
	directoriesOnly ifTrue:[
	    isDir
	] ifFalse:[
	    filesOnly ifTrue:[
		isDir not
	    ] ifFalse:[
		true
	    ]
	]
    ].

    f := f asCanonicalizedFilename.
	(nMatch := matchSet size) ~~ 1 ifTrue:[
	"
	 more than one possible completion -
	"
	aMultipleBlock notNil ifTrue:[
	    aMultipleBlock value:f value:matchSet.
	].
	aBlock value:f
    ].

    "
     even with more than one possible completion,
     f's name is now the common prefix
    "
    name := f asString.

    nMatch <= 1 ifTrue:[
	"
	 exactly one possible completion -
	"
"/        f := dir construct:matchSet first.
	false "directoriesOnly" ifFalse:[
	    (f exists and:[f isDirectory]) ifTrue:[
		(name endsWith:sep) ifFalse:[
		    name := name , sep asString
		].
	    ].
	]
    ].

    s := name.

    "/ special: if there was no change, and the string represented
    "/ is a directories name, add a directory separator
    ((nMatch == 1) or:[s = aString]) ifTrue:[
	(s endsWith:sep) ifFalse:[
	    (self named:s) isDirectory ifTrue:[
		^ s , sep asString
	    ]
	].
    ].

    ^ s

    "Modified: / 30.4.1999 / 09:40:13 / cg"
!

filesMatching:aPattern
    "return a collection of strings, representing the names
     of files matching aPattern.
     If aPattern contains a directory path, files are tried there;
     otherwise, files from the currentDirectory are tried.
     The returned strings are the expanded names, in the same form
     as given in pattern.
     The pattern should be a simple pattern."

    |basePattern dir d files|

    self isAbstract ifTrue:[
	^ ConcreteClass filesMatching:aPattern
    ].

    "/ the following works on Unix & MSDOS (but not on openVMS)

    dir := aPattern asFilename directoryName.
    basePattern := aPattern asFilename baseName.
    d := dir asFilename.
    files := dir asFilename filesMatchingWithoutDotDirs:basePattern.
    dir = '.' ifTrue:[^ files].
    ^ files collect:[:base | d constructString:base].

    "
     Filename filesMatching:'*'
     Filename filesMatching:'/*'
     Filename filesMatching:'/usr/local/*'
    "

    "Modified: 8.9.1997 / 00:32:31 / cg"
!

isAbstract
    "return true, if this is not a concrete class"

    ^ self == Filename
!

isBadCharacter:aCharacter
    "return true, if aCharacter is unallowed in a filename."

    self isAbstract  ifTrue:[
	^ ConcreteClass isBadCharacter:aCharacter
    ].

    ^ aCharacter isControlCharacter
!

isCaseSensitive
    "return true, if filenames are case sensitive.
     We ask the OS about this, to be independent here.
     This is not really correct, as the sensitivity may depend on
     the paricular mounted file system (NFS, for example).
     So we need a query on the instance side"

    self isAbstract ifTrue:[
        ^ ConcreteClass isCaseSensitive
    ].

    ^ OperatingSystem caseSensitiveFilenames

    "Modified: 8.9.1997 / 00:33:32 / cg"
!

localNameStringFrom:aString
    "ST-80 compatibility.
     what does this do ? (used in FileNavigator-goody).
     GUESS:
	does it strip off any volume characters and make a path relative ?"

    self isAbstract ifTrue:[
	^ ConcreteClass localNameStringFrom:aString
    ].

    ^ aString withoutPrefix:self separatorString

    "Modified: 7.9.1995 / 10:44:56 / claus"
    "Modified: 8.9.1997 / 00:33:51 / cg"
!

maxComponentLength
    "return the maximum number of characters a filename component may
     be in size. This depends on the OperatingSystem."

    self isAbstract ifTrue:[
	^ ConcreteClass maxComponentLength
    ].
    ^ OperatingSystem maxFileNameLength
!

maxLength
    "return the maximum number of characters a filename may be in size.
     This depends on the OperatingSystem."

    self isAbstract ifTrue:[
	^ ConcreteClass maxLength
    ].
    ^ OperatingSystem maxPathLength

    "Created: 29.2.1996 / 20:57:11 / cg"
    "Modified: 29.2.1996 / 20:57:46 / cg"
!

nullFilename
    "Return the OS dependent filename for /dev/null, or nil if there is none.
     The default is nil here"

    self isAbstract ifTrue:[
	^ ConcreteClass nullFilename
    ].

    ^ OperatingSystem getNullDevice

    "Created: / 12.1.1998 / 12:15:30 / stefan"
!

parentDirectoryName
    "return the name used for the parent directory.
     This is '..' for unix and dos-like systems.
     (there may be more in the future."

    self isAbstract ifTrue:[
	^ ConcreteClass parentDirectoryName
    ].

    ^ OperatingSystem parentDirectoryName

    "
     Filename parentDirectoryName
    "

    "Modified: 8.9.1997 / 00:34:39 / cg"
!

separator
    "return the file/directory separator.
     This is to be redefined in concrete classes."

   ^ ConcreteClass separator

    "
     Filename separator
     PCFilename separator
    "

    "Modified: 8.9.1997 / 00:20:28 / cg"
!

separatorString
    "return the file/directory separator as a string."

    ^ self separator asString

    "
     Filename separatorString
    "
!

suffixSeparator
    "return the filename suffix separator.
     Usually, this is $. for unix-like and msdos systems
     (there is currently no known system, where this differs)"

     ^ $.

     "
      Filename suffixSeparator
     "

    "Modified: 7.9.1995 / 11:10:43 / claus"
    "Modified: 30.4.1996 / 12:14:25 / cg"
!

tempFileNameTemplate
    "return a template for temporary files.
     This is expanded with the current processID and a sequenceNumber
     to generate a unique filename."

    self isAbstract ifTrue:[
	^ ConcreteClass tempFileNameTemplate
    ].

    ^ 'stxtmp_%1_%2'

    "Created: 8.9.1997 / 00:01:46 / cg"
    "Modified: 8.9.1997 / 00:35:02 / cg"
!

volumes
    "ST-80 compatibility.
     GUESS: does it return the available drives on MSDOS systems ?
     Q: what does this do on Unix systems ? (used in FileNavigator-goody)."

    self isAbstract ifTrue:[
	^ ConcreteClass volumes
    ].

    ^ OperatingSystem getDriveList

    "
     Filename volumes
    "
! !

!Filename class methodsFor:'utilities'!

canonicalize:aPathString
    "convert the argument, aPathString to a good format.
     This should eliminate useless directory components (i.e. '././')
     and useless tree walks (i.e. '../foo/..')."

    ^ self nameFromComponents:(self canonicalizedNameComponents:aPathString)

    "
     Filename canonicalize:'/etc/../etc'
     Filename canonicalize:'/home/cg/../'
     Filename canonicalize:'/home/cg/../././'
     Filename canonicalize:'./home/cg/../././'
     Filename canonicalize:'/home/././cg/../././'
     Filename canonicalize:'/home/././cg/././'
     Filename canonicalize:'/home/cg/../../..'
     Filename canonicalize:'cg/../../..'
     Filename canonicalize:'./'
     Filename canonicalize:'/home/.'
     Filename canonicalize:'/home/../..'
     Filename canonicalize:'//foo'
     Filename canonicalize:'///foo'
     Filename canonicalize:'//foo//bar'
    "
!

canonicalizedNameComponents:aPathString
    "convert the argument, aPathString to a good format.
     This should eliminate useless directory components (i.e. '././')
     and useless tree walks (i.e. '../foo/..').

     Answer a sequenceable collection of name components."

    |comps newComps rootName dotDot dot|

    dotDot := self parentDirectoryName.
    dot := self currentDirectoryName.
    rootName := self separatorString.

    comps := self components:aPathString.
    newComps := OrderedCollection new:comps size.
    comps do:[:eachComponent |
	eachComponent ~= dot ifTrue:[
	    eachComponent = dotDot ifTrue:[
	       (newComps isEmpty
		or:[(newComps size == 1 and:[newComps first startsWith:rootName])
		or:[newComps last = dotDot]]) ifTrue:[
		   newComps add:eachComponent
	       ] ifFalse:[
		   newComps removeLast
	       ].
	    ] ifFalse:[
		newComps add:eachComponent
	    ].
	]
    ].
    "/ add current Directory if empty
    newComps isEmpty ifTrue:[
	newComps add:dot.
    ].
    ^ newComps

    "
     Filename canonicalizedNameComponents:'/etc/../etc'
     Filename canonicalizedNameComponents:'/home/cg/../'
     Filename canonicalizedNameComponents:'/home/cg/../././'
     Filename canonicalizedNameComponents:'./home/cg/../././'
     Filename canonicalizedNameComponents:'/home/././cg/../././'
     Filename canonicalizedNameComponents:'/home/././cg/././'
     Filename canonicalizedNameComponents:'/home/cg/../../..'
     Filename canonicalizedNameComponents:'cg/../../..'
     Filename canonicalizedNameComponents:'/'
     Filename canonicalizedNameComponents:'./'
     Filename canonicalizedNameComponents:'/.'
     Filename canonicalizedNameComponents:'/home/.'
     Filename canonicalizedNameComponents:'/home'
     Filename canonicalizedNameComponents:'/home/../..'
     Filename canonicalizedNameComponents:'//foo'
     Filename canonicalizedNameComponents:'///foo'
     Filename canonicalizedNameComponents:'//foo//bar'
    "
!

components:aString
    "separate the pathName given by aString into
     a collection containing the directory components and the file's name as
     the final component.
     If the argument names an absolute path, the first component will be the
     name of the root directory (i.e. '/')."

    |sep f vol rest components|

    self isAbstract ifTrue:[
        ^ ConcreteClass components:aString
    ].

    "/ the following works on Unix & MSDOS (but not on openVMS)
    "/ However, MSDOS drive-letters and network drives are
    "/ not correctly handled here.

    sep := self separator.
    f := aString asFilename.
    vol := f volume.
    vol size ~~ 0 ifTrue:[
        rest := f localPathName.
    ] ifFalse:[
        rest := aString
    ].

    components := rest asCollectionOfSubstringsSeparatedBy:sep.
    (rest startsWith:sep) ifTrue:[
        "first was a separator - root directory - restore"
        (rest size > 1 and:[rest second = sep and:[vol isEmptyOrNil]]) ifTrue:[
            "keep \\ for windows network paths"
            components at:1 put:(String with:sep with:sep).
        ] ifFalse:[
            components at:1 put:sep asString.
        ].
    ].

    "/ prepend volume to first component (the root directory)
    vol size ~~ 0 ifTrue:[
        vol last = $: ifTrue:[
           vol := vol, (components at:1).
        ].
        components at:1 put:vol.
    ].
    components := components select:[:each| each notEmpty].

    ^ components

    "
     Unix:
     UnixFilename components:'/foo/bar/baz'
     UnixFilename components:'/'
     UnixFilename components:'//'
     UnixFilename components:'foo/bar/baz'
     UnixFilename components:'foo/bar'
     UnixFilename components:'foo'
     UnixFilename components:'/foo'
     UnixFilename components:'//foo'
     UnixFilename components:''

     Windows:
     PCFilename components:'\'
     PCFilename components:'\foo'
     PCFilename components:'\foo\'
     PCFilename components:'\foo\bar'
     PCFilename components:'\foo\bar\'
     PCFilename components:'c:'
     PCFilename components:'c:\'
     PCFilename components:'c:\foo'
     PCFilename components:'c:\foo\'
     PCFilename components:'c:\foo\bar'
     PCFilename components:'c:\foo\bar\'
     PCFilename components:'\\idefix'
     PCFilename components:'\\idefix\home'
     PCFilename components:'\\idefix\home\bar'
    "

    "Modified: / 24.9.1998 / 19:10:52 / cg"
!

filesMatchingGLOB:pattern
    "does a GLOB filename expansion.
     Generates and returns a possibly empty list of files which match
     the given glob pattern"

    ^ OrderedCollection withCollectedContents:[:coll |
        pattern asFilename filesMatchingGLOBDo:[:each | coll add:each]
      ]

    "
     Filename filesMatchingGLOB:'./A*'
     Filename filesMatchingGLOB:'/etc/A*'
     Filename filesMatchingGLOB:'/*/A*'
     '.' asFilename filesMatchingGLOB:'A*'
    "
!

nameFromComponents:aCollectionOfDirectoryNames
    "return a filenameString from components given in aCollectionOfDirectoryNames.
     If the first component is the name of the root directory (i.e. '/'),
     an absolute path-string is returned."

    |sep s|

    self isAbstract ifTrue:[
	^ ConcreteClass nameFromComponents:aCollectionOfDirectoryNames
    ].

    "/ fallBack - works on Unix & MSDOS

    sep := self separatorString.
    s := ''.
    aCollectionOfDirectoryNames keysAndValuesDo:[:index :component |
	index == 1 ifTrue:[
	    s := component.
	] ifFalse:[
	    (index == 2 and:[ (s endsWith:sep) ]) ifTrue:[
		s := s , component
	    ] ifFalse:[
		s := s , sep , component
	    ]
	].
    ].
    ^ s

    "
     Filename nameFromComponents:#('/' 'foo' 'bar' 'baz')
     Filename nameFromComponents:#('foo' 'bar' 'baz')
     Filename nameFromComponents:#('/')

     |comps|
     comps := Filename components:'/foo/bar/baz'.
     Filename nameFromComponents:comps

     |comps|
     comps := Filename components:'\foo\bar\baz'.
     Filename nameFromComponents:comps

     |comps|
     comps := Filename components:'c:\foo\bar\baz'.
     Filename nameFromComponents:comps

     |comps|
     comps := Filename components:'foo\bar\baz'.
     Filename nameFromComponents:comps

     |comps|
     comps := Filename components:'foo'.
     Filename nameFromComponents:comps

     |comps|
     comps := Filename components:'\'.
     Filename nameFromComponents:comps

     |comps|
     comps := Filename components:'c:\'.
     Filename nameFromComponents:comps
    "

    "Modified: 8.9.1997 / 00:23:16 / cg"
!

readingFile:aPathName do:aBlock
    "Create a read stream on a file, evaluate aBlock, passing that stream,
     and return the block's value.
     Ensures that the stream is closed."

    ^ aPathName asFilename readingFileDo:aBlock.

    "
     read the first line from some file:

     |rslt|

     rslt :=
        Filename
            readingFile:'/etc/passwd'
            do:[:s |
                s nextLine
            ].
     Transcript showCR:rslt.
    "

    "
     find all used shells in /etc/passwd and count their usage:

     |rslt|

     rslt :=
        Filename
            readingFile:'/etc/passwd'
            do:
                [:s |
                    |shells|

                    shells := Bag new.
                    s linesDo:
                        [:line |
                            |parts|

                            parts := line asCollectionOfSubstringsSeparatedBy:$:.
                            shells add:(parts seventh).
                        ].
                    shells contents
                ].
     Transcript showCR:rslt.
    "
! !

!Filename methodsFor:'Compatibility-VW5.4'!

asLogicalFileSpecification
    ^ self

    "Created: / 30.10.2001 / 17:31:10 / cg"
!

canBeWritten
    "same as isWritable - for ST-80 compatibility"

    ^ self isWritable

    "
     '/foo/bar' asFilename canBeWritten
     '/tmp' asFilename canBeWritten
     'Makefile' asFilename canBeWritten
    "
!

definitelyExists
    "for now - a kludge"

    ^ self exists
!

extension
    "return the receiver's extension;
     that is the characters from and including
     the last period or nil, if there is none."

    |string idx|

    string := self asString.
    idx := string lastIndexOf:$..
    idx > 1 ifTrue:[
	^ string copyFrom:idx
    ].
    ^ nil

    "
     'foo.html' asFilename extension
     'foo.bar' asFilename extension
     'foo.bar.baz' asFilename extension
     'foo.' asFilename extension
     'foo' asFilename extension
     '.login' asFilename extension
    "
! !

!Filename methodsFor:'comparing'!

< aFilename
    "compare file names - used for sorting"

    ^ self asString < aFilename asString
!

= aFilename
    "return true, if the argument represents the same filename"

    |str|

    self species == aFilename species ifTrue:[
	str := aFilename asString.
	self species isCaseSensitive ifTrue:[
	    ^ nameString = str
	].
	^ nameString sameAs:str
    ].
    ^ false
!

contentsIsPrefixOf:aFilename
    "return true if the contents of the file represented by the receiver
     is the same as or a prefix of the contents of the file represented by the argument, aFilename.
     This compares the files' actual contents; not the filenames."

    |f2 s1 s2 bufferSize buffer1 buffer2 n|

    bufferSize := 8192 * 4.

    f2 := aFilename asFilename.
    self fileSize > f2 fileSize ifTrue:[^ false].

    [
	s1 := self readStream.
	s2 := f2 readStream.
	s1 binary.
	s2 binary.

	buffer1 := ByteArray new:bufferSize.
	buffer2 := ByteArray new:bufferSize.

	[s1 atEnd] whileFalse:[
	    n := s1 nextBytes:bufferSize into:buffer1 startingAt:1.
	    n == 0 ifTrue:[
		"/ receiver shorter.
		^ true
	    ].
	    (s2 nextBytes:n into:buffer2 startingAt:1) ~~ n ifTrue:[
		"/ aFilename shorter
		^ false
	    ].
	    buffer1 ~= buffer2 ifTrue:[
		^ false
	    ]
	].
	"/ receiver shorter or same size.
    ] ensure:[
	s1 notNil ifTrue:[s1 close].
	s2 notNil ifTrue:[s2 close].
    ].
    ^ true

    "
     |s|

     s := 'testFile1' asFilename writeStream.
     s nextPutAll:'11111'.
     s nextPutAll:'22222'.
     s nextPutAll:'33333'.
     s close.

     s := 'testFile2' asFilename writeStream.
     s nextPutAll:'11111'.
     s nextPutAll:'22222'.
     s nextPutAll:'33333'.
     s close.

     ('testFile1' asFilename contentsIsPrefixOf:'testFile2'  ) ifFalse:[self halt].

     s := 'testFile2' asFilename writeStream.
     s nextPutAll:'11111'.
     s nextPutAll:'22222'.
     s nextPutAll:'33333'.
     s nextPutAll:'44444'.
     s close.

     ('testFile1' asFilename contentsIsPrefixOf:'testFile2'  ) ifFalse:[self halt].

     s := 'testFile2' asFilename writeStream.
     s nextPutAll:'11111'.
     s nextPutAll:'22222'.
     s close.

     ('testFile1' asFilename contentsIsPrefixOf:'testFile2'  ) ifTrue:[self halt].

     s := 'testFile2' asFilename writeStream.
     s nextPutAll:'11111'.
     s nextPutAll:'22222'.
     s nextPutAll:'33334'.
     s close.

     ('testFile1' asFilename contentsIsPrefixOf:'testFile2'  ) ifTrue:[self halt].

    "
!

contentsStartsWithContentsOf:aFilename
    "return true if the contents of the file represented by aFilename
     is the same as or a prefix of the contents of the file represented by the receiver.
     This compares the files' actual contents; not the filenames."

    ^ aFilename asFilename contentsIsPrefixOf:self

    "
     |s|

     s := 'testFile1' asFilename writeStream.
     s nextPutAll:'11111'.
     s nextPutAll:'22222'.
     s nextPutAll:'33333'.
     s close.

     s := 'testFile2' asFilename writeStream.
     s nextPutAll:'11111'.
     s nextPutAll:'22222'.
     s nextPutAll:'33333'.
     s close.

     ('testFile2' asFilename contentsStartsWithContentsOf:'testFile1'  ) ifFalse:[self halt].

     s := 'testFile2' asFilename writeStream.
     s nextPutAll:'11111'.
     s nextPutAll:'22222'.
     s nextPutAll:'33333'.
     s nextPutAll:'44444'.
     s close.

     ('testFile2' asFilename contentsStartsWithContentsOf:'testFile1'  ) ifFalse:[self halt].

     s := 'testFile2' asFilename writeStream.
     s nextPutAll:'11111'.
     s nextPutAll:'22222'.
     s close.

     ('testFile2' asFilename contentsStartsWithContentsOf:'testFile1'  ) ifTrue:[self halt].

     s := 'testFile2' asFilename writeStream.
     s nextPutAll:'11111'.
     s nextPutAll:'22222'.
     s nextPutAll:'33334'.
     s close.

     ('testFile2' asFilename contentsStartsWithContentsOf:'testFile1'  ) ifTrue:[self halt].

    "
!

hash
    "return an integer useful as a hash-key"

    self species isCaseSensitive ifFalse:[
	"/ asLowercase is slightly better:
	"/ it never converts single-byte strings to double one's,
	"/ whereas asUppercase might (for umlaut-y)
	^ nameString asUppercase hash
    ].
    ^ nameString hash
!

sameContentsAs:aFilename
    "return true if the file represented by the receiver has the
     same contents as the file represented by the argument, aFilename.
     This compares the file's actual contents; not the filenames."

    |f2|

    f2 := aFilename asFilename.
    f2 fileSize = self fileSize ifFalse:[^ false].
    ^ self contentsIsPrefixOf:f2.

    "
     'Make.proto' asFilename sameContentsAs:'Makefile'
     'Make.proto' asFilename sameContentsAs:'Make.proto'
    "

    "
     |s|

     s := 'testFile1' asFilename writeStream.
     s nextPutAll:'11111'.
     s nextPutAll:'22222'.
     s nextPutAll:'33333'.
     s close.

     s := 'testFile2' asFilename writeStream.
     s nextPutAll:'11111'.
     s nextPutAll:'22222'.
     s nextPutAll:'33333'.
     s close.

     ('testFile1' asFilename sameContentsAs:'testFile2'  ) ifFalse:[self halt].

     s := 'testFile2' asFilename writeStream.
     s nextPutAll:'11111'.
     s nextPutAll:'22222'.
     s nextPutAll:'33333'.
     s nextPutAll:'44444'.
     s close.

     ('testFile1' asFilename sameContentsAs:'testFile2'  ) ifTrue:[self halt].

     s := 'testFile2' asFilename writeStream.
     s nextPutAll:'11111'.
     s nextPutAll:'22222'.
     s close.

     ('testFile1' asFilename sameContentsAs:'testFile2'  ) ifTrue:[self halt].

     s := 'testFile2' asFilename writeStream.
     s nextPutAll:'11111'.
     s nextPutAll:'22222'.
     s nextPutAll:'33334'.
     s close.

     ('testFile1' asFilename sameContentsAs:'testFile2'  ) ifTrue:[self halt].

    "
! !

!Filename methodsFor:'converting'!

asAbsoluteFilename
    "return the receiver converted to a filename with
     an absolute pathname."

    ^ self species named:self pathName

    "
     '.' asFilename
     '.' asFilename asAbsoluteFilename
     'c:' asFilename asAbsoluteFilename
    "
!

asAutoDeletedFilename
    "will automatically delete myself, when no longer referenced"

    ^ AutoDeletedFilename basicNew setName:self name

    "Modified (comment): / 07-09-2011 / 12:20:59 / cg"
!

asCanonicalizedFilename
    "return the receiver converted to a filename without intermediate ..'s and .'s
     (similar to an absolute pathname, but symlinks are not resolved)."

    ^ self species named:(self species canonicalize:nameString)

    "
      'c:\test\work' asFilename asCanonicalizedFilename
      '/test/work' asFilename asCanonicalizedFilename
    "
!

asFilename
    "return the receiver converted to a filename; here, that's the receiver itself."

    "That's pretty easy here :-)"
    ^ self

    "Modified: 12.11.1996 / 12:40:03 / cg"
!

asString
    "return the receiver converted to a string"

    ^ nameString
!

asURI
    "return the receiver converted to a file URI"

    ^ FileURI fromFilename:self.
!

asURL
    "return an URL-object from myself"

    ^ URL fromString:self pathName.
!

asUniqueFilename
    "I a file by my name already exists, return a new filename with a unique string appended.
     here, a somewhat naive strategy is performed, by trying _1, _2,... until a new name is generated."

    |fn baseFn nextSeqNr|

    fn := baseFn := self.
    nextSeqNr := 0.
    [ fn exists ] whileTrue:[
        |newFn suff|
        
        nextSeqNr := (nextSeqNr ? 0) + 1.
        suff := baseFn suffix.
        suff notEmpty ifTrue:[ suff := '.',suff ].
        fn := self class named:((baseFn withoutSuffix name,'_',nextSeqNr asString),suff).
    ].
    ^ fn

    "
     'aaa.txt' asFilename contents:'bla'.
     'aaa.1.2.3.apk.txt' asFilename asUniqueFilename contents:'bla2'.
     'aaa.txt' asFilename asUniqueFilename contents:'bla3'.
     'aaa.txt' asFilename asUniqueFilename contents:'bla4'.
     #('aaa.txt' 'aaa_1.txt' 'aaa_2.txt' 'aaa_3.txt') do:[:f | f asFilename delete].  
    "
!

components
    "return the receiver's filename components - that is the name of each directory
     along the pathName (that DOES include the root directory)"

    ^ self species components:self name

    "
     '.' asFilename asAbsoluteFilename components
     'Makefile' asFilename asAbsoluteFilename components
    "
!

makeLegalFilename
    "convert the receiver's name to be a legal filename.
     This removes/replaces invalid characters and/or compresses
     the name as required by the OS.
     The implementation may change in the future to be more
     OS specific."

    "
     actually, in Unix spaces are allowed - but it makes life
     so hard; therefore, replace them by underscores ...
    "
    nameString := nameString copyReplaceAll:(Character space) with:$_ ifNone:nameString.
    "
     need more - especially on SYS5.3 type systems,
     we may want to contract the fileName to 14 characters.
    "
    ^ self

    "
     'hello world' asFilename makeLegalFilename
    "

    "Modified: / 20.7.1998 / 13:16:51 / cg"
!

withEncoding:encodingSymbol
    "dummy for now - for ST80 compatibility"

    ^ self

    "Created: 20.6.1997 / 17:01:28 / cg"
! !


!Filename methodsFor:'enumerating-contents'!

allDirectoriesDo:aBlock
    "evaluate aBlock for all (recursive) directories contained in the directory represented by the receiver.
     The block is invoked with a filename-arguments.
     The enumerations order within a directory is undefined - i.e. usually NOT sorted by
     filenames (but by creation time - on some systems).
     This excludes entries for '.' or '..'.
     NoOp for non-existing directories; however, this behavior
     may be changed in the near future, to raise an exception instead.
     So users of this method better test for existing directory before."

    self recursiveDirectoryContentsDo:[:eachFileOrDirectoryName |
	|eachFileOrDirectory|

	eachFileOrDirectory := self construct:eachFileOrDirectoryName.
	eachFileOrDirectory isDirectory ifTrue:[
	    aBlock value:eachFileOrDirectory
	]
    ].

    "
     '.' asFilename allDirectoriesDo:[:fn | Transcript showCR:fn name].
     '.' asFilename directoriesDo:[:fn | Transcript showCR:fn name].
    "
!

allParentDirectoriesDo:aBlock
    "evaluate aBlock for all (recursive) directories along the parent directory path.
     The block is invoked with a filename-arguments."

    |parent here|

    here := self.
    parent := here directory.
    [here notNil and:[parent ~= here]] whileTrue:[
	aBlock value:parent.
	here := parent.
	parent := here directory.
    ].

    "
     '.' asFilename allParentDirectoriesDo:[:fn | Transcript showCR:fn pathName].
    "
!

directories
    "return a collection of directories contained in the directory represented by the receiver."

    ^ OrderedCollection withCollectedContents:[:coll |
        self directoriesDo:[:eachDirectory | coll add:eachDirectory]]

    "
     '.' asFilename directories.
    "

    "Modified: / 29-05-2007 / 12:02:56 / cg"
!

directoriesDo:aBlock
    "evaluate aBlock for directories contained in the directory represented by the receiver.
     The block is invoked with a filename-arguments.
     The enumerations order is undefined - i.e. usually NOT sorted by
     filenames (but by creation time - on some systems).
     This excludes entries for '.' or '..'.
     OpenError is raised if I represent a non-existent or non-readable directories.
     So users of this method better test for existing directory before."

    self directoryContentsAsFilenamesDo:[:eachFileOrDirectory |
	eachFileOrDirectory isDirectory ifTrue:[
	    aBlock value:eachFileOrDirectory
	]
    ].

    "
     '.' asFilename directoriesDo:[:fn | Transcript showCR:fn baseName].
    "
!

directoryContentsAsFilenamesDo:aBlock
    "evaluate aBlock for each file in the directory represented by the receiver.
     The block is invoked with a filename-argument.
     The enumerations order is undefined - i.e. usually NOT sorted by
     filenames (but by creation time - on some systems).
     This excludes entries for '.' or '..'.
     An OpenError exception is raised it the directory does not exist or is not readable.
     So users of this method better test for existing directory before.
     Notice: this enumerates fileName objects; see also
     #directoryContentsDo:, which enumerates strings."

    self directoryContentsDo:[:entry |
	aBlock value:(self construct:entry).
    ]

    "
     '.' asFilename directoryContentsAsFilenamesDo:[:fn | Transcript showCR:fn pathName].
    "

    "Modified: / 18.9.1997 / 18:42:23 / stefan"
    "Modified: / 23.12.1999 / 20:56:35 / cg"
!

directoryContentsDo:aBlock
    "evaluate aBlock for each file in the directory represented by the receiver.
     The block is invoked with a string as argument.
     The enumerations order is undefined - i.e. usually NOT sorted by
     filenames (but by creation time - on some systems).
     This excludes entries for '.' or '..'.
     An OpenError exception is raised it the directory does not exist or is not readable.
     So users of this method better test for existing directory before.
     Notice: this enumerates strings; see also
     #directoryContentsAsFilenamesDo:, which enumerates fileName objects."

    |s files|

    s := DirectoryStream directoryNamed:self osNameForDirectoryContents.
    "check for nil, in order to allow to proceed from an OpenError"
    s notNil ifTrue:[
        "/ the old code did a recursive call with the stream open.
        "/ for very very deep hierarchies, this lead to having too many file streams open for
        "/ some operating systems.
        "/ (and therefore to a blocked system, sooner or later, when running out of open files)
        "/ new code reads the directory first, then does the recursion.

"/        [
"/            [s atEnd] whileFalse:[
"/                |fn|
"/
"/                fn := s nextLine.
"/                (fn notNil and:[fn ~= '.' and:[fn ~= '..']]) ifTrue:[
"/                    aBlock value:fn
"/                ].
"/            ].
"/        ] ensure:[
"/            s close.
"/        ].
        files := OrderedCollection new.
        
        [
            [s atEnd] whileFalse:[
                |fn|

                fn := s nextLine.
                (fn notNil and:[fn ~= '.' and:[fn ~= '..']]) ifTrue:[
                    files add:fn
                ].
            ].
        ] ensure:[
            s close.
        ]. 
        files do:aBlock
    ].

    "
     '.' asFilename directoryContentsDo:[:fn | Transcript showCR:fn].
     'doeSnotExIST' asFilename directoryContentsDo:[:fn | Transcript showCR:fn].
     [
        'doeSnotExIST' asFilename directoryContentsDo:[:fn | Transcript showCR:fn].
     ] on:OpenError do:[:ex| ex proceed]
    "

    "Modified: / 18.9.1997 / 18:42:23 / stefan"
    "Modified: / 23.12.1999 / 20:56:35 / cg"
!

files
    "return a collection of regular files
     contained in the directory represented by the receiver."

    ^ OrderedCollection withCollectedContents:[:coll |
        self filesDo:[:eachFileName | coll add:eachFileName]].

    "
     '.' asFilename files.
    "

    "Modified: / 29-05-2007 / 12:02:15 / cg"
!

filesDo:aBlock
    "evaluate aBlock for all regular files (i.e. subdirs are ignored)
     contained in the directory represented by the receiver."

    ^ self directoryContentsAsFilenamesDo:[:eachFileOrDirectory |
	eachFileOrDirectory isRegularFile ifTrue:[
	    aBlock value: eachFileOrDirectory
	].
    ].

    "
     '.' asFilename filesDo:[:f | Transcript showCR:f].
    "

    "Created: / 29-08-2006 / 11:03:15 / cg"
    "Modified: / 29-05-2007 / 12:02:46 / cg"
!

filesMatchingGLOB:pattern do:aBlock
    "Interpreting pattern as a GLOB pattern,
     evaluate aBlock for each file in me, which matches.
     Returns the number of matches."

    self assert:(pattern asFilename isAbsolute not).
    ^ self filesMatchingGLOBComponents:(Filename components:pattern) do:aBlock
    
    "
     '..' asFilename filesMatchingGLOB:'A*' do:[:fn | Transcript showCR:fn].
     '../..' asFilename filesMatchingGLOB:'lib*/*.st' do:[:fn | Transcript showCR:fn].
    "
!

filesMatchingGLOBComponents:patternComponents do:aBlock
    "patternComponents is a component-collection with possible GLOB patterns.
     Evaluate aBlock for each file in me, which matches.
     Returns the number of matches"

    |dirPath subComponents count|
    
    dirPath := patternComponents first.
    subComponents := patternComponents copyFrom:2.

    dirPath includesMatchCharacters ifFalse:[
        | sub |
        
        sub := (self / dirPath).
        subComponents isEmpty ifTrue:[
            "/ I am a leaf
            sub exists ifTrue:[
                aBlock value:sub.
                ^ 1.
            ].    
            ^ 0
        ] ifFalse:[    
            ^ sub filesMatchingGLOBComponents:subComponents do:aBlock
        ].
    ] ifTrue:[
        count := 0.
        subComponents isEmpty ifTrue:[
            "/ I am a leaf
            self isDirectory ifTrue:[
                self filesMatching:dirPath do:[:eachMatchingFile |
                    aBlock value:(self / eachMatchingFile).
                    count := count + 1.
                ]
            ]
        ] ifFalse:[    
            self filesMatching:dirPath do:[:eachMatchingSubDir |
                |sub|
                sub := (self / eachMatchingSubDir).
                sub isDirectory ifTrue:[
                    count := count + (sub filesMatchingGLOBComponents:subComponents do:aBlock)
                ].
            ].
        ].
        ^ count
    ].    

    "
     '/etc/A*' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
     '../A*' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
     '../../lib*/*.st' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
    "
!

filesMatchingGLOBDo:aBlock
    "Interpreting myself as a GLOB pattern,
     evaluate aBlock for each file which matches."

    |parts dirPath subComponents count top|
    
    parts := self components.
    dirPath := parts first.
    subComponents := parts copyFrom:2.

    OpenError handle:[:ex |
        ('%1 [info]: failed to open %2: %3'
                bindWith:self class name
                with:ex pathName 
                with:ex description) infoPrintCR. 
        self breakPoint:#cg.
        ex proceed.
    ] do:[
        top := dirPath asFilename.

        dirPath includesMatchCharacters ifFalse:[
            top isAbsolute ifFalse:[
                top := Filename currentDirectory construct:dirPath.
            ].
            ^ top filesMatchingGLOBComponents:subComponents do:aBlock
        ].
        
        top isAbsolute ifFalse:[
            top := Filename currentDirectory.
        ].
        count := 0.
        top filesMatching:dirPath do:[:sub |
            count := count + ((self / sub) filesMatchingGLOBComponents:subComponents do:aBlock)
        ].
        ^ count
    ].
    
    "
     '/etc/A*' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
     '/etc/a*' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
     '../A*' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
     '../../lib*/*.st' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
     '../../lib*/[A-D]*.st' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
     '../../*/[A-D]*.st' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
     '../../*/*/[A-D]*.st' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
     '../../*java*/*/[A-D]*.st' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
     '../../*java*/*/Ary.st' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
     '/*/A*' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
     '*/A*' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
     '../*/A*' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
     './*/A*' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
     './*/*' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
     '././A*' asFilename filesMatchingGLOBDo:[:fn | Transcript showCR:fn].
    "
!

filesWithSuffix:suffix
    "return a collection of regular files (i.e. not subdirectories)
     with a given suffix which are contained in the directory
     represented by the receiver."

    ^ OrderedCollection withCollectedContents:[:coll |
        self filesWithSuffix:suffix do:[:eachFileName | coll add:eachFileName]].

    "
     '.' asFilename filesWithSuffix:'so'.
     'packages' asFilename filesWithSuffix:'so'.
    "
!

filesWithSuffix:suffix do:aBlock
    "evaluate aBlock for all regular files with a given suffix
     contained in the directory represented by the receiver.
     (i.e. subdirs are ignored)"

    ^ self directoryContentsAsFilenamesDo:[:eachFileOrDirectory |
	(eachFileOrDirectory hasSuffix:suffix) ifTrue:[
	    eachFileOrDirectory isRegularFile ifTrue:[
		aBlock value: eachFileOrDirectory
	    ].
	].
    ].

    "
     '.' asFilename filesWithSuffix:'so' do:[:f | Transcript showCR:f].
    "
!

recursiveDirectoryContentsAsFilenamesDo:aBlock
    "evaluate aBlock for all files and directories found under the receiver.
     The block is invoked with the filenames as argument.
     The walk is bread-first.
     This excludes any entries for '.' or '..'.
     Subdirectory files are included with a relative pathname.
     Warning: this may take a long time to execute (especially with deep and/or remote fileSystems)."

    self recursiveDirectoryContentsDo:[:relFn |
        aBlock value:(self construct:relFn)
    ].

    "
     '.' asFilename recursiveDirectoryContentsAsFilenamesDo:[:f | Transcript showCR:f]
    "

    "Modified: / 12-09-2010 / 15:43:22 / cg"
!

recursiveDirectoryContentsAsFilenamesDo:aBlock filterForVisitingDirectories:filterOrNil
    "evaluate aBlock for all files and directories found under the receiver.
     The block is invoked with the filenames as argument.
     The walk is bread-first.
     This excludes any entries for '.' or '..'.
     Subdirectory files are included with a relative pathname.
     If filterOrNil is nonNil, it is passed every directory about to be walked into;
     if it returns false, that directory is not entered.
     Warning: this may take a long time to execute 
     (especially with deep and/or remote fileSystems)."

    self 
        recursiveDirectoryContentsDo:[:relFn |
            aBlock value:(self construct:relFn)
        ]
        filterForVisitingDirectories:filterOrNil.

    "
     '.' asFilename recursiveDirectoryContentsAsFilenamesDo:[:f | Transcript showCR:f]
    "

    "Modified: / 12-09-2010 / 15:43:22 / cg"
!

recursiveDirectoryContentsDo:aBlock
    "evaluate aBlock for all files and directories found under the receiver.
     The block is invoked with the relative filenames as string-argument.
     The walk is bread-first.
     This excludes any entries for '.' or '..'.
     Subdirectory files are included with a relative pathname.
     Warning: this may take a long time to execute (especially with deep and/or remote fileSystems)."

    self 
        recursiveDirectoryContentsWithPrefix:'' 
        filesDo:aBlock 
        directoriesDo:aBlock

    "
     '.' asFilename recursiveDirectoryContentsDo:[:f | Transcript showCR:f]
    "

    "Modified: / 12-09-2010 / 15:43:22 / cg"
!

recursiveDirectoryContentsDo:aBlock directoryPrefix:aPrefix
    "evaluate aBlock for all files and directories found under the receiver.
     The block is invoked with a string-argument.
     The walk is breadth-first.
     This excludes any entries for '.' or '..'.
     The argument to aBlock is a pathname relative to aPrefix.
     A proceedable exception is raised forn non-accessible directories.
     Warning: this may take a long time to execute (especially with deep and/or remote fileSystems)."

    self
        recursiveDirectoryContentsWithPrefix:aPrefix 
        filesDo:aBlock 
        directoriesDo:aBlock

    "
     '.' asFilename recursiveDirectoryContentsDo:[:f | Transcript showCR:f]
     '/etc' asFilename recursiveDirectoryContentsDo:[:f | Transcript showCR:f]
    "
!

recursiveDirectoryContentsDo:aBlock filterForVisitingDirectories:filterOrNil
    "evaluate aBlock for all files and directories found under the receiver.
     The block is invoked with the relative filenames as string-argument.
     The walk is bread-first.
     This excludes any entries for '.' or '..'.
     Subdirectory files are included with a relative pathname.
     If filterOrNil is nonNil, it is passed every directory about to be walked into;
     if it returns false, that directory is not entered.
     Warning: this may take a long time to execute 
     (especially with deep and/or remote fileSystems)."

    self 
        recursiveDirectoryContentsWithPrefix:'' 
        filesDo:aBlock 
        directoriesDo:aBlock
        filterForVisitingDirectories:filterOrNil    

    "
     '.' asFilename recursiveDirectoryContentsDo:[:f | Transcript showCR:f]
    "

    "Modified: / 12-09-2010 / 15:43:22 / cg"
!

recursiveDirectoryContentsWithPrefix:aPrefix filesDo:fileBlock directoriesDo:dirBlock
    "evaluate aBlock for all files and directories found under the receiver.
     The blocks are invoked with a relative pathname as string-argument.
     The walk is breadth-first (first files, then directories).
     This excludes any entries for '.' or '..'.
     A proceedable exception is raised for non-accessible directories.
     Warning: this may take a long time to execute 
     (especially with deep and/or remote fileSystems)."

    self
        recursiveDirectoryContentsWithPrefix:aPrefix 
        filesDo:fileBlock 
        directoriesDo:dirBlock
        filterForVisitingDirectories:nil

    "
     '.' asFilename 
        recursiveDirectoryContentsWithPrefix:'bla'
        filesDo:[:f | Transcript show:'file: '; showCR:f]
        directoriesDo:[:f | Transcript show:'dir: '; showCR:f]
    "
!

recursiveDirectoryContentsWithPrefix:aPrefix filesDo:fileBlock directoriesDo:dirBlock filterForVisitingDirectories:filterOrNil
    "evaluate aBlock for all files and directories found under the receiver.
     The blocks are invoked with a relative pathname as string-argument.
     The walk is breadth-first (first files, then directories).
     This excludes any entries for '.' or '..'.
     A proceedable exception is raised for non-accessible directories.
     If filterOrNil is nonNil, it is passed every directory about to be walked into;
     if it returns false, that directory is not entered.
     Warning: this may take a long time to execute 
     (especially with deep and/or remote fileSystems).
    "

    |fileNames dirNames p|

    "/ first collect files and dirs
    fileNames := OrderedCollection new.
    dirNames := OrderedCollection new.

    self directoryContentsDo:[:f | |t|
        t := self construct:f.
        t isDirectory ifTrue:[
            (filterOrNil isNil or:[filterOrNil value:t]) ifTrue:[
                dirBlock notNil ifTrue:[
                    t isSymbolicLink ifFalse:[
                        dirNames add:f
                    ]
                ]
            ]
        ] ifFalse:[
            fileBlock notNil ifTrue:[
                fileNames add:f
            ]
        ]
    ].

    aPrefix size > 0 ifTrue:[
        p := aPrefix , self separator
    ] ifFalse:[
        p := ''
    ].

    fileBlock notNil ifTrue:[
        fileNames do:[:aFile | fileBlock value:(p , aFile)].
    ].
    dirBlock notNil ifTrue:[
        dirNames do:[:dN |
            |subDir|

            subDir := (self construct:dN).
            (filterOrNil isNil or:[filterOrNil value:subDir]) ifTrue:[
                dirBlock value:(p , dN).
                subDir
                    recursiveDirectoryContentsWithPrefix:(p , dN) 
                    filesDo:fileBlock directoriesDo:dirBlock
            ].
        ].
    ].
    
    "
     '.' asFilename 
        recursiveDirectoryContentsWithPrefix:'bla'
        filesDo:[:f | Transcript show:'file: '; showCR:f]
        directoriesDo:[:f | Transcript show:'dir: '; showCR:f]
    "
!

withAllDirectoriesDo:aBlock
    "evaluate aBlock for myself and all (recursive) directories contained in the directory represented by the receiver.
     The block is invoked with a filename-arguments.
     The enumerations order within a directory is undefined - i.e. usually NOT sorted by
     filenames (but by creation time - on some systems).
     This excludes entries for '.' or '..'.
     OpenError is raised if the name I represent does not exist or is not readable.
     So users of this method better test for existing directory before."

    self isDirectory ifTrue:[
	aBlock value:self.
    ].
    self allDirectoriesDo:aBlock.

    "
     '.' asFilename withAllDirectoriesDo:[:fn | Transcript showCR:fn name].
     'IdoNOTexist' asFilename withAllDirectoriesDo:[:fn | Transcript showCR:fn name].
     '/etc/hosts' asFilename withAllDirectoriesDo:[:fn | Transcript showCR:fn name].
    "
! !

!Filename methodsFor:'error handling'!

fileCreationError:filename
    "{ Pragma: +optSpace }"

    "report an error that some file could not be created"

    ^ OperatingSystem accessDeniedErrorSignal
	raiseRequestWith:filename?self
	errorString:(' - cannot create/write file: "%1"' bindWith:(filename ? self) asString)
!

reportError:string with:filename
    "{ Pragma: +optSpace }"

    "report an error"

    ^ OsError
	raiseRequestWith:filename?self
	errorString:string
! !

!Filename methodsFor:'file access'!

appendStream
    "return a stream for appending to the file represented by the receiver.
     If the file does not already exist, it is created.
     Same as #appendingWriteStream for ST-80 compatibility."

    ^ self appendingWriteStream
!

appendingWriteStream
    "return a stream for appending to the file represented by the receiver.
     If the file does not already exist, it is created;
     if it does exist, writes are appended at the end."

    ^ FileStream appendingOldFileNamed:(self osNameForAccess)

    "
     |s|

     s := '/tmp/foo' asFilename writeStream.
     s nextPutAll:'1234567890'.
     s close.

     s := '/tmp/foo' asFilename appendingWriteStream.
     s nextPutAll:'abcdef'.
     s close.

     '/tmp/foo' asFilename contents
    "
!

existingReadWriteStream
    "return a stream for read/write the file represented by the receiver.
     If the file does not already exist, an exception is raised."

    ^ FileStream oldFileNamed:(self osNameForAccess)

    "
     '/tmp/blaFaselQuall666666' asFilename remove.
     '/tmp/blaFaselQuall666666' asFilename existingReadWriteStream.
    "
    "
     |s|
     s := '/tmp/foo' asFilename readWriteStream.
     s nextPutAll:'1234567890'; close.
     s := '/tmp/foo' asFilename existingReadWriteStream.
     s nextPutAll:'abcdef'; close.

     '/tmp/foo' asFilename contents inspect.
     '/tmp/foo' asFilename remove
    "
!

newReadWriteStream
    "return a stream for read/write the file represented by the receiver.
     If the file does not already exist, it is created;
     if it does exist, it is truncated."

    ^ FileStream newFileNamed:(self osNameForAccess)

    "
     |s|

     s := '/tmp/foo' asFilename writeStream.
     s nextPutAll:'1234567890'.
     s close.

     s := '/tmp/foo' asFilename newReadWriteStream.
     s nextPutAll:'12345'.
     s close.

     '/tmp/foo' asFilename contents
    "
!

openWithMode:anArrayOrString
    "return a stream for read/write the file represented by the receiver.
     If the file does not already exist, it is created;
     if it does exist, it is truncated."

    ^ FileStream open:self osNameForAccess withMode:anArrayOrString

    "
     |s|

     s := '/tmp/foo' asFilename openWithMode:'r+'.
     s nextPutAll:'1234567890'.
     s close.


     '/tmp/foo' asFilename contents
    "
!

readStream
    "Return a stream for reading from the file represented by the receiver.
     Raises an error if the file does not exist."

    ^ FileStream readonlyFileNamed:(self osNameForAccess)

    "
      '/tmp/foo' asFilename readStream
    "
!

readWriteStream
    "return a stream for read/write the file represented by the receiver.
     If the file does not already exist, it is created.
     If the file does exist, it is NOT truncated, but rewritten at the beginning."

    ^ FileStream fileNamed:(self osNameForAccess)

    "
     |s|

     s := '/tmp/foo' asFilename writeStream.
     s nextPutAll:'1234567890'.
     s close.

     s := '/tmp/foo' asFilename readWriteStream.
     s nextPutAll:'abcdef'.
     s close.

     '/tmp/foo' asFilename contents
     '/tmp/foo' asFilename remove
    "
!

writeStream
    "return a stream for writing to the file represented by the receiver.
     If the file does not already exist, it is created;
     if it does exist, it is truncated."

    ^ FileStream newFileForWritingNamed:(self osNameForAccess)

    "
     '/tmp/foo' asFilename writeStream
    "

    "
     |s|

     s := '/tmp/foo' asFilename writeStream.
     s nextPutAll:'1234567890'.
     s close.

     s := '/tmp/foo' asFilename writeStream.
     s nextPutAll:'12345'.
     s close.

     '/tmp/foo' asFilename contents
    "
! !

!Filename methodsFor:'file access - migration'!

appendingWriteStreamOrNil
    "return a stream for appending to the file represented by the receiver.
     If the file does not already exist, it is created;
     if it does exist, writes are appended at the end.

     Return nil, if the file cannot be opened.
     Use this method for migration of old smalltalk code that expects a nil return code
     instead of an exception when an error occurs."

    ^ [
	FileStream appendingOldFileNamed:(self osNameForAccess)
      ] on:FileStream openErrorSignal do:[:ex| nil].
!

newReadWriteStreamOrNil
    "return a stream for read/write the file represented by the receiver.
     If the file does not already exist, it is created;
     if it does exist, it is truncated.

     Return nil, if the file cannot be opened.
     Use this method for migration of old smalltalk code that expects a nil return code
     instead of an exception when an error occurs."

    ^ [
	 FileStream newFileNamed:(self osNameForAccess)
    ] on:FileStream openErrorSignal do:[:ex|nil].
!

readStreamOrNil
    "return a stream for reading from the file represented by the receiver.
     If the file does not already exist, nil is returned.

     Return nil, if the file cannot be opened.
     Use this method for migration of old smalltalk code that expects a nil return code
     instead of an exception when an error occurs."

    ^ [
	FileStream readonlyFileNamed:(self osNameForAccess)
    ] on:FileStream openErrorSignal do:[:ex|nil].

    "
     '/tmp/foo' asFilename readStreamOrNil
     '/tmp/foo' asFilename readStream
    "
!

readWriteStreamOrNil
    "return a stream for read/write the file represented by the receiver.
     If the file does not already exist, it is created.
     If the file does exist, it is NOT truncated, but rewritten at the beginning

     Return nil, if the file cannot be opened.
     Use this method for migration of old smalltalk code that expects a nil return code
     instead of an exception when an error occurs."

    ^ [
	FileStream fileNamed:(self osNameForAccess)
    ] on:FileStream openErrorSignal do:[:ex|^ nil].
!

writeStreamOrNil
    "return a stream for writing to the file represented by the receiver.
     If the file does not already exist, it is created;
     if it does exist, it is truncated.

     Return nil, if the file cannot be opened.
     Use this method for migration of old smalltalk code that expects a nil return code
     instead of an exception when an error occurs."

    ^ [
	FileStream newFileForWritingNamed:(self osNameForAccess)
    ] on:FileStream openErrorSignal do:[:ex|^ nil].


    "
     '/etc/foo' asFilename writeStreamOrNil
    "
! !

!Filename methodsFor:'file access rights'!

accessRights
    "return the access rights of the file as opaque data
     (SmallInteger in unix/linux)"

    |access|

    access := OperatingSystem accessModeOf:self osName.
    access isOSErrorHolder ifTrue:[
        access reportProceedableError:'get access rights failed'.
    ].
    ^ access.

    "
     'Make.proto' asFilename accessRights
     'foo' asFilename accessRights
    "
!

accessRights:opaqueData
    "set the access rights of the file to opaqueData,
     which is normally retrieved by Filename>>#accessRights."

    |osErrorHolder|

    osErrorHolder := OperatingSystem changeAccessModeOf:self osNameForFile to:opaqueData.
    osErrorHolder notNil ifTrue:[
        osErrorHolder reportProceedableError:'change access rights failed'.
    ].


    "
     |rights|

     rights := 'Make.proto' asFilename accessRights.
     'Make.proto' asFilename accessRights:rights.
    "

    "Modified: / 5.5.1999 / 13:41:21 / cg"
!

addAccessRights:aCollection
    "add the access rights as specified in aCollection for the file represented
     by the receiver. The argument must be a collection of symbols,
     such as #readUser, #writeGroup etc."

    |access osName osErrorHolder|

    osName := self osNameForFile.
    access := OperatingSystem accessModeOf:osName.
    access isOSErrorHolder ifTrue:[
        access reportProceedableError:'get access rights failed'.
    ].
        
    aCollection do:[:accessSymbol |
        access := access bitOr:(OperatingSystem accessMaskFor:accessSymbol).
    ].
    osErrorHolder := OperatingSystem changeAccessModeOf:osName to:access.
    osErrorHolder notNil ifTrue:[
        osErrorHolder reportProceedableError:'change access rights failed'.
    ].

    "
     'foo' asFilename writeStream close.
     'foo' asFilename addAccessRights:#(readUser readGroup readOthers).
     'foo' asFilename addAccessRights:#(writeUser writeGroup writeOthers).
     'foo' asFilename addAccessRights:#(executeUser executeGroup executeOthers).
    "
!

makeExecutable
    "make the file executable - you must have permission to do so.
     For directories, execution means: 'allow changing into it'"

    ^ self addAccessRights:#(executeUser)

    "Created: 9.1.1996 / 15:32:47 / cg"
!

makeExecutableForAll
    "make the file executable for all - you must have permission to do so.
     For directories, execution means: 'allow changing into it'"

    ^ self addAccessRights:#(executeUser executeGroup executeOthers)

    "Created: 9.1.1996 / 15:32:28 / cg"
!

makeExecutableForGroup
    "make the file executable for the group - you must have permission to do so.
     For directories, execution means: 'allow changing into it'"

    ^ self addAccessRights:#(executeGroup)

    "Created: 9.1.1996 / 15:32:28 / cg"
!

makeReadable
    "make the file readable for  the owner - you must have permission to do so."

    ^ self addAccessRights:#(readUser)
!

makeReadableForAll
    "make the file readable for all - you must have permission to do so."

    ^ self addAccessRights:#(readUser readGroup readOthers)
!

makeReadableForGroup
    "make the file readable for the group - you must have permission to do so."

    ^ self addAccessRights:#(readGroup)
!

makeUnwritable
    "make the file unwritable for all - you must have permission to do so."

    ^ self removeAccessRights:#(writeUser writeGroup writeOthers)
!

makeWritable
    "make the file writableable for all - you must have permission to do so."

    ^ self addAccessRights:#(writeUser)
!

makeWritableForAll
    "make the file writable for all - you must have permission to do so."

    ^ self addAccessRights:#(writeUser writeGroup writeOthers)
!

makeWritableForGroup
    "make the file writable for the group - you must have permission to do so."

    ^ self addAccessRights:#(writeGroup)
!

removeAccessRights:aCollection
    "remove the access rights as specified in aCollection for the file represented
     by the receiver. The argument must be a collection of symbols,
     such as #readUser, #writeGroup etc.
     Raises an exception if not successful."

    |access osName osErrorHolder|

    osName := self osNameForFile.
    access := OperatingSystem accessModeOf:osName.
    access isOSErrorHolder ifTrue:[
        access reportProceedableError:'get access rights failed'.
    ].

    aCollection do:[:accessSymbol |
        access := access bitAnd:(OperatingSystem accessMaskFor:accessSymbol) bitInvert.
    ].
    osErrorHolder := OperatingSystem changeAccessModeOf:osName to:access.
    osErrorHolder notNil ifTrue:[
        osErrorHolder reportProceedableError:'change access rights failed'.
    ].

    "
     'foo' asFilename writeStream close.
     'foo' asFilename removeAccessRights:#(readUser readGroup readOthers).
     'foo' asFilename removeAccessRights:#(writeUser writeGroup writeOthers).
     'foo' asFilename removeAccessRights:#(executeUser executeGroup executeOthers).
    "

    "Modified: / 5.5.1999 / 13:41:21 / cg"
!

symbolicAccessRights
    "return the access rights of the file as a aCollection of access symbols.
     The returned collection consists of symbols like:
        #readUser, #writeGroup etc."

    |access osName|

    osName := self osNameForFile.
    access := OperatingSystem accessModeOf:osName.
    access isOSErrorHolder ifTrue:[
        access reportProceedableError:'get access rights failed'.
    ].

    ^
        #(  readUser writeUser executeUser
            readGroup writeGroup executeGroup
            readOthers writeOthers executeOthers
          ) select:[:eachSymbolicAccessSymbol |
                access bitTest:(OperatingSystem accessMaskFor:eachSymbolicAccessSymbol).
            ].

    "
     'Make.proto' asFilename symbolicAccessRights
    "

    "Modified: / 5.5.1999 / 13:41:21 / cg"
!

symbolicAccessRights:aCollectionOfSymbols
    "set the access rights of the file given a aCollection of access symbols.
     The collection must consist of symbols like:
        #readUser, #writeGroup etc."

    |access osName osErrorHolder|

    osName := self osNameForFile.
    access := aCollectionOfSymbols inject:0 into:[:bitsSoFar :eachSymbolicAccessSymbol |
                bitsSoFar bitOr:(OperatingSystem accessMaskFor:eachSymbolicAccessSymbol)
              ].

    osErrorHolder := OperatingSystem changeAccessModeOf:osName to:access.
    osErrorHolder notNil ifTrue:[
        osErrorHolder reportProceedableError:'change access rights failed'.
    ].

    "
     |rights|

     rights := 'Make.proto' asFilename symbolicAccessRights.
     'Make.proto' asFilename symbolicAccessRights:(rights , #(executeOthers)).
    "

    "Modified: / 5.5.1999 / 13:41:21 / cg"
! !

!Filename methodsFor:'file operations'!

appendTo:newNameOrStream
    "append the file - the argument must be convertable to a filename.
     Raises an exception, if an error occurs."

    |inStream outStream outStreamToClose|

    inStream := self readStream.
    [
        newNameOrStream isStream ifTrue:[
            outStream := newNameOrStream.
        ] ifFalse:[
            outStream := outStreamToClose := newNameOrStream asFilename appendingWriteStream.
        ].

        inStream binary.
        outStream binary.

        inStream copyToEndInto:outStream.
    ] ensure:[
        inStream close.
        outStreamToClose notNil ifTrue:[outStreamToClose close].
    ].

    "
     '/etc/group' asFilename appendTo:'/tmp/Makefile.foo'.
     'Makefile' asFilename appendTo:'/tmp/Makefile.foo'
     'Makefile' asFilename copyTo:'/'
     'smalltalk' asFilename copyTo:'/dev/null'
    "

    "Modified: / 23.12.1999 / 21:52:36 / cg"
!

copyTo:newNameArg
    "Copy the file's contents into another file.
     The argument must be convertable to a filename.
     Raises an exception, if an error occurs."

    |newName inStream outStream newNameAlreadyExists|

    newName := newNameArg asFilename.

    "Contents is not copied if newName represents the same file as me."
    newName asAbsoluteFilename = self asAbsoluteFilename ifTrue: [ ^ self ].

    (newName exists and:[newName isDirectory]) ifTrue:[
        newName := newName construct:(self baseName).
    ].

    inStream := self readStream.
    inStream isNil ifTrue:[
        "open failed, but somenone did a proceed for the OpenError.
         Ignore this file but continue in order to copy the rest when
         doing a recursive copy"
        ^ self.
    ].

    [
        newNameAlreadyExists := newName exists.
        outStream := newName writeStream.
        newNameAlreadyExists ifFalse:[
            "ignore the error - may occur when copying to a network drive"
            OsError catch:[
                "would be nice to keep the access rights of the original test suite"
                newName accessRights:self accessRights.
            ].
        ].
        inStream binary; buffered:false.
        outStream binary; buffered:false.
        inStream copyToEndInto:outStream.
    ] ensure:[
        inStream close.
        outStream notNil ifTrue:[outStream close].
    ].

    "
     'Make.proto' asFilename copyTo:'/tmp/Makefile.foo'
     'Make.proto' asFilename copyTo:'/'
     'smalltalk' asFilename copyTo:'/dev/null'
    "

    "Modified: / 10-09-2004 / 09:49:28 / janfrog"
    "Modified: / 06-06-2016 / 12:15:25 / cg"
!

copyToStream:outStream
    "Copy the file's contents into another file.
     The argument must be convertable to a filename.
     Raises an exception, if an error occurs."

    |inStream resetBinary|

    "Contents is not copied if newName represent same file as me."
    outStream isFileStream ifTrue:[
	outStream fileName asAbsoluteFilename = self asAbsoluteFilename ifTrue: [ ^ self ].
    ].

    inStream := self readStream.
    [
	inStream binary"; buffered:false".
	resetBinary := false.
	outStream isBinary ifFalse:[
	    outStream binary.
	    resetBinary := true.
	].
	inStream copyToEndInto:outStream.
    ] ensure:[
	inStream close.
	resetBinary ifTrue:[
	    outStream text.
	].
    ].

    "
     |out|
     out := FileStream newTemporary.
     'Make.proto' asFilename copyToStream:out.
     out reset; contents
    "
!

createAsEmptyFile
    "create an empty file with the receiver's name.
     Raises an exception if not successful
    (either already existing or creation not possible)"

    |writeStream|

    self exists ifTrue:[
	OperatingSystem accessDeniedErrorSignal
	    raiseRequestWith:self
	    errorString:(' - file exists: ' , self asString).
	^ self
    ].

    FileStream openErrorSignal handle:[:ex|
	self fileCreationError:self.
	^ self
    ] do:[
	writeStream := self newReadWriteStream.
    ].
    writeStream close.
!

createAsHardLinkTo:linkFilenameString
    "create a directory with the receiver's name.
     Raises an exception if not successful"

    |errorHolder|

    errorHolder := OperatingSystem createHardLinkFrom:linkFilenameString asFilename osName to:self osName.
    errorHolder notNil ifTrue:[
        errorHolder reportProceedableError:'hard link failed'.
    ].

    "
        '/tmp/link' asFilename createAsHardLinkTo:'bla'
    "
!

createAsSymbolicLinkTo:linkFilenameString
    "create a directory with the receiver's name.
     Raises an exception if not successful"

    |errorHolder|

    errorHolder := OperatingSystem createSymbolicLinkFrom:linkFilenameString asFilename osName to:self osName.
    errorHolder notNil ifTrue:[
        errorHolder reportError:'symbolic link failed'.
    ].

    "
        '/tmp/link' asFilename createAsSymbolicLinkTo:'bla'
    "
!

delete
    "remove the file - same as remove, for ST-80 compatibility"

    self remove
!

makeDirectory
    "create a directory with the receiver's name.
     Raises an exception if not successful"

    |osErrorHolder|

    osErrorHolder := OperatingSystem createDirectory:(self osNameForDirectory).
    osErrorHolder notNil ifTrue:[
        "/
        "/ could have existed before ...
        "/
        (self exists and:[self isDirectory]) ifFalse:[
            osErrorHolder reportProceedableError:'make directory failed'.
        ]
    ].
    ^ nil

    "Modified: / 5.5.1999 / 13:36:33 / cg"
!

moveFileTo:newName
    "copy the file represented by the receiver, then delete it.
     This is different to renaming in case of cross device moves.
     Raise an exception if not successful.
     (Notice, that a rename is tried first, in case of non-cross device move)"

    [self renameTo:newName]
	on:OsError
	do:[:ex |
	    ex creator == OperatingSystem fileNotFoundErrorSignal ifTrue:[
		ex reject
	    ].
	    self safeCopyTo:newName.
	    self remove
	].

    "
     |f s|

     f := '/tmp/foo' asFilename.
     s := f writeStream.
     s nextPutLine:'hello'.
     s close.
     f renameTo:'./foo'
    "

    "
     |f s|

     f := '/tmp/foo' asFilename.
     s := f writeStream.
     s nextPutLine:'hello'.
     s close.
     f moveTo:'./foo'
    "
!

moveTo:newNameArg
    "copy the file represented by the receiver, then delete it.
     This is different to renaming in case of cross device moves.
     Raise an exception if not successful.
     (Notice, that a rename is tried first, in case of non-cross device move)"

    |newName|

    newName := newNameArg asFilename.
    [self renameTo:newName]
	on:(OSErrorHolder inappropriateReferentSignal)
	do:[:ex |
	    "handle renames accross device boundaries (Unix. cross device link)"
	    self isDirectory ifTrue:[
		self recursiveMoveDirectoryTo:newName.
	    ] ifFalse:[
		self safeCopyTo:newName.
		self remove.
	    ].
	].

    "
     |f s|

     f := '/tmp/foo' asFilename.
     s := f writeStream.
     s nextPutLine:'hello'.
     s close.
     f renameTo:'./foo'
    "

    "
     |f s|

     f := '/tmp/foo' asFilename.
     s := f writeStream.
     s nextPutLine:'hello'.
     s close.
     f moveTo:'./foo'
    "
!

recursiveCopyTo:destination
    "if I represent a regular file, copy it.
     Otherwise, copy the directory and recursively
     all of its subfiles/subdirectories.

     Raises an exception if not successful.
     Do not resolve symbolic links.
     If a whole directory is to be copied and the destination directory
     does not exist, it will be created."

    |ok destinationFilename|

    destinationFilename := destination asFilename.
    self isDirectory ifFalse:[
	destinationFilename isDirectory ifTrue:[
	    destinationFilename := destinationFilename construct:self baseName.
	].
	self copyTo:destinationFilename.
	^ self.
    ].

    "/ typically, an 'cp -r' is faster;
    "/ however, if the command fails (or the OS does not support it),
    "/ fallBack doing a manual directory walk.

    ok := OperatingSystem
	    recursiveCopyDirectory:(self osNameForDirectory)
	    to:(destinationFilename osNameForDirectory).

    ok ifFalse:[
	self recursiveCopyWithoutOSCommandTo:destinationFilename
    ].

    "
	'.' asFilename recursiveCopyTo:'/temp/xxx'.
    "

    "Created: / 05-05-1999 / 13:35:01 / cg"
    "Modified: / 31-05-1999 / 13:11:34 / cg"
    "Modified: / 29-07-2010 / 12:41:06 / sr"
!

recursiveCopyWithoutOSCommandTo:destination
    "if I represent a regular file, copy it.
     Otherwise, copy the directory and all of its subfiles/subdirectories.
     This one walks down the directory hierarchy, not using any OS command to do the copy.
     Raises an exception if not successful.

     Do not resolve symbolic links.
     If a whole directory is to be copied and the destination directory
     does not exist, it will be created."

    |destinationFilename|

    destinationFilename := destination asFilename.

    self isDirectory ifTrue:[
        destinationFilename exists ifFalse:[
            destinationFilename makeDirectory.
            OsError catch:[
                destinationFilename accessRights:self accessRights.
            ].
        ].

        self directoryContentsDo:[:aFilenameString |
            |src srcInfo dst info|

            src := self construct:aFilenameString.
            dst := destinationFilename construct:aFilenameString.

            srcInfo := src linkInfo.
            srcInfo isDirectory ifTrue:[
                src recursiveCopyWithoutOSCommandTo:dst
            ] ifFalse:[srcInfo isSymbolicLink ifTrue:[
                dst
                    remove;
                    createAsSymbolicLinkTo:srcInfo path.
            ] ifFalse:[
                src copyTo:dst.
            ]].
        ].
    ] ifFalse:[
        destinationFilename isDirectory ifTrue:[
            destinationFilename := destinationFilename construct:self baseName.
        ].
        self copyTo:destinationFilename.
    ]

    "
     '.' asFilename recursiveCopyWithoutOSCommandTo:'/temp/xxx'.
     'smalltalk.rc' asFilename recursiveCopyWithoutOSCommandTo:'/tmp/xxx'.
    "

    "Modified: / 31.5.1999 / 18:12:31 / cg"
!

recursiveMakeDirectory
    "create a directory with the receiver's name and all required intermediate
     directories.
     Raises an exception if not successful."

    |osErrorHolder|

    osErrorHolder := OperatingSystem recursiveCreateDirectory:(self osNameForDirectory).
    osErrorHolder notNil ifTrue:[
        osErrorHolder reportProceedableError:'recursive makedir failed'.
    ].

    "
        'k:\bla\quark' asFilename recursiveMakeDirectory
    "

    "Created: / 27.11.1995 / 23:36:40 / cg"
    "Modified: / 5.5.1999 / 13:38:42 / cg"

    "
        'C:\windows\bla\xx' asFilename recursiveMakeDirectory
        'C:\windows\bla' asFilename recursiveRemoveAll
    "
!

recursiveMoveDirectoryTo:newName
    "recursively copy the directory represented by the receiver, then delete it.
     This is different to renaming in case of cross device moves.
     Raise an exception if not successful.
     (Notice, that a rename is tried first, in case of non-cross device move)"

    [self renameTo:newName]
	on:OsError
	do:[
	    self recursiveCopyTo:newName.
	    self recursiveRemove
	].
!

recursiveRemove
    "if I represent a regular file, remove it.
     Otherwise, remove the directory and all of its subfiles/subdirectories.
     Raise an exception if not successful."

    |ok|

    "/ typically, an 'rm -rf' is faster and removes better;
    "/ however, if the command fails (or the OS does not support it),
    "/ fallBack doing a manual directory walk.

    ok := OperatingSystem recursiveRemoveDirectory:(self osNameForDirectory).
    ok ifFalse:[
	self recursiveRemoveWithoutOSCommand
    ].

    "
     'foo/bar' asFilename recursiveMakeDirectory.
     'foo' asFilename remove.
     self assert:('foo' asFilename exists not).


     'foo' asFilename recursiveRemove.
     'foo/bar' asFilename recursiveMakeDirectory.
     'foo' asFilename recursiveRemove.
     self assert:('foo' asFilename exists not).
    "

    "Created: / 14.11.1995 / 11:19:29 / cg"
    "Modified: / 5.5.1999 / 13:43:35 / cg"
!

recursiveRemoveAll
    "Remove all of my subfiles/subdirectories.
     Raise an error if not successful.
     This one walks down the directory hierarchy, not using any OS
     command to do the remove."

    self isDirectory ifTrue:[
        self directoryContentsAsFilenamesDo:[:eachFilename |
            OsError handle:[:ex |
                eachFilename isDirectory ifFalse:[ ex reject ].
                eachFilename
                    recursiveRemoveAll;
                    removeDirectory.
            ] do:[
                eachFilename remove
            ].

"/            eachFilename isDirectory ifTrue:[
"/                eachFilename recursiveRemoveWithoutOSCommand
"/            ] ifFalse:[
"/                eachFilename remove
"/            ].
        ]
    ].

    "
     'foo' asFilename makeDirectory.
     'foo/bar' asFilename writeStream close.
     'foo' asFilename remove
    "
    "
     'foo' asFilename makeDirectory.
     'foo/bar' asFilename writeStream close.
     'foo' asFilename recursiveRemove.
     self assert:('foo' asFilename exists not).
    "

    "Created: / 25-01-2011 / 16:42:15 / cg"
!

recursiveRemoveWithoutOSCommand
    "if I represent a regular file, remove it.
     Otherwise, remove the directory and all of its subfiles/subdirectories.
     Raise an error if not successful.
     This one walks down the directory hierarchy, not using any OS
     command to do the remove."

    self
	recursiveRemoveAll;
	remove.

    "
     'foo' asFilename makeDirectory.
     'foo/bar' asFilename writeStream close.
     'foo' asFilename remove
    "
    "
     'foo' asFilename makeDirectory.
     'foo/bar' asFilename writeStream close.
     'foo' asFilename recursiveRemove
    "

    "Created: / 25-02-1998 / 19:50:40 / cg"
    "Modified: / 19-01-2012 / 17:18:28 / cg"
!

remove
    "remove the file/directory.
     Raises an exception if not successful.
     Use #recursiveRemove in order to (recursively) remove non empty directories."

    |linkInfo osName osErrorHolder|

    osName := self osNameForAccess.
    osErrorHolder := OperatingSystem removeFile:osName.
    osErrorHolder notNil ifTrue:[
        linkInfo := self linkInfo.
        linkInfo isNil ifTrue:[
            "file does not exist - no error"
            ^ self.
        ] ifFalse:[linkInfo isDirectory ifTrue:[
            osErrorHolder := OperatingSystem removeDirectory:osName
        ]].
        osErrorHolder notNil ifTrue:[
            self exists ifTrue:[
                osErrorHolder reportProceedableError:'remove failed'.
            ]
        ]
    ].

    "
     (FileStream newFileNamed:'foo') close.
     'foo' asFilename remove
    "

    "
     'foo' asFilename makeDirectory.
     'foo/bar' asFilename writeStream close.
     'foo' asFilename remove.   'expect an exception'
     'foo' asFilename recursiveRemove.
    "

    "Modified: / 20-11-1997 / 17:40:22 / stefan"
    "Modified: / 11-10-2011 / 10:20:01 / cg"
!

removeDirectory
    "remove the directory.
     Raises an exception if not successful (or if its not a directory).
     Use #remove if it is not known if the receiver is a directory or file.
     Use #recursiveRemove in order to (recursively) remove non empty directories."

    |osErrorHolder|

    osErrorHolder := OperatingSystem removeDirectory:self osNameForAccess.
    osErrorHolder notNil ifTrue:[
        self exists ifTrue:[
            osErrorHolder reportProceedableError:'remove directory failed'.
        ].
    ].


    "
     (FileStream newFileNamed:'foo') close.
     'foo' asFilename removeDirectory
    "

    "
     'foo' asFilename writeStream close.
     'foo' asFilename removeDirectory
    "

    "
     'foo' asFilename makeDirectory.
     'foo/bar' asFilename writeStream close.
     ('foo' asFilename remove) ifFalse:[
        Transcript showCR:'could not remove foo'
     ]
    "

    "Modified: / 20.11.1997 / 17:40:22 / stefan"
    "Modified: / 5.5.1999 / 13:41:12 / cg"
!

removeFile
    "remove the file.
     Raises an exception if not successful (or if its not a file).
     Use #remove if it is not known if the receiver is a directory or file.
     Use #recursiveRemove in order to (recursively) remove non empty directories."

    |osErrorHolder|

    osErrorHolder := OperatingSystem removeFile:self osNameForAccess.
    osErrorHolder notNil ifTrue:[
        self exists ifTrue:[
            osErrorHolder reportProceedableError:'remove of file failed'.
        ].
    ].

    "
     (FileStream newFileNamed:'foo') close.
     'foo' asFilename removeFile
    "

    "
     'foo' asFilename makeDirectory.
     'foo' asFilename removeFile
    "
!

renameTo:newName
    "rename the file - the argument must be convertable to a String.
     Raises an exception if not successful.
     If newName already exists, it will be replaced by myself."

    |errorHolder|

    errorHolder := OperatingSystem
                        renameFile:(self osNameForFile)
                        to:(newName asFilename osNameForFile).

    errorHolder notNil ifTrue:[
        errorHolder
            parameter:self;
            reportProceedableError:'rename failed'.
    ].

    "
     '/tmp/foo' asFilename renameTo:'/tmp/bar'
     '/tmp/' asFilename renameTo:'/etc/bar'
     'C:\windows' asFilename renameTo:'C:\win'
    "

    "Modified: / 5.5.1999 / 13:41:27 / cg"
!

safeCopyTo:newNameArg
    "Copy the file's contents into another file.
     Do it safe in an atomic operation shich makes sure that no partially written file appears.
     The argument must be convertable to a filename.
     Raises an exception, if an error occurs."

    |newName inStream accessRights tempStream|

    newName := newNameArg asFilename.

    "Contents is not copied if newName represent same file as me."
    newName asAbsoluteFilename = self asAbsoluteFilename ifTrue: [ ^ self ].

    inStream := self readStream.
    newName exists ifTrue:[
        accessRights := newName accessRights.
    ] ifFalse:[
        accessRights := self accessRights.
    ].

    [
        "let the temp filename start with a ~ to make it invisible"
        tempStream := FileStream newTemporaryIn:newName directory osNameForFile nameTemplate:'~%1_%2'.
        "ignore the error - may occur when copying to a network drive"
        OsError catch:[
            "would be nice to keep the access rights of the original file"
            tempStream fileName accessRights:accessRights.
        ].

        inStream binary; buffered:false.
        tempStream binary; buffered:false.
        [
            inStream copyToEndInto:tempStream.
        ] ifCurtailed:[
            tempStream close.
            tempStream fileName remove.
            tempStream := nil.
        ].
        tempStream syncData.
    ] ensure:[
        inStream close.
        tempStream notNil ifTrue:[tempStream close].
    ].
    tempStream fileName renameTo:newName.

    "
     'Make.proto' asFilename safeCopyTo:'/tmp/Makefile.foo'
     'Make.proto' asFilename safeCopyTo:'/'
     'smalltalk' asFilename safeCopyTo:'/xxxxxxxxxxxxxxxx/bla'
    "

    "Modified: / 10-09-2004 / 09:49:28 / janfrog"
    "Modified: / 29-09-2006 / 16:26:32 / cg"
!

truncateTo:newSize
    "change the file's size.
     This may not be supported on all operating systems
     (raises an exception, if not)"

    (OperatingSystem truncateFile:self osNameForFile to:newSize) ifFalse:[
	^ self reportError:'unsupported operation' with:self
    ]

    "
     |s|

     s := 'test' asFilename writeStream.
     s next:1000 put:$1.
     s close.
     ('test' asFilename fileSize) printCR.
     'test' asFilename truncateTo:100.
     ('test' asFilename fileSize) printCR.
    "

    "Modified: / 5.5.1999 / 13:41:59 / cg"
! !

!Filename methodsFor:'file queries'!

accessTime
    "return a timeStamp containing the file's last access time."

    | i |

    (i := self info) isNil ifTrue:[^ nil].
    ^ i accessTime

    "
     Filename currentDirectory accessTime
    "

    "Created: / 9.7.1996 / 10:19:15 / cg"
    "Modified: / 26.9.1997 / 13:05:51 / stefan"
    "Modified: / 17.8.1998 / 10:23:44 / cg"
!

creationTime
    "return a timeStamp containing the file's creation time.
     NOTICE: only windoof distinguishes creation from modification;
     under unix, nil is returned (callers should fall back and use mod-time then"

    |i|

    (i := self info) isNil ifTrue:[^ nil].      "/ non-existing
    ^ i creationTime

    "
     Filename currentDirectory creationTime
    "

    "Created: / 9.7.1996 / 10:18:59 / cg"
    "Modified: / 26.9.1997 / 13:05:39 / stefan"
    "Modified: / 14.8.1998 / 17:42:50 / cg"
!

dates
    "return the file's modification and access times as an object (currently a dictionary)
     that responds to the at: message with arguments
     #modified, #accessed or #statusChanged."

    |info dates osName|

    osName := self osNameForAccess.
    info := OperatingSystem infoOf:osName.
    info isNil ifTrue:[
	"maybe this is a symbolic link with a broken link target.
	 Answer the dates of the link itself"
	info := OperatingSystem linkInfoOf:osName.
	info isNil ifTrue:[
	    ^ nil
	]
    ].
    dates := IdentityDictionary new.
    dates at:#created put:(info creationTime).
    dates at:#modified put:(info modificationTime).
    dates at:#accessed put:(info accessTime).
    dates at:#statusChanged put:(info statusChangeTime).
    ^ dates

    "
     Filename currentDirectory dates
     '../regression' asFilename dates
    "

    "Modified: 1.11.1996 / 20:19:24 / cg"
!

fileSize
    "return the size of the file in bytes"

    |i|

    (i := self info) isNil ifTrue:[^ nil].
    ^ i fileSize

    "Modified: / 17.8.1998 / 10:23:46 / cg"
!

fileType
    "this returns a string describing the type of contents of
     the file. This is done using the unix 'file' command,
     (which usually is configurable by /etc/magic).
     On non-unix systems, this may simply return 'file',
     not knowning about the contents.
     Warning:
	 Since the returned string differs among systems (and language settings),
	 it is only useful for user-information;
	 NOT as a tag to be used by a program."

    |suffix baseNm info mime|

    "/ since we cannot depend on a 'file' command being available,
    "/ do the most obvious ones here.
    "/ (also useful since the 'file' command takes some time, and the code
    "/  below is faster for common things like directories)

    info := self linkInfo.
    info isNil ifTrue:[
	^ 'removed'         "/ could happen, when coming from a snapshot image
    ].

    info isSymbolicLink ifTrue:[
	^ 'symbolic link to ' , info path
    ].
    info isDirectory ifTrue:[
	self isReadable ifFalse:[^ 'directory, unreadable'].
	self isExecutable ifFalse:[^ 'directory, locked'].
	^ 'directory'
    ].
    info isCharacterSpecial ifTrue:[
	^ 'character device special file'
    ].
    info isBlockSpecial ifTrue:[
	^ 'block device special file'
    ].
    info isSocket ifTrue:[
	^ 'socket'
    ].
    info isFifo ifTrue:[
	^ 'fifo'
    ].

    self isReadable ifFalse:[^ 'unreadable'].
    info fileSize == 0 ifTrue:[^ 'empty'].

    "/ suffix := self suffix asLowercase.
    "/ baseNm := self withoutSuffix baseName asLowercase.

    mime := self mimeTypeOfContents.
    mime notNil ifTrue:[
	"/ kludge to avoid making libview a prereq. of libbasic
	(Smalltalk at:#MIMETypes) notNil ifTrue:[
	    info := (Smalltalk at:#MIMETypes) fileInfoForMimeType:mime.
	    info notNil ifTrue:[^ info].
	].
    ].
    ^ 'file'

    "
     'Makefile' asFilename fileType
     '.' asFilename fileType
     '/dev/null' asFilename fileType
     '/usr/tmp' asFilename fileType
     '/tmp/.X11-unix/X0' asFilename fileType
     'smalltalk.rc' asFilename fileType
     'bitmaps/SBrowser.xbm' asFilename fileType
    "

    "Modified: / 21.7.1998 / 11:25:56 / cg"
!

id
    "return the file's/directory's file-id (inode number)"

    ^ OperatingSystem idOf:(self osNameForAccess)

    "
     Filename currentDirectory id
    "

    "Modified: 9.7.1996 / 10:19:27 / cg"
    "Created: 5.8.1997 / 19:26:01 / cg"
!

info
    "return some object filled with the file's info;
     the info (for which corresponding access methods are understood by
     the returned object) is:

         type  - a symbol giving the files fileType
         mode  - numeric access mode
         uid   - owners user id
         gid   - owners group id
         size  - files size
         id    - files number (i.e. inode number)
         accessed      - last access time (as osTime-stamp)
         modified      - last modification time (as osTime-stamp)
         statusChangeTime - last staus change (as osTime-stamp)

     Some of the fields may be returned as nil on systems which do not provide
     all of the information.
     The minimum returned info (i.e. on all OS's) will consist of at least:
        modified
        size
        type

     Don't expect things like uid/gid/mode to be non-nil; write your application
     to either handle nil values,
     or (better) use one of isXXXX query methods. (Be prepared for DOS ...)
     (i.e. instead of:
        someFilename type == #directory
      use
        someFilename isDirectory
    "

    ^ OperatingSystem infoOf:(self osNameForAccess)

    "
     Filename currentDirectory info
     '/dev/null' asFilename info
     'Make.proto' asFilename info
     'source/Point.st' asFilename info
     'source/Point.st' asFilename linkInfo
     '../../libbasic/Point.st' asFilename info
     '.' asFilename info
     '..' asFilename info
     '..\..' asFilename info
     '..\..\..' asFilename info
     '..\..\..\..' asFilename info
     'c:\' asFilename info
    "

    "Modified: / 17-08-1998 / 10:24:10 / cg"
    "Modified (comment): / 21-03-2014 / 00:35:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linkInfo
    "return the file's info. If it is a symbolic link return the info of the link itself
     instead of the link's target.
     The information is the same as returned by #info, except that if the
     receiver represents a symbolic link, the links information
     is returned
     (while in this case, #info returns the info of the target file,
      which is accessed via the symbolic link).

     In addition to the normal entries, Unix returns an additional entry:
	 path -> the target files pathname

     See the comment in #info for more details."

    ^ OperatingSystem linkInfoOf:(self osNameForAccess)

    "
     Filename currentDirectory linkInfo
     '/dev/null' asFilename linkInfo
     'Make.proto' asFilename linkInfo
     'Make.proto' asFilename linkInfo path
     'source/Point.st' asFilename linkInfo
     '../../libbasic/Point.st' asFilename linkInfo
     '/usr/tmp' asFilename linkInfo
    "

    "Modified: 1.11.1996 / 20:49:09 / cg"
!

modificationTime
    "return a timeStamp containing the file's modification time."

    |i|

    (i := self info) isNil ifTrue:[^ nil].      "/ non-existing
    ^ i modificationTime

    "
     Filename currentDirectory modificationTime
    "

    "Created: / 9.7.1996 / 10:18:59 / cg"
    "Modified: / 26.9.1997 / 13:05:39 / stefan"
    "Modified: / 14.8.1998 / 17:42:50 / cg"
!

type
    "return the symbolic type of the file"

    ^ OperatingSystem typeOf:(self osNameForAccess)

    "
     Filename currentDirectory type
    "

    "Modified: 9.7.1996 / 10:19:27 / cg"
    "Created: 5.8.1997 / 19:31:26 / cg"
! !

!Filename methodsFor:'file utilities'!

edit
    "start an editView on the file represented by the receiver"

    EditTextView openOn:self asString

    "
     'smalltalk.rc' asFilename edit
    "
!

fileIn
    "load source code from the file"

    ^ (ProgrammingLanguage forFile: self) fileIn: self

    "Modified: / 16-08-2009 / 13:27:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Filename methodsFor:'instance creation'!

/ subname
    "Same as construct: Taking the receiver as a directory name, construct a new
     filename for an entry within this directory
     (i.e. for a file or a subdirectory in that directory).
     The argument may not specify an absolute path name.
     Please do not use this to create filenames with suffixes,
     since some systems require special naming conventions.
     See also: #withSuffix: (which is different, but often needed).
     Thanks to Jan Vrany for this idea."

    ^ self construct:subname

    "
     '/tmp' asFilename / 'foo'
     '/' asFilename / 'foo' / 'bar' / 'baz'
     '/foo/bar' asFilename / ('baz' asFilename)

     Bad example; works on UNIX, but may not on others:
       'foo/bar.baz' / '.suff'
    "
!

construct:subname
    "taking the receiver as a directory name, construct a new
     filename for an entry within this directory
     (i.e. for a file or a subdirectory in that directory).
     The argument may not specify an absolute path name.
     Please do not use this to create filenames with suffixes,
     since some systems require special naming conventions.
     See also: #withSuffix: (which is different, but often needed)."

    |constructedName|

    constructedName := self constructString:subname.
    ^ self species named:constructedName.

    "
     '/tmp' asFilename construct:'foo'
     '/' asFilename construct:'foo'
     '/usr/tmp' asFilename construct:'foo'
     '/foo/bar' asFilename construct:'baz'
     '/foo/bar' asFilename construct:'baz' asFilename

     Bad example; works on UNIX, but may not on others:
       'foo/bar.baz' asFilename construct:'.suff'
    "

    "Modified: 29.2.1996 / 20:55:06 / cg"
!

constructDirectory:subname
    "same as #construct: on most systems.
     (may allow different/relaxed name syntax of the argument on some systems)"

    ^ self species named:(self constructDirectoryString:subname)
!

constructDirectoryString:subName
    "same as #constructString: on most systems.
     (may allow different/relaxed name syntax of the argument on some systems)"

    ^ self constructString:subName
!

constructString:subName
    "taking the receiver as a directory name, construct a new
     filename-string for an entry within this directory
     (i.e. for a file or a subdirectory in that directory).
     The argument may not specify an absolute path name.
     The code below works for UNIX & MSDOS;
     other filename classes (i.e. VMS) may want to redefine this method."

    |sepString sub|

    sub := subName asString.
    nameString size == 0 ifTrue:[
        ^ sub
    ].
    sepString := self species separatorString.
    (nameString endsWith:sepString) ifTrue:[
        ^ nameString , sub
    ].
    ^ nameString , sepString , sub

    "
     '/tmp' asFilename constructString:'foo'
     '/' asFilename constructString:'foo'
     '/usr/tmp' asFilename constructString:'foo'
     '/foo/bar' asFilename constructString:'baz'
     '' asFilename constructString:'baz'
    "

    "Modified: / 7.9.1995 / 10:15:22 / claus"
    "Created: / 9.9.1997 / 08:57:08 / cg"
    "Modified: / 20.1.1998 / 15:58:23 / md"
    "Modified: / 27.7.1998 / 19:47:51 / cg"
!

filenameFor:fileName
    "return a filename representing the argument, fileName
     either in myself (if the arg is a releative path) or absolute otherwise."

    |f|

    f := fileName asFilename.
    f isAbsolute ifTrue:[^ f].
    ^ (self construct:fileName)

    "
     '/tmp' asFilename filenameFor:'foo'
     '/tmp' asFilename filenameFor:'/foo'
    "

    "Created: 18.9.1997 / 14:34:14 / stefan"
!

secureConstruct:subname
    "taking the receiver as a directory name, construct a new
     filename for an entry within this directory
     (i.e. for a file or a subdirectory in that directory).
     The argument may not specify an absolute path name.
     Please do not use this to create filenames with suffixes,
     since some systems require special naming conventions.
     See also: #withSuffix: (which is different, but often needed).

     This method differs from #construct:, by not permitting subName
     to navigate above (via ..) the current filename."

    ^ self species named:(self secureConstructString:subname)

    "
     '/tmp' asFilename secureConstruct:'foo'
     '/tmp' asFilename secureConstruct:'../foo'
     '/tmp' asFilename secureConstruct:'/./foo'
     '/tmp' asFilename secureConstruct:'foo/../bar'
     '/' asFilename secureConstruct:'foo'
     '/usr/tmp' asFilename secureConstruct:'foo'
     '/foo/bar' asFilename secureConstruct:'baz'
     '/foo/bar' asFilename secureConstruct:'baz' asFilename

     Bad example; works on UNIX, but may not on others:
       'foo/bar.baz' secureConstruct:'.suff'
    "

    "Modified: 29.2.1996 / 20:55:06 / cg"
!

secureConstructString:subName
    "taking the receiver as a directory name, construct a new
     filename-string for an entry within this directory
     (i.e. for a file or a subdirectory in that directory).

     This method differs from #constructString, by not permitting subName
     to navigate above (via ..) the current filename.

     The code below works for UNIX & MSDOS;
     other filename classes (i.e. VMS) may want to redefine this method."

    |sepString sub normalizedPath pathStream|

    sepString := self species separatorString.
    sub := subName asString.

    sub := sub asCollectionOfSubstringsSeparatedByAll:sepString.
    normalizedPath := OrderedCollection new:sub size.
    sub do:[:eachPathComponent|
	eachPathComponent = '..' ifTrue:[
	    normalizedPath isEmpty ifTrue:[
		self error:'secureConstruct: - trying to escape from: ', nameString.
	    ].
	    normalizedPath removeLast.
	] ifFalse:[(eachPathComponent notEmpty and:[eachPathComponent ~= '.']) ifTrue:[
	    normalizedPath add:eachPathComponent.
	]]
    ].
    pathStream := CharacterWriteStream with:nameString.
    (nameString notEmpty and:[(nameString endsWith:sepString) not]) ifTrue:[
	pathStream nextPutAll:sepString.
    ].
    normalizedPath do:[:eachPathComponent|
	pathStream nextPutAll:eachPathComponent.
    ] separatedBy:[
	pathStream nextPutAll:sepString.
    ].

    ^ pathStream contents.

    "
     '/tmp' asFilename secureConstructString:'fooŠ'
     '/tmp' asFilename secureConstructString:'../foo'
     '/tmp' asFilename secureConstructString:'foo/../bla'
     '/tmp' asFilename secureConstructString:'foo/./bla'
     '/tmp' asFilename secureConstructString:'/bla/foo/../../foo'
     '/' asFilename secureConstructString:'foo'
     '/usr/tmp' asFilename secureConstructString:'foo'
     '/foo/bar' asFilename secureConstructString:'baz'
     '' asFilename secureConstructString:'baz'
     '' asFilename secureConstructString:'/baz'
    "
! !

!Filename methodsFor:'misc'!

, aString
    "this allows filenames to understand how names are concatenated.
     Returns a string consisting of the receiver's name, concatenated
     by aString. Notice this is NOT the same as construct:, which inserts
     a directory delimiter and returns a new fileName instance.
     See also: #withSuffix: which is new and better."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #construct:'.
    ^ (nameString , aString asString)

    "
     'Makefile' asFilename , '.bak'
     ('Makefile' asFilename , '.bak') asFilename
     'Makefile' asFilename withSuffix:'bak'
     'Makefile' asFilename construct:'.bak'
    "

    "Modified: / 07-09-1997 / 23:45:36 / cg"
    "Modified (comment): / 01-04-2012 / 13:18:21 / cg"
!

canonicalize
    "normalize a filename by removing all empty path components or dots,
     and by resolving parent directory '..' references.

     The code below works for UNIX & MSDOS;
     other filename classes (i.e. VMS) may want to redefine this method."

    nameString := self species canonicalize:nameString.

    "
	'/tmp/bla' asFilename canonicalize.
	'/tmp/bla/../fasel' asFilename canonicalize.
	'/tmp/bla/.././/fasel' asFilename canonicalize.
	'..' asFilename canonicalize.
	'bla/../fasel' asFilename canonicalize.
	'//bla/../fasel' asFilename canonicalize.
    "
! !

!Filename methodsFor:'os shell'!

openExplorer
    "open a file-explorer on the directory represented by the receiver.
     On non-windows systems, an error is raised"

    OperatingSystem isMSWINDOWSlike ifFalse:[
	self warn:'sorry - this operation is only available under windows'.
    ].

    OperatingSystem
	openApplicationForDocument:self pathName
	operation:#explore.

    "Created: / 21-07-2012 / 12:28:18 / cg"
!

openFinder
    "open a finder on the directory represented by the receiver.
     On non-osx systems, an error is raised"

    OperatingSystem isOSXlike ifFalse:[
	self warn:'sorry - this operation is only available under osx'.
    ].

    OperatingSystem executeCommand:'open "',self pathName,'"'
!

openTerminal
    "open a terminal window on the directory represented by the receiver;
     on osx, a terminal app is opened,
     on windows a cmd.exe window,
     on unix, an xterm is opened."

    OperatingSystem isOSXlike ifTrue:[
        "/ I don't know yet how to tell the terminal to
        "/ go to a particular directory.
        "/ therefore, use the built in terminal
        VT100TerminalView openShellIn:self pathName.
        ^ self.
    ].
    "/ using the code below seems to close the window immediately
    "/ at least on win7.
    "/ use out own terminal, to make sure.
    (OperatingSystem isMSWINDOWSlike
    and:[OperatingSystem isWin7Like]) ifTrue:[
        "/ I don't know yet how to tell the terminal to
        "/ go to a particular directory.
        "/ therefore, use the built in terminal
        VT100TerminalView openShellIn:self pathName.
        ^ self.
    ].

    [
        |cmd|

        OperatingSystem isOSXlike ifTrue:[
            cmd := '/Applications/Utilities/Terminal.app/Contents/MacOS/Terminal '
        ] ifFalse:[
            OperatingSystem isMSWINDOWSlike ifTrue:[
                cmd := #('c:\windows\System32\cmd.exe')
            ] ifFalse:[
                "/ VT100TerminalView openShellIn:self pathName
                cmd := 'xterm'
            ]
        ].
        OperatingSystem
            executeCommand:cmd
            inDirectory:self pathName
            showWindow:#default.
    ] fork

    "Modified: / 18-10-2016 / 16:08:15 / cg"
! !

!Filename methodsFor:'printing & storing'!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    aStream nextPutAll:(self class name).
    aStream nextPutAll:'('''.
    nameString printOn:aStream.
    aStream nextPutAll:''')'

    "Modified: 7.9.1997 / 23:46:20 / cg"
!

storeOn:aStream
    "append a printed representation of the receiver to aStream,
     which allows reconstructing it via readFrom:"

    aStream nextPut:$(.
    nameString storeOn:aStream.
    aStream nextPutAll:' asFilename)'
! !

!Filename methodsFor:'private-accessing'!

getName
    <resource: #obsolete>
    "get the raw filename"

    ^ nameString
!

nameString
    "raw access to nameString - req'd for xml-store/reload"

    ^ nameString
!

nameString:aString
    "raw access to nameString - req'd for xml-store/reload"

    nameString := aString
!

setName:aString
    "set the filename"

    nameString := aString.

    "Modified: / 21.7.1998 / 10:44:18 / cg"
! !

!Filename methodsFor:'queries'!

exists
    "return true, if such a file exists."

    ^ OperatingSystem isValidPath:(self osNameForAccess)

    "
     '/foo/bar' asFilename exists
     '/tmp' asFilename exists
     'Makefile' asFilename exists
    "
!

filenamesMatching:aPattern
    "VW compatibility"

    ^ (self filesMatching:aPattern)
	    collect:[:eachName | self construct:eachName].

    "
     '/etc' asFilename filenamesMatching:'a*;c*'
    "

    "Created: / 15.4.1997 / 15:40:02 / cg"
    "Modified: / 3.8.1998 / 21:22:15 / cg"
!

filesMatching:aPattern
    "given the receiver, representing a directory;
     return a collection of files matching a pattern.
     The pattern may be a simple matchPattern, or a set of
     multiple patterns separated by semicolons."

    ^ OrderedCollection withCollectedContents:[:coll |
        self filesMatching:aPattern do:[:fn | coll add:fn]]

    "
     '/etc' asFilename filesMatching:'a*;c*'
    "

    "Created: / 15.4.1997 / 15:40:02 / cg"
    "Modified: / 3.8.1998 / 21:22:15 / cg"
!

filesMatching:aPattern caseSensitive:caseSensitive do:aBlock
    "given the receiver, representing a directory;
     evaluate aBlock for files which match a pattern.
     The pattern may be a simple matchPattern, or a set of
     multiple patterns separated by semicolons."

    |matchers|

    matchers := aPattern asCollectionOfSubstringsSeparatedBy:$;.
    self directoryContentsDo:[:name |
        (matchers contains:[:p | p match:name caseSensitive:caseSensitive]) ifTrue:[
            aBlock value:name
        ]
    ].    

    "
     '/etc' asFilename filesMatching:'a*;c*' do:[:f | Transcript showCR:f]
    "

    "Created: / 15.4.1997 / 15:40:02 / cg"
    "Modified: / 3.8.1998 / 21:22:15 / cg"
!

filesMatching:aPattern do:aBlock
    "given the receiver, representing a directory;
     evaluate aBlock for files which match a pattern.
     The pattern may be a simple matchPattern, or a set of
     multiple patterns separated by semicolons."

    self filesMatching:aPattern caseSensitive:self species isCaseSensitive do:aBlock

    "
     '/etc' asFilename filesMatching:'a*;c*' do:[:f | Transcript showCR:f]
    "

    "Created: / 15.4.1997 / 15:40:02 / cg"
    "Modified: / 3.8.1998 / 21:22:15 / cg"
!

filesMatchingWithoutDotDirs:aPattern
    "given the receiver, representing a directory;
     return a collection of files matching a pattern.
     Exclude '.' and '..' from the returned list.
     The pattern may be a simple matchPattern, or a set of
     multiple patterns separated by semicolons."

    ^ OrderedCollection withCollectedContents:[:coll |
        self filesMatchingWithoutDotDirs:aPattern do:[:fn | coll add:fn]]

    "
     Filename currentDirectory filesMatching:'.*'
     Filename currentDirectory filesMatchingWithoutDotDirs:'*.*'
     '/etc' asFilename filesMatchingWithoutDotDirs:'*'
    "

    "Created: / 15.4.1997 / 12:52:10 / cg"
    "Modified: / 3.8.1998 / 21:22:30 / cg"
!

filesMatchingWithoutDotDirs:aPattern caseSensitive:caseSensitive do:aBlock
    "given the receiver, representing a directory;
     evaluate aBlock for files matching a pattern.
     Exclude '.' and '..'.
     The pattern may be a simple matchPattern, or a set of
     multiple patterns separated by semicolons."

    |matchers|

    matchers := aPattern asCollectionOfSubstringsSeparatedBy:$;.

    self directoryContentsDo:[:name |
        (name ~= '.'
            and:[ name ~= '..'
            and:[ (matchers contains:[:p | p match:name caseSensitive:caseSensitive]) ]])
        ifTrue:[
            aBlock value:name
        ]
    ].
    
    "
     Filename currentDirectory filesMatching:'M*'
     '/etc' asFilename filesMatching:'[a-z]*'
     '../../libbasic' asFilename filesMatching:'[A-D]*.st'
    "

    "Created: / 15.4.1997 / 12:52:10 / cg"
    "Modified: / 3.8.1998 / 21:22:30 / cg"
!

filesMatchingWithoutDotDirs:aPattern do:aBlock
    "given the receiver, representing a directory;
     evaluate aBlock for files matching a pattern.
     Exclude '.' and '..'.
     The pattern may be a simple matchPattern, or a set of
     multiple patterns separated by semicolons."

    self filesMatchingWithoutDotDirs:aPattern caseSensitive:self species isCaseSensitive do:aBlock

    "
     Filename currentDirectory filesMatching:'M*'
     '/etc' asFilename filesMatching:'[a-z]*'
     '../../libbasic' asFilename filesMatching:'[A-D]*.st'
    "

    "Created: / 15.4.1997 / 12:52:10 / cg"
    "Modified: / 3.8.1998 / 21:22:30 / cg"
!

fullAlternativePathName
    "some filesystems (aka: windows) have alternative (short) filenames.
     Those systems redefine this method to return it.
     Otherwise, the same as the regular name is returned here"
     
    ^ nameString
!

isExecutable
    "return true, if such a file exists and is executable (by Unix's definition).
     For directories, true is returned if the directory can be entered.
     See isExecutableProgram for a related check."

    ^ OperatingSystem isExecutable:(self osNameForAccess)

    "
     '/foo/bar' asFilename isExecutable
     '/tmp' asFilename isExecutable
     'Makefile' asFilename isExecutable
     '/bin/ls' asFilename isExecutable
    "
!

isExecutableProgram
    "return true, if such a file exists and is an executable program.
     (i.e. for directories, false is returned.)"

    |osName|

    osName := self osNameForAccess.
    ^ (OperatingSystem isExecutable:osName)
      and:[(OperatingSystem isDirectory:osName) not]

    "
     '/tmp' asFilename isExecutable
     '/bin/ls' asFilename isExecutable
     '/tmp' asFilename isExecutableProgram
     '/bin/ls' asFilename isExecutableProgram
     
     'ls' asFilename isExecutableProgram
     OperatingSystem canExecuteCommand:'ls'
    "
!

isHidden
    "return true, if the receiver represents a hidden file.
     The definitions of hidden files depends on the OS used;
     on UNIX, a name starting with a period is considered hidden;
     on MSDOS, the file's hidden attribute is also used.
     VMS has no concept of hidden files."

    ^ false
!

isMountPoint:aPathName
    "return true, if I represent a mount-point.
     Warning:
	the receiver must be an absolute pathname,
	because a realPath is not used/generated for the query (to avoid automounting).
	Aka: do not ask: '../../' asFilename isMountPoint;
    "

    self isAbsolute ifFalse:[
	self error:'this query must be done on an absolute pathname'.
    ].
    ^ OperatingSystem isMountPoint:(self name)
!

isReadable
    "return true, if such a file exists and is readable."

    ^ OperatingSystem isReadable:(self osNameForFile)

    "
     '/foo/bar' asFilename isReadable
     '/tmp' asFilename isReadable
     'Makefile' asFilename isReadable
    "
!

isSharedLibrary
    "return true, if such a file exists and is a shared library."

    ObjectFileLoader isNil ifTrue:[
	"we cannot handle shared libraries, so there are no shared libraries"
	^ false.
    ].
    ^ (ObjectFileLoader validBinaryExtensions includes:self suffix)
	and:[self isRegularFile].

    "
     'libstx_libbasic.so' asFilename isSharedLibrary
     'libstx_libbasic.dll' asFilename isSharedLibrary
     '/tmp' asFilename isSharedLibrary
     '/tmp.dll' asFilename isSharedLibrary
    "
!

isWritable
    "return true, if such a file exists and is writable."

    ^ OperatingSystem isWritable:(self osNameForFile)

    "
     '/foo/bar' asFilename isWritable
     '/tmp' asFilename isWritable
     'Makefile' asFilename isWritable
    "
!

isWritableDirectory
    "return true, if such a directory exists and is writable.
     Don't believe #isWritable, since on an NFS mounted filesystem
     with UID mapping and attribute cache enabled, there may be false negatives."

    self isDirectory ifFalse:[
	^ false.
    ].

    self isWritable ifFalse:[
	"/ on an NFS mounted filesystem with UID mapping and
	"/ attribute cache enabled,
	"/ this query may fail, but creation may work actually.
	"/ check again...
	[
	    |tempFile|

	    tempFile := FileStream newTemporaryIn:self.
	    tempFile close.
	    tempFile fileName remove.
	] on:OpenError do:[:ex|
	    ^ false.
	].
    ].
    ^ true.

    "
     '/foo/bar' asFilename isWritableDirectory
     '/tmp' asFilename isWritableDirectory
     '/etc' asFilename isWritableDirectory
     'Makefile' asFilename isWritableDirectory
     '/net/exeptn/home2/office' asFilename isWritable
     '/net/exeptn/home2/office' asFilename isWritableDirectory
    "
!

separator
    "return the directory-separator character"

    ^ self species separator

    "Modified: 29.2.1996 / 20:52:01 / cg"
!

species
    "create only new instances of the concrete OS specific class.
     Redefined in AutoDeletedFilename, to not create AutoDeleted instances
     per default (from directories etc.)"

    self == Filename ifTrue:[
	^ ConcreteClass.
    ] ifFalse:[
	^ self class.
    ].
!

withSpecialExpansions
    "return a new filename, expanding any OS specific macros.
     Here, a ~/ prefix is expanded to the users home dir (as in bash)"

    |newName|

    newName := self species nameWithSpecialExpansions:nameString.
    newName = nameString ifTrue:[
	^ self.
    ].
    ^ self species named:newName.

    "
     '~' asFilename withSpecialExpansions
     '~/Desktop' asFilename withSpecialExpansions
     '~stefan' asFilename withSpecialExpansions
     '~stefan/Desktop' asFilename withSpecialExpansions
    "
! !

!Filename methodsFor:'queries-contents'!

mimeTypeFromName
    "return the mimeType as guessed from the file's name/and or extension.
     This could be less accurate than mimeTypeOfContents, but avoids
     reading the file (is therefore much faster).
     Also it works with non-existing files.
     Returns nil for directories and other non-regular files."

    |mimeTypes|

    "/ kludge to avoid making libview a prereq. of libbasic
    (mimeTypes := Smalltalk at:#MIMETypes) notNil ifTrue:[
	^ mimeTypes mimeTypeForFilename:(self name)
    ].
    ^ nil

    "
     'Makefile' asFilename mimeTypeFromName
     '.' asFilename mimeTypeFromName
     '/dev/null' asFilename mimeTypeFromName
     '/tmp/.X11-unix/X0' asFilename mimeTypeFromName
     'smalltalk.rc' asFilename mimeTypeFromName
     'bitmaps/SBrowser.xbm' asFilename mimeTypeFromName
     '../../rules/stmkmf' asFilename mimeTypeFromName
     '/bläh' asFilename mimeTypeFromName
     '/x.zip' asFilename mimeTypeFromName
     '/x.gz' asFilename mimeTypeFromName
    "
!

mimeTypeOfContents
    "this tries to guess the mime type of contents of
     the file. Returns nil, if the file is unreadable, not a plain file
     or the contents is unknown.
     This is done using some heuristics, and may need some improvement"

    |type buffer s size mimeTypes|

    type := self type.
    type isNil ifTrue:[ ^ nil ].
    type == #directory ifTrue:[ ^ nil ].
    type == #characterSpecial ifTrue:[ ^ nil ].
    type == #blockSpecial ifTrue:[ ^ nil ].
    type == #socket ifTrue:[ ^ nil ].
    self fileSize == 0 ifTrue:[^ nil].

    s := self readStreamOrNil.
    s isNil ifTrue:[^ nil].

    "/ read some data from the file ...
    buffer := String new:2048.

    s errorSignal handle:[:ex |
	size := 0.
    ] do:[
	size := s nextBytes:buffer size into:buffer.
    ].
    s close.

    "/ kludge to avoid making libview a prereq. of libbasic
    (mimeTypes := Smalltalk at:#MIMETypes) notNil ifTrue:[
	^ mimeTypes mimeTypeOfData:buffer suffix:self suffix.
    ].
    ^ nil

    "
     'Makefile' asFilename mimeTypeOfContents
     '.' asFilename mimeTypeOfContents
     '/dev/null' asFilename mimeTypeOfContents
     '/tmp/.X11-unix/X0' asFilename mimeTypeOfContents
     'smalltalk.rc' asFilename mimeTypeOfContents
     'bitmaps/SBrowser.xbm' asFilename mimeTypeOfContents
     '../../rules/stmkmf' asFilename mimeTypeOfContents
     '/bläh' asFilename mimeTypeOfContents
     'C:\Dokumente und Einstellungen\cg\Favoriten\languages.lnk' asFilename mimeTypeOfContents
     'G:\A\A01.TOP' asFilename mimeTypeOfContents
    "

    "Modified: / 06-11-2006 / 11:44:58 / cg"
! !

!Filename methodsFor:'queries-path & name'!

baseName
    "return my baseName as a string.
     - that's the file/directory name without leading parent-dirs.
     (i.e. '/usr/lib/st/file' asFilename baseName -> 'file'
       and '/usr/lib'         asFilename baseName -> lib).
     This method does not check if the path is valid.
     The code here should work for Unix and MSDOS, but needs to be redefined
     for VMS (and maybe others as well).
     See also: #pathName, #directoryName and #directoryPathName.
     Compatibility note: use #tail for ST-80 compatibility."

    |len index sep endIdx|

    sep := self separator.
    len := nameString size.
    ((len == 1) and:[(nameString at:1) == sep]) ifTrue:[
        ^ nameString
    ].

    endIdx := len.
    len > 1 ifTrue:[
        (nameString at:len) == sep ifTrue:[endIdx := endIdx - 1].
    ].
    index := nameString lastIndexOf:sep startingAt:len-1.
    ^ nameString copyFrom:(index+1) to:endIdx

    "
     '/foo/bar' asFilename baseName
     '/foo/bar.cc' asFilename baseName
     '.' asFilename baseName
     '..' asFilename baseName
     '../..' asFilename baseName
     '../../libbasic' asFilename baseName
     '../../libpr' asFilename baseName
     '../../libbasic/Object.st' asFilename baseName
     '/' asFilename baseName
     '\' asFilename baseName
     'c:\' asFilename baseName
     '\\idefix' asFilename baseName
    "

    "Modified: / 24.9.1998 / 13:06:23 / cg"
!

directory
    "return the directory name part of the file/directory as a new filename.
     - that's a filename for the directory where the file/dir represented by
       the receiver is contained in.
     (this is almost equivalent to #directoryName or #head, but returns
      a Filename instance instead of a string )."

    ^ self species named:(self directoryName)

    "
     '/foo/bar' asFilename directory
     '/foo/bar' asFilename directoryName
     '/foo/bar' asFilename head

     '.' asFilename directory
     '..' asFilename directory
     '../..' asFilename directory
    "

    "Modified: 29.2.1996 / 20:50:14 / cg"
!

directoryName
    "return the directory name part of the file/directory as a string.
     - that's the name of the directory where the file/dir represented by
       the receiver is contained in.
     This method does not check if the path is valid.

     (i.e. '/usr/lib/st/file' asFilename directoryName -> '/usr/lib/st'
       and '/usr/lib' asFilename directoryName         -> /usr').

     (this is almost equivalent to #directory, but returns
      a string instead of a Filename instance).

     See also: #pathName, #directoryPathName and #baseName.
     Compatibility note: use #head for ST-80 compatibility."

    |index sep sepString p rest parentDirectoryString|

    sep := self separator.
    sepString := sep asString.
    (nameString = sepString) ifTrue:[
        "/
        "/ the trivial '/' case
        "/
        ^ sepString
    ].

    "/
    "/ strip off multiple trailing slashes
    "/
    p := nameString.
    [p endsWith:sep] whileTrue:[
        (p = sepString) ifTrue:[
            ^ sepString
        ].
        p := p copyButLast:1
    ].

    parentDirectoryString := self class parentDirectoryName.

    "/ strip off trailing components
    index := p lastIndexOf:sep startingAt:p size.
    index == 0 ifTrue:[
        "/ no separator found
        p = '.' ifTrue:[
            ^ parentDirectoryString
        ].
        p = '..' ifTrue:[
            ^ parentDirectoryString, sepString, parentDirectoryString
        ].
        ^ '.'
    ].
    rest := p copyFrom:(index+1).
    (rest = '.') ifTrue:[
        ^ p copyTo:index-1.
    ].
    (rest = parentDirectoryString) ifTrue:[
        ^ (self species named:(p copyTo:(index-1))) directoryName
    ].
    index == 1 ifTrue:[
        ^ sepString
    ].
    ^ p copyTo:(index - 1)

    "
     '/home' asFilename directoryName
     '/foo/bar/' asFilename directoryName
     '/foo/bar/' asFilename directory

     '/foo/bar' asFilename directoryName
     'bitmaps' asFilename directoryName
     'bitmaps' asFilename directoryPathName
     '.' asFilename directoryName
     '.' asFilename directoryPathName
     '..' asFilename directoryName
     '..' asFilename directoryPathName
     '../..' asFilename directoryName
     '../..' asFilename directoryPathName
     '/foo/bar/baz/..' asFilename directoryName
     '/foo/bar/baz/.' asFilename directoryName
     'c:\' asFilename directoryName
    "

    "Modified: / 7.9.1995 / 10:42:03 / claus"
    "Modified: / 21.10.1998 / 22:52:25 / cg"
    "Modified: / 27.10.1998 / 13:19:26 / ps"
!

directoryPathName
    "return the full directory pathname part of the file/directory as a string.
     - that's the full pathname of the directory where the file/dir represented by
       the receiver is contained in.
     See also: #pathName, #directoryName, #directory and #baseName"

    ^ (self species named:self pathName) directoryName

    "
     '/foo/bar/' asFilename directoryPathName
     '/foo/bar' asFilename directoryPathName

     '.' asFilename directoryPathName
     '.' asFilename directoryName
     '.' asFilename directory

     '..' asFilename directoryPathName
     '..' asFilename directoryName
     '..' asFilename directory

     '../..' asFilename directoryPathName
    "

    "Modified: 7.9.1995 / 10:42:13 / claus"
    "Modified: 21.12.1996 / 15:21:57 / cg"
!

encodedNameString
    "answer the name as passed to OS system calls"

    ^ OperatingSystem encodePath:nameString
!

filenameCompletion
    "try to complete the receiver filename.
     BAD DESIGN: has side effect on the receiver.
     This method has both a return value and a side effect on the receiver:
       it returns a collection of matching filename objects,
       and changes the receiver's filename-string to the longest common
       match.
     If none matches, the returned collection is empty and the receiver is unchanged.
     If there is only one match, the size of the returned collection is exactly 1,
     containing the fully expanded filename and the receiver's name is changed to it."

    ^ self filenameCompletionIn:nil

    "
     'mak' asFilename filenameCompletion
     'Make' asFilename filenameCompletion
     'Makef' asFilename filenameCompletion;yourself
     '/u' asFilename filenameCompletion
     '../../libpr' asFilename inspect filenameCompletion
    "

    "Modified: 3.7.1996 / 10:53:51 / cg"
!

filenameCompletionIn:aDirectory
    "try to complete the receiver filename.

     BAD DESIGN: has side effect on the receiver.
     This method has both a return value and a side effect on the receiver:
       it returns a collection of matching filename objects,
       and changes the receiver's filename-string to the longest common match.
     If none matches, the returned collection is empty and the receiver is unchanged.
     If there is only one match, the size of the returned collection is exactly 1,
     containing the fully expanded filename and the receiver's name is changed to it.
     An empty baseName pattern (i.e. giving the name of a directory) will also return an empty matchset."

    |mySpecies dir baseName matching matchLen try allMatching
     sepString parentString prefix nMatch nm caseless lcBaseName|

    mySpecies := self species.

    caseless := mySpecies isCaseSensitive not.
    matching := OrderedCollection new.

    nm := mySpecies nameWithSpecialExpansions:nameString.
    nm := mySpecies canonicalize:nm.

    sepString := mySpecies separatorString.
    (nm endsWith:sepString) ifTrue:[
	"/ two exceptions here:
	"/   if there is only one file in the directory, that one must be it.
	"/   otherwise, return the longest common prefix of all files.
	self isDirectory ifTrue:[
	    |first longest|

	    first := nil.
	    OpenError catch:[
		self directoryContentsDo:[:fileName |
		    ((fileName ~= '.') and:[fileName ~= parentString]) ifTrue:[
			matching add:fileName.
			first isNil ifTrue:[
			    first := longest := fileName.
			] ifFalse:[
			    "/ more than one file
			    longest := longest commonPrefixWith:fileName ignoreCase:caseless.
			    longest isEmpty ifTrue:[
				^ #()
			    ].
			]
		    ]
		].
	    ].
	    longest notNil ifTrue:[
		nameString := (self constructString:longest).
		 ^ matching
	    ].
	].
	^ #()
    ].

    parentString := mySpecies parentDirectoryName.
    baseName := self baseName.
    baseName ~= nm ifTrue:[
	prefix := self directoryName.
    ].

    self isAbsolute ifTrue:[
	dir := self directory
    ] ifFalse:[
	aDirectory isNil ifTrue:[
	    dir := self directory
	] ifFalse:[
	    dir := (aDirectory asFilename construct:nm) directory
	]
    ].

    caseless ifTrue:[
	lcBaseName := baseName asLowercase
    ].

    dir class errorReporter openErrorSignal handle:[:ex|
	^ #().
    ] do:[
	dir directoryContents do:[:fileName |
	    ((fileName ~= '.') and:[fileName ~= parentString]) ifTrue:[
		((caseless and:[fileName asLowercase startsWith:lcBaseName])
		or:[caseless not and:[fileName startsWith:baseName]]) ifTrue:[
		    matching add:fileName
		]
	    ]
	].
    ].

    (nMatch := matching size) > 1 ifTrue:[
	"
	 find the longest common prefix
	"
	matchLen := baseName size.
	matchLen > matching first size ifTrue:[
	    try := baseName.
	    allMatching := false
	] ifFalse:[
	    try := matching first copyTo:matchLen.
	    allMatching := true.
	].

	[allMatching] whileTrue:[
	    matching do:[:aName |
		((caseless and:[aName asLowercase startsWith:try asLowercase])
		or:[caseless not and:[aName startsWith:try]]) ifFalse:[
		    allMatching := false
		]
	    ].
	    allMatching ifTrue:[
		matchLen <  matching first size ifTrue:[
		    matchLen := matchLen + 1.
		    try := matching first copyTo:matchLen.
		] ifFalse:[
		    allMatching := false
		]
	    ] ifFalse:[
		try := matching first copyTo:matchLen - 1.
	    ]
	].
	"
	 and set my name to the last full match
	"
	nameString := nm := try
    ].

    "
     if I had a directory-prefix, change names in collection ...
    "
    prefix notNil ifTrue:[
	(prefix endsWith:sepString) ifTrue:[
	    "/ avoid introducing double slashes
	    prefix := prefix copyButLast:(sepString size).
	].
	matching := matching collect:[:n | prefix , sepString , n].
	nMatch == 1 ifTrue:[
	    nameString := nm := matching first
	] ifFalse:[
	    nMatch > 1 ifTrue:[
		nameString := nm := prefix , sepString , nm
	    ]
	]
    ] ifFalse:[
	nMatch == 1 ifTrue:[
	    nameString := nm := matching first
	]
    ].

    "
     return the match-set, so caller can decide what to do
     (i.e. show the matches, output a warning etc ...)
    "
    ^ matching

    " trivial cases:

     '../' asFilename filenameCompletion     -> empty
     '/' asFilename filenameCompletion       -> empty
     '/usr/' asFilename filenameCompletion   -> empty

     'mak' asFilename filenameCompletion
     'Make' asFilename filenameCompletion
     'Makef' asFilename filenameCompletion
     '/u' asFilename filenameCompletion
     '../../libpr' asFilename filenameCompletion
     '/etc/mail/auth/xx' asFilename filenameCompletion

     'c:\pr' asFilename filenameCompletion             -> matching names
     'c:\pr' asFilename filenameCompletion; yourself   -> side effect: name changed to longest match
     'c:\p' asFilename filenameCompletion
     'c:\' asFilename filenameCompletion  -> empty
     'c:' asFilename filenameCompletion   -> empty
     '\' asFilename filenameCompletion    -> empty
    "

    "Modified: / 22-09-1997 / 18:03:33 / stefan"
    "Modified: / 17-11-2007 / 14:31:08 / cg"
!

head
    "return the directory name as a string.
     An alias for directoryName, for ST-80 compatiblity.
     (this is almost equivalent to #directory, but returns
      a string instead of a Filename instance)"

    ^ self directoryName

    "
     Filename currentDirectory head
     'Makefile' asFilename head
     '/foo/bar/baz.st' asFilename head
    "

    "Modified: 29.2.1996 / 20:21:25 / cg"
!

isAbsolute
    "return true, if the receiver represents an absolute pathname
     (in contrast to one relative to the current directory)."

    ((nameString startsWith:self species separator) or:[nameString startsWith:$~]) ifTrue:[^ true].
    ^ self isVolumeAbsolute

    "
     '/foo/bar' asFilename isAbsolute
     '~/bla' asFilename isAbsolute
     '..' asFilename isAbsolute
     '..' asFilename asAbsoluteFilename isAbsolute
     'source/SBrowser.st' asFilename isAbsolute
     'source/SBrowser.st' asFilename isRelative
     'SBrowser.st' asFilename isRelative
    "
!

isExplicitRelative
    "return true, if this name is an explicit relative name
     (i.e. starts with './' or '../', to avoid path-prepending)"

    ^ false
!

isImplicit
    "return true, if the receiver represents a builtin file.
     The definitions of builtin files depends on the OS used;
     on UNIX, '.' and '..' are builtin names."

    ^ false

    "Created: 18.9.1997 / 18:04:51 / stefan"
!

isParentDirectoryOf:aFilenameOrString
    "Answer true, if myself is a parent directory of aFilenameOrString.
     Unexpected results may be returned, if one of myself or aFilenameOrString does
     not exist and relative and absolute path names are mixed
     ('/' asFilename isParentDirectoryOf:'../noExistent' -> false)

     Warning: maybe symbolic links must be resolved which could lead to automounting"

    |filenameArg otherNames myNames myName|

    filenameArg := aFilenameOrString asFilename.

    "first do a simple comparison"
    otherNames := self class canonicalizedNameComponents:filenameArg name.
    myNames := self class canonicalizedNameComponents:self name.
    ((otherNames startsWith:myNames) and:[myNames first ~= self class parentDirectoryName]) ifTrue:[
	^ otherNames ~= myNames
    ].

    "fall back - try it again with ~ substitution and symbolic links resolved"
    otherNames := self class canonicalizedNameComponents:filenameArg pathName.
    myNames := self class canonicalizedNameComponents:self pathName.
    (otherNames startsWith:myNames) ifTrue:[
	^ otherNames ~= myNames
    ].

    myName := self class nameFromComponents:myNames.
    filenameArg allParentDirectoriesDo:[:parent |
	parent pathName = myName ifTrue:[^ true].
    ].
    ^ false.

    "
     '/etc' asFilename isParentDirectoryOf:'/etc/passwd'
     'etc' asFilename isParentDirectoryOf:'etc/passwd'
     '/etc' asFilename isParentDirectoryOf:'/etc/'
     '/etc' asFilename isParentDirectoryOf:'/etc'
     '/et' asFilename isParentDirectoryOf:'/etc'
     '/home' asFilename isParentDirectoryOf:Filename currentDirectory
     '~' asFilename isParentDirectoryOf:Filename currentDirectory
     '~' asFilename isParentDirectoryOf:'.'
     '~' asFilename isParentDirectoryOf:'..'
     '~' asFilename isParentDirectoryOf:'../smalltalk'
     '../..' asFilename isParentDirectoryOf:'../nonExistent'
     '..' asFilename isParentDirectoryOf:'../../nonExistent'
     '/' asFilename isParentDirectoryOf:'../nonExistent'
     '/' asFilename isParentDirectoryOf:'/phys/qnx'
    "
!

isRelative
    "return true, if this name is interpreted relative to some
     directory (opposite of absolute)"

    ^ self isAbsolute not

    "
     './foo/bar' asFilename isRelative
     '../../foo/bar' asFilename isRelative
     '/foo/bar' asFilename isRelative
     'bar' asFilename isRelative
    "

    "Modified: 16.1.1997 / 01:19:14 / cg"
!

isRootDirectory
    "return true, if I represent the root directory
     (i.e. I have no parentDir)"

    "/ mhmh - should we use:
    "/
    "/ parentDir := self construct:'..'.
    "/ (parentDir exists
    "/ and:[parentDir isDirectory
    "/ and:[parentDir id ~= self id]]) ifTrue:[
    "/    ^ false
    "/ ].
    "/ ^ true
    "/

    ^ self pathName = Filename rootDirectory pathName

    "Modified: 23.10.1997 / 00:38:35 / cg"
!

isVolumeAbsolute
    "return true, if the receiver represents an absolute pathname
     on some disk volume (MSDOS only)"

    ^ false

    "Modified: 7.9.1997 / 23:54:33 / cg"
!

localPathName
    "return the full pathname of the file represented by the receiver,
     but without any volume information.
     Only makes a difference on MSDOS & VMS systems."

    ^ self pathName
!

name
    "return the name of the file represented by the receiver as a string.
     This may or may not be a relative name (i.e. include ..'s).
     See also: pathName"

"/    self isAbsolute ifTrue:[^ self pathName].
    ^ nameString

    "
     '/foo/bar' asFilename name
     '/foo/bar' asFilename pathName
     '.' asFilename name
     '.' asFilename pathName
     '../..' asFilename name
     '../..' asFilename pathName
     'bitmaps' asFilename name
     'bitmaps' asFilename pathName
     '/tmp/../usr' asFilename name
     '/tmp/../usr' asFilename pathName
     'source/..' asFilename name
     'source/..' asFilename pathName
     '/tmp/..' asFilename name
     '/tmp/..' asFilename pathName
    "

    "Modified: 18.1.1996 / 21:36:27 / cg"
!

pathName
    "return the full pathname of the file represented by the receiver,
     as a string. This will not include ..'s.
     If the path represented by the receiver does NOT represent a valid path,
     no compression will be done (for now; this may change).
     See also: name"


"/    sep := self class separator.
"/    (nameString startsWith:sep) ifTrue:[
"/        parentName := self class parentDirectoryName.
"/        (nameString findString:parentName) == 0 ifTrue:[
"/            ^ nameString
"/        ]
"/    ].
    ^ OperatingSystem pathNameOf:(self species nameWithSpecialExpansions:nameString).

    "
     '/foo/bar' asFilename pathName
     '.' asFilename pathName
     '../..' asFilename pathName
     '../..' asFilename name
     '/tmp/../usr' asFilename pathName
     '/././usr' asFilename pathName
     '~/..' asFilename pathName
    "

    "Modified: 27.4.1996 / 18:19:52 / cg"
!

physicalFilename
    "return the fileName representing the physical file as represented by the receiver,
     If the receiver represents a symbolic link, that's the fileName of the
     final target. Otherwise, its the receiver's pathName itself.
     If any file along the symbolic path does not exist (i.e. is a broken link),
     nil is returned."

    |pathOrNil|

    pathOrNil := self physicalPathName.
    pathOrNil isNil ifTrue:[
        ^ nil
    ].
    ^ pathOrNil asFilename

    "
     '/foo/bar' asFilename physicalFilename
    "
!

physicalPathName
    "return the full pathname of the physical file represented by the receiver,
     If the receiver represents a symbolic link, that's the fileName of the
     final target. Otherwise, its the receiver's pathName itself.
     If any file along the symbolic path does not exist (i.e. is a broken link),
     nil is returned."

    |t path info|

    info := self linkInfo.
    info isNil ifTrue:[
        " I do not exist"
        ^ nil.
    ].
    info isSymbolicLink ifFalse:[
        ^ self pathName
    ].

    t := self.
    [
        path := info path.
        path isNil ifTrue:[
            "/ cannot happen
            ^ nil
        ].
        path asFilename isAbsolute ifTrue:[
            t := path asFilename
        ] ifFalse:[
            t := (self species named:t directoryName) construct:path.
        ].
        info := t linkInfo.
        info isNil ifTrue:[
            "t does not exist"
             ^ nil
        ].
    ] doWhile:[info isSymbolicLink].

    ^ t pathName

    "
     '/foo/bar' asFilename physicalPathName
     '.' asFilename physicalPathName
     '../..' asFilename physicalPathName
     '/usr/tmp' asFilename physicalPathName
    "

    "Modified: 21.12.1996 / 15:29:50 / cg"
!

tail
    "the file's name without directory prefix as a string.
     An alias for baseName, for ST-80 compatiblity."

    ^ self baseName

    "
     Filename currentDirectory tail
     'Makefile' asFilename tail
     '/foo/bar/baz.st' asFilename tail
    "

    "Modified: 29.2.1996 / 20:19:50 / cg"
!

tail:nComponents
    "return the last n components of myself.
     - that's the file/directory name without leading parent-dirs.
     (i.e. '/usr/lib/st/file' asFilename tail:2 -> 'st/file'
       and '/usr/lib'         asFilename tail:1 -> lib).
     This method does not check if the path is valid.
     The code here should work for Unix and MSDOS, but needs to be redefined
     for VMS (and maybe others as well).
     See also: #pathName, #directoryName and #directoryPathName."

    |sep components tail start|

    sep := self species separator.
    components := self components.
    start := components size - nComponents + 1.
    start < 1 ifTrue:[
        start := 1.
    ].
    start = 1 ifTrue:[
        tail := ''
    ] ifFalse:[
        tail := components at:start.
    ].
    start+1 to:components size do:[:i|
        tail := tail, sep, (components at:i).
    ].
    ^ tail.


    "
     '/foo/bar' asFilename tail:1
     '/foo/bar' asFilename tail:2
     '/foo/bar' asFilename tail:3
     '/foo/bar.cc' asFilename tail:2
     '.' asFilename tail:3
     '..' asFilename tail:3
     '../..' asFilename tail:2
     '../../libbasic' asFilename tail:2
     '../../libbasic' asFilename asCanonicalizedFilename tail:2
     '../../libpr' asFilename tail:2
     '../../libbasic/Object.st' asFilename asCanonicalizedFilename tail:2
     '/' asFilename tail:2
     '\' asFilename tail:2
     'c:\' asFilename tail:2
     '\\idefix' asFilename tail:2
    "
!

volume
    "return the disc volume part of the name or an empty string.
     This is only used with MSDOS and VMS filenames
     - by default (and on unix), an empty string is returned"

    ^ ''

    "Modified: 8.9.1997 / 00:37:33 / cg"
! !

!Filename methodsFor:'queries-type'!

isDirectory
    "return true, if the receiver represents an existing,
     readable directories pathname."

    ^ OperatingSystem isDirectory:(self osNameForAccess)

    "
     '/foo/bar' asFilename isDirectory
     '/tmp' asFilename isDirectory
     'Makefile' asFilename isDirectory
     'c:\' asFilename isDirectory
     'd:\' asFilename isDirectory
    "

    "Modified: / 21.9.1998 / 15:53:10 / cg"
!

isNonEmptyDirectory
    "return true, if the receiver represents an existing,
     readable directories pathname, and the directory is not empty."

    FileStream openErrorSignal
	handle:[:ex| ]
	do:[
	    self directoryContentsDo:[:pathString|^ true].
	].
    ^ false.

    "
     '/foo/bar' asFilename isNonEmptyDirectory
     '/tmp' asFilename isNonEmptyDirectory
     '/tmp/empty' asFilename makeDirectory; isNonEmptyDirectory.
     '/tmp/empty' asFilename removeDirectory.
     'Makefile' asFilename isNonEmptyDirectory
     'c:\' asFilename isNonEmptyDirectory
     'd:\' asFilename isNonEmptyDirectory
    "

    "Modified: / 21.9.1998 / 15:53:10 / cg"
!

isRegularFile
    "return true, if the receiver represents a plain, regular file"

    ^ self type == #regular

    "
     '/foo/bar' asFilename isRegularFile
     '/tmp' asFilename isRegularFile
     'Makefile' asFilename isRegularFile
     'c:\' asFilename isRegularFile
     'd:\' asFilename isRegularFile
     '/dev/null' asFilename isRegularFile
    "
!

isSpecialFile
    "return true, if the receiver represents a socket, named pipe, fifo
     or device special file (i.e. anything non regular and non-directory)"

    |t|

    t := self type.
    ^ (t ~= #directory and:[t ~~ #regular and:[t ~~ #symbolicLink]])

    "
     '/foo/bar' asFilename isSpecialFile
     '/tmp' asFilename isSpecialFile
     'Makefile' asFilename isSpecialFile
     'c:\' asFilename isSpecialFile
     'd:\' asFilename isSpecialFile
     '/dev/null' asFilename isSpecialFile
    "
!

isSymbolicLink
    "return true, if the file represented by the receiver is a symbolic
     link. Notice that not all OS's support symbolic links; those that do
     not will always return false."

    ^ OperatingSystem isSymbolicLink:(self osNameForFile)

    "
     'Make.proto' asFilename isSymbolicLink
     'Makefile' asFilename isSymbolicLink
    "
! !

!Filename methodsFor:'reading-directories'!

directoryContents
    "return the contents of the directory as a collection of strings.
     This excludes any entries for '.' or '..'.
     Returns nil for non-existing directories; however, this behavior
     may be changed in the near future, to raise an exception instead.
     So users of this method better test for existing directory before.
     Notice:
        this returns the file-names as strings;
        see also #directoryContentsAsFilenames, which returns fileName instances."

    ^ OrderedCollection withCollectedContents:[:coll |
        self directoryContentsDo:[:each | coll add:each]] 

    "
     '.' asFilename directoryContents
     '/XXXdoesNotExist' asFilename directoryContents
    "

    "Modified: / 18.9.1997 / 18:42:23 / stefan"
    "Modified: / 3.8.1998 / 21:36:21 / cg"
!

directoryContentsAsFilenames
    "return the contents of the directory as a collection of filenames.
     This excludes any entries for '.' or '..'.
     Returns nil for non-existing directories; however, this behavior
     may be changed in the near future, to raise an exception instead.
     So users of this method better test for existing directory before.
     Notice:
        this returns the file-names as fileName instances;
        see also #directoryContents, which returns strings."

    ^ OrderedCollection withCollectedContents:[:coll |
        self directoryContentsAsFilenamesDo:[:each | coll add:each]] 

    "
     '.' asFilename directoryContentsAsFilenames
     '/XXXdoesNotExist' asFilename directoryContentsAsFilenames
    "
!

fullDirectoryContents
    "return the full contents of the directory as a collection of strings.
     This is much like #directoryContents, but includes an entry for the
     parent directory, if there is one.
     Returns nil for non-existing directories; however, this behavior
     may be changed in the near future, to raise an exception instead.
     So users of this method better test for existing directory before."

    |files|

    "here we get the files without '.' and '..'"
    files := self directoryContents.
    files isNil ifTrue:[
	"/ mhmh - that one does not exist
	^ files
    ].

    files addFirst:'..'.
    ^ files

    "
     '.' asFilename fullDirectoryContents
     '/XXXdoesNotExist' asFilename fullDirectoryContents
     'd:\FET' asFilename fullDirectoryContents
    "

    "Modified: / 21.9.1998 / 15:33:07 / cg"
!

recursiveDirectoryContents
    "return the contents of the directory and all subdirectories
     as a collection of strings.
     This excludes any entries for '.' or '..'.
     Subdirectory files are included with a relative pathname.
     Notice:
	this returns the file-names as strings;
	see also #recursiveDirectoryContentsAsFilenames, which returns fileName instances.

     Warning: this may take a long time to execute."

    |fileNames dirNames|

    fileNames := OrderedCollection new.
    dirNames := OrderedCollection new.
    self directoryContents do:[:f |
	(self construct:f) isDirectory ifTrue:[
	    dirNames add:f
	] ifFalse:[
	    fileNames add:f
	]
    ].

    dirNames do:[:dN |
	|dd subFiles|

	dd := dN asFilename.
	subFiles := (self construct:dN) recursiveDirectoryContents.
	fileNames addAll:(subFiles collect:[:f | dd constructString:f])
    ].
    ^ fileNames.

    "
     '.' asFilename recursiveDirectoryContents
     '../../clients' asFilename recursiveDirectoryContents
    "
!

recursiveDirectoryContentsAsFilenames
    "return the contents of the directory and all subdirectories
     as a collection of filenames.
     This excludes any entries for '.' or '..'.
     Returns nil for non-existing directories; however, this behavior
     may be changed in the near future, to raise an exception instead.
     So users of this method better test for existing directory before.
     Notice:
	this returns the file-names as fileName instances;
	see also #recursiveDirectoryContents, which returns strings.

     Warning: this may take a long time to execute."

    |names|

    names := self recursiveDirectoryContents.
    names isNil ifTrue:[^ nil].
    ^ names collect:[:entry | self construct:entry].

    "
     '.' asFilename recursiveDirectoryContentsAsFilenames
     '/XXXdoesNotExist' asFilename recursiveDirectoryContentsAsFilenames
    "
! !

!Filename methodsFor:'reading-files'!

binaryContentsOfEntireFile
    "return the binary contents of the file (as a byteArray);
     Raises an error, if the file is unreadable/non-existing."

    ^ self
	readingFileDo:[:s |
	    |nBytes bytes n result|

	    s binary.
	    nBytes := self fileSize.
	    (nBytes notNil and:[ nBytes ~~ 0 ]) ifTrue:[
		bytes := ByteArray uninitializedNew:nBytes.
		n := s nextBytes:nBytes into:bytes startingAt:1.
		n == nBytes ifTrue:[
		    result := bytes
		] ifFalse:[
		    result := bytes copyTo:n
		]
	    ] ifFalse:[
		result := s contentsOfEntireFile
	    ].
	    result
	]

    "
     'Makefile' asFilename binaryContentsOfEntireFile
     'foobar' asFilename binaryContentsOfEntireFile
    "

    "Modified: / 27-10-2012 / 19:42:07 / cg"
!

contents
    "Return the contents of the file as a collection of lines.
     Raise an error if the file is unreadable/non-existing.
     See also #contentsOfEntireFile, which returns a string for textFiles.
     CAVEAT: bad naming - but req'd for VW compatibility."

    ^ self readingFileDo:[:s | s contents].

    "
     'Makefile' asFilename contents
     'foobar' asFilename contents
    "

    "Modified: / 2.7.1996 / 12:49:45 / stefan"
    "Created: / 11.7.1996 / 14:09:11 / cg"
    "Modified: / 15.10.1998 / 11:41:45 / cg"
!

contentsAsString
    "to compensate for the bad naming, use this to make things explicit.
     See also #contents, which returns the lines as stringCollection for textFiles."

    ^ self contentsOfEntireFile

    "
     'Makefile' asFilename contentsAsString
     'foobar' asFilename contentsAsString
    "

    "Modified: / 02-07-1996 / 12:49:45 / stefan"
    "Created: / 08-11-2007 / 13:29:59 / cg"
!

contentsOfEntireFile
    "return the contents of the file as a string;
     Raises an error, if the file is unreadable/non-existing.
     See also #contents, which returns the lines as stringCollection for textFiles.
     CAVEAT: bad naming - but req'd for VW compatibility."

    ^ self readingFileDo:[:s | s contentsOfEntireFile].

    "
     'Makefile' asFilename contentsOfEntireFile
     'smalltalk.rc' asFilename contentsOfEntireFile
     'foobar' asFilename contentsOfEntireFile
    "

    "Modified: / 2.7.1996 / 12:49:45 / stefan"
    "Modified: / 15.10.1998 / 11:42:05 / cg"
!

readingFileDo:aBlock
    "Create a read stream on the receiver file, evaluate aBlock, passing that stream as arg,
     and return the block's value.
     If the file cannot be opened, an exception is raised or
     (old behavior, will vanish:)the block is evaluated with a nil argument.
     Ensures that the stream is closed."

    |stream result|

    stream := self readStream.
    [
        result := aBlock value:stream
    ] ensure:[
        stream notNil ifTrue:[stream close]
    ].
    ^ result

    "
     read the first line from some file:

     |rslt|

     rslt :=
        '/etc/passwd' asFilename
            readingFileDo:[:s |
                s nextLine
            ].
     Transcript showCR:rslt.
    "

    "
     find all used shells in /etc/passwd and count their usage:

     |rslt|

     rslt :=
        '/etc/passwd' asFilename
            readingFileDo:
                [:s |
                    |shells|

                    shells := Bag new.
                    s linesDo:
                        [:line |
                            |parts|

                            parts := line asCollectionOfSubstringsSeparatedBy:$:.
                            shells add:(parts seventh).
                        ].
                    shells contents
                ].
     Transcript showCR:rslt.
    "
!

readingLinesDo:aBlock
    "Create a read stream on the receiver file and
     evaluate aBlock for each line read from the stream.
     If the file cannot be opened, an error is raised.
     Ensures that the stream is closed."

    self readingFileDo:[:stream |
        stream linesDo:aBlock
    ].

    "
    '/etc/passwd' asFilename
        readingLinesDo:[:eachLine |
            Transcript showCR:eachLine.
        ].
    "

    "
    '/etc/xxxxx' asFilename
        readingLinesDo:[:eachLine |
            Transcript showCR:eachLine.
        ].
    "
! !

!Filename methodsFor:'special accessing'!

osName
    "special - return the OS's name for the receiver."

    self isDirectory ifTrue:[
	^ self osNameForDirectory
    ].
    ^ self osNameForFile
!

osNameForAccess
    "internal - return the OS's name for the receiver to
     access its fileInfo.
     This may be redefined for systems, where a special suffix must be
     added in order to access directories (or others) as a file.
     (i.e. under VMS, a '.dir' suffix is added to access directories)"

    ^ self osNameForFile

    "Modified: / 21.7.1998 / 10:40:40 / cg"
!

osNameForDirectory
    "internal - return the OS's name for the receiver to
     access it as a directory."

    ^ self osNameForFile

    "Modified: / 12.8.1998 / 14:44:32 / cg"
!

osNameForDirectoryContents
    "internal - return the OS's name for the receiver to
     access it as a directory when reading its contents."

    ^ self osNameForDirectory

    "Created: / 3.8.1998 / 21:36:06 / cg"
    "Modified: / 12.8.1998 / 14:44:34 / cg"
!

osNameForFile
    "internal - return the OS's name for the receiver to
     access it as a file."

    (nameString startsWith:$~) ifFalse:[
        ^ nameString.
    ].

    ^ self species nameWithSpecialExpansions:nameString.
! !

!Filename methodsFor:'suffixes'!

addSuffix:aSuffix
    "return a new filename for the receiver's name with a additional suffix.
     The new suffix is simply appended to the name,
     regardless whether there is already an existing suffix.
     See also #withSuffix:"

    |prefixName|

    prefixName := self name.
    aSuffix isEmptyOrNil ifTrue:[
	^ self species named:prefixName
    ].

    ^ self species named:
	(prefixName
	 , self species suffixSeparator asString
	 , aSuffix asString)

    "
     'abc.st' asFilename addSuffix:nil
     'a.b.c' asFilename addSuffix:nil
     '.b.c.' asFilename addSuffix:nil
     '.b.c' asFilename addSuffix:nil
     '.c.' asFilename addSuffix:nil
     '.c' asFilename addSuffix:nil
     'c.' asFilename addSuffix:nil
     '.' asFilename addSuffix:nil

     'abc.st' asFilename addSuffix:'o'
     'abc' asFilename addSuffix:'o'
     'a.b.c' asFilename addSuffix:'o'
     'a.b.c.' asFilename addSuffix:'o'
     '.b.c.' asFilename addSuffix:'o'
     '.c.' asFilename addSuffix:'o'
     '.c' asFilename addSuffix:'o'
     'c.' asFilename addSuffix:'o'
     '.' asFilename addSuffix:'o'
     '/foo/bar/baz.st' asFilename addSuffix:'c'
     '/foo/bar/baz.c' asFilename addSuffix:'st'
     '/foo/bar.c/baz.c' asFilename addSuffix:'st'
     '/foo/bar.c/baz' asFilename addSuffix:'st'
    "
!

hasSuffix:aSuffixString
    "return true if my suffix is the same as aString.
     This cares for systems, where case is ignored in filenames"

    |mySuffix|

    mySuffix := self suffix.
    self species isCaseSensitive ifTrue:[
	^ mySuffix = aSuffixString
    ].
    ^ mySuffix asLowercase = aSuffixString asLowercase

    "
     'abc.st' asFilename hasSuffix:'st'
     'abc.ST' asFilename hasSuffix:'st'
     '.ST' asFilename hasSuffix:'st'              -- false expected here
     '.foorc' asFilename hasSuffix:'foorc'        -- false expected here
     '.foorc.sav' asFilename hasSuffix:'sav'
    "

    "Modified: 7.9.1997 / 02:55:25 / cg"
!

nameWithoutSuffix
    "return the receiver's name without the suffix.
     If the name has no suffix, the original name is returned."

    |nm idx idxFromEnd|

    nm := self baseName.
    idx := nm lastIndexOf:(self species suffixSeparator).
    (idx == 0) ifTrue:[^ nameString].
    "/ be careful: if the name consists only of suffix (i.e '.foo'),
    "/ the suffix is considered empty.
    (idx == 1) ifTrue:[^ nameString].

    idxFromEnd := nm size - idx.
    idx := nameString size - idxFromEnd.

    ^ nameString copyTo:(idx - 1)

    "
     'abc.st' asFilename nameWithoutSuffix
     'abc' asFilename nameWithoutSuffix
     '/abc' asFilename nameWithoutSuffix
     '/abc.d' asFilename nameWithoutSuffix
     './abc' asFilename nameWithoutSuffix
     './abc.d' asFilename nameWithoutSuffix
     './.abc' asFilename nameWithoutSuffix
     'a.b.c' asFilename nameWithoutSuffix
     'a.b.' asFilename nameWithoutSuffix
     '.b.c' asFilename nameWithoutSuffix
     '.b.' asFilename nameWithoutSuffix
     '.b' asFilename nameWithoutSuffix
     '/foo/bar/baz.c' asFilename nameWithoutSuffix
     '/foo/bar.x/baz.c' asFilename nameWithoutSuffix
     '/foo/bar.x/baz' asFilename nameWithoutSuffix
     '/foo/bar/baz/foo.c/bar' asFilename nameWithoutSuffix
     '/foo/bar/baz/foo.c/bar.c' asFilename nameWithoutSuffix
    "

    "Modified: / 07-09-1995 / 11:15:42 / claus"
    "Created: / 07-11-2006 / 13:55:18 / cg"
!

prefix
    "return my prefix.
     The suffix is the namepart after the final period character,
     or the empty string, if the name does not contain a period."

    ^ self prefixAndSuffix at:1

    "
     'abc.st' asFilename prefix
     'abc' asFilename prefix
     'a.b.c' asFilename prefix
     'a.b.c' asFilename prefix
     'a.' asFilename prefix
     '.a' asFilename prefix
    "

    "Modified: / 07-09-1995 / 11:09:03 / claus"
    "Created: / 13-07-2006 / 10:27:19 / fm"
!

prefixAndSuffix
    "return an array consisting of my prefix and suffix.
     The suffix is the namepart after the final period character,
     the prefix everything before, except for the period.
     The directory name part is stripped off (i.e. the returned prefix
     will consist of the file's basename only.)
     (on some systems, the suffix-character may be different from a period).
     For example, foo.bar.baz has a prefix of 'foo.bar' and a suffix of '.baz'.
     An exception to the above: if the name starts with the suffixCharacter,
     that part is NOT considered a suffix. Thus, '.foorc' has no suffix and a prefix of
     '.foorc'.
     See also: #withoutSuffix and #withSuffix
     Notice:
	there is currently no known system which uses other than
	the period character as suffixCharacter."

    |nm idx|

    nm := self baseName.
    idx := nm lastIndexOf:(self species suffixSeparator).
    "/ be careful: if the name consists only of suffix (i.e '.foo'),
    "/ the suffix is considered empty.
    ((idx == 1) or:[ idx == 0 ]) ifTrue:[
	^ Array with:nm with:''
    ].
    ^ Array
	with:(nm copyTo:idx-1)
	with:(nm copyFrom:idx+1)

    "
     'abc.st' asFilename prefixAndSuffix
     'abc' asFilename prefixAndSuffix
     'a.b.c' asFilename prefixAndSuffix
     '/foo/bar.c/baz.c' asFilename prefixAndSuffix
     'a.' asFilename prefixAndSuffix
     '.a' asFilename prefixAndSuffix

     |parts|
     parts := 'Object.st' asFilename prefixAndSuffix.
     ((parts at:1) , '.o') asFilename
    "

    "Modified: 7.9.1995 / 11:15:42 / claus"
    "Modified: 3.7.1996 / 10:53:10 / cg"
!

suffix
    "return my suffix.
     The suffix is the namepart after the final period character,
     or the empty string, if the name does not contain a period."

    ^ self prefixAndSuffix at:2

    "
     'abc.st' asFilename suffix
     'abc' asFilename suffix
     'a.b.c' asFilename suffix
     'a.b.c' asFilename suffix
     'a.' asFilename suffix
     '.a' asFilename suffix
    "

    "Modified: 7.9.1995 / 11:09:03 / claus"
!

withSuffix:aSuffix
    "return a new filename for the receiver's name with a different suffix.
     If the name already has a suffix, the new suffix replaces it;
     otherwise, the new suffix is simply appended to the name."

    |prefixName|

    prefixName := self nameWithoutSuffix.
    aSuffix isEmptyOrNil ifTrue:[
	^ self species named:prefixName
    ].

    ^ self species named:
	(prefixName
	 , self class suffixSeparator asString
	 , aSuffix asString)

    "
     'abc.st' asFilename withSuffix:nil
     'a.b.c' asFilename withSuffix:nil
     '.b.c.' asFilename withSuffix:nil
     '.b.c' asFilename withSuffix:nil
     '.c.' asFilename withSuffix:nil
     '.c' asFilename withSuffix:nil
     'c.' asFilename withSuffix:nil
     '.' asFilename withSuffix:nil

     'abc.st' asFilename withSuffix:'o'
     'abc' asFilename withSuffix:'o'
     'a.b.c' asFilename withSuffix:'o'
     'a.b.c.' asFilename withSuffix:'o'
     '.b.c.' asFilename withSuffix:'o'
     '.c.' asFilename withSuffix:'o'
     '.c' asFilename withSuffix:'o'
     'c.' asFilename withSuffix:'o'
     '.' asFilename withSuffix:'o'
     '/foo/bar/baz.st' asFilename withSuffix:'c'
     '/foo/bar/baz.c' asFilename withSuffix:'st'
     '/foo/bar.c/baz.c' asFilename withSuffix:'st'
     '/foo/bar.c/baz' asFilename withSuffix:'st'
    "

    "Modified: / 07-09-1995 / 11:15:42 / claus"
    "Modified: / 07-11-2006 / 13:58:45 / cg"
!

withoutSuffix
    "return a new filename for the receiver's name without the suffix.
     If the name has no suffix, a filename representing the same file as the receiver is returned."

    |n|

    n := self nameWithoutSuffix.
    n = nameString ifTrue:[^ self].
    ^ self species named:n

    "
     'abc.st' asFilename withoutSuffix
     'abc' asFilename withoutSuffix
     '/abc' asFilename withoutSuffix
     '/abc.d' asFilename withoutSuffix
     './abc' asFilename withoutSuffix
     './abc.d' asFilename withoutSuffix
     './.abc' asFilename withoutSuffix
     'a.b.c' asFilename withoutSuffix
     'a.b.' asFilename withoutSuffix
     '.b.c' asFilename withoutSuffix
     '.b.' asFilename withoutSuffix
     '.b' asFilename withoutSuffix
     '/foo/bar/baz.c' asFilename withoutSuffix
     '/foo/bar.x/baz.c' asFilename withoutSuffix
     '/foo/bar.x/baz' asFilename withoutSuffix
     '/foo/bar/baz/foo.c/bar' asFilename withoutSuffix
     '/foo/bar/baz/foo.c/bar.c' asFilename withoutSuffix
    "

    "Modified: / 07-09-1995 / 11:15:42 / claus"
    "Modified: / 07-11-2006 / 13:57:45 / cg"
! !

!Filename methodsFor:'testing'!

isFilename
    "return true, if the receiver is some kind of filename;
     false is returned here - the method is redefined from Object."

    ^true


! !

!Filename methodsFor:'writing-files'!

appendingFileDo:aBlock
    "create a append-stream on the receiver file, evaluate aBlock, passing that stream as arg,
     and return the block's value.
     If the file cannot be opened, an exception is raised.
     Ensures that the stream is closed."

    |stream result|

    stream := self appendStream.
    [
	result := aBlock value:stream
    ] ensure:[
	stream close
    ].
    ^ result

    "
     'ttt' asFilename appendingFileDo:[:s |
	s nextPutLine:'hello'.
	s nextPutLine:'world'.
     ]
    "

    "Created: / 09-11-2012 / 10:07:41 / sr"
!

contents:aStringOrCollectionOfLines
    "create (or overwrite) a file given its contents as a collection of lines.
     Raises an error, if the file is unwritable."

    ^ self
	writingFileDo:[:s |
	    aStringOrCollectionOfLines isNonByteCollection ifTrue:[
		"a StringCollection or a collection of lines"
		aStringOrCollectionOfLines do:[:each | s nextPutLine:(each ? '')]
	    ] ifFalse:[
		"something string-like"
		aStringOrCollectionOfLines isString ifFalse:[
		    s binary
		].
		s nextPutAll:aStringOrCollectionOfLines
	    ]
	].

    "
     'foo1' asFilename contents:#('one' 'two' 'three')
     'foo2' asFilename contents:'Hello world'
     'foo3' asFilename contents:#[1 2 3 4 5]
    "

    "Created: / 11-12-2006 / 14:11:21 / cg"
    "Modified: / 08-11-2007 / 13:28:41 / cg"
!

writingFileDo:aBlock
    "create a write-stream on the receiver file, evaluate aBlock, passing that stream as arg,
     and return the block's value.
     If the file cannot be opened, an exception is raised.
     Ensures that the stream is closed."

    |stream result|

    stream := self writeStream.
    [
	result := aBlock value:stream
    ] ensure:[
	stream close
    ].
    ^ result

    "
     'ttt' asFilename writingFileDo:[:s |
	s nextPutLine:'hello'.
	s nextPutLine:'world'.
     ]
    "

    "Created: / 11-12-2006 / 14:09:39 / cg"
! !

!Filename class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


Filename initialize!
