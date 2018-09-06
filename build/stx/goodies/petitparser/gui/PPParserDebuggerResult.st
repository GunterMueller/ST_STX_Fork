"{ Package: 'stx:goodies/petitparser/gui' }"

Object subclass:#PPParserDebuggerResult
	instanceVariableNames:'parser result children parent start end'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitGui-Core'
!


!PPParserDebuggerResult class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
!

parse: aStream with: parser 
        | root newParser |
        root := self new.
        newParser := parser transform: [:each |
                each name isNil 
                        ifTrue: [ each ]
                        ifFalse: [
                                each >=> [:stream :continuation | 
                                        | result child |
                                        child := PPParserDebuggerResult new 
                                                        parser: each;
                                                        parent: root.
                                        root := root children add: child.
                                        child start: stream position + 1.
                                        result := continuation value.
                                        child end: stream position.
                                        root result: result.
                                        root := root parent.
                                        result ]]].
        newParser parse: aStream.
        ^ root children first
! !

!PPParserDebuggerResult methodsFor:'accessing'!

children
	^ children
!

children: anObject
	children := anObject
!

end
	^ end
!

end: anObject
	end := anObject
!

parent
	^ parent
!

parent: anObject
	parent := anObject
!

parser
	^ parser
!

parser: anObject
	parser := anObject
!

result
	^ result
!

result: anObject
	result := anObject
!

start
	^ start
!

start: anObject
	start := anObject
! !

!PPParserDebuggerResult methodsFor:'initialization'!

initialize 
	children := OrderedCollection new
! !

!PPParserDebuggerResult methodsFor:'printing'!

formattedText
	^ self result isPetitFailure 
		ifTrue: [ Text string: self printString attribute: TextColor gray ]
		ifFalse: [ self printString]
!

printOn: aStream 
	aStream 
		nextPutAll: self parser name;
		nextPutAll: ' - ';   
		nextPutAll: self result printString
! !

!PPParserDebuggerResult class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPParserDebuggerResult.st,v 1.2 2014-03-04 23:58:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/gui/PPParserDebuggerResult.st,v 1.2 2014-03-04 23:58:31 cg Exp $'
! !

