"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

ProtoObject subclass:#LazyValue
	instanceVariableNames:'result block lock'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

!LazyValue class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    I represent an expression which might not be needed.
    Any messages sent to me will force the evaluation (once).
    The value is remembered.

    Can be used to simulate non-strict programming languages.

    [see also:]
        Block Future LazyValue

    [author:]
        Claus Gittinger
"
!

examples
"
                                                        [exBegin]
    |x|

    x := LazyValue block:[ Transcript flash. 1234 ].
    Delay waitForSeconds:4.
    Transcript showCR:x printString
                                                        [exEnd]

  listFrom:n - an infinite list of integers starting with n
                                                        [exBegin]
    |gen infiniteList|

    gen := [:n |
                        Cons 
                            car:n 
                            cdr:( LazyValue block:[gen value:n+1] )
                   ].

    infiniteList := gen value:1.
    1 to:10 do:[:i |
        Transcript showCR:infiniteList car.
        infiniteList := infiniteList cdr.
    ].
                                                        [exEnd]

  filterOdd:l - an infinite list filtering odd numbers from another list
                                                        [exBegin]
    |gen infiniteList genOdd infiniteOdd|

    gen := [:n |
                        Cons 
                            car:n 
                            cdr:( LazyValue block:[gen value:n+1] )
                   ].

    infiniteList := gen value:1.

    genOdd := [:l |
                        |lR el|

                        lR := l.
                        [ el := lR car. lR := lR cdr. el odd ] whileFalse:[].
                        Cons 
                            car:el 
                            cdr:( LazyValue block:[genOdd value:lR] )
                   ].

    infiniteOdd := genOdd value:infiniteList.

    1 to:10 do:[:i |
        Transcript showCR:infiniteOdd car.
        infiniteOdd := infiniteOdd cdr.
    ].
                                                        [exEnd]

  powersOf:n - an infinite list of powers of n
                                                        [exBegin]
    |genPowersOf infiniteListOfPowers|

    genPowersOf := [:base |
                   |powersOfBase|

                   powersOfBase :=
                       [:n |
                            Cons 
                                car:n 
                                cdr:( LazyValue block:[powersOfBase value:n*base] )
                       ].
                   powersOfBase value:1.
                ].

    infiniteListOfPowers := genPowersOf value:2.
    1 to:10 do:[:i |
        Transcript showCR:infiniteListOfPowers car.
        infiniteListOfPowers := infiniteListOfPowers cdr.
    ].
                                                        [exEnd]

  merge2:a _:b - merge 2 lists.
                                                        [exBegin]
    |genMerge2 l gen infiniteList genOdd infiniteOdd genEven infiniteEven genMerge|

    gen := [:n |
                        Cons 
                            car:n 
                            cdr:( LazyValue block:[gen value:n+1] )
                   ].

    infiniteList := gen value:1.

    genOdd := [:l |
                        |lR el|

                        lR := l.
                        [ el := lR car. lR := lR cdr. el odd ] whileFalse:[].
                        Cons 
                            car:el 
                            cdr:( LazyValue block:[genOdd value:lR] )
                   ].

    infiniteOdd := genOdd value:infiniteList.

    genEven := [:l |
                        |lR el|

                        lR := l.
                        [ el := lR car. lR := lR cdr. el even ] whileFalse:[].
                        Cons 
                            car:el 
                            cdr:( LazyValue block:[genEven value:lR] )
                   ].

    infiniteEven := genEven value:infiniteList.

    genMerge2 := [:a :b |
                   |nextA nextB|

                   nextA := a car.
                   nextB := b car.

                   nextA < nextB ifTrue:[
                       Cons 
                           car:nextA 
                           cdr:( LazyValue block:[genMerge2 value:(a cdr) value:b] )
                   ] ifFalse:[
                       Cons 
                           car:nextB 
                           cdr:( LazyValue block:[genMerge2 value:a value:(b cdr)] )
                   ].
                ].

    l := genMerge2 value:infiniteOdd value:infiniteEven.
    1 to:10 do:[:i |
        Transcript showCR:l car.
        l := l cdr.
    ].
                                                        [exEnd]
"
!

