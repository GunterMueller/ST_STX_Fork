"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

XMLWriter subclass:#IndentingXMLWriter
	instanceVariableNames:'indentLevel'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XML Writer'
!


!IndentingXMLWriter class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 23-12-2005 / 21:03:15 / janfrog"
! !

!IndentingXMLWriter methodsFor:'SAX2 events'!

characters:aString 
    self nextPutIndentedString:aString

    "Created: / 27-11-2005 / 11:52:48 / janfrog"
!

endElement:localName namespace:namespace prefix:prefix 

    indentLevel := indentLevel - 1.
    self nextPutIndent.
    super endElement:localName namespace:namespace prefix:prefix.
    self cr.

    "Created: / 27-11-2005 / 11:47:05 / janfrog"
!

nextPutIndentedString:aString 
    aString asStringCollection do:[:line | 
        self
            nextPutIndent;
            nextPutString:line;
            cr.
    ]

    "Created: / 27-11-2005 / 11:56:50 / janfrog"
    "Modified: / 28-11-2005 / 16:35:58 / janfrog"
!

processingInstruction:target data:data

    self nextPutIndent.
    super processingInstruction:target data:data

    "Created: / 27-11-2005 / 11:54:33 / janfrog"
!

startDocument

    indentLevel := 0.
    super startDocument.
    self cr.

    "Created: / 27-11-2005 / 11:42:03 / janfrog"
!

startElement:localName namespace:namespace prefix:prefix attributes:attributes

    self nextPutIndent.
    super startElement:localName namespace:namespace prefix:prefix attributes:attributes.
    self cr.
    indentLevel := indentLevel + 1.

    "Created: / 27-11-2005 / 11:45:19 / janfrog"
! !

!IndentingXMLWriter methodsFor:'SAX2 interface - extensions'!

cDataSection:aString

    self nextPutIndent; nextPutAll:'<!![CDATA['; cr.
    indentLevel := indentLevel + 1.
    self nextPutIndentedString: aString.
    indentLevel := indentLevel - 1.
    self nextPutIndent; nextPutAll:']]>'; cr.

    "Created: / 28-12-2005 / 16:18:04 / janfrog"
!

comment:aString

    self nextPutIndent; nextPutAll:'<!!--'; cr.
    indentLevel := indentLevel + 1.
    self nextPutIndentedString: aString.
    indentLevel := indentLevel - 1.
    self nextPutIndent; nextPutAll:'-->'; cr.

    "Created: / 27-11-2005 / 11:57:59 / janfrog"
! !

!IndentingXMLWriter methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)

    "/ super initialize.   -- commented since inherited method does nothing
    indentLevel := 0

    "Created: / 23-12-2005 / 21:03:15 / janfrog"
! !

!IndentingXMLWriter methodsFor:'writing'!

nextPutIndent

    self next:(indentLevel * 2) put: Character space

    "Created: / 27-11-2005 / 11:44:39 / janfrog"
! !

!IndentingXMLWriter class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__IndentingXMLWriter.st,v 1.4 2005-12-28 16:16:23 vranyj1 Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

