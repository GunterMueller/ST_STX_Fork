"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

"{ NameSpace: Smalltalk }"

Object subclass:#RBToken
	instanceVariableNames:'sourcePointer lineNumber columnNumber comments'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Scanner'
!


!RBToken class methodsFor:'instance creation'!

start: anInterval 
	^self new start: anInterval
!

start: anInterval lineNumber: tokenLineNumber
	^self new start: anInterval lineNumber: tokenLineNumber
! !

!RBToken methodsFor:'accessing'!

columnNumber
    ^ columnNumber
!

columnNumber:something
    columnNumber := something.
!

comments
    ^ comments
!

comments:anObject
    comments := anObject.
!

endPosition
    ^ self stop
!

length
	^self subclassResponsibility
!

lineNumber
    lineNumber isNil ifTrue:[self breakPoint:#cg info:'lineNumber should always be non-nil'].
    ^ lineNumber

    "Modified: / 26-04-2010 / 14:58:57 / sr"
!

lineNumber:something
    lineNumber := something.
    "/ self assert:(lineNumber notNil).
!

originalCodeIn:source
    ^ (source copyFrom:self start to:self stop) 
!

removePositions
	sourcePointer := nil
!

start
        ^sourcePointer ? 1
!

startPosition
    ^ self start
!

stop
        ^(sourcePointer ? 1) + self length - 1
! !

!RBToken methodsFor:'initialization & release'!

start: anInteger 
	sourcePointer := anInteger
!

start: anInteger lineNumber: tokenLineNumber
        sourcePointer := anInteger.
        lineNumber := tokenLineNumber.
        "/ self assert:(lineNumber notNil).
! !

!RBToken methodsFor:'printing'!

printOn: aStream 
	aStream
		nextPut: $ ;
		nextPutAll: self class name
! !

!RBToken methodsFor:'testing'!

isAssignment
	^false
!

isBinary
	^false
!

isEOF
    ^ self class == RBToken

    "Created: / 06-03-2012 / 11:20:54 / cg"
!

isIdentifier
	^false
!

isKeyword
	^false
!

isLiteral
	^false
!

isLiteralArray
        ^false
!

isLiteralByteArray
        ^false
!

isLiteralCharacter
        ^false
!

isLiteralFloat
        ^false
!

isLiteralInteger
        ^false
!

isLiteralNumber 
    ^ false
!

isLiteralString
        ^false
!

isLiteralSymbol
        ^false
!

isMetaVariable
	^false
!

isOptimized
	^false
!

isPatternBlock
	^false
!

isPatternVariable
	^false
!

isSTXPrimitiveCode
    ^ false
!

isSpecial
	^false
! !

!RBToken class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

