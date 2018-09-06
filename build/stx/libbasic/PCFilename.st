"
 COPYRIGHT (c) 1997 by eXept Software AG
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

Filename subclass:#PCFilename
	instanceVariableNames:''
	classVariableNames:'StandardSuffixTable NextTempFilenameIndex'
	poolDictionaries:''
	category:'OS-Windows'
!

!PCFilename class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    Filenames in Windows-NT / Win95.
"
! !

!PCFilename class methodsFor:'initialization'!

initStandardSuffixTable
    "since there is no 'file' command to extract the type,
     return a guess based upon the files suffix. The following
     table defines what is returned."

    StandardSuffixTable := Dictionary new.
    #(
	'COM'   'executable'
	'DIR'   'directory'
	'EXE'   'executable'
	'LST'   'listing'
	'OBJ'   'object file'
	'TMP'   'temporary'
	'BAS'   'basic source'
	'C'     'c source'
	'COB'   'cobol source'
	'FOR'   'fortran source'
	'PAS'   'pascal source'
	'PL1'   'PL/1 source'
	'ST'    'smalltalk source'
	'STH'   'stc generated header'
	'DLL'   'dynamic link library'
    ) pairWiseDo:[:k :v |
	StandardSuffixTable at:k put:v
    ]

    "
     StandardSuffixTable := nil.
     self initStandardSuffixTable
    "

    "Modified: 16.10.1997 / 13:12:39 / cg"
! !

!PCFilename class methodsFor:'instance creation'!

named:aString
    "return a filename for a directory named aString.
     This is the same as 'aString asFilename'."

    |fn|

    fn := super named:aString.
    fn makeNonDOSName.
    ^fn
!

newTemporaryIn:aDirectoryPrefix
    "return a new unique filename - use this for temporary files.
     redefined to always return an MSDOS 8+3 fileName,
     in case the tempFile is passed to an OLD dos utility.."

    |pid nr nameString|

    NextTempFilenameIndex isNil ifTrue:[
	NextTempFilenameIndex := 1.
    ].

    pid := OperatingSystem getProcessId printString.
    pid := pid copyLast:(3 min:pid size).
    nr := NextTempFilenameIndex printString.
    nr := nr copyLast:(3 min:nr size).
    nameString := (self tempFileNameTemplate) bindWith:pid with:nr.
    NextTempFilenameIndex := NextTempFilenameIndex + 1.

    (aDirectoryPrefix isNil or:[aDirectoryPrefix asString isEmpty]) ifFalse:[
	^ aDirectoryPrefix asFilename construct:nameString
    ].
    ^ self named:nameString

    "temp files in '/tmp':

     Filename newTemporary
    "

    "temp files somewhere
     (not recommended - use above since it can be controlled via shell variables):

     Filename newTemporaryIn:'/tmp'
     Filename newTemporaryIn:'/tmp'
     Filename newTemporaryIn:'/usr/tmp'
     Filename newTemporaryIn:'/'
    "

    "a local temp file:

     Filename newTemporaryIn:''
     Filename newTemporaryIn:nil
     Filename newTemporaryIn:'.'
     Filename newTemporaryIn:('source' asFilename)
    "

    "Modified: / 07-09-1995 / 10:48:31 / claus"
    "Created: / 30-01-1998 / 11:49:33 / md"
    "Modified: / 30-01-1998 / 12:09:18 / dq"
    "Modified: / 23-03-2011 / 16:29:34 / cg"
!

rootComponents:aCollectionOfDirectoryNames
    |rootDirOrVolume|

    aCollectionOfDirectoryNames notEmpty ifTrue:[
        rootDirOrVolume := aCollectionOfDirectoryNames first.
        (rootDirOrVolume endsWith:$:) ifTrue:[
            "do not add a leading \ to C:"    
            ^ self fromComponents:aCollectionOfDirectoryNames.
         ].
    ].
    ^ super rootComponents:aCollectionOfDirectoryNames.
!

