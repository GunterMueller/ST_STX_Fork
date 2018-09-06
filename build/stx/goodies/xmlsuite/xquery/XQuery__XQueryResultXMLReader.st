"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XDMXMLReader variableSubclass:#XQueryResultXMLReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Result set'
!


!XQueryResultXMLReader methodsFor:'accessing'!

visitText: node

    | data |
    data := (node dmStringValue).

    (data allSatisfy:[:c|c isXMLWhiteSpace]) ifFalse:
        [contentHandler characters: data]

    "Created: / 02-05-2009 / 20:55:21 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 29-09-2009 / 13:18:25 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryResultXMLReader methodsFor:'initialization'!

initialize
    super initialize.
    self initializeNamespaces.

    "Created: / 25-07-2009 / 14:14:21 / Jan Kurs <kursj1@fel.cvut.cz>"
!

initializeNamespaces

    namespacePrefixMapping := Dictionary new
        at:'' put: '';
        at:'http://www.w3.org/TR/xpath-datamodel' put: 'dm';
        "Taken from XQuery specification section 4.12"
        at:'http://www.w3.org/XML/1998/namespace' put: 'xml';
        at:'http://www.w3.org/2000/xmlns/' put: 'xmlns';
        at:'http://www.w3.org/2001/XMLSchema' put: 'xs';
        at:'http://www.w3.org/2001/XMLSchema-instance' put: 'xsi';
        at:'http://www.w3.org/2005/xpath-functions' put: 'fn';
        at:'http://www.w3.org/2005/xquery-local-functions' put:'local';
        yourself

    "Created: / 25-07-2009 / 14:06:16 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 18-09-2009 / 16:00:37 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryResultXMLReader methodsFor:'visiting'!

visitDocument:node
    super visitDocument: node.
    self initializeNamespaces.

    "Created: / 25-07-2009 / 14:07:45 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitDocumentFragment:node
    super visitDocumentFragment: node.
    self initializeNamespaces.

    "Created: / 25-07-2009 / 14:08:16 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryResultXMLReader class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
