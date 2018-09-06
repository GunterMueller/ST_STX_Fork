"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

IndentingXMLWriter subclass:#IndentingAndHighlightingXMLWriter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XML Writer'
!


!IndentingAndHighlightingXMLWriter class methodsFor:'accessing - colors'!

attributeValueColor

    ^Color red:0 green:0 blue:100

    "Created: / 21-12-2005 / 16:54:14 / janfrog"
!

commentColor

    ^Color red:0 green:51 blue:0

    "Created: / 21-12-2005 / 16:54:14 / janfrog"
!

elementNameColor

    ^Color red:58 green:15 blue:58

    "Created: / 21-12-2005 / 16:54:14 / janfrog"
!

normalColor

    ^Color black

    "Created: / 21-12-2005 / 16:54:14 / janfrog"
!

piColor

    ^Color gray

    "Created: / 21-12-2005 / 16:54:14 / janfrog"
! !

!IndentingAndHighlightingXMLWriter methodsFor:'SAX2 events'!

attributeValueColor
    ^ self class attributeValueColor

    "Created: / 21-12-2005 / 16:54:04 / janfrog"
!

comment:aString

    self emphasis:(Array with:(#color->self commentColor) with:#italic).
    super comment:aString.
    self emphasis:nil.

    "Created: / 21-12-2005 / 16:57:51 / janfrog"
!

commentColor
    ^ self class commentColor

    "Created: / 21-12-2005 / 16:54:04 / janfrog"
!

elementNameColor
    ^ self class elementNameColor

    "Created: / 21-12-2005 / 16:54:04 / janfrog"
!

emphasis: anObject

    stream emphasis: anObject

    "Created: / 21-12-2005 / 16:54:54 / janfrog"
!

nextPutAttribute:anAttr implicitNamespace:implicitNS 
    self
        space;
        emphasis:#bold;
        nextPutAll:
            (anAttr namespaceURI = implicitNS
                ifTrue:[anAttr localName ]
                ifFalse:[anAttr nodeName]);
        emphasis:nil;
        nextPut:$=;
        emphasis:#color -> self attributeValueColor;
        nextPut:$";
        nextPutString:(anAttr nodeValue);
        emphasis:nil;
        nextPut:$"

    "Created: / 09-04-2007 / 11:19:59 / janfrog"
!

nextPutPrefix:prefix localName:localName

    self emphasis:#color -> self elementNameColor.
    super nextPutPrefix:prefix localName:localName.
    self emphasis:#nil.

    "Modified: / 21-12-2005 / 16:56:51 / janfrog"
!

nextPutProlog

    self emphasis:(Array with: #color->self piColor with:#italic).
    super nextPutProlog.
    self emphasis:nil.

    "Created: / 21-12-2005 / 16:51:26 / janfrog"
    "Modified: / 21-12-2005 / 17:53:20 / janfrog"
!

normalColor
    ^ self class normalColor

    "Created: / 21-12-2005 / 16:54:04 / janfrog"
!

piColor
    ^ self class piColor

    "Created: / 21-12-2005 / 16:54:04 / janfrog"
!

processingInstruction:target data:data

    self emphasis:(Array with:(#color->self piColor) with:#italic).
    self processingInstruction:target data:data.
    self emphasis:nil.

    "Created: / 21-12-2005 / 16:57:51 / janfrog"
! !

!IndentingAndHighlightingXMLWriter class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__IndentingAndHighlightingXMLWriter.st,v 1.2 2007-04-10 08:33:08 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
