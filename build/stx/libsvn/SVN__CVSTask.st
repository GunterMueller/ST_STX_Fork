"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libsvn' }"

"{ NameSpace: SVN }"

Task subclass:#CVSTask
	instanceVariableNames:'packageDir tmpDir cvsRoot transcript'
	classVariableNames:'CVSRoot'
	poolDictionaries:''
	category:'SVN-Tasks'
!

!CVSTask class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
! !

!CVSTask class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
! !

!CVSTask class methodsFor:'accessing'!

cvsRoot

    ^CVSRoot

    "
        self cvsRoot
        self cvsRoot: '/home/jv/Projects/SmalltalkX/sandbox/cvs'
        self cvsRoot: '/home/jv/Repositories/mirrors/exept2.sytes.net/cvs/stx'         
    "

    "Created: / 25-05-2009 / 19:52:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-05-2009 / 18:26:31 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2011 / 19:44:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cvsRoot: aString

    CVSRoot := aString

    "
        CVSTask cvsRoot: '/home/jv/Repositories/mirrors/dialin.exept.de/cvs/stx' 
    "

    "Created: / 25-05-2009 / 19:51:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 23-09-2010 / 15:43:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 27-01-2012 / 22:47:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CVSTask class methodsFor:'execution'!

doFor:packages
    self doFor:packages
        logOn:Filename defaultTempDirectoryName pathName
                , Filename separatorString , 'convert.log'

    "Created: / 26-05-2009 / 18:20:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-05-2009 / 11:41:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doFor: pkgs logOn: log
    | transcript  packages failed |

    packages := pkgs isString ifTrue: [ Array with: pkgs ] ifFalse: [ pkgs ].
    transcript := SplittingWriteStream
                    on: Transcript
                    and: log asFilename writeStream.
    transcript showCR: 'Logging on ' , log asString.

    failed := false.

    packages do:
        [:pkg|
        [self new package: pkg; transcript: transcript; do]
            on: Error do:
                [:ex|
                transcript showCR: 'ERROR: Synchronization of ' , pkg , ' failed!!'.
                ex suspendedContext fullPrintAllOn:transcript.
                OperatingSystem getLoginName = 'jv' ifTrue:[ex pass].
                failed := true]].
    failed ifTrue:
        [transcript
            showCR:'Synchronization of one or more packages failed!!';
            showCR:'See the log for details'].

    transcript outStream2 close.

    "Created: / 26-05-2009 / 18:08:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 12:39:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2011 / 14:42:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CVSTask methodsFor:'accessing'!

cvsRoot
    ^ cvsRoot
!

cvsRoot:aStringOrFilename
    cvsRoot := aStringOrFilename asFilename.

    "Modified: / 25-05-2009 / 19:54:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

obsoleteFileNames

    ^#(
       '.cvsignore'
    )

    "Created: / 30-05-2009 / 15:48:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-06-2009 / 13:38:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

package
    ^ package
!

package: aStringOrSymbol
    package := aStringOrSymbol asSymbol.
    packageDir := (aStringOrSymbol asString copyReplaceAll: $: with: $/)
                asSymbol.
    workingCopy := self svnWorkingCopy.

    "Modified: / 19-08-2009 / 11:26:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnWorkingCopyPath
    ^ (tmpDir construct: 'svn-working-copy') construct: (packageDir asFilename baseName)

    "Modified: / 19-08-2009 / 11:25:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

transcript
    ^ transcript
!

transcript:something
    transcript := something.
! !

!CVSTask methodsFor:'executing'!

doCleanup

    tmpDir recursiveRemove

    "Created: / 29-05-2009 / 17:17:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doFixPackageContentIn: dir

    dir baseName = '.svn' ifTrue:[^self].

    self
       doRemoveObsoleteFilesIn: dir;
       doNormalizeClassContainerNamesIn: dir;
       doNormalizeEndOfLineIn: dir;
       doNormalizeVersionMethodIn: dir.

    self
        doSVNSetSvnEolStylePropertyIn: dir for: #( '*.st' );
        doSVNSetSvnKeywordPropertyIn: dir  for: #( '*.st' ).

    dir directoryContentsAsFilenames do:
        [:file|
        file isDirectory ifTrue:[self doFixPackageContentIn: file]]

    "Created: / 02-06-2009 / 17:31:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2011 / 20:00:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CVSTask methodsFor:'executing - helpers'!

