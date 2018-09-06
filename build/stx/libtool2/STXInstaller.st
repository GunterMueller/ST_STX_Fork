"{ Package: 'stx:libtool2' }"

Object subclass:#STXInstaller
	instanceVariableNames:'stxLibDir stxLibBinDir stxBinDir stxPkgDir stxDocDir stxTopDir
		installDocFiles installSourceFiles installSTCFiles
		installGoodyFiles fullDir actionPercentageHolder actionTextHolder
		commandTraceView resources dfHolder copyProcess installWhat'
	classVariableNames:'LastPartialDir LastFullDir'
	poolDictionaries:''
	category:'eXept-tools'
!


!STXInstaller class methodsFor:'startup'!

open
    ^ self new open

    "
     STXInstaller open
    "
! !

!STXInstaller methodsFor:'defaults'!

defaultBinDirs
    |dirs stxRel|

    stxRel := self smalltalkRelease.
    dirs := OrderedCollection new.

    OperatingSystem isMSWINDOWSlike ifTrue:[
        dirs add:'c:\Programme\eXept\SmalltalkX\' , stxRel , '\bin'.
        dirs add:'c:\Programme\SmalltalkX\' , stxRel , '\bin'.
        dirs add:'c:\SmalltalkX\' , stxRel , '\bin'.
    ] ifFalse:[
        dirs add:'/opt/smalltalk/' , stxRel , '/bin'.
        dirs add:'/usr/local/bin'.
        dirs add:'/usr/bin'.

        dirs add:(Filename homeDirectory constructString:'bin').
        dirs add:((Filename homeDirectory construct:'stx') constructString:'bin').
        dirs add:'/tmp/stxbin'.
        ('/home' asFilename exists and:['/home' asFilename isDirectory]) ifTrue:[
            dirs add:'/home/stx/bin'.
        ].
        ('/home2' asFilename exists and:['/home2' asFilename isDirectory]) ifTrue:[
            dirs add:'/home2/stx/bin'.
        ].
    ].

"/    dirs := dirs select:[:path | 
"/                            |f|
"/
"/                            f := path asFilename.
"/                            f exists and:[f isDirectory]].
    ^ dirs "sort"

    "Created: / 18.7.1996 / 19:43:00 / cg"
    "Modified: / 31.5.1999 / 12:11:48 / cg"
!

defaultFullDirs
    |dirs|

    dirs := OrderedCollection new.

    dirs add:((Filename homeDirectory constructString:'stxDevelop')).
    dirs add:((Filename homeDirectory constructString:'develop')).
    dirs add:((Filename homeDirectory constructString:'work')).

"/    ('/home' asFilename exists 
"/    and:['/home' asFilename isDirectory]) ifTrue:[
"/        dirs add:'/home/work'.
"/    ].

    ^ dirs "sort"

    "Modified: / 18.7.1996 / 19:45:08 / cg"
    "Created: / 25.2.1998 / 17:14:43 / cg"
!

defaultInstDirs
    |dirs d stxRel|

    stxRel := self smalltalkRelease.
    dirs := OrderedCollection new.

    OperatingSystem isMSWINDOWSlike ifTrue:[
        dirs add:'c:\Programme\eXept\SmalltalkX\' , stxRel.
        dirs add:'c:\Programme\SmalltalkX\' , stxRel.
        dirs add:'c:\SmalltalkX\' , stxRel.
    ] ifFalse:[
        dirs add:'/opt/smalltalk/' , stxRel.
        dirs add:'/usr/local/smalltalkX'.

        d := (Filename homeDirectory constructString:'smalltalkX').
        (dirs includes:d) ifFalse:[dirs add:d].
        d := (Filename homeDirectory constructString:'stx').
        (dirs includes:d) ifFalse:[dirs add:d].
        d := '/tmp/stx'.
        (dirs includes:d) ifFalse:[dirs add:d].
        ('/home' asFilename exists and:['/home' asFilename isDirectory]) ifTrue:[
            d := '/home/stx'.
            (dirs includes:d) ifFalse:[dirs add:d].
        ].
        ('/home2' asFilename exists and:['/home2' asFilename isDirectory]) ifTrue:[
            d := '/home2/stx'.
            (dirs includes:d) ifFalse:[dirs add:d].
        ].
    ].

"/    dirs := dirs select:[:path | 
"/                            |f|
"/
"/                            f := path asFilename.
"/                            f exists and:[f isDirectory]].
    ^ dirs "sort"

    "Created: / 18.7.1996 / 19:43:00 / cg"
    "Modified: / 31.5.1999 / 18:32:17 / cg"
!

defaultLibBinDirs
    |dirs stxRel|

    stxRel := self smalltalkRelease.
    dirs := OrderedCollection new.
    OperatingSystem isMSWINDOWSlike ifTrue:[
        dirs add:'c:\Programme\eXept\SmalltalkX\' , stxRel , '\lib'.
        dirs add:'c:\Programme\SmalltalkX\' , stxRel , '\lib'.
        dirs add:'c:\SmalltalkX\' , stxRel , '\lib'.
    ] ifFalse:[
        dirs add:'/opt/smalltalk/' , stxRel , '/lib'.
        dirs add:'/usr/local/lib'.
        dirs add:'/usr/lib'.
        dirs add:'/lib'.
        dirs add:(Filename homeDirectory constructString:'lib').

        dirs add:((Filename homeDirectory construct:'stx') constructString:'lib').
        dirs add:'/tmp/stxlib'.
        dirs add:'/home/stx/lib'.
        dirs add:'/home2/stx/lib'.
    ].
    ^ dirs sort

    "Created: / 18.7.1996 / 19:43:21 / cg"
    "Modified: / 31.5.1999 / 12:12:17 / cg"
!

defaultLibDirs
    |dirs stxRel|

    stxRel := self smalltalkRelease.
    dirs := OrderedCollection new.
    OperatingSystem isMSWINDOWSlike ifTrue:[
        dirs add:'c:\Programme\eXept\SmalltalkX\' , stxRel , '\lib'.
        dirs add:'c:\Programme\SmalltalkX\' , stxRel , '\lib'.
        dirs add:'c:\SmalltalkX\' , stxRel , '\lib'.
    ] ifFalse:[
        dirs add:'/opt/smalltalk/' , stxRel , '/lib'.
        dirs add:'/usr/local/lib/smalltalk'.
        dirs add:'/usr/lib/smalltalk'.
        dirs add:((Filename homeDirectory construct:'lib') constructString:'smalltalk').
        dirs add:((Filename homeDirectory construct:'stx') constructString:'lib').
        dirs add:'/tmp/stxlib'.
        dirs add:'/home/stx/lib'.
        dirs add:'/home2/stx/lib'.
    ].

"/    dirs := dirs select:[:path | 
"/                            |f|
"/
"/                            f := path asFilename.
"/                            f exists and:[f isDirectory]].
    ^ dirs "sort"

    "Created: / 18.7.1996 / 19:43:21 / cg"
    "Modified: / 31.5.1999 / 12:12:30 / cg"
!

directoriesToMake
    |dirsToMake docDir docOnlineDir|

    dirsToMake := OrderedCollection new.
    installWhat == #full ifTrue:[
        dirsToMake add:fullDir.
    ] ifFalse:[
        dirsToMake add:stxBinDir.
        dirsToMake add:stxLibDir.
        stxLibDir ~= stxLibBinDir ifTrue:[
            dirsToMake add:stxLibBinDir.
        ].
        dirsToMake add:stxDocDir.
        docOnlineDir := stxDocDir asFilename construct:'online'.
        dirsToMake add:docOnlineDir name.
        dirsToMake add:(docOnlineDir constructString:'english').
        dirsToMake add:(docOnlineDir constructString:'german').
        installDocFiles ifTrue:[
            dirsToMake add:(docOnlineDir constructString:'french').
            dirsToMake add:(docOnlineDir constructString:'italian').
        ]
    ].
    ^ dirsToMake

    "Modified: / 31.5.1999 / 17:52:03 / cg"
