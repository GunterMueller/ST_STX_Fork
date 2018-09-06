"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#XQueryScannerState
	instanceVariableNames:'stream streamPosition start'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Core'
!


!XQueryScannerState methodsFor:'accessing'!

start
    ^ start
!

start:something
    start := something.
!

stream
    ^ stream
!

stream:something
    stream := something.
!

streamPosition
    streamPosition isNil ifTrue: [
        streamPosition := 0.
    ].
    ^ streamPosition

    "Modified: / 15-07-2009 / 22:40:17 / Jan Kurs <kursj1@fel.cvut.cz>"
!

streamPosition:something
    streamPosition := something.
! !

!XQueryScannerState class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
