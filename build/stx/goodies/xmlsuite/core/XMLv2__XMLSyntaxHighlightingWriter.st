"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

OldXMLWriter subclass:#XMLSyntaxHighlightingWriter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XML Writer'
!


!XMLSyntaxHighlightingWriter class methodsFor:'accessing - colors'!

attributeValueColor

    ^Color red:0 green:0 blue:100

    "Created: / 23-04-2005 / 17:08:21 / janfrog"
!

commentColor

    ^Color red:0 green:51 blue:0

    "Created: / 23-04-2005 / 17:08:21 / janfrog"
!

elementNameColor

    ^Color red:58 green:15 blue:58

    "Created: / 23-04-2005 / 17:08:21 / janfrog"
!

normalColor

    ^Color black

    "Created: / 23-04-2005 / 17:08:21 / janfrog"
!

piColor

    ^Color gray

    "Created: / 23-04-2005 / 17:08:21 / janfrog"
! !

!XMLSyntaxHighlightingWriter methodsFor:'accessing - colors'!

attributeValueColor
    ^ self class attributeValueColor

    "Created: / 23-04-2005 / 17:08:21 / janfrog"
!

commentColor
    ^ self class commentColor

    "Created: / 23-04-2005 / 17:08:21 / janfrog"
!

elementNameColor
    ^ self class elementNameColor

    "Created: / 23-04-2005 / 17:08:21 / janfrog"
!

normalColor
    ^ self class normalColor

    "Created: / 23-04-2005 / 17:08:21 / janfrog"
!

piColor
    ^ self class piColor

    "Created: / 23-04-2005 / 17:08:21 / janfrog"
! !

!XMLSyntaxHighlightingWriter methodsFor:'writing'!

nextPutAttributeName:qName

    stream emphasis:#bold.
    super nextPutAttributeName:qName.
    stream emphasis:nil.

    "Created: / 17-04-2005 / 13:44:29 / janfrog"
    "Modified: / 22-04-2005 / 22:47:14 / janfrog"
!

nextPutAttributeValue:aString

    stream 
        emphasis:#color->self attributeValueColor.
    super nextPutAttributeValue:aString.
    stream    
        emphasis:nil

    "Created: / 17-04-2005 / 13:44:29 / janfrog"
    "Modified: / 22-04-2005 / 22:45:26 / janfrog"
!

nextPutComment:aString

    stream 
        emphasis:(Array with:(#color->self commentColor) with:#italic).
    super nextPutComment:aString.
    stream    
        emphasis:nil

    "Created: / 17-04-2005 / 13:44:29 / janfrog"
    "Modified: / 23-04-2005 / 09:22:08 / janfrog"
!

nextPutElementPrefix:qName localName:anObject 
    stream
        emphasis:#color -> self elementNameColor;
        nextPutAll:qName;
        emphasis:nil

    "Created: / 18-10-2005 / 10:50:19 / janfrog"
!

nextPutPI:target data:data

    stream 
        emphasis:(Array with: #color->self piColor with:#italic).

    super nextPutPI:target data:data.

    stream emphasis:nil

    "Created: / 23-04-2005 / 09:20:48 / janfrog"
! !

!XMLSyntaxHighlightingWriter class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__XMLSyntaxHighlightingWriter.st,v 1.1.1.1 2005-11-01 22:07:10 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