!

listOfOptionalPackages
    ^ #(
        'libDB'
        'clients/CBrowser'
        'libcompat'
        'libxt'


        "/ mhmh - these should not be needed here ...

        'projects/smalltalk/bitmaps/javaImages'
        'doc/online/english/overview/icons'
      )

    "Created: 2.3.1997 / 12:39:59 / cg"
    "Modified: 2.3.1997 / 13:24:41 / cg"
!

smalltalkRelease
    ^ Smalltalk majorVersionNr printString 
               , '.' , Smalltalk minorVersionNr printString
               , '.' , Smalltalk revisionNr printString.
!

specOfCommonFilesToCopy
    |fileSpec|

    fileSpec := #(
                "/ name                             destination  subDir             required mode      
                ( 'projects/smalltalk/include'          #lib     nil                  true  '644' )
                ( 'projects/smalltalk/*.rc'             #lib     nil                  true  '644' )
                ( 'projects/smalltalk/*.wsp'            #lib     nil                  true  '644' )
                ( 'projects/smalltalk/banner*.xpm'      #lib     nil                  true  '644' )
                ( 'projects/smalltalk/patches'          #lib     nil                  true  '644' )
                ( 'COPYRIGHT'                           nil      nil                  true  '644' )
                ( 'RELEASE'                             nil      nil                  true  '644' )
                ( 'doc/online/german/LICENCE_STX.html'  nil           'doc/online/german'      true  '644' )
                ( 'doc/online/english/LICENCE_STX.html' nil           'doc/online/english'     true  '644' )
                ( 'doc/online/german/LICENCE_DEMO_STX.html'  nil      'doc/online/german'      true  '644' )
                ( 'doc/online/english/LICENCE_DEMO_STX.html' nil      'doc/online/english'     true  '644' )
    ).

    installDocFiles ifTrue:[
        fileSpec := fileSpec , #(
                ( 'doc'                                  nil     nil        false '644' )
        ).
    ].

    installSTCFiles ifTrue:[
        fileSpec := fileSpec , #(
                ( 'include'                                  #lib        nil              false '644' )
                ( 'configurations'                           #lib        nil              false '644' )
                ( 'configurations/PACKS'                     #lib        'configurations' false '644' )
                ( 'configurations/my*'                       #lib        'configurations' false '644' )
                ( 'configurations/vendor*'                   #lib        'configurations' false '644' )
                ( 'rules'                                    #lib        nil              false '644' )
        ).
    ].

    installGoodyFiles ifTrue:[
        fileSpec := fileSpec , #(
                ( 'goodies/*.st'                  #pkg     'stx/goodies/source'       false '644' )
                ( 'goodies/*.chg'                 #pkg     'stx/goodies/source'       false '644' )
        ).
    ].


    ^ fileSpec

    "Created: / 2.5.1999 / 13:17:37 / cg"
    "Modified: / 24.12.1999 / 01:16:42 / cg"
!

specOfFilesToCopy
    OperatingSystem isMSWINDOWSlike ifTrue:[
        ^ self specOfWindowsFilesToCopy
    ].
    ^ self specOfUnixFilesToCopy

    "Modified: / 2.5.1999 / 13:17:59 / cg"
!

specOfUnixFilesToCopy
    |fileSpec|

    fileSpec := self specOfCommonFilesToCopy.

    fileSpec := fileSpec , #(
                "/ name                             destination  subDir             required mode      
                ( 'projects/smalltalk/smalltalk'        #bin     nil                  true  '755' )
                ( 'projects/smalltalk/stx'              #bin     nil                  true  '755' )
                ( 'librun/librun.so'                    #lib     'lib'                true  '644' )
    ).

    installSTCFiles ifTrue:[
        fileSpec := fileSpec , #(
                ( 'stc/stc'                                  #bin        nil              false '755' )
                ( 'rules/stmkmp'                             #bin        nil              false '755' )
                ( 'rules/stmkmf'                             #bin        nil              false '755' )
                ( 'configurations/COMMON'                    #lib        'configurations' false '644' )
                ( 'configurations/PACKS'                     #lib        'configurations' false '644' )
                ( 'configurations/my*'                       #lib        'configurations' false '644' )
                ( 'configurations/vendor*'                   #lib        'configurations' false '644' )

                ( 'support/VGL/vogl/src/libvogl.*'           #lib        'lib'            false '644' )
                ( 'support/VGL/vogl/src/*.h'                 #lib        'include'        false '644' )
                ( 'support/DLD/dld-3.2.5/libdld.*'           #lib        'lib'            false '644' )

                ( 'goodies/persistency/db-1.6/PORT/libdb.*'  #libBin     'lib'            false '644' )

"/                ( 'librun/librun.o'                          #libBin     nil              false '644' )
"/                ( 'librun/librun.a'                          #libBin     nil              false '644' )
        ).
    ].

    installGoodyFiles ifTrue:[
        fileSpec := fileSpec , #(
                ( 'goodies/rdoit/rdoit'           #bin     nil        false '755' )
                ( 'goodies/xml/indelv/abbrev.stc' #pkg     'stx/goodies/xml/indelv'   true  )
        ).
    ] ifFalse:[
        fileSpec := fileSpec , #(
                ( 'goodies/persistency/libdbase.so'  #pkg     'stx/goodies/persistency' true '644' )
        ).
    ].

    ^ fileSpec

    "Modified: / 30.4.1999 / 18:02:22 / cg"
    "Created: / 2.5.1999 / 13:17:37 / cg"
!

specOfWindowsFilesToCopy
    |fileSpec|

    fileSpec := self specOfCommonFilesToCopy.

    fileSpec := fileSpec , #(
                "/ name                             destination  subDir             required       
                ( 'projects\smalltalk\smalltalk.bat'    #bin     nil                  true   )
                ( 'projects\smalltalk\stx.exe'          #bin     nil                  true   )
                ( 'projects\smalltalk\winstx.exe'       #bin     nil                  true   )
                ( 'projects\smalltalk\stxspawn.exe'     #bin     nil                  true   )
                ( 'projects\smalltalk\*.dll'            #bin     nil                  true   )
    ).

    installSTCFiles ifTrue:[
        fileSpec := fileSpec , #(
                ( 'projects\smalltalk\stc.exe'           #bin        nil              false  )
                ( 'libbc\*.lib'                          #lib        nil              false  )
                ( 'rules'                                #lib        nil              false  )
        ).
    ].

    installGoodyFiles ifTrue:[
        fileSpec := fileSpec , #(
                ( 'goodies/rdoit/rdoit.exe'              #bin     nil                 false )
        ).
    ].

    ^ fileSpec

    "Created: / 2.5.1999 / 13:23:06 / cg"
    "Modified: / 16.10.2001 / 12:25:58 / cg"
! !

!STXInstaller methodsFor:'installing'!

add:specEntry toFileSpec:fileSpec
    (specEntry first startsWith:'./') ifTrue:[
        specEntry at:1 put:(specEntry first copyFrom:3).
    ].
    (specEntry first startsWith:'.\') ifTrue:[
        specEntry at:1 put:(specEntry first copyFrom:3).
    ].
    (fileSpec includes:specEntry) ifFalse:[
        fileSpec add:specEntry
    ] ifTrue:[
        "/ self halt
    ]
!

addFilesToSpec:fileSpec relativeTo:rel fromINSTALLSpec:f
    |s entry t cond dst|

    s := f asFilename readStream.
    s isNil ifTrue:[^  self].
    [s atEnd] whileFalse:[
        entry := s nextLine.
        (entry startsWith:$#) ifFalse:[
            t := entry asCollectionOfWords.
            t size >= 2 ifTrue:[
                cond := t at:3 ifAbsent:nil.
                (cond ~= 'optionalSource' 
                 or:[installSourceFiles]) ifTrue:[
                    ((rel startsWith:'goodies/') not
                    or:[installGoodyFiles]) ifTrue:[
                        dst := t at:2.
                        (dst startsWith:'packages/stx/') ifTrue:[
                            self add:(Array 
                                            with:(rel asFilename constructString:(t at:1))
                                            with:#pkg
                                            with:('stx' asFilename constructString:(dst copyFrom:'packages/stx/' size+1))
                                            with:true)
                                 toFileSpec:fileSpec.
                        ] ifFalse:[
                            ((dst = 'bin') or:[dst startsWith:'bin/']) ifTrue:[
                                (dst = 'bin') ifTrue:[
                                    self add:(Array 
                                                    with:(rel asFilename constructString:(t at:1))
                                                    with:#bin
                                                    with:nil
                                                    with:true)
                                         toFileSpec:fileSpec.
                                ] ifFalse:[
                                    self add:(Array 
                                                    with:(rel asFilename constructString:(t at:1))
                                                    with:#bin
                                                    with:(dst copyFrom:'bin/' size+1)
                                                    with:true)
                                         toFileSpec:fileSpec.
                                ].
                            ] ifFalse:[
                                ((dst = 'lib') or:[dst startsWith:'lib/']) ifTrue:[
                                    (dst = 'lib') ifTrue:[
                                        self add:(Array 
                                                        with:(rel asFilename constructString:(t at:1))
                                                        with:#lib
                                                        with:nil
                                                        with:true)
                                             toFileSpec:fileSpec.
                                    ] ifFalse:[
                                        self add:(Array 
                                                        with:(rel asFilename constructString:(t at:1))
                                                        with:#lib
                                                        with:(dst copyFrom:'lib/' size+1)
                                                        with:true)
                                             toFileSpec:fileSpec.
                                    ]
                                ] ifFalse:[
                                    self halt:'unhandled destination: ' , dst.
                                ]
                            ]
                        ]
                    ]
                ].
            ].
        ].
    ].
    s close.
!

changeWritability
    |msg|

    installWhat == #full ifTrue:[
        msg := (resources array:#('ST/X Installation' '' 'making target dir writable' '' '' '')) asStringCollection.

        commandTraceView showCR:(resources string:'making target dir writable ...').
        commandTraceView endEntry.
        OperatingSystem executeCommand:('(cd ' , fullDir , ' ; find . -exec chmod u+w {} \;)').
    ].

    "Created: / 17.7.1996 / 15:24:19 / cg"
    "Modified: / 20.4.1998 / 15:40:00 / cg"
!

copyFiles
    |msg fileSpec filesToCopy numFiles nDone cmd topDir topDirPrefix|

    msg := (resources array:#('ST/X Installation' '' 'copying:' '' 'to:' '')) asStringCollection.

    OperatingSystem isUNIXlike ifTrue:[
        topDir := '../..'.
        topDirPrefix := '../../'.
    ] ifFalse:[
        topDir := '..\..'.
        topDirPrefix := '..\..\'.
    ].

    installWhat == #full ifTrue:[
        "/ MUST be under stx (for packagePath stuff)
        fullDir asFilename baseName ~= 'stx' ifTrue:[
            fullDir := fullDir asFilename constructString:'stx'.
        ].
        fullDir asFilename recursiveMakeDirectory.
        fullDir asFilename exists ifFalse:[
            self warn:'Oops - failed to create directory: ' , fullDir.
            ^ false
        ].

        msg at:4 put:('    all from CD' asText allBold).
        msg at:6 put:'    ' , (fullDir asText allBold).
        actionTextHolder value:nil.
        actionTextHolder value:msg.

        actionPercentageHolder value:-1.
        OperatingSystem isUNIXlike ifTrue:[
            cmd := '(cd ' , topDir , '/doc/online ; find . -type s -exec rm {} \; )'.
            commandTraceView showCR:'removing symbolic links ...'.
            commandTraceView endEntry.
            self executeCommandAndShowOutput:cmd emphasize:false.

            cmd := '(cd ' , topDir , ' ; tar cf - .) | (cd ' , fullDir , ' ; tar xvf -)'.
            commandTraceView showCR:'copying ...'.
            commandTraceView endEntry.
            cmd := cmd , ' 2>&1' .

            self executeCommandAndShowOutput:cmd emphasize:false.

            cmd := '(cd ' , fullDir , '/doc/online ; make )'.
            commandTraceView showCR:'creating symbolic links ...'.
            commandTraceView endEntry.
            self executeCommandAndShowOutput:cmd emphasize:false.

        ] ifFalse:[
            fullDir asFilename exists ifFalse:[
                commandTraceView showCR:(resources string:'creating %1 ...' with:fullDir asFilename pathName).
                commandTraceView endEntry.
                OperatingSystem recursiveCreateDirectory:fullDir asFilename pathName
            ].
            self recursiveCopy:(topDir , '\*') to:fullDir.
        ].
        actionPercentageHolder value:100.
        ^ true
    ].

    fileSpec := self specOfFilesToCopy asOrderedCollection.

    actionPercentageHolder value:0.
    "/ search for INSTALL.files specs, and add to list ...
    actionTextHolder value:nil.
    actionTextHolder value:(resources array:#('ST/X Installation' '' 'searching for packages to install...' '' '' '')) asStringCollection.

    topDir asFilename recursiveDirectoryContentsDo:[:f |
        f asFilename baseName = 'INSTALL.files' ifTrue:[
            self addFilesToSpec:fileSpec relativeTo:f asFilename directoryName fromINSTALLSpec:(topDir asFilename construct:f).
        ]
    ].

    filesToCopy := OrderedCollection new.

    fileSpec do:[:entry |
        |fileNames dest subDir required destDir|

        fileNames := entry at:1.
        dest := entry at:2.
        subDir := entry at:3.
        required := entry at:4.

        dest == #bin ifTrue:[
            destDir := stxBinDir
        ] ifFalse:[
            dest == #libBin ifTrue:[
                destDir := stxLibBinDir
            ] ifFalse:[
                dest == #pkg ifTrue:[
                    destDir := stxPkgDir
                ] ifFalse:[
                    dest == nil ifTrue:[
                        destDir := stxTopDir
                    ] ifFalse:[
                        destDir := stxLibDir
                    ]
                ]
            ]
        ].
        
        destDir := destDir asFilename.
        subDir notNil ifTrue:[
            destDir := destDir construct:subDir
        ].

        filesToCopy add:(fileNames -> destDir pathName)
    ].

    numFiles := filesToCopy size.
    nDone := 0.

    filesToCopy do:[:entry |
        |fileName destDir cmd|

        fileName := entry key.
        destDir := entry value.

        ((fileName includes:$*)
        or:[(topDirPrefix , fileName) asFilename exists])ifTrue:[
            actionPercentageHolder value:(nDone / numFiles * 100) rounded.

            msg at:4 put:'    ' , (fileName asText allBold).
            msg at:6 put:'    ' , (destDir asText allBold).
            actionTextHolder value:nil.
            actionTextHolder value:msg.

            ((fileName includes:$*) not
            and:[(topDirPrefix , fileName) asFilename exists not]) ifTrue:[
                (self listOfOptionalPackages includes:fileName) ifFalse:[
                    commandTraceView showCR:('cannot copy ' , fileName , ' - not included in distribution').
                    commandTraceView endEntry.
                ]
            ] ifFalse:[
                destDir asFilename exists ifFalse:[
                    commandTraceView showCR:(resources string:'creating %1 ...' with:destDir asFilename pathName).
                    commandTraceView endEntry.
                    OperatingSystem recursiveCreateDirectory:destDir asFilename pathName
                ].
                self recursiveCopy:(topDirPrefix , fileName) to:destDir.
            ]
        ].

        nDone := nDone + 1
    ].

    ^ true

    "
     STXInstaller open
    "

    "Created: / 17.7.1996 / 15:16:20 / cg"
    "Modified: / 31.5.1999 / 18:07:33 / cg"
!

createDirectories
    |msg dirsToMake numDirs nDone|

    msg := (resources array:#('ST/X Installation' '' 'creating directory:' '' '' '')) asStringCollection.

    dirsToMake := self directoriesToMake.

    numDirs := dirsToMake size.
    nDone := 0.

    dirsToMake do:[:dirName |
        |d errMsg stop box|

        actionPercentageHolder value:(nDone / numDirs * 100) rounded.

        msg at:4 put:'    ' , (dirName asText allBold).
        actionTextHolder value:nil.
        actionTextHolder value:msg.

        d := dirName asFilename.

        commandTraceView showCR:(resources string:'creating %1 ...' with:d pathName).
        commandTraceView endEntry.

        d exists ifFalse:[
            OperatingSystem recursiveCreateDirectory:d pathName
        ].

        d exists ifFalse:[
            errMsg := (resources string:'failed to create directory: %1\\Please check your permissions.' with:dirName) withCRs.
            stop := true
        ] ifTrue:[
            d isDirectory ifFalse:[
                errMsg := resources string:'not a directory: %1' with:dirName.
                stop := true
            ] ifTrue:[
                (d isReadable
                and:[d isWritable]) ifFalse:[
                    errMsg := resources string:'no read/write access to directory: %1' with:dirName.
                    stop := false
                ] ifTrue:[
                    errMsg := nil
                ]
            ]
        ].

        errMsg notNil ifTrue:[
            box := WarningBox new.
            box title:errMsg.
            box showAtPointerNotCovering:(WindowGroup activeGroup topViews first).
            stop ifTrue:[^ false].
        ].

        Delay waitForSeconds:0.25.
        nDone := nDone + 1.
    ].
    ^ true

    "Created: 17.7.1996 / 15:24:19 / cg"
    "Modified: 22.5.1997 / 15:06:41 / cg"
!

createRegistryEntries
    |release msg k|

    msg := (resources array:#('ST/X Installation' '' 'creating registry entries' '' '' '')) asStringCollection.
    actionTextHolder value:nil.
    actionTextHolder value:msg.

    commandTraceView showCR:(resources string:'creating registry entries...').
    commandTraceView endEntry.

    release := self smalltalkRelease.

    k := Win32OperatingSystem::RegistryEntry key:'HKEY_LOCAL_MACHINE\Software'.
    k isNil ifTrue:[
        self warn:'cannot update registry under HKEY_LOCAL_MACHINE\Software\eXept'.
        ^ self.
    ].

    k := k createSubKeyNamed:'eXept'.
    k := k createSubKeyNamed:'Smalltalk/X'.
    k valueNamed:'CurrentVersion' put:release.

    k := k createSubKeyNamed:release.
    k valueNamed:'LibDir' put:stxLibDir.
    k valueNamed:'BinDir' put:stxBinDir.
    k valueNamed:'DocDir' put:stxDocDir.
    k valueNamed:'PackageDirPath' put:stxPkgDir.

    "Modified: / 23.12.1999 / 22:21:18 / cg"
!

createSymbolicLinks
    |msg dirsToMake numDirs nDone languages cmd|

    OperatingSystem isUNIXlike ifFalse:[^ self].

    msg := (resources array:#('ST/X Installation' '' 'creating symbolic links' '' '' '')) asStringCollection.
    actionTextHolder value:nil.
    actionTextHolder value:msg.

    installWhat == #full ifTrue:[
        commandTraceView showCR:(resources string:'setting up symbolic links in doc...'); endEntry.
        OperatingSystem executeCommand:('(cd ' , fullDir , '/doc/online ; make links)').

        commandTraceView showCR:(resources string:'setting up symbolic links in projects/smalltalk...'); endEntry.
        OperatingSystem executeCommand:('(cd ' , fullDir , '/projects/smalltalk ; ln -s ../../lib*/*.so .)').
        OperatingSystem executeCommand:('(cd ' , fullDir , '/projects/smalltalk ; ln -s ../../goodies/*/*.so .)').
        ^ self.
    ].
"/        OperatingSystem executeCommand:('(cd ' , stxLibDir , '/doc/online ; make links)').

    commandTraceView showCR:(resources string:'setting up symbolic links in lib...'); endEntry.

    #(
        'libbasic/libbasic.so'
        'libbasic2/libbasic2.so'
        'libbasic3/libbasic3.so'
        'libcomp/libcomp.so'
        'libboss/libboss.so'
        'libview/*.so'
        'libview2/libview2.so'
        'libwidg/libwidg.so'
        'libwidg2/libwidg2.so'
        'libwidg3/libwidg3.so'
        'libhtml/libhtml.so'
        'libui/libui.so'
        'libtool/libtool.so'
        'libtool2/libtool2.so'
        'goodies/persistency/libdbase.so'
    ) do:[:src |  |cmd|
        cmd := '(cd ' , stxLibDir , '/lib ; ln -s ../../packages/stx/' , src , ' . )'.
        commandTraceView showCR:cmd; endEntry.
        OperatingSystem executeCommand:cmd.
    ].

    installDocFiles ifTrue:[
        msg := (resources array:#('ST/X Installation' '' 'creating symbolic links' '' '' '')) asStringCollection.
        actionTextHolder value:nil.
        actionTextHolder value:msg.

        commandTraceView showCR:(resources string:'setting up symbolic links in doc/online ...'); endEntry.

        languages := #(
                        'english'
                        'german'
                        'french'
                        'italian'
                        'spanish'
                        'japanese'
                      ).
        languages := languages select:[:l | (stxDocDir , '/online/' , l) asFilename exists].

        languages do:[:thisLang |
            |langDir|

            langDir := stxDocDir , '/online/' , thisLang.
            languages do:[:otherLang |
                otherLang ~= thisLang ifTrue:[
                    cmd := '(cd ' , langDir , ' ; ln -s ../' , otherLang , ' .)'.
                    commandTraceView showCR:cmd; endEntry.
                    OperatingSystem executeCommand:cmd.
                ]
            ].

            cmd := '(cd ' , langDir , ' ; ln -s ../icons .)'.
            commandTraceView showCR:cmd; endEntry.
             OperatingSystem executeCommand:cmd.

            cmd := '(cd ' , langDir , ' ; ln -s ../pictures .)'.
            commandTraceView showCR:cmd; endEntry.
             OperatingSystem executeCommand:cmd.
        ]
    ]
    "Created: / 17.7.1996 / 15:24:19 / cg"
    "Modified: / 31.5.1999 / 14:46:36 / cg"
!

executeCommandAndShowOutput:cmd
    ^ self executeCommandAndShowOutput:cmd emphasize:true
!

executeCommandAndShowOutput:cmd emphasize:doEmphasize
    |doneSemaphore line p|

    OperatingSystem isMSWINDOWSlike ifTrue:[
        ^ self
    ].

    doneSemaphore := Semaphore new.

    copyProcess := [   

        p := PipeStream readingFrom:cmd.
        p isNil ifTrue:[
            self warn:('command error. Could not execute:\\' , cmd) withCRs.
        ] ifFalse:[
            [
                [p atEnd] whileFalse:[
                    (p readWaitWithTimeout:0.1) ifFalse:[
                        line := p nextLine.
                        (line notNil and:[line notEmpty]) ifTrue:[
                            doEmphasize ifTrue:[
                                line := line asText emphasizeAllWith:(#color->Color red).
                            ].
                            commandTraceView showCR:('  ' , line).
                            commandTraceView endEntry.
                        ]
                    ]
                ].
                p close.
            ] valueOnUnwindDo:[
                p shutDown
            ]
        ].
        doneSemaphore signal.
        copyProcess := nil.
    ] forkAt:4.

    doneSemaphore wait.

    "Created: / 25.2.1998 / 17:46:06 / cg"
    "Modified: / 30.4.1999 / 18:00:43 / cg"
!

outputInitialMessage
^ self.

    #(
    'Notice:'
    ''
    'During the installation, you may get error messages'
    'complaining that some files where not found'
    'and could therefore not be copied.'
    ) do:[:line |
        commandTraceView showCR:((resources string:line) asText emphasizeAllWith:(#color->Color blue)).
        commandTraceView endEntry. 
    ].

    Delay waitForSeconds:2.

    #(
    ''
    'This is normal behavior; since the CD may contain'
    'broken symbolic links to non-existing packages'
    'which are either not contained on your ordered'
    'package (i.e. non-commercial) or are not required'
    'for your architecture (and therefore not contained'
    'on the CD).'
    ''
    ) do:[:line |
        commandTraceView showCR:((resources string:line) asText emphasizeAllWith:(#color->Color blue)).
        commandTraceView endEntry.
    ].

    Delay waitForSeconds:2.

    #(
    ''
    'Please excuse this inconvenience.'
    ''
    ) do:[:line |
        commandTraceView showCR:((resources string:line) asText emphasizeAllWith:(#color->Color blue)).
        commandTraceView endEntry.
    ].

    Delay waitForSeconds:2.

    "Created: 2.3.1997 / 12:49:52 / cg"
    "Modified: 8.8.1997 / 17:47:06 / cg"
!

recursiveCopy:src to:dst
    self recursiveCopy:src to:dst print:true
!

recursiveCopy:src to:dst print:doPrint
    |cmd srcBaseName srcF dstF d|

    srcF := src asFilename.
    dstF := dst asFilename.

    srcF directory exists ifFalse:[
        ^ self
    ].

    srcBaseName := srcF baseName.
    (srcBaseName startsWith:'.#') ifTrue:[^ self].

    (#(
        'CVS'
        'not_delivered'
        '.cvsignore'
        '.dir.info'
    ) includes:srcBaseName) ifTrue:[
        ^ self
    ].

    srcBaseName includesMatchCharacters ifTrue:[
        doPrint ifTrue:[
            OperatingSystem isUNIXlike ifTrue:[
                commandTraceView showCR:('cp ' , srcF pathName , ' ' , dstF pathName).
            ] ifFalse:[
                commandTraceView showCR:('copy ' , srcF pathName , ' ' , dstF pathName).
            ].
            commandTraceView endEntry.
        ].

        (srcF directory directoryContents ? #()) do:[:fileName |
            (srcBaseName match:fileName) ifTrue:[
                (#(
                    'CVS'
                    'not_delivered'
                ) includes:fileName) ifFalse:[
                    self 
                        recursiveCopy:(srcF directory construct:fileName) 
                        to:dstF
                        print:doPrint
                ]
            ]
        ]
    ] ifFalse:[
        srcF isDirectory ifFalse:[
            (dstF exists and:[dstF isDirectory]) ifTrue:[
                dstF := dstF construct:srcBaseName.
            ].
            "/ special check for windows bug
            "/ (lists trans.tbl files, but wont find it later)
            srcF exists ifTrue:[
                Object errorSignal handle:[:ex |
                    commandTraceView showCR:('*** Error: ' , ex errorString)
                ] do:[
                    srcF copyTo:dstF.
                ]
            ].
            OperatingSystem isUNIXlike ifTrue:[
                srcF isExecutable ifTrue:[
                    dstF makeExecutableForAll
                ]
            ]
        ] ifTrue:[
            doPrint ifTrue:[
                OperatingSystem isUNIXlike ifTrue:[
                    commandTraceView showCR:('cp ' , srcF pathName , ' ' , dstF pathName).
                ] ifFalse:[
                    commandTraceView showCR:('copy ' , srcF pathName , ' ' , dstF pathName).
                ].
                commandTraceView endEntry.
            ].
            d := dstF asFilename construct:srcBaseName.
            (d exists) ifFalse:[
                d makeDirectory.
            ].
            (srcF directoryContents ? #()) do:[:fileName |
                self recursiveCopy:(srcF construct:fileName) 
                     to:d
                     print:doPrint
            ]
        ]
    ]

    "Created: / 31.5.1999 / 13:05:09 / cg"
    "Modified: / 3.3.2000 / 01:51:54 / cg"
!

removeMakefilesInDoc
    |cmd msg|

    OperatingSystem isUNIXlike ifFalse:[ ^ self ].
    installWhat == #full ifTrue:[^ self].

    installDocFiles ifTrue:[
        msg := (resources array:#('ST/X Installation' '' 'removing useless makefiles in doc' '' '' '')) asStringCollection.
        actionTextHolder value:nil.
        actionTextHolder value:msg.

        commandTraceView showCR:(resources string:'removing useless makefiles in doc ...'); endEntry.

        #(
            'Make.proto'
            'nt.mak'
            'vms.mak'
            'Makefile'
        ) do:[:toRemove |
            cmd := '(cd ' , stxDocDir , ' ; find . -name ''' , toRemove , ''' -exec rm {} \; )'.

            commandTraceView showCR:cmd; endEntry.
             OperatingSystem executeCommand:cmd.
        ]
    ]
! !

!STXInstaller methodsFor:'startup'!

askAndInstall
    "/ check, if we are in the projects/smalltalk directory

    |answer here|

    resources := ResourcePack for:self class.

    (((here := Filename currentDirectory pathName) endsWith:'projects/smalltalk') not
    and:[(here asLowercase endsWith:'stx\binbc') not
    and:[(here asLowercase endsWith:'projects\smalltalk') not
    ]]) ifTrue:[
        "/ double - check if some of my expected files exists here ...
        ('../../libbasic' asFilename exists
        and:['../../libbasic' asFilename isDirectory]) ifTrue:[
            self warn:(resources string:'Oops - current directories name seems to not end with ''/projects/smalltalk''\\Assume its OK.' withCRs).
        ] ifFalse:[
            self warn:(resources string:'must be in the ''projects/smalltalk'' directory').
            ^ self
        ]
    ].

    answer := self askForFullInstallation.
    answer ifFalse:[^ self].

    [self askForDestination] whileTrue:[
        self checkForExistingInstallationAndConfirm ifTrue:[
            self preInstall.
            self doInstall ifTrue:[
                self postInstall.
                ^ self
            ].
            (self confirm:(resources string:'installation failed or aborted - retry ?'))
            ifFalse:[
                ^ self
            ]
        ]
    ].

    "Modified: / 31.5.1999 / 12:04:14 / cg"
!

askForDestination
    "open a dialog to enter destination directories"

    installWhat == #full ifTrue:[
        ^ self askForDestinationForFullInstallation
    ] ifFalse:[
        ^ self askForDestinationForPartialInstallation
    ]

    "
     STXInstaller open
    "

    "Modified: / 25.2.1998 / 17:12:45 / cg"
!

askForDestinationForFullInstallation
    "open a dialog to enter destination directories"

    |d cm l green dark img
     fullDirHolder|

    LastFullDir isNil ifTrue:[
        LastFullDir := (Filename homeDirectory construct:'work') constructString:'stx'
    ].

    fullDirHolder := LastFullDir asValue.

    Screen current hasColors ifTrue:[
        green := (Color red:0 green:80 blue:20) "darkened".
        dark := Color grey:10.
    ] ifFalse:[
        green := Color white.
        dark := Color black.
    ].

    d := DialogBox new.

    d label:(resources string:'ST/X Full Installation').
    img := Image fromFile:'SmalltalkX.xbm'.

    l := d addTextLabel:img.
    l adjust:#left; foregroundColor:green backgroundColor:dark.

    l := d addTextLabel:(resources string:'Smalltalk/X CD installation (full).').
    l adjust:#left; backgroundColor:dark; foregroundColor:Color white.

    l := d addTextLabel:(resources string:'\Notice: this simply copies all of the CD to the destination directory below.\If any problem is encountered, manually copy the CD to your harddisk.') withCRs.
    l adjust:#left; backgroundColor:dark; foregroundColor:Color white.

    d addVerticalSpace.
    d addVerticalSpace.

    d addHorizontalLine.

    l := d addTextLabel:(resources string:'ST/X development directory:').
    l adjust:#left; backgroundColor:dark; foregroundColor:Color white.

    cm := ComboBoxView on:fullDirHolder.
    cm list:self defaultFullDirs.
    d 
        addLabelledField:cm 
        label:(resources string:'stx develop')
        adjust:#left 
        tabable:true 
        from:0.0 to:1.0 separateAtX:0.25
        nameAs:'fullBox'.

    (d componentAt:'fullBox.label') backgroundColor:dark; foregroundColor:Color white.

    d addVerticalSpace.
    d addHorizontalLine.

    d addHelpButtonFor:'STXInstaller/installHelp.html';
      addAbortButton; 
      addOkButtonLabelled:(resources string:'install').
    d extent:500@400.
    d resize. "/ compute best size

    d allViewBackground:dark.

    d openAtCenter.
    d accepted ifTrue:[
        fullDir := LastFullDir := fullDirHolder value.
        d destroy.
        ^ true
    ].
    d destroy.
    ^ false

    "
     STXInstaller open
    "

    "Created: / 25.2.1998 / 17:11:37 / cg"
    "Modified: / 25.2.1998 / 17:29:07 / cg"
!

askForDestinationForPartialInstallation
    "open a dialog to enter destination directories"

    |d cm l green dark img
     stxInstDirHolder stxLibDirHolder stxLibBinDirHolder stxBinDirHolder
     installDocHolder installSourceHolder installSTCHolder installGoodiesHolder
     binMegabytes libMegabytes docMegabytes stcMegabytes srcMegabytes
     goodyMegabytes stxRel list stxInstDir
    |

    binMegabytes := 20.
    libMegabytes := 30.
    docMegabytes := 12.
    stcMegabytes := 2.
    srcMegabytes := 20.
    goodyMegabytes := 10.

    stxRel := self smalltalkRelease.

    OperatingSystem isMSWINDOWSlike ifTrue:[
        LastPartialDir isNil ifTrue:[
            LastPartialDir := 'c:\Programme\eXept\SmalltalkX\' , stxRel 
        ].
"/        LastLibDir isNil ifTrue:[
"/            LastLibDir := 'c:\Programme\SmalltalkX\' , stxRel , '\lib'
"/        ].
"/        LastLibBinDir isNil ifTrue:[
"/            LastLibBinDir := 'c:\Programme\SmalltalkX\' , stxRel , '\lib'
"/        ].
"/        LastBinDir isNil ifTrue:[
"/            LastBinDir := 'c:\Programme\SmalltalkX\' , stxRel , '\bin'
"/        ].
    ] ifFalse:[
        LastPartialDir isNil ifTrue:[
            LastPartialDir := '/opt/smalltalk/' , stxRel
        ].
"/        LastLibDir isNil ifTrue:[
"/            LastLibDir := '/opt/smalltalk/' , stxRel , '/lib'
"/        ].
"/        LastLibBinDir isNil ifTrue:[
"/            LastLibBinDir := '/opt/smalltalk/' , stxRel , '/lib'
"/        ].
"/        LastBinDir isNil ifTrue:[
"/            LastBinDir := '/opt/smalltalk/' , stxRel , '/bin'
"/        ].
    ].

    stxInstDirHolder := LastPartialDir asValue.
"/    stxLibDirHolder := LastLibDir asValue.
"/    stxLibBinDirHolder := LastLibBinDir asValue.
"/    stxBinDirHolder := LastBinDir asValue.

    installDocHolder := true asValue.
    installSourceHolder := true asValue.
    installSTCHolder := true asValue.
    installGoodiesHolder := true asValue.

    Screen current hasColors ifTrue:[
        green := (Color red:0 green:80 blue:20) "darkened".
        dark := Color grey:10.
    ] ifFalse:[
        green := Color white.
        dark := Color black.
    ].

    d := DialogBox new.

    d label:(resources string:'ST/X Standard Installation').
    img := Image fromFile:'SmalltalkX.xbm'.

    l := d addTextLabel:img.
    l adjust:#left; foregroundColor:green backgroundColor:dark.

    l := d addTextLabel:(resources string:'Smalltalk/X Standard installation (partial).').
    l adjust:#left; backgroundColor:dark; foregroundColor:Color white.
    d addVerticalSpace.
    d addVerticalSpace.

    d addHorizontalLine.

    l := d addTextLabel:(resources string:'Destination directories:').
    l adjust:#left; backgroundColor:dark; foregroundColor:Color white.

    l := d addTextLabel:(resources string:'(the default below is recommended)').
    l adjust:#right; backgroundColor:dark; foregroundColor:Color white.

    cm := ComboBoxView on:stxInstDirHolder.
    list := self defaultInstDirs collect:[:line |
                line replChar:$\ withString:'\\'
            ].
    cm list:list.
    d 
        addLabelledField:cm 
        label:(resources string:'install into:')
        adjust:#left 
        tabable:true 
        from:0.0 to:1.0 separateAtX:0.25
        nameAs:'instDirBox'.

    (d componentAt:'instDirBox.label') backgroundColor:dark; foregroundColor:Color white.

"/    cm := ComboBoxView on:stxBinDirHolder.
"/    list := self defaultBinDirs collect:[:line |
"/                line replChar:$\ withString:'\\'
"/            ].
"/    cm list:list.
"/    d 
"/        addLabelledField:cm 
"/        label:(resources string:'binaries')
"/        adjust:#left 
"/        tabable:true 
"/        from:0.0 to:1.0 separateAtX:0.25
"/        nameAs:'binaryBox'.
"/
"/    (d componentAt:'binaryBox.label') backgroundColor:dark; foregroundColor:Color white.
"/
"/    cm := ComboBoxView on:stxLibBinDirHolder.
"/    cm list:self defaultLibBinDirs.
"/    d 
"/        addLabelledField:cm 
"/        label:(resources string:'libraries') 
"/        adjust:#left 
"/        tabable:true 
"/        from:0.0 to:1.0 separateAtX:0.25
"/        nameAs:'libraryBinBox'.
"/
"/    (d componentAt:'libraryBinBox.label') backgroundColor:dark; foregroundColor:Color white.
"/
"/    cm := ComboBoxView on:stxLibDirHolder.
"/    cm list:self defaultLibDirs.
"/    d 
"/        addLabelledField:cm 
"/        label:(resources string:'other files') 
"/        adjust:#left 
"/        tabable:true 
"/        from:0.0 to:1.0 separateAtX:0.25
"/        nameAs:'libraryBox'.
"/
"/    (d componentAt:'libraryBox.label') backgroundColor:dark; foregroundColor:Color white.

    d addVerticalSpace.
    d addHorizontalLine.
    d addVerticalSpace.

    (d addTextLabel:(resources string:'required:'))
        adjust:#left; foregroundColor:Color white backgroundColor:dark.

    d leftIndent:35.
    (d addTextLabel:(resources string:'binaries (approx. %1 Mb)' with:binMegabytes printString))
        adjust:#left; foregroundColor:Color white backgroundColor:dark.
    (d addTextLabel:(resources string:'libraries (approx. %1 Mb)' with:libMegabytes printString))
        adjust:#left; foregroundColor:Color white backgroundColor:dark.
    d leftIndent:0.

    d addVerticalSpace.
    d addHorizontalLine.
    d addVerticalSpace.

    (d addTextLabel:(resources string:'optional:'))
        adjust:#left; foregroundColor:Color white backgroundColor:dark.

    (d addCheckBox:((resources string:'doc files (+%1 Mb)' with:docMegabytes)) on:installDocHolder)
        labelView foregroundColor:Color white backgroundColor:dark.
    (d addCheckBox:((resources string:'stc & support files (+%1 Mb)' with:stcMegabytes)) on:installSTCHolder)
        labelView foregroundColor:Color white backgroundColor:dark.

    d addVerticalSpace.
    d addHorizontalLine.
    d addVerticalSpace.

    (d addTextLabel:(resources string:'optional (but highly recommended):'))
        adjust:#left; foregroundColor:Color white backgroundColor:dark.

    (d addCheckBox:((resources string:'smalltalk source files (+%1 Mb)' with:srcMegabytes)) on:installSourceHolder)
        labelView foregroundColor:Color white backgroundColor:dark.
    (d addCheckBox:((resources string:'goodies (+%1 Mb)' with:goodyMegabytes)) on:installGoodiesHolder)
        labelView foregroundColor:Color white backgroundColor:dark.

    d addVerticalSpace.
    d addHorizontalLine.

    d addHelpButtonFor:'STXInstaller/installHelp.html';
      addAbortButton; 
      addOkButtonLabelled:(resources string:'install').
    d extent:500@400.
    d resize. "/ compute best size

    d allViewBackground:dark.

    d openAtCenter.
    d accepted ifTrue:[
        stxInstDir := LastPartialDir := stxTopDir := stxInstDirHolder value.
        stxDocDir := stxInstDir asFilename constructString:'doc'.
        stxLibDir := stxInstDir asFilename constructString:'lib'.
        stxLibBinDir := stxInstDir asFilename constructString:'lib'.
        stxBinDir := stxInstDir asFilename constructString:'bin'.
        stxPkgDir := stxInstDir asFilename constructString:'packages'.

"/        stxLibDir := LastLibDir := stxLibDirHolder value.
"/        stxLibBinDir := LastLibBinDir := stxLibBinDirHolder value.
"/        stxBinDir := LastBinDir := stxBinDirHolder value.
        installDocFiles := installDocHolder value.
        installSourceFiles := installSourceHolder value.
        installSTCFiles := installSTCHolder value.
        installGoodyFiles := installGoodiesHolder value.
        d destroy.
        ^ true
    ].
    d destroy.
    ^ false

    "
     STXInstaller open
    "

    "Created: / 25.2.1998 / 17:11:26 / cg"
    "Modified: / 31.5.1999 / 18:37:50 / cg"
!

askForFullInstallation
    "open a dialog to ask if a full installation is wanted;
     Leave the result in installWhat (a symbol, either #full or #partial)."

    |d cm l green dark img|

    Screen current hasColors ifTrue:[
        green := (Color red:0 green:80 blue:20) "darkened".
        dark := Color grey:10.
    ] ifFalse:[
        green := Color white.
        dark := Color black.
    ].

    d := DialogBox new.

    d label:(resources string:'ST/X CD Installation').
    img := Image fromFile:'SmalltalkX.xbm'.

    l := d addTextLabel:img.
    l adjust:#left; foregroundColor:green backgroundColor:dark.

    l := d addTextLabel:(resources string:'Smalltalk/X CD installation.').
    l adjust:#left; backgroundColor:dark; foregroundColor:Color white.
    d addVerticalSpace.
    d addVerticalSpace.

    d addHorizontalLine.

    l := d addTextLabel:(resources string:
'You can either perform a ' , 'full' asText allBold , ' installation, or a ' , 'standard' asText allBold ,' (partial) installation.').
    l adjust:#left; backgroundColor:dark; foregroundColor:Color white.

    d addVerticalSpace.
    d addHorizontalLine.

    d leftIndent:20.
    l := d addTextLabel:(resources string:
'full:' asText allBold , '
The full installation is required if you want to build your own
customized smalltalk executable. It allows you to create and include 
additional precompiled binary classes or classLibraries. 
This is also required if you want to link your own standalone executables.

It consists of a directory hierachy, including makefiles for a customizeable 
rebuild of the whole smalltalk system.
(Actually, it simply copies the whole CD contents onto your disk).
This requires roughly 200-300Mb of hard disk space (dep. upon architecture).').
    l adjust:#left; backgroundColor:dark; foregroundColor:Color white.

    d addVerticalSpace.
    d addHorizontalLine.

    l := d addTextLabel:(resources string:
'standard:' asText allBold , '
The standard (runTime) installation requires less disk space and only copies the
smalltalk executable, shared libraries and support files onto your hard disk.
This setup allows normal smalltalk development and is also useful as a runtime
environment for smalltalk applications.
However, it does not support recreation of a new smalltalk executable and/or
shared binary classLibraries.
This setup also saves a lot of disk space, if multiple users are going to
use smalltalk, since most of the code is shared (both on disk and in memory).
This requires roughly 70-120Mb of hard disk space (dep. upon architecture).


 ').
    l adjust:#left; backgroundColor:dark; foregroundColor:Color white.


    d leftIndent:0.
    d addVerticalSpace.
    d addHorizontalLine.


    d addHelpButtonFor:'STXInstaller/installHelp.html';
      addAbortButton; 
      addOkButton:(Button label:(resources string:'full') action:[installWhat := #full]);
      addOkButtonLabelled:(resources string:'standard').
    d extent:500@500.
    d resize.    "/ compute best size ...

    d allViewBackground:dark.

    installWhat := #partial.
    d openAtCenter.
    d accepted ifTrue:[
        d destroy.
        ^ true
    ].
    d destroy.
    ^ false

    "
     STXInstaller open
    "

    "Created: / 25.2.1998 / 16:50:16 / cg"
    "Modified: / 25.2.1998 / 19:42:31 / cg"
!

checkForExistingInstallationAndConfirm
    "look if there is another installation and confirm
     reinstalling; return true if ok, false if not"

    |whichDir canOverWrite whatToDo box|

    installWhat == #full ifTrue:[
        whichDir := fullDir.
        canOverWrite := false.
    ] ifFalse:[
        whichDir := stxLibDir.
        canOverWrite := true.
    ].

    whichDir asFilename exists ifTrue:[
            whatToDo := Dialog 
                            choose:(resources 
                                        string:'detected existing ST/X installation in %1' 
                                          with:whichDir asText allBold)
                            label:(resources string:'Attention')
                            labels:(resources array:(canOverWrite 
                                                    ifFalse:[#('remove first' 'cancel')] 
                                                    ifTrue:[#('remove first' 'overwrite' 'cancel')] )) 
                            values:(canOverWrite ifFalse:[#(remove nil)] ifTrue:[#(remove over nil)])
                            default:nil.     

            whatToDo isNil ifTrue:[^false].
            whatToDo == #remove ifTrue:[
                ((whichDir findString:'stx') == 0
                and:[(whichDir findString:'smalltalk') == 0]) ifTrue:[
                    "/ confirm again
                    (self confirm:(resources 
                                    string:'are you certain that the directory to remove
(' , whichDir , ') is really a smalltalk directory ?

Remove it now ?')) ifFalse:[ 
                        ^ false
                    ]
                ].

                [
                    box := DialogBox new label:'please wait'.
                    box addTextLabel:'removing ' , whichDir , ' ...'.
                    box showAtPointer.
                ] forkAt:(Processor activePriority+1).
                box waitUntilVisible.

                (OperatingSystem recursiveRemoveDirectory:whichDir)
                ifFalse:[
                    OperatingSystem removeDirectory:whichDir.
                    whichDir asFilename exists ifTrue:[
                        self warn:(resources string:'mhmh - could not remove old installation.

Please remove it manually (using administrator privileges if required) 
and try again.').
                        box destroy.
                        ^ false
                    ]
                ].

                box destroy
            ].
    ].

    ^ true

    "
     STXInstaller open
    "

    "Modified: / 31.5.1999 / 13:23:03 / cg"
!

doInstall
    "install ST/X; return true if ok, false if not"

    |progressView ok v textView p l 
     dirToMonitor doDfMonitoring dfMonitorProcess kB drive|

    doDfMonitoring := false.

    v := View new preferredExtent:(250 @ 350).

    textView := HVScrollableView for:TextCollector in:v.
    textView origin:0.0@0.0 corner:1.0@1.0.
    textView bottomInset:30.
    textView lineLimit:10000.
    commandTraceView := textView scrolledView.

    installWhat == #full ifTrue:[
        dirToMonitor := fullDir.
    ] ifFalse:[
        dirToMonitor := stxLibDir
    ].

    OperatingSystem isMSWINDOWSlike ifTrue:[
        drive := Filename rootDirectoryOnVolume:(dirToMonitor asFilename volume)
    ] ifFalse:[
        drive := dirToMonitor
    ].
    drive := drive asFilename.

    p := HorizontalPanelView in:v.
    p origin:0.0@1.0 corner:1.0@1.0.
    p topInset:-30.
    p horizontalLayout:#fit.

    l := Label label:'' in:p.
    l labelChannel:(dfHolder := '' asValue).
    l adjust:#left.
    dfMonitorProcess := [
        |ok info free kB i l|

        ok := true.
        [ok] whileTrue:[
            doDfMonitoring ifTrue:[
                ok := false.
                info := OperatingSystem getDiskInfoOf:drive pathName.
                info notNil ifTrue:[
                    free := info at:#freeBytes ifAbsent:nil.
                    free notNil ifTrue:[
                        kB := free / 1024.
                        kB > 10000 ifTrue:[
                            l := (kB // 1024) printString, 'Mb available.'.
                        ] ifFalse:[
                            l := kB printString , 'Kb available.'.
                        ].
                        dfHolder value:l.
                        ok := true.
                        Delay waitForSeconds:9.
                    ].
                ].
            ].
            Delay waitForSeconds:1.
        ]
    ] forkAt:(Processor activePriority+3).

    progressView := ProgressIndicator
                        inBoxWithLabel:'ST/X Installation' icon:(Icon stxIcon)
                        text:#('ST/X Installation' '' '' '' '' '' '' '') asStringCollection
                        abortable:true
                        view:v
                        closeWhenDone:false.
    progressView topView extent:(640 min:Display width) @ (500 min:Display height).

    ok := false.

    progressView showProgressOf:
            [:progressValue :currentAction| |msg|

              Processor activeProcess withPriority:7 do:[
                  [
                      actionPercentageHolder := progressValue.
                      actionTextHolder := currentAction.

                      installWhat == #full ifFalse:[
                            self outputInitialMessage.
                      ].

                      (self createDirectories) ifTrue:[
                          doDfMonitoring := true.
                          ok := self copyFiles
                      ].
                      self changeWritability.
                      self createSymbolicLinks.
                      self removeMakefilesInDoc.

                      OperatingSystem isMSWINDOWSlike ifTrue:[
                          self createRegistryEntries.
                      ].

                      progressValue value:100.

                      progressView topView raise.
                      commandTraceView showCR:'Installation finished.' asText allBold.
                      commandTraceView endEntry. 
                      textView flash.

                      progressView topView abortButton label:(resources string:'continue').
                      progressView topView abortButton action:[progressView topView hide].
                      msg := (resources 
                                 array:#('ST/X Installation finished.' '' 'press continue ...' '' '' ''))
                                     asStringCollection.
                      actionTextHolder value:nil.
                      actionTextHolder value:msg.
                 ] valueOnUnwindDo:[
                    dfMonitorProcess notNil ifTrue:[
                        dfMonitorProcess terminate.
                        dfMonitorProcess := nil.
                    ].
                    copyProcess notNil ifTrue:[
                        copyProcess terminate.
                        copyProcess := nil.
                    ].
                 ]
              ] 
            ].

    dfMonitorProcess notNil ifTrue:[
        dfMonitorProcess terminate.
        dfMonitorProcess := nil.
    ].
    copyProcess notNil ifTrue:[
        copyProcess terminate.
        copyProcess := nil.
    ].
    ^ ok

    "
     STXInstaller open
    "

    "Created: / 17.7.1996 / 15:11:27 / cg"
    "Modified: / 31.5.1999 / 14:45:12 / cg"
!

open
    self askAndInstall.

    "
     LastLibDir := LastBinDir := LastLibBinDir := nil.
     LastPartialDir := LastFullDir := nil.

     STXInstaller open
    "

    "Modified: / 31.5.1999 / 18:28:10 / cg"
!

postInstall
    "some messages at the end ..."

    |shInfo cshInfo msg havePath|

    resources isNil ifTrue:[
        resources := ResourcePack for:self class.
    ].

    msg := (resources string:'ST/X Installation complete.\\') withCRs.
    shInfo := ''.
    cshInfo := ''.

    OperatingSystem isMSWINDOWSlike ifFalse:[

        installWhat == #full ifTrue:[
            msg := msg , 'You will now find a development directory hierarchy
in ''' , fullDir asText allBold , '''.

To try it, ''cd'' to ''' , fullDir , '/projects/smalltalk''
and start smalltalk with the command: ''./smalltalk''.

To perform a partial installation of your customized smalltalk later,
use the INSTALL script found in ''' , fullDir , ''''.

        ] ifFalse:[
            havePath := true.
            (((OperatingSystem getEnvironment:'PATH')
                asCollectionOfSubstringsSeparatedBy:$:)
                    includes:stxBinDir) ifFalse:[

                havePath := false.
                shInfo  := 'PATH=$PATH:' , stxBinDir , ' ; export PATH\'.
                cshInfo := 'set path=($path ' , stxBinDir , ')\'.
                msg := msg , (resources string:'%1 is not in your PATH.\You should change your ".login" and/or ".profile" files to include it.\\'
                                          with:stxBinDir asText allBold) withCRs.
            ].

            (stxLibDir ~= '/usr/local/lib/smalltalk'
            and:[stxLibDir ~= '/usr/lib/smalltalk'
            and:[stxLibDir ~= ('/opt/smalltalk/' , self smalltalkRelease , '/lib')]]) ifTrue:[
                msg := msg , (resources string:'The library directory is not a standard ST/X library directory\("/opt/smalltalk/' , self smalltalkRelease , '/lib", "/usr/local/lib/smalltalk" or "/usr/lib/smalltalk").
You may have to define the %1 environment variable\as %2 if ST/X complains about not finding its files.\'
                                          with:'STX_LIBDIR' asText allBold 
                                          with:stxLibDir asText allBold) withCRs.
                havePath ifFalse:[
                    msg := msg , (resources string:'The above mentioned files are also a good place to do this.\') withCRs.
                ] ifTrue:[
                    msg := msg , (resources string:'The ".login" and/or ".profile" files are a good place to do this.\') withCRs.
                ].

                shInfo := shInfo , 'STX_LIBDIR=' , stxLibDir , ' ; export STX_LIBDIR\'.
                cshInfo := cshInfo , 'setenv STX_LIBDIR ' , stxLibDir , '\'.
            ].

            shInfo notEmpty ifTrue:[
                '*********************************************************' errorPrintCR.
                (resources string:'Message from the ST/X Installer:\\') withCRs errorPrintCR.
                (resources string:'Please add the following to your ".profile" file:') withCRs errorPrintCR.
                '' errorPrintCR.
                shInfo withCRs errorPrintCR.
                '' errorPrintCR.
                (resources string:'or (if you use csh/tcsh), add to your ".login" file:') withCRs errorPrintCR.
                '' errorPrintCR.
                cshInfo withCRs errorPrintCR.
                '' errorPrintCR.
                '*********************************************************' errorPrintCR.
            ].
        ].
    ].
    msg := msg , '\\Have fun using ST/X !!'.

    self information:msg withCRs.

    "Modified: / 30.4.1999 / 17:59:39 / cg"
!

preInstall
    "clobber the doc directory, to avoid copying cyclic symbolic links.
     Notice, the CD does not contain symlinks, but checking for them
     allows installing from a development dir."

    |f|

    OperatingSystem isMSWINDOWSlike ifFalse:[
        f := '../../doc/online/english/german' asFilename.
        f exists ifTrue:[
            f isSymbolicLink ifTrue:[
                OperatingSystem executeCommand:'(cd ../../doc/online; make clobber) >/dev/null 2>/dev/null'
            ]
        ]
    ]

    "
     STXInstaller new preInstall
    "

    "Modified: / 30.4.1999 / 17:54:38 / cg"
! !

!STXInstaller class methodsFor:'documentation'!

version
    ^ '$Header$'
! !