examples2
"
    Attention: for the examples below to work,
    you have to enable the Parsers AllowLazyValueExtension and
    the parsers AllowFunctionCallSyntaxForBlockEvaluation.
    (set the corresponding classVariables in Parser to true).

      Parser classVarAt:#AllowSTXSyntaxExtensions put:true.
      Parser classVarAt:#AllowLazyValueExtension put:true.
      Parser classVarAt:#AllowFunctionCallSyntaxForBlockEvaluation put:true.

    notice that this is just syntactic sugar: the 'FOO(arg)' notation is
    the same as 'FOO value:arg', and !!block is the same as 'LazyValue block:block'.
    BTW: the # is the binary Cons-message.
                                                        [exBegin]
    |x|

    x := !![ Transcript flash. 1234 ].
    Delay waitForSeconds:4.
    Transcript showCR:x printString
                                                        [exEnd]

  listFrom:n - an infinite list of integers starting with n
                                                        [exBegin]
    |GEN infiniteList|

    GEN := [:n | n # !![ GEN( n+1) ] ].

    infiniteList := GEN(1).
    1 to:10 do:[:i |
        Transcript showCR:infiniteList car.
        infiniteList := infiniteList cdr.
    ].
                                                        [exEnd]

  filterOdd:l - an infinite list filtering odd numbers from another list
                                                        [exBegin]
    |GEN infiniteList GENOdd infiniteOdd|

    GEN := [:n | n # !![ GEN(n+1) ] ].

    infiniteList := GEN(1).

    GENOdd := [:l |
                        |lR el|

                        lR := l.
                        [ 
                            el := lR car. 
                            lR := lR cdr. 
                            el odd 
                        ] whileFalse:[].
                        el # !![ GENOdd(lR) ]
                   ].

    infiniteOdd := GENOdd(infiniteList).

    1 to:10 do:[:i |
        Transcript showCR:infiniteOdd car.
        infiniteOdd := infiniteOdd cdr.
    ].
                                                        [exEnd]

  powersOf:n - an infinite list of powers of n
                                                        [exBegin]
    |GENPowersOf infiniteListOfPowers|

    GENPowersOf := [:base |
                   |powersOfBase|

                   powersOfBase := [:n | n # !![powersOfBase(n*base)]].
                   powersOfBase(1)
                ].

    infiniteListOfPowers := GENPowersOf(2).
    1 to:10 do:[:i |
        Transcript showCR:infiniteListOfPowers car.
        infiniteListOfPowers := infiniteListOfPowers cdr.
    ].
                                                        [exEnd]

  merge2:a _:b - merge 2 lists.
  the genODD and genEVEN setup is just for testing.
                                                        [exBegin]
    |GENMerge2 l GEN infiniteList GENFILTER GENOdd infiniteOdd GENEven infiniteEven GENMerge|

    GEN := [:n | n # !![GEN(n+1)] ].

    infiniteList := GEN(1).

    GENFILTER := [:l :filter|
                        |lR el|

                        lR := l.
                        [ el := lR car. lR := lR cdr. filter(el) ] whileFalse:[].
                        el # !![ GENFILTER(lR. filter) ] 
              ].

    GENOdd := [:l | GENFILTER(l. [:el | el odd])].
    infiniteOdd := GENOdd(infiniteList).

    GENEven := [:l | GENFILTER(l. [:el | el even])].
    infiniteEven := GENEven value:infiniteList.

    GENMerge2 := [:a :b |
                   |nextA nextB|

                   nextA := a car.
                   nextB := b car.

                   nextA < nextB ifTrue:[
                       nextA # !![ GENMerge2(a cdr . b)]
                   ] ifFalse:[
                       nextB # !![ GENMerge2(a . b cdr)]
                   ].
                ].

    l := GENMerge2(infiniteOdd .infiniteEven).
    1 to:10 do:[:i |
        Transcript showCR:l car.
        l := l cdr.
    ].
                                                        [exEnd]

  powersOf2 - generate 2^i for all i >= 0
                                                        [exBegin]
    |l GENPowersOf powersOf2|

    GENPowersOf := [:base |
                   |powersOfBase|

                   powersOfBase := [:n | n # !![powersOfBase value:n*base] ].
                   powersOfBase value:1.
                ].

    powersOf2 := GENPowersOf value:2.

    1 to:10 do:[:i |
        Transcript showCR:powersOf2 car.
        powersOf2 := powersOf2 cdr.
    ].
                                                        [exEnd]

  genPoly - generate 2^i + 3^j + 5^k for all i,j,k
  unfinished.
                                                        [exBegin]
    |GENPowersOf genMerge2 l gen  infiniteList powersOf2 powersOf3 powersOf5
     genAdd genMerge3|

    gen := [:n | Cons car:n cdr:( !![gen value:n+1] ) ].

    infiniteList := gen value:1.

    GENPowersOf := [:base |
                   |powersOfBase|

                   powersOfBase := [:n | n # !![powersOfBase value:n*base] ].
                   powersOfBase(1).
                ].

    powersOf2 := GENPowersOf(2).     '2^i' for all i
    powersOf3 := GENPowersOf(3).     '3^j' for all j
    powersOf5 := GENPowersOf(5).     '5^k' for all k

    genMerge3 := [:a :b :c|
                   |min nextA nextB nextC rA rB rC|

                   nextA := a car.
                   nextB := b car.
                   nextC := c car.
                
                   [ (nextB := rB car) = nextA ] whileTrue:[ rB := rB cdr ].

                   nextA < nextB ifTrue:[
                       'a is smallest'.
                       min := nextA.
                       rA := rA cdr.
                   ] ifFalse:[
                       'b is smallest'.
                       min := nextB.
                       rB := rB cdr.
                   ].

                   Cons 
                       car:min 
                       cdr:!![genMerge2 value:rA value:rB] 
                ].

    genMerge3 := [:a :b :c|
                   genMerge2(genMerge2(a . b) . c).
                ].

    l := genMerge3 value:powersOf2 value:powersOf3 value:powersOf5.
    1 to:10 do:[:i |
        Transcript showCR:l car.
        l := l cdr.
    ].
                                                        [exEnd]

"
! !

!LazyValue class methodsFor:'instance creation'!

block:aBlock
    ^ self new block:aBlock
! !

!LazyValue methodsFor:'printing'!

displayOn:aGCOrStream

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ self _evaluate_ displayOn:aGCOrStream
    ].

    block isNil ifTrue:[
        result displayOn:aGCOrStream.
        aGCOrStream nextPutAll:' (lazyValue evaluated)'.
        ^ self.
    ].    
    aGCOrStream nextPutAll:'LazyValue (unevaluated) block: '.
    block displayOn:aGCOrStream.
!

displayString
    |s|

    "/ attention: TextStream is not present in ultra-mini standalone apps
    s := TextStream isNil
            ifTrue:['' writeStream]
            ifFalse:[TextStream on:(String new:32)].
    self displayOn:s.
    ^ s contents
! !

!LazyValue methodsFor:'private access'!

block:aBlock
    block := aBlock.
    lock := Semaphore forMutualExclusion.
! !

!LazyValue methodsFor:'queries'!

class
    ^ self _evaluate_ class
! !

!LazyValue methodsFor:'synchronising'!

_evaluate_
    block notNil ifTrue:[
        lock wait.   "ensure that block is only executed once"
        block notNil ifTrue:[
            result := block value.
            block := nil.

            lock signalForAll.
            lock := nil.
        ].
    ].
    ^ result
!

doesNotUnderstand:aMessage
    block notNil ifTrue:[
        IsDebuggingQuery query ifTrue:[
            "enable debugging / inspecting without evaluating"
            ^ aMessage sendTo:self usingClass:Object.
        ].
        self _evaluate_.
    ].
    ^ aMessage sendTo:result
!

perform:aSelector withArguments:argArray
    "send the message aSelector with all args taken from argArray
     to the receiver."

    block notNil ifTrue:[
        IsDebuggingQuery query ifTrue:[
            "enable debugging / inspecting"
            ^ super perform:aSelector withArguments:argArray.
        ].
        self _evaluate_.
    ].
    ^ result perform:aSelector withArguments:argArray.
! !

!LazyValue methodsFor:'testing'!

isBehavior
    ^ self _evaluate_ isBehavior
!

isLazyValue
    ^ block notNil
! !

!LazyValue class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

