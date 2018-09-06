"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

Object subclass:#XPathDocumentAdaptorFactory
	instanceVariableNames:''
	classVariableNames:'adaptors'
	poolDictionaries:''
	category:'XML Suite-XPath-Adaptors'
!


!XPathDocumentAdaptorFactory class methodsFor:'instance creation'!

documentAdaptorFor:aDocument 
    "use an XML parser to parse a source file and then pass the result as aDocument"

    | adaptorClass |
    
    adaptorClass := self allAdaptors 
        at: (aDocument class)
        ifAbsent:[self error:'No adaptor class for document ', aDocument class name].

    ^ adaptorClass new document:aDocument.

    "Created: / 13-10-2006 / 18:55:09 / janfrog"
    "Modified: / 13-10-2006 / 21:09:01 / janfrog"
!

new
        self error:'Should not be queried for instances'.
! !

!XPathDocumentAdaptorFactory class methodsFor:'accessing'!

allAdaptors

    | allAdaptors |

    allAdaptors := Dictionary new.
    XPathDocumentAdaptor allSubclasses select:[:cls|cls isAbstract not] thenDo:
        [:cls|allAdaptors at:cls documentClass put:cls].
    ^allAdaptors

    "
        XMLv2::XPathDocumentAdaptorFactory allAdaptors

    "

    "Created: / 13-10-2006 / 21:07:00 / janfrog"
    "Modified: / 15-12-2006 / 08:04:10 / janfrog"
! !

!XPathDocumentAdaptorFactory class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathDocumentAdaptorFactory.st,v 1.3 2006-12-15 11:07:11 vranyj1 Exp $'
! !
