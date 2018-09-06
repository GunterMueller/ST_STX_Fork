"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Entity subclass:#GeneralEntity
	instanceVariableNames:'ndata'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Nodes'
!

GeneralEntity comment:'This class represents a general entity which is a parsed entity for use within the XML document content.

Instance Variables:
	ndata   <Notation>
'
!


!GeneralEntity methodsFor:'accessing'!

entityType

	^'generic'
!

ndata: aNotifierNameOrNil

	ndata := aNotifierNameOrNil
! !

!GeneralEntity methodsFor:'testing'!

isParsed

	^ndata == nil
! !

!GeneralEntity methodsFor:'validation'!

completeValidationAgainst: aParser

	ndata isNil
		ifFalse: [aParser dtd notationAt: ndata ifAbsent:
				[aParser invalid: ('Unparsed entity "<1s>" uses an undeclared notation "<2s>"'
						expandMacrosWith: name
						with: ndata)]]
! !

!GeneralEntity methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitGeneralEntity:self
! !

!GeneralEntity class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/GeneralEntity.st,v 1.8 2003-05-28 07:43:11 james Exp $'
! !
