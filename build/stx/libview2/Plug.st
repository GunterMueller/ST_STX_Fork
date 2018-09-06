"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'stx:libview2' }"

Model subclass:#Plug
	instanceVariableNames:'simulatedProtocol inheritedClasses'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Objects'
!

!Plug class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    A Plug is an object which simulates a protocol and evaluates
    a corresponding block when receiving messages.
    A plug's interface can be changed dynamically.
    A plug can also be told to simulate inheriting messages from other classes,
    even multiple inheritance is possible.

    Its main use is for the demo doIts, to play the role of a model,
    when no actual modelClass is available for the demonstration.
    However, it can be used wherever some object is needed which responds to
    some protocol AND you do not want to add a class for it
    (lightWeight objects).

    There is a slight performance penalty - compared to `normal' objects,
    getting `normal' messages, though.

    [author:]
        Claus Gittinger

    [see also:]
        Model
"
!

examples
"
  a simple plug:
                                                                        [exBegin]
        |plug|

        plug := Plug new.
        plug respondTo:#foo  with:[Transcript showCR:'Plug received foo'].
        plug respondTo:#foo: with:[:arg | Transcript showCR:'Plug received foo: ', arg printString].

        plug foo.
        plug foo:'some argument'
                                                                        [exEnd]


  using a plug as a generator (simulates a readStream):
                                                                        [exBegin]
        |generator num|

        num := 0.
        generator := Plug new.
        generator respondTo:#next   with:[num := num + 1. num].
        generator respondTo:#atEnd  with:[false].

        10 timesRepeat:[
            Transcript showCR:(generator next)
        ]
                                                                        [exEnd]


  simulating a big collection:
                                                                        [exBegin]
        |virtualList|

        virtualList := Plug new.
        virtualList inheritFrom:SequenceableCollection.
        virtualList respondTo:#size with:[ 1000000 ].
        virtualList respondTo:#at:  with:[:lineNr | 'List line Nr. ' , lineNr printString ].
        virtualList inspect.
                                                                        [exEnd]


  simulating ``instance variables'':
  (actually, this is somewhat expensive - the contexts locals are used for them ...)
  be careful with unintended variable sharing (if plugs are created in a loop ..)
                                                                        [exBegin]
        |plug1 plug2 local1 local2|

        plug1 := Plug new.
        plug1 respondTo:#get  with:[local1].
        plug1 respondTo:#set: with:[:arg | local1 := arg].

        plug2 := Plug new.
        plug2 respondTo:#get  with:[local2].
        plug2 respondTo:#set: with:[:arg | local2 := arg].

        Transcript show:'plug1''s value: '; showCR:plug1 get.
        Transcript show:'plug2''s value: '; showCR:plug2 get.

        plug1 set:5.
        plug2 set:17.

        Transcript show:'plug1''s value: '; showCR:plug1 get.
        Transcript show:'plug2''s value: '; showCR:plug2 get.
                                                                        [exEnd]


  simulating a big list in a ListView 
  (real applications would read the lines from a database or file):
                                                                        [exBegin]
        |virtualList top lv|

        virtualList := Plug new.
        virtualList inheritFrom:SequenceableCollection.
        virtualList respondTo:#size with:[ 1000000 ].
        virtualList respondTo:#at:  with:[:lineNr | 'List line Nr. ' , lineNr printString ].

        top := StandardSystemView extent:200@200.

        lv := ScrollableView for:ListView in:top.
        lv origin:0.0 @ 0.0 corner:1.0 @ 1.0. 
        lv list:virtualList expandTabs:false scanForNonStrings:false includesNonStrings:false.

        top open.
                                                                        [exEnd]
"
! !

!Plug class methodsFor:'instance creation'!

new
    ^ super basicNew privateInitialize

    "Modified: 27.4.1996 / 16:16:59 / cg"
! !

!Plug methodsFor:'initialization'!

privateInitialize
    "this method is NOT called `#initialize' to allow plugging that
     selector ..."

    simulatedProtocol := IdentityDictionary new.

    "Modified: 27.4.1996 / 16:15:45 / cg"
    "Created: 27.4.1996 / 16:17:07 / cg"
! !

!Plug methodsFor:'message sending'!

