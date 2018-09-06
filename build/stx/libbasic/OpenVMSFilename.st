'From Smalltalk/X, Version:3.1.9 on 9-sep-1997 at 11:55:40 pm'                  !

Filename subclass:#OpenVMSFilename
	instanceVariableNames:'osName'
	classVariableNames:'StandardSuffixTable PresentAsLowercase'
	poolDictionaries:''
	category:'OS-OpenVMS'
!

Object subclass:#NameComponents
	instanceVariableNames:'volume directory filename'
	classVariableNames:''
	poolDictionaries:''
	privateIn:OpenVMSFilename
!

!OpenVMSFilename class methodsFor:'documentation'!

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
    Filenames in OpenVMS.
    
    For your convenience, UNIX style filenames are converted
    to VMS format.
"
! !

!OpenVMSFilename class methodsFor:'initialization'!

initStandardSuffixTable
    "since there is no 'file' command to extract the type,
     return a guess based upon the files suffix. The following
     table defines what is returned."

    StandardSuffixTable := Dictionary new.
    #(  
	'COM'   'command procedure'
	'DIR'   'directory'
	'EXE'   'executable'
	'LIS'   'listing'
	'OBJ'   'object file'
	'TMP'   'temporary'
	'ADA'   'ADA source'
	'BAS'   'basic source'
	'C'     'c source'
	'COB'   'cobol source'
	'FOR'   'fortran source'
	'PAS'   'pascal source'
	'PL1'   'PL/1 source'
	'ST'    'smalltalk source'
	'STH'   'stc generated header'
    ) pairWiseDo:[:k :v |
	StandardSuffixTable at:k put:v
    ]
! !

!OpenVMSFilename class methodsFor:'instance creation'!

currentDirectory
    "return a filename for the current directory"

    ^ self named:'[]'

    "
     Filename currentDirectory
    "
!

rootDirectory
    "return a filename for the root directory"

    ^ self named:'[000000]'

    "
     Filename rootDirectory
    "
! !

!OpenVMSFilename class methodsFor:'parsing'!

components:aString
    "break a filenameString into path components.
     Cannot really do it, since applications assume, they can
     create a valid path by concatenating a dirName, the separator
     and a baseName."

    |idx|

    idx := (aString lastIndexOf:$]) max:(aString lastIndexOf:self separator).
    idx ~~ 0 ifTrue:[
	^ OrderedCollection 
		with:(aString copyTo:idx)
		with:(aString copyFrom:idx+1)
    ].
    ^ OrderedCollection with:aString
! !

!OpenVMSFilename methodsFor:'helpers'!

nameFromComponents:aComponentObject
    "concatenate the components, return a fileNameString"

    |sv sd sf s sep volume directory filename dcomps idx|

    volume := aComponentObject volume.
    directory := aComponentObject directory.
    filename := aComponentObject filename.

    volume notNil ifTrue:[
	sv := volume , ':'
    ] ifFalse:[
	sv := ''
    ].
    directory size > 0 ifTrue:[
	"/
	"/ strip of '-''s - if possible
	"/
	(directory includes:$-) ifTrue:[
	    dcomps := directory asCollectionOfSubstringsSeparatedBy:$..
	    [(idx := dcomps indexOf:'-') > 1] whileTrue:[
		((dcomps at:(idx-1)) ~= '-') ifTrue:[
		    dcomps := (dcomps copyTo:(idx-2)) , (dcomps copyFrom:idx+1)
		]
	    ].
	    directory := dcomps asStringWith:$.
	].
	sd := '[' , directory , ']'
    ] ifFalse:[
	sd := ''
    ].
    filename size > 0 ifTrue:[
	"/
	"/ soon no longer needed - I never create UNIX names
	"/ internally ...
	"/
	(filename includesAny:'/\') ifTrue:[
	    (filename includes:$/) ifTrue:[
		"/ a UNIX component given ...
		sep := $/
	    ] ifFalse:[
		"/ an MSDOS component given ...
		sep := $\
	    ].
	    "/ special hack - convert UNIX/MSDOS path to VMS conventions
	    (filename startsWith:sep) ifTrue:[
		"/ mhm that should not happen ...
		filename := filename copyFrom:2
	    ].
	    (filename endsWith:sep) ifTrue:[
		"/ mhm that should not happen ...
		filename := filename copyWithoutLast:1
	    ].
	    dcomps := filename asCollectionOfSubstringsSeparatedBy:sep.
	    sf := dcomps last.
	    dcomps := dcomps copyWithoutLast:1.
	    dcomps := dcomps 
			collect:[:aDirComponent |
				    aDirComponent = '..' ifTrue:[
					'-'
				    ] ifFalse:[
					aDirComponent
				    ]
				].                  
	    directory size > 0 ifTrue:[
		sd := '[' , directory , '.' , (dcomps asStringWith:$.) , ']'.
	    ] ifFalse:[
		sd := '[' , (dcomps asStringWith:$.) , ']'.
	    ]
	] ifFalse:[
	    sf := filename
	]
    ] ifFalse:[
	sf := ''
    ].
    s := sv, sd, sf.
    s isEmpty ifTrue:[
	^ '[]'
    ].
    PresentAsLowercase == true ifTrue:[
	^ s asLowercase
    ].
    ^ s

    "Modified: 9.9.1997 / 09:38:41 / cg"
