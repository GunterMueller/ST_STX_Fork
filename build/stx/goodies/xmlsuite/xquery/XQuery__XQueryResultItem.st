"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#XQueryResultItem
	instanceVariableNames:'dataContextItem cachedDocumentFragment'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Result set'
!


!XQueryResultItem class methodsFor:'instance creation'!

for: item

    ^self new setDataContextItem: item

    "Created: / 12-12-2006 / 11:24:12 / janfrog"
! !

!XQueryResultItem methodsFor:'converting'!

asDocumentFragment

    cachedDocumentFragment 
        ifNil:[cachedDocumentFragment := dataContextItem asDocumentFragment].
    ^cachedDocumentFragment

    "Created: / 12-12-2006 / 10:58:40 / janfrog"
!

asDocumentFragmentWithoutComment

    ^ self asDocumentFragment.

    "Created: / 11-04-2009 / 12:50:33 / Martin Plicka <plickm1@fel.cvut.cz>"
!

asString

    ^dataContextItem asString.

    "Created: / 18-04-2009 / 14:37:39 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryResultItem methodsFor:'initialization & release'!

releaseResources

    cachedDocumentFragment := nil.
    dataContextItem releaseResources

    "Created: / 12-12-2006 / 10:57:53 / janfrog"
!

setDataContextItem: aDataContextItem

    dataContextItem := aDataContextItem.
    cachedDocumentFragment := nil

    "Created: / 12-12-2006 / 10:56:53 / janfrog"
! !

!XQueryResultItem methodsFor:'printing & storing'!

xmlPrintOn:aStream 
    ^ dataContextItem xmlPrintOn:aStream

    "Created: / 25-03-2009 / 12:02:14 / Martin Plicka <plickm1@fel.cvut.cz>"
! !

!XQueryResultItem class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
