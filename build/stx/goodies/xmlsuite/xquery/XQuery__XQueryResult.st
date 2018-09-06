"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Array variableSubclass:#XQueryResult
	instanceVariableNames:'queryString queryTime'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Result set'
!


!XQueryResult methodsFor:'accessing'!

at:idx

    ^(super at: idx) asDocumentFragment

    "Created: / 12-12-2006 / 11:21:44 / janfrog"
!

at: idx put: val

    super at:idx put:(XQueryResultItem for: val)

    "Created: / 12-12-2006 / 11:21:00 / janfrog"
!

description
    |s|

    s := (UnicodeString new:30) writeStream.
    s
        cr;
        nextPutAll:'XQuery result (';
        nextPutAll:self size printString;
        nextPutAll:' items):';
        cr;
        nextPutAll:'Query took ';
        nextPutAll:(self queryTime ? 'almost no time') printString;
        cr.
     "XQueryInterpreter indexClassToUse isNil ifFalse:[
     s
     nextPutAll:'(with index ' , XQueryInterpreter indexClassToUse printString
     , ')'.
     ] ifTrue:[
     s nextPutAll:'(without index)'.
     ]."
    s cr.
    self queryString asStringCollection do:[:line | 
        s
            nextPutAll:line;
            cr
    ].
    ^ s contents

    "Created: / 12-12-2006 / 12:40:37 / janfrog"
    "Modified: / 08-11-2007 / 00:30:25 / beyboy"
    "Modified: / 21-11-2007 / 15:50:10 / janfrog"
!

queryString
    ^ queryString ? 'Query string not available'

    "Created: / 12-12-2006 / 12:41:12 / janfrog"
!

queryTime
    ^ queryTime ifNil:[ -1000 ]

    "Created: / 21-11-2007 / 15:44:11 / janfrog"
!

queryTime:aTime 
    queryTime := aTime

    "Created: / 21-11-2007 / 15:44:01 / janfrog"
! !

!XQueryResult methodsFor:'converting'!

asDocument

    |document|

    document := self asDocumentWithoutComment.
    (document childNodes size = 0)
        ifTrue:[document appendChild:(XMLv2::Comment new data:self description)]
        ifFalse:[document insert:(XMLv2::Comment new data:self description) before:document childNodes first].
    ^document

    "Created: / 12-12-2006 / 11:31:33 / janfrog"
    "Modified: / 20-09-2007 / 10:57:42 / janfrog"
!

asDocumentFragment

    |document|

    document := self asDocumentFragmentWithoutComment.
    (document childNodes size = 0)
        ifTrue:[document appendChild:(XMLv2::Comment new data:self description)]
        ifFalse:[document insert:(XMLv2::Comment new data:self description) before:document childNodes first].
    ^document

    "Created: / 12-12-2006 / 11:31:33 / janfrog"
    "Modified: / 20-09-2007 / 10:57:42 / janfrog"
!

asDocumentFragmentWithoutComment

    ^(self size == 1 and:[self first isDocument])
        ifTrue:[self primAsDocument]
        ifFalse:[self primAsDocumentFragment]

    "Created: / 10-08-2007 / 09:09:29 / janfrog"
!

asDocumentWithoutComment

    (self size == 1 and:[self first isDocument]) ifTrue:[^self primAsDocument].
    (self size == 1 and:[self first isDocumentFragment]) ifTrue:[^self primAsDocumentFromSingleElement].

    self error:'Cannot convert to document'

    "Created: / 10-08-2007 / 09:09:29 / janfrog"
!

asString
    ^self primAsString

    "Created: / 18-04-2009 / 13:40:32 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primAsDocument

    ^self first.

    "Created: / 12-12-2006 / 14:03:48 / janfrog"
    "Modified: / 10-08-2007 / 09:09:12 / janfrog"
!

primAsDocumentFragment

    |documentFragment|

    documentFragment := XMLv2::XMLSuiteDOM3Implementation 
                createDocumentFragment.
    self do:[:item | 
        documentFragment appendChild:item asDocumentFragment
    ].
    ^ documentFragment

    "Created: / 12-12-2006 / 14:03:33 / janfrog"
    "Modified: / 10-08-2007 / 09:08:11 / janfrog"
!

primAsDocumentFromSingleElement

    |documentFragment|

    documentFragment := XMLv2::XMLSuiteDOM3Implementation 
                createDocument.
    self do:[:item | 
        documentFragment appendChild:item asDocumentFragment
    ].
    ^ documentFragment

    "Created: / 12-12-2006 / 14:03:33 / janfrog"
    "Modified: / 10-08-2007 / 09:08:11 / janfrog"
!

primAsString
    |string|

    string := ''.

    self do:[:item | 
        string := string, item asString
    ].
    ^ string.

    "Created: / 18-04-2009 / 14:39:23 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 19-04-2009 / 14:44:36 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryResult methodsFor:'initialize & release'!

releaseResources

    self do:[:each|each releaseResources]

    "Created: / 22-10-2008 / 07:55:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

setQueryString: aString

    queryString := aString

    "Created: / 12-12-2006 / 11:38:15 / janfrog"
!

setQueryTime: aTimeDuration

    queryTime := aTimeDuration

    "Created: / 21-11-2007 / 15:47:16 / janfrog"
! !

!XQueryResult methodsFor:'printing & storing'!

xmlPrintOn: aStream

    (1 to: self size) 
        do:
            [:idx|
            (super at: idx) xmlPrintOn: aStream]
        " removed, looks ugly :-) ~~ plickm1
          separatedBy:
            [aStream cr; cr]"

    "Created: / 25-03-2009 / 12:06:32 / Martin Plicka <plickm1@fel.cvut.cz>"
    "Modified: / 29-03-2009 / 18:13:14 / Martin Plicka <plickm1@fel.cvut.cz>"
!

xmlString

    | s |
    s := CharacterWriteStream on: (String new: 100).
    self xmlPrintOn: s.
    ^s contents

    "Created: / 25-03-2009 / 12:08:45 / Martin Plicka <plickm1@fel.cvut.cz>"
! !

!XQueryResult class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
