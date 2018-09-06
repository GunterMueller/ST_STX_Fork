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

SequenceableCollection subclass:#Cons
	instanceVariableNames:'car cdr'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Linked'
!

!Cons class methodsFor:'documentation'!

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
    A pair as in lisp.
        Cons car:a cdr:b

    Conses are not heavily used by Smalltalk (actually: not at all).
    Consider this a demo class.

    [author:]
        Claus Gittinger (Jun 2002)

    [see also:]

"
!

examples
"
                                                                        [exBegin]
    |p1 p2 p3|

    p3 := Cons car:3 cdr:nil.
    p2 := Cons car:2 cdr:p3.
    p1 := Cons car:1 cdr:p2.
    p1 head.
    p1 tail.
    p1 size.
    p1 do:[:each | Transcript showCR:each].
    p1 at:2
                                                                        [exEnd]
"
! !

!Cons class methodsFor:'instance creation'!

car:carArg cdr:cdrArg
    ^ self basicNew car:carArg cdr:cdrArg
!

fromArray:anArray
    |p last first|

    anArray do:[:el |
        p := self car:el cdr:nil.
        first isNil ifTrue:[
            first := p.
        ] ifFalse:[
            last cdr:p.
        ].
        last := p.
    ].
    ^ first.

    "
     Cons fromArray:#(1 2 3 4)   
     Cons fromArray:#()    
     Cons fromArray:#(1)    
     Cons fromArray:(1 to:10000)    
    "
!

makeList:size
    |first prev this|

    size == 0 ifTrue:[^ nil].

    first := prev := self car:nil cdr:nil.
    2 to:size do:[:n |
        this := self car:nil cdr:nil.
        prev cdr:this.
        prev := this
    ].
    ^ first

    "
     (self makeList:0) size    
     (self makeList:1) size    
     (self makeList:100) size
     (self makeList:1000) size 
     (self makeList:10000) size 
    "

    "Created: / 28-04-2011 / 00:37:11 / cg"
    "Modified: / 29-04-2011 / 10:38:11 / cg"
! !

!Cons class methodsFor:'sExpressions'!

readLispAtomFrom:aStream
    |chars n|

    aStream skipSeparators.
    aStream atEnd ifTrue:[^ nil].

    chars := aStream upToMatching:[:ch | ch isSeparator or:[ch = $( or:[ch = $)]]].
    (n := Number readFromString:chars onError:nil) notNil ifTrue:[
        "/ smalltalk allows +n; scheme does not
        (chars startsWith:'+') ifFalse:[
            ^ n
        ].
    ].
    ^ chars asSymbol

    "
     self readLispFrom:('(cons 1 2)' readStream).
     self readLispFrom:('(cons 1+ 2)' readStream).  
     self readLispFrom:('(cons +1 2)' readStream).
    "

    "Created: / 08-08-2010 / 17:15:18 / cg"
!

readLispFrom:aStream
    [
        aStream skipSeparators.
        aStream atEnd ifTrue:[^ nil].

        aStream peek ==$; ifFalse:[
            aStream peek ==$( ifTrue:[
                ^ self readLispListFrom:aStream
            ].
            ^ self readLispAtomFrom:aStream
        ].
        "/ EOL comment
        aStream skipLine.
    ] loop
    
    "
     self readLispFrom:('(cons 1 2)' readStream).
    "

    "Created: / 08-08-2010 / 17:07:49 / cg"
!

readLispListFrom:aStream
    |first this prev element|

    aStream next.   "/ the leading '('
    [
        aStream skipSeparators.
        aStream peek ~= $)
    ] whileTrue:[
        element := self readLispFrom:aStream.
        this := self car:element cdr:nil.
        prev isNil ifTrue:[
            first := this
        ] ifFalse:[
            prev cdr:this.
        ].
        prev := this.
    ].

    aStream next.   "/ the trailing ')'
    ^ first.

    "
     self readLispFrom:('(cons 1 2)' readStream).
    "

    "Modified: / 08-08-2010 / 17:15:54 / cg"