!

parseComponentsFrom:aString makeRelative:makeRelative
    "given a pathName, decompose into volume, directory & filename.
     Return the components as a componentObject (which is a dump
     container for those components).
     Beside parsing VMS filenames, this also detects UNIX and MSDOS
     names and tries to convert them into VMS format - however,
     in your applications you probably should not depend on this
     to work out correctly every time. To make certain, only
     provide relative UNIX/MSDOS pathnames (if at all)."

    |nameString v d f idx0 idx idx1 idx2 dcomps sep abs len|

    nameString := aString.

    "/
    "/ hack - allow Unix names ...
    "/
    nameString = '.' ifTrue:[
	"/ 'OpenVMSFilename [warning]: use of Unix name: ''.''' infoPrintCR.
	nameString := '[]'.
    ] ifFalse:[
	nameString = '..' ifTrue:[
	    "/ 'OpenVMSFilename [warning]: use of Unix name: ''..''' infoPrintCR.
	    nameString := '[-]'.
	] ifFalse:[
	     nameString = '/' ifTrue:[
		"/ 'OpenVMSFilename [warning]: use of Unix name: ''/''' infoPrintCR.
		nameString := '[000000]'.
	    ]
	]
    ].

    "/
    "/ a unix or msdos filename - convert.
    "/
    (nameString includesAny:'/\') ifTrue:[
	(nameString includes:$/) ifTrue:[
	    "/ a UNIX component given ...
	    sep := $/
	] ifFalse:[
	    "/ an MSDOS component given ...
	    sep := $\
	].

	"/ although not a legal VMS name,
	"/ we support the form volume:<unixPath>
	"/ this makes your life easier in the FileBrowser
	"/ or FileEntry dialogs. However, you should not
	"/ place such filenames into your program, since
	"/ those are not compatible with UNIX/MSDOS conventions
	"/ i.e. that should be used for user-entered pathNames only.
	"/
	idx1 := nameString indexOf:sep.
	idx2 := nameString indexOf:$:.
	idx2 ~~ 0 ifTrue:[
	    idx2 < idx1 ifTrue:[
		"/
		"/ something like:
		"/   volume:<unixPath>
		"/
		v := nameString copyTo:idx2-1.
		nameString := nameString copyFrom:idx2+1.
		idx1 := nameString indexOf:$/.
	    ]
	].
	abs := false.
	(nameString startsWith:sep) ifTrue:[
	    abs := true.
	    nameString := nameString copyFrom:2.
	    [nameString startsWith:sep] whileTrue:[
		nameString := nameString copyFrom:2.
	    ]
	].

	[nameString size > 2
	 and:[(nameString at:1) == $.
	 and:[(nameString at:2) == sep]]] whileTrue:[
	    nameString := nameString copyFrom:3.
	].

	dcomps := nameString asCollectionOfSubstringsSeparatedBy:$/.

	"/
	"/ replace '..' by '-'
	"/
	f := dcomps last.
	dcomps := dcomps copyWithoutLast:1.
	dcomps size > 0 ifTrue:[
	    dcomps replaceAll:'..' with:'-'.
	    d := dcomps asStringWith:$..
	    abs ifFalse:[
		makeRelative ifTrue:[
		    d := '.' , d
		]
	    ].
	    nameString := '[' , d , ']' , f
	] ifFalse:[
	    nameString := f
	]
    ].

    nameString = '[]' ifTrue:[
	"/ replace by currentDirectory
	nameString := OperatingSystem pathNameOf:'[]'
    ].

    len := nameString size.

    "/
    "/ is there a volume ?
    "/
    idx := nameString indexOf:$:.
    idx ~~ 0 ifTrue:[
	v := nameString copyTo:idx - 1.
	"/ eat up any additional colons
	[(idx < len) and:[(nameString at:idx+1)==$:]] whileTrue:[
	    idx := idx + 1
	]
    ].
    idx := idx + 1.
    idx > len ifTrue:[
	"/
	"/ a volume alone; i.e.
	"/ something like: 'volume:'
	"/
    ] ifFalse:[
	d := ''.
	[(idx < len)
	 and:[(nameString at:idx) == $[ ]] whileTrue:[
	    idx0 := idx + 1.
	    idx := nameString indexOf:$] startingAt:idx0.
	    idx == 0 ifTrue:[
		"/ mhmh - malformed. what should we do here ?
		self error:'malformed filename'
	    ].
	    d isEmpty ifTrue:[
		d := nameString copyFrom:idx0 to:(idx-1).
	    ] ifFalse:[
		(d endsWith:$.) ifTrue:[
		    d := d , (nameString copyFrom:idx0 to:(idx-1)).
		] ifFalse:[
		    d := d , '.' , (nameString copyFrom:idx0 to:(idx-1)).
		]
	    ].
	    idx := idx + 1.

	    "/ eat up any additional colons
	    [(idx <= len) and:[(nameString at:idx)==$:]] whileTrue:[
		idx := idx + 1
	    ]
	].
	f := nameString copyFrom:idx.
	"/ if the directory starts with '000000.', cut it off
	(d startsWith:'000000.') ifTrue:[
	    d := d copyFrom:8
	].

	"/ check if the filename component has multiple '.'
	"/ characters in it; if so, translate them into
	"/ underscore characters (except for the last one).
	f size > 0 ifTrue:[
	    (f occurrencesOf:$.) > 1 ifTrue:[
		f replaceAll:$. with:$_ from:1 to:(f lastIndexOf:$.)-1.
	    ]
	].
    ].
    ^ NameComponents basicNew volume:v directory:d filename:f

    "Modified: 9.9.1997 / 08:50:04 / cg"
