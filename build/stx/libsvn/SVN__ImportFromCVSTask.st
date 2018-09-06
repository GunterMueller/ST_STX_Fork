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

CVSTask subclass:#ImportFromCVSTask
	instanceVariableNames:'svnRoot'
	classVariableNames:'SVNRoot'
	poolDictionaries:''
	category:'SVN-Tasks'
!

!ImportFromCVSTask class methodsFor:'documentation'!

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

!ImportFromCVSTask class methodsFor:'accessing'!

svnRoot

    ^SVNRoot

    "
        self svnRoot 
        self svnRoot: '/home/jv/Projects/SmalltalkX/sandbox/svn'      
    "

    "Created: / 25-05-2009 / 21:06:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-05-2009 / 16:47:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-11-2009 / 21:22:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnRoot: aString

    SVNRoot := aString

    "
        self svnRoot 
        self svnRoot: '/home/jv/Projects/SmalltalkX/sandbox/svn'     

        USE THIS IN JV BOX (because of encryption)

        self svnRoot: '/tmp/migrated_svn_repos'      
    "

    "Created: / 25-05-2009 / 21:07:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-05-2009 / 18:26:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2011 / 19:45:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ImportFromCVSTask class methodsFor:'examples'!

migrate_eXept_repository
    self import:#( #'stx:libbasic'
             #'stx:libbasic2'
             #'stx:libbasic3'
             #'stx:libcomp' )
        logOn:'/tmp/migrate_eXept.log'

    "
        SVN::CVSMigrationTool migrate_eXept_repository"
    "Created: / 26-05-2009 / 17:34:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

migrate_eXept_repository_tinytalk
    self import:#( #'stx:libbasic'
             #'stx:libbasic2'
             #'stx:libbasic3'
             #'stx:libcomp'
             #'stx:projects/tinytalk' )
        logOn:'/tmp/migrate_eXept.log'

    "
        SVN::CVSMigrationTool migrate_eXept_repository_tinytalk"
    "Created: / 27-05-2009 / 10:08:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

migrate_eXpecco

    self import:#'exept:expecco'

    "
        SVN::CVSTask           cvsRoot: '/home/jv/Repositories/mirrors/exept2.sytes.net/cvs/stx'.
        SVN::ImportFromCVSTask svnRoot: '/tmp/migrated_svn_repos'.
        
        SVN::ImportFromCVSTask migrate_eXpecco
    "

    "Modified: / 26-05-2009 / 18:22:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-08-2010 / 11:16:11 / Jan Vrany <enter your email here>"
    "Created: / 14-04-2011 / 14:39:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-04-2011 / 17:59:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

migrate_stx_libbasic2
    self import:#'stx:libbasic2'

    "
        SVN::ImportFromCVSTask migrate_stx_libbasic2
    "

    "Created: / 25-05-2009 / 19:41:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-05-2009 / 10:09:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-08-2010 / 11:16:26 / Jan Vrany <enter your email here>"
!

migrate_stx_libbasic3
    self import:#'stx:libbasic3'

    "
        SVN::ImportFromCVSTask migrate_stx_libbasic3
    "

    "Created: / 27-01-2012 / 22:48:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

migrate_stx_libtool
    self import:#'stx:libtool'

    "
        SVN::ImportFromCVSTask migrate_stx_libtool
    "

    "Created: / 25-05-2009 / 22:12:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-05-2009 / 18:22:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-08-2010 / 11:16:11 / Jan Vrany <enter your email here>"
    "Modified: / 14-04-2011 / 18:10:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

migrate_workflow

    self import:#'exept:workflow'

    "
        SVN::CVSTask           cvsRoot: '/home/jv/Repositories/mirrors/exept2.sytes.net/cvs/stx'.
        SVN::ImportFromCVSTask svnRoot: '/home/jv/Projects/SmalltalkX/sandbox/svn'.
        
        SVN::ImportFromCVSTask migrate_eXpecco
    "

    "Modified: / 26-05-2009 / 18:22:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-08-2010 / 11:16:11 / Jan Vrany <enter your email here>"
    "Created: / 14-04-2011 / 17:58:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ImportFromCVSTask class methodsFor:'migration'!

import:pkgs 
    ^ self doFor:pkgs

    "Created: / 28-05-2009 / 11:08:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

import:pkgs logOn:log 
    ^ self doFor:pkgs logOn:log

    "Created: / 28-05-2009 / 11:09:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ImportFromCVSTask class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!ImportFromCVSTask methodsFor:'executing'!

