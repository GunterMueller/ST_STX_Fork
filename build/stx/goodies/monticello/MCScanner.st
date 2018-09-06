"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCScanner
	instanceVariableNames:'stream'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Chunk Format'
!

!MCScanner class methodsFor:'documentation'!

documentation
"
    I scan / tokenize metadata  (package name, version info, ancestry, dependencies, ...) found in .mcz files.

    For example, try:

    MCScanner scan:  '(name ''MyPackage-ll.6'' message ''Fix bug xxx'' id ''b21dbd73-f1c3-2746-a3cc-92f1d4edea28'')' readStream
"
! !

!MCScanner class methodsFor:'as yet unclassified'!

scan: aStream
    ^ (self new stream: aStream) next

    "kludge:

    | v |
    [ v := (self new stream: aStream) next ]
        on: RecursionInterruptSignal do:[:ex|ex proceed].
    ^v
    "

    "Modified: / 13-10-2010 / 15:52:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scanTokens: aString
	"compatibility"
	^ Array with: (self scan: aString readStream)
! !

!MCScanner methodsFor:'as yet unclassified'!

next

    | token stack array |
    token := self nextToken.
    token == $) ifTrue:[self error: 'Array not opened'].
    token ~= $( ifTrue:[^token].
    stack := Stack with: (array := OrderedCollection new).
    [ stack isEmpty ] whileFalse:[
        token := self nextToken.
        token == $( 
            ifTrue:
                [stack push: OrderedCollection new]
            ifFalse:
                [token == $) 
                    ifTrue:
                        [|top|
                        top := stack top asArray.
                        stack pop.
                        stack size > 0 ifTrue:[stack top add: top]]
                    ifFalse:
                        [stack top add: token]]].

    ^array asArray

    "Modified: / 28-10-2010 / 13:31:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextArray
	stream next. "("
	^ Array streamContents:
		[:s |
		[stream skipSeparators.
		(stream peek = $)) or: [stream atEnd]] whileFalse: [s nextPut: self next].
		stream next = $) ifFalse: [self error: 'Unclosed array']]
!

nextString
	^ stream nextDelimited: $'
!

nextSymbol
	^ (String streamContents:
		[:s |
		[stream peek isAlphaNumeric] whileTrue: [s nextPut: stream next]]) asSymbol
			
!

nextToken
        | c |
        stream skipSeparators.
        c := stream peek.
        c = $# ifTrue: [c := stream next; peek].
        c = $' ifTrue: [^ self nextString].
        c = $( ifTrue: [stream next.^ $(].
        c = $) ifTrue: [stream next.^ $)].
        c isAlphaNumeric ifTrue: [^ self nextSymbol].
        self error: 'Unknown token type'.

    "Created: / 28-10-2010 / 13:20:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stream: aStream
	stream := aStream
! !

!MCScanner class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCScanner.st,v 1.6 2014-12-11 15:49:15 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCScanner.st,v 1.6 2014-12-11 15:49:15 cg Exp $'
!

version_SVN
    ^ '$Id: MCScanner.st,v 1.6 2014-12-11 15:49:15 cg Exp $'
! !

