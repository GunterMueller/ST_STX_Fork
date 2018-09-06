"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

Object subclass:#IXMLDOMNamedNodeMap
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!


!IXMLDOMNamedNodeMap methodsFor:'printing'!

printOn: aStream
	#swAdded.
	aStream nextPutAll: self class name asString
! !

!IXMLDOMNamedNodeMap class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/IXMLDOMNamedNodeMap.st,v 1.1 2002-11-18 20:11:53 cg Exp $'
! !