at:key
    "catch this one - its so common"

    ^ self doesNotUnderstand:(Message selector:#at: arguments:(Array with:key))
!

at:key put:value
    ^ self doesNotUnderstand:(Message selector:#at:put: arguments:(Array with:key with:value))
!

doesNotUnderstand:aMessage
    "catch unhandled messages by looking in my simulated protocol
     definition; if there is some block for it, return its value.
     Otherwise, fall into the real doesNotUnderstand error."

    |block|

    block := simulatedProtocol at:(aMessage selector) ifAbsent:[].
    block notNil ifTrue:[
        ^ block valueWithArguments:(aMessage arguments)
    ].
    inheritedClasses notNil ifTrue:[
        inheritedClasses do:[:eachClass |
            |method|

            method := eachClass lookupMethodFor:(aMessage selector).
            method notNil ifTrue:[
                ^ method valueWithReceiver:self arguments:(aMessage arguments).
            ].
        ].
    ].
    ^ super doesNotUnderstand:aMessage

    "Modified: 27.4.1996 / 16:15:34 / cg"
!

isSequenceable
    "catch this one - its so common"

    ^ self doesNotUnderstand:(Message selector:#isSequenceable arguments:#())
!

size
    "catch this one - its so common"

    ^ self doesNotUnderstand:(Message selector:#size arguments:#())
!

update:something with:aParameter from:changedObject
    "catch unhandled messages by looking in my simulated protocol
     definition; if there is some block for it, return its value.
     Otherwise, fall into the real update."

    |block|

    block := simulatedProtocol at:#'update:with:from:' ifAbsent:[].
    block isNil ifTrue:[
        ^ super update:something with:aParameter from:changedObject
    ].
    ^ block valueWithArguments:(Array with:something with:aParameter with:changedObject)

!

value
    "catch this one - its so common"

    |block|

    block := simulatedProtocol at:#value ifAbsent:[].
    block isNil ifTrue:[
        ^ self
    ].
    ^ block valueWithArguments:#()
!

value:arg
    "catch this one - its so common"

    ^ self doesNotUnderstand:(Message selector:#value: argument:arg)

    "Created: 21.1.1997 / 15:21:36 / cg"
! !

!Plug methodsFor:'protocol definition'!

forgetAbout:aSelector
    "tell the receiver to forget about how to respond to the given by selector"

    simulatedProtocol removeKey:aSelector ifAbsent:nil

    "
     |p|

     p := Plug new.
     p respondTo:#foo  with:[Transcript showCR:'foo'].
     p respondTo:#foo: with:[:arg | Transcript show:'foo:'; showCR:arg].

     p foo.
     p foo:'hello'.

     p forgetAbout:#foo.

     p foo.
    "

    "Modified: 27.4.1996 / 16:14:19 / cg"
    "Created: 27.4.1996 / 16:19:08 / cg"
!

inheritFrom:aClass
    "very tricky - change the inheritance.
     This cannot be done by changing my class directly, because the instance layout
     must still be correct for Plugs instance variables.
     Therefore, the inheritance is remembered, and done dynamically in the doesNotUnderstand
     implementation."

    self assert:(aClass instSize == 0).
    inheritedClasses isNil ifTrue:[
        inheritedClasses := Array with:aClass
    ] ifFalse:[
        inheritedClasses := inheritedClasses copyWith:aClass
    ].
!

respondTo:aSelector with:aBlock
    "tell the receiver to respond to a message given by selector,
     with evaluating aBlock. The number of arguments as defined by the 
     selector must match the number of blockArsg expected by the block.
     The value returned from aBlock will be the value returned from the
     message."

    (self class includesSelector:aSelector) ifFalse:[
        (self class superclass canUnderstand:aSelector) ifTrue:[

            "/ sorry - this implementation is too quick of a hack.
            "/ (must be rewritten to inherit from nil, in order 
            "/  to be able to catch more ...)

            self error:'inherited message cannot be redefined: ' , aSelector.
        ]
    ].
    simulatedProtocol at:aSelector put:aBlock

    "
     |p|

     p := Plug new.
     p respondTo:#foo  with:[Transcript showCR:'foo'].
     p respondTo:#foo: with:[:arg | Transcript show:'foo:'; showCR:arg].

     p foo.
     p foo:'hello'
    "

    "Modified: 21.2.1997 / 18:35:07 / cg"
! !

!Plug methodsFor:'queries'!

respondsTo:aSelector
    "return true, if the receiver responds to a message"

    (simulatedProtocol includesKey:aSelector) ifTrue:[^ true].
    ^ super respondsTo:aSelector

    "Modified: 27.4.1996 / 16:14:41 / cg"
! !

!Plug class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/Plug.st,v 1.23 2006-02-14 11:08:47 cg Exp $'
! !
