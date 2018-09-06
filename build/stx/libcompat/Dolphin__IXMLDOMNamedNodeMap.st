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
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__IXMLDOMNamedNodeMap.st,v 1.2 2011-10-01 11:08:52 vrany Exp $'
!

version_SVN
    ^ '§Id: Dolphin__IXMLDOMNamedNodeMap.st,v 1.1 2011/07/05 18:09:55 cg Exp §'
! !