!

parseComponentsFrom:aString
    "given a pathName, decompose into volume, directory & filename.
     Return the components as a componentObject (which is a dump
     container for those components).
     Beside parsing VMS filenames, this also detects UNIX and MSDOS
     names and tries to convert them into VMS format - however,
     in your applications you probably should not depend on this
     to work out correctly every time. To make certain, only
     provide relative UNIX/MSDOS pathnames (if at all)."

    ^ self
	parseComponentsFrom:aString
	makeRelative:true
! !

!OpenVMSFilename class methodsFor:'queries'!

defaultTempDirectoryName
    "return the default temp directory as a filename.
     Here, the presence of a sys$tmp: or sys$scratch: volume
     is checked, and if so, returned. Otherwise, the current directory
     is returned.
     This is used, if no special preferences were defined in
     any of the TEMP-environment variables (see tempDirectory)."

    #( 'sys$tmp:[000000]' 'sys$scratch:[000000]')
    do:[:try |
	|fn|

	fn := try asFilename.
	(fn isDirectory 
	and:[fn canBeWritten
	and:[fn isReadable]]) ifTrue:[
	    ^ try
	]
    ].

    "/ fallBack - use current.
    ^ '.'

    "
     OpenVMSFilename defaultTempDirectoryName
    "
!

directorySuffix
    "Return the suffix for directories.
     In VMS, all directories have a '.dir' extension."

    ^ 'DIR'
!

