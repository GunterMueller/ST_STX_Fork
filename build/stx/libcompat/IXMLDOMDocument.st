"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

Object subclass:#IXMLDOMDocument
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!


!IXMLDOMDocument class methodsFor:'instance creation'!

newEmpty
	"When creating a new instance of the receiver we'd like it initialized to include the standard
		<?xml version='1.0' ?> processing instruction.
	But this can cause problems loading a string with a different encoding"

	#swAdded.
	^super new 
! !

!IXMLDOMDocument class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/IXMLDOMDocument.st,v 1.1 2002-11-18 20:10:29 cg Exp $'
! !