doNormalizeClassContainerNamesIn: dir
    | files |

    self notify: 'Normalizing class container names'.
    files := dir directoryContentsAsFilenamesMatching: '*.st'.
    files do:
            [:file |
            | changeset change |
            changeset := ChangeSet fromFile: file.
            changeset isEmpty ifFalse:[change := changeset first].
            (change notNil and:[change isClassDefinitionChange])
                ifTrue:
                    [ | oldName  newName |

                    oldName := file baseName.
                    newName := (change className replaceAll: $: with: $_) , '.st'.
                    oldName ~= newName
                        ifTrue:
                            [ | sed  files |

                            self renameFile: (dir / oldName) to: (dir / newName).
                             "
                             Also, we have to update makefiles. Grrr, I hate this
                             build system.
                            "
                            files := dir directoryContentsMatching: #( 'Make.*' 'Makefile' 'makefile' '*.mak' 'abbrev.stc' ).
                            files isEmpty ifFalse:[
                            sed := (OSProcess new)
                                        executable: '/bin/sed';
                                        workdir: dir;
                                        arguments: (Array
                                                    with: '-i'
                                                    with: '-e'
                                                    with: ('"s/' , (oldName upTo: $.) , '/' , (newName upTo: $.) , '/g"'))
                                                        , (dir
                                                                directoryContentsMatching: #( 'Make.*' 'Makefile' 'makefile' '*.mak' 'abbrev.stc' ));
                                        stdout: transcript;
                                        stderr: transcript.
                            sed execute.
                            self assert: sed exitValue = 0
                                message: 'sed failed to finish properly. Check transcript'. ] ] ] ].

    "Created: / 29-05-2009 / 18:27:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 03-06-2009 / 12:19:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2011 / 20:05:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doNormalizeEndOfLineIn: dir
    | files  sed |

    self notify: 'Normalizing end-of-lines'.
    files := dir directoryContentsAsFilenames select: [:e | e suffix = 'st' ].
        files isEmpty ifTrue:[^self].
    sed := (OSProcess new)
                executable: '/bin/sed';
                arguments: (Array
                            with: '-i'
                            with: '-e'
                            with: 's/\r[^\n]/\n/g') , (files collect: [:e | e pathName ]);
                stdout: transcript;
                stderr: transcript.
    sed execute.
    self assert: sed exitValue = 0
        message: 'sed failed to finish properly. Check transcript'.

    "Created: / 29-05-2009 / 18:27:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 30-05-2009 / 16:06:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doNormalizeVersionMethodIn: dir

    self doNormalizeVersionMethodIn: dir doCopy: false

    "Created: / 29-05-2009 / 18:27:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 03-06-2009 / 11:22:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doNormalizeVersionMethodIn: dir doCopy: doCopy
    | files sed script |

    self notify: 'Normalizing #version methods'.
    files := dir
                directoryContentsAsFilenamesMatching: #( '*.st' "/ 'Make.*' 'Makefile' 'makefile' '*.mak' '*.c' '*.cc'
    ).
    files isEmpty ifTrue:[^self].
    doCopy
        ifTrue:
            [ files do: [:f | f copyTo: (f pathName , '~') asFilename ].
            files := files collect: [:f | (f pathName , '~') asFilename ] ].
    files do: [:file |
        self doNormalizeVersionMethodInFile: file
    ].

        
    

"/Old, probably buggy code (umlaut-remover?)
"/    sed := (OSProcess new)
"/                executable: '/bin/sed';
"/                arguments: (Array
"/                            with: '-i'
"/                            with: '-f'
"/                            with: script pathName)
"/                               , (files collect: [:e | e pathName ]);
"/                stdout: transcript;
"/                stderr: transcript.
"/    sed execute.
"/    self assert: sed exitValue = 0
"/        message: 'sed failed to finish properly. Check transcript'.

    "Created: / 03-06-2009 / 11:26:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2011 / 19:51:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2011 / 12:39:27 / jv"
