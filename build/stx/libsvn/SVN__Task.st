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

Object subclass:#Task
	instanceVariableNames:'package classes workingCopy'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Tasks'
!

!Task class methodsFor:'documentation'!

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

!Task class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!Task methodsFor:'accessing'!

branch

    ^self workingCopy branch

    "Created: / 23-03-2009 / 17:16:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

classes
    ^ classes
!

classes:aCollection"<Collection[Class]>"

    self 
        assert: (aCollection allSatisfy: [:e|e isBehavior])
        message: 'All elements should be classes'.

    self
        assert: (aCollection allSatisfy: [:e|e package = package])
        message: 'All classes should belongs to my package (' , package , ')'.

    classes := aCollection.

    "Modified: / 16-06-2009 / 20:56:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

package
    ^ package
!

package:aSymbol
    package := aSymbol.
!

repository

    ^self workingCopy repository

    "Created: / 23-03-2009 / 11:24:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

workingCopy

    workingCopy ifNil:
        [workingCopy := 
            (SVN::RepositoryManager repositoryForPackage: self package)
                workingCopy].
    ^workingCopy

    "Created: / 23-03-2009 / 11:18:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

workingCopy:aWorkingCopy
    workingCopy := aWorkingCopy.
    package := aWorkingCopy package

    "Modified: / 23-03-2009 / 11:44:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Task methodsFor:'executing'!

do
    "
        Perform whole task
    "            

    ^ self subclassResponsibility

    "Modified: / 23-03-2009 / 11:16:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Task methodsFor:'executing - private'!

do: aBlock

    ^SVN::CompatModeQuery
        answer: false
        do: aBlock

    "Created: / 15-07-2009 / 20:07:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

doCompileSvnRepositoryUrlStringMethod
    |pkgDef revNr|

    ActivityNotification notify:'Compiling #svnRepositoryUrlString method'.
    pkgDef := self workingCopy packageDefinition.
    (pkgDef theMetaclass includesSelector:#svnRepositoryUrlString) not
            ifTrue:[
                pkgDef theMetaclass compile:(pkgDef svnRepositoryUrlString_code)
                    classified:'description - svn'.
                (pkgDef theMetaclass compiledMethodAt:#svnRepositoryUrlString) 
                    setPackage:self package asSymbol
            ].

    "Created: / 08-04-2011 / 15:58:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doCompileSvnRevisionNrMethod:compileRevision 
    |pkgDef revNr|

    ActivityNotification notify:'Compiling #svnRevisionNr method'.
    pkgDef := self workingCopy packageDefinition.
    revNr := compileRevision ifTrue:[
                pkgDef svnRevision number
            ] ifFalse:[ nil ].
    (revNr notNil 
        or:[ (pkgDef theMetaclass includesSelector:#svnRevisionNr) not ]) 
            ifTrue:[
                pkgDef theMetaclass compile:(pkgDef svnRevisionNr_code:revNr)
                    classified:'description - svn'.
                (pkgDef theMetaclass compiledMethodAt:#svnRevisionNr) 
                    setPackage:self package asSymbol
            ].

    "Created: / 16-06-2009 / 12:16:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Task methodsFor:'notification'!

notify: aString

    self notify: aString progress: nil

    "Created: / 29-05-2009 / 16:51:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

notify: aString progress: aNumberOrNil

    aNumberOrNil 
        ifNil:[ActivityNotification notify: aString]
        ifNotNil:[ProgressNotification notify: aString progress: aNumberOrNil]

    "Created: / 29-05-2009 / 16:51:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Task class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__Task.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