rootDirectoryOnVolume:aVolumeName
    "return a filename for the root directory on some volume"

    ^ self named:(aVolumeName , '\')

    "
     Filename rootDirectoryOnVolume:'d:'
     Filename rootDirectoryOnVolume:'\\idefix\home'
    "

    "Modified: / 24.9.1998 / 19:06:15 / cg"
! !

!PCFilename class methodsFor:'defaults'!

defaultTempDirectoryName
    "return the default temp directory as a filename.
     This is used, if no special preferences were defined in
     any of the TEMP-environment variables (see tempDirectory)."

    |winDir vol tempDirString tempDir|

    "/ if no explicit temp dir environment variable has been specified,
    "/ use the ALLUSERS common folder and create an stx_tmp folder there.
    "/ this will only happen for services which are installed to run under system
    "/ instead of under any particular user.

    #('STX_TMPDIR' 'ST_TMPDIR' 'TMPDIR' 'TEMPDIR' 'TEMP' 'TMP' 'ALLUSERSPROFILE') do:[:envVar |
	tempDirString := OperatingSystem getEnvironment:envVar.
	tempDirString notNil ifTrue:[
	    "/ kludge when running cygwin: replace '/cygdrive/X/...'
	    "/ by X:\...
	    (tempDirString startsWith:'/cygdrive/') ifTrue:[
		tempDirString := tempDirString withoutPrefix:'/cygdrive/'.
		tempDirString size > 2 ifTrue:[
		    (tempDirString at:2) == $/ ifTrue:[
			tempDirString := (tempDirString at:1) asString , ':' ,
				   ((tempDirString copyFrom:2) replaceAll:$/ with:$\).
		    ].
		].
	    ].
	    tempDir := self named:tempDirString.
	    (tempDir exists and:[ tempDir isWritable ]) ifTrue:[
		('Filename [info]: using tmp folder "%1" as specified by environment: "%2"'
		    bindWith:tempDir pathName with:envVar) infoPrintCR.
		^ tempDir asFilename.
	    ].
	].
    ].

    winDir := OperatingSystem getWindowsDirectory asFilename.
    vol := winDir volume.
    tempDir := vol asFilename construct:'temp'.
    (tempDir exists and:[ tempDir isWritable ]) ifFalse:[
	tempDir := vol asFilename construct:'tmp'.
	(tempDir exists and:[ tempDir isWritable ]) ifFalse:[
	    tempDir := winDir construct:'temp'.
	    (tempDir exists and:[ tempDir isWritable ]) ifFalse:[
		tempDir := '.\temp' asFilename
	    ]
	]
    ].
    ('Filename [info]: using fallback windows tmp folder: ',tempDir pathName) infoPrintCR.
    ^ tempDir

    "
     Filename defaultTempDirectoryName
     Filename defaultTempDirectoryName exists
     Filename defaultTempDirectoryName isWritable
    "
!

defaultVolumeName
    "return the default volume name."

    ^ 'c:'
! !

!PCFilename class methodsFor:'misc'!

nameWithSpecialExpansions:aString
    "return the nameString, expanding any OS specific macros.
     Here, a ~/ or ~user/ prefix is expanded to the users home dir (as in csh)"

    |expandedString|

    expandedString := aString.
    (expandedString includes:$%) ifTrue:[
        expandedString := OperatingSystem expandEnvironmentStrings:expandedString.
    ].

    (expandedString startsWith:$~) ifTrue:[
        ^ super nameWithSpecialExpansions:expandedString.
    ].
    ^ expandedString

    "
        self nameWithSpecialExpansions:'c:/windows'
        self nameWithSpecialExpansions:'%ProgramFiles%\exept\expecco'
        self nameWithSpecialExpansions:'~\exept\expecco'
        self nameWithSpecialExpansions:'~stefan\exept\expecco'
    "
! !

!PCFilename class methodsFor:'queries'!

isBadCharacter:aCharacter
    "return true, if aCharacter is unallowed in a filename."

    ('<>:"/\|?*' includes:aCharacter) ifTrue:[^ true].
    ^ super isBadCharacter:aCharacter
!

isCaseSensitive
    "return true, if filenames are case sensitive."

    ^ false
