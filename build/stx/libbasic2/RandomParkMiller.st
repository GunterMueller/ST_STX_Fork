"{ Package: 'stx:libbasic2' }"

Object subclass:#RandomParkMiller
	instanceVariableNames:'seed'
	classVariableNames:'PMa PMm PMmu1 PMq PMr'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!RandomParkMiller class methodsFor:'documentation'!

documentation
"
    Warning: this generator should not be used for cryptographic work.

    NO WARRANTY

    Another pseudo-random number generator

    The ParkMiller random generator (although better than the old Random), is not recommended 
    when a high quality random is required (for example, for cryptographic work). 
    Applications should use either the OS-random generator or a LaggedFibonacci generator.
    This is because the random values provided by the Park-Miller generator are double precision 
    floating point numbers which have up to 53 significant bits. Since only the first 31 bits 
    of their mantissa are known to have good random properties, the behavior of the remaining 
    22 bits is undefined. 
    In particular, bit aliasing occurs during the calculation of the next random value, 
    and bit 22 of the mantissa is always 1.

    Please read:
        Standard reference by Park and Miller in 
            'Random Number Generators: Good Ones Are Hard to Find',
        Comm. ACM, 31:1192-1201, 1988.

    [see also:]
        http://www0.cs.ucl.ac.uk/staff/d.jones/GoodPracticeRNG.pdf
        RandomGenerator - the default; uses the machine's /dev/random if available
        Random  - fast, but generates less quality random numbers
        RandomTT800 - another random generator
        RandomMT19937 - a better random generator
        RandomKISS - fast and better random generator
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

!RandomParkMiller class methodsFor:'initialization'!

initialize
    PMa := 16807.         " magic constant "
    PMm := 2147483647.    " magic constant "
    PMq := 127773.        " quotient (m quo: a) = 44488 "
    PMr := 2836.          " remainder (m \\ a). = 2836 "
    PMmu1 := 4.65661E-10  
! !

!RandomParkMiller class methodsFor:'instance creation'!

new
    self initialize.
    ^ super new initialize
! !

!RandomParkMiller methodsFor:'accessing-reading'!

next
    " This method generates random instances of Float in the interval 0.0 to 1.0 "

    seed := self nextInteger.
    ^ seed * PMmu1
!

nextBoolean
    " This method generates a boolean "

    ^ self next > 0.5
!

nextInteger
    " This method generates random instances of Integer in the interval 0 to 16r7FFFFFFF. "

    seed := self peekInteger.
    ^ seed
! !

!RandomParkMiller methodsFor:'initialization'!

initialize
    " Set a reasonable Park-Miller starting seed "

    seed := (Random randomSeed bitAnd:16rFFFFFFFF) "/ 2345678901
!

seed:anInteger 
    seed := anInteger
! !

!RandomParkMiller methodsFor:'private'!

peek
    " This method answers the next random number that will be generated as a Float in the range [0..1). 
      It answers the same value for all successive message sends. "

    ^ self peekInteger * PMmu1
!

peekInteger
    " This method generates random instances of Integer in the interval 0 to 16r7FFFFFFF. This method does NOT update the seed; repeated sends answer the same value. The algorithm is described in detail in 'Random Number Generators: Good Ones Are Hard to Find' by Stephen K. Park and Keith W. Miller, (Comm. Asso. Comp. Mach., 31(10):1192--1201, 1988). "

    |lo hi aLoRHi answer|

    hi := seed quo:PMq.
    lo := seed rem:PMq.
    aLoRHi := (PMa * lo) - (PMr * hi).
    (aLoRHi > 0) ifTrue:[ ^ aLoRHi ].
    ^ aLoRHi + PMm
! !

!RandomParkMiller class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/RandomParkMiller.st,v 1.11 2014-10-02 16:23:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/RandomParkMiller.st,v 1.11 2014-10-02 16:23:25 cg Exp $'
! !


RandomParkMiller initialize!