do
    self notify:'Importing package ' , package.

    (svnRoot construct:packageDir) exists ifFalse:[
    self
        doChecks;
        doPrepareRepositories;
        doCVS2SVN.
    ].
    self
        doSVNFixPackageContent;
        doCleanup.
    self notify:'Package ' , package , ' imported'

    "Created: / 29-05-2009 / 18:05:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 31-05-2009 / 10:17:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2011 / 17:30:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCVS2SVN

    | cvs2svn |


    self notify: 'Importing CVS repository into SVN'.

    (svnRoot construct:packageDir) directory recursiveMakeDirectory.
    cvs2svn := OSProcess new
                executable: '/usr/bin/cvs2svn';
                arguments: (#(
                                '--quiet' '--quiet'
                                "/'--use-cvs'
                                '--use-rcs'
                                '--encoding=ascii'
                                '--encoding=utf8'
                                '--encoding=latin_1'
                                '--encoding=iso8859_2') ,
                                (Array with: '--tmpdir=' , (tmpDir construct:'cvs2svn-tmp') pathName) ,
                                (Array with: '--svnrepos' with: (svnRoot construct: packageDir) pathName) ,
                                (Array with: (cvsRoot construct: packageDir) pathName));
                stdout: transcript;
                stderr: transcript.

    cvs2svn execute.
    self 
        assert:  cvs2svn exitValue = 0
        message: 'cvs2svn failed to finish properly. Check transcript'.

    "Created: / 29-05-2009 / 18:05:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 11:48:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-08-2010 / 11:15:42 / Jan Vrany <enter your email here>"
!

doChecks

    self notify: 'Checking repositories'.

    self
        assert:cvsRoot exists 
        message:'cvsRoot does not exist';

        assert:(cvsRoot construct:'CVSROOT') exists
        message:'cvsRoot seems not to be a valid CVS root (no CVSROOT directory)';

        assert:(cvsRoot construct:packageDir) exists
        message:'cvsRoot seems does not contain given package';

        assert:svnRoot exists 
        message:'svnRoot does not exist';

"/        assert:(svnRoot construct:packageDir) exists not
"/        message:'SVN repository already exists in svnRoot';

        yourself.

    "Created: / 29-05-2009 / 17:18:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 30-05-2009 / 16:03:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2011 / 17:30:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doPrepareRepositories
    self doCVSRemoveDuplicateCommaVFilesInAttic

    "Created: / 29-05-2009 / 18:02:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doSVNFixPackageContent

    | trunk |
    trunk := workingCopy path.
    
    self
        doSVNCheckout;
        doFixPackageContentIn: trunk;
        doSVNCommit

    "Created: / 29-05-2009 / 18:06:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 11:26:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2011 / 17:57:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ImportFromCVSTask methodsFor:'executing - private'!

doCVSRemoveDuplicateCommaVFilesInAttic

    self notify: 'Removing duplicate *,v files in Attic'.

    self doRemoveDuplicateCommaVFilesInAtticIn:(cvsRoot construct:packageDir).

    "Created: / 25-05-2009 / 22:28:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 30-05-2009 / 16:04:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ImportFromCVSTask methodsFor:'initialization'!

initialize

    super initialize.
    svnRoot := self class svnRoot asFilename.

    "Created: / 28-05-2009 / 09:06:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ImportFromCVSTask methodsFor:'private'!

removeFiles: filenames 

    | filenamesToDelete |
    filenamesToDelete := filenames
        select:[:each| (workingCopy path / each) exists].

    filenamesToDelete isEmpty ifFalse:[
        (DeleteCommand new)
            workingCopy: workingCopy;
            paths: filenamesToDelete;
            execute]

    "Created: / 30-05-2009 / 16:09:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 11:28:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-11-2009 / 21:34:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

renameFile: oldFilename to: newFilename

    newFilename exists ifFalse:[
    (MoveCommand new)
        workingCopy: workingCopy;
        src: oldFilename pathName;
        dst: newFilename pathName;
        execute.
    ]

    "Created: / 30-05-2009 / 16:09:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 11:28:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-07-2010 / 22:37:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnBranchPath
        "raise an error: must be redefined in concrete subclass(es)"

    ^'trunk'

    "Modified: / 19-08-2009 / 11:18:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2011 / 17:45:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnCommitMessage
    ^ 'Manufactured by SVN::ImportFromCVSTask to fix repository layout'

    "Modified: / 30-05-2009 / 16:15:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

svnRepositoryUrl
    ^ 'file://' , (svnRoot asAbsoluteFilename construct:packageDir) pathName , '/%(BRANCH)'

    "Modified: / 19-08-2009 / 11:09:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-04-2011 / 17:44:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ImportFromCVSTask class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__ImportFromCVSTask.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !
