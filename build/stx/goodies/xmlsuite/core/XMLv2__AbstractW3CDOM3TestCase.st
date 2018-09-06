"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

TestCase subclass:#AbstractW3CDOM3TestCase
	instanceVariableNames:'lastException'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests'
!


!AbstractW3CDOM3TestCase class methodsFor:'accessing'!

defaultTestFilesDirectory
    ^ (Smalltalk getPackageDirectoryForPackage:self package) 
        construct:'resources/tests/dom3/' , self module , '/files'

    "Modified: / 11-08-2005 / 14:22:56 / janfrog"
    "Created: / 17-08-2005 / 09:13:34 / masca"
! !

!AbstractW3CDOM3TestCase class methodsFor:'defaults'!

module

    ^self subclassResponsibility

    "Created: / 11-08-2005 / 14:22:56 / janfrog"
! !

!AbstractW3CDOM3TestCase class methodsFor:'testing'!

isAbstract

    ^self == AbstractW3CDOM3TestCase

    "Created: / 11-08-2005 / 10:21:32 / janfrog"
    "Modified: / 11-08-2005 / 14:22:55 / janfrog"
! !

!AbstractW3CDOM3TestCase methodsFor:'accessing'!

xmlFilenameFor:aString 
    |filename|

    filename := self class defaultTestFilesDirectory 
                construct:aString , '.xml'.
    self assert:filename exists description:'Test file does not exist!!'.
    ^ filename

    "Created: / 11-08-2005 / 14:23:14 / janfrog"
    "Modified: / 17-08-2005 / 09:13:34 / masca"
! !

!AbstractW3CDOM3TestCase methodsFor:'private'!

executeShould: aBlock inScopeOf: anExceptionalEvent 
       [aBlock value]
                on: anExceptionalEvent
                do: [:ex | lastException := ex. ^true].

        ^false.

    "Created: / 15-11-2005 / 14:16:54 / janfrog"
! !

!AbstractW3CDOM3TestCase class methodsFor:'documentation'!

version
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

