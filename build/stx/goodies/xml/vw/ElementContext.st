"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Object subclass:#ElementContext
	instanceVariableNames:'tag namespaces'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Parsing'
!

ElementContext comment:'This class includes some functionality to support XML namespaces. XML namespaces provide a simple method for qualifying element and attribute names used in XML documents  It stands as a proxy for an element when the element cannot yet be created, or when the element will never be created, but where information about the element must be recorded while processing its content.

Instance Variables:
	tag     <XML.NodeTag>
	namespaces      <Dictionary>
'
!


!ElementContext methodsFor:'accessing'!

namespaces

	namespaces == nil ifTrue: [namespaces := Dictionary new].
	^namespaces
!

namespaces:something
    namespaces := something.
!

tag

	^tag
!

tag: aTag

	tag := aTag isString
			ifTrue: [NodeTag new qualifier: '' ns: '' type: aTag]
			ifFalse: [aTag].
! !

!ElementContext methodsFor:'namespaces'!

defineDefaultNamespace: attribute

	self namespaces at: '' put: attribute value
!

defineNamespace: attribute

	(#('xmlns' 'xml') includes: attribute tag type)
		ifTrue: [self error: ('It is illegal to redefine the qualifier "<1s>".' expandMacrosWith: attribute tag type)].
	attribute value isEmpty ifTrue: [XMLParser invalid: 'It is not permitted to have an empty URI as a namespace name'].
	self namespaces at: attribute tag type put: attribute value
!

findNamespace: ns

	^namespaces isNil
		ifTrue: [nil]
		ifFalse: [namespaces at: ns ifAbsent: [nil]]
! !

!ElementContext methodsFor:'printing'!

printOn:aStream
       tag printOn:aStream
! !

!ElementContext methodsFor:'testing'!

definesNamespaces

        ^ namespaces notEmptyOrNil
! !

!ElementContext class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/ElementContext.st,v 1.10 2009-11-07 02:23:45 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/ElementContext.st,v 1.10 2009-11-07 02:23:45 cg Exp $'
! !
