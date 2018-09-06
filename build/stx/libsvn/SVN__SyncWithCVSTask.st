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

CVSTask subclass:#SyncWithCVSTask
	instanceVariableNames:'cvsWc newFiles obsoleteFiles branchPath'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Tasks'
!

!SyncWithCVSTask class methodsFor:'documentation'!

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

!SyncWithCVSTask class methodsFor:'accessing'!

cvsRoot

    ^(Smalltalk at:#CVSSourceCodeManager:CVSRoot) 
        ? CVSRoot 
            ? ':pserver:cvs@cvs.smalltalk-x.de:/cvs/stx'

    "Created: / 19-08-2009 / 11:44:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SyncWithCVSTask class methodsFor:'updating'!

update:pkgs 
    ^ self doFor:pkgs

    "Created: / 28-05-2009 / 11:10:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

update:pkgs logOn:log 
    ^ self doFor:pkgs logOn:log

    "Created: / 28-05-2009 / 11:09:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

updateJv
    "Updates repositories at smalltalk.felk.cvut.cz"

    "
        SVN::SyncWithCVSTask updateJv
    "

    self
        update:#(
            #'stx:libbasic'
"/            #'stx:libbasic2'
            #'stx:libbasic3'
            #'stx:libcomp'
"/            #'stx:libcompat'
            #'stx:libjavascript'
            #'stx:libtool'
"/            #'stx:libview'
"/            #'stx:goodies/sunit'
        ) 
        logOn: 
            Filename homeDirectory / 'Projects' / 'SmalltalkX' /
                ('cvs-sync-log-', (Date today printStringFormat:'%y-%m-%d') , '.txt')

    "Created: / 19-08-2009 / 11:34:31 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 12:49:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-02-2012 / 08:57:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SyncWithCVSTask methodsFor:'accessing'!

branchPath
    ^ branchPath
!

branchPath:aString

    branchPath := aString.

    "Modified: / 19-08-2009 / 11:17:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

package: aString

    super package: aString.
    (tmpDir construct: 'cvs-working-copy') recursiveMakeDirectory.
    cvsWc := (tmpDir construct: 'cvs-working-copy') construct: packageDir.
    cvsRoot := CVSSourceCodeManager getCVSROOTForModule: package.

    "Created: / 28-05-2009 / 09:22:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-05-2009 / 11:45:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SyncWithCVSTask methodsFor:'executing'!

do
    self notify: 'Syncing package ', package.
    self
        doCVSCheckout;
        doCVSFixPackageContent;
        doSVNCheckout;
        doUpdate;
        doSVNCommit;
        doCleanup.
    self notify: 'Package ' , package , ' synced'

    "Created: / 02-06-2009 / 18:41:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doCVSFixPackageContent

    self
        doFixPackageContentIn:cvsWc

    "Created: / 02-06-2009 / 18:51:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doUpdate
    self
        doCopyFiles;
        doNormalizeVersionMethodIn: workingCopy path doCopy: true;
        doSVNAddFiles: newFiles;
        doSVNSetSvnKeywordPropertyFor: (newFiles reject:[:f|f isDirectory]);
        doSVNSetSvnEolStylePropertyFor: (newFiles reject:[:f|f isDirectory]);
        yourself

    "Created: / 02-06-2009 / 18:59:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 11:26:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 23-04-2011 / 12:47:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SyncWithCVSTask methodsFor:'executing - private'!

