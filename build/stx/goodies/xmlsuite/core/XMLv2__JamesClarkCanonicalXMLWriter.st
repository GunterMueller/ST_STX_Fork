"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

XMLWriter subclass:#JamesClarkCanonicalXMLWriter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XML Writer'
!


!JamesClarkCanonicalXMLWriter methodsFor:'SAX2 events'!

comment:aString

    "nothing to do"

    "Created: / 21-10-2005 / 15:14:02 / janfrog"
!

endDocument

    stream cr

    "Created: / 20-05-2006 / 13:17:48 / janfrog"
!

startDocument

    "no prolog in JClark's Canonical XML"

    "Created: / 21-10-2005 / 15:14:29 / janfrog"
! !

!JamesClarkCanonicalXMLWriter methodsFor:'streaming'!

nextPutString:aString

    stream nextPutAll:aString asJamesClarkCanonicalXMLEscapedString

    "Created: / 21-10-2005 / 15:10:40 / janfrog"
! !

!JamesClarkCanonicalXMLWriter methodsFor:'writing'!

nextPutAttributes:attributes implicitNamespace:defaultNS 
    super nextPutAttributes:(attributes 
                asSortedCollection:[:a1 :a2 | a1 qualifiedName < a2 qualifiedName ])
        implicitNamespace:defaultNS

    "Modified: / 09-04-2007 / 11:20:13 / janfrog"
! !

!JamesClarkCanonicalXMLWriter class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__JamesClarkCanonicalXMLWriter.st,v 1.3 2007-04-10 08:32:52 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