!

doNormalizeVersionMethodInFile: file

    | tmp src dst line line2 versionMethodSelector |

    versionMethodSelector := nil.

    tmp := Filename newTemporary.
    [
        src := file asFilename readStream.
        dst := tmp writeStream.
        [ src atEnd ] whileFalse:[
            line := src nextLine.
            (line includes: '"{ Encoding: ') ifTrue:[
                (line includes: '"{ Encoding: utf8') ifTrue:[
                    src := EncodedStream stream: src encoder: CharacterEncoder encoderForUTF8.
                    dst :=  EncodedStream stream: dst encoder: CharacterEncoder encoderForUTF8.
                ] ifFalse:[
                    (line includes: '"{ Encoding: iso8859-1') ifTrue:[
                        src := EncodedStream stream: src encoder: (CharacterEncoder encoderFor:#'iso8859-1').
                        dst :=  EncodedStream stream: dst encoder: (CharacterEncoder encoderFor:#'iso8859-1')
                    ] ifFalse:[ 
                        self error: 'Unsupported encoding in a chunk, see chunk variable'.
                        ^self.
                    ]
                ]            
            ].


            ("(line = 'version')"false or:[line startsWith: 'version_']) ifTrue:[
                versionMethodSelector := line asSymbol.
            ].
            versionMethodSelector notNil ifTrue:[
                (#(version version_SVN) includes: versionMethodSelector) ifTrue:[
                    "Fix for bad version_SVN in some .st files"
                    line =  '    ^ '' Id ''' ifTrue:[
                    line := '    ^ ''Id'''                
                    ].  
                    (line startsWith: '    ^ '' Id: ') ifTrue:[
                        line := '    ^ ''',$$,'Id: ' , (line copyFrom: 13 to: (line lastIndexOf: $') - 1) , '$'''.

                    ] ifFalse:[
                        ((line startsWith: '    ^ ''$Header: ' ) and:[versionMethodSelector == #version]) ifTrue:[
                            line := '    ^ ''', $$ , 'Id: ' , (line copyFrom: 17 to: (line lastIndexOf: $') - 1) , ''''.    
                        ].
                    ].

                    line2 := line copyReplaceAll: (Character codePoint:16rA7) "16rA7" with: $$.            
                    (line = line2) ifFalse:[versionMethodSelector := nil].
                    line := line2.
                ] ifFalse:[
                    line2 := line copyReplaceAll: $$ with: (Character codePoint:16rA7) "16rA7".            
                    (line = line2) ifFalse:[versionMethodSelector := nil].
                    line := line2.
                ].
            ].
            src atEnd ifFalse:[
                dst nextPutLine: line.
            ] ifTrue:[
                dst nextPutAll: line.
            ]
        ].
        src close.            
        dst close.
        "
            tmp contents asString.
        "
        tmp moveTo: file asFilename.


    ] ensure: [
        src close.            
        dst close.
        tmp exists ifTrue:[tmp remove].
    ]

    "
        SVN::CVSTask basicNew doNormalizeVersionMethodInFile: 
            '/tmp/stx/libbasic/LongFloat.st'
    "

    "Created: / 05-07-2011 / 18:54:54 / jv"
    "Modified: / 19-01-2012 / 10:55:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRemoveDuplicateCommaVFilesInAtticIn:cvsDir
    |cvsAtticDir cvsDirContents|

    cvsAtticDir := cvsDir construct:'Attic'.
    cvsDirContents := cvsDir directoryContents.
    cvsAtticDir exists ifTrue:[
        cvsAtticDir
            directoryContentsAsFilenamesDo:[:atticFile |
                (cvsDirContents includes:atticFile baseName) ifTrue:[
                    Transcript showCR:'removing stale file ' , atticFile baseName , ' in Attic'.
                    atticFile isDirectory 
                        ifTrue:[atticFile recursiveRemove]
                        ifFalse:[atticFile remove]

                    "/cvsAtticDir remove.
                ]
            ]
    ].
    cvsDir
        directoryContentsAsFilenamesDo:[:file |
            (file isDirectory and:[ file baseName ~= 'Attic' ]) ifTrue:[
                self doRemoveDuplicateCommaVFilesInAtticIn:file
            ]
        ]

    "Created: / 25-05-2009 / 22:35:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-05-2009 / 18:27:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2011 / 18:01:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doRemoveObsoleteFilesIn: dir

    self notify: 'Removing obsolete files'.
    self removeFiles: self obsoleteFileNames.

    "Created: / 30-05-2009 / 15:43:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doSVNAddFilesFor: files
    self notify: 'Adding files'.
    files isEmpty ifTrue: [ ^ self ].
    (AddCommand new)
        workingCopy: workingCopy;
        paths: files;
        execute

    "Created: / 02-06-2009 / 19:01:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 11:26:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doSVNSetProperty: propName to: propValue in: dir for: files
    |  |
    self notify: 'Setting ',propName,' property to ', propValue.
    (dir asFilename / '.svn') exists ifFalse:[^self].
    files isEmpty ifTrue: [ ^ self ].
    (PropsetCommand new)
        workingCopy: (WorkingCopy branch: workingCopy branch path: dir);
        name:propName;
        value: propValue;
        paths: files;
        execute

    "Modified: / 19-08-2009 / 11:27:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 14-04-2011 / 17:25:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-04-2011 / 12:20:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSVNSetSvnEolStylePropertyFor: files
    | realFiles |
    self notify: 'Setting svn:eol-style property to LF'.
    files isEmpty ifTrue: [ ^ self ].
    realFiles := files select:
        [:each|(workingCopy path / each) isRegularFile].
    realFiles isEmpty ifTrue:[^self].
    (PropsetCommand new)
        workingCopy: workingCopy;
        name: 'svn:eol-style';
        value: 'LF';
        paths: realFiles;
        execute

    "Modified: / 19-08-2009 / 11:27:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 20-11-2009 / 13:27:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSVNSetSvnEolStylePropertyIn: dir for: files

    ^self doSVNSetProperty: 'svn:eol-style' to: 'LF' in: dir for: files.

    "Modified: / 19-08-2009 / 11:27:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2011 / 17:26:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSVNSetSvnKeywordPropertyFor: files

    self doSVNSetSvnKeywordPropertyIn: workingCopy path for: files.

    "Modified: / 19-08-2009 / 11:27:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2011 / 17:12:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSVNSetSvnKeywordPropertyIn: dir for: files

    ^self doSVNSetProperty: 'svn:keywords' to: 'Id HeadURL' in: dir for: files.

    "Modified: / 19-08-2009 / 11:27:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 14-04-2011 / 17:18:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CVSTask methodsFor:'executing - private'!

doSVNCheckout
    self notify: 'Checking out'.
    workingCopy checkout: SVN::Revision head full: true

    "Modified: / 19-08-2009 / 12:42:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-05-2011 / 18:30:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSVNCommit
    "
        FileBrowserV2 openOnDirectory: workingCopy path
    "

    self notify: 'Commiting'.
    (CommitCommand new)
        workingCopy: workingCopy;
        message: self svnCommitMessage;
        execute

    "Created: / 29-05-2009 / 18:13:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 11:28:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 20-11-2009 / 10:11:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CVSTask methodsFor:'initialization'!

initialize

    cvsRoot := self class cvsRoot asFilename.
    tmpDir := Filename newTemporaryDirectory.

    "Modified: / 29-05-2009 / 17:13:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CVSTask methodsFor:'private'!

removeFiles:arg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

renameFile:arg1 to:arg2
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

svnBranch

    ^Branch repository: self svnRepository path: self svnBranchPath

    "Created: / 19-08-2009 / 11:20:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnBranchPath
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility

    "Created: / 19-08-2009 / 11:18:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnCommitMessage
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

svnRepository

    ^Repository package: package url: self svnRepositoryUrl

    "Created: / 19-08-2009 / 11:12:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 12:23:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnRepositoryUrl
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

svnWorkingCopy
    "raise an error: must be redefined in concrete subclass(es)"

    ^WorkingCopy
        branch: self svnBranch
        path: self svnWorkingCopyPath

    "Created: / 19-08-2009 / 11:23:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CVSTask class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN

    ^ '§Id: SVN__CVSTask.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
