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

Object subclass:#RepositoryManager
	instanceVariableNames:'configurations repositories workingCopyBase'
	classVariableNames:'Current WorkingCopyBase'
	poolDictionaries:''
	category:'SVN-Core'
!

!RepositoryManager class methodsFor:'documentation'!

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

!RepositoryManager class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 16-03-2008 / 11:53:21 / janfrog"
! !

!RepositoryManager class methodsFor:'accessing'!

current

    Current ifNil:
        [Current := self new].
    ^Current

    "Created: / 16-03-2008 / 11:52:11 / janfrog"
    "Modified: / 07-06-2008 / 22:23:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

disable

    self enabled: false

    "Created: / 20-04-2008 / 09:19:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-06-2008 / 22:30:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

enable

    self enabled: true

    "Created: / 20-04-2008 / 09:21:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-06-2008 / 22:30:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

enabled

    ^UserPreferences current svnEnabled

    "Created: / 20-04-2008 / 09:27:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 03-10-2008 / 11:28:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

enabled: aBoolean

    UserPreferences current svnEnabled: aBoolean.
    self changed:#enabled

    "Created: / 20-04-2008 / 09:18:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 03-10-2008 / 11:28:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

hasRepositoryForPackage: package

    self enabled ifFalse:[^false].
    ^self current hasRepositoryForPackage: package

    "Created: / 19-04-2008 / 10:04:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-06-2008 / 22:28:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

repositoryForModule: module directory: dir

    ^self repositoryForPackage: (module , ':' , dir)

    "Created: / 25-05-2009 / 19:48:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-08-2009 / 18:42:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 11-10-2011 / 11:12:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryForPackage: package

    ^self repositoryForPackage: package onlyFromCache: false

    "Created: / 25-05-2009 / 19:48:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-08-2009 / 18:42:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

repositoryForPackage: package onlyFromCache: aBoolean

    self enabled ifFalse:[^nil].
    ^self current repositoryForPackage: package onlyFromCache: aBoolean

    "Created: / 16-08-2009 / 18:41:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

repositoryUrlForPackage: package

    self enabled ifFalse:[^nil].
    ^self current repositoryUrlForPackage: package

    "Created: / 25-05-2009 / 19:48:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

reset

    self current reset.

    "Created: / 31-03-2008 / 10:55:10 / janfrog"
    "Modified: / 20-03-2009 / 10:44:31 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

workingCopyForPackage: package

    | repo |
    ^(repo := self repositoryForPackage: package)
        ifNil:[nil]
        ifNotNil:[repo workingCopy]

    "Created: / 13-08-2009 / 15:08:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!RepositoryManager class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!RepositoryManager methodsFor:'accessing'!

configurationForPackage: package

    ^self configurations
        detect: [:cfg|cfg matchesPackage: package]
        ifNone: [nil]

    "Created: / 03-10-2008 / 15:38:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

configurations
    configurations ifNil:
        [configurations := UserPreferences current svnConfigurations].
    ^configurations ? #()
 
    "Created: / 26-05-2008 / 10:47:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 03-10-2008 / 13:11:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

configurations: anObject
    configurations := anObject

    "Created: / 03-10-2008 / 13:10:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

repositories 

    ^repositories values collect:[:repo|repo value] thenSelect:[:repo|repo notNil].

    "Created: / 24-03-2010 / 22:24:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryForPackage:package 

    ^self repositoryForPackage:package onlyFromCache: false

    "Modified: / 16-08-2009 / 18:44:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

repositoryForPackage:package onlyFromCache: onlyFromCache 


    "There is no repository for no project, by definition"
    package = PackageId noProjectID ifTrue:[ ^nil ].

    ^onlyFromCache 
        ifTrue:
            [repositories at:package ifAbsent:[nil]]
        ifFalse:
            [repositories 
                at:package 
                ifAbsentPut:
                    (MessageSend 
                        receiver: self 
                        selector: #basicRepositoryForPackage: 
                        argument: package)]

    "Modified: / 01-04-2008 / 19:08:35 / janfrog"
    "Created: / 16-08-2009 / 18:43:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 13:07:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-04-2010 / 11:15:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repositoryUrlForPackage:package 
    | repo |

    repo := repositories at:package ifAbsent:[ nil ].
    repo ifNotNil:[ ^ repo url ].

    SVN::Configuration isLoaded ifFalse:[^nil]."JV: hack for loading issue"
    repo := SVN::Configuration current repositoryFor: package.
    repo ifNil:[^nil].
    repo exists ifFalse:[^nil].
    repo manager: self.                        
    ^ repo url

    "Modified: / 01-04-2008 / 19:08:35 / janfrog"
    "Created: / 25-05-2009 / 19:48:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-08-2009 / 16:56:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-06-2010 / 17:19:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

urlBase:aString 
    |repoConf|

    repoConf := self configurations 
                detect:[:conf | conf packagePattern = '*' ]
                ifNone:[
                    self configurations add:(RepositoryConfiguration new packagePattern:'*')
                ].
    repoConf urlPattern:aString , '/%p'

    "
        SVN::RepositoryManager current urlBase:
            'http://smalltalk.felk.cvut.cz/svn'"

    "Created: / 16-03-2008 / 12:09:21 / janfrog"
    "Modified: / 03-10-2008 / 13:10:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

