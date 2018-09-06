"{ Package: 'stx:libbasic2' }"

Object subclass:#RandomParkMillerUsingFloat
	instanceVariableNames:'seed a m q r'
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!RandomParkMillerUsingFloat class methodsFor:'documentation'!

documentation
"
    Like RandomParkMiller, but using floats (instead of LargeInts).
    This makes this one roughly 4 times faster.

    Please read:
        Standard reference by Park and Miller in 
            'Random Number Generators: Good Ones Are Hard to Find',
        Comm. ACM, 31:1192-1201, 1988.

    [see also:]
        Random  - fast, but generates less quality random numbers
        RandomTT800 - another random generator
"
!

testing
"

    |r|

    r := self new.
    (1 to:10) collect:[:i | r next]

    -> should be
        #(
            0.1492432697 
            0.3316330217 
            0.7561964480 
            0.3937015400 
            0.9417831814 
            0.5499291939 
            0.6599625962 
            0.9913545591 
            0.6960744326 
            0.9229878997
        #)
"
! !

!RandomParkMillerUsingFloat class methodsFor:'initialization'!

initialize
    PMa := 16807.
    PMm := 2147483647.    " magic constant = 16807 "
    PMq := 127773.        " magic constant = 2147483647 "
    PMr := 2836.          " quotient (m quo: a) = 44488 "
    PMmu1 := 4.65661E-10  " remainder (m \\ a). = 2836 "
! !

!RandomParkMillerUsingFloat class methodsFor:'instance creation'!

new
    self initialize.
    ^ super new initialize
! !

!RandomParkMillerUsingFloat methodsFor:'accessing-reading'!

next
    " This method generates random instances of Float in the interval 0.0 to 1.0 "

    seed := self peekValue.
    ^ seed / m
!

nextInteger
    " This method generates random instances of Integer in the interval 0 to 16r7FFFFFFF. "

    seed := self peekValue.
    ^ seed

    "
     self new next
     self new nextInteger
    "
! !

!RandomParkMillerUsingFloat methodsFor:'initialization'!

initialize
    " Set a reasonable Park-Miller starting seed "

    [
        seed := (Time millisecondClockValue bitAnd: 16r3FFFFFFF) bitXor: self hash.
        seed = 0
    ] whileTrue: ["Try again if ever get a seed = 0"].

    a := 16r000041A7 asFloat.    " magic constant =      16807 "
    m := 16r7FFFFFFF asFloat.    " magic constant = 2147483647 "
    q := (m quo: a) asFloat.
    r  := (m \\ a) asFloat.
!

seed:anInteger 
    seed := anInteger
! !

!RandomParkMillerUsingFloat methodsFor:'private'!

peek
    " This method answers the next random number that will be generated as a Float in the range [0..1). 
      It answers the same value for all successive message sends. "

    ^ self peekValue / m
!

peekValue
    "This method generates random instances of Integer  in the interval
    0 to 16r7FFFFFFF. This method does NOT update the seed; repeated sends
    answer the same value.
    The algorithm is described in detail in 'Random Number Generators: 
    Good Ones Are Hard to Find' by Stephen K. Park and Keith W. Miller 
    (Comm. Asso. Comp. Mach., 31(10):1192--1201, 1988)."

    |lo hi aLoRHi|

    hi := (seed quo:q) asFloat.
    lo := seed - (hi * q).
    aLoRHi := (a * lo) - (r * hi).
    (aLoRHi > 0) ifTrue:[ ^ aLoRHi ].
    ^ aLoRHi + m
! !

!RandomParkMillerUsingFloat class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/RandomParkMillerUsingFloat.st,v 1.1 2008-12-16 22:39:51 cg Exp $'
! !

RandomParkMillerUsingFloat initialize!
