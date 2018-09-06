"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2007 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

PeekableStream subclass:#JSONReader
	instanceVariableNames:'stream'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-JSON'
!

!JSONReader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2007 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    I read data structures (currently build of OrderedCollection and Dictionary)
    from and to JSON (Java Script Object Notation). 
    Writing is done with the #toJSON: class-method (note: it will behave badly with circular data structures).
    Reading via the #fromJSON: class-method.

    Notice: 
        By default (and standard), 
        Date, Time and Timestamps are written as iso8601 strings,
        and read initially as strings (thus, they must be converted explicitely back if required).

        The non-standard (but supported by some browsers) format is 'new Date(...)' which is generated
        optionally, if the useISODateFormat flag is turned off in the JSONPrinter.
        However, we cannot read back this format.
        As per ECMA,
            JSON.stringify({'now': new Date()}) 
        should generate
            {''now'':''2013-10-21T13:28:06.419Z''}
        which is exactly what JSONPrinter now generates by default
            JSONPrinter encode:(Structure with: #now -> (Timestamp now)).

    Another Note:
        Can now also encode arbitrary Smalltalk objects; however, the reader will always decode them 
        as dictionaries:
            JSONPrinter encode:(Point x:10 y:20).
            JSONReader decode:(JSONPrinter encode:(Point x:10 y:20)).

    Final Notice:
        take a look at the other (alternative) JSON framework (Json),
        which can also be used to handle JSON data, and offers a more flexible
        object mapping mechanism to decode into real objects.

    Author:
        Public Domain Code from Robin Redeker published in lists.gnu.org
        adapted to ST/X by Claus Gittinger
"
!

examples
"
                                                                        [exBegin]
    |o1 s o2|
    o1 := #('hello' 123 nil true false (1 'two' 3.0) -4 -2.123e-5).
    s := JSONPrinter toJSON:o1.
    o2 := JSONReader fromJSON:s   
    self assert:(o1 = o2).
                                                                        [exEnd]

                                                                        [exBegin]
    |o1 s o2|
    o1 := Dictionary withKeysAndValues:#('one' 1 'two' 2 'three' 3.0 'four' 'vier').
    s := JSONPrinter toJSON:o1.
    o2 := JSONReader fromJSON:s.   
    self assert:(o1 sameContentsAs: o2).
                                                                        [exEnd]

                                                                        [exBegin]
    |o1 s o2|
    o1 := Dictionary withKeysAndValues:#('one two three' 123).
    s := JSONPrinter toJSON:o1.
    o2 := JSONReader fromJSON:s.   
    self assert:(o1 sameContentsAs: o2).
                                                                        [exEnd]

                                                                        [exBegin]
    |o1 s o2|
    o1 := { Date today . Time now . Timestamp now }.
    s := JSONPrinter encode:o1.
    o2 := JSONReader decode:s.
    -- notice: data & times are decoded as strings
                                                                        [exEnd]

                                                                        [exBegin]
    |o1 s o2|
    o1 := { Point x:10 y:20 }.
    s := JSONPrinter new useISODateFormat:false; encode:o1.
    o2 := JSONReader decode:s.
    self assert:(o1 sameContentsAs: o2).
                                                                        [exEnd]

                                                                        [exBegin]
    |o1 s o2|
    o1 := { Date today . Time now . Timestamp now }.
    s := JSONPrinter new useISODateFormat:false; encode:o1.
    o2 := JSONReader decode:s -- fails as non-JSON  
                                                                        [exEnd]
"
! !

!JSONReader class methodsFor:'instance creation'!

on: aStream
    ^self basicNew stream: aStream

    "Modified: / 27-08-2007 / 11:35:05 / cg"
! !

!JSONReader class methodsFor:'API - decoding'!

decode:stringOrStream
    "decode the JSON string (as received from JavaScript) to an object.
     Same as fromJSON; added to make this encoder more protocol-conform
     to other encoders."

    ^ self fromJSON:stringOrStream
!

fromJSON: stringOrStream
    "decode the JSON string (as received from JavaScript) to an object."

    ^ (self on: stringOrStream readStream) nextJSONObject

    "Modified: / 07-01-2011 / 12:40:56 / cg"
    "Modified (format): / 08-03-2018 / 19:06:48 / stefan"
!

readFrom:stringOrStream
    "decode the JSON string (as received from JavaScript) to an object.
     Same as fromJSON; added to make this encoder more protocol-conform
     to other encoders."

    ^ self fromJSON:stringOrStream

    "Created: / 28-06-2018 / 14:30:51 / Claus Gittinger"
! !

!JSONReader class methodsFor:'API - encoding'!

encode:anObject
    "return a JSON string which represents the object (can be sent to JavaScript).
     Same as toJSON; added to make this encoder more protocol-conform
     to other encoders."

    ^ self toJSON:anObject

    "
     |s1 s2|
     s1 := self encode:#('hello' 123 true (1 'two' 3.0)).
     s2 := self decode:s1  
    "
!

toJSON:anObject
    "return a JSON string which represents the object (can be sent to JavaScript)."

    ^ JSONPrinter encode:anObject

    "
     |s1 s2|
     s1 := self toJSON:#('hello' 123 true (1 'two' 3.0)).
     s2 := self fromJSON:s1  
    "

    "
     |s1 s2|
     s1 := self toJSON:(Dictionary withKeys:#('a' 'b' 'c') andValues:#(1 2 3)).
     s2 := self fromJSON:s1  
    "

    "Modified: / 07-01-2011 / 12:41:01 / cg"
    "Modified: / 26-06-2018 / 10:31:01 / Stefan Vogel"
    "Modified (comment): / 15-08-2018 / 13:46:56 / Claus Gittinger"
!

toJSON:anObject on:aStream
    "append a JSON string which represents the object (can be sent to JavaScript)
     to aStream."

    JSONPrinter encode:anObject on:aStream

    "
     self toJSON:#('hello' 123 true (1 'two' 3.0)) on:Transcript.
    "

    "Created: / 25-06-2018 / 18:52:08 / Claus Gittinger"
    "Modified: / 26-06-2018 / 10:47:05 / Stefan Vogel"
    "Modified: / 22-07-2018 / 09:07:57 / Claus Gittinger"
! !

!JSONReader methodsFor:'private'!

atEnd
    ^ stream atEnd.
!

next
    "I'm returning the next non-whitespace character"
    
    |c|

    c := self peek.
    c isNil ifTrue:[
        ^ self error:'expected character but found end of stream'
    ].
    stream next.
    ^ c

    "Modified: / 07-01-2011 / 12:52:17 / cg"
!

nextJSONArray
    "I decode JSON arrays from self and will return an Array for them."

    | c obj |

    obj := OrderedCollection new.
    self next.
    [ 
        c := self peek.
        (c == $]) 
    ] whileFalse: [
       (c == $,) ifTrue: [ self next. ].
       obj add: self nextJSONObject.
    ].
    self next.
    ^ obj asArray

    "Modified (format): / 05-02-2017 / 18:25:45 / cg"
    "Modified: / 08-03-2018 / 19:02:31 / stefan"
!

nextJSONDict
    "I decode JSON objects from self and will return a Dictionary containing all the key/value pairs."

    | c obj |

    obj := OrderedDictionary new.
    self next.
    [ 
        c := self peek.
        c == $} 
    ] whileFalse: [
        | key |

        (c == $,) ifTrue: [ self next ].

        key := self nextJSONObject.
        "/ self nextJSONString.

        c := self next.
        c == $: ifFalse: [
            self error: ('unexpected character found where name-seperator '':'' expected, found: %1' bindWith: c)
        ].

        obj at: key put: self nextJSONObject.
    ].
    self next.
    ^obj

    "Modified (format): / 08-03-2018 / 19:10:18 / stefan"
