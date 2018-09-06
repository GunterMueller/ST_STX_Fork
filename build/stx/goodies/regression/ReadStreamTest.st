"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#ReadStreamTest
	instanceVariableNames:'startPosition streamClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Tests-Regression'
!

!ReadStreamTest class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]

    [class variables:]
"
!

history
    "Created: / 13.12.2001 / 17:13:17 / stefan"
! !

!ReadStreamTest methodsFor:'accessing'!

streamClass
    ^ streamClass
! !

!ReadStreamTest methodsFor:'helpers'!

checkReadStreamFor:testCollection 
    "check for correct common behavior of Stream reading"

    "The stream is opened in a way so that it can be used for both
     ReadStreams and ReadWriteStreams. Do not use #on:!!"

    ^ self checkReadStreamFor:testCollection useWith:true
!

checkReadStreamFor:testCollection useWith:useWith
    "check for correct common behavior of Stream reading"

    |stream|

    "The stream is opened in a way so that it can be used for both
     ReadStreams and ReadWriteStreams. Do not use #on:!!"

    useWith ifTrue:[
        stream := self streamClass with:testCollection.
    ] ifFalse:[
        stream := self streamClass on:testCollection.
    ].
    stream reset. "for ReadWriteStreams"
    self assert:(stream size == testCollection size).
    testCollection size == 0 ifTrue:[
        self assert:(stream isEmpty).
    ] ifFalse:[
        self assert:(stream isEmpty not).
    ].
    testCollection 
        keysAndValuesDo:[:pos :element | 
            self assert:(stream atEnd not).
            self assert:(stream peek == element).
            self assert:(stream position == (pos + startPosition - 1)).
            self assert:(stream next == element).
            self assert:(stream position == (pos + startPosition))
        ].
    self assert:(stream atEnd).
    self assert:(stream peek isNil).
    self assert:(stream next isNil).
    streamClass endOfStreamSignal 
        handle:[:ex | ex return]
        do:[
            self should:(stream next) raise:streamClass endOfStreamSignal.
            self should:(stream peek) raise:streamClass endOfStreamSignal.
            self shouldnt:(stream peekOrNil) raise:streamClass endOfStreamSignal
        ]
! !

!ReadStreamTest methodsFor:'setup'!

setUp
    self streamClass:Rel5::ReadStream.
!

streamClass:aClass 
    streamClass := aClass.
    startPosition := streamClass zeroPosition
! !

!ReadStreamTest methodsFor:'tests'!

testBasic
    |stream|

    stream := self streamClass on:''.
    self assert:(stream isReadable).
    self assert:(stream isPositionable).
    self assert:(stream isWritable not).
    self assert:(stream size == 0).
    self assert:(stream isEmpty)
!

testOn

    |stream|

    stream := self streamClass on:'12345'.
    self assert:(stream position == startPosition).
    self assert:(stream isEmpty not).
    self assert:(stream size == 5).
!

testReadStream

   self checkReadStreamFor:''.
   self checkReadStreamFor:'12345'.
   self checkReadStreamFor:'12345'asByteArray.
   self checkReadStreamFor:#[1 2 3 4 5].
   self checkReadStreamFor:#(1 2 3 4 5).
   self checkReadStreamFor:#(1 2 3 4 5) asOrderedCollection.

   self checkReadStreamFor:''                                   useWith:false.
   self checkReadStreamFor:'12345'                              useWith:false.
   self checkReadStreamFor:'12345'asByteArray                   useWith:false.
   self checkReadStreamFor:#[1 2 3 4 5]                         useWith:false.
   self checkReadStreamFor:#(1 2 3 4 5)                         useWith:false.
   self checkReadStreamFor:#(1 2 3 4 5) asOrderedCollection     useWith:false.

   "
    (self selector:#testReadStream) runCase
   "
!

testSkipAny
    |stream skipChars|

    stream := self streamClass 
                on:'some numbers1234with\in other99 stuff' withCRs.
    skipChars := 'abcdefghijklmnopqrstuvwxyz\ ' withCRs.
    self assert:(stream skipAny:skipChars) == $1.
    self assert:(Integer readFrom:stream) == 1234.
    self assert:(stream skipAny:skipChars) == $9.
    self assert:(Integer readFrom:stream) == 99
!

testSkipSeparators
    |stream sep|

    stream := self streamClass on:'one      two\three' withCRs.
    self assert:((sep := stream skipSeparators) == $o).
    self assert:(stream nextWord = 'one').
    self assert:(stream skipSeparators == $t).
    self assert:(stream nextWord = 'two').
    self assert:(stream skipSeparators == $t).
    self assert:(stream nextWord = 'three').
    self assert:(stream atEnd).
    self assert:(stream skipSeparators isNil)
!

testSkipSeparatorsExceptCR
    |stream|

    stream := self streamClass on:'one      two\three' withCRs.
    self assert:(stream skipSeparatorsExceptCR == $o).
    self assert:(stream nextWord = 'one').
    self assert:(stream skipSeparatorsExceptCR == $t).
    self assert:(stream nextWord = 'two').
    self assert:(stream skipSeparatorsExceptCR == Character cr).
    self assert:(stream next = Character cr).
    self assert:(stream nextWord = 'three').
    self assert:(stream atEnd).
    self assert:(stream skipSeparatorsExceptCR isNil)
!

testSkipSpaces
    |stream|

    stream := self streamClass on:'one      two\three' withCRs.
    self assert:(stream skipSpaces == $o).
    self assert:(stream nextWord = 'one').
    self assert:(stream skipSpaces == $t).
    self assert:(stream nextWord = 'two').
    self assert:(stream skipSpaces == Character cr).
    self assert:(stream next = Character cr).
    self assert:(stream nextWord = 'three').
    self assert:(stream atEnd).
    self assert:(stream skipSpaces isNil)
!

testWith

    |stream|

    stream := self streamClass with:'12345'.
    self assert:(stream position == (startPosition+5)).
!

xxtestReadBinary
    |stream byte|

    stream := self streamClass on:'hello'.
    stream binary.

    self assert:(byte := stream next) == $h asciiValue.
    self assert:(byte := stream next) == $e asciiValue.
    self assert:(byte := stream next) == $l asciiValue.
    self assert:(byte := stream next) == $l asciiValue.
    self assert:(byte := stream next) == $o asciiValue.
    self assert:(stream atEnd)


   "
    (self selector:#testReadBinary) runCase
   "
! !

!ReadStreamTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !
