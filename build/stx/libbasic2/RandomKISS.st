"{ Package: 'stx:libbasic2' }"

Object subclass:#RandomKISS
	instanceVariableNames:'x y z c'
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!RandomKISS class methodsFor:'documentation'!

documentation
"
    Warning: this generator should not be used for cryptographic work.

    NO WARRANTY

    KISS combines a linear congruence, XorShift and Lag with carry geenrator.
    The idea is from George Marsaglia.

    RandomKISS new nextInteger
    (RandomKISS new:5489) nextInteger

    If heavily used, it may be useful to embed the original C code as inline C code for a big speedup)

    Please read:
        Wikipedia article on KISS http://de.wikipedia.org/wiki/KISS_(Zufallszahlengenerator)
        http://de.wikipedia.org/wiki/Liste_von_Zufallszahlengeneratoren
        http://eprint.iacr.org/2011/007.pdf  (KISS is not cryptographically secure)

    [see also:]
        http://www0.cs.ucl.ac.uk/staff/d.jones/GoodPracticeRNG.pdf
        RandomGenerator - the default; uses the machine's /dev/random if available
        Random  - fast, but generates less quality random numbers
        RandomTT800 - another random generator
        RandomParkMiller - another random generator
        RandomMT19937 - another random generator

    [author:]
        Ported to Smalltalk by Claus Gittinger.
"
! !

!RandomKISS class methodsFor:'instance creation'!

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

!RandomKISS methodsFor:'initialization'!

initialize
    x := 123456789. "/ <- any seed !!= 0
    y := 362436000.
    z := 521288629.
    c := 7654321.
!

seed:seed
    self assert:(seed ~= 0).
    x := seed.
! !

!RandomKISS methodsFor:'random numbers'!

nextBoolean
    "generates a boolean random"

    ^ self nextInteger > 16r7FFFFFFF
!

nextInteger
    "generates the next integer in 0..FFFFFFFF"

    |t|

    "/ Linear Congruencegenerator
    x := (69069 * x) + 12345.
    x := x bitAnd:16rFFFFFFFF.

    "/ Xorshift
    y := y bitXor:(y << 13).
    y := y bitXor:(y >> 17).
    y := y bitXor:(y << 5).
    y := y bitAnd:16rFFFFFFFF.

    "/ Multiply-with-carry
    t := (698769069 * z) + c.
    c := t >> 32.
    z := t bitAnd:16rFFFFFFFF.

    ^ (x + y + z) bitAnd:16rFFFFFFFF
! !

!RandomKISS class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/RandomKISS.st,v 1.7 2014-10-02 16:23:23 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/RandomKISS.st,v 1.7 2014-10-02 16:23:23 cg Exp $'
! !

