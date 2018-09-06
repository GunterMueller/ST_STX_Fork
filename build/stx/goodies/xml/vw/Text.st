"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Node subclass:#Text
	instanceVariableNames:'text stripped'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Nodes'
!

!Text class methodsFor:'documentation'!

documentation
"
    This class represents an XML textual object,
    i.e. a sequence of legal characters as defined in the XML 1.0 specification
    and may represent markup or character data.

    Instance Variables:
            text    <CharacterArray | nil>
            stripped        <Boolean>
"
! !

!Text class methodsFor:'instance creation'!

text: aString

	^self new text: aString
! !

!Text methodsFor:'accessing'!

characterData

	^self text
!

characterDataDo:aBlock
    aBlock value:self text

    "Created: / 18-07-2011 / 15:25:04 / cg"
!

characterDataOnto: str

	str nextPutAll: self text
!

description

	^'text'
!

string
    ^ text

    "Created: / 15-03-2018 / 16:31:42 / mawalch"
!

strip: aBoolean

	stripped := aBoolean.
!

text

	^text
!

text: aText
    text := aText.
    stripped isNil ifTrue: [stripped := false].
!

xPath
    ^ parent xPath, '/text()'
! !

!Text methodsFor:'comparing'!

= anXmlText
    ^ anXmlText isText
        and:[text withoutSeparators = anXmlText asString withoutSeparators].
!

hash
    ^ text withoutSeparators hash
! !

!Text methodsFor:'converting'!

asString
    ^ text
! !

!Text methodsFor:'printing'!

prettyPrintOn: aStream depth: indent
    self printOn:aStream.

    "Modified: / 17-02-2011 / 14:45:11 / cg"
!

printCanonicalOn: aStream
    text isEmptyOrNil ifTrue: [^self].
    self isStripped ifFalse: [
        self printCanonical:text withEscapedLineFeeds:false on:aStream.
    ]
!

printHTMLOn: aStream

	text == nil ifTrue: [^self].
	self isStripped
		ifFalse: [self printCanonical: text on: aStream.]
!

printNoIndentOn: aStream endSpacing: endSpacingBlock spacing: spacingBlock

	text == nil ifTrue: [^self].
	self isStripped
		ifFalse: [aStream nextPutAll: text]
!

printOn: aStream
    text isNil ifTrue:[
        aStream nextPutAll:'&nil;'.
        ^ self.
    ].
    true "text size <= 80" ifTrue:[
        self printCanonicalOn:aStream.
    ] ifFalse:[
        aStream
            nextPutAll:'<!![CDATA[';
            nextPutAll:text;
            nextPutAll:']]>'.
    ].
! !

!Text methodsFor:'testing'!

isBlankText

	^(text contains: [:i | i isSeparator not]) not
!

isContent

	^true
!

isStripped

	^stripped
!

isText

	^true
! !

!Text methodsFor:'visiting'!

acceptVisitor:aVisitor
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitText:self
! !

!Text class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/Text.st,v 1.15 2018-03-15 15:36:47 mawalch Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/Text.st,v 1.15 2018-03-15 15:36:47 mawalch Exp $'
! !