!

nullFilename
    "Return the OS dependent filename for the data sink, or nil if there is none"

    ^ 'nul:'
!

parentDirectoryName
    "return the name used for the parent directory.
     This is '..' for unix and dos-like systems.
     (there may be more in the future."

    ^ '..'
!

separator
    "return the file/directory separator."

     ^ $\

     "
      Filename concreteClass separator
     "

    "Modified: 8.9.1997 / 00:18:03 / cg"
!

tempFileNameTemplate
    "return a template for temporary files.
     This is expanded with the current processID and a sequenceNumber
     to generate a unique filename.
     Redefined for MSDOS 8+3 filenames"

    ^ 'st%1%2'

    "Created: 30.1.1998 / 12:09:18 / dq"
! !

!PCFilename methodsFor:'attribute setter'!

setHidden
    "return true, if the hidden attribute could be setted to true"

    ^ OperatingSystem setHidden:(self osNameForFile)
!

setNormal
    "
    sets all file attributes to the normal state

    e.g. set the hidden attribute to false (unhidden)
    "

    ^ OperatingSystem setNormal:(self osNameForFile)
! !

!PCFilename methodsFor:'converting'!

makeDOSName
    "convert the receivers name to be a DOS filename."

    nameString := self fullAlternativePathName.

    "
     'C:\Dokumente und Einstellungen\str\Desktop\output folder\' asFilename makeDOSName
    "
!

makeLegalFilename
    "convert the receivers name to be a legal filename.
     This removes/replaces invalid characters and/or compresses
     the name as required by Win95-WinNT."

    |srchStart|

    "/ there may be only one colon in the name
    "/ (and if present, it must be the second character)

    ((nameString size >= 2)
    and:[(nameString at:2) == $:]) ifTrue:[
	srchStart := 3.
    ] ifFalse:[
	srchStart := 1
    ].

    "/ replace colons by underscore
    "/ may need more to convert - time will show

    (nameString indexOfAny:#($: ) startingAt:srchStart) ~~ 0 ifTrue:[
	nameString := nameString copy.
	nameString replaceAny:#($: ) with:$_ from:srchStart to:(nameString size).
    ].
    ^ self

    "
     'hello world' asFilename makeLegalFilename
     'hello:world' asFilename makeLegalFilename
     'hello::world' asFilename makeLegalFilename
     'c:hello::world' asFilename makeLegalFilename
     '\\idefix' asFilename makeLegalFilename
     '\\idefix\' asFilename makeLegalFilename
    "

    "Modified: / 01-12-2010 / 18:53:59 / cg"
!

makeNonDOSName
    "convert the receivers name to be a full filename, in case its an abbreviated (alternative) DOS name.
     This removes/replaces components of the form FOOBAR~n by the real, full components name."

    |directory directoryName baseName info|

    (nameString includes:$~) ifFalse:[^self].
    (nameString startsWith:$~) ifTrue:[^self].

    directoryName := self directoryName.
    directoryName = nameString ifTrue:[^self].

    baseName := self baseName.

    (baseName includes:$~) ifTrue:[
	info := self info.
	info notNil ifTrue:[
	    baseName := info fullName.
	].
	directory := self class named:directoryName.
	directory isRootDirectory ifFalse:[
	    directory makeNonDOSName.
	].
	nameString := directory constructString:baseName
    ].

    "
     Filename tempDirectory makeNonDOSName
    "

    "Modified: / 11.10.1998 / 01:40:47 / cg"
! !

!PCFilename methodsFor:'file operations'!

renameTo:newName
    "rename the file - the argument must be convertable to a String.
     Raise an error if not successful.
     Redefined to delete any existing target-file first.
     Also take care of possible locks by antivirus scanners, that go away after some time."

    |retryCtr newFilename|


    "try 5 times (retry 4 times) if file has just been written to and is locked by a virus scanner"
    retryCtr := 4.
    [
        ^ super renameTo:newName
    ] on:OSErrorHolder existingReferentSignal do:[:ex|
        |newFilename|

        newFilename := newName asFilename.
        (self pathName sameAs:newFilename pathName) ifTrue:[
            ex reject.
        ].
        newFilename remove.
        ex restart.
    ] on:OSErrorHolder noPermissionsSignal do:[:ex|
        retryCtr > 0 ifTrue:[
            Logger warning:'Error caught while renaming %1 to %2 - maybe temporary locked by virus scanner, still trying: %3'
                                with:self pathName
                                with:newFilename pathName
                                with:ex description.
            retryCtr := retryCtr - 1.
            Delay waitForMilliseconds:200.
            ex restart.
        ] ifFalse:[
            ex reject
        ].
    ].

    "
     'c:\users\stefan\test.txt' asFilename  renameTo:'c:\users\stefan\test1.txt'
     'c:\users\stefan\test12.txt' asFilename  renameTo:'c:\users\stefan\test.txt'
    "

    "Modified: / 20-01-1998 / 15:33:00 / md"
    "Modified: / 21-09-2006 / 18:19:47 / cg"
! !

!PCFilename methodsFor:'queries'!

directoryName
    "return the directory name part of the file/directory as a string.
     - thats the name of the directory where the file/dir represented by
       the receiver is contained in.
     This method does not check if the path is valid.

     (i.e. '/usr/lib/st/file' asFilename directoryName -> '/usr/lib/st'
       and '/usr/lib' asFilename directoryName         -> /usr').

     (this is almost equivalent to #directory, but returns
      a string instead of a Filename instance).

     See also: #pathName, #directoryPathName and #baseName.
     Compatibility note: use #head for ST-80 compatibility."

    |nm|

    (nameString endsWith:':\') ifTrue:[
	^ nameString
    ].

    nm := super directoryName.
    (nm size == 2 and:[(nm at:2) == $:]) ifTrue:[
	^ nm , '\'
    ].
    ^ nm

    "
     (PCFilename named:'c:\') directoryName
     (PCFilename named:'c:\users') directoryName
     (PCFilename named:'c:\users') directory pathName
     (PCFilename named:'c:\users') directory isRootDirectory
    "

    "Modified: / 26-10-2010 / 12:45:55 / cg"
!

fileType
    "this returns a string describing the type of contents of
     the file. Here, the suffix is examined for a standard
     suffix and an appropriate string is returned.
     Poor MSDOS - no file command."

    |suff type info fmt|

    StandardSuffixTable isNil ifTrue:[
	self class initStandardSuffixTable
    ].

    suff := self suffix asUppercase.
    type := StandardSuffixTable at:suff ifAbsent:nil.
    type isNil ifTrue:[
	type := super fileType.
    ].
    ^ type

    "Created: 16.10.1997 / 13:07:24 / cg"
    "Modified: 16.10.1997 / 13:10:00 / cg"
!

freeBytesInVolume
    ^ (OperatingSystem getDiskInfoOf: self volume) at: #freeBytes

    "Created: / 05-07-2006 / 15:02:38 / cg"
!

fullAlternativePathName
    "return my complete MSDOS-path"

    |altNameComponent fullAlternativePath fullAlternativeDirectoryName info|

    self isRootDirectory ifTrue:[
	^ nameString
    ].

    (self name endsWith:$\) ifTrue:[
	^ (self class named:self pathName) fullAlternativePathName
    ].

    info := self info.
    info notNil ifTrue:[
	^ info alternativePathName.
    ].

    fullAlternativeDirectoryName := self directory fullAlternativePathName.
    (fullAlternativeDirectoryName endsWith:$\) ifTrue:[
	fullAlternativePath := fullAlternativeDirectoryName, self baseName.
    ] ifFalse:[
	fullAlternativePath := fullAlternativeDirectoryName , '\' , (altNameComponent ? self baseName).
    ].
    ^ fullAlternativePath

    "
     'C:\Dokumente und Einstellungen\str\Desktop\output folder' asFilename fullAlternativePathName
     'C:\Dokumente und Einstellungen\str\Desktop\output folder' asFilename fullAlternativePathName asFilename exists
     'C:\' asFilename fullAlternativePathName
     'C:\Dokumente und Einstellungen\str\Desktop\output folder\' asFilename fullAlternativePathName asFilename
    "
!

isCDRom
    "return true, if is is a drive"
    |pathName|

    self isRootDirectory ifFalse:[^ false].

    pathName := self asString asLowercase.
    ^ (OperatingSystem getDriveType:pathName) == 5

    "
     'd:' asFilename isCDRom
    "
!

isDirectory
    "return true, if I represent a directory
     Redefined to care for volumeRoots."

    self isRootDirectory ifTrue:[^ true].
    ^ super isDirectory.

    "Created: / 24.9.1998 / 14:04:31 / cg"
!

isDrive
    "return true, if is is a drive,
     that is either a fixed, removable, ramdisk or cdrom"

    |pathName|

    self isRootDirectory ifFalse:[^ false].

    pathName := self asString asLowercase.

    "/ ((pathName = 'a:\') or:[pathName = 'b:\']) ifTrue:[^ false].
    ^ #(2 3 5 6) includes:(OperatingSystem getDriveType:pathName)

   "
    'z:' asFilename isDrive
    'c:' asFilename isDrive
    'd:' asFilename isDrive
    'a:\' asFilename isDrive
    'b:\' asFilename isDrive
   "
!

isExecutableProgram
    "return true, if such a file exists and is an executable program.
     (i.e. for directories, false is returned.)"

    |osName|

    osName := self osNameForAccess.
    (OperatingSystem getBinaryType:osName) notNil ifTrue:[
        ^ true.
    ].

    (#('bat' 'cmd') includes:self suffix asLowercase) ifTrue:[
        ^ (OperatingSystem isValidPath:osName)      
            and:[(OperatingSystem isDirectory:osName) not].
    ].
    ^ false

    "
        '%windir%\notepad.exe' asFilename isExecutableProgram
        '%windir%\notepad' asFilename isExecutableProgram
        '%windir%\system32\kernel32.dll' asFilename isExecutableProgram
        'bmake.bat' asFilename isExecutableProgram
        'c:\' asFilename isExecutableProgram
        OperatingSystem getBinaryType:'bmake.bat'  
        OperatingSystem getBinaryType:'c:\'  
    "


    "Created: / 16-10-1997 / 13:19:10 / cg"
    "Modified: / 09-09-1998 / 20:17:52 / cg"
    "Modified: / 23-08-2011 / 21:24:57 / jv"
!

isExplicitRelative
    "return true, if this name is an explicit relative name
     (i.e. starts with './' or '../', to avoid path-prepending)"

    (nameString startsWith:'.\') ifTrue:[
	^ true
    ].
    (nameString startsWith:'..\') ifTrue:[
	^ true
    ].
    ^ false
!

isHidden
    "return true, if such a file is hidden.
     On MSDOS, a name starting with a period is considered hidden
     AND a file with a hidden attribute is so."

    |baseName|

    baseName := self baseName.
    ((baseName startsWith:'.') and:[baseName ~= '..']) ifTrue:[^ true].
    ^ OperatingSystem isHidden:(self osNameForFile)
!

isRootDirectory
    "return true, if I represent a root directory
     (i.e. I have no parentDir)"

    |nm|

    (self isRootDirectoryName:nameString) ifTrue:[ ^ true].
"/    nm := self pathName.
"/    nm ~= nameString ifTrue:[
"/        ^ self isRootDirectoryName:nm
"/    ].
"/    ^ false

    (nameString includesString:'..') ifTrue:[
	nm := self pathName.
	nm ~= nameString ifTrue:[
	    ^ self isRootDirectoryName:nm
	].
    ].
    ^ false
"
'\\exeptn\tmp\' asFilename isRootDirectory
"
!

isRootDirectoryName:nm
    "return true, if aString represents a root directory;
     i.e. is of the form:
	\
	X:
	X:\
     or:
	\\hostname\
	\\hostname\topDir
    "

    |sz i|

    sz := nm size.
    sz == 1 ifTrue:[
	(nm = '\') ifTrue:[
	    "/ \ alone
	    ^ true
	]
    ].

    sz >= 2 ifTrue:[
	(nm at:2) == $: ifTrue:[
	    sz == 2 ifTrue:[
		"/ <DRIVE-char>:
		^ true
	    ].
	    sz == 3 ifTrue:[
		(nm at:3) == $\ ifTrue:[
		    "/ <DRIVE-char>:\
		    ^ true
		]
	    ]
	].
    ].

    "/ \\<REMOTE-HOST>
    (((sz > 3)
    and:[(nm at:1) == $\])
    and:[(nm at:2) == $\]) ifTrue:[
	"/ something like \\hostname\
	i := nm indexOf:$\ startingAt:4.
	((i == 0) or:[i == nameString size]) ifTrue:[
	    "/ not really a root (its not readable)
	    ^ true
	].
	i ~~ 0 ifTrue:[
	    "/ something like \\hostname\dirName
	    i := nm indexOf:$\ startingAt:i+1.
	    ((i == 0) or:[i == nameString size]) ifTrue:[
		"/ yeah - really a root
		^ true
	    ].
	]
    ].
    ^ false
!

isVolumeAbsolute
    "return true, if the receiver represents an absolute pathname
     on some disk volume."

    "/ <DRIVE-CHAR>:
    (((nameString size >= 3)
    and:[(nameString at:2) == $:])
    and:[(nameString at:3) == $\]) ifTrue:[
	"/ something like x:\foo
	^ true
    ].

    "/ \\REMOTE-HOST:
    (((nameString size >= 3)
    and:[(nameString at:1) == $\])
    and:[(nameString at:2) == $\]) ifTrue:[
	"/ something like \\hostname
	^ true
    ].
    ^ false

    "Created: / 7.9.1997 / 23:54:20 / cg"
    "Modified: / 9.9.1998 / 20:38:54 / cg"
!

localNameStringFrom:aString
    "ST-80 compatibility.
     what does this do ? (used in FileNavigator-goody).
     GUESS: does it strip off the voulume-character and initial '\' ?"

    (aString at:2) == $: ifTrue:[
	(aString at:3) == $\ ifTrue:[
	    ^ aString copyFrom:4
	].
	^ aString copyFrom:3
    ].
    (aString at:1) == $\ ifTrue:[
	^ aString copyFrom:1
    ].
    ^ aString
!

localPathName
    "return the full pathname of the file represented by the receiver,
     but without any volume information.
     Only makes a difference on MSDOS & VMS systems."

    |vol vsz rest|

    vol := self volume.
    (vsz := vol size) ~~ 0 ifTrue:[
        rest := nameString copyFrom:vsz + 1.
        rest size == 0 ifTrue:[
            ^ '\'
        ].
        (rest startsWith:$\) ifFalse:[
            ^ '\' , rest
        ].
        ^ rest
    ].
    ^ nameString

    "
     '\foo'         asFilename localPathName
     '\foo\'        asFilename localPathName
     '\foo\bar'     asFilename localPathName
     '\foo\bar\'    asFilename localPathName
     'c:'           asFilename localPathName
     'c:\'          asFilename localPathName
     'c:\foo'       asFilename localPathName
     'c:\foo\'      asFilename localPathName
     'c:\foo\bar'   asFilename localPathName
     'c:\foo\bar\'  asFilename localPathName
     '\\idefix'          asFilename localPathName
     '\\idefix\home'     asFilename localPathName
     '\\idefix\home\foo' asFilename localPathName
     "

    "Modified: / 24.9.1998 / 19:09:53 / cg"
!

pathName
    |path|

    path := super pathName.
    path size > 1 ifTrue:[
	(path endsWith:'\') ifTrue:[
	    (path endsWith:':\') ifFalse:[
		path := path copyButLast:1
	    ]
	]
    ].
    ^ path

    "
     '\foo'         asFilename pathName
     '\foo\'        asFilename pathName
     '\foo\bar'     asFilename pathName
     '\foo\bar\'    asFilename pathName
     '\'            asFilename pathName
     'c:'           asFilename pathName
     'c:\'          asFilename pathName
     'c:\foo'       asFilename pathName
     'c:\foo\'      asFilename pathName
     'c:\foo\bar'   asFilename pathName
     'c:\foo\bar\'  asFilename pathName
     '\\idefix'          asFilename pathName
     '\\idefix\home'     asFilename pathName
     '\\idefix\home\foo' asFilename pathName
     "

    "Modified: / 24.9.1998 / 19:09:53 / cg"
!

volume
    "return the disc volume part of the name or an empty string.
     This is only used with DOS filenames - on unix, an empty string is returned.
     A full path can be reconstructed from
        aFilename volume , aFilename localPathName
    "

    |endIdx|

    nameString size >= 2 ifTrue:[
        (nameString at:2) == $: ifTrue:[
            ^ nameString copyTo:2
        ].
        (nameString startsWith:'\\') ifTrue:[
            endIdx := nameString indexOf:$\ startingAt:3.
            endIdx == 0 ifTrue:[
                ^ nameString.
            ].
            ^ nameString copyFrom:1 to:endIdx-1
        ].
    ].

    ^ ''

    "
     '\foo'         asFilename volume
     '\foo\'        asFilename volume
     '\foo\bar'     asFilename volume
     '\foo\bar\'    asFilename volume
     'c:'           asFilename volume
     'c:\'          asFilename volume
     'c:\foo'       asFilename volume
     'c:\foo\'      asFilename volume
     'c:\foo\bar'   asFilename volume
     'c:\foo\bar\'  asFilename volume
     'c:\foo\bar\'  asFilename localPathName
     '\\idefix'          asFilename volume
     '\\idefix\home'     asFilename volume
     '\\idefix\home\foo' asFilename volume
     '\\idefix\home\foo' asFilename localPathName
     "

    "Modified: / 24.9.1998 / 19:04:27 / cg"
! !

!PCFilename methodsFor:'special accessing'!

osNameForAccess
    "/ mhmh - Win32operatingSystem gets confused, when we give it a relative name for fileInfo.
    (nameString startsWith:'..\') ifTrue:[
	^ self pathName
    ].
    ^ self osNameForFile
!

osNameForDirectory
    "special - return the OS's name for the receiver to
     access it as a directory.
     Care remove trailing backSlashes here and to use the shortName
     if available"

    |n|

    n := self osNameForFile.

    (n endsWith:'\') ifTrue:[
	((n size == 3) and:[(n at:2) == $:]) ifFalse:[
	    n := n copyButLast:1
	]
    ].
"/    i := OperatingSystem infoOf:n.
"/    (i notNil and:[(shortName := i alternativeName) notNil]) ifTrue:[
"/        ^ shortName
"/    ].
    ^ n

    "Modified: / 20.1.1998 / 15:39:06 / md"
    "Modified: / 17.8.1998 / 10:04:01 / cg"
!

osNameForDirectoryContents
    "special - return the OS's name for the receiver to
     access it as a directory for reading the contents.
     Care to remove trailing backSlashes here"

    |name|

    name := self osNameForFile.
    (name endsWith:'\') ifTrue:[
	^ name copyButLast:1
    ].
    ^ name

    "Modified: / 20.1.1998 / 15:39:06 / md"
    "Created: / 3.8.1998 / 21:37:46 / cg"
    "Modified: / 17.8.1998 / 10:04:22 / cg"
!

osNameForFile
    "internal - return the OS's name for the receiver to
     access it as a file."

    (nameString includesAny:'~%') ifTrue:[
        ^ self class nameWithSpecialExpansions:nameString.
    ].

    ^ nameString

    "Modified: / 21-07-2012 / 19:35:19 / cg"
!

setName:aString
    "set the filename, convert unix directory separators to native separators"

    nameString := aString copyReplaceAll:$/ with:$\

    "Created: / 22-01-1998 / 17:32:45 / md"
    "Modified: / 16-07-2013 / 19:44:00 / cg"
! !

!PCFilename class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