isBadCharacter:aCharacter
    "return true, if aCharacter is unallowed in a filename."

    ('/\' includes:aCharacter) ifTrue:[^ true].
    ^ super isBadCharacter:aCharacter

    "Created: 8.9.1997 / 00:14:47 / cg"
!

isCaseSensitive
    "return true, if filenames are case sensitive.return true, if filenames are case sensitive."

    ^ false
!

maxComponentLength
    "return the maximum number of characters a filename component
     may have in VMS"

    ^ 39
!

maxLength
    "return the maximum number of characters a filename may have in VMS"

    ^ 1024
!

separator
    "return the file/directory separator.
     For openVMS, the separator concept does not really fit,
     since names are composed as 'volume:[dir.dir.dir]file.ext'."

     ^ $.

     "
      Filename concreteClass separator  
     "

    "Created: 8.9.1997 / 00:17:28 / cg"
    "Modified: 9.9.1997 / 08:51:01 / cg"
!

tempFileNameTemplate
    "return a template for temporary files.
     This is expanded with the current processID and a sequenceNumber
     to generate a unique filename."

    ^ 'AAA_%1_%2.DIR'

    "Created: 8.9.1997 / 00:01:46 / cg"
    "Modified: 8.9.1997 / 00:29:23 / cg"
! !

!OpenVMSFilename methodsFor:'file queries'!

fileType
    "this returns a string describing the type of contents of
     the file. Here, the suffix is examined for a standard
     suffix and an appropriate string is returned.
     Poor VMS - no file command."

    |suff type info fmt|

    StandardSuffixTable isNil ifTrue:[
	self class initStandardSuffixTable
    ].
    
    suff := self suffix asUppercase.
    type := StandardSuffixTable at:suff ifAbsent:nil.
    type isNil ifTrue:[
	type := super fileType.
	type = 'file' ifTrue:[
	    "/ look at its record format
	    info := self info.
	    fmt := info recordFormat ? ''.
	    fmt size > 0 ifTrue:[
		type := type , ' (' , fmt ,')'
	    ]
	]
    ].
    ^ type
! !

!OpenVMSFilename methodsFor:'queries'!

isExecutableProgram
    "return true, if such a file exists and is an executable program.
     (i.e. for directories, false is returned.)"

    (self hasSuffix:'exe') ifTrue:[
	^ super isExecutableProgram
    ].
    ^ false
! !

!OpenVMSFilename methodsFor:'queries - contents'!

directoryContents
    |cont|

    cont := super directoryContents.
    PresentAsLowercase == true ifTrue:[
	cont := cont collect:[:nm | nm asLowercase]
    ].
    ^ cont

    "
     PresentAsLowercase := true
     PresentAsLowercase := false
    "
!

fullDirectoryContents
    |cont|

    cont := super fullDirectoryContents.
    PresentAsLowercase == true ifTrue:[
	cont := cont collect:[:nm | nm asLowercase]
    ].
    ^ cont
! !

!OpenVMSFilename methodsFor:'private accessing'!

osNameForDirectory
    "internal - return the OS's name for the receiver when
     used as a directory.
     On VMS, a path like '[dir1]dir2' must be converted to
     '[dir1.dir2]' in order for the OS calls to retrieve
     correct information."
  
    |comps f d|

    comps := self parseComponentsFrom:nameString.
    d := comps directory.

    (f := comps filename) size > 0 ifTrue:[
	(f asUppercase endsWith:'.DIR') ifTrue:[
	    f := f copyWithoutLast:4
	].

	"/ something like v:file or v:[dir]file
	"/ make it: v:[.file] or v:[dir.file]

	d isNil ifTrue:[
	    d := ''
	].
	(comps volume size ~~ 0
	and:[d size == 0]) ifTrue:[
	    comps directory:f
	] ifFalse:[
	    comps directory:(d , '.' , f).
	].
	comps filename:''.
	^ self nameFromComponents:comps
    ].

    "/ ok, an empty fileName
    d size == 0 ifTrue:[
	"/ v: -> v:[000000]
        
	comps directory:'000000'.
	^ self nameFromComponents:comps
    ].

    "/ v:[d1.d2] -> remains
    ^ nameString
!

osNameForFile
    "internal - return the OS's name for the receiver.
     On VMS, a path like '[dir1.dir2]' must be converted to
     '[dir1]dir2.dir' in order for the OS calls to retrieve
     correct information."
  
    |comps f d v idx|

    osName notNil ifTrue:[^ osName].

    comps := self parseComponentsFrom:nameString.
    d := comps directory.

    (f := comps filename) size > 0 ifTrue:[
	d size == 0 ifTrue:[
	    v := comps volume.
	    v size > 0 ifTrue:[
		"/ something like v:file
		"/ make it: v:[000000]file
		comps directory:'000000'.
	    ].
	].
	"/
	"/ if it has no suffix, at least append a suffix character
	"/
	(f includes:$.) ifFalse:[
	    f := f , '.'.
	    comps filename:f.
	].
	(f endsWith:'.') ifTrue:[
	    "/ no suffix -> make it '.dir'
	    f := f , 'DIR'.
	    comps filename:f.
	].
	osName := self nameFromComponents:comps.
	^ osName
    ].

    "/ ok, an empty fileName
    d size > 0 ifTrue:[
	idx := d lastIndexOf:$..
	idx ~~ 0 ifTrue:[
	    "/
	    "/ something like: '[d1.d2]' -> '[d1]d2.DIR'
	    "/
	    comps directory:(d copyTo:(idx-1)).
	    comps filename:((d copyFrom:idx+1) , '.DIR').
	    osName := self nameFromComponents:comps.
	    ^ osName
	].
	"/
	"/ something like: '[d]' -> '[000000]d.DIR'
	"/
	comps directory:'000000'.
	comps filename:(d , '.DIR').
	osName := self nameFromComponents:comps.
	^ osName
    ].

    "/ mhmh - an empty directory and empty file
    "/ i.e. something like v:
    "/ make it: v:000000.dir

    osName := nameString , '[000000]'.
    ^ osName
!

osNameForAccess
    "internal - return the OS's name for the receiver,
     when asking for (stat-) info or to open the file.
     This returns the files name unchanged, but translates
     special directory names."
  
    |comps f d v idx|

    comps := self parseComponentsFrom:nameString.
    d := comps directory.

    (f := comps filename) size > 0 ifTrue:[
	d size == 0 ifTrue:[
	    v := comps volume.
	    v size > 0 ifTrue:[
		"/ something like v:file
		"/ make it: v:[000000]file
		comps directory:'000000'.
	    ].
	].
	"/
	"/ if it has no suffix, at least append a suffix character
	"/
	(f includes:$.) ifFalse:[
	    f := f , '.'.
	    comps filename:f.
	].
	osName := self nameFromComponents:comps.
	^ osName
    ].

    "/ ok, an empty fileName
    d size > 0 ifTrue:[
	idx := d lastIndexOf:$..
	idx ~~ 0 ifTrue:[
	    "/
	    "/ something like: '[d1.d2]' -> '[d1]d2.DIR'
	    "/
	    comps directory:(d copyTo:(idx-1)).
	    comps filename:((d copyFrom:idx+1) , '.DIR').
	    osName := self nameFromComponents:comps.
	    ^ osName
	].
	"/
	"/ something like: '[d]' -> '[000000]d.DIR'
	"/
	comps directory:'000000'.
	comps filename:(d , '.DIR').
	osName := self nameFromComponents:comps.
	^ osName
    ].

    "/ mhmh - an empty directory and empty file
    "/ i.e. something like v:
    "/ make it: v:000000.dir

    osName := nameString , '[000000]'.
    ^ osName
!

! !

!OpenVMSFilename methodsFor:'instance creation'!

constructString:subname
    "taking the receiver as a directory name, construct a new
     filename-string for an entry within this directory
     (i.e. for a file or a subdirectory in that directory)."

    |d f comps dcomps sub subcomps subD|

    comps := self parseComponentsFrom:nameString.
    d := comps directory.

    (f := comps filename) size > 0 ifTrue:[
	"/ path was of the form vol:[d1...dN]foo
	"/ assume foo is a directory and append it to directory path.
	"/ effectively clearing the filename part.

	"/ cut off .DIR ending

	(f asUppercase endsWith:'.DIR') ifTrue:[
	    f := f copyWithoutLast:4
	].
	(d size == 0 or:[d = '000000']) ifTrue:[
	    d := f.
	] ifFalse:[
	    d := d , '.' , f
	].
    ].

    "/ UNIX compatibility
    sub := subname asString.
    (sub = '..') ifTrue:[
	sub := '-'
    ].

    sub = '-' ifTrue:[
	"/ try to cut it off here ...
	dcomps := d asCollectionOfSubstringsSeparatedBy:$..
	dcomps size > 1 ifTrue:[
	    "/ 'foo.bar.baz.-' -> 'foo.bar'
	    dcomps := dcomps copyWithoutLast:1.
	    d := (dcomps asStringWith:$.).
	] ifFalse:[
	    dcomps size == 1 ifTrue:[
		"/ 'foo.-' -> '000000'
		d := '000000'.
	    ] ifFalse:[
		"/ 'any.-'
		d := d , '.' , sub.
	    ]
	].
	sub := ''
    ] ifFalse:[
	"/ get subnames components
	subcomps := self parseComponentsFrom:sub.

	"/ concatenate
	d size == 0 ifTrue:[
	    d := ''.
	].
	subD := subcomps directory.
	subD size > 0 ifTrue:[
	    (subD startsWith:$.) ifTrue:[
		(d = '' and:[comps volume size > 0]) ifTrue:[
		    "/ I am a volume only; no initial '.' in dir.
		    d := subD copyFrom:2
		] ifFalse:[
		    d := d , subD
		]
	    ] ifFalse:[
		(d = '' and:[comps volume size > 0]) ifTrue:[
		    "/ I am a volume only; no initial '.' in dir.
		    d := subD
		] ifFalse:[
		    d := d , '.' , subD
		]
	    ].
	].
	sub := subcomps filename.
    ].

    comps directory:d.
    comps filename:sub.
    ^ self nameFromComponents:comps

    "
     (OpenVMSFilename named:'sys$root:[foo.bar]') construct:'baz'
     (OpenVMSFilename named:'sys$root:[foo.bar]baz') construct:'foo'
    "

    "Modified: 9.9.1997 / 05:26:04 / cg"
! !

!OpenVMSFilename methodsFor:'queries'!

isAbsolute
    "return true, if the receiver represents an absolute pathname
     (in contrast to one relative to the current directory)."

    |comps d|

    comps := self parseComponentsFrom:nameString.
    (d := comps directory) isNil ifTrue:[
	"/ mhmh ...
	comps volume size > 0 ifTrue:[
	    "/ something like v:file
	    "/ (assumed in v's root dir)
	    ^ true
	].
	^ false
    ].
    d size == 0 ifTrue:[
	"/ [] - the current directory is relative
	^ false
    ].
    d = '-' ifTrue:[
	"/ [-] - the parent directory is relative
	^ false
    ].
    (d startsWith:'-.') ifTrue:[
	"/ [-.] - some parent directory is relative
	^ false
    ].
    ^ (d startsWith:'.') not

    "
     (OpenVMSFilename named:'dka:[foo.bar]baz.st') isAbsolute   
     (OpenVMSFilename named:'[foo.bar]baz.st') isAbsolute    
     (OpenVMSFilename named:'[.foo.bar]baz.st') isAbsolute   
     (OpenVMSFilename named:'[]baz.st') isAbsolute           
     (OpenVMSFilename named:'[-]baz.st') isAbsolute    
     (OpenVMSFilename named:'[-.-]baz.st') isAbsolute   
    "

    "Modified: 9.9.1997 / 09:03:42 / cg"
!

isExplicitRelative
    "return true, if this name is an explicit relative name
    (i.e. dir starts with '[.name]' or '[-.]', to avoid path-prepending)"

    |comps d|

    comps := self parseComponentsFrom:nameString makeRelative:false.
    d := comps directory.
    d size > 0 ifTrue:[
	(d startsWith:'.') ifTrue:[
	    ^ true
	].
	(d startsWith:'-.') ifTrue:[
	    ^ true
	]
    ].
    ^ false

    "
     'xpmBitmaps/minus.xpm' asFilename isExplicitRelative
    "
!

isSymbolicLink
    "return true, if the file represented by the receiver
     is a symbolic link. Since VMS does not support these,
     always return false here."

    ^ false
!

linkInfo
    "return information on a symbolic link.
     Since VMS does not support these, always return nil here."

    ^ nil
! !

!OpenVMSFilename methodsFor:'queries-path & name'!

baseName
    "return my baseName as a string.
     - thats the file/directory name without leading parent-dirs.
     See also: #pathName, #directoryName and #directoryPathName.
     Compatibility note: use #tail for ST-80 compatibility."

    |idx d f comps|

    comps := self parseComponentsFrom:nameString.
    (f := comps filename) size > 0  ifTrue:[
	^ f
    ].

    "/ path was of the form vol:[d1...dN]
    "/ cut off the last directory.
    d := comps directory.
    d notNil ifTrue:[
	d = '' ifTrue:[
	    "/ [] 
	    "/ ought to get the current directory ...
	    ^ ''
	].
	d = '-' ifTrue:[
	    "/ [-]
	    "/ ought to get the current directory ...
	    ^ ''
	].
	(d endsWith:'.-') ifTrue:[
	    "/ [rest.-]
	    "/ ought to expand and get final directory ...
	    ^ ''
	].
	idx := d lastIndexOf:$..
	idx ~~ 0 ifTrue:[
	    ^ (d copyFrom:idx+1) , '.DIR'
	].
	^ d , '.DIR'
    ].
    ^ ''

    "
     (OpenVMSFilename named:'dka100:[stx.libbasic]Object.st') baseName
     (OpenVMSFilename named:'stx$root:[stx.libbasic.-]Object.st') baseName 
     (OpenVMSFilename named:'[-]Object.st') baseName                       
     (OpenVMSFilename named:'[]Object.st') baseName                        
     (OpenVMSFilename named:'Object.st') baseName                          
     (OpenVMSFilename named:'[stx.libbasic]') baseName                     
     (OpenVMSFilename named:'[stx]') baseName                     
     (OpenVMSFilename named:'[]') baseName                     
     (OpenVMSFilename named:'[-]') baseName                     
    "

    "Created: 9.9.1997 / 09:23:15 / cg"
    "Modified: 9.9.1997 / 10:52:04 / cg"
!

directoryName
    "return the directory name part of the file/directory as a string.
     - thats the name of the directory where the file/dir represented by
       the receiver is contained in.
     (this is almost equivalent to #directory, but returns
      a string instead of a Filename instance).
     See also: #pathName, #directoryPathName and #baseName.
     Compatibility note: use #head for ST-80 compatibility."

    |idx d f comps|

    comps := self parseComponentsFrom:nameString.
    d := comps directory.
    (f := comps filename) size > 0  ifTrue:[
	comps filename:nil.
	^ self nameFromComponents:comps
    ].

    "/ path was of the form vol:[d1...dN]
    "/ cut off the last directory.

    d isNil ifFalse:[
	d = '' ifTrue:[
	    "/ [] -> [-]
	] ifFalse:[
	    d = '-' ifTrue:[
		"/ [-] -> [-.-]
		d := '-.-'
	    ] ifFalse:[
		(d endsWith:'.-') ifTrue:[
		    "/ [rest.-] -> [rest.-.-]
		    d := d , '.-'
		] ifFalse:[
		    idx := d lastIndexOf:$..
		    idx ~~ 0 ifTrue:[
			d := d copyTo:idx-1
		    ]
		]
	    ]
	].
	comps directory:d.
    ].
    ^ self nameFromComponents:comps

    "
     (OpenVMSFilename named:'dka100:[stx.libbasic]Object.st') directoryName
     (OpenVMSFilename named:'stx$root:[stx.libbasic.-]Object.st') directoryName 
     (OpenVMSFilename named:'[-]Object.st') directoryName                       
     (OpenVMSFilename named:'[]Object.st') directoryName                        
     (OpenVMSFilename named:'Object.st') directoryName                          
     (OpenVMSFilename named:'[stx.libbasic]') directoryName                     
    "

    "Created: 9.9.1997 / 09:23:15 / cg"
    "Modified: 9.9.1997 / 10:36:42 / cg"
!

isVolumeOnly
    "temporary kludge - return true, if the receiver consists of
     a volume name only"

    |comps|

    comps := self parseComponentsFrom:nameString.
    comps directory size > 0 ifTrue:[^ false].
    comps filename size >0 ifTrue:[^ false].
    ^ true
!

localPathName
    "return the directory & name, but without any volume prefix."
 
    |comps|

    comps := self parseComponentsFrom:nameString.
    comps volume:nil.
    ^ self nameFromComponents:comps

    "
     (OpenVMSFilename named:'dka100:[stx.libbasic]Object.st') localPathName
    "
!

volume
    "return the disc volume part of the name or an empty string."

    ^ (self parseComponentsFrom:nameString) volume ? ''

    "
     (OpenVMSFilename named:'dka100:[stx.libbasic]Object.st') volume  
     (OpenVMSFilename named:'stx$root:[stx.libbasic.-]Object.st') volume 
     (OpenVMSFilename named:'[-]Object.st') volume                       
     (OpenVMSFilename named:'[]Object.st') volume                        
     (OpenVMSFilename named:'Object.st') volume                          
     (OpenVMSFilename named:'[stx.libbasic]') volume                     
    "

    "Modified: 9.9.1997 / 08:56:05 / cg"
! !

!OpenVMSFilename::NameComponents methodsFor:'accessing'!

directory
    ^ directory

    "Created: 9.9.1997 / 05:21:04 / cg"
!

directory:aString
    directory := aString

    "Created: 9.9.1997 / 05:21:11 / cg"
!

filename
    ^ filename

    "Created: 9.9.1997 / 05:21:23 / cg"
!

filename:aString
    filename := aString

    "Created: 9.9.1997 / 05:21:28 / cg"
!

volume
    ^ volume

    "Created: 9.9.1997 / 05:20:58 / cg"
!

volume:aString
    volume := aString

    "Created: 9.9.1997 / 05:21:17 / cg"
!

volume:v directory:d filename:n
    volume := v.
    directory := d.
    filename := n.

    "Created: 9.9.1997 / 05:20:53 / cg"
! !

!OpenVMSFilename methodsFor:'file operations'!

basicMakeDirectory
    "create a directory with the receivers name.
     Return true if successful, false if not."

    |nm|

    (OperatingSystem executeCommand:('cre/dir ' , self osNameForDirectory))
	ifFalse:[^ false].

    "/ make it deletable ...

    nm := self osNameForFile.
    (nm endsWith:'.') ifTrue:[
	nm := nm , 'DIR'
    ].
    OperatingSystem executeCommand:('set sec/prot=o:RWED ' , nm).
    ^ true
!

recursiveRemove
    "remove the directory and all of its subfiles/subdirectories.
     Raise an error if not successful."

    self directoryContents do:[:aFile |
	(self construct:aFile) recursiveRemove.
    ].
    self remove
!

remove
    "remove the file/directory.
     Raise an error if not successful.
     Use #recursiveRemove in order to (recursively) remove non empty 
     directories.
     This has been redefined, to add ';*' to the filename, 
     unless an explicit version number has been provided.
     If no explicit version has been specified, all versions are removed."

    |ok baseName osName|

    self exists ifFalse:[^ self].

    osName := self osNameForFile.
    self isDirectory ifTrue:[
	ok := OperatingSystem removeDirectory:osName
    ] ifFalse:[
	baseName := self baseName.
	(baseName includes:$;) ifFalse:[
	    osName := osName , ';0'
	].
	ok := OperatingSystem removeFile:osName.
	ok ifTrue:[
	    "/ get rid of the other versions ...
	    [OperatingSystem removeFile:osName] whileTrue.
	]
    ].
    ok ifFalse:[
	self removeError:self
    ].

    "
     (FileStream newFileNamed:'foo') close.
     'foo' asFilename remove
    "
! !

!OpenVMSFilename class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/OpenVMSFilename.st,v 1.18 1997/10/16 10:41:25 cg Exp $'
! !



