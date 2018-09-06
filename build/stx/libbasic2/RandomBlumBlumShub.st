"{ Package: 'stx:libbasic2' }"

Object subclass:#RandomBlumBlumShub
	instanceVariableNames:'p q m seed'
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!RandomBlumBlumShub class methodsFor:'documentation'!

documentation
"
    NO WARRANTY

    This generator uses the blum blub shub algorithm to generate random numbers.
    It is very slow, but considered to provide good random numbers.

    RandomBlumBlumShub new nextInteger

    [see also:]
        RandomGenerator - the default; uses the machine's /dev/random if available
        Random  - fast, but generates less quality random numbers
        RandomTT800 - another random generator
        RandomParkMiller - another random generator
        RandomMT19937 - another random generator
        RandomKISS - another random generator
        exept:libcrypt - a library containing more stuff based on hashes and cyphers

    [author:]
        Claus Gittinger.
"
! !

!RandomBlumBlumShub class methodsFor:'instance creation'!

new
    ^ self basicNew 
        initialize;
        seed:(Random randomSeed)
!

new:seed
    self isSupported ifFalse:[ self error:'this generator needs a cpu with rdgen instruction' ].
    ^ self basicNew 
        initialize;
        seed:seed
! !

!RandomBlumBlumShub methodsFor:'initialization'!

initialize
    "The two primes, p and q, should both be congruent to 3 (mod 4)"

    p := 615389388455725613122981570401989286707.
    q := 8936277569639798554773638405675965349567.
    m := p * q.

    "/ (p \\ 4) = 3 ifFalse:[ self halt: 'unsuitable p' ].
    "/ (q \\ 4) = 3 ifFalse:[ self halt: 'unsuitable p' ].

    "
     self new initialize
    "
!

seed:seedArg
    seed := seedArg.

    self assert:(seed < m).
    self assert:(seed gcd:m) = 1.
! !

!RandomBlumBlumShub methodsFor:'random numbers'!

nextBoolean
    "generates the next random boolean"

    seed := seed*seed \\ m.
    ^ seed bitTest:1
!

nextInteger
    "generates the next integer in 0..FFFFFFFF"

    |num|

    num := 0.
    32 timesRepeat:[
        seed := (seed * seed) \\ m.
        num := (num<<1) + (seed bitAnd:1).
    ].
    ^ num.

    "
     self new nextInteger.

     |r|
     r := self new
     100 timesRepeat:[ Transcript showCR:r nextInteger].
    "
! !

!RandomBlumBlumShub class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/RandomBlumBlumShub.st,v 1.1 2014-10-02 16:24:30 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/RandomBlumBlumShub.st,v 1.1 2014-10-02 16:24:30 cg Exp $'
! !