! !

!Cons methodsFor:'accessing'!

at:n
    "for collection compatibility:
     a slow indexed accessor"

    ^ (self nth:n)

    "
     (Cons fromArray:#(1))       at:1     
     (Cons fromArray:#(1 2 3 4)) at:1 
     (Cons fromArray:#(1 2 3 4)) at:3  
     (Cons fromArray:#(1 2 3 4)) at:4  
     (Cons fromArray:#(1 2 3 4)) at:5  
    "
!

at:n put:newValue
    "destructive: 
     for collection compatibility: a slow indexed accessor"

    (self nthPair:n) car:newValue.
    ^ newValue.

    "
     |l|

     l := Cons fromArray:#(1 2 3 4).
     l at:1 put:'one'.
     l at:3 put:'three'.
     l       
    "
!

first
    "return the head, first or car - whatever you wonna call it"

    ^ car

    "Modified: / 08-08-2010 / 17:04:23 / cg"
!

head
    "return the head, first or car - whatever you wonna call it"

    ^ car

    "Modified: / 08-08-2010 / 17:04:20 / cg"
!

last
    "for lispers:
     return the last element of a list"

    |p rest|

    p := self.
    [(rest := p cdr) notNil] whileTrue:[
        p := rest
    ].
    ^ p car

    "
     (Cons fromArray:#(1))       last     
     (Cons fromArray:#(1 2 3 4)) last    
    "
!

nth:n
    "for lispers:
     return the nth element of a list"

    ^ (self nthPair:n) car

    "
     (Cons fromArray:#(1))       nth:1     
     (Cons fromArray:#(1 2 3 4)) nth:1 
     (Cons fromArray:#(1 2 3 4)) nth:3  
     (Cons fromArray:#(1 2 3 4)) nth:4  
     (Cons fromArray:#(1 2 3 4)) nth:5  
     (Cons fromArray:#( ))       nth:1  -> error    
    "
!

rest
    "return the tail, rest or cdr - whatever you wonna call it"

    ^ cdr

    "Modified: / 08-08-2010 / 17:04:48 / cg"
!

reversed
    "for lispers:
     return a new list with the cars in reverse order"

"/ for now, tail recursion is not yet optimized by the st/x jitter...
"/
"/    |rev|
"/
"/    rev := [:lst :acc |
"/                lst isNil ifTrue:[
"/                    acc
"/                ] ifFalse:[
"/                    rev value:(lst tail)
"/                        value:(Cons car:(lst head) cdr:acc)
"/                ]
"/           ].
"/    ^ rev value:self value:nil

    | lst acc|

    lst := self.
    acc := nil.

    [
        |nLst nAcc|

        lst isNil ifTrue:[ ^ acc].

        nLst := lst tail.
        nAcc := Cons car:(lst head) cdr:acc.
        lst := nLst.
        acc := nAcc.
   ] loop

    "
     (Cons fromArray:#(1))       reversed     
     (Cons fromArray:#(1 2))     reversed     
     (Cons fromArray:#(1 2 3 4)) reversed    
     (Cons fromArray:(1 to:10000)) reversed    
    "
!

tail
    "return the tail, rest or cdr - whatever you wonna call it"

    ^ cdr

    "Modified: / 08-08-2010 / 17:04:59 / cg"
! !

!Cons methodsFor:'accessing - basic'!

cadddr
    "return the fourth element"

    ^ cdr cdr cdr car

    "Created: / 08-08-2010 / 17:29:40 / cg"
!

caddr
    "return the third element"

    ^ cdr cdr car

    "Created: / 08-08-2010 / 17:29:32 / cg"
!

cadr
    "return the second element"

    ^ cdr car

    "Created: / 08-08-2010 / 17:29:25 / cg"
!

car
    "return the head, first or car - whatever you wonna call it"

    ^ car
!

car:something
    "set the head, first or car - whatever you wonna call it"

    car := something.
!

car:carArg cdr:cdrArg 
    "set both car and cdr"

    car := carArg.
    cdr := cdrArg.
!

cddr
    "return the rest after the second element"

    ^ cdr cdr

    "Created: / 08-08-2010 / 17:47:11 / cg"
!

cdr
    "return the tail, second or cdr - whatever you wonna call it"

    ^ cdr
!

cdr:something
    "set the tail, second or cdr - whatever you wonna call it"

    cdr := something.
!

first:carArg rest:cdrArg 
    "set both car and cdr"

    car := carArg.
    cdr := cdrArg.
!

head:carArg tail:cdrArg 
    "set both car and cdr"

    car := carArg.
    cdr := cdrArg.
!

nthPair:n
    "a helper:
     return the nth pair of a list"

    |cnt p|

    cnt := n.
    p := self.
    [
        cnt := cnt - 1.
        cnt == 0 ifTrue:[^ p].

        p := p cdr.
        p isNil ifTrue:[
            self error:'no such element' mayProceed:true.
            ^ nil
        ].
    ] loop.
! !

!Cons methodsFor:'comparing'!

= aCons
    ^ aCons class == self class
    and:[ car = aCons car
    and:[ cdr = aCons cdr ]]
!

hash
    ^ car hash bitXor: cdr hash
! !

!Cons methodsFor:'enumerating'!

do:aBlock
    "evaluate aBlock for each car"

    |ptr|

    aBlock value:car.
    ptr := cdr.
    [ ptr notNil ] whileTrue:[
        aBlock value:ptr car.
        ptr := ptr cdr.
    ].

    "Modified: / 08-08-2010 / 17:33:44 / cg"
! !

!Cons methodsFor:'list processing'!

append:aCons
    "for lispers:
     append the arg. Return a new list, where the 2nd part is shared.
     Destructive: the receivers last cdr is modified."

    |p rest|

    p := self.
    [(rest := p cdr) notNil] whileTrue:[
        p := rest
    ].
    p cdr:aCons.
    ^ self

    "
     (Cons fromArray:#(1 2 3 4)) 
        append:(Cons fromArray:#(5 6 7 8)) 
    "

    "sharing demonstrated:

     |a b ab|

     a := Cons fromArray:#(1 2 3 4).
     b := Cons fromArray:#(5 6 7 8).
     ab := a append:b.
     b car:'five'.
     ab      
    "

    "destruction demonstrated:

     |a b ab|

     a := Cons fromArray:#(1 2 3 4).
     b := Cons fromArray:#(5 6 7 8).
     ab := a append:b.
     a  
    "
!

take:nTaken
    "for lispers:
     take n elements from the list; return a new list"

    |nRemain l rslt lastCons cons|

    nTaken > 0 ifTrue:[
        "/ avoiding recursion here...
        "/ instead of:
        "/        ^ Cons car:(self car) cdr:(self cdr take:nTaken-1)
        "/ we do:
        nRemain := nTaken.
        l := self.
        rslt := lastCons := Cons car:(l car) cdr:nil.
        [nRemain > 1] whileTrue:[
            l := l cdr.
            cons := Cons car:(l car) cdr:nil.    
            lastCons cdr:cons.
            lastCons := cons.
            nRemain := nRemain - 1.
        ].
        ^ rslt.
    ].
    ^ nil

    "
     (Cons fromArray:#(1 2 3 4)) take:3  
     (Cons fromArray:#(1)) take:0  
     (Cons fromArray:#()) take:3  
     (Cons fromArray:(1 to: 1000)) take:999  

     |gen allNumbers|
     gen := [:n | LazyCons car:n cdr:[ gen value:n+1 ]].
     allNumbers := gen value:1. 
     allNumbers take:10
    "

    "Modified (comment): / 27-09-2011 / 11:31:38 / cg"
! !

!Cons methodsFor:'printing'!

displayString
    ^ self printString
!

printOn:aStream
    thisContext isRecursive ifTrue:[ 
        'Cons [error]: printOn: of self referencing collection.' errorPrintCR.
        aStream nextPutAll:'#("recursive")'.
        ^ self.
    ].

    (car isLazyValue not and:[ car isCons ]) ifTrue:[
        aStream nextPutAll:'('.
        car printOn:aStream.
        aStream nextPutAll:')'.
    ] ifFalse:[
        car printOn:aStream.
    ].

    aStream nextPutAll:'!!'.

    (cdr isLazyValue not and:[ cdr isCons ]) ifTrue:[
        aStream nextPutAll:'('.
        cdr printOn:aStream.
        aStream nextPutAll:')'.
    ] ifFalse:[
        cdr printOn:aStream.
    ].

    "Modified: / 18-05-2010 / 10:25:49 / cg"
! !

!Cons methodsFor:'queries'!

beginAndSizeOfCycle
    "return the begin and size of a cycle, if the list contains one.
     Nil otherwise.
     Floyd's cycle-finding algorithm"

    |t h i loopStartIndex loopSize|

    t := self cdr. t isNil ifTrue:[^ nil].
    h := t cdr. h isNil ifTrue:[^ nil].

    [t ~~ h] whileTrue:[
        t := t cdr.
        h := h cdr. h isNil ifTrue:[^ nil].
        h := h cdr. h isNil ifTrue:[^ nil].
    ].

    "/ both h and t are now inside the cycle,
    "/ equidistant from the start of the cycle
    t := self.
    i := 1.
    [t ~~ h] whileTrue:[
        t := t cdr.
        h := h cdr.
        i := i + 1.
    ].
    loopStartIndex := i.

    loopSize := 1.
    h := t cdr.
    [t ~~ h] whileTrue:[
        h := h cdr.
        i := i + 1.
        loopSize := loopSize + 1.
    ].
    
    ^ { loopStartIndex. loopSize }

    "
     |n1 n2 n3 n4 n5|

     n1 := Cons new car:1.
     n2 := Cons new car:2.
     n3 := Cons new car:3.
     n4 := Cons new car:4.
     n5 := Cons new car:5.
     n1 cdr: n2.
     n2 cdr: n3.
     n3 cdr: n4.
     n4 cdr: n5.
     n1 beginAndSizeOfCycle.      
     n5 cdr: n3.    
     n1 beginAndSizeOfCycle.             
    "

    "Created: / 27-07-2012 / 00:00:36 / cg"
!

isCyclic
    "true if the list contains a cycle"

    ^ self beginAndSizeOfCycle notNil

    "
     |n1 n2 n3 n4 n5|

     n1 := Cons new car:1.
     n2 := Cons new car:2.
     n3 := Cons new car:3.
     n4 := Cons new car:4.
     n5 := Cons new car:5.
     n1 cdr: n2.
     n2 cdr: n3.
     n3 cdr: n4.
     n4 cdr: n5.
     n1 isCyclic.
     n5 cdr: n3.    
     n1 isCyclic.   
    "

    "Created: / 26-07-2012 / 23:32:52 / cg"
!

size
    "the list's length"

    |len p rest|

    len := 1.
    p := self.

    [
        p isLazyValue not
        and:[ (rest := p cdr) notNil ]
    ] whileTrue:[
        len := len + 1.
        p := rest
    ].
    ^ len

    "
     (Cons fromArray:#(1)) size       
     (Cons fromArray:#(1 2 3 4)) size    
     (Cons car:1 cdr:2) size          --> error (degenerated list)
    "
! !

!Cons methodsFor:'streaming'!

readStream
    ^ ConsStream on:self.
! !

!Cons methodsFor:'testing'!

isCons
    ^ true
!

isLazy
    ^ false
! !

!Cons class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

