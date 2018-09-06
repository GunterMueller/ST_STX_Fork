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

ObjectCoder subclass:#JSONPrinter
	instanceVariableNames:'useISODateFormat alreadyStored prettyPrint skipNil'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-JSON'
!

!JSONPrinter class methodsFor:'documentation'!

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
    I encode a limited subset of Smalltalk object types into a JSON representation.

    Allowed are:
        strings,
        numbers
        booleans,
        nil,
        Arrays and OrderedCollections,
        Dictionaries,
        Date & Time (careful - see >> useISODateFormat)

    Everything else is not representable. 
    I do not handle recursive data structures.

    Notice:
        take a look at the other (alternative) JSON framework (Json),
        which can also be used to handle JSON data, and offers a more flexible
        object mapping mechanism to decode into real objects.
        
    Author:
        Claus Gittinger
        Loosely Based upon Public Domain Code from Robin Redeker published in lists.gnu.org
"
!

examples
"
     see examples in JSONReader
"
! !

!JSONPrinter class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!JSONPrinter class methodsFor:'API - encoding'!

encode:anObject
    "return a JSON string which represents the object (can be sent to JavaScript)."

    |stream|
    
    self encode:anObject on:(stream := CharacterWriteStream new:100).
    ^ stream contents

    "Modified: / 22-07-2018 / 09:22:22 / Claus Gittinger"
!

encode:anObject on:aStream
    "append a JSON string which represents the object onto aStream (can be sent to JavaScript)."

    RecursiveStoreError handle:[:ex |
        self recursionInterruptSignal raiseErrorString:'JSON: recursive store'
    ] do:[
        self new encode:anObject on:aStream.
    ].

    "Created: / 22-07-2018 / 09:05:04 / Claus Gittinger"
!

toJSON:anObject
    "return a JSON string which represents the object (can be sent to JavaScript)."

    ^ self encode:anObject

    "Modified (comment): / 09-06-2018 / 12:43:08 / Claus Gittinger"
! !

!JSONPrinter methodsFor:'accessing'!

prettyPrint:aBoolean
    "if false (the default), the generated JSON is compact;
     if true, lines are indented to be more readable"

    prettyPrint := aBoolean.

    "
     JSONPrinter new 
        encode:( Dictionary new
                    at:'hello' put:'world';
                    at:'foo' put:123;
                    at:'bar' put:(Dictionary new
                                    at:'one' put:1;
                                    at:'two' put:2;
                                    at:'three' put:#('aaa' 'bbb' 'ccc');
                                    yourself);
                    at:'baz' put:999.99;
                    yourself )
        on:Transcript.            

     JSONPrinter new 
        prettyPrint:true;
        encode:( Dictionary new
                    at:'hello' put:'world';
                    at:'foo' put:123;
                    at:'bar' put:(Dictionary new
                                    at:'one' put:1;
                                    at:'two' put:2;
                                    at:'three' put:#('aaa' 'bbb' 'ccc');
                                    yourself);
                    at:'baz' put:999.99;
                    yourself )
        on:Transcript.            
    "

    "Created: / 25-06-2018 / 19:01:13 / Claus Gittinger"
!

skipNil
    ^ skipNil
!

skipNil:something
    skipNil := something.
!

useISODateFormat
    "returns the date format generated.
     If true (the default), a string containing the ISO format
     is generated for Date, Time and Timestamp.
     if false, a non-standard (but supported by some browsers) format
     is generated (eg. 'new Date(y,m,d)')."

    ^ useISODateFormat ? true

    "
     JSONPrinter new 
        encode:{ Date today . Time now . Timestamp now }.

     JSONPrinter new 
        useISODateFormat:false;
        encode:{ Date today . Time now . TimeStamp now }.
    "
!

useISODateFormat:aBoolean
    "if true (the default), a string containing the ISO format
     is generated for Date, Time and Timestamp.
     if false, a non-standard (but supported by some browsers) format
     is generated (eg. 'new Date(y,m,d)')."

    useISODateFormat := aBoolean.

    "
     JSONPrinter new 
        encode:{ Date today . Time now . Timestamp now }.

     JSONPrinter new 
        useISODateFormat:false;
        encode:{ Date today . Time now . TimeStamp now }.
    "
! !

!JSONPrinter methodsFor:'encoding / decoding'!

