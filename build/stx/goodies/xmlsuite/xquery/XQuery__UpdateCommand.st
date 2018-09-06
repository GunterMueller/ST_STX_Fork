"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#UpdateCommand
	instanceVariableNames:'sourceSequence targetSequence'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Update Facility'
!


!UpdateCommand class methodsFor:'priorities'!

priority

self subclassResponsibility
! !

!UpdateCommand methodsFor:'accessing'!

setXQIinAdaptor: xqueryInt

    (targetSequence first) documentAdaptor xQueryInterpreter:(xqueryInt clone).

    "Created: / 07-03-2012 / 10:50:29 / Adam Senk <senkadam@gmail.com>"
!

sourceSequence
    ^ sourceSequence

    "Modified: / 02-12-2009 / 14:36:12 / heverma1 <heverma1@fel.cvut.cz>"
    "Modified: / 17-04-2010 / 11:39:04 / Martin Hevera <>"
!

sourceSequence:anXQuerySequence
    "self checkSourceSequence: anXQuerySequence."
    sourceSequence := anXQuerySequence.

    "Modified: / 02-12-2009 / 14:39:46 / heverma1 <heverma1@fel.cvut.cz>"
    "Modified: / 18-04-2010 / 22:12:13 / Martin Hevera <>"
    "Modified: / 13-02-2012 / 19:39:28 / Adam Senk <senkadam@gmail.com>"
!

targetSequence
    ^ targetSequence

    "Modified: / 02-12-2009 / 14:37:09 / heverma1 <heverma1@fel.cvut.cz>"
    "Modified: / 17-04-2010 / 11:39:53 / Martin Hevera <>"
!

targetSequence:anXQuerySequence
    "self checkTargetSequence: anXQuerySequence."
    targetSequence := anXQuerySequence.

    "Modified: / 02-12-2009 / 14:38:49 / heverma1 <heverma1@fel.cvut.cz>"
    "Modified: / 18-04-2010 / 22:12:44 / Martin Hevera <>"
    "Modified: / 13-02-2012 / 19:38:55 / Adam Senk <senkadam@gmail.com>"
! !

!UpdateCommand methodsFor:'checking'!

isEmptyCommand
   ^false.

    "Created: / 25-03-2012 / 15:10:20 / Adam Senk <senkadam@gmail.com>"
! !

!UpdateCommand methodsFor:'checks'!

assert: aBlockOrBoolean description: aString

    aBlockOrBoolean value ifFalse:
        [XQueryInterpreterError raiseErrorString:'err:TBD - ', aString]
!

checkSourceSequence:anXQUerySequence

    self subclassResponsibility
!

checkTargetSequence:anXQUerySequence

    self subclassResponsibility
! !

!UpdateCommand methodsFor:'enumerating'!

do: aBlock

        aBlock value: self
! !

!UpdateCommand methodsFor:'executing'!

execute

    ^self subclassResponsibility
! !

!UpdateCommand methodsFor:'flattening'!

flatten
!

flattenOn: stream

        stream nextPut: self
! !

!UpdateCommand methodsFor:'merging'!

mergeWith: anotherCommand

        ^CompositeCommand
                with:self
                with:anotherCommand
! !

!UpdateCommand methodsFor:'priorities'!

< anotherCommand

  self priority < anotherCommand priority
!

<= anotherCommand

  self priority <= anotherCommand priority
!

> anotherCommand

  self priority > anotherCommand priority
!

>= anotherCommand

  self priority >= anotherCommand priority
!

priority

        ^self class priority
! !

!UpdateCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