!

nextJSONNumber
    "I'm extracting a number in JSON format from self and return Integer or Float depending on the input."

    | c sgn int intexp exp isfloat |

    isfloat := false.
    sgn     := 1.
    int     := 0.
    intexp  := 1.

    c := self peek.
    (c isNil) ifTrue: [ ^self error: 'expected number or -sign, but found end of self' ].
    c == $- ifTrue: [ 
        sgn := -1. 
        c := self nextPeek.
        (c isNil) ifTrue: [ ^self error: 'expected number, but found end of self' ].
    ].

    (c isDigit or: [ c == $. ]) ifFalse: [ ^self error: 'invalid JSON input' ].

    [ c notNil and: [ c isDigit ] ] whileTrue: [
        int := sgn * (c digitValue) + (int * 10).
        c := self nextPeek
    ].
    (c isNil) ifTrue: [ ^int ].

    c == $. ifTrue: [
        isfloat := true.
        [ c := self nextPeek. c notNil and: [ c isDigit ] ] whileTrue: [
            sgn := sgn / 10.
            int := sgn * (c digitValue) + int.
        ]
    ].

    exp := 0.
    ((c == $e) or: [ c == $E ]) ifFalse: [
        ^ isfloat ifTrue: [ int asFloat ] ifFalse: [ int ] 
    ].

    c := self nextPeek.
    (c isNil) ifTrue: [ ^int ].
    sgn := 1.
    c == $+ ifTrue: [ sgn :=  1. self next ].
    c == $- ifTrue: [ sgn := -1. self next ].

    [ c := self peek. c notNil and: [ c isDigit ] ] whileTrue: [
        exp := (c digitValue) + (exp * 10).
        self next
    ].

    int := int * (10 raisedToInteger: exp * sgn).
    ^ int asFloat

    "Modified: / 05-02-2017 / 18:26:25 / cg"
    "Modified: / 08-03-2018 / 19:23:49 / stefan"
