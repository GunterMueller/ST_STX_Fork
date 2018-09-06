"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Node subclass:#Attribute
	instanceVariableNames:'name value'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Nodes'
!

Attribute comment:'XML elements may have name-value pairs called attributes associated with them. This class instantiates an XML attribute.

Instance Variables:
	name    <XML.Node | XML.NodeTag>        tag name
	value   <Object>                                        tag value
'
!


!Attribute class methodsFor:'instance creation'!

name: nm value: val

	^self new name: nm value: val
! !

!Attribute methodsFor:'accessing'!

characterData

	^self value
!

characterDataDo:aBlock
    "/ left blank

    "Created: / 18-07-2011 / 15:24:50 / cg"
!

characterDataOnto:aStream
    ^ aStream nextPutAll:value
!

expandedName

	^name expandedName
!

key

	^name
!

tag

	^name
!

value

	^value
!

value: aValue

	value := aValue
!

xPath
    ^ parent xPath, '/@', self tag type printString
! !

!Attribute methodsFor:'comparing'!

= anXmlAttribute
    ^ self == anXmlAttribute
        or:[anXmlAttribute isAttribute 
            and:[name = anXmlAttribute key
            and:[value = anXmlAttribute value]]].
!

hash
    ^ name hash
! !

!Attribute methodsFor:'initialization'!

name: nm value: val

	name := nm isString
			ifTrue: [NodeTag new qualifier: '' ns: '' type: nm]
			ifFalse: [nm].
	value := val
!

tag: aTag

	name := aTag
! !

!Attribute methodsFor:'printing'!

prettyPrintColorizedOn: aStream
    self printColorizedOn: aStream

    "Created: / 24-07-2011 / 21:36:28 / cg"
!

prettyPrintOn: aStream
        self printCanonicalOn: aStream
!

printCanonicalOn: aStream

        aStream nextPutAll: self tag asString, '="'.
        self printCanonical: value ? '' on: aStream.
        aStream nextPutAll: '"'.
!

printColorizedOn: aStream
    |em|

    em := (Smalltalk at:#Text) 
                addEmphasis:UserPreferences current xmlAttributeEmphasis 
                to:(#color->UserPreferences current xmlAttributeColor).

    aStream emphasis:em.
    aStream nextPutAll: self tag asString.
    aStream emphasis:nil.
    aStream nextPutAll: '='.
    aStream emphasis:(UserPreferences current stringEmphasisAndColor).
    aStream nextPutAll: '"'.
    self printCanonical: value ? '' on: aStream.
    aStream nextPutAll: '"'.
    aStream emphasis:nil.

    "Created: / 17-02-2011 / 14:29:22 / cg"
!

printNoIndentOn: aStream endSpacing: endSpacingBlock spacing: spacingBlock

	aStream nextPutAll: self tag asString, '="'.
	self printCanonical: value on: aStream.
	aStream nextPutAll: '"'.
!

printOn: aStream

	self printCanonicalOn: aStream
!

simpleDescription

	^'@', self key
! !

!Attribute methodsFor:'testing'!

isAttribute

	^true
!

isLike: aNode

	^self class == aNode class
		and: [self tag isLike: aNode tag]
! !

!Attribute methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAttribute:self
! !

!Attribute class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/Attribute.st,v 1.19 2017-01-03 13:57:41 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/Attribute.st,v 1.19 2017-01-03 13:57:41 stefan Exp $'
! !

