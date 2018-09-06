"
 COPYRIGHT (c) 1995 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

AbstractSourceCodeManager subclass:#CVSSourceCodeManager
	instanceVariableNames:''
	classVariableNames:'AuthorMap CMD_checkout CVSCommandSemaphore CVSCommandTimeout
		CVSCommitOptions CVSExecutable CVSModuleRoots CVSRoot CVSTempDir
		CVSUpdateOptions DisabledModules RecentTags
		RecentlyCheckedModulesAndPackages RemoteCVS'
	poolDictionaries:''
	category:'System-SourceCodeManagement'
!

VersionInfo subclass:#CVSVersionInfo
	instanceVariableNames:'repositoryPathName timeZone changedLinesInfo'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CVSSourceCodeManager
!

!CVSSourceCodeManager class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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
    SourceCodeManager which accesses the sourcecode through cvs.
    It requires the shell environment variable CVSROOT to be set
    to the top of the repository tree. (or alternatively, the CVSRoot
    variable being set by a private.rc file).
    Under that top, for each module (especially the stx module itself), 
    a subdirectory containing that modules directories must exist.

    If not specified otherwise, the module defaults to 'stx'. 
    If a class has its home in another module, it has to be compiled
    with a corresponding entry in the package string (see below).
    Within a module, classes are organized in classlibraries, and the corresponding
    source code is found in various subdirectories of CVSROOT. The directories
    name can also be provided by the package string - if not, it defaults to the
    libraries name.
    The package string controls all this, and is REQUIRED in order for the sourceCodeManager
    to be able to retrieve a classes source.
    The package strings format is:
        '...any infotext....(sourceCodeInfo)'
    the sourceCOdeInfo consists of multiple entries, separated by colons.
    The following formats are allowed:
        (libraryName)                   - module defaults to 'stx'; directory to the name of the library
        (foo/bar/x)                     - module defaults to 'stx'; dir is 'foo/bar/x'; library name defaults to x
        (module:directory:libname)      - specifies all components
    The first formats are intermediate, for backward compatibility. We urge everyone
    to use the last format (by changing the Make.proto files and add a -P flag to
    the stc compiler flags (see libbasic/Make.proto as an example).

    Notice, that the sourceCodeManager is (currently) only consulted, if no
    source subdirectory exists, or no source file is found there. If it does exist,
    that one is supposed to contain an up-to-date version of the classes source
    (this is temporary - in the future the probe order will be reversed, trying
     the source repository first).
    The source directory is required for systems which do NO source code control.

    Setup:
        - make certain, that the commands 'cvs' and 'co' are available on your system.
        - add setup for the CVSROOT environment variable to your .bashrc / .login / .profile
        - Make certain that either no local source directory exists, or it is empty or it contains
          only source code for files NOT found in the repository (this will not be required in future versions).

    Caveat:
        currently, the rcs container is accessed directly, since cvs mangles the file's ident-string and
        thus does not correctly recreate the original file (all source is offset by some characters w.r.t. the
        compiled file).
        Therefore, server-mode CVS is not supported.

    Comment:
        The code here is a copy-paste mess; it definitely needs some cleanup...

    [class variables:]
        CVSTempDir      <String | nil>  where a directory tree is
                                        generated temporarily for checkin/checkout
                                        (default is nil -> systems tmp-dir)

        CVSRoot         <String>        the CVS root. Imported from the
                                        CVSROOT shell variable.

        RemoteCVS       <Boolean>       if true, remote CVS access is used
                                        (i.e. via a socket to a CVS server).
                                        if false, disk access is used;
                                        files in CVSRoot must be accessible.

        CVSWorkDirectory                not yet supported/implemented.
                                        PLANNED: name of a directory hierarchy,
                                        which is kept in sync with the current
                                        version.

        CVSBinDir                       where the CVS commands are found

        CVSModuleRoots  <Directory>     per-module roots.
                                        If empty, or no entry is found for a
                                        module is found, CVSRoot is used.
                                        Otherwise, specifies a per-module CVSRoot.
                                        (allows multiple CVS hierarchies)

    [author:]
        Claus Gittinger

    [see also:]
        ( cvs manual page :man: cvs )
        ( Coding style used in Smalltalk/X classes :html: programming/codingStyle.html )
"
!

examples
"
    Default setup:
        This setup accesses all sources from a single repository: /files/CVS.
        Actually, this is the setup as used within eXept for development.

            CVSSourceCodeManager initializeForRepository:'/files/CVS'.


    Dual repository setup:
        This accesses all ST/X standard classes' source from the /files/CVS
        repository, while your private classes are created in and accessed from
        '/files/myCVS'.
        This setup is useful, if you need revision management on the
        ST/X standard classes as well as for your own classes.
        In order to do this, you should (manually) check in all ST/X classes
        into a private repository WHILE preserving the original revision numbers.
        A shell-procedure similar to:

            for i in lib*/*.st
            do
                id=`ident $i`
                set $id
                rev=$3
                ci -r$rev <CVSDIR>/$i $i
            done

        should acomplish this.
        Now, that you have all ST/X files in your own repository (and with the
        original revision numbers), access is possible by defining CVSROOT
        as above. However, in order to have your own files being stored in
        another repository, you have to give a per-module repository.

        This defines the default repository (for your containers):

            CVSSourceCodeManager initializeForRepository:'/files/myCVS'.

        and this specifies a repository for all standard ST/X classes (in the stx module):

            CVSSourceCodeManager repositoryName:'/files/CVS' forModule:'stx'

    Dual repository setup for eXept customers with a full licence
    (these can access our in-house master repository, for convenient software update
     and uploading):
        All class sourcees under the 'stx' module (i.e. packageID is 'stx:*') can be accessed
        from the eXept cvs server (i.e. CVSROOT for them is :pserver:userName@exept.de:/files/CVS/stc).
        All local classes should be maintained in and accessed from a local cvs repository
        such as '/files/myCVS'.

        Then, tell the CVSSourceCodeManager about this;
        first the default repository:

            CVSSourceCodeManager initializeForRepository:'/files/myCVS'.

        and the repository for all standard ST/X classes (in the stx module):

            CVSSourceCodeManager repositoryName:':pserver:userName@exept.de:/files/CVS' forModule:'stx'
"
! !

!CVSSourceCodeManager class methodsFor:'initialization'!

addExeptsPrivateRepositoryToModuleRoots
    CVSModuleRoots at:'stx' put:(self exeptsPrivateSTXRepositoryModuleRoot).
    CVSModuleRoots at:'exept' put:(self exeptsPrivateSTXRepositoryModuleRoot).
!

addExeptsPublicRepositoryToModuleRoots
    CVSModuleRoots at:'stx' put:(self exeptsPublicSTXRepositoryModuleRoot)
!

exeptsPrivateSTXRepositoryModuleRoot
    "the actual stx repository as used within exept.
     Only valid within exept"
    
    ^ ':pserver:',(OperatingSystem getLoginName),'@cvs.bh.exept.de:/cvs/stx'.
!

exeptsPublicSTXRepositoryModuleRoot
    "the public repository, which is a read-only copy of the exept-internal repository.
     Updated every night." 
     
    ^ ':pserver:cvs@cvs.smalltalk-x.de:/cvs/stx'.
!

forgetDisabledModules
    DisabledModules := nil.
!

initCommands
    CMD_checkout := 'cvs -n checkout %1'.

    "Modified: / 13-10-2006 / 00:44:13 / cg"
!

initialize
    "check if $CVSROOT (the shell variable) or CVSRoot (the smalltalk global)
     is set, check if cvs commands can be executed and install myself as the
     SourceCodeManager if this works out ok"

    | s f top |

    CVSCommandSemaphore isNil ifTrue:[
        CVSCommandSemaphore := (Semaphore new:10) name:'Concurrent CVS Commands'.    "/ at most 10 cvs activities concurrently
    ].
    CVSCommitOptions isNil ifTrue:[
        CVSCommitOptions := ''.
        CVSUpdateOptions := ''.
    ].
    RemoteCVS isNil ifTrue:[
        RemoteCVS := true.
    ].
    DisabledModules := nil.
    CVSModuleRoots isNil ifTrue:[
        CVSModuleRoots := Dictionary new.
    ].
    "/ self possiblyAddExeptsPrivateRepositoryToModuleRoots.

    "/
    "/ if CVSROOT is non-empty and both cvs and co are available
    "/ as commands, assume this system uses a cvs source code management.
    "/
    CVSRoot isNil ifTrue:[
        CVSRoot := OperatingSystem getEnvironment:'CVSROOT'.
        CVSRoot isNil ifTrue:[
            "disabled since $CVSROOT is not set"
            ^ self
        ].
    ].

    UseWorkTree := false.

    "/
    "/ check if there is an stx directory there
    "/
    ((f := CVSRoot asFilename) isDirectory 
    and:[(top := f construct:'stx') isDirectory
    and:[top isReadable]]) ifTrue:[
        RemoteCVS := false
    ].

    DefaultManager isNil ifTrue:[
        DefaultManager := self.    
    ].

    ('CVSSourceCodeManager [info]: repository CVSROOT is ''' , CVSRoot , '''.') infoPrintCR.
    RemoteCVS ifFalse:[
        'CVSSourceCodeManager [info]: using faster local CVS mode' infoPrintCR.
        ^ self
    ].

    "/
    "/ optionally set the WorkTreeDirectoryName from $STX_WORKTREE;
    "/ if non-nil, a working tree is kept there
    "/ and updated/commited files are not removed.
    "/ If you use a regular (make-) tree, 
    "/ set WorkTreeDirectoryName (or the environment variable) to that.
    "/
    "/ this is not yet finished.
    "/
    s := OperatingSystem getEnvironment:'STX_WORKTREE'.
    s notNil ifTrue:[
        WorkTreeDirectoryName := s.
        UseWorkTree := true.
    ]

    "
     AbstractSourceCodeManager initialize
     CVSSourceCodeManager initialize
    "

    "
     CVSRoot := '/files/CVS'.
     AbstractSourceCodeManager initialize.
     CVSSourceCodeManager initialize.
    "

    "
     CVSRoot := ':pserver:cg@cvs.bh.exept.de:/cvs/stx'.
     AbstractSourceCodeManager initialize.
     CVSSourceCodeManager initialize.
     SourceCodeManager := CVSSourceCodeManager.
    "

    "Created: / 04-11-1995 / 19:14:38 / cg"
    "Modified: / 19-12-1995 / 14:25:46 / stefan"
    "Modified: / 20-03-2012 / 19:06:35 / cg"
!

initializeForRepository:aDirectoryName
    "set the global CVSROOT directory (i.e. the repositories name).
     And reinitialize. 
     Can be used from the launcher to change/configure the repository."

    self repositoryName:aDirectoryName.
    AbstractSourceCodeManager initialize.
    self initialize.

    "
     CVSSourceCodeManager initializeForRepository:'/files/CVS'
     CVSSourceCodeManager initializeForRepository:'ibm:/files/CVS'
    "

    "Created: / 13.8.1997 / 17:20:57 / cg"
    "Modified: / 25.9.1997 / 12:28:05 / stefan"
    "Modified: / 2.11.1997 / 17:08:27 / cg"
!

possiblyAddExeptsPrivateRepositoryToModuleRoots
    "/ for exept's convenience: if this is a host in our domain,
    "/ add the exept repository.

    ((OperatingSystem getDomainName endsWith:'exept.de') or:[
     OperatingSystem getNetworkAddresses contains:[:eachSocketAddress| eachSocketAddress hostAddress startsWith: #[172 23 1]]]
    ) ifTrue:[
        self addExeptsPrivateRepositoryToModuleRoots.
    ].
!

validateWorkingCopy: path
    "Return true, if given path is a valid working 
     copy of this manager; false otherwise."

    ^ (path asFilename / 'CVS') isDirectory and:[ (path asFilename / 'CVS' / 'Root') exists ]

    "Created: / 02-10-2015 / 09:59:04 / jv"
! !

!CVSSourceCodeManager class methodsFor:'accessing'!

CVSCommitOptions
    ^ CVSCommitOptions ? ''
!

CVSCommitOptions:aString
    CVSCommitOptions := aString.
!

CVSUpdateOptions
    ^ CVSUpdateOptions ? ''
!

CVSUpdateOptions:aString
    CVSUpdateOptions := aString.
!

cvsBinDirectory:ignoredString
    "ignored - for backward compatibility (to read old settings files)"

    "Created: / 21-09-2006 / 17:26:43 / cg"
!

cvsCommandTimeout
    ^ CVSCommandTimeout ? ("360" 120 seconds)

    "Modified (comment): / 08-01-2012 / 19:02:44 / cg"
!

cvsCommandTimeout:aTimeDuration
    CVSCommandTimeout := aTimeDuration asTimeDuration.

    "Created: / 08-01-2012 / 19:36:01 / cg"
!

cvsExecutable
    "return the name of the cvs executable."

    ^ CVSExecutable ? 'cvs'

    "Created: / 21-09-2006 / 15:31:12 / cg"
!

cvsExecutable:aString
    "set the name of the cvs executable."

    aString isEmptyOrNil ifTrue:[
        CVSExecutable := nil
    ] ifFalse:[        
        CVSExecutable := aString.
    ].

    "Created: / 21-09-2006 / 15:31:59 / cg"
    "Modified: / 21-09-2006 / 16:41:33 / cg"
!

cvsTmpDirectory
    "return the name of the tmp repository.
     That's the directory, where temporary files are created for checkin/checkout.
     If nil, a directory under the system's default tempDirectory is used."

    |d|

    CVSTempDir notNil ifTrue:[^ CVSTempDir].
    d := Filename tempDirectory / 'stx_cvs'.
    d exists ifFalse:[
        d recursiveMakeDirectory.
    ].
    ^ d pathName

    "
     CVSTempDir := nil   
    "

    "Modified (comment): / 24-09-2012 / 11:09:38 / cg"
!

cvsTmpDirectory:aPathNameString
    "set the name of the tmp repository.
     That's the directory, where temporary files are created for checkin/checkout.
     If nil, the system's default tempDirectory is used."

    CVSTempDir := aPathNameString

    "Modified (comment): / 24-09-2012 / 11:09:34 / cg"
!

knownModules
    "return the modules, we currently know"

    CVSModuleRoots isEmptyOrNil ifTrue:[^ #() ].
    ^ CVSModuleRoots keys

    "Modified: / 26-12-2011 / 00:49:03 / cg"
!

knownRepositories
    "return the modules, we currently know"

    ^ CVSModuleRoots values copyWith:CVSRoot 
!

recentTag
    "a place to remember recently set tags (to share between File and SystemBrowser)"

    ^ RecentTags isEmptyOrNil ifTrue:[nil] ifFalse:[RecentTags first].

    "
     self recentTag
    "
!

recentTag:aString
    "a place to remember recently set tags (to share between File and SystemBrowser)"

    aString isEmpty ifTrue:[
        ^ self.
    ].
    RecentTags isNil ifTrue:[
        RecentTags := OrderedCollection new.
    ].
    RecentTags remove:aString ifAbsent:[].
    RecentTags addFirst:aString.
    RecentTags size > 10 ifTrue:[ RecentTags removeLast].
!

recentTags
    "a place to remember recently set tags (to share between File and SystemBrowser)"

    ^ RecentTags
!

repositoryForPackage:packageId
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"

    ^self getCVSROOTForModule: ( packageId upTo:$:)

    "Modified: / 10-10-2011 / 19:38:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryInfoPerModule
    "return the dictionary, which associates CVSRoots to module names.
     If no entry is contained in this dictionary for some module,
     the default cvsRoot (CVSRoot) will be used."

    ^ CVSModuleRoots ? #()
!

repositoryInfoPerModule:aDictionary
    "set the dictionary, which associates CVSRoots to module names.
     If no entry is contained in this dictionary for some module,
     the default cvsRoot (CVSRoot) will be used."

    CVSModuleRoots := aDictionary
!

repositoryName
    "return the name of the global repository.
     This is used, if no per-module repository is defined."

    ^ CVSRoot

    "Created: 14.9.1996 / 13:22:05 / cg"
    "Modified: 19.9.1997 / 06:12:02 / cg"
!

repositoryName:aDirectoryName
    "set the name of the repository;
     that's the name of the global CVSROOT directory, which is used 
     if no specific repository was defined for a module.
     Can be used from an rc-script, to override the CVSROOT shell 
     variable setting."

    DisabledModules := nil.
    CVSRoot := aDirectoryName.

    "Created: / 14-09-1996 / 13:22:24 / cg"
    "Modified: / 19-09-1997 / 06:10:31 / cg"
    "Modified (comment): / 21-12-2011 / 14:54:15 / cg"
!

repositoryName:aRepositoryName forModule:aModuleName
    "set the CVSROOT directory which provides the sources for all 
     classes in a particular module.
     This can be used from an rc-script, to specify a repository
     for a particular module.
     If left unspecified, the global (i.e. fallBack) repository is used."

    DisabledModules := nil.
    CVSModuleRoots at:aModuleName put:aRepositoryName

    "Modified: 19.9.1997 / 06:09:40 / cg"
!

repositoryNameForModule:aModuleName
    "return the CVSROOT directory which provides the sources for all 
     classes in a particular module.
     Nil is returned for unspecified moduleRoots; in this case, 
     the global (i.e. fallBack) repository will be used for source access."

    ^ CVSModuleRoots at:aModuleName ifAbsent:nil.

    "Modified: 19.9.1997 / 06:09:40 / cg"
    "Created: 19.9.1997 / 06:13:06 / cg"
!

repositoryNameForPackage:packageId 
    "superclass AbstractSourceCodeManager class says that I am responsible to implement this method"
    
    ^ self getCVSROOTForModule:(packageId upTo:$: )

    "Created: / 10-10-2011 / 19:44:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 21-12-2011 / 23:03:29 / cg"
!

repositoryNamesPerModule
    <resource: #obsolete>
    "return the dictionary, which associates CVSRoots to module names.
     If no entry is contained in this dictionary for some module,
     the default cvsRoot (CVSRoot) will be used."

    self obsoleteMethodWarning:'use repositoryInfoPerModule'.
    ^ CVSModuleRoots 
!

repositoryNamesPerModule:aDictionary
    <resource: #obsolete>
    "set the dictionary, which associates CVSRoots to module names.
     If no entry is contained in this dictionary for some module,
     the default cvsRoot (CVSRoot) will be used."

    self obsoleteMethodWarning:'use repositoryInfoPerModule:'.
    CVSModuleRoots := aDictionary
! !

!CVSSourceCodeManager class methodsFor:'basic administration'!

createContainerFor:aClass inModule:moduleName directory:dirName container:fileName
    "create a new container & check into it an initial version of aClass"

    ^ self shouldImplement
! !

!CVSSourceCodeManager class methodsFor:'misc operations'!

authorMappingFor:authorName
    "allows for author names to be mapped on the fly
     when retrieving a revisionLog or other statistics.
     Useful when a login name is changed, and you still want to
     create reasonable logs"

    AuthorMap isNil ifTrue:[ ^ authorName ].
    ^ AuthorMap at:authorName ifAbsent:[ authorName ].

    "
     AuthorMap := Dictionary new
                    at:'claus' put:'cg';
                    yourself.
    "
!

changeCVSRoot:newRootString inDirectoryTree:aDirectoryFilename
    "WARNING: read and understand before executing !!
     Change the CVS root to newRootString (something like:':pserver:user@cvs.bh.exept.de:/cvs/stx').
     This is done by rewriting all files named CVS/Root below the given path.
     aDirectoryFilename is recursively descended"

    aDirectoryFilename asFilename allDirectoriesDo:[:eachDirectoryName|
        eachDirectoryName baseName = 'CVS' ifTrue:[
            self activityNotification:eachDirectoryName pathName.
            (eachDirectoryName construct:'Root') writeStream 
                nextPutLine:newRootString;
                close.
        ].
    ].
    self activityNotification:nil.

    "OperatingSystem getLoginName
     self 
        changeCVSRoot:':pserver:',OperatingSystem getLoginName,'@cvs.bh.exept.de:/cvs/stx' 
        inDirectoryTree:'../../../stx'

     self 
        changeCVSRoot:':pserver:',OperatingSystem getLoginName,'@cvs.bh.exept.de:/cvs/stx' 
        inDirectoryTree:'..\..\..\exept'

     self 
        changeCVSRoot:':pserver:',OperatingSystem getLoginName,'@cvs.bh.exept.de:/cvs/stx' 
        inDirectoryTree:'..\..\..\cg'
    "
! !

!CVSSourceCodeManager class methodsFor:'private'!

checkOut:relativeFilename module:moduleDir in:tempdir
    "checkout realtiveFilename in tempdir"

    |cmd|

    cmd := 'checkout -l ' , relativeFilename.
    ^ self 
        executeCVSCommand:cmd 
        module:moduleDir
        inDirectory:tempdir name
        log:false


    "
      self checkOut:'libbasic/Integer.st' module:'stx' in:'/tmp' asFilename
    "

    "Created: / 18.1.2000 / 20:30:01 / cg"
    "Modified: / 18.1.2000 / 20:35:06 / cg"
!

checkinTroubleDialog:title message:message log:log abortable:abortable option:optionTitle
    "trouble checking in - open a dialog"

    ^ self
        checkinTroubleDialog:title 
        message:message 
        log:log 
        abortable:abortable 
        option:optionTitle 
        option2:nil

    "Created: 10.12.1995 / 17:34:33 / cg"
    "Modified: 12.9.1996 / 02:39:06 / cg"
!

checkinTroubleDialog:title message:message log:log abortable:abortable option:optionTitle option2:optionTitle2
    ^self
        checkinTroubleDialog:title 
        message:message 
        log:log 
        abortable:abortable 
        option:optionTitle 
        option2:optionTitle2 
        option3:nil
!

checkinTroubleDialog:title message:message log:log abortable:abortable option:optionTitle option2:optionTitle2 option3:optionTitle3
    "trouble checking in - open a dialog"

    |l box list listView optionPressed option2Pressed option3Pressed|

    l := log collect:[:line | line withTabsExpanded].
    list := SelectionInList with:l.

    box := Dialog new.
    box label:(title).

    (box addTextLabel:message) borderWidth:0.

    listView := SelectionInListView on:list.
    listView disable.
    listView height:200.
    box addComponent:(HVScrollableView forView:listView miniScrollerH:true) tabable:false.
    box addVerticalSpace.

    abortable ifTrue:[
        box addAbortButton
    ].
    optionTitle notNil ifTrue:[
        box addOkButton:(Button label:optionTitle action:[optionPressed := true. box hide]).
    ].
    optionTitle2 notNil ifTrue:[
        box addOkButton:(Button label:optionTitle2 action:[option2Pressed := true. box hide]).
    ].
    optionTitle3 notNil ifTrue:[
        box addOkButton:(Button label:optionTitle3 action:[option3Pressed := true. box hide]).
    ].
    box addOkButton.

    box extent:(box preferredExtent).
    box minExtent:box extent.
    box maxExtent:box extent.

    box open.

    box destroy.
    optionPressed == true ifTrue:[^ #option].
    option2Pressed == true ifTrue:[^ #option2].
    option3Pressed == true ifTrue:[^ #option3].
    ^ box accepted

    "Created: 9.9.1996 / 19:12:45 / cg"
    "Modified: 12.9.1996 / 02:39:10 / cg"
!

createEntryFor:pathInRepository module:aModule in:aDirectory revision:rev date:date special:special overwrite:overwrite
    "create an CVS/Repository and CVS/Entries entry for filename. 
     If the path does not exist, it will be created
     If overwrite is true, an existing entry will be overwritten.
    "

    |filename cvsRoot cvsDir name entries firstPart entriesInStream path|

    filename := pathInRepository asFilename.
    cvsDir := (aDirectory asFilename construct:'CVS') recursiveMakeDirectory.
    entries := cvsDir construct:'Entries'.
    name := filename baseName.
    firstPart := '/', name, '/'.

    entriesInStream := entries readStreamOrNil.
    entriesInStream isNil ifTrue:[
        "/
        "/ no Repository yet, create one
        "/
        |root|

        cvsRoot := self getCVSROOTForModule:aModule.
        cvsRoot isNil ifTrue:[ self error:'missing/invalid CVSROOT setting' ].
        cvsRoot := cvsRoot withoutPrefix:':local:'.

        root := self repositoryTopDirectoryFromCVSRoot:cvsRoot.

        "/ create Repository
        "/ (notice, contents must be a Unix filename ...

        entriesInStream := (cvsDir construct:'Repository') writeStream.
        path := Filename components:filename directory name.
        path := path asStringWith:$/.
        entriesInStream nextPutLine:(root, '/', path).
        entriesInStream syncData; close.

        "/ make new Entries file.
        entriesInStream := entries writeStream.
    ] ifFalse:[
        |newName newStream line|

        newName := Filename newTemporaryIn:cvsDir.
        newStream := newName writeStream.
        [(line := entriesInStream nextLine) notNil] whileTrue:[
            (line findString:firstPart) ~= 1 ifTrue:[
                "/ we have found an entry for ourself.
                "/ If we do not want to overwrite it, clean up everything and return.
                overwrite ifFalse:[
                    newName remove.
                    newStream close.
                    entriesInStream close.
                    ^ self
                ].
                newStream nextPutLine:line
            ].
        ].
        newName renameTo:entries.
        entriesInStream close.
        entriesInStream := newStream.
    ].
    entriesInStream nextPutLine:firstPart, rev, '/', date, '/', special, '/'.
    entriesInStream syncData; close.

    "
        self createEntryFor:'foo/xxx/yyy' in:'foo/xxx' revision:'1.22' date:'dummy' special:''
        self createEntryFor:'foo/xxx/yyy' in:'foo/xxx' revision:'3.44' date:'new dummy' special:'special'
    "

    "Created: / 19-09-1997 / 06:21:02 / cg"
    "Modified: / 07-01-1998 / 14:15:35 / stefan"
    "Modified: / 21-06-2006 / 12:13:30 / cg"
!

createLocalDirectory:packageDir inModule:moduleDir
    "create a local working directory for module/package.
     To speed up things, we checkout the file '.cvsignore', to create
     the whole tree. If the file is not present, we will create it as empty file.
     Return the name of a temporary directory containing the package"

    ^ self
        createLocalDirectory:packageDir 
        inModule:moduleDir 
        with:'.cvsignore'
        andDefaultContents:
'makefile
*.STH
*.@@@
ntLibInit.c
*.res
*.RES
*.sc
*.c
objbc
objvc
objmingw
'.

    "
     self createLocalDirectory:'libbasic' inModule:'stx'
    "

    "Created: / 23.7.1999 / 19:14:28 / stefan"
    "Modified: / 26.7.1999 / 17:43:35 / stefan"
    "Modified: / 18.1.2000 / 20:56:19 / cg"
!

createLocalDirectory:packageDir inModule:moduleDir with:fileToCheckout
    "create a local working directory for module/package, and checkout the
     given file there.
     Return the name of a temporary directory containing the package, or nil"

    ^ self 
        createLocalDirectory:packageDir 
        inModule:moduleDir 
        with:fileToCheckout 
        andDefaultContents:nil

    "
     self createLocalDirectory:'libbasic' inModule:'stx'
    "

    "Modified: / 26-07-1999 / 17:43:35 / stefan"
    "Created: / 18-01-2000 / 20:55:52 / cg"
    "Modified: / 16-07-2013 / 19:49:26 / cg"
!

createLocalDirectory:packageDir inModule:moduleDir with:fileToCheckout andDefaultContents:defaultContents
    "create a local working directory for module/package, and checkout the
     given file there.
     Return the name of a temporary directory containing the package, or nil"

    |path absolutePath tempdir unixPath|

    path := (moduleDir asFilename construct:packageDir) construct:fileToCheckout.

    tempdir := self createTempDirectory:nil forModule:nil.
    tempdir isNil ifTrue:[
        ('no tempDir - cannot checkout') errorPrintCR.
        ^ nil
    ].

    [
        OperatingSystem isUNIXlike ifTrue:[
            unixPath := path name.
        ] ifFalse:[
            OperatingSystem isVMSlike ifTrue:[
                self error:'VMS case not yet implemented'
            ].
            unixPath := path name asUnixFilenameString
        ].

        (self checkOut:unixPath module:moduleDir in:tempdir) ifFalse:[
            "dummy file does not exist, so create it"

            absolutePath := tempdir construct:path.
            absolutePath directory recursiveMakeDirectory.

            "now create the file"
            absolutePath writingFileDo:[:s |
                defaultContents notNil ifTrue:[
                    s nextPutAll:defaultContents.
                ].
            ].

            "now create the dummy file in the repository"
            (self import:moduleDir in:tempdir) ifFalse:[
                ('CVSSourceCodeManager [error]: cannot import dummy') errorPrintCR.
            ].

            "remove the path, so that checkout works"
            (tempdir construct:moduleDir) recursiveRemove.

            "checkout the dummy, the intermediate directories will be created"
            (self checkOut:unixPath module:moduleDir in:tempdir) ifFalse:[
                ('CVSSourceCodeManager [warning]: import failed (to create working dir)') errorPrintCR.
"/false ifTrue:[
"/                "/ manually create it
"/
"/                (tempdir construct:unixPath) directory recursiveMakeDirectory.
"/                workingDir := tempdir.
"/                unixPath asFilename directory components do:[:each |
"/                    self executeCVSCommand:('add ' , each) module:moduleDir inDirectory:workingDir.
"/                    workingDir := workingDir construct:each.
"/                ].
"/                (absolutePath writeStream close) isNil ifTrue:[
"/                    ('CVSSourceCodeManager [error]: cannot create dummy') errorPrintCR.
"/                    tempdir recursiveRemove.
"/                    ^ nil.
"/                ].
"/                self executeCVSCommand:('add ' , fileToCheckout) module:moduleDir inDirectory:workingDir.
"/                self executeCVSCommand:('commit ' , fileToCheckout) module:moduleDir inDirectory:workingDir.
"/
"/                ^ tempdir
"/].
                tempdir recursiveRemove.
                ^ nil.
            ].
        ].
    ] ifCurtailed:[
        tempdir recursiveRemove.
    ].

    ^ tempdir.

    "
     self createLocalDirectory:'libbasic' inModule:'stx'
    "

    "Modified: / 26-07-1999 / 17:43:35 / stefan"
    "Created: / 18-01-2000 / 20:55:52 / cg"
    "Modified: / 16-07-2013 / 19:49:26 / cg"
!

createTempDirectory:packageDir forModule:moduleDir
    "create a temp directory for checking out"

    ^ self createTempDirectory:packageDir forModule:moduleDir in:(self cvsTmpDirectory)
!

cvsTimeString:timestamp
    "convert a Timestamp to a string suitable for the CVS/Entries file:

                         123456789012345678901234
                         Tue Dec 19 20:56:26 1995
    "

    ^ timestamp printStringFormat:'%(ShortDayName) %(ShortMonthName) %(day) %h:%m:%s %(year)' language:#en.

    "
     CVSSourceCodeManager cvsTimeString:(UtcTimestamp now)
    "
!

executeCVSCommand:cvsCommand module:moduleName inDirectory:dir
    "execute command and prepend cvs command name and global options.
     if dir ~= nil, execute command in that directory.
     This also leads to a log-entry to be added to cvs's logfile."

    ^ self
        executeCVSCommand:cvsCommand 
        module:moduleName 
        inDirectory:dir 
        log:true

    "Modified: / 20.5.1998 / 16:07:28 / cg"
!

executeCVSCommand:cvsCommand module:moduleName inDirectory:dir log:doLog
    "execute command and prepend cvs command name and global options.
     if dir ~= nil, execute command in that directory.
     The doLog argument, if false suppresses a logEntry to be added
     in the cvs log file (used when reading / extracting history)"

    ^ self
        executeCVSCommand:cvsCommand module:moduleName inDirectory:dir log:doLog
        pipe:false
!

executeCVSCommand:cvsCommand module:moduleName inDirectory:dirArg log:doLog errorTo:errorStream 
    ^ self 
        executeCVSCommand:cvsCommand
        module:moduleName
        inDirectory:dirArg
        log:doLog
        outputTo:nil
        errorTo:errorStream
!

executeCVSCommand:cvsCommand module:moduleName inDirectory:dirArg log:doLog outputTo:outStream errorTo:errorStream
    "execute command and prepend cvs command name and global options.
     execute command in the dirArg directory.
     The doLog argument, if false suppresses a logEntry to be added
     in the cvs log file (used when reading / extracting history)"

    ^ self
        executeCVSCommand:cvsCommand
        module:moduleName
        inDirectory:dirArg
        log:doLog
        pipe:false
        orElseOutputTo:outStream errorTo:errorStream

    "Modified: / 23-04-1996 / 15:24:00 / stefan"
    "Created: / 20-05-1998 / 16:06:34 / cg"
    "Modified: / 13-10-2011 / 17:07:07 / jv"
    "Modified: / 28-02-2012 / 17:31:34 / cg"
!

executeCVSCommand:cvsCommand module:moduleName inDirectory:dirArg log:doLog pipe:doPipe
    "execute command and prepend cvs command name and global options.
     execute command in the dirArg directory.
     The doLog argument, if false suppresses a logEntry to be added
     in the cvs log file (used when reading / extracting history)"

    ^ self
        executeCVSCommand:cvsCommand
        module:moduleName
        inDirectory:dirArg
        log:doLog
        pipe:doPipe
        orElseOutputTo:nil errorTo:nil

    "Modified: / 23-04-1996 / 15:24:00 / stefan"
    "Created: / 20-05-1998 / 16:06:34 / cg"
    "Modified: / 10-10-2011 / 14:47:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 13-10-2011 / 17:06:28 / jv"
    "Modified: / 28-02-2012 / 17:31:06 / cg"
!

executeCVSCommand:cvsCommand module:moduleName inDirectory:dirArg log:doLog pipe:doPipe orElseOutputTo:outStreamOrNil errorTo:errorStreamOrNil
    "execute command and prepend cvs command name and global options.
     execute command in the dirArg directory (or the current directory if dirArg is nil).
     The doLog argument, if false suppresses a logEntry to be added
     in the cvs log file (used when reading / extracting history)"

    |command cvsRoot rslt ok pathOfDir errorString osProcess|

    dirArg notNil ifTrue:[
        pathOfDir := dirArg asFilename pathName.
    ].

    cvsRoot := self getCVSROOTForModule:moduleName.
    cvsRoot := cvsRoot withoutPrefix:':local:'.

    command := self cvsExecutable.
    (command includes:Character space) ifTrue:[
        command := '"' , command , '"'
    ].
    doLog ifFalse:[
        "/ cvs  1.11.14 fails with -l option
        "/        command := command , ' -l'.
    ].

    "JV@2011-10-13: Try to be foolproof and set CVS_RSH on Windows"
    OperatingSystem isMSWINDOWSlike ifTrue:[
        (OperatingSystem getEnvironment:'CVS_RSH') isNil ifTrue:[
            (OperatingSystem canExecuteCommand: 'plink') ifTrue:[
                OperatingSystem setEnvironment: 'CVS_RSH' to: 'plink'
            ]
        ].
    ].

    command := command , ' -d "' , cvsRoot , '" ' , cvsCommand.

    Verbose == true ifTrue:[
        ('CVSSourceCodeManager [info]: executing: ' , command , ' [in ' , (pathOfDir ? '.') , ']') infoPrintCR.
    ].

    doPipe ifTrue:[
        rslt := PipeStream
                    readingFrom:command
                    errorDisposition:#inline
                    inDirectory:pathOfDir.
        ok := rslt notNil.
    ] ifFalse:[
        osProcess := OSProcess new
                        command:command;
                        outStream:outStreamOrNil;
                        errorStream:outStreamOrNil;
                        directory:pathOfDir.

        Processor isDispatching ifFalse:[
            "/ special hack to allow source code access during the initialization
            "/ phase (when threading is not yet enabled in the ProcessorScheduler)
            "/ execute the command in this thread, as opposed to the code below.
            ok := rslt := osProcess execute.
        ] ifTrue:[
            CVSCommandSemaphore critical:[
                |errOut done|

                errOut := WriteStream on:''.
                osProcess errorStream:errOut.
                ok := osProcess startProcess.

                [
                    done := true.
                    (osProcess waitUntilFinishedWithTimeout:self cvsCommandTimeout) isNil ifTrue:[
                        (Dialog confirm:('CVS command timeout (%1) for:\\%2\\Hint: you can change this timeout in the launcher''s settings dialog.\Proceed?' withCRs
                                                bindWith:self cvsCommandTimeout with:command)) 
                        ifTrue:[
                            done := false
                        ] ifFalse:[
                            ('CVSSourceCodeManager [info]: command timeout: ' , command) errorPrintCR.
                            osProcess terminate.
                            ok := false.
                            errorString := 'CVS command timeout'.
                        ].
                    ] ifFalse:[
                        ok := rslt := osProcess finishedWithSuccess.
                        ok ifFalse:[
                            errorString := errOut contents.
                        ].
                    ]
                ] doUntil:[done].
            ].
        ].
    ].
    ok ifFalse:[
        ('CVSSourceCodeManager [info]: command failed: ' , command) errorPrintCR.
        SourceCodeManagerError isHandled ifTrue:[
            SourceCodeManagerError raiseRequestErrorString:(errorString ? 'CVS Error').
        ].
    ].
    ^ rslt

    "Modified: / 23-04-1996 / 15:24:00 / stefan"
    "Modified: / 10-10-2011 / 14:47:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 13-10-2011 / 17:06:28 / jv"
    "Created: / 28-02-2012 / 17:30:34 / cg"
!

fetchRevisionsFromRLogStream:inStream searchForKeyword:searchFor
    "helper for revisionsInModule*"

    |info line s revisionUsed fileName|

    info := OrderedCollection new.

    [inStream atEnd] whileFalse:[
        line:= inStream nextLine.
        line notNil ifTrue:[
            line := line withoutSeparators.
            line notEmpty ifTrue:[
                s := line restAfter:'RCS file:' withoutSeparators:true. 
                s notNil ifTrue:[ 
                    (UnixFilename named:s) directory baseName = 'Attic' ifTrue:[
                        "/ file has been removed in the repository
                        revisionUsed := #deleted
                    ].
                    fileName := (UnixFilename named:s) baseName.
                    (fileName endsWith:',v') ifTrue:[
                        fileName := fileName copyButLast:2.
                    ] ifFalse:[
                        self halt:'oops - should not happen'.
                    ].
                ].
                s := line restAfter:searchFor withoutSeparators:true.
                s notNil ifTrue:[ |i|
                    i := s indexOfSeparator.
                    i ~~ 0 ifTrue:[
                        s := s copyTo:i-1
                    ].
                    revisionUsed := revisionUsed ? s.  "/ deleted-info comes from the Attic-component in the path
                    info add:(fileName -> revisionUsed).
                    fileName := revisionUsed := nil.
                ].                        
            ].                        
        ]
    ].
    ^ info
!

fetchRevisionsFromRLogStream:inStream searchForKeyword:searchFor ignoreDeleted:ignoreDeleted
    "helper for revisionsInModule*"

    |info line s revisionUsed fileName|

    info := OrderedCollection new.

    [inStream atEnd] whileFalse:[
        line:= inStream nextLine.
        line notNil ifTrue:[
            line := line withoutSeparators.
            line notEmpty ifTrue:[
                s := line restAfter:'RCS file:' withoutSeparators:true. 
                s notNil ifTrue:[ 
                    (UnixFilename named:s) directory baseName = 'Attic' ifTrue:[
                        "/ file has been removed in the repository
                        revisionUsed := #deleted
                    ].
                    fileName := (UnixFilename named:s) baseName.
                    (fileName endsWith:',v') ifTrue:[
                        fileName := fileName copyButLast:2.
                    ] ifFalse:[
                        self halt:'oops - should not happen'.
                    ].
                ].
                s := line restAfter:searchFor withoutSeparators:true.
                s notNil ifTrue:[ |i|
                    i := s indexOfSeparator.
                    i ~~ 0 ifTrue:[
                        s := s copyTo:i-1
                    ].
                    revisionUsed := revisionUsed ? s.  "/ deleted-info comes from the Attic-component in the path
                    (revisionUsed ~~ #deleted or:[ ignoreDeleted not ]) ifTrue:[
                        info add:(fileName -> revisionUsed).
                    ].
                    fileName := revisionUsed := nil.
                ].                        
            ].                        
        ]
    ].
    ^ info
!

getCVSROOTForModule:aModuleName
    "internal: used when accessing a source repository.
     Return the CVSROOT which provides the sources for a particular module.
     If no specific root was defined for that module, return the value of
     the global (fallBack) CVSRoot.
     Nil is returned if no repository is available." 

    CVSModuleRoots isNil ifTrue:[^ CVSRoot].
    aModuleName isNil ifTrue:[^ CVSRoot].
    ^ CVSModuleRoots at:aModuleName ifAbsent:CVSRoot.

    "Created: / 19.9.1997 / 06:18:07 / cg"
    "Modified: / 20.5.1998 / 16:30:12 / cg"
!

getCVSROOTsPerModule
    "return a dictionary, which associates CVSRoots to modules" 

    ^ CVSModuleRoots ? #()
!

import:moduleDir in:tempdir
    "import the existing tree in tempdir as repository"

    |cmd|

    cmd := 'import -m "checkin from stx browser" ', moduleDir, ' initialV initialR'.
    ^ self 
        executeCVSCommand:cmd 
        module:moduleDir
        inDirectory:(tempdir / moduleDir) name
        log:false


    "
      |f d|
      f := 'stefan/dummy/fasel'.
      d := '/tmp/tt' asFilename construct:f.
      d directory recursiveMakeDirectory.
      d writeStream close.
      self import:'stefan' in:'/tmp/tt/stefan' asFilename
    "

    "Created: / 23.7.1999 / 19:19:34 / stefan"
    "Modified: / 26.7.1999 / 17:46:29 / stefan"
    "Modified: / 18.1.2000 / 20:21:32 / cg"
!

readRevisionLogEntryFromStream:inStream
    "read and parse a single revision info-entry from the cvs log output.
     Return nil on end.

     The returned information is a CVSVersionInfo object (used to be an IdentityDictionary)
     filled with:
              #revision              -> the revision string
              #author                -> who checked that revision into the repository
              #date                  -> when was it checked in
              #state                 -> the RCS state
              #numberOfChangedLines  -> the number of changed line w.r.t the previous
              #logMessage            -> the checkIn log message
    "

    |revLine1 revLine2 record s line atEnd|

    atEnd := false.

    revLine1 := inStream nextLine.
    [revLine1 notNil and:[(revLine1 startsWith:'revision ') not]]
        whileTrue:[inStream atEnd ifTrue:[
                    revLine1 := nil
                   ] ifFalse:[
                    revLine1 := inStream nextLine.
                  ]
    ].
    revLine2 := inStream nextLine.
    (revLine1 notNil and:[revLine2 notNil]) ifTrue:[
        record := CVSVersionInfo "IdentityDictionary" new.
        record at:#revision put:(revLine1 asCollectionOfWords at:2).
        "/ decompose date/author/state etc.
        (revLine2 asCollectionOfSubstringsSeparatedBy:$;) do:[:info |
            |subEntry|
            subEntry := info withoutSeparators.
            #('date:'   #date
              'author:' #author 
              'state:'  #state 
              'lines:'  #numberOfChangedLines
             ) pairWiseDo:[:word :key |
                s := subEntry restAfter:word withoutSeparators:true.
                s notNil ifTrue:[
                    key == #'author' ifTrue:[ s := self authorMappingFor:s ].
                    record at:key put:s.
                ].                        
            ].
        ].

        "first revision does not have a 'lines:' entry"
        (record at:#numberOfChangedLines ifAbsent:[nil]) isNil ifTrue:[
            record at:#numberOfChangedLines put:''
        ].

        s := nil.
        line := inStream nextLine.
        [atEnd or:[line isNil or:[line startsWith:'--------']]] whileFalse:[
            (line startsWith:'==========') ifTrue:[
                atEnd := true.
            ] ifFalse:[
                (line withoutSpaces = '.') ifTrue:[
                    line := '*** empty log message ***'
                ].
                s isNil ifTrue:[
                    s := line
                ] ifFalse:[
                    s := s , Character cr asString , line.
                ].
                line := inStream nextLine.
            ]
        ].
        record at:#logMessage put:s.
    ].
    ^record.
!

releaseAndRemove:tempdir module:moduleDir outputTo:outputFilename
    "cleanup; release tree towards cvs and remove the temporary tree"

    |cmd redirect|

    outputFilename isNil ifTrue:[
        OperatingSystem isMSDOSlike ifTrue:[
            redirect := 'NUL'
        ] ifFalse:[
            redirect := '/dev/null'
        ]
    ] ifFalse:[
        redirect := outputFilename name
    ].

    "/
    "/ release it towards cvs
    "/
    cmd := 'release > ' , redirect.
    (self 
        executeCVSCommand:cmd 
        module:moduleDir
        inDirectory:tempdir name
        log:false
    ) ifFalse:[
"/        'CVSMGR: failed to release: ' errorPrint. cmd errorPrintNL.
    ].

    tempdir recursiveRemove.

    "Modified: / 23.4.1996 / 14:29:49 / stefan"
    "Created: / 19.9.1997 / 06:28:02 / cg"
    "Modified: / 20.5.1998 / 16:44:07 / cg"
    "Modified: / 3.9.1999 / 14:51:29 / ps"
!

repositoryTopDirectoryFromCVSRoot
    "return the top of the repository. This handles remote CVS connections
     as well"

    CVSRoot isNil ifTrue:[^ nil].
    ^ self repositoryTopDirectoryFromCVSRoot:CVSRoot.

    "
     CVSSourceCodeManager repositoryTopDirectory
    "

    "Modified: / 16-01-1998 / 17:33:31 / stefan"
    "Created: / 21-06-2006 / 12:06:18 / cg"
!

repositoryTopDirectoryFromCVSRoot:aString
    "return the top of the repository (without remote prefix)"

    |idx|

    idx := aString indexOf:$/.
    idx <= 1 ifTrue:[
        ^ aString.
    ].
    ^ aString copyFrom:idx.

    "
     CVSSourceCodeManager repositoryTopDirectoryFromCVSRoot:':pserver:stefan@ibm.exept.de:/archiv/cvs'
     CVSSourceCodeManager repositoryTopDirectoryFromCVSRoot:'exept:/files/CVS'
     CVSSourceCodeManager repositoryTopDirectoryFromCVSRoot:'/archiv/cvs'
    "

    "Modified: / 16-01-1998 / 17:32:03 / stefan"
    "Created: / 21-06-2006 / 12:05:53 / cg"
!

revisionStringFromLog:log entry:entry forClass:aClass
    "given a log entry, extract a revision string"

    |oldRev idx special|

    oldRev := aClass revisionString.
    special := ''.

    oldRev notNil ifTrue:[
        idx := oldRev lastIndexOf:$[.
        idx ~~ 0 ifTrue:[
            idx := oldRev indexOf:$[ startingAt:idx+1.
            idx ~~ 0 ifTrue:[
                special := ' ' , (oldRev copyFrom:idx).
            ]
        ].
    ].

    ^ '$Header: ' , (log at:#container) ,
      ' ' , (entry at:#revision) ,
      ' ' , (entry at:#date) , 
      ' ' , (entry at:#author) , 
      ' ' , (entry at:#state) ,
      ' $' ,
      special

    "Created: 16.9.1996 / 20:24:14 / cg"
    "Modified: 3.3.1997 / 22:31:51 / cg"
!

updatedRevisionStringOf:aClass forRevision:newRevision andUser:userName with:originalVersionString
    "update a revision string: take the original versionString,
     and return a new version string with changed revisionNr, dateAndTime and author.
     Used to synthetically generate a new version method without a need to consult the
     cvs for an revision string after an update (which is slow, when done remote)"

    |idx leftPart rightPart vsnString newVsn dateAndTimePart newDateAndTimePart prevUser|

    originalVersionString isEmptyOrNil ifTrue:[^ nil].

    "/ search for ,v
    idx := originalVersionString indexOfSubCollection:'.st,v'.
    idx == 0 ifTrue:[^ nil].

    leftPart := originalVersionString copyTo:(idx - 1 + 5).
    rightPart := (originalVersionString copyFrom:(idx + 5)) withoutSpaces.
    idx := rightPart indexOfSeparator.

    vsnString := rightPart copyTo:idx - 1.
    rightPart := rightPart copyFrom:idx + 1.

    newRevision isNil ifTrue:[
        (vsnString endsWith:'m') ifTrue:[
             "/ already a modified class
"/            ('already modified: ' , vsnString) printNL.
            ^ nil
        ].
        newVsn := vsnString , 'm'
    ] ifFalse:[
        newVsn := newRevision
    ].

    idx := rightPart indexOfSeparator.
    idx := rightPart indexOfSeparatorStartingAt:idx+1.
    dateAndTimePart := rightPart copyTo:idx-1.
    rightPart := rightPart copyFrom:idx+1.
    idx := rightPart indexOfSeparator.
    prevUser := rightPart copyTo:idx-1.
    rightPart := rightPart copyFrom:idx+1.

    "/ originalVersionString:
    "/      '$Header$'
    "/ leftPart:
    "/      '$Header: /cvs/stx/stx/goodies/refactoryBrowser/lint/RBLiteralArrayContainsCommaRule.st,v'
    "/ dateAndTimePart:
    "/      '2013/01/24 10:14:27'
    "/ rightPart:
    "/      'Exp $'
    newDateAndTimePart := Timestamp now printStringFormat:'%(year)-%(month)-%(day) %H:%m:%s'.
    ^ leftPart , ' ' , newVsn , ' ' , newDateAndTimePart , ' ' , userName , ' ' , rightPart
!

updatedRevisionStringOf:aClass forRevision:newRevision with:originalVersionString
    "update a revision string: take the original versionString,
     and return a new version string with changed revisionNr."

    |idx leftPart rightPart vsnString newVsn|

    originalVersionString isEmptyOrNil ifTrue:[^ nil].

    "/ search for ,v
    idx := originalVersionString indexOfSubCollection:'.st,v'.
    idx == 0 ifTrue:[^ nil].

    leftPart := originalVersionString copyTo:(idx - 1 + 5).
    rightPart := (originalVersionString copyFrom:(idx + 5)) withoutSpaces.
    idx := rightPart indexOfSeparator.
"/    idx == 0 ifTrue:[^ nil].

    vsnString := rightPart copyTo:idx - 1.
    rightPart := rightPart copyFrom:idx + 1.

    newRevision isNil ifTrue:[
        (vsnString endsWith:'m') ifTrue:[
             "/ already a modified class
"/            ('already modified: ' , vsnString) printNL.
            ^ nil
        ].
        newVsn := vsnString , 'm'
    ] ifFalse:[
        newVsn := newRevision
    ].

    ^ leftPart , ' ' , newVsn , ' ' , rightPart

    "Created: / 07-12-1995 / 20:23:38 / cg"
    "Modified: / 20-11-2006 / 22:22:09 / cg"
!

use_rlog
    ^ true "/ OperatingSystem isMSWINDOWSlike not

    "Modified: / 04-07-2006 / 18:05:43 / cg"
! !

!CVSSourceCodeManager class methodsFor:'queries'!

isResponsibleForPackage:aString

    "JV@2011-07-09: The real check is too slow. Cache needed here"
    ^ true.

"/    id := aString asPackageId. 
"/    ^self checkForExistingModule: id module directory: id directory.

    "Created: / 09-07-2011 / 14:32:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

managerTypeName
    ^ 'CVS'

    "Created: / 16-08-2006 / 11:05:56 / cg"
!

nameOfVersionMethodForExtensions
    ^ #'extensionsVersion_CVS'
!

nameOfVersionMethodInClasses
    ^ #'version_CVS'
!

settingsApplicationClass
    "link to my settings application (needed for the settings dialog"

    ^ CVSSourceCodeManagementSettingsAppl

    "Created: / 19-04-2011 / 12:43:29 / cg"
    "Modified: / 19-04-2011 / 13:52:42 / cg"
!

versionInfoClass

    ^ CVSVersionInfo
! !

!CVSSourceCodeManager class methodsFor:'saving'!

savePreferencesOn:aStream
    aStream nextPutLine:'CVSSourceCodeManager notNil ifTrue:['.
    self repositoryInfoPerModule notEmptyOrNil ifTrue:[
        aStream nextPutLine:'    CVSSourceCodeManager repositoryInfoPerModule:' , self repositoryInfoPerModule storeString , '.'.
    ].
    CVSExecutable notNil ifTrue:[
        aStream nextPutLine:'    CVSSourceCodeManager cvsExecutable:' , CVSExecutable storeString , '.'.
    ].
    (Smalltalk at:#SourceCodeManager) == self ifTrue:[
        aStream nextPutLine:'    Smalltalk at:#SourceCodeManager put: CVSSourceCodeManager.'.
        aStream nextPutLine:'    CVSSourceCodeManager initializeForRepository:' , self repositoryName storeString , '.'.
    ] ifFalse:[
        aStream nextPutLine:'    CVSSourceCodeManager repositoryName:' , self repositoryName storeString , '.'.
    ].
    aStream nextPutLine:'].'.

    "Created: / 09-11-2006 / 15:09:25 / cg"
    "Modified: / 22-12-2011 / 00:47:28 / cg"
! !

!CVSSourceCodeManager class methodsFor:'source code access'!

checkin:containerFilename text:someText directory:packageDir module:moduleDir logMessage:logMessage force:force
    "enter some (source) code (which is someText)
     into the source repository. If the force argument is true, no merge is done;
     instead, the code is checked in as given (Dangerous).
     Return true if ok, false if not."

    |tempdir cmd checkoutName logMsg revision logTmp
     cmdOut whatHappened idx changeLog changesAsLogged l
     newRevision  msg answer didMerge
     modulePath time
     editor checkInRepaired didAccept emphasizedText repairedText out
     emSep comment|

    revision := self newestRevisionInFile:containerFilename directory:packageDir module:moduleDir.

    logMsg := logMessage.
    (logMsg isEmptyOrNil) ifTrue:[
        logMsg := 'checkin from browser'.
    ].

    packageDir isEmptyOrNil ifTrue:[
        modulePath := moduleDir
    ] ifFalse:[
        modulePath :=  moduleDir , '/' , packageDir.
    ].
    checkoutName :=  modulePath , '/' , containerFilename.

    revision isNil ifTrue:[
        "/ a new file ...
        ^ self
            createContainerForText:someText inModule:moduleDir package:packageDir container:containerFilename
    ].

    [
        cmdOut := Filename newTemporary.
        cmdOut exists ifTrue:[
            cmdOut remove.
        ].

        "/
        "/ in CVS, we have to checkout the file first, in order
        "/ to get up-to-date CVS entries, and also to be able to merge in
        "/ other users changes.
        "/

        "/
        "/ first, create a temporary work tree
        "/
        tempdir := self createTempDirectory:nil forModule:nil.
        tempdir isNil ifTrue:[
            ('no tempDir - cannot checkin ' , containerFilename) errorPrintCR.
            ^ false
        ].

        "/
        "/ next, create CVS/Entries and CVS/Repository with version information of current version
        "/

        "/ correct our current time, so that converting it will give us UTC
        time := Timestamp now asUtcTimestamp subtractSeconds:1.

        self createEntryFor:checkoutName
             module:moduleDir
             in:(tempdir construct:modulePath)
             revision:revision
             date:(self cvsTimeString:time)
             special:''
             overwrite:true.

        "/
        "/ copy-over our current version
        "/
        Error handle:[:ex|
            'CVSSourceCodeManager [error]: cannot copy-over filedOut class source' errorPrintCR.
            ^ false.
        ] do:[
            |s|

            s := (tempdir construct:checkoutName) writeStream.
            s nextPutAll:someText.
            s close.
        ].

        "/
        "/ synchronize i.e. merge in any changes
        "/
        self activityNotification:'CVS: Merging ' , containerFilename , ' with repository version...'.

        cmd := 'update ', CVSUpdateOptions, ' ', containerFilename, ' >', '"' , cmdOut name , '"'.
        (self
            executeCVSCommand:cmd
            module:moduleDir
            inDirectory:((tempdir construct:moduleDir) constructString:packageDir)
        ) ifFalse:[
            force ifFalse:[
                'CVSSourceCodeManager [error]: cannot merge current source with repository version' errorPrintCR.
                ^ false.
            ].
        ] ifTrue:[
            "/
            "/ check what happened - the contents of the cmdOut file may be:
            "/   empty   -> nothing changed
            "/   M xxx   -> merged-in changes from other users
            "/   C xxx   -> a conflict occurred and the differences have been merged into the source
            "/              needs special action
            "/
            (cmdOut exists and:[cmdOut fileSize > 0]) ifTrue:[
                whatHappened := cmdOut contentsAsString.
            ].
        ].

        (whatHappened isEmptyOrNil) ifTrue:[
            "/
            "/ no change
            "/
    "/        Transcript showCR:'no change in ' , containerFilename , ' (repository unchanged)'.
            force ifFalse:[
                self information:'nothing changed in ' , containerFilename , ' (repository unchanged)'.
            ].
            ^ true
        ].

        Verbose == true ifTrue:[
            ('CVSMGR: result is: ' , whatHappened) infoPrintCR.
        ].

        force ifFalse:[
            revision isNil ifTrue:[
                changeLog := self revisionLogOfContainer:containerFilename directory:packageDir module:moduleDir.
            ] ifFalse:[
                changeLog := self revisionLogOfContainer:containerFilename module:moduleDir directory:packageDir fromRevision:(self revisionAfter:revision) toRevision:nil.
            ].
            changeLog notNil ifTrue:[
                |s|

                s := CharacterWriteStream new.
                self writeRevisionLogMessagesFrom:changeLog withHeader:false to:s.
                changesAsLogged := s contents.
            ] ifFalse:[
                "/ mhmh - that should not happen
                changesAsLogged := ''.
            ].
        ].

        didMerge := false.

        "/
        "/ cvs above rel10 returns a multiline info ...
        "/ we have to extract the one line which states what happened.
        "/
        whatHappened := whatHappened asCollectionOfLines asStringCollection.
        whatHappened := whatHappened select:[:line |
                            (line startsWith:'RCS file') not
                            and:[(line startsWith:'retrieving') not
                            and:[(line startsWith:'Merging') not
                            and:[line size > 0]]]
                        ].
        whatHappened := whatHappened asString.

        (force or:[whatHappened startsWith:'M ']) ifTrue:[
            "/
            "/ merged in changes
            "/
            (force
            or:[changeLog isNil
            or:[(changeLog at:#revisions ifAbsent:[#()]) isEmpty]]) ifTrue:[
                "/
                "/ pretty good - nothing has changed in the meanwhile
                "/
                Transcript showCR:'CVSSourceCodeManager [info]: checking in ' , containerFilename , ' ...'
            ] ifFalse:[
                | mySource mergedSource |

                "/
                "/ someone else has changed things in the meanwhile, but there is no conflict
                "/ and version have been merged.
                "/
                didMerge := true.
                changesAsLogged := changesAsLogged asCollectionOfLines.

                mySource := someText.
                mergedSource := (tempdir construct:checkoutName) readStream contents asString.

                mySource = mergedSource ifTrue:[
                    msg := 'The source of ' , containerFilename , ' has been changed in the meanwhile as listed below.

I have merged your version with the newest repository version,
and found no differences between the result and your current version
(i.e. your version seemed up-to-date).'.

                    self checkinTroubleDialog:'Merging versions'
                                   message:msg
                                   log:changesAsLogged
                                   abortable:false
                                   option:nil.
                    didMerge := false.
                ] ifFalse:[
                    msg := 'The source of ' , containerFilename , ' has been changed in the meanwhile as listed below.

If you continue, your new changes (based upon rev. ' , revision printString , ') will be MERGED
into the newest revision. This will combine the other version with your changes
into a new common revision which may be different from both.
Although this is a nice feature, it may fail to create the expected result in certain situations.

You should carefully check the result - by comparing the current version with the
most recent version in the repository. If that does not contain an acceptable version,
change methods as required and check in again.
Be aware, that after that, the actual repository version is different from your current classes,
and you should update your class from the repository.

Continue ?'.

                    answer := self checkinTroubleDialog:'Merging versions'
                                   message:msg
                                   log:changesAsLogged
                                   abortable:true
                                   option:'Stop - see first'.
                    answer ~~ true ifTrue:[
                        answer == #option ifTrue:[
                            DiffCodeView
                                openOn:mySource
                                label:'current version'
                                and:mergedSource
                                label:'merged version'.

                        ].
                        Transcript showCR:'checkin aborted - (no merge; repository unchanged)'.
                        ^ false.
                    ].
                ].

"/                changesAsLogged := (changesAsLogged asStringCollection collect:[:line | line withTabsExpanded]) asString.
"/                msg := 'The source of ' , containerFilename , ' has been changed in the meanwhile as follows:
"/' , changesAsLogged , '
"/
"/If you continue, your new changes (based upon rev. ' , revision , ') will be MERGED
"/into the newest revision. This will combine the other version with your changes
"/into a new common revision which is different from both.
"/Although convenient, it may fail to create the expected result in certain situations.
"/
"/You should carefully check the result - by comparing the current version with the
"/most recent version in the repository. If that does not contain an acceptable version,
"/change methods as required and check in again. Be aware, that the actual repository version
"/is different from your current classes.
"/
"/Continue ?'.
"/                (self confirm:msg) ifFalse:[
"/                    Transcript showCR:'checkin aborted - (no merge; repository unchanged)'.
"/                    ^ false.
"/                ].
                Transcript showCR:'CVSSourceCodeManager [info]: checking in ' , containerFilename , ' (merged other changes) ...'
            ]
        ] ifFalse:[
            (whatHappened startsWith:'C ') ifTrue:[
                "/
                "/ conflict; someone else checked in something in the meanwhile,
                "/ and there is a conflict between this version and the checked in version.
                "/

                changesAsLogged := changesAsLogged asCollectionOfLines.

                msg := 'The source of ' , containerFilename , ' has been changed in the meanwhile as listed below.

Your new changes (based upon rev. ' , revision printString , ') CONFLICT with those changes.

You should fix things by comparing your class with the most recent repository version
and change your methods avoiding conflicts. The checkin again.
'.

                answer := self checkinTroubleDialog:'Version conflict'
                     message:msg
                     log:changesAsLogged
                     abortable:false
                     option:'show conflicts'
                     option2:'resolve conflicts'.

                answer == #option ifTrue:[
                    "/
                    "/ show conflicts in a 3-way DiffTextView ...
                    "/
                    Diff3TextView
                        openOnMergedText:(tempdir construct:checkoutName) readStream contents
                        label:'your version (checkin attempt)'
                        label:'original (base version)'
                        label:'newest repository version'.
                ].

                checkInRepaired := false.
                answer == #option2 ifTrue:[
                    "/
                    "/ allow checkin of repair version
                    "/ this is error prone ...
                    "/
                    "/
                    "/ show merged version in an editor ...
                    "/ ... accept will check it in.
                    "/
                    emphasizedText := (tempdir construct:checkoutName) readStream contents.
                    emSep := (Array with:(#color->Color black)
                                 with:(#backgroundColor->Color green)).
                    emphasizedText := Diff3TextView
                                emphasizeMergedDiff3Text:emphasizedText
                                emphasize1:(Array with:(#color->Color white)
                                                  with:(#backgroundColor->Color blue))
                                emphasize2:(Array with:(#color->Color white)
                                                  with:(#backgroundColor->Color red))
                                emphasizeSep:emSep.

                    comment :=
'"/ ***************************************************************
"/ This text contains your current versions code (blue)
"/ merged with the conflicting code as found in the repository (red) which resulted
"/ from some other checkin.
"/ Each such conflict is surrounded by green text (like this paragraph).
"/
"/ Please have a look at ALL the conflicts and fix things as appropriate.
"/ Delete the green lines as a confirmation - I will not checkin the changed text,
"/ unless no more green parts are present. This includes this comment at the top.
"/ ***************************************************************
'.
                    comment := (Text string:comment emphasis:emSep) asStringCollection.
                    emphasizedText := comment , emphasizedText.

                    didAccept := false. checkInRepaired := true.
                    [didAccept not and:[checkInRepaired]] whileTrue:[
                        editor := RCSConflictEditTextView
                                    setupWith:emphasizedText
                                    title:'Resolve conflicts in ' , containerFilename , ', then accept & close to checkin'.

                        editor acceptAction:[:dummy |
                            repairedText := editor list.
                            didAccept := true.
                        ].
                        didAccept := false.
                        editor topView openModal.

                        didAccept ifFalse:[
                            (Dialog confirm:'You did not accept the new text. Edit again ?')
                            ifFalse:[
                                checkInRepaired := false.
                            ]
                        ] ifTrue:[
                            "/ check if all green-stuff (separators) have been removed
                            (repairedText findFirst:[:line | line notEmptyOrNil and:[(line emphasisAt:1) = emSep]]) ~~ 0 ifTrue:[
                                self warn:'You have to look at ALL conflicts, and remove ALL green lines as a confirmation !!'.
                                didAccept := false.
                            ]
                        ].

                    ].

                    checkInRepaired ifTrue:[
                        [
                            out := (tempdir construct:checkoutName) writeStream.
                            out nextPutAll:(repairedText asString string).
                            didAccept := true.
                            out close.
                        ] on:FileStream openErrorSignal do:[:ex|
                            self warn:'could not write file ' , (tempdir constructString:checkoutName).
                            checkInRepaired := false.
                        ].
                    ]
                ].

                checkInRepaired ifTrue:[
                    Transcript showCR:'CVSSourceCodeManager [info]: checking in ' , containerFilename , ' (manually repaired version) ...'
                ] ifFalse:[
                    'CVSSourceCodeManager [warning]: cannot (for now) checkin; conflicts found' infoPrintCR.
                    Transcript showCR:'checkin of ' , containerFilename , ' aborted (conflicting changes; repository unchanged)'.
                    ^ false.
                ]
            ] ifFalse:[
                (whatHappened startsWith:'U ') ifTrue:[
                    "/
                    "/ nothing changed here, but the repository already contains
                    "/ a newer version.
                    "/

                    self information:'nothing changed in your ''' , containerFilename , ''';
but repository already contains a newer version (repository unchanged).'.
                    ^ true.
                ] ifFalse:[
                    "/
                    "/ unexpected
                    "/
                    self warn:'unexpected message from CVS:
' , whatHappened , '

No checkin performed.'.
                    Transcript showCR:'*** cannot checkin ' , containerFilename , ' (unexpected CVS response; repository unchanged)'.
                    ^ false.
                ]
            ]
        ].


        "/
        "/ now check it in again
        "/
        self activityNotification:'CVS: Saving ' , containerFilename , ' in repository...'.

        logMsg := logMsg replChar:$"  withString:'\"'.

        OperatingSystem isUNIXlike ifFalse:[
            "/ save the log message into another tempFile ...
            |s|

            logTmp := Filename newTemporaryIn:tempdir.
            s := logTmp writeStream.
            s nextPutAll:logMsg.
            s close.

            cmd := 'commit -F "%1" %2 %3 > "%4"'
                    bindWith:logTmp baseName
                    with:CVSCommitOptions
                    with:checkoutName
                    with:cmdOut name.
        ] ifTrue:[
            "/
            "/ CVS up to V1.9.14 prints the 'new revision' to stderr,
            "/ CVS V1.9.16 to stdout.
            "/
            cmd := 'commit -m "%1" %2 %3 > "%4" 2>&1'
                    bindWith:logMsg
                    with:CVSCommitOptions
                    with:checkoutName
                    with:cmdOut name
        ].

        (self
            executeCVSCommand:cmd
            module:moduleDir
            inDirectory:tempdir name
        ) ifFalse:[
            (cmdOut exists and:[cmdOut fileSize > 0]) ifTrue:[
                whatHappened := cmdOut contentsOfEntireFile asString.
            ] ifFalse:[
                whatHappened := '<< no message >>'
            ].
            self warn:'The following problem was reported by cvs:

' , whatHappened , '

The class has NOT been checked into the repository.'.

           ('CVSSourceCodeManager [error]: cvs: ' , whatHappened) errorPrintCR.
           'CVSSourceCodeManager [error]: cannot checkin modified class source' errorPrintCR.
            logTmp notNil ifTrue:[logTmp remove].
            ^ false.
        ].
        logTmp notNil ifTrue:[logTmp remove].
        (cmdOut exists and:[cmdOut fileSize > 0]) ifTrue:[
            whatHappened := cmdOut contentsOfEntireFile asString.
        ] ifFalse:[
            whatHappened := nil
        ].

        "/
        "/ fetch the new revision nr as found in the commit commands output
        "/

        (whatHappened isEmptyOrNil) ifTrue:[
            'CVSSourceCodeManager [warning]: unexpected empty checkin command output' errorPrintCR.
        ] ifFalse:[
            whatHappened := whatHappened asCollectionOfLines asStringCollection.
            idx := whatHappened indexOfLineStartingWith:'new revision:'.
            idx == 0 ifTrue:[
                'CVSSourceCodeManager [error]: unexpected checkin command output (no new-revision info)' errorPrintCR.
            ] ifFalse:[
                l := whatHappened at:idx.
                newRevision := (l copyFrom:14 to:(l indexOf:$; startingAt:14)-1) withoutSpaces.
            ]
        ].
    ] ensure:[
        cmdOut notNil ifTrue:[ cmdOut remove ].
        tempdir notNil ifTrue:[ tempdir recursiveRemove ]
    ].
    ^ true

    "Modified: / 12-11-2010 / 11:04:10 / cg"
    "Modified: / 19-04-2012 / 14:18:24 / sr"
!

checkinClass:cls fileName:classFileName directory:packageDir module:moduleDir source:sourceFileName logMessage:logMessage force:forceArg
    "enter a classes source code (which has been already filed out into sourceFileName)
     into the source repository. If the force argument is true, no merge is done;
     instead, the code is checked in as given (Dangerous).
     Return true if ok, false if not."

    |tempdir cmd checkoutName logMsg revision newestRevision logTmp
     cmdOut whatHappened s entry idx changeLog changesAsLogged l
     newRevision newString binRevision className msg answer didMerge
     modulePath time
     editor checkInRepaired checkInNew didAccept emphasizedText repairedText out
     emSep comment force conflictResolvedManually revisionOption|

    force := forceArg.

    className := cls name.
    cls isPrivate ifTrue:[
        self reportError:'refuse to check in private classes.'.
        ^ false.
    ].
    revision := "cls revision" cls revisionOfManager:self.
    (revision notNil and:[revision endsWith:$m])
    ifTrue:[
        "/ this class has already been checked in with a merge,
        "/ but not reloaded from the repository.
        "/ must use the original revision string.
        revision := revision copyButLast:1.
    ].
    (binRevision := cls binaryRevision) notNil ifTrue:[
        revision ~= binRevision ifTrue:[
            Transcript showCR:('CVSSourceCodeManager [info]: class ' , className , ' is based upon ' , binRevision , ' but has revision ' , (revision ? '?'))
        ]
    ].

    revision isNil ifTrue:[
        revision := newestRevision := self newestRevisionOf:cls.
        revision isNil ifTrue:[
            force ifTrue:[
                revision := newestRevision := self newestRevisionInFile:classFileName directory:packageDir module:moduleDir.
                revision isNil ifTrue:[
                    revision := '1.0'   "/ initial checkin
                ].
            ] ifFalse:[
                revision := '1.0'   "/ initial checkin
            ]
        ] ifFalse:[
            revision == #deleted ifTrue:[
                revision := '0'     "/ to force cvs-adding, which resurrects the file from the Attic
            ].
        ].
    ].

    logMessage isNil ifTrue:[
        logMsg := ''.
    ] ifFalse:[
        logMsg := logMessage asSingleByteStringIfPossible.
        logMsg isWideString ifTrue:[
            self reportError:'cvs cannot handle unicode in logMessage'.
            ^ false.
        ].
    ].

    cmdOut := Filename newTemporary.
    cmdOut exists ifTrue:[
        cmdOut remove.
    ].

    "/
    "/ in CVS, we have to checkout the file first, in order
    "/ to get up-to-date CVS entries, and also to be able to merge in
    "/ other users changes.
    "/

    "/
    "/ first, create a temporary work tree
    "/
    tempdir := self createTempDirectory:nil forModule:nil.
    tempdir isNil ifTrue:[
        ('no tempDir - cannot checkin ' , className) errorPrintCR.
        ^ false
    ].
    [
        "/
        "/ next, create CVS/Entries and CVS/Repository with version information of current version
        "/
        packageDir isEmptyOrNil ifTrue:[
            modulePath := moduleDir
        ] ifFalse:[
            modulePath :=  moduleDir , '/' , packageDir.
        ].
        checkoutName :=  modulePath , '/' , classFileName.

        "/
        "/ correct our current time, so that converting it will give us UTC
        "/
        time := Timestamp now asUtcTimestamp subtractSeconds:1.

        self createEntryFor:checkoutName
             module:moduleDir
             in:(tempdir construct:modulePath)
             revision:revision
             date:(self cvsTimeString:time)
             special:''
             overwrite:true.

        "/
        "/ copy-over our current version
        "/
        Error handle:[:ex|
            self reportError:'cannot copy-over filedOut class source'.
            ^ false.
        ] do:[
            sourceFileName asFilename copyTo:(tempdir construct:checkoutName).
        ].

        "/
        "/ synchronize i.e. merge in any changes
        "/
        self activityNotification:'CVS: Merging ' , cls name , ' with repository version...'.

        revisionOption := ''.
        (revision asCollectionOfSubstringsSeparatedBy:$.) size > 2 ifTrue:[
            "must be a branch, compare with branch revision"
            revisionOption := '-r ', revision copyUpToLast:$..
        ].

        cmd := 'update %1 %4 %2 >"%3"'
            bindWith:CVSUpdateOptions
            with:classFileName
            with:cmdOut name
            with:revisionOption.

        (self
            executeCVSCommand:cmd
            module:moduleDir
            inDirectory:((tempdir construct:moduleDir) constructString:packageDir)
        ) ifFalse:[
            force ifFalse:[
                (self checkForExistingContainer:classFileName inModule:moduleDir directory:packageDir) ifFalse:[
                    "/ no container
                    "/ someone fiddled around with repository ?
                    (cls binaryRevision notNil) ifTrue:[
                        (Dialog confirm:('Someone seems to have removed the source container for ',cls name,'\\Force new checkin ?') withCRs)
                        ifTrue:[
                            cls setBinaryRevision:nil.
                            ^ self checkinClass:cls fileName:classFileName directory:packageDir module:moduleDir source:sourceFileName logMessage:logMsg force:force.
                        ].
                    ].
                    (Dialog confirm:('There seems to be no source container for "%1"\(Either the source container was removed,\or your per-module repository setting is wrong,\or the CVS server is unreachable).\\Proceed?' bindWith:cls name allBold) withCRs)
                    ifFalse:[
                        ^ false
                    ].
                ].

                "/ is the version correct ?
                newestRevision isNil ifTrue:[
                    newestRevision := self newestRevisionOf:cls.
                    newestRevision isNil ifTrue:[
                        (Dialog confirm:('The source container for ',cls name allBold,' seems corrupted. Proceed?' withCRs)) ifFalse:[
                            ^ false
                        ].
                        ^ self
                            checkinClass:cls fileName:classFileName directory:packageDir module:moduleDir
                            source:sourceFileName logMessage:logMessage force:true.
                    ].
                ].
"/            revision > newestRevision ifTrue:[
"/                true "/ (Dialog confirm:('The version-info of ',cls name allBold,' is wrong \(The class version (',revision allBold,') is newer than the newest version in the repository (',newestRevision allBold,').\\Patch the version and retry checkin ?') withCRs)
"/                ifTrue:[
"/                    "/ newVersionString := self updatedRevisionStringOf:cls forRevision:newestRevision with:cls revisionString.
"/                    "/ self updateVersionMethodOf:cls for:newVersionString.
"/                    ^ self checkinClass:cls fileName:classFileName directory:packageDir module:moduleDir source:sourceFileName logMessage:logMsg force:force.
"/                ].
"/            ].
"/
"/            self reportError:('cannot merge current source with repository version (failed to execute: ',cmd,')').
"/            ^ false.
                "/ if we arrive here, proceed as if merged
                whatHappened := 'M initial'
            ].
        ] ifTrue:[
            "/
            "/ check what happened - the contents of the cmdOut file may be:
            "/   empty   -> nothing changed
            "/   M xxx   -> merged-in changes from other users
            "/   C xxx   -> a conflict occurred and the differences have been merged into the source
            "/              needs special action
            "/
            (cmdOut exists and:[cmdOut fileSize > 0]) ifTrue:[
                whatHappened := cmdOut contentsAsString.
            ] ifFalse:[
                self breakPoint:#cg.
            ].
        ].

        (whatHappened isEmptyOrNil) ifTrue:[
            "/
            "/ no change
            "/
        Transcript showCR:'no change in ' , className , ' (repository unchanged)'.

            force ifFalse:[
"/            (ChangeSet current includesChangeForClass:cls) ifTrue:[
"/                (self confirm:('Nothing changed in %1 (repository unchanged).\\Remove entries from changeSet ?' bindWith:className) withCRs) ifTrue:[
"/                    ChangeSet current condenseChangesForClass:cls.
"/                ].
"/            ] ifFalse:[
"/                self information:('Nothing changed in %1 (repository unchanged)' bindWith:className).
"/            ].
                self postCheckInClass:cls.
            ] ifTrue:[
                changeLog := self revisionLogOfContainer:classFileName directory:packageDir module:moduleDir.
                (changeLog isNil or:[(changeLog at:#revisions) size ~~ 1]) ifTrue:[
                    'CVSSourceCodeManager [error]: failed to update revisionString (no log)' errorPrintCR.
                    self updateVersionMethodOf:cls for:'$' , 'Header' , '$'.  "/ concatenated to avoid RCS expansion
                ] ifFalse:[
                    entry := (changeLog at:#revisions) first.
                    newString := self revisionStringFromLog:changeLog entry:entry forClass:cls.
                    newString isEmptyOrNil ifTrue:[
                        'CVSSourceCodeManager [error]: missng revisionString' errorPrintCR
                    ] ifFalse:[
                        self updateVersionMethodOf:cls for:newString.
                        cls revision ~= newRevision ifTrue:[
                            'CVSSourceCodeManager [error]: failed to update revisionString' errorPrintCR
                        ] ifFalse:[
                            ('CVSSourceCodeManager [info]: updated revisionString to:',newString) infoPrintCR
                        ]
                    ]
                ]
            ].

            ^ true
        ].
        Verbose == true ifTrue:[
            ('CVSMGR: result is: ' , whatHappened) infoPrintCR.
        ].

        force ifFalse:[
            revision isNil ifTrue:[
                changeLog := self revisionLogOf:cls.
            ] ifFalse:[
                changeLog := self revisionLogOf:cls fromRevision:(self revisionAfter:revision) toRevision:nil.
            ].
            changeLog notNil ifTrue:[
                s := CharacterWriteStream on:''.
                self writeRevisionLogMessagesFrom:changeLog withHeader:false to:s.
                changesAsLogged := s contents.
            ] ifFalse:[
                "/ mhmh - that should not happen
                changesAsLogged := ''.
            ].
        ].

        didMerge := false.
        conflictResolvedManually := checkInRepaired := checkInNew := false.

        "/
        "/ cvs above rel10 returns a multiline info ...
        "/ we have to extract the one line which states what happened.
        "/
        whatHappened := whatHappened asCollectionOfLines asStringCollection.
        whatHappened := whatHappened select:[:line |
                            (line startsWith:'RCS file') not
                            and:[(line startsWith:'retrieving') not
                            and:[(line startsWith:'Merging') not
                            and:[line size > 0]]]
                        ].
        whatHappened := whatHappened asString.

        (force or:[(whatHappened startsWith:'M ') or:[whatHappened startsWith:'A ']]) ifTrue:[
            "/
            "/ merged in changes / resurrected
            "/
            (force
            or:[changeLog isNil
            or:[(changeLog at:#revisions ifAbsent:nil) isEmptyOrNil]]) ifTrue:[
                "/
                "/ pretty good - nothing has changed in the meanwhile
                "/
                Transcript showCR:('CVSSourceCodeManager [info]: checking in %1 (%2)...' bindWith:className with:modulePath).
            ] ifFalse:[
                |mySource mergedSource |

                "/
                "/ someone else has changed things in the meanwhile, but there is no conflict
                "/ and version have been merged.
                "/
                didMerge := true.
                changesAsLogged := changesAsLogged asCollectionOfLines.

                s := CharacterWriteStream new.
                self fileOutSourceCodeOf: cls on:s.
                mySource := s contents asString.
                mergedSource := (tempdir construct:checkoutName) readStream contents asString.

                mySource = mergedSource ifTrue:[
                    msg := 'The source of ' , className , ' has been changed in the meanwhile as listed below.

I have merged your version with the newest repository version,
and found no differences between the result and your current version
(i.e. your version seemed up-to-date).'.

                    self checkinTroubleDialog:'Merging versions'
                                   message:msg
                                   log:changesAsLogged
                                   abortable:false
                                   option:nil.
                    didMerge := false.
                ] ifFalse:[
                    msg := 'The source of ' , className , ' has been changed in the meanwhile as listed below.

If you continue, your new changes (based upon rev. ' , revision printString , ') will be MERGED
into the newest revision. This will combine the other version with your changes
into a new common revision which may be different from both.
Although this is a nice feature, it may fail to create the expected result in certain situations.

You should carefully check the result - by comparing the current version with the
most recent version in the repository. If that does not contain an acceptable version,
change methods as required and check in again.
Be aware, that after that, the actual repository version is different from your current classes,
and you should update your class from the repository.

Continue ?'.

                    answer := self checkinTroubleDialog:'Merging versions'
                                   message:msg
                                   log:changesAsLogged
                                   abortable:true
                                   option:'Stop - see first'
                                   option2:'Do NOT Merge - Force my Code'.

                    answer == #option2 ifTrue:[
                        (Dialog confirm:'Are you certain that you want to suppress a merge and force your code to be checked in ?')
                        ifTrue:[
                            s := (tempdir construct:checkoutName) writeStream.
                            self fileOutSourceCodeOf: cls on:s.
                            s close.
                            answer := true.
                        ]
                    ].

                    answer ~~ true ifTrue:[
                        answer == #option ifTrue:[
                            DiffCodeView
                                openOn:mySource
                                label:'current version'
                                and:mergedSource
                                label:'merged version'.

                        ].
                        self reportError:'checkin aborted - (no merge; repository unchanged)'.
                        ^ false.
                    ].
                ].

"/                changesAsLogged := (changesAsLogged asStringCollection collect:[:line | line withTabsExpanded]) asString.
"/                msg := 'The source of ' , className , ' has been changed in the meanwhile as follows:
"/' , changesAsLogged , '
"/
"/If you continue, your new changes (based upon rev. ' , revision , ') will be MERGED
"/into the newest revision. This will combine the other version with your changes
"/into a new common revision which is different from both.
"/Although convenient, it may fail to create the expected result in certain situations.
"/
"/You should carefully check the result - by comparing the current version with the
"/most recent version in the repository. If that does not contain an acceptable version,
"/change methods as required and check in again. Be aware, that the actual repository version
"/is different from your current classes.
"/
"/Continue ?'.
"/                (self confirm:msg) ifFalse:[
"/                    Transcript showCR:'checkin aborted - (no merge; repository unchanged)'.
"/                    ^ false.
"/                ].
                Transcript showCR:('CVSSourceCodeManager [info]: checking in %1 (%2) (merge)...' bindWith:className with:modulePath).
            ]
        ] ifFalse:[
            (whatHappened startsWith:'C ') ifTrue:[
                "/
                "/ conflict; someone else checked in something in the meanwhile,
                "/ and there is a conflict between this version and the checked in version.
                "/

                changesAsLogged := changesAsLogged asCollectionOfLines.

                msg := 'The source of ' , className , ' has been changed in the meanwhile as listed below.

Your new changes (based upon rev. ' , revision printString , ') CONFLICT with those changes.

You should fix things by comparing your class with the most recent repository version
and change your methods avoiding conflicts. Then checkin again.
'.

                answer := self checkinTroubleDialog:'Version conflict'
                     message:msg
                     log:changesAsLogged
                     abortable:false
                     option:'Show conflicts'
                     option2:'Resolve conflicts'
                     option3:'Do NOT Merge - Force my Code'.

                answer == #option ifTrue:[
                    "/
                    "/ show conflicts in a 3-way DiffTextView ...
                    "/
                    Diff3TextView
                        openOnMergedText:(tempdir construct:checkoutName) readStream contents
                        label:'your version (checkin attempt)'
                        label:'original (base version)'
                        label:'newest repository version'.
                ].

                answer == #option2 ifTrue:[
                    "/
                    "/ allow checkin of repair version
                    "/ this is error prone ...
                    "/
                    "/
                    "/ show merged version in an editor ...
                    "/ ... accept will check it in.
                    "/
                    emphasizedText := (tempdir construct:checkoutName) readStream contents.
                    emSep := (Array with:(#color->Color black)
                                 with:(#backgroundColor->Color green)).
                    emphasizedText := Diff3TextView
                                emphasizeMergedDiff3Text:emphasizedText
                                emphasize1:(Array with:(#color->Color white)
                                                  with:(#backgroundColor->Color blue))
                                emphasize2:(Array with:(#color->Color white)
                                                  with:(#backgroundColor->Color red))
                                emphasizeSep:emSep.

                    comment :=
'"/ ***************************************************************
"/ This text contains your current versions code (blue)
"/ merged with the conflicting code as found in the repository (red) which resulted
"/ from some other checkin.
"/ Each such conflict is surrounded by green text (like this paragraph).
"/
"/ Please have a look at ALL the conflicts and fix things as appropriate.
"/ Delete the green lines as a confirmation - I will not checkin the changed text,
"/ unless no more green parts are present. This includes this comment at the top.
"/ ***************************************************************
'.
                    comment := (Text string:comment emphasis:emSep) asStringCollection.
                    emphasizedText := comment , emphasizedText.

                    didAccept := false. checkInRepaired := true.
                    [didAccept not and:[checkInRepaired]] whileTrue:[
                        editor := RCSConflictEditTextView
                                    setupWith:emphasizedText
                                    title:'Resolve conflicts in ' , className , ', then accept & close to checkin'.

                        editor acceptAction:[:dummy |
                            repairedText := editor list.
                            didAccept := true.
                        ].
                        didAccept := false.
                        editor topView openModal.

                        didAccept ifFalse:[
                            (Dialog confirm:'You did not accept the new text. Edit again ?')
                            ifFalse:[
                                checkInRepaired := false.
                            ]
                        ] ifTrue:[
                            "/ check if all green-stuff (separators) have been removed
                            (repairedText findFirst:[:line | line notEmptyOrNil and:[(line emphasisAt:1) = emSep]]) ~~ 0 ifTrue:[
                                self warn:'You have to look at ALL conflicts, and remove ALL green lines as a confirmation !!'.
                                didAccept := false.
                            ]
                        ].

                    ].

                    checkInRepaired ifTrue:[
                        [
                            out := (tempdir construct:checkoutName) writeStream.
                            out nextPutAll:(repairedText asString string).
                            didAccept := true.
                            out close.
                        ] on:FileStream openErrorSignal do:[:ex|
                            self warn:'could not write file ' , (tempdir constructString:checkoutName).
                            checkInRepaired := false.
                        ].
                    ]
                ].

                answer == #option3 ifTrue:[
                    "/
                    "/ force checkin of new version
                    "/
                    "/
                    "/ show merged version in an editor ...
                    "/ ... accept will check it in.
                    "/
                    [
                        out := (tempdir construct:checkoutName) writeStream.
                        self fileOutSourceCodeOf: cls on:out.
                        out close.
                        didAccept := true.
                        checkInNew := checkInRepaired := true.
                    ] on:FileStream openErrorSignal do:[:ex|
                        self warn:'could not write file ' , (tempdir constructString:checkoutName).
                    ].
                ].

                checkInRepaired ifTrue:[
                    checkInNew ifTrue:[
                        Transcript showCR:('CVSSourceCodeManager [info]: checking in %1 (%2) (force)...' bindWith:className with:modulePath).
                    ] ifFalse:[
                        conflictResolvedManually := true.    "/ checkInRepaired and:[checkInNew not].
                        Transcript showCR:('CVSSourceCodeManager [info]: checking in %1 (%2) (manually repaired)...' bindWith:className with:modulePath).
                    ].
                ] ifFalse:[
                    Transcript showCR:'checkin of ' , className , ' aborted (conflicting changes; repository unchanged)'.
                    self reportError:'checkin of ' , className , ' aborted (conflicting changes; repository unchanged)'.
                    ^ false.
                ].
            ] ifFalse:[
                ((whatHappened startsWith:'U ')
                or:[ (whatHappened startsWith:'P ') ]) ifTrue:[
                    "/
                    "/ nothing changed here, but the repository already contains
                    "/ a newer version.
                    "/

                    self information:'nothing changed in your ''' , className , ''';
but repository already contains a newer version (repository unchanged).'.
                    ^ true.
                ] ifFalse:[
                    "/
                    "/ unexpected
                    "/
                    self warn:'unexpected message from CVS:
' , whatHappened , '

No checkin performed.'.
                    self reportError:'*** cannot checkin ' , className , ' (unexpected CVS response; repository unchanged)'.
                    ^ false.
                ]
            ]
        ].


        "/
        "/ now check it in again
        "/
        self activityNotification:'CVS: Saving ' , cls name , ' in repository...'.

        logMsg := logMsg replChar:$"  withString:'\"'.

        OperatingSystem isUNIXlike ifFalse:[
            "/ save the log message into another tempFile ...
            logTmp := Filename newTemporaryIn:tempdir.
            s := logTmp writeStream.
            s nextPutAll:logMsg.
            s close.

            cmd := 'commit -F "', logTmp baseName, '" ', checkoutName, ' >', '"' , cmdOut name , '"'.
        ] ifTrue:[
            "/
            "/ CVS up to V1.9.14 prints the 'new revision' to stderr,
            "/ CVS V1.9.16 to stdout.
            "/
            cmd := 'commit -m "', logMsg, '" ', checkoutName, ' >', '"', cmdOut name, '"' , ' 2>&1'.
        ].
        (self
            executeCVSCommand:cmd
            module:moduleDir
            inDirectory:tempdir name
        ) ifFalse:[
            (cmdOut exists and:[cmdOut fileSize > 0]) ifTrue:[
                whatHappened := cmdOut contentsOfEntireFile asString.
            ] ifFalse:[
                whatHappened := '<< no message >>'
            ].
            self warn:'The following problem was reported by cvs:

' , whatHappened , '

The class has NOT been checked into the repository.'.

            logTmp notNil ifTrue:[logTmp remove].
            self reportError:'cannot checkin modified class source'.
            ^ false.
        ].
        logTmp notNil ifTrue:[logTmp remove].
        (cmdOut exists and:[cmdOut fileSize > 0]) ifTrue:[
            whatHappened := cmdOut contentsOfEntireFile asString.
        ] ifFalse:[
            whatHappened := nil
        ].
    ] ensure:[
        OsError handle:[:ex |
            Dialog warn:('Warning: some problem encountered when trying to remove a temporary workfile:\\%1\\The checkin was successful, though.\Please remove those temporary files later.' withCRs
                        bindWith:ex description).
            ex proceed.
        ] do:[
            tempdir notNil ifTrue:[ tempdir recursiveRemove ].
            cmdOut notNil ifTrue:[ cmdOut remove ].
        ].
    ].

    "/
    "/ fetch the new revision nr as found in the commit commands output
    "/
    (whatHappened isEmptyOrNil) ifTrue:[
        'CVSSourceCodeManager [warning]: unexpected empty checkin command output' errorPrintCR.
    ] ifFalse:[
        whatHappened := whatHappened asCollectionOfLines asStringCollection.
        idx := whatHappened indexOfLineStartingWith:'new revision:'.
        idx == 0 ifTrue:[
            'CVSSourceCodeManager [error]: unexpected checkin command output (no new-revision info)' errorPrintCR.
        ] ifFalse:[
            l := whatHappened at:idx.
            newRevision := (l copyFrom:14 to:(l indexOf:$; startingAt:14)-1) withoutSpaces.
        ]
    ].

    "/
    "/ if there was no merge (i.e. the current version has been checked in unchanged):
    "/   patch the classes revisionInfo (but keep binaryRevision unchanged) to the new revision
    "/   this makes everyone here believe, that the incore version of the class is based upon
    "/   the newly checked in version.
    "/   (however, the binaryRevision must remain as it is - we will need it to fetch the sourceCode
    "/    correctly for all unchanged methodss)
    "/
    "/ if there was a merge (i.e. the repository now contains a merge of the current and some
    "/ other version):
    "/    patch the classes revisionInfo (again, keep the binaryRevision) to the old revision
    "/    and add a 'm' (for merged).
    "/    If we later checkin again, the new checkin will be again based on the current revision
    "/
    newRevision notNil ifTrue:[
        (didMerge or:[conflictResolvedManually]) ifFalse:[
            "/ new code:
            cls revisionString notEmptyOrNil ifTrue:[
                newRevision isNil ifTrue:[
                    'CVSSourceCodeManager [error]: got no valid revisionString (class checked in, but no valid revision returned)' errorPrintCR
                ] ifFalse:[
                    newString := self updatedRevisionStringOf:cls forRevision:newRevision andUser:OperatingSystem getLoginName with:cls revisionString.
                    newString isNil ifTrue:[
                        'CVSSourceCodeManager [error]: failed to update revisionString (class checked in, but no revision method)' errorPrintCR
                    ] ifFalse:[
                        self updateVersionMethodOf:cls for:newString.
                        cls revision ~= newRevision ifTrue:[
                            'CVSSourceCodeManager [error]: failed to update revisionString' errorPrintCR
                        ].
                    ].
                ].
                self activityNotification:'Done.'.
            ] ifFalse:[
                self activityNotification:'CVS: Fetch new revision number of ', cls name.

                changeLog := self revisionLogOf:cls fromRevision:newRevision toRevision:newRevision.
                (changeLog isNil or:[(changeLog at:#revisions) size ~~ 1]) ifTrue:[
                    force ifTrue:[
                        changeLog := self revisionLogOfContainer:classFileName directory:packageDir module:moduleDir.
                    ].
                ].
                (changeLog isNil or:[(changeLog at:#revisions) size ~~ 1]) ifTrue:[
                    'CVSSourceCodeManager [error]: failed to update revisionString (no log)' errorPrintCR.
                    self updateVersionMethodOf:cls for:'$' , 'Header' , '$'.  "/ concatenated to avoid RCS expansion
                ] ifFalse:[
                    entry := (changeLog at:#revisions) first.
                    newString := self revisionStringFromLog:changeLog entry:entry forClass:cls.
                    self updateVersionMethodOf:cls for:newString.
                    cls revision ~= newRevision ifTrue:[
                        'CVSSourceCodeManager [error]: failed to update revisionString' errorPrintCR
                    ]
                ]
            ]
        ] ifTrue:[
            "/ If the conflict was resolved manually, do NOT update the revision method
            "/ (to get a new conflict in the next check-in)

            "/ If there was a merge, update the revision method adding an 'm'"
            didMerge ifTrue: [
                newString := self updatedRevisionStringOf:cls forRevision:nil with:cls revisionString.
                newString notNil ifTrue:[ self updateVersionMethodOf:cls for:newString ].
            ]
        ].
    ].

    Class addChangeRecordForClassCheckIn:cls.
    self postCheckInClass:cls.

    conflictResolvedManually ifTrue:[
        (Dialog
            confirm:'Now the repository contains a merge between your and the other changes.
However, the class in your image does NOT contain the other changes.
This will lead to more conflict-resolving whenever you check this class in again later,
unless you load the newest (merged) version of the class from the repository.

I recommend doing this as soon as possible via your browser''s checkout function.'
            title:'Code Merged'
            yesLabel:'OK' noLabel:'Update (Load Merged Code)'
        ) ifFalse:[
            self utilities
                checkoutClass:cls
                askForRevision:false
                askForMerge:false
                askForConfirmation:false.
        ].
    ].
    ^ true

    "
     SourceCodeManager checkinClass:Array logMessage:'testing only'
    "

    "Created: / 11-09-1996 / 16:16:11 / cg"
    "Modified: / 26-02-1998 / 17:34:16 / stefan"
    "Modified: / 31-07-2013 / 18:07:53 / cg"
!

checkoutModule:aModule directory:aPackage andDo:aBlock
    "check out everything from a package into a temporary directory.
     Then evaluate aBlock, passing the name of that temp-directory.
     Afterwards, the tempDir is removed.
     Return true, if OK, false if any error occurred."

    |cvsRoot packageDir tempdir cmdOut cmd dirName rslt|

    cvsRoot := self getCVSROOTForModule:aModule.
    cvsRoot isNil ifTrue:[^ false ].

    aPackage notNil ifTrue:[
        dirName := aModule , '/' , aPackage.
    ] ifFalse:[
        dirName := aModule.
    ].

    self activityNotification:'CVS: Checking out everything in ' , dirName , '...'.

    tempdir := self createTempDirectory:nil forModule:nil.
    [
        cmd := 'checkout ', dirName.
        OperatingSystem isUNIXlike ifTrue:[
            "/ can redirect output
            cmdOut := Filename newTemporary.
            cmdOut exists ifTrue:[
                cmdOut remove.
            ].
            cmd := cmd , ' > ', '"'  , cmdOut name, '"' .
        ].

        rslt := self 
            executeCVSCommand:cmd 
            module:aModule
            inDirectory:tempdir name.

        packageDir := (tempdir construct:dirName).
        (packageDir exists and:[packageDir isDirectory]) ifFalse:[
            self reportError:(rslt ifTrue:['checkout failed (no dir)'] ifFalse:['failed to execute: ',cmd]).
            ^ false
        ].

        "/ now, invoke the block ...
        aBlock value:packageDir
    ] ensure:[
        cmdOut notNil ifTrue:[ cmdOut remove ].
        tempdir notNil ifTrue:[ tempdir recursiveRemove ].
    ].
    ^ true

    "Created: / 23-08-2006 / 14:07:05 / cg"
    "Modified: / 06-03-2012 / 11:57:52 / cg"
!

getSourceStreamFor:aClass revision:aRevisionStringOrNil
    "extract a classes source code and return an open readStream on it.
     A revision of nil selects the current (in image) revision.
     The classes source code is extracted using the revision and the sourceCodeInfo,
     which itself is extracted from the classes packageString."

    |cacheIt|

    "/ never cache symbolic versions
    cacheIt := (aRevisionStringOrNil isNil or:[ aRevisionStringOrNil first isDigit ]).
    ^ self getSourceStreamFor:aClass revision:aRevisionStringOrNil cache:cacheIt
!

streamForClass:cls fileName:fileName revision:revision directory:packageDir module:moduleDir cache:cacheItArg
    "extract a source file and return an open readStream on it,
     or nil if the extract failed. If revision is nil or (#newest), take
     the latest; otherwise, a specific revisions source is extracted.
     The cls argument is currently ignored, but may be used in future versions,
     to validate the correct container against the class.
     To check out a file (i.e. not a classes file), leave it nil."

    |cacheDir cacheSubDir cachedSourceFilename cachedFile cmd fullName revisionArg stream
     checkoutName checkoutNameLocal fullTempName fullCachedName tempdir cmdOut
     classFileName cvsRoot revMsg cacheIt zArg|

    cacheIt := cacheItArg.

    (DisabledModules notNil and:[DisabledModules includes:moduleDir]) ifTrue:[
        Transcript showCR:'cvs access for module ' , moduleDir , ' has been disabled (due to previous failure)'.
        Transcript showCR:'reenable using the launchers source&debugger dialog'.

        ^ nil
    ].

    cvsRoot := self getCVSROOTForModule:moduleDir.
    cvsRoot isNil ifTrue:[^ nil].

    classFileName := fileName.
    classFileName isNil ifTrue:[classFileName := cls classBaseFilename].

    (classFileName endsWith:',v') ifTrue:[
        classFileName := classFileName copyButLast:2.
    ].
    (classFileName endsWith:'.st') ifTrue:[
        cls notNil ifTrue:[
            classFileName := classFileName copyButLast:3.
        ]
    ].
    packageDir isEmptyOrNil ifTrue:[
        fullName := moduleDir , '/' , classFileName.
    ] ifFalse:[
        fullName := moduleDir , '/' , packageDir , '/' , classFileName.
    ].        
    cls notNil ifTrue:[
        fullName := fullName , '.st'.
    ].

    (revision isNil or:[revision == #newest]) ifTrue:[
        cachedSourceFilename := classFileName.
    ] ifFalse:[
        cachedSourceFilename := classFileName , '_' , revision.
    ].

    "/ if not already existing, create a cache directory
    "/ where we deposit sources.
    "/ this is used as a cache for further requests, since
    "/ accessing the repository may be slow.
    "/ (if cvs uses a remote connection via ppp, for example)

   (cacheIt and:[revision ~~ #newest and:[revision notNil]]) ifTrue:[
        (cacheDir := self sourceCacheDirectory) isNil ifTrue:[
            ('CVSSourceCodeManager [warning]: no source cache directory for %1' bindWith:cachedSourceFilename) infoPrintCR.
        ]
    ].

    cacheDir notNil ifTrue:[
        cacheSubDir := cacheDir / moduleDir / packageDir.
        cachedFile := cacheSubDir / cachedSourceFilename.
        cachedFile exists ifTrue:[
            ^ cachedFile readStream
        ].
    ].

    "/
    "/ first, create a temporary work tree
    "/ Do not make module and package directories, their existence cause cvs checkout to fail in server mode
    "/
    tempdir := self createTempDirectory:nil forModule:nil.
    tempdir isNil ifTrue:[
        ('CVSSourceCodeManager [error]: no tempDir - cannot checkout ' , classFileName) errorPrintCR.
        ^ nil
    ].
    [
"/    tempdir := Filename newTemporaryIn:nil.
"/    tempdir exists ifTrue:[
"/        tempdir recursiveRemove.
"/    ].
"/    tempdir makeDirectory.
"/    dir := tempdir construct:moduleDir.
"/    dir makeDirectory.
"/    dir := dir construct:packageDir.
"/    dir recursiveMakeDirectory.
"/    dir exists ifFalse:[
"/        tempdir recursiveRemove.
"/        'CVSMGR: cannot create temporary directory' infoPrintCR.
"/        ^ nil.
"/    ].

        "/
        "/ check it out there
        "/
        checkoutName :=  fullName.

        checkoutNameLocal := (moduleDir asFilename construct:packageDir) constructString:(fullName asFilename baseName).

        (revision isNil or:[revision == #newest]) ifTrue:[
            cachedSourceFilename := classFileName.
            revisionArg := ''.
            revMsg := ''.
        ] ifFalse:[
            cachedSourceFilename := classFileName , '_' , revision.
            revisionArg := ' -r ' , revision.
            revMsg := ' (' , revision , ')'.
        ].
        zArg := ''.
"/ does not work, yet ?!!?!!
"/        (cvsRoot includesString:'pserver') ifTrue:[
"/            zArg := ' -z 9'.
"/        ].

        self activityNotification:'CVS: Checking out source ' , checkoutName , revMsg.
        OperatingSystem isUNIXlike ifTrue:[
            "/ can redirect output
            cmdOut := FileStream newTemporary 
                        close;
                        fileName.
            cmd := 'checkout' , zArg, revisionArg , ' ', checkoutName , ' > ' , '"' , cmdOut name, '"' .
        ] ifFalse:[
            cmd := 'checkout' , zArg, revisionArg , ' ', checkoutName.
        ].

        (self 
            executeCVSCommand:cmd 
            module:moduleDir
            inDirectory:tempdir
        ) ifFalse:[
            ('CVSSourceCodeManager [error]: cannot checkout ' , checkoutName) errorPrintCR.

"/        "/ see if there is CVS access at all ...
"/        (self checkForExistingModule:moduleDir) ifFalse:[
"/            "/ disable
"/            DisabledModules isNil ifTrue:[
"/                DisabledModules := Set new.
"/            ].
"/            DisabledModules add:moduleDir.
"/            ('CVSSourceCodeManager [warning]: disabled repository access for module ' , moduleDir) errorPrintCR.
"/        ].

            ^ nil.
        ].

        fullTempName := tempdir construct:checkoutNameLocal.
        (cacheSubDir isNil) ifTrue:[
            cacheIt := false
        ] ifFalse:[
            cacheSubDir recursiveMakeDirectory.
            fullCachedName := cacheSubDir constructString:cachedSourceFilename.
        ].
        fullTempName exists ifFalse:[
            ('CVSSourceCodeManager [error]: failed to checkout ', fullTempName pathName, ' (file does not exist after cvs co)') errorPrintCR.
            ^ nil
        ].

        (cacheIt 
        and:[cachedFile notNil
        and:[fullTempName exists]])
        ifTrue:[
            (OsError catch:[
                fullTempName moveTo:fullCachedName.
                self activityNotification:'CVS: Cached as ',fullCachedName asFilename baseName.
            ]) ifTrue:[
                self activityNotification:'CVS: Not cached.'.
                ('CVSSourceCodeManager [error]: failed to rename ', fullTempName pathName, ' to ', cachedSourceFilename) errorPrintCR.
                ^ nil
            ].
            fullCachedName asFilename exists ifTrue:[
                stream := fullCachedName asFilename readStream.
            ].
        ] ifFalse:[
            fileName = 'extensions.st' ifTrue:[
                self activityNotification:('CVS: "%1" not cached - please check your settings and/or version method in the "%2" projectDefinition.'
                                                bindWith:fileName 
                                                with:(moduleDir,':',packageDir))
            ] ifFalse:[
                self activityNotification:('CVS: "%1" not cached - please check your settings and/or version method in the "%2" projectDefinition.'
                                                bindWith:fileName
                                                with:(moduleDir,':',packageDir))
            ].

            OperatingSystem isUNIXlike ifTrue:[
                stream := fullTempName readStream.
            ] ifFalse:[ 
                "/ cannot remove files which are still open ...
                "/ sigh - need a delete-on-close flag in FileStream.
                "/
                stream := FileStream newTemporary.
                fullTempName copyToStream:stream.
                stream removeOnClose:true.
                stream reset.
            ].
        ].
        self releaseAndRemove:tempdir module:moduleDir outputTo:nil. 
    ] ensure:[
        cmdOut notNil ifTrue:[cmdOut remove].
        tempdir notNil ifTrue:[
            OsError handle:[:ex |
                ('CVSSourceCodeManager [warning]: could not remove temp directory ',tempdir pathName) infoPrintCR.
            ] do:[
                tempdir recursiveRemove
            ]
        ].
    ].
    ^ stream

    "Created: / 04-11-1995 / 19:46:20 / cg"
    "Modified: / 20-08-1997 / 16:37:11 / stefan"
    "Modified: / 20-01-2012 / 16:43:37 / cg"
! !

!CVSSourceCodeManager class methodsFor:'source code administration'!

checkForExistingContainer:fileName inModule:moduleDir directory:packageDir
    "check for a container to exist"

    |fullName ret ret2 cvsRoot cmd tempDir outputStream errorStream isLocalCVSRoot|

    cvsRoot := self getCVSROOTForModule:moduleDir.
    cvsRoot isNil ifTrue:[^ false].

    (isLocalCVSRoot := (cvsRoot startsWith:':local:')) ifTrue:[
        cvsRoot := cvsRoot withoutPrefix:':local:'.
    ].

    packageDir isEmptyOrNil ifTrue:[
        fullName := moduleDir , '/' , fileName.
    ] ifFalse:[ 
        fullName := moduleDir , '/' , packageDir , '/' , fileName.
    ].
    
    (RemoteCVS not or:[isLocalCVSRoot]) ifTrue:[
        cvsRoot asFilename exists ifTrue:[
            "/
            "/ with local CVS - simply check if that file exists
            "/
            (fullName endsWith:',v') ifFalse:[
                fullName := fullName , ',v'.
            ].
            ^ (cvsRoot asFilename / fullName) exists.
        ].
        ^ false
    ].

    tempDir := self createTempDirectory:nil forModule:nil.

    "With remote CVS, do a no-op rtag command, which doesn't
     need a working directory, but reports missing files"

    (fullName endsWith:',v') ifTrue:[
        fullName := fullName copyButLast:2.
    ].

    "/ cg: the code below smells - it depends upon no output being generated by cvs.
    "/ (which is NOT true, as the -l flag generates a warning message (sigh).

    "/ cmd := '-n rtag -l -F dummy '.
    cmd := '-n rtag -F dummy '.
    [  
        errorStream := '' writeStream.
        outputStream := '' writeStream.
        
        SourceCodeManagerError handle:[:ex |
            ^ false.
        ] do:[    
            ret := self 
                        executeCVSCommand:cmd , fullName 
                        module:moduleDir 
                        "/ cg; cannot do it in current dir, in case it contains a CVS subDirectory,
                        "/ with a different CVSRoot in its CVS/Root file ...
                        "/ cvs would complain then.
                        inDirectory:(tempDir pathName) 
                        log:false
                        outputTo:outputStream
                        errorTo:errorStream.
    
            "cannot check for exit status starting at cvs 1.11.5, because an exit status 0
             is returned even if the file does not exist"

            "But: if there is any output, the command failed and the container does not exist"
            "/ cg: read comment above.
            ret2 := errorStream size == 0.
            ret2 ifFalse:[
                ret2 := (errorStream contents asCollectionOfLines 
                            reject:[:l | l isBlank or:[(l includesString:'WARNING:')] ]) size == 0 
            ].
        ]
    ] ensure:[
        tempDir recursiveRemove.
    ].
    ^ ret2

    "
     CVSSourceCodeManager 
        checkForExistingContainer:'Integer.st'
        inModule:'stx' 
        directory:'libbasic' 

     CVSSourceCodeManager 
        checkForExistingContainer:'AboutBox.st'
        inModule:'stx' 
        directory:'libtool' 
    "

    "Modified: / 23-07-1999 / 17:36:58 / stefan"
    "Created: / 13-09-2006 / 18:20:36 / cg"
!

checkForExistingModule:moduleDir
    "check for a module to exist"

    |ret cvsRoot cmd tempDir isLocalCVSRoot |

    RecentlyCheckedModulesAndPackages notNil ifTrue:[
        (RecentlyCheckedModulesAndPackages includes:moduleDir) ifTrue:[
            RecentlyCheckedModulesAndPackages remove:moduleDir.
            RecentlyCheckedModulesAndPackages addFirst:moduleDir.
            ^ true.
        ].
    ].

    self activityNotification:'CVS: Checking for existing module ' , moduleDir.

    cvsRoot := self getCVSROOTForModule:moduleDir.
    cvsRoot isNil ifTrue:[^ false].

    (isLocalCVSRoot := (cvsRoot startsWith:':local:')) ifTrue:[
        cvsRoot := cvsRoot withoutPrefix:':local:'.
    ].

    ((RemoteCVS not or:[isLocalCVSRoot])
    and:[ cvsRoot asFilename exists ]) ifTrue:[
        "/
        "/ with local CVS - simply check if that directory exists
        "/
        ret := (cvsRoot , '/' , moduleDir) asFilename isDirectory.
    ] ifFalse:[
        tempDir := self createTempDirectory:nil forModule:nil.

        "With remote CVS, do a no-op rtag command, which doesn't
         need a working directory, but reports missing files"

        cmd := '-n rtag -l dummy '.
        [
            ret := self 
                        executeCVSCommand:cmd , moduleDir 
                        module:moduleDir
                        "/ cg; cannot do it in current dir, in case it contains a CVS subDirectory,
                        "/ with a different CVSRoot in its CVS/Root file ...
                        "/ cvs would complain then.
                        inDirectory:(tempDir pathName) 
                        log:false.
        ] ensure:[
            tempDir recursiveRemove.
        ].
    ].

    RecentlyCheckedModulesAndPackages isNil ifTrue:[
        RecentlyCheckedModulesAndPackages := OrderedCollection new.
    ].
    RecentlyCheckedModulesAndPackages addFirst:moduleDir.

    ^ ret

    "
     CVSSourceCodeManager checkForExistingModule:'stx'
     CVSSourceCodeManager checkForExistingModule:'DPU'
     CVSSourceCodeManager checkForExistingModule:'cg'  
     CVSSourceCodeManager checkForExistingModule:'aeg' 
     CVSSourceCodeManager checkForExistingModule:'foo'   
    "

    "Created: / 09-12-1995 / 19:13:37 / cg"
    "Modified: / 23-07-1999 / 17:38:59 / stefan"
    "Modified: / 19-08-2011 / 10:38:35 / cg"
!

checkForExistingModule:moduleDir directory:directory
    "check for a package to exist"

    |ret cvsRoot cmd tempDir fullName isLocalCVSRoot|

    fullName := moduleDir , '/' , directory.

    RecentlyCheckedModulesAndPackages notNil ifTrue:[
        (RecentlyCheckedModulesAndPackages includes:fullName) ifTrue:[
            RecentlyCheckedModulesAndPackages remove:fullName.
            RecentlyCheckedModulesAndPackages addFirst:fullName.
            ^ true.
        ].
    ].

    self activityNotification:'CVS: Checking for existing package ' , directory.

    cvsRoot := self getCVSROOTForModule:moduleDir.
    cvsRoot isNil ifTrue:[^ false].

    (isLocalCVSRoot := (cvsRoot startsWith:':local:')) ifTrue:[
        cvsRoot := cvsRoot withoutPrefix:':local:'.
    ].

    ((RemoteCVS not or:[isLocalCVSRoot]) 
    and:[ cvsRoot asFilename exists ]) ifTrue:[
        "/
        "/ with local CVS - simply check if that directory exists
        "/
        ret := (cvsRoot , '/' , fullName) asFilename isDirectory.
    ] ifFalse:[

        tempDir := self createTempDirectory:nil forModule:nil.

        "With remote CVS, do a no-op rtag command, which doesn't
         need a working directory, but reports missing files"

        cmd := '-n rtag -l -F dummy '.
        [
            ret := self 
                        executeCVSCommand:cmd, fullName 
                        module:moduleDir
                        "/ cg; cannot do it in current dir, in case it contains a CVS subDirectory,
                        "/ with a different CVSRoot in its CVS/Root file ...
                        "/ cvs would complain then.
                        inDirectory:(tempDir pathName) 
                        log:false.

        ] ensure:[
            tempDir recursiveRemove.
        ].
    ].

    RecentlyCheckedModulesAndPackages isNil ifTrue:[
        RecentlyCheckedModulesAndPackages := OrderedCollection new.
    ].
    RecentlyCheckedModulesAndPackages addFirst:fullName.

    ^ ret

    "
     CVSSourceCodeManager checkForExistingModule:'stx' package:'libbasic' 
     CVSSourceCodeManager checkForExistingModule:'aeg' package:'libProgram'  
     CVSSourceCodeManager checkForExistingModule:'foo' package:'libbasic' 
     CVSSourceCodeManager checkForExistingModule:'foo' package:'bar'   
     CVSSourceCodeManager checkForExistingModule:'cg' package:'private'   
    "

    "Modified: / 23-07-1999 / 17:39:21 / stefan"
    "Created: / 23-08-2006 / 14:03:03 / cg"
!

createContainerFor:aClass inModule:moduleDir package:packageDir container:fileName
    "create a container - this does an initial checkin
     (i.e. cvs add & cvs commit)"

    |fullName tempdir checkoutName cmdOut cmd tempFile idx aStream whatHappened l newRevision
     changeLog entry newString startIdx endIdx checkInDir logTmp s|

    aClass isPrivate ifTrue:[
        self reportError:'refuse to check in private classes.'.
        ^ false.
    ].

    cmdOut := Filename newTemporary.
    cmdOut exists ifTrue:[
        cmdOut remove.
    ].

    packageDir isEmptyOrNil ifTrue:[
        fullName :=  moduleDir , '/' , fileName
    ] ifFalse:[
        fullName := moduleDir , '/' , packageDir , '/' , fileName.
    ].        
    checkoutName :=  moduleDir , '/' , packageDir.

    "/
    "/ first, check out everything there - this creates the CVS helpfiles
    "/ required later.
    "/

    self activityNotification:'CVS: Checking for directory ' , checkoutName.
    tempdir := self createLocalDirectory:packageDir inModule:moduleDir.
    tempdir isNil ifTrue:[
        ('CVSSourceCodeManager [error]: cannot checkout ' , checkoutName) errorPrintCR.
        ^ false.
    ].

    "/
    "/ create the source there
    "/
    tempFile := (tempdir construct:checkoutName) construct:fileName.
    [
        aStream := tempFile writeStream.
    ] on:FileStream openErrorSignal do:[:ex|
        ('CVSSourceCodeManager [error]: temporary fileout failed -> ', tempFile name) errorPrintCR.
        tempdir recursiveRemove.
        ^ false
    ].

    Class fileOutErrorSignal handle:[:ex |
        'CVSSourceCodeManager [error]: fileout failed' errorPrintCR.
        aStream close.
        tempdir recursiveRemove.
        ^ false
    ] do:[
        self fileOutSourceCodeOf:aClass on:aStream
    ].
    aStream close.

    tempFile exists ifFalse:[
        'CVSSourceCodeManager [error]: temporary fileout failed' errorPrintCR.
        tempdir recursiveRemove.
        ^ false
    ].

    "/
    "/ and add it to the repository
    "/
    self activityNotification:'CVS: Adding ' , fileName.

    OperatingSystem isUNIXlike ifTrue:[
        checkInDir := tempdir constructString:checkoutName.
    ] ifFalse:[
        OperatingSystem isMSDOSlike ifTrue:[
            checkInDir := tempdir constructString:(checkoutName copyReplaceAll:$/ with:$\).
        ] ifFalse:[
            self error:'VMS case not yet implemented'. "/ add code for VMS ...
        ]
    ].
    cmd := 'add ' , fileName , ' > ', '"' , cmdOut name, '"'.
    (self 
        executeCVSCommand:cmd 
        module:moduleDir
        inDirectory:checkInDir
    ) ifFalse:[
        cmdOut remove.
        tempdir recursiveRemove.
        ('CVSSourceCodeManager [error]: cannot checkout ' , checkoutName) errorPrintCR.
        ^ false.
    ].
    cmdOut remove.

    "/
    "/ commit
    "/
    self activityNotification:'CVS: Committing ' , fileName.

    OperatingSystem isUNIXlike ifFalse:[
        "/ save the log message into another tempFile ...
        logTmp := Filename newTemporaryIn:checkInDir.
        s := logTmp writeStream.
        s nextPutAll:'initial checkin'.
        s close.

        cmd := 'commit -F "', logTmp baseName, '" ', fileName, ' > ', '"', cmdOut name, '"'.
    ] ifTrue:[
        "/
        "/ CVS up to V1.9.14 prints the 'new revision' to stderr,
        "/ CVS V1.9.16 to stdout.
        "/
        cmd := 'commit -m "initial checkin" ' , fileName , ' > ', '"' , cmdOut name, '"', ' 2>&1'.
    ].

    (self 
        executeCVSCommand:cmd 
        module:moduleDir
        inDirectory:checkInDir "tempdir name"
    ) ifFalse:[
        cmdOut fileSize > 0 ifTrue:[
            whatHappened := cmdOut contentsAsString.
        ] ifFalse:[
            whatHappened := '<< no message >>'
        ].
        self warn:'The following problem was reported by cvs:

' , whatHappened , '

The class has NOT been checked into the repository.'.

       'CVSSourceCodeManager [error]: cannot checkin modified class source' errorPrintCR.
        cmdOut remove.
        tempdir recursiveRemove.
        ^ false.
    ].
    whatHappened := cmdOut contentsOfEntireFile asString.
    cmdOut remove.

    "/
    "/ release it towards cvs
    "/
    self releaseAndRemove:tempdir module:moduleDir outputTo:nil. 

    "/
    "/ good - its in the CVS repository; now, we need the updated RCS header
    "/
    (whatHappened isEmptyOrNil) ifTrue:[
        'CVSSourceCodeManager [warning]: unexpected empty commit command output' errorPrintCR.
        "/ TODO: scan the file for $Header ...
        "/ and extract the revision manually

    ] ifFalse:[
        whatHappened := whatHappened asCollectionOfLines asStringCollection.
        idx := whatHappened indexOfLineStartingWith:'initial revision:'.
        idx ~~ 0 ifTrue:[
            startIdx := 18
        ] ifFalse:[
            idx := whatHappened indexOfLineStartingWith:'new revision:'.
            idx ~~ 0 ifTrue:[
                'CVSSourceCodeManager [warning]: container existed before' errorPrintCR.
                startIdx := 14.
            ] ifFalse:[
                'CVSSourceCodeManager [warning]: unexpected commit command output (no new-revision info)' errorPrintCR.
            ]
        ].
        idx ~~ 0 ifTrue:[
            l := whatHappened at:idx.
            endIdx := (l indexOf:$; startingAt:startIdx) - 1.
            endIdx < 0 ifTrue:[
                endIdx := l size
            ].
            newRevision := (l copyFrom:startIdx to:endIdx) withoutSpaces.
            (Number fromString:newRevision onError:nil) isNil ifTrue:[
                newRevision := '1.1'
            ]
        ]
    ].

    Transcript showCR:'created new sourceContainer for ' , aClass name , '.'.

    "/
    "/ patch the classes revisionInfo (but keep binaryRevision unchanged)
    "/ this makes everyone here believe, that the incore version of the class is based upon
    "/ the newly checked in version.
    "/ (however, the binaryRevision must remain as it is - we will need it to fetch the sourceCode
    "/  correctly for all unchanged methodss)
    "/

    newRevision notNil ifTrue:[
        changeLog := self 
                        revisionLogOf:aClass 
                        fromRevision:newRevision 
                        toRevision:newRevision
                        fileName:fileName
                        directory:packageDir
                        module:moduleDir.

        (changeLog isNil or:[(changeLog at:#revisions) size ~~ 1]) ifTrue:[
            'CVSSourceCodeManager [error]: failed to update revisionString (no log)' errorPrintCR
        ] ifFalse:[
            entry := (changeLog at:#revisions) first.
            newString := self revisionStringFromLog:changeLog entry:entry forClass:aClass.
            self updateVersionMethodOf:aClass for:newString.
            ('CVSSourceCodeManager [info]: updated revisionString to:',newString) infoPrintCR
        ]
    ].

    tempdir recursiveRemove.

    Class addChangeRecordForClassCheckIn:aClass.
    self postCheckInClass:aClass.
    ^ true

    "Created: / 09-12-1995 / 19:13:37 / cg"
    "Modified: / 23-07-1999 / 19:47:59 / stefan"
    "Modified: / 12-11-2010 / 11:04:42 / cg"
!

createContainerForText:someText inModule:moduleDir package:packageDir container:fileName
    "create a container - this does an initial checkin
     (i.e. cvs add & cvs commit)"

    |fullName tempdir checkoutName cmdOut cmd tempFile idx aStream whatHappened l newRevision
     startIdx endIdx checkInDir logTmp s|

    cmdOut := Filename newTemporary.
    cmdOut exists ifTrue:[
        cmdOut remove.
    ].

    packageDir isEmptyOrNil ifTrue:[
        fullName :=  moduleDir , '/' , fileName
    ] ifFalse:[
        fullName := moduleDir , '/' , packageDir , '/' , fileName.
    ].        
    checkoutName :=  moduleDir , '/' , packageDir.

    "/
    "/ first, check out everything there - this creates the CVS helpfiles
    "/ required later.
    "/

    self activityNotification:'CVS: Checking for directory ' , checkoutName.
    tempdir := self createLocalDirectory:packageDir inModule:moduleDir.
    tempdir isNil ifTrue:[
        ('CVSSourceCodeManager [error]: cannot checkout ' , checkoutName) errorPrintCR.
        ^ false.
    ].

    [
        "/
        "/ create the source there
        "/
        tempFile := (tempdir construct:checkoutName) construct:fileName.
        [
            aStream := tempFile writeStream.
        ] on:FileStream openErrorSignal do:[:ex|
            ('CVSSourceCodeManager [error]: temporary fileout failed -> ', tempFile name) errorPrintCR.
            ^ false
        ].

        aStream nextPutAll:someText.
        aStream close.

        tempFile exists ifFalse:[
            'CVSSourceCodeManager [error]: temporary fileout failed' errorPrintCR.
            ^ false
        ].

        "/
        "/ and add it to the repository
        "/
        self activityNotification:'CVS: Adding ' , fileName.

        OperatingSystem isUNIXlike ifTrue:[
            checkInDir := tempdir constructString:checkoutName.
        ] ifFalse:[
            OperatingSystem isMSDOSlike ifTrue:[
                checkInDir := tempdir constructString:(checkoutName copyReplaceAll:$/ with:$\).
            ] ifFalse:[
                self error:'VMS case not yet implemented'. "/ add code for VMS ...
            ]
        ].
        cmd := 'add ' , fileName , ' > ', '"' , cmdOut name, '"'.
        (self 
            executeCVSCommand:cmd 
            module:moduleDir
            inDirectory:checkInDir
        ) ifFalse:[
            cmdOut remove.
            ('CVSSourceCodeManager [error]: cannot checkout ' , checkoutName) errorPrintCR.
            ^ false.
        ].
        cmdOut remove.

        "/
        "/ commit
        "/
        self activityNotification:'CVS: Committing ' , fileName.

        OperatingSystem isUNIXlike ifFalse:[
            "/ save the log message into another tempFile ...
            logTmp := Filename newTemporaryIn:checkInDir.
            s := logTmp writeStream.
            s nextPutAll:'initial checkin'.
            s close.

            cmd := 'commit -F "', logTmp baseName, '" ', fileName, ' >', '"', cmdOut name, '"'.
        ] ifTrue:[
            "/
            "/ CVS up to V1.9.14 prints the 'new revision' to stderr,
            "/ CVS V1.9.16 to stdout.
            "/
            cmd := 'commit -m "initial checkin" ' , fileName , ' > ', '"' , cmdOut name, '"', ' 2>&1'.
        ].

        (self 
            executeCVSCommand:cmd 
            module:moduleDir
            inDirectory:checkInDir "tempdir name"
        ) ifFalse:[
            cmdOut fileSize > 0 ifTrue:[
                whatHappened := cmdOut contentsAsString.
            ] ifFalse:[
                whatHappened := '<< no message >>'
            ].
            self warn:'The following problem was reported by cvs:

' , whatHappened , '

The class has NOT been checked into the repository.'.

           'CVSSourceCodeManager [error]: cannot checkin modified class source' errorPrintCR.
            cmdOut remove.
            ^ false.
        ].
        whatHappened := cmdOut contentsOfEntireFile asString.
        cmdOut remove.

        "/
        "/ release it towards cvs
        "/
        self releaseAndRemove:tempdir module:moduleDir outputTo:nil. 

        "/
        "/ good - its in the CVS repository; now, we need the updated RCS header
        "/
        (whatHappened isEmptyOrNil) ifTrue:[
            'CVSSourceCodeManager [warning]: unexpected empty commit command output' errorPrintCR.
            "/ TODO: scan the file for $Header ...
            "/ and extract the revision manually

        ] ifFalse:[
            whatHappened := whatHappened asCollectionOfLines asStringCollection.
            idx := whatHappened indexOfLineStartingWith:'initial revision:'.
            idx ~~ 0 ifTrue:[
                startIdx := 18
            ] ifFalse:[
                idx := whatHappened indexOfLineStartingWith:'new revision:'.
                idx ~~ 0 ifTrue:[
                    'CVSSourceCodeManager [warning]: container existed before' errorPrintCR.
                    startIdx := 14.
                ] ifFalse:[
                    'CVSSourceCodeManager [warning]: unexpected commit command output (no new-revision info)' errorPrintCR.
                ]
            ].
            idx ~~ 0 ifTrue:[
                l := whatHappened at:idx.
                endIdx := (l indexOf:$; startingAt:startIdx) - 1.
                endIdx < 0 ifTrue:[
                    endIdx := l size
                ].
                newRevision := (l copyFrom:startIdx to:endIdx) withoutSpaces.
                (Number fromString:newRevision onError:nil) isNil ifTrue:[
                    newRevision := '1.1'
                ]
            ]
        ].

        Transcript showCR:'created new sourceContainer for ' , fileName , '.'.
    ] ensure:[
        tempdir recursiveRemove.
    ].
    ^ true

    "Modified: / 12-11-2010 / 11:04:55 / cg"
!

createModule:moduleName
    "create a module directory"

    |tempdir moduleDir cmdOut cmd|

    "/
    "/ first, create a temporary work tree
    "/
    tempdir := self createTempDirectory:nil forModule:moduleName.
    tempdir isNil ifTrue:[
        'CVSSourceCodeManager [error]: no tempDir - cannot create moduleDirectory' errorPrintCR.
        ^ false
    ].

    cmdOut := Filename newTemporary.
    cmdOut exists ifTrue:[
        cmdOut remove.
    ].

    "/
    "/ create the module directory 
    "/
    moduleDir := tempdir construct:moduleName.
    moduleDir exists ifFalse:[
        'CVSSourceCodeManager [error]: failed to create: ' errorPrint.  moduleDir name errorPrintCR.
        tempdir recursiveRemove.
        ^ false.
    ].     

    "/
    "/ then import it into CVS
    "/

    cmd := 'import -m "created from browser" ' , moduleName , ' initialV initialR > ' , cmdOut name.
    (self 
        executeCVSCommand:cmd 
        module:moduleName
        inDirectory:tempdir name
    ) ifFalse:[
        cmdOut remove.
        tempdir recursiveRemove.
        ^ false.
    ].

    'CVSSourceCodeManager [info]: created new module: ' infoPrint. moduleName infoPrintCR.
    tempdir recursiveRemove.
    cmdOut remove.
    ^ true

    "Created: / 09-12-1995 / 19:53:51 / cg"
    "Modified: / 07-01-1998 / 14:18:57 / stefan"
    "Modified: / 12-11-2010 / 11:00:25 / cg"
!

createModule:moduleDirName directory:packageDirName
    "create a package directory"

    |tempdir cmdOut cmd packageDir moduleDir relativePath idx parentPackage|

    "/ any parent package required ?
    idx := packageDirName lastIndexOf:$/.
    idx ~~ 0 ifTrue:[
        parentPackage := packageDirName copyTo:idx-1.
        (self checkForExistingModule:moduleDirName directory:parentPackage) ifFalse:[
            (self createModule:moduleDirName directory:parentPackage) ifFalse:[
                ^ false.
            ].
        ].
    ].

    (moduleDirName asFilename components includes:'core') ifTrue:[
        ('CVSSourceCodeManager [error]: cvs does not allow for a module to be named ''core'' - cannot create moduleDirectory') errorPrintCR.
        ^ false
    ].

    "/
    "/ first, create a temporary work tree
    "/
    tempdir := self createTempDirectory:packageDirName forModule:moduleDirName.

    cmdOut := Filename newTemporary.
    cmdOut exists ifTrue:[
        cmdOut remove.
    ].

    moduleDir := tempdir construct:moduleDirName.
    moduleDir isDirectory ifFalse:[
        'CVSSourceCodeManager [error]: command failed: ' errorPrint. cmd errorPrintCR.

        tempdir recursiveRemove.
        ^ false.
    ].
        
    "/
    "/ create the package directory there
    "/
    packageDir := moduleDir construct:packageDirName.
    OsError catch:[
        packageDir recursiveMakeDirectory.
    ].
    packageDir isDirectory ifFalse:[
        tempdir recursiveRemove.
        ('CVSSourceCodeManager [error]: cannot create new directory: ' , packageDir pathName) errorPrintCR.
        ^ false.
    ].

    "/
    "/ then import it into CVS
    "/

    relativePath := moduleDirName asFilename constructString:packageDirName.
    cmd := 'import -m "created from browser" . initialV initialR > ' , cmdOut name.
    (self 
        executeCVSCommand:cmd 
        module:moduleDirName
        inDirectory:tempdir name
    ) ifFalse:[
        'CVSSourceCodeManager [error]: output from cvs:' errorPrintCR.
        (cmdOut contentsAsString) errorPrint.

        cmdOut remove.
        tempdir recursiveRemove.
        ^ false.
    ].

    tempdir recursiveRemove.
    cmdOut remove.
    ^ true

    "
      self createModule:'stefan' package:'dummy1'
    "

    "Modified: / 23-07-1999 / 18:40:49 / stefan"
    "Created: / 23-08-2006 / 14:04:39 / cg"
    "Modified: / 12-11-2010 / 11:00:18 / cg"
!

deleteSymbolicName:symbolicName path:pathInRepository
    "remove symbolicName from classFileName"

    self setSymbolicName:symbolicName revision:0 overWrite:false path:pathInRepository

    "
        self deleteSymbolicName:'stable' path:'stx/libbasic/Array.st'
        self deleteSymbolicName:'testBLAbla' path:'stx/libbasic/Array.st'
    "
!

getExistingContainersInModule:aModule directory:aPackage
    "return a list of existing containers."

    ^ self listNonDirectories:aModule, '/', aPackage

    "
     CVSSourceCodeManager getExistingContainersInModule:'stx' package:'libhtml'
     CVSSourceCodeManager getExistingContainersInModule:'cg'  package:'java'
     CVSSourceCodeManager getExistingContainersInModule:'exept' package:'osi'
    "

    "Created: / 23-08-2006 / 14:12:04 / cg"
!

getExistingDirectoriesInModule:aModule
    "return a list of existing directories."

    ^ self listDirectories:aModule.

    "
     CVSSourceCodeManager getExistingDirectoriesInModule:'stx'
     CVSSourceCodeManager getExistingDirectoriesInModule:'cg'
     CVSSourceCodeManager getExistingDirectoriesInModule:'exept'
    "

    "Created: / 23-08-2006 / 14:13:41 / cg"
!

getExistingModules
    "return a list of existing modules"

    ^ self listDirectories:nil.

    "
     CVSSourceCodeManager getExistingModules
    "
!

listDirectories:cvsPath
    "return a list of all directories in cvsPath.
     cvsPath is the path relative to the cvs root"

    |directories|

    self activityNotification:'CVS: Fetching list of directories...'.

    directories := Set new.
    self listDirectoriesIn:cvsPath 
        into:[:fn | directories add:fn]
        nonDirectoriesInto:[:fn | ].
    ^ directories asArray sort

    "
     CVSSourceCodeManager listDirectories:nil
     CVSSourceCodeManager listDirectories:'stx'
     CVSSourceCodeManager listDirectories:'stx/libbasic'
    "
!

listDirectoriesIn:cvsPath into:dirBlock nonDirectoriesInto:nonDirBlock
    "enumerate all directories and non-directories in cvsPath.
     cvsPath is the path relative to the cvs root"

    |cvsRoot inStream line|

    cvsRoot := self getCVSROOTForModule:nil.
    cvsRoot isNil ifTrue:[^ self ].

    [
        inStream := self 
                        executeCVSCommand:('rls -l ' , (cvsPath ? '')) 
                        module:nil 
                        inDirectory:nil 
                        log:false 
                        pipe:true.

        inStream isNil ifTrue:[
            self warn:'This operation is not possible with this remoteCVS server'.
            ^ self.
        ].

        [
            line := inStream atEnd 
                        ifTrue:[nil] 
                        ifFalse:[ inStream nextLine ]. 
            line notNil
        ] whileTrue:[
            |idx|

            (line startsWith:$d) ifTrue:[
                "/ 'd--- 2005-06-02 17:21:20 +0200 Eigene Dateien'
                idx := 0.
                4 timesRepeat:[
                    idx := line indexOf:Character space startingAt:idx+1.
                ].
                dirBlock value: (line copyFrom:idx+1) withoutSeparators
            ] ifFalse:[
                "/ '---- 2005-06-02 17:21:20 +0200 1.23 .cvsIgnore'
                idx := 0.
                5 timesRepeat:[
                    idx := line indexOf:Character space startingAt:idx+1.
                ].
                nonDirBlock value: (line copyFrom:idx+1) withoutSeparators
            ].
        ].
    ] ensure:[
        inStream notNil ifTrue:[
            inStream close.
        ]
    ].

    "
     CVSSourceCodeManager listDirectories:nil
     CVSSourceCodeManager listDirectories:'stx'
     CVSSourceCodeManager listDirectories:'stx/libbasic'
    "
!

listNonDirectories:cvsPath
    "return a list of all containers in cvsPath.
     cvsPath is the path relative to the cvs root"

    |containers|

    self activityNotification:'CVS: Fetching list of containers...'.

    containers := Set new.
    self listDirectoriesIn:cvsPath 
        into:[:fn | ]
        nonDirectoriesInto:[:fn | containers add:fn].
    ^ containers asArray sort

    "
     CVSSourceCodeManager listNonDirectories:nil
     CVSSourceCodeManager listNonDirectories:'stx'
     CVSSourceCodeManager listNonDirectories:'stx/libbasic'
    "
!

newestRevisionInFile:classFileName directory:packageDir module:moduleDir
    "return the newest revision found in a container.
     Return nil on failure."

    |fullName modulePath inStream line s|

    false "self use_rlog" ifFalse:[
         "/ Uses 'cvs status' - rlog seems not to work and/or is slower

        |info|

        info := self
                statusOf:nil 
                fileName:classFileName 
                directory:packageDir 
                module:moduleDir.

        info isNil ifTrue:[^ nil].
        ^ info at:#newestRevision ifAbsent:nil 
    ].

    packageDir isEmptyOrNil ifTrue:[
        modulePath := moduleDir
    ] ifFalse:[
        modulePath :=  moduleDir , '/' , packageDir. 
    ].        
    fullName :=  modulePath , '/' , classFileName.

    [
        self activityNotification:'CVS: Fetching revision info for ', fullName.

        inStream := self 
                        executeCVSCommand:('rlog -h -N ' , fullName) 
                        module:moduleDir 
                        inDirectory:nil 
                        log:true 
                        pipe:true.

        inStream isNil ifTrue:[
            ('CVSSourceCodeManager [error]: cannot open pipe to cvs log ', fullName) errorPrintCR.
            "/ will be raised unconditionally in the near future...
            SourceCodeManagerError isHandled ifTrue:[
                SourceCodeManagerError raiseRequestErrorString:'cvs rlog failed'.
            ].
            ^ nil
        ].
        inStream atEnd ifTrue:[
            "/ mhmh - that could be a cvs configuration problem...
            "/ the following checks this and raises an appropriate error
            self 
                executeCVSCommand:('status ' , fullName) 
                module:moduleDir 
                inDirectory:nil 
                log:true 
                outputTo:(WriteStream on:'') errorTo:(WriteStream on:'').
        ] ifFalse:[
            "/
            "/ read the commands pipe output and extract the container info
            "/
            [inStream atEnd] whileFalse:[
                line:= inStream nextLine.
                line notNil ifTrue:[
                    line := line withoutSeparators.
                    line notEmpty ifTrue:[
                        s := line restAfter:'RCS file:' withoutSeparators:true. 
                        s notNil ifTrue:[ 
                            (UnixFilename named:s) directory baseName = 'Attic' ifTrue:[
                                "/ file has been removed in the repository
                                ^ #deleted
                            ].
                        ].
                        s := line restAfter:'head:' withoutSeparators:true.
                        s notNil ifTrue:[ |i|
                            i := s indexOfSeparator.
                            i ~~ 0 ifTrue:[
                                s := s copyTo:i-1
                            ].
                            ^ s
                        ].                        
                    ].                        
                ]
            ].
        ].
        ('CVSSourceCodeManager [warning]: no revision for ', fullName) errorPrintCR.
    ] ensure:[
        inStream notNil ifTrue:[inStream close].
    ].
    ^ nil

    "
     SourceCodeManager newestRevisionInFile:'Array.st' directory:'libbasic' module:'stx'       
    "

    "Modified: / 06-03-2012 / 11:55:33 / cg"
!

newestRevisionsInModule:module directory:packageDir
    "return a list of filename-module associations for the containers in
     a package directory.
     Return nil on failure."

    ^ self revisionsInModule:module directory:packageDir fromDate:nil

    "
     SourceCodeManager 
        newestRevisionsInModule:'bosch' directory:'dapasx'   
     SourceCodeManager 
        newestRevisionsInModule:'stx' directory:'goodies/net/ssl'   
    "

    "Created: / 12-10-2006 / 10:12:59 / cg"
!

removeContainer:fileName inModule:moduleDir directory:packageDir
    "remove a container"

    |fullName tempdir checkoutName cmdOut cmd tempFile whatHappened|

    packageDir isEmptyOrNil ifTrue:[
        fullName := moduleDir , '/' , fileName.
    ] ifFalse:[
        fullName := moduleDir , '/' , packageDir , '/' , fileName.
    ].        
    checkoutName :=  moduleDir , '/' , packageDir.

    (tempdir := self createLocalDirectory:packageDir inModule:moduleDir with:fileName) isNil ifTrue:[
        tempdir recursiveRemove.
        self reportError:('cannot checkout ',checkoutName,' (cannot create local directory)').
        ^ false.
    ].

    "/
    "/ and remove it to the repository
    "/
    self activityNotification:'CVS: Removing ' , fileName.

    RecentlyCheckedModulesAndPackages := nil.   "/ flush (could do better...)

    "/
    "/ check presence of file there
    "/
    tempFile := (tempdir construct:checkoutName) construct:fileName.
    tempFile exists ifFalse:[
        tempdir recursiveRemove.
        "/ already removed
        ^ false
    ].

    tempFile exists ifTrue:[
        tempFile remove.
    ].

    cmdOut := Filename newTemporary.
    cmdOut exists ifTrue:[
        cmdOut remove.
    ].

    cmd := 'remove ' , fileName , ' > ' , cmdOut name.
    (self 
        executeCVSCommand:cmd 
        module:moduleDir
        inDirectory:(tempdir constructString:checkoutName)
    ) ifFalse:[
        cmdOut remove.
        tempdir recursiveRemove.
        self reportError:('cannot remove ',checkoutName).
        ^ false.
    ].
    cmdOut remove.

    "/
    "/ commit
    "/
    self activityNotification:'CVS Committing removal of ' , fileName.

    cmd := 'commit -m "removed container" -l ' , fileName , ' 2> ' , cmdOut name.
    (self 
        executeCVSCommand:cmd 
        module:moduleDir
        inDirectory:(tempdir constructString:checkoutName)
    ) ifFalse:[
        cmdOut fileSize > 0 ifTrue:[
            whatHappened := cmdOut contentsAsString.
        ] ifFalse:[
            whatHappened := '<< no message >>'
        ].
        self warn:'The following problem was reported by cvs:

' , whatHappened , '

The container has NOT been removed into the repository.'.

        cmdOut remove.
        tempdir recursiveRemove.
        self reportError:'cannot remove container'.
        ^ false.
    ].
    cmdOut remove.

    "/
    "/ release the temporary tree towards cvs
    "/
    self releaseAndRemove:tempdir module:moduleDir outputTo:nil. 

    tempdir recursiveRemove.
    ^ true

    "
     SourceCodeManager checkForExistingContainer:'foo.st' inModule:'stx' directory:'private'. 

     SourceCodeManager removeContainer:'foo.st' inModule:'stx' package:'private'
    "

    "Modified: / 26-02-1998 / 17:33:57 / stefan"
    "Created: / 13-09-2006 / 18:31:55 / cg"
    "Modified (comment): / 19-08-2011 / 10:44:53 / cg"
!

removeContainer:fileName inModule:moduleDir package:packageDir
    "remove a container"

    <resource: #obsolete>
    self obsoleteMethodWarning.
    ^ self removeContainer:fileName inModule:moduleDir directory:packageDir

    "Modified: / 13-09-2006 / 18:32:25 / cg"
!

removeContainerInModule:moduleDir package:packageDir container:fileName
    "remove a container"

    <resource: #obsolete>
    self obsoleteMethodWarning.
    ^ self removeContainer:fileName inModule:moduleDir directory:packageDir

    "
     SourceCodeManager removeContainer:'foo.st' inModule:'stx' package:'private'
    "

    "Modified: / 26-02-1998 / 17:33:57 / stefan"
    "Modified: / 13-09-2006 / 18:31:52 / cg"
!

reportHistoryLogSince:timeGoal 
    filterSTSources:filterSTSourcesBool 
    filterUser:userFilter 
    filterRepository:filterRep 
    filterModules:filterModules
    inTo:aBlock

    "process a full historyLog, evaluate aBlock for each entry, passing 
     the logs info in a dictionary.
     This walks over all possible repositories.
     filterRep may be a collection of repository names 
     (i.e. 'stx', 'exept', 'phx' etc.) to only report changes made to one
     of those repositories.
     filterUser, if non-nil, will filter only changes made by that user."

    |inStream line words recordType fileName user date time rev pkgDir module idx
     clsName cls clsRev roots info tempDir endReached|

    CVSRoot isNil ifTrue:[
        'CVSSourceCodeManager [info]: CVSROOT not set' infoPrintCR.
        ^ nil
    ].

    filterRep notEmptyOrNil ifTrue:[
        roots := filterRep.
    ] ifFalse:[
        roots := Set withAll:(CVSModuleRoots values).
        roots add:CVSRoot.
    ].

    "/ must do it in a tempDir, to avoid cvs validating the -D arg
    "/ against any info found in CVS/Root

    tempDir := self createTempDirectory:nil forModule:nil.
    tempDir isNil ifTrue:[
        ('CVSSourceCodeManager [error]: no tempDir - cannot extract log') errorPrintCR.
        ^ nil.
    ].

    roots do:[:eachCvsRoot |
        |root host cmd|

        cmd := 'cvs -d ' , eachCvsRoot.

        cmd := cmd , ' history -x ARMT -a'.
        (timeGoal notEmptyOrNil) ifTrue:[
            cmd := cmd , ' -D "' , timeGoal printString , '"'.
        ].
        userFilter notNil ifTrue:[
            userFilter isString ifTrue:[
                cmd := cmd , ' -u "' , userFilter , '"'.
            ] ifFalse:[
                userFilter do:[:user |
                    cmd := cmd , ' -u "' , user , '"'.
                ].
            ].
        ].

"/ The -m and -x options do not work together in cvs history
"/
"/        filterModules notNil ifTrue:[
"/            filterModules do:[:aModule |
"/                cmd := cmd , ' -m "' , aModule , '"'.
"/            ].
"/        ].

        Transcript showCR:cmd.

        inStream := PipeStream readingFrom:cmd inDirectory:tempDir.
        inStream isNil ifTrue:[
            ('CVSSourceCodeManager [error]: cannot open pipe to ''cvs history''') errorPrintCR.
        ] ifFalse:[
            inStream class streamErrorSignal handle:[:ex |
                ('CVSSourceCodeManager [error]: pipe read error (''cvs history'')') errorPrintCR.
                ex return.
            ] do:[
                "/
                "/ read the commands pipe output and reformat the lines
                "/
                endReached := false.
                [endReached] whileFalse:[
                    inStream readWait.
                    line := inStream nextLine.
                    (endReached := line isNil) ifFalse:[

                        "/ cvs history line is of the following format:
                        "/ [Ma] date time +xxx user rev name module/package ....
                        words := line asCollectionOfWords.
                        words size < 7 ifTrue:[
                            "/ something like 'No records selected' ...
                        ] ifFalse:[
                            "a valid history line"
                            recordType := words at:1.
                            user := words at:5.

                            recordType = 'T' ifTrue:[
                                rev := words at:7.   "something like [expecco_2_8_0:HEAD]"
                                module := fileName := words at:6.
                                fileName := fileName copyAfterLast:$/.
                            ] ifFalse:[
                                rev := words at:6.
                                fileName := words at:7.
                                pkgDir := words at:8.
                                module := pkgDir.
                            ].
                            (filterSTSourcesBool not or:[fileName endsWith:'.st']) ifTrue:[
                                (userFilter isNil or:[userFilter includes:user]) ifTrue:[
                                    date := words at:2.
                                    time := words at:3.

                                    (module startsWith:'./') ifTrue:[
                                        module := module copyFrom:3.
                                    ].
                                    idx := module indexOf:$/.
                                    idx ~~ 0 ifTrue:[    
                                        module := module copyTo:idx-1.
                                    ].

                                    (filterModules isNil 
                                     or:[filterModules includes:module]) ifTrue:[
                                        recordType = 'M' ifTrue:[
                                            recordType := ' '
                                        ] ifFalse:[
                                            recordType = 'A' ifTrue:[
                                                recordType := '+'
                                            ] ifFalse:[
                                                recordType = 'R' ifTrue:[
                                                    recordType := '-'
                                                ]
                                            ]
                                        ].

                                        info := Dictionary new.
                                        info at:#cvsRecordType       put:recordType.
                                        info at:#date                put:date.
                                        info at:#time                put:time.
                                        info at:#user                put:user.
                                        info at:#fileName            put:fileName.
                                        info at:#revision            put:rev.
                                        info at:#directory           put:pkgDir.
                                        info at:#className           put:(Smalltalk classNameForFile:fileName).
                                        info at:#cvsRoot             put:eachCvsRoot.

                                        "/
                                        "/ for your convenience:
                                        "/  check what the actual version is in the image
                                        "/
                                        clsName := Smalltalk classNameForFile:fileName.
                                        clsName notNil ifTrue:[
                                            cls := Smalltalk classNamed:clsName.
                                            (cls notNil and:[(clsRev := cls revision) notNil]) ifTrue:[
                                                info at:#classesRevision     put:clsRev.
                                            ].
                                        ].
                                        aBlock value:info
                                    ]
                                ]
                            ]
                        ]
                    ]
                ].
            ].
            inStream close.
        ]
    ].

    tempDir recursiveRemove.

    "Created: / 17-01-2001 / 13:11:20 / cg"
    "Modified: / 29-08-2006 / 13:17:50 / cg"
!

reportHistoryLogSince:timeGoal filterSTSources:filter filterUser:userFilter filterRepository:filterRep inTo:aBlock
    "process a full historyLog, evaluate aBlock for each entry, passing 
     the logs info in a dictionary.
     This walks over all possible repositories.
     filterRep may be a collection of repository names 
     (i.e. 'stc', 'exept', 'phx' etc.) to only report changes made to one
     of those repositories.
     filterUser, if non-nil, will filter only changes made by that user."

    ^self
        reportHistoryLogSince:timeGoal 
        filterSTSources:filter 
        filterUser:userFilter 
        filterRepository:filterRep 
        filterModules:nil
        inTo:aBlock

    "Modified: / 17.1.2001 / 13:12:15 / cg"
!

revisionInfoFromString:aString
    "{ Pragma: +optSpace }"

    "return a dictionary filled with revision info.
     This extracts the relevant info from aString."

    ^ self revisionInfoFromString:aString inClass:nil

    "
     self revisionInfoFromString:(Array version_CVS)   
     self revisionInfoFromString:(stx_libbasic2 extensionsVersion_CVS)   
    "

    "Modified: / 01-07-2011 / 13:54:02 / cg"
!

revisionInfoFromString:aString inClass:aClass
    "{ Pragma: +optSpace }"

    "return a dictionary filled with revision info.
     This extracts the relevant info from aString."

    |fixedString autoFixHolder|

    autoFixHolder := UserPreferences current showBadRevisionStringDialogs not asValue.

    Dialog
        modifyingBoxWith:[:box |
            box addCheckBoxAtBottom:'Do not show this dialog again (always fix & proceed)' on:autoFixHolder.
        ] do:[
            "/ info: in some older ST/X releases, there have been bugs in the header string rewriting code,
            "/ which lead to invalid CVS strings being checked into our repository.
            "/ The following repairs such corrupted revision strings 'on the fly'.
            "/ The repair code will be removed at some time in the future...

            "/ temporary fix Felix' bad string translation:
            (aString startsWith:'§Header:') ifTrue:[
                (aString endsWith:'Exp §') ifTrue:[
                    fixedString := '$' , (aString copyFrom:3 to:(aString size - 2)) , '$'.

                    aClass isNil ifTrue:[
                        autoFixHolder value ifFalse:[
                            Dialog information:'Attention: the CVS version string is corrupted (§-bug). Please fix it manually'.
                        ]
                    ] ifFalse:[
                        (autoFixHolder value 
                            or:[ Dialog confirm:('Attention: the CVS version string is corrupted in "%1" (§-bug). Fix it?' withCRs bindWith:aClass name) ]
                        ) ifTrue:[
                            self updateVersionMethodOf:aClass for:fixedString.
                        ].
                    ].
                ].
            ].

            "/ temporary fix Jan's bad Umlaut-removal (which results in Felix's bad § being removed):
            (aString startsWith:'Header: ') ifTrue:[
                (aString endsWith:'Exp ') ifTrue:[
                    fixedString := '$' , aString , '$'.

                    aClass isNil ifTrue:[
                        autoFixHolder value ifFalse:[
                            Dialog information:'Attention: the CVS version string is corrupted (Umlaut remover-bug). Please fix it manually'.
                        ]
                    ] ifFalse:[
                        (autoFixHolder value 
                            or:[ Dialog confirm:('Attention: the CVS version string is corrupted in "%1" (Umlaut remover-bug). Fix it?' withCRs bindWith:aClass name) ]
                        ) ifTrue:[
                            self updateVersionMethodOf:aClass for:fixedString.
                        ].
                    ].
                ].
            ].

            "/ temporary fix translated (-sign) and not restored strings:
            (aString startsWith:'Header: ') ifTrue:[
                (aString endsWith:'Exp ') ifTrue:[
                    fixedString := '$' , (aString copyFrom:2 to:(aString size - 1)) , '$'.

                    aClass isNil ifTrue:[
                        autoFixHolder value ifFalse:[
                            Dialog information:'Attention: the CVS version string is corrupted (Escaper-bug). Please fix it manually'.
                        ]
                    ] ifFalse:[
                        (autoFixHolder value 
                            or:[ Dialog confirm:('Attention: the CVS version string is corrupted in "%1" (Escaper-bug).\\Fix it?' withCRs bindWith:aClass name) ]
                        ) ifTrue:[
                            self updateVersionMethodOf:aClass for:fixedString.
                        ].
                    ].
                ].
            ].
            UserPreferences current showBadRevisionStringDialogs:autoFixHolder value not.
        ].

    ^ CVSVersionInfo fromRCSString:(fixedString ? aString)

    "
     self revisionInfoFromString:(Array version_CVS)   
     self revisionInfoFromString:(stx_libbasic2 extensionsVersion_CVS)   
    "

    "Created: / 01-07-2011 / 13:51:41 / cg"
    "Modified: / 28-02-2012 / 10:40:48 / cg"
!

revisionLogOf:clsOrNil 
    fromRevision:firstRevOrNil toRevision:lastRevOrNil numberOfRevisions:numRevisionsOrNil 
    fileName:classFileName directory:packageDir module:moduleDir

    "return info about the repository container and
     (part of) the revisionlog as a collection of revision entries.
     Return nil on failure.

     If numRevisionsOrNil is notNil, it limits the number of revision records returned -
     only numRevions of the newest revision infos will be collected.

     The returned information is a structure (IdentityDictionary)
     filled with:
            #container          -> the CVS container file name 
            #cvsRoot            -> the CVS root (repository) 
            #filename           -> the actual source file name
            #newestRevision     -> the revisionString of the newest revision
            #numberOfRevisions  -> the number of revisions in the container (nil for all)
            #revisions          -> collection of per-revision info (see below)

            firstRevOrNil / lastRevOrNil specify from which revisions a logEntry is wanted:
             -If firstRevOrNil is nil, the first revision is the initial revision
              otherwise, the log starts with that revision.
             -If lastRevOrNil is nil, the last revision is the newest revision
              otherwise, the log ends with that revision.

             -If both are nil, all logEntries are extracted.
             -If both are 0 (not nil), no logEntries are extracted (i.e. only the header).

            per revision info consists of one record per revision:

              #revision              -> the revision string
              #author                -> who checked that revision into the repository
              #date                  -> when was it checked in
              #state                 -> the RCS state
              #numberOfChangedLines  -> the number of changed lines w.r.t the previous (as string with +n -n)
              #logMessage            -> the checkIn log message

            revisions are ordered newest first 
            (i.e. the last entry is for the initial revision; the first for the most recent one)
            Attention: if state = 'dead' that revision is no longer valid.
        "

    |tempDir fullName modulePath inStream inHeaderInfo atEnd line idx
     info record revisionRecords s headerOnly msg selectedRevisions|

    self use_rlog ifFalse:[
        tempDir := self createTempDirectory:nil forModule:nil.
        tempDir isNil ifTrue:[
            ('CVSSourceCodeManager [error]: no tempDir - cannot extract log') errorPrintCR.
            ^ nil.
        ].
    ].

    [
        |cmd revArg|

        packageDir isEmptyOrNil ifTrue:[
            modulePath := moduleDir 
        ] ifFalse:[
            modulePath :=  moduleDir , '/' , packageDir. 
        ].
        fullName :=  modulePath , '/' , classFileName.

        self use_rlog ifFalse:[
            self createEntryFor:fullName 
                 module:moduleDir
                 in:(tempDir construct:modulePath) 
                 revision:'1.1' 
                 date:'dummy' 
                 special:''
                 overwrite:false.
        ].

        revArg := ''.
        headerOnly := false.
        (firstRevOrNil notNil or:[lastRevOrNil notNil]) ifTrue:[
            (firstRevOrNil == 0 and:[lastRevOrNil == 0]) ifTrue:[
                revArg := '-h'.
                headerOnly := true.
            ] ifFalse:[
                revArg := '-r'.
                firstRevOrNil notNil ifTrue:[
                    revArg := revArg , firstRevOrNil
                ].
                revArg := revArg , ':'.
                lastRevOrNil notNil ifTrue:[
                    revArg := revArg , lastRevOrNil
                ].
            ]
        ].

        headerOnly ifTrue:[
            msg := 'CVS: Fetching revision info '
        ] ifFalse:[
            msg := 'CVS: Reading revision log '
        ].
        clsOrNil isNil ifTrue:[
            msg := msg , 'in ' , fullName.
        ] ifFalse:[
            msg := msg , 'of ', clsOrNil name.
        ].
        self activityNotification:msg,'...'.

        self use_rlog ifTrue:[
            cmd := ('rlog ' , revArg , ' ' , fullName).
        ] ifFalse:[
            cmd := ('log ' , revArg , ' ' , fullName).
        ].

        inStream := self 
                        executeCVSCommand:('rlog ' , revArg , ' ' , fullName) 
                        module:moduleDir 
                        inDirectory:tempDir 
                        log:true 
                        pipe:true.

        (inStream isNil or:[inStream atEnd]) ifTrue:[
            ('CVSSourceCodeManager [error]: cannot open pipe to "cvs log" ', fullName) errorPrintCR.
            SourceCodeManagerError raiseRequestWith:'failed to open pipe to "cvs log"'.
            ^ nil
        ].

        "/
        "/ read the commands pipe output and extract the container info
        "/
        info := IdentityDictionary new.
        inHeaderInfo := true.
        [inHeaderInfo and:[inStream atEnd not]] whileTrue:[
            line:= inStream nextLine.
            line notNil ifTrue:[
                |gotIt|

                gotIt := false.
                #('RCS file:'        #container
                  'Working file:'    #filename
                  'head:'            #newestRevision
                  'total revisions:' #numberOfRevisions
                 ) pairWiseDo:[:word :key |
                    gotIt ifFalse:[
                        s := line restAfter:word withoutSeparators:true.
                        s notNil ifTrue:[info at:key put:s. gotIt := true].                        
                    ]
                ].
                gotIt ifFalse:[
                    (line startsWith:'symbolic names:') ifTrue:[
                        |tags tokens|

                        tags := Dictionary new.
                        line:= inStream nextLine.
                        [line notNil 
                         and:[(line startsWith:Character space) or:[line startsWith:Character tab]]] whileTrue:[
                            tokens := line asCollectionOfSubstringsSeparatedBy:$:.
                            tags at:(tokens first withoutSeparators) put:(tokens second withoutSeparators).
                            line:= inStream nextLine.
                        ].
                        info at:#symbolicNames put:tags.
                    ].
                    (line notNil and:[line startsWith:'description:']) ifTrue:[inHeaderInfo := false].
                ]
            ]
        ].
        inStream nextLine. "/ skip separating line after description.

        info isEmpty ifTrue:[
            ('CVSSourceCodeManager [warning]: no log for ', fullName) errorPrintCR.
            ^ nil
        ].

        "/ strip selected revisions from the total-revisions entry
        s := info at:#numberOfRevisions.
        (idx := s indexOf:$;) ~~ 0 ifTrue:[
            info at:#numberOfRevisions put:(Integer readFrom:(s copyTo:idx - 1)).
            idx := s indexOf:$: startingAt:idx.
            selectedRevisions := Integer readFrom:(s copyFrom:idx+1) onError:0.
        ] ifFalse:[
            info at:#numberOfRevisions put:(Integer readFrom:s onError:[1]).
            selectedRevisions := 0.
        ].
        info at:#numberOfSelectedRevisions put:selectedRevisions.
        headerOnly ifFalse:[
            "/
            "/ continue to read the commands pipe output 
            "/ and extract revision info records
            "/
            inStream atEnd ifTrue:[
                selectedRevisions > 0 ifTrue:[
                    "/ suppress warning. if we try to get the info of a non-existing revision"
                    ('CVSSourceCodeManager [warning]: empty log for ', fullName) errorPrintCR.
                ].
                ^ info
            ].

            revisionRecords := OrderedCollection new:selectedRevisions.
            info at:#revisions put:revisionRecords.

            atEnd := false.
            [atEnd or:[inStream atEnd]] whileFalse:[
                record := self readRevisionLogEntryFromStream:inStream.
                record isNil ifTrue:[
                    atEnd := true.
                ] ifFalse:[
                    revisionRecords add:record.
                ].
                (numRevisionsOrNil notNil and:[revisionRecords size >= numRevisionsOrNil]) ifTrue:[
                    atEnd := true
                ]
            ].
        ].
    ] ensure:[
        inStream notNil ifTrue:[inStream close].

        tempDir notNil ifTrue:[
            OsError handle:[:ex |
                ('CVSSourceCodeManager [warning]: could not remove tempDir ', tempDir pathName) infoPrintCR.
            ] do:[
                tempDir recursiveRemove
            ].
        ].
        self activityNotification:nil.
    ].
    ^ info

    "
     SourceCodeManager revisionLogOf:Array 
     SourceCodeManager revisionLogOf:Array fromRevision:'1.40' toRevision:'1.43' 
     SourceCodeManager revisionLogOf:Array fromRevision:'1.40' toRevision:nil  
     SourceCodeManager revisionLogOf:Array fromRevision:nil toRevision:'1.3'  
     SourceCodeManager revisionLogOf:Array fromRevision:nil toRevision:nil  
     SourceCodeManager revisionLogOf:Array fromRevision:0 toRevision:0  
    "

    "Created: / 16-11-1995 / 13:25:30 / cg"
    "Modified: / 29-01-1997 / 16:51:30 / stefan"
    "Modified: / 05-02-2012 / 19:03:06 / cg"
!

revisionLogOfPackageInDirectory:packageDir module:moduleDir
    "
     The returned information is a list of structures (IdentityDictionary)
     each filled with:
            #container          -> the CVS container file name 
            #cvsRoot            -> the CVS root (repository) 
            #filename           -> the actual source file name
            #newestRevision     -> the revisionString of the newest revision
            #numberOfRevisions  -> the number of revisions in the container (nil for all)
            #revisions          -> collection of per-revision info (see below)

            firstRev / lastRef specify from which revisions a logEntry is wanted:
             -If firstRev is nil, the first revision is the initial revision
              otherwise, the log starts with that revision.
             -If lastRef is nil, the last revision is the newest revision
              otherwise, the log ends with that revision.

             -If both are nil, all logEntries are extracted.
             -If both are 0 (not nil), no logEntries are extracted (i.e. only the header).

            per revision info consists of one record per revision:

              #revision              -> the revision string
              #author                -> who checked that revision into the repository
              #date                  -> when was it checked in
              #state                 -> the RCS state
              #numberOfChangedLines  -> the number of changed lines w.r.t the previous (as string with +n -n)
              #logMessage            -> the checkIn log message

            revisions are ordered newest first 
            (i.e. the last entry is for the initial revision; the first for the most recent one)
            Attention: if state = 'dead' that revision is no longer valid.
        "

    |tempDir modulePath inStream inHeaderInfo atEnd line idx
     info record revisionRecords s headerOnly msg infoCollection
     fn container|

    self use_rlog ifFalse:[
        tempDir := self createTempDirectory:nil forModule:nil.
    ].

    [
        |cmd revArg|

        packageDir isEmptyOrNil ifTrue:[
            modulePath := moduleDir 
        ] ifFalse:[
            modulePath :=  moduleDir , '/' , packageDir. 
        ].
        self use_rlog ifFalse:[
self halt:'non-rlog no longer supported'.
^ self.
"/            self createEntryFor:fullName 
"/                 module:moduleDir
"/                 in:(tempDir construct:modulePath) 
"/                 revision:'1.1' 
"/                 date:'dummy' 
"/                 special:''
"/                 overwrite:false.
        ].

        revArg := ''.
        headerOnly := false.

        headerOnly ifTrue:[
            msg := 'CVS: Fetching revision info '
        ] ifFalse:[
            msg := 'CVS: Reading revision log '
        ].
        msg := msg , 'in package ' , modulePath.
        self activityNotification:msg,'...'.

        self use_rlog ifTrue:[
            cmd := ('rlog ' , revArg , ' ' , modulePath).
        ] ifFalse:[
            cmd := ('log ' , revArg , ' ' , modulePath).
        ].

        inStream := self 
                        executeCVSCommand:cmd 
                        module:moduleDir 
                        inDirectory:tempDir 
                        log:true 
                        pipe:true.

        inStream isNil ifTrue:[
            ('CVSSourceCodeManager [error]: cannot open pipe to cvs log ', modulePath) errorPrintCR.
            ^ nil
        ].

        infoCollection := Dictionary new.
        [inStream atEnd] whileFalse:[
            "/
            "/ read the commands pipe output and extract the container info
            "/
            info := IdentityDictionary new.
            inHeaderInfo := true.
            [inHeaderInfo and:[inStream atEnd not]] whileTrue:[
                line:= inStream nextLine.
                line notEmptyOrNil ifTrue:[
                    |gotIt|

                    gotIt := false.
                    #('RCS file:'        #container
                      'Working file:'    #filename
                      'head:'            #newestRevision
                      'total revisions:' #numberOfRevisions
                     ) pairWiseDo:[:word :key |
                        gotIt ifFalse:[
                            s := line restAfter:word withoutSeparators:true.
                            s notNil ifTrue:[info at:key put:s. gotIt := true].                        
                        ]
                    ].
                    gotIt ifFalse:[
                        (line startsWith:'symbolic names:') ifTrue:[
                            |tags tokens|

                            tags := Dictionary new.
                            line:= inStream nextLine.
                            [line notNil 
                             and:[(line startsWith:Character space) or:[line startsWith:Character tab]]] whileTrue:[
                                tokens := line asCollectionOfSubstringsSeparatedBy:$:.
                                tags at:(tokens first withoutSeparators) put:(tokens second withoutSeparators).
                                line:= inStream nextLine.
                            ].
                            info at:#symbolicNames put:tags.
                        ].
                        (line startsWith:'description:') ifTrue:[inHeaderInfo := false].
                    ]
                ]
            ].
            inStream nextLine. "/ skip separating line after description.

            info isEmpty ifTrue:[
                ('CVSSourceCodeManager [warning]: no log for ', modulePath) errorPrintCR.
            ] ifFalse:[

                "/ strip selected revisions from the total-revisions entry
                s := info at:#numberOfRevisions.
                (idx := s indexOf:$;) ~~ 0 ifTrue:[
                    info at:#numberOfRevisions put:(Integer readFrom:(s copyTo:idx - 1))
                ] ifFalse:[
                    info at:#numberOfRevisions put:(Integer readFrom:s onError:[1])
                ].
                headerOnly ifFalse:[
                    |numRevisions|

                    "/
                    "/ continue to read the commands pipe output 
                    "/ and extract revision info records
                    "/
                    numRevisions := info at:#numberOfRevisions.
                    revisionRecords := OrderedCollection new:numRevisions.
                    info at:#revisions put:revisionRecords.

                    atEnd := false.
                    [atEnd or:[inStream atEnd]] whileFalse:[
                        record := self readRevisionLogEntryFromStream:inStream.
                        record isNil ifTrue:[
                            atEnd := true.
                        ] ifFalse:[
                            revisionRecords add:record.
                        ].
                        (numRevisions notNil and:[revisionRecords size >= numRevisions]) ifTrue:[
                            atEnd := true
                        ]
                    ].
                ].
            ].
            fn := info at:#filename ifAbsent:nil.
            fn isNil ifTrue:[
                container := info at:#container ifAbsent:nil.
                fn := container asFilename baseName copyButLast:2.   "/ remove ',v' suffix
                info at:#filename put:fn.
            ].
            infoCollection at:(info at:#filename) put:info.    
        ].
    ] ensure:[
        inStream notNil ifTrue:[inStream close].

        tempDir notNil ifTrue:[
            OsError handle:[:ex |
                ('CVSSourceCodeManager [warning]: could not remove tempDir ', tempDir pathName) infoPrintCR.
            ] do:[
                tempDir recursiveRemove
            ].
        ].
        self activityNotification:nil.
    ].
    ^ infoCollection

    "
     CVSSourceCodeManager revisionLogOfPackageInDirectory:'libbasic3' module:'stx'  
    "
!

revisionsInModule:module directory:packageDir fromDate:aDateOrNilForNewest
    "return a list of filename-module associations for the containers in
     a package directory. Return nil on failure."

    |tempDir modulePath inStream info|

    tempDir := nil.         "use the current directory"

    self use_rlog ifFalse:[
         "/ Uses 'cvs status' - rlog seems not to work
        ^ nil.
    ].

    packageDir isEmptyOrNil ifTrue:[
        modulePath := module 
    ] ifFalse:[
        modulePath :=  module , '/' , packageDir. 
    ].
    [
        |revisionUsed dateSelector searchFor|

        self activityNotification:('CVS: Fetching revision infos for %1%2'
                                    bindWith:modulePath
                                    with:(aDateOrNilForNewest isNil
                                                ifTrue:[ '' ]
                                                ifFalse:[ ' of ',aDateOrNilForNewest printString])).

        dateSelector := aDateOrNilForNewest isNil 
                            ifTrue:[ '-h ' ]
                            ifFalse:[ '-S -d "%1"' bindWith:(aDateOrNilForNewest printStringFormat:'%y-%m-%d') ].
        inStream := self 
                        executeCVSCommand:('rlog -N -l %1 %2' bindWith:dateSelector with:modulePath) 
                        module:module 
                        inDirectory:tempDir 
                        log:true 
                        pipe:true.

        inStream isNil ifTrue:[
            ('CVSSourceCodeManager [error]: cannot open pipe to cvs rlog ', modulePath) errorPrintCR.
            ^ nil
        ].

        "/
        "/ read the commands pipe output and extract the container infos
        "/
        searchFor := aDateOrNilForNewest isNil 
                            ifTrue:[ 'head:' ]
                            ifFalse:[ 'revision ' ].

        info := self fetchRevisionsFromRLogStream:inStream searchForKeyword:searchFor.
    ] ensure:[
        inStream notNil ifTrue:[inStream close].
    ].
    self breakPoint:#cg.
    ^ info

    "
     SourceCodeManager 
        revisionsInModule:'exept' directory:'osi/asn1' fromDate:(Date today subtractDays:7)
     SourceCodeManager 
        revisionsInModule:'exept' directory:'osi/asn1' fromDate:nil
    "

    "Created: / 12-10-2006 / 10:12:59 / cg"
!

revisionsInModule:module directory:packageDir taggedAs:symbolicName
    "return a list of filename-module associations for the containers in
     a package directory. Return nil on failure."

    |tempDir modulePath inStream info|

    tempDir := nil.         "use the current directory"
    self use_rlog ifFalse:[
         "/ Uses 'cvs status' - rlog seems not to work
        ^ nil.
    ].

    packageDir isEmptyOrNil ifTrue:[
        modulePath := module 
    ] ifFalse:[
        modulePath :=  module , '/' , packageDir. 
    ].        
    self activityNotification:('CVS: Fetching revision infos for %1%2'
                                    bindWith:modulePath
                                    with:(' tagged as "',symbolicName,'"')).

    [
        |revisionUsed tagSelector searchFor|

        tagSelector := '-S -r"%1"' bindWith:symbolicName.
        inStream := self 
                        executeCVSCommand:('rlog -N -l %1 %2' bindWith:tagSelector with:modulePath) 
                        module:module 
                        inDirectory:tempDir 
                        log:true 
                        pipe:true.

        inStream isNil ifTrue:[
            ('CVSSourceCodeManager [error]: cannot open pipe to cvs rlog ', modulePath) errorPrintCR.
            ^ nil
        ].

        "/
        "/ read the commands pipe output and extract the container infos
        "/
        info := self fetchRevisionsFromRLogStream:inStream searchForKeyword:'revision '.
    ] ensure:[
        inStream notNil ifTrue:[inStream close].
    ].
    self breakPoint:#cg.
    ^ info

    "
     SourceCodeManager 
        revisionsInModule:'stx' directory:'libbasic2' taggedAs:'stable'
    "

    "Created: / 12-10-2006 / 10:12:59 / cg"
!

setSymbolicName:symbolicName revision:rev overWrite:overWriteBool class:aClass
    "set a symbolicName for revision rev.
     If rev is nil, set it for the head (most recent) revision.
     If rev is 0, delete the symbolic name.
     If overWriteBool is true, the symbolicName will be changed, even if it has already been set.
     If overWriteBool is false, an error will be raised if symbolicName has already been set.

     If filename is nil, the symbolicName for a whole package is set"

    self
        setSymbolicName:symbolicName 
        revision:rev 
        overWrite:overWriteBool 
        path:((self sourceInfoOfClass:aClass) at:#pathInRepository)

    "
     self setSymbolicName:'foo' revision:nil overWrite:false class:Array
     self setSymbolicName:'foo' revision:nil overWrite:true class:Array
     self setSymbolicName:'foo' revision:nil overWrite:true class:Array
     self setSymbolicName:'foo' revision:'1.1' overWrite:true class:Array
     self setSymbolicName:'foo' revision:0 overWrite:true class:Array
    "

    "Created: / 12-09-2006 / 12:56:52 / cg"
!

setSymbolicName:symbolicName revision:rev overWrite:overWriteBool classes:aCollectionOfClasses
    "set a symbolicName for revision rev.
     If rev is nil, set it for the head (most recent) revision.
     If rev is 0, delete the symbolic name.
     If overWriteBool is true, the symbolicName will be changed, even if it has already been set.
     If overWriteBool is false, an error will be raised if symbolicName has already been set.

     If filename is nil, the symbolicName for a whole package is set"

    |paths alreadyWarned|

    alreadyWarned := 0.

    paths := aCollectionOfClasses
                collect:[:cls |
                    |info path answer|

                    cls isLoaded ifFalse:[
                        Transcript showCR:('Cannot tag unloaded class: %1.' bindWith:cls name).
                        alreadyWarned == 0 ifTrue:[
                            Dialog warn:('Cannot tag unloaded class: %1.' bindWith:cls name).
                            alreadyWarned := alreadyWarned + 1.
                        ] ifFalse:[
                            alreadyWarned == 1 ifTrue:[
                                answer := Dialog confirmWithCancel:('Cannot tag unloaded class: %1.\\Suppress further warnings?' withCRs bindWith:cls name).
                                answer isNil ifTrue:[^ self].
                                answer == true ifTrue:[
                                    alreadyWarned := alreadyWarned + 1.
                                ].
                            ]
                        ].
                        nil
                    ] ifTrue:[
                        info := self sourceInfoOfClass:cls.
                        info isNil ifTrue:[
                            Dialog warn:('No source info for: %1 (not in repository?)' bindWith:cls name).
                            nil
                        ] ifFalse:[
                            path := info at:#pathInRepository ifAbsent:nil.
                            path isNil ifTrue:[
                                Dialog warn:('No source info for: %1 (not in repository?)' bindWith:cls name).
                            ].
                            path
                        ].
                    ].
                ]
                thenSelect:[:path | path notNil].
    self
        setSymbolicName:symbolicName
        revision:rev
        overWrite:overWriteBool
        pathes:paths

    "
     self setSymbolicName:'foo' revision:nil overWrite:false classes:(Array with:True with:False)
     self setSymbolicName:'foo' revision:nil overWrite:true classes:(Array with:True with:False)
     self setSymbolicName:'foo' revision:nil overWrite:true classes:(Array with:True with:False)
     self setSymbolicName:'foo' revision:'1.1' overWrite:true classes:(Array with:True with:False)
     self setSymbolicName:'foo' revision:0 overWrite:true classes:(Array with:True with:False)
    "

    "Created: / 12-09-2006 / 12:58:23 / cg"
!

setSymbolicName:symbolicName revision:rev overWrite:overWriteBool path:pathInRepository
    "set a symbolicName for revision rev.
     If rev is nil, set it for the head (most recent) revision.
     If rev is 0, delete the symbolic name.
     If overWriteBool is true, the symbolicName will be changed, even if it has already been set.
     If overWriteBool is false, an error will be raised if symbolicName has already been set.

     If filename is nil, the symbolicName for a whole package is set"

    self
        setSymbolicName:symbolicName
        revision:rev
        overWrite:overWriteBool
        pathes:(Array with:pathInRepository)

    "
     self setSymbolicName:'stable' revision:nil overWrite:false path:'stx/libbasic/Array.st'
     self setSymbolicName:'stable' revision:nil overWrite:true path:'stx/libbasic/Array.st'
     self setSymbolicName:'stable' revision:nil overWrite:true path:'stx/libbasic/Array.st'
     self setSymbolicName:'stable' revision:'1.1' overWrite:true path:'stx/libbasic/Array.st'
    "

    "Modified: / 12-09-2006 / 12:37:20 / cg"
!

setSymbolicName:symbolicNameArg revision:rev overWrite:overWriteBool pathes:pathesInRepository
    "set a symbolicName for revision rev.
     If rev is nil, set it for the head (most recent) revision.
     If rev is 0, delete the symbolic name.
     If overWriteBool is true, the symbolicName will be changed, even if it has already been set.
     If overWriteBool is false, an error will be raised if symbolicName has already been set.

     If filename is nil, the symbolicName for a whole package is set.
     If multiple paths are given, the revision MUST be nil."

    |argumentString result errorStream outStream moduleDirs symbolicName|

    symbolicName := (symbolicNameArg includes:Character space)
                        ifTrue:[ '"',symbolicNameArg,'"' ]
                        ifFalse:[ symbolicNameArg ].

    pathesInRepository size > 1 ifTrue:[
        self assert:(rev isNil or:[rev == 0]) "revision must be nil (for head) or 0 (for delete) with multiple paths"
    ].

    moduleDirs := pathesInRepository
                    collect:[:pathInRepository |
                        (pathInRepository asCollectionOfSubstringsSeparatedByAny:'/\') first.
                    ].
    moduleDirs do:[:moduleDir |
        |pathsInModule pathsInModuleAsArgument|

        pathsInModule := pathesInRepository
                    select:[:pathInRepository |
                        |moduleOfThisPath|

                        moduleOfThisPath := (pathInRepository asCollectionOfSubstringsSeparatedByAny:'/\') first.
                        moduleOfThisPath = moduleDir
                    ].

        rev = 0 ifTrue:[
            argumentString := ' -d '.
        ] ifFalse:[
            argumentString := ' -r ', (rev ? 'HEAD').
            overWriteBool ifTrue:[
                argumentString := argumentString, ' -F'
            ].
        ].

        pathsInModuleAsArgument := pathsInModule
                                        collect:[:eachPath |
                                            (eachPath includes:Character space) ifTrue:[
                                                '"',eachPath,'"'
                                            ] ifFalse:[
                                                eachPath
                                            ].
                                        ].
        pathsInModuleAsArgument := pathsInModuleAsArgument asStringCollection asStringWith:Character space.

        self activityNotification:('CVS: Setting symbolic name "%1" for: %2' bindWith:symbolicName with:pathsInModuleAsArgument).

        errorStream := '' writeStream.
        outStream := '' writeStream.

        result := self
                    executeCVSCommand:('rtag ' , argumentString, ' ', symbolicName, ' ', pathsInModuleAsArgument)
                    module:moduleDir
                    inDirectory:nil
                    log:true
                    outputTo:outStream
                    errorTo:errorStream.
        self activityNotification:nil.
        (result not or:[errorStream size ~~ 0]) ifTrue:[
            SourceCodeManagerError raiseRequestWith:errorStream contents errorString:' cvs tag failed: ', pathsInModuleAsArgument.
        ] ifFalse:[
            (outStream contents asStringCollection contains:[:someLine| someLine startsWithAnyOf:'WE']) ifTrue:[
                SourceCodeManagerError raiseRequestWith:outStream contents errorString:' cvs tag could not be set: ', pathsInModuleAsArgument.
            ].
        ].
    ].

    "
     self setSymbolicName:'stable' revision:nil overWrite:false path:'stx/libbasic/Array.st'
     self setSymbolicName:'stable' revision:nil overWrite:true path:'stx/libbasic/Array.st'

     self
        setSymbolicName:'test1'
        revision:nil
        overWrite:true
        path:'bosch/dapasx/datenbasis/DAPASX__HierarchicalList.st'

     self
        setSymbolicName:'test2'
        revision:nil
        overWrite:true
        pathes:#( 'bosch/dapasx/datenbasis/DAPASX__HierarchicalList.st'
                  'bosch/dapasx/datenbasis/DAPASX__ProjectSearch.st' )

     self
        setSymbolicName:'test2'
        revision:0
        overWrite:true
        pathes:#( 'bosch/dapasx/datenbasis/DAPASX__HierarchicalList.st'
                  'bosch/dapasx/datenbasis/DAPASX__ProjectSearch.st' )
    "

    "Created: / 12-09-2006 / 12:36:44 / cg"
!

standardRevisionStringFor:aClass inModule:moduleDir directory:packageDir container:fileName revision:revisionString
    "utility function: return a string usable as initial revision string"

    ^ 'Header: %1/%2/%3,v %4, %5 %6 %7 Exp'
        bindWith:moduleDir
        with:packageDir
        with:fileName
        with:revisionString
        with:(Date today printStringFormat:'%y/%m/%d')
        with:(Time now printStringFormat:'%h:%m:%s')
        with:(OperatingSystem getLoginName)
        

    "
     self 
        revisionStringFor:Array 
        inModule:'stx' 
        directory:'libbasic' 
        container:'Array.st' 
        revision:'123'          
    "

    "Created: / 23-07-2012 / 18:46:29 / cg"
!

statusOf:clsOrNil fileName:classFileName directory:packageDir module:moduleDir
    "return info about the status of a repository container.
     Return nil on failure.

     The returned information is a structure (IdentityDictionary)
     filled with:
            #newestRevision     -> the revisionString of the newest revision

     This is much faster than revisionLog info (especially, if there are many revisions),
     and all we need is a class's newest version number."

    |tempDir fullName modulePath inStream line   
     info s msg|

    packageDir isEmptyOrNil ifTrue:[
        modulePath :=  moduleDir. 
    ] ifFalse:[        
        modulePath :=  moduleDir , '/' , packageDir. 
    ].
    fullName :=  modulePath , '/' , classFileName.
    tempDir := self createTempDirectory:nil forModule:nil.
    tempDir isNil ifTrue:[
        ('CVSSourceCodeManager [error]: no tempDir - cannot extract status') errorPrintCR.
        ^ nil.
    ].

    [
        self createEntryFor:fullName 
             module:moduleDir
             in:(tempDir construct:modulePath) 
             revision:'1.1' 
             date:'dummy' 
             special:''
             overwrite:false.

        msg := 'CVS: fetching status info of '.
        clsOrNil isNil ifTrue:[
            msg := msg , fullName.
        ] ifFalse:[
            msg := msg , clsOrNil name.
        ].
        self activityNotification:msg.

        inStream := self 
                        executeCVSCommand:('status ' , fullName) 
                        module:moduleDir 
                        inDirectory:tempDir 
                        log:true 
                        pipe:true.

        (inStream isNil or:[inStream atEnd]) ifTrue:[
            ('CVSSourceCodeManager [error]: cannot open pipe to cvs status ', fullName) errorPrintCR.
            SourceCodeManagerError raiseRequestErrorString:'failed to open pipe to "cvs status"'.
            ^ nil
        ].

        "/
        "/ read the commands pipe output and extract the container info
        "/
        info := IdentityDictionary new.
        [inStream atEnd] whileFalse:[
            line:= inStream nextLine.
            line notNil ifTrue:[
                line := line withoutSeparators.
            ].
            line size > 0 ifTrue:[
                |gotIt i|

                ((line includesString:'warning')
                and:[ (line includesString:'is not')
                and:[ (line includesString:'pertinent') ]]) ifTrue:[
                    ^ nil
                ].

                gotIt := false.
                #(
                  'Repository revision:'  #newestRevision
                  'File:'  #fileStatus
                 ) pairWiseDo:[:word :key |
                    gotIt ifFalse:[
                        s := line restAfter:word withoutSeparators:true.
                        s notNil ifTrue:[
                            i := s indexOfSeparator.
                            i ~~ 0 ifTrue:[
                                s := s copyTo:i-1
                            ].
                            info at:key put:s.
                            gotIt := true.
                        ].                        
                    ]
                ].
            ]
        ].
        info isEmpty ifTrue:[
            ('CVSSourceCodeManager [warning]: no status for "', fullName,'"') errorPrintCR.
            SourceCodeManagerError raiseRequestErrorString:'no status for "', fullName,'"'.
            ^ nil
        ].
    ] ensure:[
        inStream notNil ifTrue:[inStream close].
        tempDir recursiveRemove
    ].
    ^ info

    "
     SourceCodeManager statusOf:Array 
     SourceCodeManager statusOf:Array fileName:'Array.st' directory:'libbasic' module:'stx'  
     SourceCodeManager statusOf:Filename fileName:'Filename.st' directory:'libbasic' module:'stx'  
     SourceCodeManager statusOf:NewSystemBrowser fileName:'NewSystemBrowser.st' directory:'libtool' module:'stx'  
    "

    "Modified: / 29-08-2006 / 13:18:00 / cg"
! !

!CVSSourceCodeManager class methodsFor:'source code utilities'!

annotationsFor:clsOrNil fileName:classFileName directory:packageDir module:moduleDir
    "return info about who changed what and when.
     Return nil on failure.

     The returned information is a structure entry for each line
            #revision           -> version of last change
            #author             -> author 
            #date               -> change date 
        "

    |tempDir fullName modulePath inStream inHeaderInfo line info msg|

    tempDir := self createTempDirectory:nil forModule:nil.
    tempDir isNil ifTrue:[
        ('CVSSourceCodeManager [error]: no tempDir - cannot extract log') errorPrintCR.
        ^ nil.
    ].

    [
        |cmd revArg|

        modulePath :=  moduleDir , '/' , packageDir. 
        fullName :=  modulePath , '/' , classFileName.

        self createEntryFor:fullName 
             module:moduleDir
             in:(tempDir construct:modulePath) 
             revision:'1.1' 
             date:'dummy' 
             special:''
             overwrite:false.

        msg := 'Fetching annotation log '.
        clsOrNil isNil ifTrue:[
            msg := msg , 'in ' , fullName.
        ] ifFalse:[
            msg := msg , 'of ', clsOrNil name.
        ].
        self activityNotification:msg,'...'.

        inStream := self 
                        executeCVSCommand:('annotate ' , fullName) 
                        module:moduleDir 
                        inDirectory:tempDir 
                        log:true 
                        pipe:true.

        inStream isNil ifTrue:[
            ('CVSSourceCodeManager [error]: cannot open pipe to cvs annotate ', fullName) errorPrintCR.
            ^ nil
        ].

        "/
        "/ read the commands pipe output and extract the info
        "/
        info := IdentityDictionary new.
        inHeaderInfo := true.
        [inHeaderInfo and:[inStream atEnd not]] whileTrue:[
            line:= inStream nextLine.
            ((line ? '') startsWith:'*******') ifTrue:[
                inHeaderInfo := false.
            ]
        ].

        "/
        "/ continue to read the commands pipe output 
        "/ and extract change info records
        "/
        [inStream atEnd] whileFalse:[
            line := inStream nextLine.
Transcript showCR:line.
        ].
    ] ensure:[
        inStream notNil ifTrue:[inStream close].

        tempDir notNil ifTrue:[
            OsError handle:[:ex |
                ('CVSSourceCodeManager [warning]: could not remove tempDir ', tempDir pathName) infoPrintCR.
            ] do:[
                tempDir recursiveRemove
            ].
        ].
        self activityNotification:nil.
    ].
    ^ info

    "
     SourceCodeManager 
        annotationsFor:Array 
        fileName:'Array.st' directory:'libbasic' module:'stx'
    "
    "
     SourceCodeManager 
        annotationsFor:MenuPanel 
        fileName:'MenuPanel.st' directory:'libwidg2' module:'stx'
    "
!

diffListFor:clsOrNil fileName:classFileNameArg directory:packageDir module:moduleDir revision1:rev1 revision2:rev2 cache:cacheIt
    "return diff info. This is supposed to return a standard diff-like
     list of lines, representing the diffs between two revisions.
     experimental (for ownershipGraph).
     Here we ask cvs to give us the diff list"

    |tempDir fullName modulePath inStream list msg cacheDir cachedFile classFileName diffDir|

    clsOrNil notNil ifTrue:[
        modulePath :=  clsOrNil package copyReplaceAll:$: with:$/.
        fullName :=  modulePath , '/' , (classFileName := clsOrNil getClassFilename).
    ] ifFalse:[
        modulePath :=  moduleDir , '/' , packageDir. 
        fullName :=  modulePath , '/' , (classFileName := classFileNameArg).
    ].

   (cacheIt) ifTrue:[
        (cacheDir := self sourceCacheDirectory) isNil ifTrue:[
            ('CVSSourceCodeManager [warning]: no source cache directory') infoPrintCR.
        ] ifFalse:[
            diffDir := (cacheDir / modulePath / '.diffs').
            diffDir exists ifFalse:[
                diffDir makeDirectory.
            ].
            cachedFile := diffDir / (classFileName,'_',rev1,'_',rev2).
            cachedFile exists ifTrue:[
                ^ cachedFile contents
            ].
        ].
    ].

    tempDir := self createTempDirectory:nil forModule:nil.
    tempDir isNil ifTrue:[
        ('CVSSourceCodeManager [error]: no tempDir - cannot extract status') errorPrintCR.
        ^ nil.
    ].

    [
        self createEntryFor:fullName 
             module:moduleDir
             in:(tempDir construct:modulePath) 
             revision:'1.1' 
             date:'dummy' 
             special:''
             overwrite:false.

        msg := 'CVS: Fetching diff list of '.
        clsOrNil isNil ifTrue:[
            msg := msg , fullName.
        ] ifFalse:[
            msg := msg , clsOrNil name.
        ].
        msg := msg , ' ' , rev1 , ' vs. ' , rev2.
        self activityNotification:msg.

        inStream := self 
                        executeCVSCommand:('diff -w -r%1 -r%2 %3' bindWith:rev1 with:rev2 with:fullName) 
                        module:moduleDir 
                        inDirectory:tempDir 
                        log:true 
                        pipe:true.

        inStream isNil ifTrue:[
            ('CVSSourceCodeManager [error]: cannot open pipe to cvs diff ', fullName) errorPrintCR.
            ^ nil
        ].

        "/
        "/ read the command's pipe output, skipping some administrative info
        "/
        [ inStream nextLine startsWith:'diff -'] whileFalse.

        list := inStream contents.
    ] ensure:[
        inStream notNil ifTrue:[inStream close].
        tempDir recursiveRemove
    ].
    list := list reject:[:line | line startsWith:'\ '].

    cachedFile notNil ifTrue:[
        cachedFile contents:list.
    ].
    ^ list

    "
     SourceCodeManager statusOf:Array 
     SourceCodeManager statusOf:Array fileName:'Array.st' directory:'libbasic' module:'stx'  
     SourceCodeManager statusOf:Filename fileName:'Filename.st' directory:'libbasic' module:'stx'  
     SourceCodeManager statusOf:NewSystemBrowser fileName:'NewSystemBrowser.st' directory:'libtool' module:'stx'  
    "

    "Modified: / 29-08-2006 / 13:18:00 / cg"
!

initialRCSRevisionStringFor:aClass in:dir container:fileName
    "return a string usable as initial revision string"

    "/ do not make the string below into one string;
    "/ RCS would expand it into a wrong rev-string

    |nm oldRev idx special|

    nm := fileName.
    (nm endsWith:',v') ifTrue:[
        nm := nm copyButLast:2
    ].
    (nm endsWith:'.st') ifFalse:[
        nm := nm , '.st'
    ].

    oldRev := aClass revisionString.
    special := ''.

    oldRev notNil ifTrue:[
        idx := oldRev lastIndexOf:$[.
        idx ~~ 0 ifTrue:[
            idx := oldRev indexOf:$[ startingAt:idx+1.
            idx ~~ 0 ifTrue:[
                special := ' ' , (oldRev copyFrom:idx).
            ]
        ]
    ].


    ^ '$' , 'Header: ' , dir , '/' , fileName , ',v $'
      , special

    "Modified: 17.9.1996 / 15:57:15 / cg"
    "Created: 14.2.1997 / 20:59:28 / cg"
!

initialRevisionStringFor:aClass inModule:moduleDir directory:packageDir container:fileName
    "return a string usable as initial revision string"

    |cvsRoot fullName|

    cvsRoot := self getCVSROOTForModule:moduleDir.
    cvsRoot := self repositoryTopDirectoryFromCVSRoot:cvsRoot.
    packageDir isEmptyOrNil ifTrue:[
        fullName := (cvsRoot , '/' , moduleDir)
    ] ifFalse:[
        fullName := (cvsRoot , '/' , moduleDir , '/' , packageDir)
    ].        
    ^ self initialRCSRevisionStringFor:aClass in:fullName container:fileName

    "Modified: / 16-01-1998 / 17:34:13 / stefan"
    "Created: / 23-08-2006 / 14:05:46 / cg"
! !

!CVSSourceCodeManager class methodsFor:'testing'!

isCVS
    ^ true

    "Created: / 16-08-2006 / 10:58:19 / cg"
! !

!CVSSourceCodeManager::CVSVersionInfo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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
    In ancient times, Class used to return a Dictionary when asked for versionInfo.
    This has been replaced by instances of VersionInfo and subclasses.

    CVSVersionInfo adds some CVS specific data.

    [author:]
        cg (cg@AQUA-DUO)
"
!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

!CVSSourceCodeManager::CVSVersionInfo class methodsFor:'instance creation'!

fromRCSString:aString
    "{ Pragma: +optSpace }"

    "I know how to parse RCS/CVS version id strings.
     Return an instance filled with revision info which is
     extracted from aString. This must be in RCS/CVS format."

    |words firstWord nextWord info nm s fn revString d |

    s := aString readStream.
    s skipSeparators.
    firstWord := s upToSeparator.

    info := self new.

    "/
    "/ supported formats:
    "/
    "/ $-Header:   pathName rev date time user state $
    "/ $-Revision: rev $
    "/ $-Id:       fileName rev date time user state $
    "/
    (firstWord = '$Header:' or:[firstWord = 'Header:']) ifTrue:[
        d := firstWord first.
        s skipSeparators.
        nm := s throughAll:',v '.
        nm := nm withoutSeparators.
        info repositoryPathName:nm.
        info fileName:(nm asFilename baseName copyButLast:2).
        words := s upToEnd asCollectionOfWords readStream.

        words atEnd ifFalse:[
            nextWord := words next.
            nextWord first ~= d ifTrue:[
                info revision:nextWord.
                nextWord := words next.
                (nextWord notNil and:[nextWord first ~= d]) ifTrue:[
                    info date:nextWord.
                    info time:words next.
                    nextWord := words next.
                    (nextWord notNil and:[nextWord startsWithAnyOf:'+-']) ifTrue:[
                        info timezone:nextWord.
                        nextWord := words next.
                    ].
                    info user:nextWord.
                    info state:words next.
                ]
            ].
        ].
        ^ info
    ].

    (firstWord = '$Revision:' or:[firstWord = 'Revision:']) ifTrue:[
        info revision:(s upToEnd asCollectionOfWords first).
        ^ info
    ].

    (firstWord = '$Id:' or:[firstWord = 'Id:']) ifTrue:[
        "/commented out by Jan Vrany, 2009/10/20
        "/according to http://svnbook.red-bean.com/en/1.5/svn.advanced.props.special.keywords.html
        "/svn has no support for $ Header $ expansion. Therefore
        "/libsvn uses $Id$ instead.
        "/self halt:'no longer supported'.        
        words := s upToEnd asCollectionOfWords readStream.
        info fileName:(fn := words next).
        (fn endsWith:',v') ifFalse:[
            "/ not a CVS version
            ^ nil
        ].
        info revision:(revString := words next).

        "/ do not use matchesRegex:'[0-9]+\.[0-9]+.*') here: regex is an optional package
        ((revString conform:[:c | c isDigit or:[c == $.]])
        and:[revString includes:$.]) ifFalse:[
            "/ not a CVS version
            ^ nil
        ].
        info date:(words next).
        info time:(words next).
        info user:(words next).
        info state:(words next).
        ^ info
    ].

    ^ nil

    "
     CVSVersionInfo fromRCSString:('$' , 'Revision: 1.122 $')
     CVSVersionInfo fromRCSString:(CVSSourceCodeManager version)
     CVSVersionInfo fromRCSString:(SVNSourceCodeManager version_CVS)
    "

    "Modified (comment): / 11-10-2011 / 23:41:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-11-2011 / 16:15:49 / cg"
    "Modified (format): / 24-11-2011 / 10:56:51 / cg"
! !

!CVSSourceCodeManager::CVSVersionInfo methodsFor:'accessing'!

changedLinesInfo
    ^ changedLinesInfo
!

changedLinesInfo:aString
    changedLinesInfo := aString.
!

repositoryPathName
    ^ repositoryPathName
!

repositoryPathName:something
    repositoryPathName := something.
!

timeZone
    ^ timeZone
!

timeZone:something
    timeZone := something.
!

timezone
    ^ timeZone

    "Created: / 22-10-2008 / 20:50:39 / cg"
!

timezone:something
    timeZone := something.

    "Created: / 22-10-2008 / 20:50:32 / cg"
! !

!CVSSourceCodeManager class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


CVSSourceCodeManager initialize!