!

nextJSONString
    "I'm extracting a JSON string from self and return it as String."

    | c str |

    str := CharacterWriteStream on:(String new:20).
    self next.
    [
         c := stream next.    "/ not self next here - we want spaces inside the string !!
         c == $"
    ] whileFalse: [
         c == $\ ifTrue: [
             c := stream next.   "/ not self next here - we want spaces inside the string !!
             c isNil ifTrue:[ 
                 ^ self error: 'expected character, found end of self' 
             ].
             c == $b ifTrue: [ c := 8 asCharacter ].
             c == $f ifTrue: [ c := 12 asCharacter ].
             c == $n ifTrue: [ c := Character nl ].
             c == $r ifTrue: [ c := Character cr ].
             c == $t ifTrue: [ c := Character tab ].
             c == $u ifTrue: [
                 c := Character codePoint:(Integer readFrom: (self next: 4) readStream radix: 16).
             ]
       ].
       str nextPut:c.
    ].

    "Undo the conversion to UnicodeString done above."
    ^str contents asString

    "Modified: / 05-02-2017 / 18:26:40 / cg"
!

peek
    "I'm peeking for the next non-whitespace character and will drop all whitespace in front of it"
    
    |c|

    [
        c := stream peek.
        c = (Character space) or:[ c = (Character tab) or:[ c = (Character lf) or:[ c = (Character return) ] ] ]
    ] whileTrue:[ stream next ].
    ^ c

    "Modified: / 07-01-2011 / 12:52:12 / cg"
!

stream: aStream
    stream := aStream
! !

!JSONReader methodsFor:'reading'!

nextJSONObject
    "I decode a json self to a value, which will be one of: 
         nil, true, false, OrderedCollection, Dictionary, String or Number
     (I will return Integer or Float depending on the input)."

    | c |

    c := self peek.
    (c == $n) ifTrue: [ self next: 4. ^nil   ].
    (c == $t) ifTrue: [ self next: 4. ^true  ].
    (c == $f) ifTrue: [ self next: 5. ^false ].
    (c == ${) ifTrue: [ ^self nextJSONDict ].
    (c == $[) ifTrue: [ ^self nextJSONArray  ].
    (c == $") ifTrue: [ ^self nextJSONString ].
    "/ undefined as nil?!!?    
    (c == $u) ifTrue: [ self nextAlphaNumericWord. ^nil ].
    ^self nextJSONNumber

    "Modified: / 07-01-2011 / 12:53:26 / cg"
! !

!JSONReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/JSONReader.st,v 1.29 2018-09-03 09:20:30 anharman Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/JSONReader.st,v 1.29 2018-09-03 09:20:30 anharman Exp $'
! !

