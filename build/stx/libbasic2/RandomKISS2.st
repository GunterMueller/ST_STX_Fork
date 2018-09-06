"{ Package: 'stx:libbasic2' }"

Object subclass:#RandomKISS2
	instanceVariableNames:'x y z c'
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!RandomKISS2 class methodsFor:'documentation'!

documentation
"
    Warning: this generator should not be used for cryptographic work.

    NO WARRANTY

    KISS combines a linear congruence, XorShift and Lag with carry geenrator.
    The idea is from George Marsaglia.
    KISS2 uses slightly different parameters and initial state.

    RandomKISS2 new nextInteger
    (RandomKISS2 new:5489) nextInteger

    If heavily used, it may be useful to embed the original C code as inline C code for a big speedup)

    Please read:
        http://www.cs.ucl.ac.uk/staff/d.jones/GoodPracticeRNG.pdf

    [see also:]
        RandomGenerator - the default; uses the machine's /dev/random if available
        Random  - fast, but generates less quality random numbers
        RandomTT800 - another random generator
        RandomParkMiller - another random generator
        RandomMT19937 - another random generator

    [author:]
        Ported to Smalltalk by Claus Gittinger.
"
! !

!RandomKISS2 class methodsFor:'instance creation'!

new
    ^ self basicNew 
        initialize;
        seed:(Random randomSeed bitAnd:16rFFFFFFFF)
!

new:seed
    ^ self basicNew 
        initialize;
        seed:seed
! !

!RandomKISS2 methodsFor:'initialization'!

initialize
    x := 123456789. "/ <- any seed !!= 0
    y := 987654321.
    z := 43219876.
    c := 6543217.
!

seed:seed
    self assert:(seed ~= 0).
    x := seed.
! !

!RandomKISS2 methodsFor:'random numbers'!

nextBoolean
    "generates a boolean random"

    ^ self nextInteger > 16r7FFFFFFF
!

nextInteger
    "generates the next integer in 0..FFFFFFFF"

    |t|

    "/ Linear Congruencegenerator
    x := (314527869 * x) + 1234567.
    x := x bitAnd:16rFFFFFFFF.

    "/ Xorshift
    y := y bitXor:(y << 5).
    y := y bitAnd:16rFFFFFFFF.
    y := y bitXor:(y >> 7).
    y := y bitAnd:16rFFFFFFFF.
    y := y bitXor:(y << 22).
    y := y bitAnd:16rFFFFFFFF.

    "/ Multiply-with-carry
    t := (4294584393 * z) + c.
    c := t >> 32.
    z := t bitAnd:16rFFFFFFFF.

    ^ (x + y + z) bitAnd:16rFFFFFFFF
! !

!RandomKISS2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/RandomKISS2.st,v 1.6 2014-10-02 16:23:21 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/RandomKISS2.st,v 1.6 2014-10-02 16:23:21 cg Exp $'
! !

