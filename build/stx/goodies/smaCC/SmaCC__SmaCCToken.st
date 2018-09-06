"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

Object subclass:#SmaCCToken
	instanceVariableNames:'start id value'
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Runtime'
!

SmaCCToken comment:'SmaCCTokens are used as the interface objects between scanner and parser. They hold the string that was scanned and its position information. Also, included in the token is its id. The id specifies what type of token it is.

Instance Variables:
	id	<Array of: Integer>	the list of possible token types this represents. There can be overlapping tokens, so we list all of the id here. The default parser only looks at the first id, but we can redefine this behavior in a subclass to look at all possibilities until we find a valid token.
	start	<Integer>	the starting position of the token in the original input
	value	<Object>	the value of our token (normally a string, but could be anything)
'
!


!SmaCCToken class methodsFor:'instance creation'!

value: aString start: anInteger id: anObject 
	^(self new)
		value: aString
			start: anInteger
			id: anObject;
		yourself
! !

!SmaCCToken methodsFor:'accessing'!

id
	^id
!

startPosition
	^start + 1
!

stopPosition
	^start + value size
!

value
	^value
! !

!SmaCCToken methodsFor:'initialize-release'!

value: anObject start: startPositionInteger id: anInteger 
	value := anObject.
	start := startPositionInteger.
	id := anInteger
! !

!SmaCCToken methodsFor:'printing'!

printOn: aStream 
	aStream
		nextPut: ${;
		nextPutAll: self value;
		nextPut: $(;
		nextPutAll: self startPosition printString;
		nextPut: $,;
		nextPutAll: self stopPosition printString;
		nextPut: $,;
		nextPutAll: self id printString;
		nextPutAll: ')}'
! !

!SmaCCToken class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCToken.st,v 1.1 2006-02-09 21:15:10 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