workingCopyBase

    workingCopyBase ifNil:
        [WorkingCopyBase ~= nil ifTrue:[
            workingCopyBase := WorkingCopyBase
        ] ifFalse: [
            workingCopyBase := (Filename homeDirectory / '.smalltalk' / 'working-copy'
                                    / UUID genUUID printString) asString.
        ]].
    (Smalltalk packagePath last = workingCopyBase)
        ifFalse:
            [Smalltalk packagePath remove: workingCopyBase ifAbsent:[].
            Smalltalk packagePath addLast: workingCopyBase].

    ^ workingCopyBase

    "Created: / 16-03-2008 / 12:09:21 / janfrog"
    "Modified: / 10-04-2008 / 13:25:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-07-2011 / 20:24:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingCopyBase:aString
    workingCopyBase := aString.
    self changed:#workingCopyBase

    "Created: / 16-03-2008 / 12:09:21 / janfrog"
    "Modified: / 26-05-2008 / 10:34:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!RepositoryManager methodsFor:'accessing - private'!

workingCopyForPackage: package

    ^self 
        workingCopyForPackage: package
        in: (self workingCopyBase , '/' , (package asString copy replaceAll:$: with:$/))

    "Created: / 16-03-2008 / 12:09:02 / janfrog"
    "Modified: / 31-03-2008 / 12:58:44 / janfrog"
    "Modified: / 11-04-2008 / 10:48:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 10-04-2010 / 12:38:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

workingCopyForPackage: package in: directory

    ^WorkingCopy new path: directory

    "Modified: / 31-03-2008 / 12:58:44 / janfrog"
    "Modified: / 11-04-2008 / 10:48:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 10-04-2010 / 12:37:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RepositoryManager methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ baseUrl := nil.
    repositories := Cache new.
    Smalltalk addDependent: self.
    Smalltalk addExitBlock:(MessageSend receiver: self selector: #aboutToQuit).

    "/ super initialize.   -- commented since inherited method does nothing

    "Created: / 16-03-2008 / 11:53:21 / janfrog"
    "Modified: / 31-03-2008 / 10:54:28 / janfrog"
    "Modified: / 16-06-2009 / 12:39:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-12-2009 / 20:20:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reset

    repositories := Cache new.

    "Created: / 10-04-2008 / 12:41:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-12-2009 / 20:23:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resetConfigurations

    configurations := nil

    "Created: / 25-05-2009 / 18:59:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

resetForPackage: packageId

    repositories removeKey: packageId ifAbsent:[]

    "Created: / 08-04-2009 / 22:37:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!RepositoryManager methodsFor:'private'!

basicRepositoryForPackage:package 
    | repo |

    "There is no repository for no project, by definition"
    package = PackageId noProjectID ifTrue:[ ^nil ].
    "/Old Config Scheme
    "
    repo ifNotNil:[ ^ repo ].
    cfg := self configurationForPackage: package.
    cfg ifNotNil:
        [repo := (Repository new)
                    manager: self;
                    url:(cfg urlForPackage:package);
                    package:package].
    repo ifNil:[ ^ nil ].
    "
    "/New Config Scheme
        SVN::Configuration isLoaded ifFalse:[^nil]."JV: hack for loading issue"
    SVN::Configuration current isNil ifTrue:[^ nil].
    repo := SVN::Configuration current repositoryFor: package.
    repo isNil ifTrue:[^nil].
"/    repo exists ifFalse:[^nil].
    repo manager: self.                        
    ^ repo

    "Modified: / 01-04-2008 / 19:08:35 / janfrog"
    "Created: / 16-08-2009 / 18:43:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 13:07:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 23-08-2011 / 18:38:53 / cg"
    "Modified: / 17-08-2012 / 11:08:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RepositoryManager methodsFor:'queries'!

hasRepositoryForPackage: package

    ^(self repositoryForPackage: package) notNil

    "Created: / 31-03-2008 / 15:11:23 / janfrog"
! !

!RepositoryManager methodsFor:'updating'!

aboutToQuit

    "
     This is send by Smalltalk before the virtual machine
     terminates. If there is no image, removes working copy.
    "

    workingCopyBase isNil ifTrue: [^self].
    workingCopyBase asFilename exists ifFalse:[^self].

    ObjectMemory imageName  
        ifNil:
            ["Windows hack..."
            [workingCopyBase asFilename recursiveRemove]
                on:Smalltalk::Error do:
                    [Delay waitForMilliseconds: 20.
                    [workingCopyBase asFilename recursiveRemove]
                        on:Smalltalk::Error do:
                            [Delay waitForMilliseconds: 40.
                            [workingCopyBase asFilename recursiveRemove]
                                on:Smalltalk::Error do:["nothing"]]]]
        ifNotNil:
            [| imagesStream |
            [imagesStream := (workingCopyBase asFilename / 'images.txt') appendStream.
            imagesStream nextPutLine: ObjectMemory imageName printString]
                ensure:[imagesStream ifNotNil:[imagesStream close]]]

    "Created: / 16-06-2009 / 13:36:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-07-2009 / 13:54:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-09-2009 / 15:55:57 / Felix Madrid <fm@exept.de>"
!

class: class renamedFrom: oldName to: newName

    "Created: / 31-03-2008 / 11:06:11 / janfrog"
!

update: aspect with: param from: sender

    (aspect = #classRename)
        ifTrue:[self class: param first renamedFrom: param second to: param first fullName]

    "Created: / 31-03-2008 / 10:54:55 / janfrog"
! !

!RepositoryManager class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__RepositoryManager.st 384 2011-10-12 11:01:11Z vranyj1 §'
! !
