"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#XQueryConstructedItem
	instanceVariableNames:'attributes baseUri children documentUri nodeKind nodeName parent
		stringValue typeName typedValue'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Sequence'
!

!XQueryConstructedItem class methodsFor:'documentation'!

documentation
"
    This is a data storage element for the constructed xquery items.
    This class is connected with ConstructedKindDocumentAdaptor

    TODO: the class should be dividet into the atomicValueItem and
        nodeItem.

    [author:]

    [instance variables:    
        itemType - type of the item (e.g. node and its subtypes or anyAtomicType for
                    atomic values.
        itemValue - value of the item
        itemValueType - type of the item value (according to the XQuery Data Model)
    ]

    [class variables:]

    [see also: ConstructedKindDocumentAdaptor]
        

"
! !

!XQueryConstructedItem methodsFor:'xdm properties'!

attributes
    ^ attributes
!

baseUri
    ^ baseUri
!

children
    ^ children
!

documentUri
    ^ documentUri
!

nodeKind
    ^ nodeKind
!

nodeName
    ^ nodeName
!

parent
    ^ parent
!

stringValue
    ^ stringValue
!

typeName
    ^ typeName
!

typedValue
    ^ typedValue
! !

!XQueryConstructedItem methodsFor:'xdm properties setters'!

attributes:something
    attributes := something.
!

baseUri:something
    baseUri := something.
!

children:something
    children := something.
!

documentUri:something
    documentUri := something.
!

nodeKind:aStringOrSymbolSymbol
    self assert: aStringOrSymbolSymbol isString.
    nodeKind := aStringOrSymbolSymbol asSymbol.

    "Modified: / 02-10-2009 / 20:02:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 18-03-2010 / 10:53:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nodeName:something
    nodeName := something.
!

parent:something
    parent := something.
!

stringValue:something
    stringValue := something.
!

typeName:something
    typeName := something.
!

typedValue:something
    typedValue := something.
! !

!XQueryConstructedItem class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