encode:anObject
    stream isNil ifTrue:[
        stream := CharacterWriteStream new:20.
    ].
    anObject acceptVisitor:self with:0.
    ^ self contents.

    "Modified: / 25-06-2018 / 19:03:05 / Claus Gittinger"
!

encode:anObject on:aStream
    stream := aStream.
    anObject acceptVisitor:self with:0.

    "Created: / 25-06-2018 / 19:05:12 / Claus Gittinger"
! !

!JSONPrinter methodsFor:'initialization'!

initialize
    alreadyStored := IdentitySet new.
    prettyPrint := false.   
    skipNil := false.

    "Modified: / 25-06-2018 / 18:58:32 / Claus Gittinger"
    "Modified: / 28-06-2018 / 14:41:31 / Stefan Vogel"
! !

!JSONPrinter methodsFor:'visiting'!

visitBoolean:aBoolean with:aParameter
    aBoolean printOn: stream

    "Created: / 27-08-2007 / 11:33:08 / cg"
!

visitDate: aDate with: aParameter 
    self useISODateFormat ifTrue:[
        stream 
            nextPutAll: '"';
            nextPutAll: (aDate printStringIso8601);
            nextPutAll: '"'
    ] ifFalse:[
        stream 
            nextPutAll: 'new Date(' ;
            nextPutAll: aDate year asString ;
            nextPutAll:',' ;
            nextPutAll: (aDate month - 1) printString;  "/ months start at 0
            nextPutAll:',' ;
            nextPutAll: aDate  dayOfMonth asString;
            nextPutAll:')'.
    ]

    "
     JSONReader toJSON:{ Date today }            
     JSONReader toJSON:{ Date today addDays: 1 }
    "
!

visitDictionary:aDictionary with:indent
    |first|

    (alreadyStored includes:aDictionary) ifTrue:[
        RecursiveStoreError raiseRequestWith:aDictionary.
        'JSON [error]: trying to encode self referencing object.' errorPrintCR.
        stream nextPutAll:'"<<recursive>>"'.
        ^ self
    ].
    alreadyStored add:aDictionary.
    
    stream nextPut: ${.
    first := true.
    aDictionary keysAndValuesDo: [ :key :val |
        (val notNil or:[skipNil not]) ifTrue:[
            first ifFalse: [ stream nextPut: $, ].
            prettyPrint ifTrue:[stream cr; spaces:indent+2].
            key acceptVisitor:self with:(indent+2).
            stream nextPut: $:.
            val acceptVisitor:self with:(indent+2).
            first := false.
        ].
    ].
    prettyPrint ifTrue:[stream cr; spaces:indent].
    stream nextPut: $}.

    "Created: / 27-08-2007 / 11:44:06 / cg"
    "Modified: / 25-06-2018 / 19:04:34 / Claus Gittinger"
    "Modified: / 28-06-2018 / 14:41:20 / Stefan Vogel"
!

visitFloat:aFloat with:aParameter
    stream nextPutAll:
        (aFloat printString copyReplacing: aFloat class exponentCharacter withObject: $e)

    "Created: / 27-08-2007 / 11:32:37 / cg"
!

visitInteger:anInteger with:aParameter
    anInteger printOn: stream

    "Created: / 27-08-2007 / 11:30:10 / cg"
!

visitNilWith:aParameter
    stream nextPutAll: 'null'

    "Created: / 27-08-2007 / 11:37:08 / cg"
!

visitNumber:aNumber with:aParameter
    aNumber asFloat printOn: stream

    "Created: / 27-08-2007 / 11:30:24 / cg"
!

visitObject:someObject with:aParameter 
    "encode the object like a dictionary, using the object's instVarNames as keys."

    |first|

    (alreadyStored includes:someObject) ifTrue:[
        RecursiveStoreError raiseRequestWith:someObject.
        'JSON [error]: trying to encode self referencing object: ' errorPrint.
        someObject errorPrintCR.
        stream nextPutAll:'"<<recursive>>"'.
        ^ self
    ].
    alreadyStored add:someObject.
    
    stream nextPut:${.
    first := true.
    someObject class allInstVarNames 
        doWithIndex:[:eachName :idx |
           first ifFalse: [ stream nextPut: $, ].
           stream nextPut:$".
           stream nextPutAll:(eachName).
           stream nextPut:$".
           stream nextPut:$:.
           (someObject instVarAt:idx) acceptVisitor:self with:aParameter.
            first := false 
        ].
    stream nextPut: $}.

    "Modified: / 18-07-2018 / 09:55:55 / Claus Gittinger"
