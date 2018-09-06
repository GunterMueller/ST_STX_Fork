"{ Package: 'stx:libbasic2' }"

Cons subclass:#LazyCons
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Linked'
!

!LazyCons class methodsFor:'documentation'!

documentation
"
    This is an experimental (academic ?) goody for demonstration purposes.

    A pair with lazy evaluation of the tail.
    Useful to implement infinite lists as possible in lazy functional languages.

    [author:]
        Claus Gittinger (Jun 2003)

    [see also:]
"
!

examples
"
  allNumbers represents an infinite list (1..)
                                                                            [exBegin]
    |gen allNumbers|

    gen := [:n | LazyCons car:n cdr:[ gen value:n+1 ]].
    allNumbers := gen value:1. 

    allNumbers head.   
    allNumbers tail head. 
    allNumbers tail tail head. 
                                                                            [exEnd]

  sieve
                                                                            [exBegin]
    |gen filter sieve primeNumberList|

    gen := [:n | LazyCons car:n cdr:[ gen value:n+1 ]].
    filter := [:n :l |
                |head rest|

                head := l car.
                rest := l cdr.
                (head \\ n) ~~ 0 ifTrue:[
                    LazyCons car:head cdr:[ filter value:n value:rest ].
                ] ifFalse:[
                    filter value:n value:rest.
                ]
              ].

    sieve := [:l |
                |prime rest|

                prime := l car.
                rest := l cdr.
                LazyCons car:prime cdr:[ sieve value:(filter value:prime value:rest) ]
             ].

    primeNumberList := sieve value:(gen value:2).
    primeNumberList
                                                                            [exEnd]
"
! !

!LazyCons methodsFor:'accessing - basic'!

cdr
    "return the tail, second or cdr - whatever you wonna call it.
     Here, the tail is evaluated. 
     This makes me a non-lazy cons."

    cdr := cdr value.
    self changeClassTo:Cons.
    ^ cdr

    "Modified (comment): / 27-09-2011 / 11:37:09 / cg"
!

isLazyValue
    ^ true
! !

!LazyCons class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/LazyCons.st,v 1.7 2014-06-25 17:19:02 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/LazyCons.st,v 1.7 2014-06-25 17:19:02 cg Exp $'
! !

