"{ Package: 'stx:goodies/petitparser' }"

Object subclass:#PPToken
	instanceVariableNames:'collection start stop value'
	classVariableNames:'NewLineParser'
	poolDictionaries:''
	category:'PetitParser-Core'
!


!PPToken class methodsFor:'initialization'!

initialize
	"Platform independent newline sequence. LF: Unix, CR+LF: Windows, and CR: Apple."
	| cr lf |
	cr := Character codePoint: 13.
	lf := Character codePoint: 10.
	NewLineParser := lf asParser / (cr asParser , lf asParser optional)
! !

!PPToken class methodsFor:'instance creation'!

new
	self error: 'Token can only be created using a dedicated constructor.'
!

on: aSequenceableCollection
	^ self on: aSequenceableCollection start: 1 stop: aSequenceableCollection size value: nil
!

on: aSequenceableCollection start: aStartInteger stop: aStopInteger value: anObject
	^ self basicNew 
		initializeOn: aSequenceableCollection
		start: aStartInteger stop: aStopInteger
		value: anObject
! !


!PPToken methodsFor:'accessing'!

collection
	"Answer the underlying collection of this token."

	^ collection
!

size
	"Answer the size of this token in the underlying collection."

	^ stop - start + 1
!

start
	"Answer the start position of this token in the underlying collection."

	^ start
!

stop
	"Answer the stop position of this token in the underlying collection."
	
	^ stop
! !

!PPToken methodsFor:'accessing-values'!

inputValue
	"Answer the consumed input of this token."

	^ collection copyFrom: start to: stop
!

parsedValue
	"Answer the parsed value of this token."

	^ value
!

value
	self notify: 'Token>>#value is no longer supported. Instead use Token>>#inputValue or the more pragmatic #parsedValue.'.
	^ self inputValue
! !

!PPToken methodsFor:'comparing'!

= anObject
	^ self class = anObject class and: [ self parsedValue = anObject parsedValue ]
!

hash
	^ self parsedValue hash
! !

!PPToken methodsFor:'copying'!

copyFrom: aStartInteger to: aStopInteger
	^ self class on: collection start: start + aStartInteger - 1 stop: stop + aStopInteger - 3 value: value
! !

!PPToken methodsFor:'initialization'!

initializeOn: aSequenceableCollection start: aStartInteger stop: aStopInteger value: anObject
	collection := aSequenceableCollection.
	start := aStartInteger.
	stop := aStopInteger.
	value := anObject
! !

!PPToken methodsFor:'printing'!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $[; print: self start; nextPut: $,; print: self stop; nextPut: $].
	aStream nextPut: $(; print: self parsedValue; nextPut: $)
! !

!PPToken methodsFor:'private'!

newline
        "Parser a platform independent newline sequence. LF: Unix, CR+LF: Windows, and CR: Apple."
        | cr lf |

        cr := Character codePoint: 13.
        lf := Character codePoint: 10.
        ^ lf asParser
        / (cr asParser , lf asParser optional)

    "Modified: / 04-10-2014 / 00:02:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPToken methodsFor:'querying'!

column
	"Answer the column number of this token in the underlying collection."
	
	| position |
	position := 0.
	(NewLineParser , [ :stream |
		start <= stream position
			ifTrue: [ ^ start - position ].
		position := stream position ] asParser
		/ #any asParser) star
			parse: collection.
	 ^ start - position
!

line
	"Answer the line number of this token in the underlying collection."
	
	| line |
	line := 1.
	(NewLineParser , [ :stream |
		start <= stream position
			ifTrue: [ ^ line ].
		line := line + 1 ] asParser
		/ #any asParser) star
			parse: collection.
	^ line
! !

!PPToken class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPToken.st,v 1.6 2014-03-04 20:10:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPToken.st,v 1.6 2014-03-04 20:10:06 cg Exp $'
!

version_SVN
    ^ '$Id: PPToken.st,v 1.6 2014-03-04 20:10:06 cg Exp $'
! !


PPToken initialize!