!

visitProtoObject:someObject with:aParameter 
    "I cannot encode proto objects"

    'JSON [error]: trying to encode a proto object.' errorPrintCR.
    stream nextPutAll:'"<<unstorable>>"'.
    ^ self

    "Created: / 04-07-2018 / 00:43:39 / Claus Gittinger"
!

visitSequenceableCollection:aCollection with:aParameter
    |first|

    (alreadyStored includes:aCollection) ifTrue:[
        RecursiveStoreError raiseRequestWith:aCollection.
        'JSON [error]: trying to encode self referencing object.' errorPrintCR.
        stream nextPutAll:'"<<recursive>>"'.
        ^ self
    ].
    alreadyStored add:aCollection.

    stream nextPut: $[.
    first := true.
    aCollection do:[:val |
       first ifFalse: [ stream nextPut: $, ].
       val acceptVisitor:self with:aParameter.
       first := false
    ].
    stream nextPut: $].

    "Created: / 27-08-2007 / 11:19:17 / cg"
    "Modified: / 13-06-2018 / 20:00:59 / Claus Gittinger"
!

visitString:aString with:aParameter
    stream nextPut: $".
    aString do:[:char |
       |code f |

       code := char codePoint.
       (((code == 16r20
          or: [ code == 16r21 ])
          or: [ code between:16r23 and:16r5B ])
          or: [ code >= 16r5D ])
             ifTrue: [ stream nextPut: char ]
             ifFalse: [
                f := false.
                stream nextPut: $\.
                code = 16r22 ifTrue: [ f := true. stream nextPut: char ].
                code = 16r5C ifTrue: [ f := true. stream nextPut: char ].
                code = 16r2F ifTrue: [ f := true. stream nextPut: char ].
                code = 16r08 ifTrue: [ f := true. stream nextPut: $b ].
                code = 16r0C ifTrue: [ f := true. stream nextPut: $f ].
                code = 16r0A ifTrue: [ f := true. stream nextPut: $n ].
                code = 16r0D ifTrue: [ f := true. stream nextPut: $r ].
                code = 16r09 ifTrue: [ f := true. stream nextPut: $t ].
                f ifFalse: [
                   stream nextPut: $u.
                   stream nextPutAll: (code printStringRadix:16 size:4 fill:$0) ].
             ]
    ].
    stream nextPut: $".

    "Created: / 27-08-2007 / 11:29:21 / cg"
    "Modified: / 12-11-2017 / 12:45:29 / cg"
!

visitTime:aTime with:aParameter
    self useISODateFormat ifTrue:[
        stream 
            nextPutAll: '"';
            nextPutAll: (aTime printStringIso8601);
            nextPutAll: '"'
    ] ifFalse:[
        stream 
            nextPutAll: 'new Time(' ;
            print: (aTime hourInDay);
            nextPutAll:',' ;
            print: (aTime minuteInDay) printString;
            nextPutAll:',' ;
            print: (aTime secondInDay);
            nextPutAll:')'.
    ].

    "
     JSONReader encode:{ Time now }
     JSONPrinter new 
        useISODateFormat:false; 
        encode:{ Time now }

     JSONReader decode:(JSONReader encode:{ Time now })
     JSONReader decode:(JSONPrinter new 
                            useISODateFormat:false; 
                            encode:{ Time now })
    "
!

visitTimestamp:aTimestamp with:aParameter 
    |nameOfMonth timestampString|

    self useISODateFormat ifTrue:[
        stream 
            nextPutAll: '"';
            nextPutAll: (aTimestamp printStringIso8601);
            nextPutAll: '"'
    ] ifFalse:[
        "Month dd, yyyy hh:mm:ss"
        nameOfMonth := Date abbreviatedNameOfMonth: aTimestamp month.

        timestampString := String streamContents:[:s |
            s nextPutAll: nameOfMonth asUppercaseFirst; nextPutAll:' '.
            aTimestamp printOn: s format:'%(day), %(year) %h:%m:%s'.
        ].

        stream 
            nextPutAll: 'new Date("'; nextPutAll: timestampString; nextPutAll: '")'.
    ].
! !

!JSONPrinter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/JSONPrinter.st,v 1.27 2018-08-05 11:41:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/JSONPrinter.st,v 1.27 2018-08-05 11:41:36 cg Exp $'
! !

