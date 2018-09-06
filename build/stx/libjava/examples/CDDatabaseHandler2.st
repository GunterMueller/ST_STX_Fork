"{ Package: 'stx:libjava/examples' }"

"{ NameSpace: Smalltalk }"

Object subclass:#CDDatabaseHandler2
	instanceVariableNames:'index title artist tag'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Examples'
!

!CDDatabaseHandler2 class methodsFor:'documentation'!

documentation
"
    A simple XML CD database parser - a demonstration
    of stx:libjava capabilities. See JavaExamples>>example_2

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!CDDatabaseHandler2 class methodsFor:'initialization'!

initialize

    self lookupObject: JavaLookup instance

    "Created: / 13-05-2012 / 17:24:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CDDatabaseHandler2 methodsFor:'SAX2 interface'!

characters: string offset: off length: len

    tag = 'title'  ifTrue:[
        title := string copyFrom: off + 1 to: off + len.
        tag := nil.
    ].
    tag = 'artist' ifTrue:[
        artist := string copyFrom: off + 1 to: off + len.
        tag := nil.
    ].

    "Created: / 13-05-2012 / 17:27:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

endDocument

    "Created: / 16-04-2005 / 12:28:31 / janfrog"
!

endDocumentFragment

    "Created: / 10-08-2007 / 09:22:12 / janfrog"
!

endElement:namespace localName:localName qName:qName 


    qName = 'cd' ifTrue:[
        index := index + 1.
        UserNotification notify: 
            (index printString , '. ', title , ' - ' , artist)
    ]

    "Created: / 13-05-2012 / 17:38:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

endPrefixMapping:prefix

    "Created: / 16-04-2005 / 12:29:45 / janfrog"
!

ignorableWhitespace:aString

    "Created: / 16-04-2005 / 12:30:04 / janfrog"
!

processingInstruction:target data:data

    "Created: / 16-04-2005 / 12:31:04 / janfrog"
!

setDocumentLocator:aLocator

    "Created: / 16-04-2005 / 12:30:37 / janfrog"
    "Modified: / 13-05-2012 / 17:26:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skippedEnrity:aString

    "Created: / 16-04-2005 / 12:31:18 / janfrog"
!

startDocument

    index := 0

    "Created: / 16-04-2005 / 12:31:25 / janfrog"
    "Modified: / 13-05-2012 / 17:30:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startDocumentFragment

    "Created: / 10-08-2007 / 09:22:07 / janfrog"
!

startElement:namespace localName:localName qName:qName attributes:attributes

    tag := qName.

    "Created: / 13-05-2012 / 17:37:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startPrefix:prefix mappingTo:uri

    "Created: / 17-04-2005 / 08:47:18 / janfrog"
! !

!CDDatabaseHandler2 class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/examples/CDDatabaseHandler2.st,v 1.5 2015-03-20 12:08:02 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: CDDatabaseHandler2.st,v 1.5 2015-03-20 12:08:02 vrany Exp $'
! !


CDDatabaseHandler2 initialize!
