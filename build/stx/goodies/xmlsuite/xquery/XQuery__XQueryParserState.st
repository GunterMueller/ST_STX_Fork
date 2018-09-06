"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#XQueryParserState
	instanceVariableNames:'currentToken stateStack nodeStack'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Core'
!


!XQueryParserState methodsFor:'accessing'!

currentToken
    ^ currentToken
!

currentToken:something
    currentToken := something.
!

nodeStack
    ^ nodeStack
!

nodeStack:something
    nodeStack := something.
!

stateStack
    ^ stateStack
!

stateStack:something
    stateStack := something.
! !

!XQueryParserState class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
