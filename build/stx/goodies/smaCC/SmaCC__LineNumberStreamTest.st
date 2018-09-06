"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

TestCase subclass:#LineNumberStreamTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmaCC-Tests'
!


!LineNumberStreamTest methodsFor:'private'!

addCRLFsTo: aString
        Smalltalk isSmalltalkX ifTrue:[
            ^aString replString: '\'
                    withString: (String with: Character return with: Character lf)
        ].

        ^aString copyReplaceAll: '\'
                with: (String with: Character cr with: Character lf)
!

addCRsTo: aString 
        Smalltalk isSmalltalkX ifTrue:[
            ^aString replString: '\'
                    withString: (String with: Character return)
        ].
        ^aString copyReplaceAll: '\' with: (String with: Character cr)
!

addLFsTo: aString 
        Smalltalk isSmalltalkX ifTrue:[
            ^aString replString: '\'
                    withString: (String with: Character lf)
        ].
        ^aString copyReplaceAll: '\' with: (String with: Character lf)
! !

!LineNumberStreamTest methodsFor:'public'!

testCRLFLines
	| stream |
	stream := SmaCCLineNumberStream 
				on: (ReadStream on: (self addCRLFsTo: '1\2\3\4')).
	1 to: 4
		do: 
			[:each | 
			self assert: stream lineNumber = each.
			stream upTo: Character lf]
!

testCRLines
        | stream cr |

        cr := Character cr.
        Smalltalk isSmalltalkX ifTrue:[ cr := Character return. ].

        stream := SmaCCLineNumberStream 
                                on: (ReadStream on: (self addCRsTo: '1\2\3\4')).
        1 to: 4
                do: 
                        [:each | 
                        self assert: stream lineNumber = each.
                        stream upTo: cr]
!

testEmptyLines
        | stream cr |

        cr := Character cr.
        Smalltalk isSmalltalkX ifTrue:[ cr := Character return. ].

        stream := SmaCCLineNumberStream 
                                on: (ReadStream on: (self addCRsTo: '\\\')).
        1 to: 4
                do: 
                        [:each | 
                        self assert: stream lineNumber = each.
                        stream upTo: cr]
!

testForwardPositionCRLFLines
	| stream |
	stream := SmaCCLineNumberStream 
				on: (ReadStream on: (self addCRLFsTo: '1\2\3\4')).
	stream position: 3.
	self assert: stream lineNumber = 2
!

testLFLines
	| stream |
	stream := SmaCCLineNumberStream 
				on: (ReadStream on: (self addLFsTo: '1\2\3\4')).
	1 to: 4
		do: 
			[:each | 
			self assert: stream lineNumber = each.
			stream upTo: Character lf]
!

testNoLines
	| stream |
	stream := SmaCCLineNumberStream on: (ReadStream on: 'this is a test').
	self assert: stream lineNumber = 1.
	stream do: [:each | self assert: stream lineNumber = 1]
!

testPositionCRLFLines
        | stream |
        stream := SmaCCLineNumberStream 
                                on: (ReadStream on: (self addCRLFsTo: '1\2\3\4')).
        self assert: stream lineNumber = 1.
        stream upTo: $5.
        self assert: stream lineNumber = 4.
        Smalltalk isSmalltalkX ifTrue:[ stream reset ] ifFalse:[ stream position: 0 ].
        self assert: stream lineNumber = 1.
        Smalltalk isSmalltalkX ifTrue:[ stream position: 4 ] ifFalse:[ stream position: 3 ].
        self assert: stream lineNumber = 2
!

testPositionCRLines
        | stream |
        stream := SmaCCLineNumberStream 
                                on: (ReadStream on: (self addCRsTo: '1\2\3\4')).
        self assert: stream lineNumber = 1.
        stream upTo: $5.
        self assert: stream lineNumber = 4.
        stream skip: -1.
        self assert: stream lineNumber = 4.
        Smalltalk isSmalltalkX ifTrue:[ stream reset ] ifFalse:[ stream position: 0 ].
        self assert: stream lineNumber = 1.
        Smalltalk isSmalltalkX ifTrue:[ stream position: 3 ] ifFalse:[ stream position: 2 ].
        self assert: stream lineNumber = 2
! !

!LineNumberStreamTest class methodsFor:'documentation'!

version
    ^ '$Id$'
!

version_SVN
    ^ '$Id$'
! !

