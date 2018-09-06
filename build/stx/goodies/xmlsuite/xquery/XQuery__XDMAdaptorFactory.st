"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#XDMAdaptorFactory
	instanceVariableNames:''
	classVariableNames:'adaptors'
	poolDictionaries:''
	category:'XQuery-XDM'
!


!XDMAdaptorFactory class methodsFor:'instance creation'!

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

!XDMAdaptorFactory class methodsFor:'accessing'!

allAdaptors

    | allAdaptors |

    allAdaptors := Dictionary new.
    XQuery::XDMAdaptor allSubclasses select:[:cls|cls isAbstract not] thenDo:
        [:cls|allAdaptors at:cls documentClass put:cls].
    ^allAdaptors

    "
        XMLv2::XDMAdaptorFactory allAdaptors

    "

    "Created: / 13-10-2006 / 21:07:00 / janfrog"
    "Modified: / 15-12-2006 / 08:04:10 / janfrog"
    "Modified: / 27-10-2009 / 17:08:14 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 28-01-2010 / 10:48:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XDMAdaptorFactory class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
