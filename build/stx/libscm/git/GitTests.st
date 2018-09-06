"{ Package: 'stx:libscm/git' }"

TestCase subclass:#GitTests
	instanceVariableNames:'repositories'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Tests'
!


!GitTests class methodsFor:'accessing'!

resources
    ^Array with: GitRepositoriesResource

    "Created: / 19-09-2012 / 18:55:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitTests methodsFor:'accessing'!

repositoryNamed: nm
    | dir |

    dir := GitRepositoriesResource current directoryForRepositoryNamed: nm.
    repositories add:  dir.
    ^GitRepository open: dir.

    "Created: / 19-09-2012 / 19:04:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitTests methodsFor:'private'!

performTest

    GitCommitterQuery answer: (GitSignature name: self class name email: (self class name , '@nowhere')) do:[
        super performTest
    ].

    "Created: / 30-09-2012 / 10:02:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitTests methodsFor:'running'!

setUp

    repositories := OrderedCollection new.

    "Created: / 19-09-2012 / 19:01:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown

    repositories do:[:e|
        [
            e asFilename recursiveRemove
        ] on: Error do:[
            "Stupid windows"
        ]
    ].

    "Created: / 19-09-2012 / 19:03:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-09-2012 / 05:26:48 / jv"
! !

!GitTests methodsFor:'tests - basic workflow'!

test_01a

    "Test modification of working copy and commit back"

    | repo wc file1_txt |

    repo := self repositoryNamed: 'test_repo_01'.
    "
    UserPreferences fileBrowserClass openOn: repo directory.    
    "
    wc := repo workingCopy.
    self assert: wc commit oid = (GitOid fromString:'541c09aa382a56ec87b813b3fb6ea84e17909889').

    "Modify some file"
    file1_txt := wc / 'file1.txt'.
    self assert: file1_txt isModified not.

    (file1_txt) writingFileDo:[:s|
        s nextPutAll: 'modified from test_01a'.
    ].
    self assert: file1_txt isModified.

    wc stage.
    wc commit: 'test_01a commit 1'.

    self assert: wc commit oid ~= (GitOid fromString:'541c09aa382a56ec87b813b3fb6ea84e17909889').
    self assert: wc commit message = 'test_01a commit 1'.
    self assert: wc commit parents size == 1.
    self assert: wc commit parents anElement oid = (GitOid fromString:'541c09aa382a56ec87b813b3fb6ea84e17909889').

    "Created: / 19-09-2012 / 23:06:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