doCVSCheckout

    | cvs cvswc |
    cvswc := tmpDir construct:'cvs-working-copy'.
    "cvswc exists"false ifFalse:[
        cvs := OSProcess new
                executable: '/usr/bin/cvs';
                arguments: {
                    '-d'.
                    cvsRoot.
                    'checkout'.
                    packageDir.
                    };
                stdout: transcript;
                stderr: transcript;
                workdir: (tmpDir construct:'cvs-working-copy');
                yourself.
        cvs execute.
        self 
            assert:  cvs exitValue = 0
            message: 'cvs failed to finish properly. Check transcript'.
    ].

    "Created: / 02-06-2009 / 17:19:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 11:47:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-04-2012 / 16:24:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCopyFiles
    | cvsFiles  svnFilesSeen |

    cvsFiles := cvsWc recursiveDirectoryContents 
                reject: [:e | e asFilename directoryName endsWith: 'CVS' ].
    svnFilesSeen := Set new.
    cvsFiles do: 
            [:cvsFileName | 
            | cvsFile  svnFile  svnFileCopy |

            cvsFile := cvsWc construct: cvsFileName.
            svnFile := workingCopy path / cvsFileName.
            svnFileCopy := workingCopy path / (cvsFileName , '~').
            svnFilesSeen add: svnFile.
            svnFile exists 
                ifTrue: 
                    [ (self is: cvsFile
                        sameAs: (svnFileCopy exists ifTrue: [ svnFileCopy ] ifFalse: [ svnFile ])) 
                            ifFalse: 
                                [ cvsFile copyTo: svnFile.
                                self notify: 'Updating ' , cvsFileName. ].
                    svnFileCopy exists ifTrue: [ self removeFiles: (Array with: svnFileCopy) ] ]
                ifFalse: 
                    [
                    | svnDir |
                    svnDir := svnFile directory.
                    [svnDir exists] whileFalse:
                        [svnDir recursiveMakeDirectory.
                        newFiles addFirst: svnDir.
                        svnDir := svnDir directory].                    

                    newFiles add: svnFile.
                    cvsFile copyTo: svnFile.
                    self notify: 'Updating ' , cvsFileName. ]. ].
    obsoleteFiles := (workingCopy path recursiveDirectoryContentsAsFilenames 
                reject: [:e | e directory baseName = '.svn' ]) \ svnFilesSeen.

    "Created: / 02-06-2009 / 18:52:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 11:27:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 20-11-2009 / 11:36:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSVNAddFiles

    | newFileNames |
    newFiles isEmpty ifTrue: [ ^ self ].

    newFileNames := newFiles collect: [:e | e pathName ].
    
    (AddCommand new)
        workingCopy: workingCopy;
        paths: newFileNames;
        execute.

    "Created: / 28-05-2009 / 10:59:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 11:27:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 23-04-2011 / 12:41:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSVNAddFiles: files 

    | filesToAdd |
    files isEmpty ifTrue: [ ^ self ].
    filesToAdd := Set new.
    files do:[:f|
        | d |

        d := f directory.
        (d / '.svn') exists ifTrue:[
            filesToAdd add: f
        ] ifFalse:[
            | pd |
            pd := d.
            d := d directory.
            [ (d / '.svn') exists ] whileFalse:[
                pd := d.
                d := d directory.
            ].
            filesToAdd add: pd.
        ]
    ].


    (AddCommand new)
        workingCopy: workingCopy;
        paths: (filesToAdd collect: [:e | e pathName ]);
        execute.

    "Created: / 02-06-2009 / 19:39:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 11:27:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 16-11-2011 / 12:13:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SyncWithCVSTask methodsFor:'initialization'!

initialize

    super initialize.
    branchPath := '/trunk'.
    newFiles := OrderedSet new.
    obsoleteFiles := Set new.

    "Created: / 28-05-2009 / 09:08:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 12:29:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 20-11-2009 / 11:34:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SyncWithCVSTask methodsFor:'passes'!

pass56_RemoveFiles

    "
    svnFilesObsolete isEmpty ifTrue:[^self].

    DeleteCommand new
        workingCopy:svnWc pathName;
        paths:(svnFilesObsolete collect:[:e|e pathName]);
        execute.
    "

    "Created: / 28-05-2009 / 10:59:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-05-2009 / 17:52:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SyncWithCVSTask methodsFor:'private'!

is: fileA sameAs: fileB

    ^false"/(fileA suffix = 'st' and:[fileB suffix = 'st'])
        ifTrue: [self isSource:  fileA sameAs: fileB]
        ifFalse:[self isContent: fileA sameAs: fileB]

    "Created: / 28-05-2009 / 19:58:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-06-2009 / 20:04:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isContent: fileA sameAs: fileB

    ^(
        (MD5Stream hashValueOfFile: fileA)
            = (MD5Stream hashValueOfFile: fileB)
    ) 
        ifTrue:[true] ifFalse:["self halt."false]

    "Created: / 28-05-2009 / 22:28:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 03-06-2009 / 11:12:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isSource: fileA sameAs: fileB

    |rejectedVersionMethods changeSetA changeSetB diff |

    rejectedVersionMethods := #( version version_CVS version_SVN ).

    changeSetA := (ChangeSet fromFile: fileA) reject:
        [:ch|ch isMethodChange 
            and:[ch isForMeta
                and:[rejectedVersionMethods includes:ch changeSelector]]].
    changeSetB := (ChangeSet fromFile: fileB) reject:
        [:ch|ch isMethodChange 
            and:[ch isForMeta
                    and:[rejectedVersionMethods includes:ch changeSelector]]].
    diff := changeSetA diffSetsAgainst: changeSetB.
    ^diff isEmpty

    "Created: / 28-05-2009 / 22:27:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-06-2009 / 20:22:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

removeFiles: files

    files do:
        [:file|(cvsWc construct: file) remove]

    "Modified: / 02-06-2009 / 19:53:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

renameFile:file1 to:file2

    file1 asFilename renameTo: file2 asString

    "Modified: / 02-06-2009 / 19:36:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnBranchPath

    ^branchPath

    "Created: / 19-08-2009 / 11:16:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnCommitMessage

    ^'Synchronized with CVS repository at:
    ', cvsRoot asString

    "Created: / 28-05-2009 / 09:18:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnRepositoryUrl

    ^ (RepositoryManager repositoryUrlForPackage: package)

    "Modified: / 19-08-2009 / 11:09:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!SyncWithCVSTask class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__SyncWithCVSTask.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !
