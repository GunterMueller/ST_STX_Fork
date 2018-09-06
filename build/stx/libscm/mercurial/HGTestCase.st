"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#HGTestCase
	instanceVariableNames:'repositories hgScmEnabled hgSettings scm scmPerPackage
		tryLocalSourceFirst debug'
	classVariableNames:'Verbose'
	poolDictionaries:''
	category:'SCM-Mercurial-Tests'
!

!HGTestCase class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
!

documentation
"
    An anbstract base class for Mercurial tests

    [author:]
	Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGTestCase class methodsFor:'accessing'!

resources
    ^Array with: HGRepositoriesResource

    "Created: / 19-09-2012 / 18:55:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-10-2012 / 13:01:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTestCase class methodsFor:'testing'!

isAbstract
    ^self == HGTestCase

    "Created: / 17-11-2012 / 11:00:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTestCase methodsFor:'asserting'!

should: block raise: error withMessage: msg

    <resource: #skipInDebuggersWalkBack>

    ^self should: block raise: error suchThat: [:ex|
	ex description = msg
	].

    "Created: / 04-02-2013 / 11:13:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 04-02-2013 / 12:35:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTestCase methodsFor:'debugging'!

dumpRepositoryLog: repo
    ^self dumpRepositoryLog: repo on: Transcript sender: thisContext sender

    "Created: / 22-11-2012 / 11:08:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dumpRepositoryLog: repo on: stream
    self dumpRepositoryLog: repo on: stream sender: thisContext sender.

    "Created: / 22-11-2012 / 11:10:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dumpRepositoryLog: repo on: stream sender: sender

    Verbose == true ifFalse:[ ^ self ].
    stream cr.
    stream nextPutAll: '+-- hg log '; nextPutAll: repo pathName; nextPutAll:' -- '; cr.
    stream nextPutAll: '+-- sender: '; nextPutAll: sender printString ; nextPutAll:' -- '; cr.
    (OperatingSystem getFullCommandOutputFrom:'hg log ', repo pathName) do:[:line|
	stream nextPutAll:'| '; nextPutAll: line; cr.
    ].
    stream nextPutAll: '+------------- '; cr.

    "Created: / 22-11-2012 / 11:10:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTestCase methodsFor:'private'!

performTest

    HGAuthorQuery answer: (testSelector , ' <', testSelector , '@', self class name, '>') do:[
        Class updateChangeFileQuerySignal answer: false do:[
            | savedProject |

            savedProject := Project current.
            Project current: Project new.
            [
                super performTest.
            ] ensure:[
                Project current: savedProject
            ].
        ]
    ].

    "Created: / 30-09-2012 / 10:02:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-09-2013 / 01:22:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTestCase methodsFor:'running'!

setUp
    scm := false.
    hgScmEnabled := HGSourceCodeManager shownInBrowserMenus.

    "/ Save settings and reset to defaults, they will be restored in tearDown
    hgSettings := Dictionary new.
    #(hgCommand hgAutopush hgUseSharedRepositories) do:[:each | 
        hgSettings at: each put: (UserPreferences current at: each ifAbsent: [ nil ]).
    ].
    UserPreferences current at: #hgUseSharedRepositories put: false.

    scm := (Smalltalk at:#SourceCodeManager).
    scmPerPackage := AbstractSourceCodeManager managerPerMatchingModuleDefinitions.
    AbstractSourceCodeManager managerPerMatchingModuleDefinitions: scmPerPackage copy.
    AbstractSourceCodeManager managerPerMatchingModuleDefinitions addFirst:
        (AbstractSourceCodeManager::PackageAndManager package:'mocks:hg*' manager:HGSourceCodeManager).
    scm isNil ifTrue:[ Smalltalk at: #SourceCodeManager put: HGSourceCodeManager].            

    tryLocalSourceFirst := Class tryLocalSourceFirst.
    Class tryLocalSourceFirst:true.

    HGSourceCodeManager shownInBrowserMenus: true.
    repositories:= OrderedCollection new.

    HGRepositoriesResource current setUpRepositoryDirectory.

    debug := HGDebugFlags debug.
    "/HGDebugFlags debug: false.

    "Created: / 19-09-2012 / 19:01:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-02-2018 / 22:34:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    "/ Restore settings
    #(hgCommand hgAutopush hgUseSharedRepositories) do:[:each | 
        (hgSettings at: each) isNil ifTrue:[ 
            UserPreferences current removeKey: each
        ] ifFalse:[ 
            UserPreferences current at: each put: (hgSettings at: each).
        ].
    ].

    HGSourceCodeManager shownInBrowserMenus: hgScmEnabled.
    Smalltalk at: #SourceCodeManager put: scm.
    AbstractSourceCodeManager managerPerMatchingModuleDefinitions: scmPerPackage.
    Class tryLocalSourceFirst: tryLocalSourceFirst.
    HGPackageWorkingCopyRegistry current flush:'mocks*'.
    repositories := nil.
    HGRepositoriesResource current tearDownRepositoryDirectory.
    HGDebugFlags debug: debug.

    "Created: / 19-09-2012 / 19:03:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-09-2012 / 05:26:48 / jv"
    "Modified: / 07-02-2018 / 22:25:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTestCase methodsFor:'utilities'!

repositoryNamed: nm
    ^self repositoryNamed: nm unpack: true

    "Created: / 19-09-2012 / 19:04:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-01-2013 / 13:20:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryNamed: nm init: init
    | dir |

    dir := HGRepositoriesResource current directoryForRepositoryNamed: nm init: init.
    repositories add:  dir.
    ^HGRepository on: dir.

    "Created: / 04-02-2013 / 11:04:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryNamed: nm revision: revision
    ^self repositoryNamed: nm unpack: true revision: revision

    "Created: / 11-02-2014 / 11:09:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryNamed: nm unpack: unpack
    | dir |

    dir := HGRepositoriesResource current directoryForRepositoryNamed: nm unpack: unpack.
    repositories add:  dir.
    ^HGRepository on: dir.

    "Created: / 14-01-2013 / 13:20:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryNamed: nm unpack: unpack revision: revision
    | dir |

    dir := HGRepositoriesResource current directoryForRepositoryNamed: nm unpack: unpack revision: revision.
    repositories add:  dir.
    ^HGRepository on: dir.

    "Created: / 11-02-2014 / 11:09:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGTestCase class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

