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
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__IXMLDOMDocument.st,v 1.2 2011-10-01 11:00:25 vrany Exp $'
!

version_SVN
    ^ '§Id: Dolphin__IXMLDOMDocument.st,v 1.1 2011/07/05 18:09:55 cg Exp §'
! !
