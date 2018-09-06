"{ Encoding: utf8 }"

"
======================================================================
|
| Copyright (C) 1988, 1989 Free Software Foundation, Inc.
| Written by Steve Byrne.
|
| This file is part of GNU Smalltalk.
|
| GNU Smalltalk is free software; you can redistribute it and/or modify it
| under the terms of the GNU General Public License as published by the Free
| Software Foundation; either version 1, or (at your option) any later version.
| 
| GNU Smalltalk is distributed in the hope that it will be useful, but WITHOUT
| ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
| FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
| details.
| 
| You should have received a copy of the GNU General Public License along with
| GNU Smalltalk; see the file LICENSE.  If not, write to the Free Software
| Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  
|
======================================================================

see notice in (Random>>documentation)
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Stream subclass:#Random
	instanceVariableNames:'seed increment multiplier modulus'
	classVariableNames:'SharedGenerator RandomSalt'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!Random class methodsFor:'documentation'!

copyright
"
======================================================================
|
| Copyright (C) 1988, 1989 Free Software Foundation, Inc.
| Written by Steve Byrne.
|
| This file is part of GNU Smalltalk.
|
| GNU Smalltalk is free software; you can redistribute it and/or modify it
| under the terms of the GNU General Public License as published by the Free
| Software Foundation; either version 1, or (at your option) any later version.
| 
| GNU Smalltalk is distributed in the hope that it will be useful, but WITHOUT
| ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
| FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
| details.
| 
| You should have received a copy of the GNU General Public License along with
| GNU Smalltalk; see the file LICENSE.  If not, write to the Free Software
| Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  
|
======================================================================

see notice in (Random>>documentation)
"
!

documentation
"
    Warning: this generator should not be used for cryptographic work 

    simple random numbers - thanks to Steves GNU Smalltalk

    This implements a linear congruential maximum period random number generator
    which passes the spectral test for randomness for dimensions 2 3 4 5 6.

    WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
    =======================================================================================
    DO NOT USE THIS GENERATOR FOR CRYPTOGRAPHY OR OTHER SECURITY RELATED WORK, 
    because linear congruential generators are predictable and can be broken easily!!

    Smalltalk/X includes a better generator named RandomGenerator, which uses the best
    available generator of the system (either OS-random, /dev/random or as a less dangerous
    fallback, an RC4-based random generator.
    Please use that one.
    =======================================================================================

    Notice: although being included here,
            this file is NOT covered by the ST/X license, but by
            the FSF copyLeft (see copyright method).

            You can redistribute it under the terms stated there ...
            Also, the price you pay for ST/X does not include a charge for
            this file - it has to be considered as a separate piece of
            software, which can be copied and given away without any 
            restriction from my (CG) side.

    [author:]
        Steve Byrne
        Claus Gittinger

    [see also:]
        http://www0.cs.ucl.ac.uk/staff/d.jones/GoodPracticeRNG.pdf
        RandomTT800      - a new random generator
        RandomParkMiller - another new random generator
"
!

examples
"
                                                                        [exBegin]
    |rnd|

    rnd := Random new.
    10 timesRepeat:[
        Transcript showCR:(rnd next)
    ]
                                                                        [exEnd]

    rolling a dice:
                                                                        [exBegin]
    |rnd|

    rnd := Random new.
    10 timesRepeat:[
        Transcript showCR:(rnd nextIntegerBetween:1 and:6)
    ]
                                                                        [exEnd]
"
! !

!Random class methodsFor:'instance creation'!

new
    "return a new random generator"

    ^ self basicNew initialize
!

random
    "return a new random generator.
     Defined here for compatibility with StreamCipher"

    ^ self new

    "Created: / 12.11.1999 / 17:52:08 / stefan"
!

seed:seedValue
    "return a new random generator with initial seed"

    ^self basicNew setSeed:seedValue

    "Created: / 26-05-2007 / 21:27:18 / cg"
!

sharedGenerator
    "return a shared random generator."

    SharedGenerator isNil ifTrue:[
        SharedGenerator := self new.
    ].
    ^ SharedGenerator
!

standard
    "return the 'standard' generator"

    ^ self new
! !

!Random class methodsFor:'random numbers'!

next
    "return the next random number in the range 0..1
     This method behaves like the corresponding instance method,
     but allows generation of random numbers without
     a need for an instance of Random to be kept around.
     This uses a common, shared generator."

    ^ self sharedGenerator next.

    "
     Transcript showCR:(Random next).
     Transcript showCR:(Random next).
     Transcript showCR:(Random next).
     Transcript showCR:(Random next).
    "
!

nextBetween:start and:stop
    "return a random number between start and stop.
     This method behaves like the corresponding instance method,
     but allows generation of random numbers without
     a need for an instance of Random to be kept around.
     This uses a common, shared generator."

    ^ self sharedGenerator nextBetween:start and:stop

    "
     Transcript showCR:(Random nextBetween:1 and:100).
     Transcript showCR:(Random nextBetween:1 and:100).
     Transcript showCR:(Random nextBetween:1 and:100).
     Transcript showCR:(Random nextBetween:1 and:100).
    "

    "Modified: 21.8.1997 / 18:08:56 / cg"
    "Created: 21.8.1997 / 18:09:36 / cg"
!

nextBoolean
    "return a boolean random.
     This method behaves like the corresponding instance method,
     but allows generation of random numbers without
     a need for an instance of Random to be kept around.
     This uses a common, shared generator."

    ^ self sharedGenerator nextBoolean.

    "
     Transcript showCR:(Random nextBoolean).
     Transcript showCR:(Random nextBoolean).
     Transcript showCR:(Random nextBoolean).
     Transcript showCR:(Random nextBoolean).
    "

    "Created: 21.8.1997 / 18:08:23 / cg"
!

nextInteger
    "return an integral random number.
     This method behaves like the corresponding instance method,
     but allows generation of random numbers without
     a need for an instance of Random to be kept around.
     This uses a common, shared generator."

    ^ self sharedGenerator nextInteger.

    "
     Transcript showCR:(Random nextInteger).
     Transcript showCR:(Random nextInteger).
     Transcript showCR:(Random nextInteger).
     Transcript showCR:(Random nextInteger).
    "

    "Created: 21.8.1997 / 18:08:23 / cg"
!

nextIntegerBetween:start and:stop
    "return an integral random number between start and stop.
     This method behaves like the corresponding instance method,
     but allows generation of random numbers without
     a need for an instance of Random to be kept around.
     This uses a common, shared generator."

    ^ self sharedGenerator nextIntegerBetween:start and:stop

    "
     Transcript showCR:(Random nextIntegerBetween:1 and:10).
     Transcript showCR:(Random nextIntegerBetween:1 and:10).
     Transcript showCR:(Random nextIntegerBetween:1 and:10).
     Transcript showCR:(Random nextIntegerBetween:1 and:10).
    "

    "Created: 21.8.1997 / 18:07:00 / cg"
    "Modified: 21.8.1997 / 18:08:56 / cg"
!

nextLettersOrDigits:count
    "get the next count printable letters or digits [0-9A-Za-z]."

    ^ self sharedGenerator nextLettersOrDigits:count

    "
     Transcript showCR:(Random nextLettersOrDigits:10).
     Transcript showCR:(Random nextLettersOrDigits:10).
     Transcript showCR:(Random nextLettersOrDigits:10).
     Transcript showCR:(Random nextLettersOrDigits:10).
    "

    "Created: 21.8.1997 / 18:07:00 / cg"
    "Modified: 21.8.1997 / 18:08:56 / cg"
! !

!Random class methodsFor:'seeding'!

randomSeed
    "return a number useful for seeding.
     This takes the current processor's time, plus the processor's process id,
     plus some value depending on the memory allocation state,
     plus a random salt, and shuffles those bits around.
     The entropy returned should be reasonable enough for a good seed of a good rnd
     generator. However, keep in mind, that it only has a limited number of entropy bits
     (in the order of 32). 
     But it should be much better than what is commonly used in older
     programs (current time) or even a constant."

    |hash|

    RandomSalt isNil ifTrue:[
        RandomSalt := 1.
    ] ifFalse:[
        RandomSalt := RandomSalt + 1.
    ].

    hash := MD5Stream new.
    hash 
        nextPut:RandomSalt;
        nextPut:Time microsecondClockValue; 
        nextPut:OperatingSystem getProcessId; 
        nextPut:(ObjectMemory addressOf:Object new); 
        nextPut:ObjectMemory oldSpaceUsed; 
        nextPut:ObjectMemory newSpaceUsed; 
        nextPut:OperatingSystem getCPUCycleCount. 

    "/ any other cheap sources of entropy?

    "/ I think there is no problem in that MD5 is not a secure hash algo here 
    "/ - the idea is to shuffle the bits around a bit
    "/ (because the numbers above usually have many high bits in common)
    "/ and then condense the bits into a smaller number.
    "/ Any comment from a crypto guy here - I am willing to change this to some other hash, if that makes a problem

    "/ Seeding rnd generators should take some bits from the returned number (i.e. their max. seed size)
    ^ LargeInteger digitBytes:hash hashValue.

    "
     10 timesRepeat:[Transcript showCR:self randomSeed].
     10 timesRepeat:[Transcript showCR:(self randomSeed bitAnd:16rFFFF)].
     self randomSeed bitAnd:16rFFFFFFFF
    "
! !

!Random class methodsFor:'testing'!

bucketTest: randy
    "A quick-and-dirty bucket test. Prints nbuckets values on the Transcript.
     Each should be 'near' the value of ntries. Any run with any value 'far' from ntries
     indicates something is very wrong. Each run generates different values.
     For a slightly better test, try values of nbuckets of 200-1000 or more; 
     go get coffee.
     This is a poor test; see Knuth.   
     Some 'OK' runs:
           1000 1023 998 969 997 1018 1030 1019 1054 985 1003
           1011 987 982 980 982 974 968 1044 976
           1029 1011 1025 1016 997 1019 991 954 968 999 991
           978 1035 995 988 1038 1009 988 993 976
    "

    | nbuckets buckets ntrys slot |

    nbuckets := 20.
    buckets := Array new: nbuckets withAll:0.
    ntrys :=  1000.
    ntrys*nbuckets timesRepeat: [
            slot := (randy next * nbuckets) floor + 1.
            buckets at: slot put: (buckets at: slot) + 1 ].
    Transcript cr.
    1 to: nbuckets do: [ :nb |
            Transcript show: (buckets at: nb) printString, ' ' ]


    "Execute this:  
         self bucketTest: self new
         self bucketTest: RandomGenerator new
    "
!

chiSquareTest   
    " Chi-Squared Test - from R.Sedgewick's 1st ed. of 'Algorithms', 
            o N = number of samples
            o r  = range of random numners is [0,r)      -- condition: N >= 10r.
            o Random number generator 'passes' if chisquare value is very close to r
            o Repeat test several times, since it may be *wrong* 1 out of 10 trials."

    | aGenerator frequencies n range t |

    aGenerator := self new.  "Seeded differently each time (if seeded at all)"
    range := 100.   
    n := 10000.
    frequencies := Array new:range withAll:0.

    1 to: n do: [:i |
        t := ((aGenerator next) * range) truncated + 1.
        frequencies at:t put: ((frequencies at:t) + 1).
    ].
    t := frequencies inject:0 into: [:nextValue :eachFreq |
            nextValue + eachFreq squared
        ].
    ^ ((range * t  / n) - n) asFloat.

    "
     self chiSquareTest 
     RandomGenerator chiSquareTest
    "

   "
    |fail|
    fail := 0.
    10 timesRepeat:[
        |testResult|
        testResult := RandomGenerator chiSquareTest.
        (100 - testResult) abs > 20 ifTrue:[Transcript showCR:testResult. fail := fail + 1].
    ].
    fail > 1 ifTrue:[self error:'test failed'].
    "

    "
      Sedgewick claims each chisquare number should be 100 +- 20. 
      The closer to 100, the better.
    "
! !

!Random methodsFor:'Compatibility-Squeak'!

nextInt:upperBound
    "Answer a random integer in the interval [1, anInteger]."

    (upperBound < 1) ifTrue:[self error:'invalid upper bound'].

    ^ self nextIntegerBetween:1 and:upperBound

    "
     Random new nextInt:10
    "
!

nextIntFrom:lowerBound to:upperBound
    "return a random integer in the given range"

    ^ self nextIntegerBetween:lowerBound and:upperBound

    "
     Random new nextIntFrom:5 to:10
    "
!

seed: anInteger
    self setSeed: anInteger.

    "Created: / 20-07-2013 / 01:52:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Random methodsFor:'accessing-reading'!

next
    "return the next random number in the range ]0..1["

    self step.
    ^ seed / modulus asFloat

    "
     |r|
     r := Random new.
     Transcript showCR:r next.
     Transcript showCR:r next.
     Transcript showCR:r next.
     Transcript showCR:r next.
    "

    "Modified: 1.4.1997 / 22:44:46 / cg"
!

nextBetween:start and:stop
    "return a random number in the range ]start..stop[.
     claus: the original GNU version has a bug in returning values
     from the interval [start .. stop+1]"

    |rnd|

    rnd := self next.
    rnd := rnd * (stop - start) asFloat.
    rnd := rnd + start asFloat.
    ^ rnd

    "|r|
     r := Random new.
     Transcript showCR:(r nextBetween:1 and:10).
     Transcript showCR:(r nextBetween:1 and:10).
     Transcript showCR:(r nextBetween:1 and:10).
     Transcript showCR:(r nextBetween:1 and:10).
    "

    "Modified: / 21.8.1998 / 14:45:27 / cg"
!

nextBoolean
    "return true or false by random"

    self step.
    ^ seed < (modulus // 2)

    "
    |r|
     r := Random new.
     Transcript showCR:r nextBoolean.
     Transcript showCR:r nextBoolean.
     Transcript showCR:r nextBoolean.
     Transcript showCR:r nextBoolean.
    "

    "
     |r bag|
     r := Random new.
     bag := Bag new.
     1000000 timesRepeat:[
         bag add:(r nextBoolean).
     ].
     Transcript showCR:bag contents
    "

    "Modified: / 22-10-2008 / 15:17:57 / cg"
!

nextByte
    "return the next integral random number byte in the range 0 .. 16rFF"

    self step.
    ^ seed bitAnd:16rFF

    "
     |r|
     r := self new.
     Transcript showCR:r nextByte.
     Transcript showCR:r nextByte.
     Transcript showCR:r nextByte.
     Transcript showCR:r nextByte.
    "

    "Modified: 1.4.1997 / 22:42:53 / cg"
!

nextBytes:count
    "return count random bytes (0..16rFF each)"

    |res cnt "{Class: SmallInteger}"|

    cnt := count.
    res := ByteArray uninitializedNew:cnt.

    1 to:cnt do:[:i|
        self step.
        res at:i put:(seed bitAnd:16rFF).
    ].

    ^ res

    "
     Transcript showCR:(Random new nextBytes:20).
    "

    "Modified: 1.4.1997 / 22:42:53 / cg"
!

nextCharacters:count
    "get the next cnt printable characters.
     We answer printable characters in the ascii range (codepoints 32 - 126)"

    |res cnt "{ Class:SmallInteger }"|

    cnt := count.
    res := String uninitializedNew:cnt.

    1 to:cnt do:[:i|
        self step.
        res at:i put:(Character value:(seed \\ 94 + 32)).
    ].

    ^ res

    "
      Random new nextCharacters:8
    "
!

nextInteger
    "return the next integral random number,
     in the range 0 .. modulus (which is less than 16r3FFFFFFF).
     From Sedgewick's 'Algorithms', based on Lehmer's method.

     Take care, this returns an even number after each odd number!!"

    self step.
    ^ seed

    "
     |r|
     r := Random new.
     Transcript showCR:r nextInteger.
     Transcript showCR:r nextInteger.
     Transcript showCR:r nextInteger.
     Transcript showCR:r nextInteger.
    "

    "Modified: 1.4.1997 / 22:42:53 / cg"
!

nextIntegerBetween:start and:stop
    "return an integral random number between start and stop"

    |rnd range bytesNeeded|

    range := stop - start + 1.

    range < modulus ifTrue:[
        "we need the float computation in order to not return alternate even and odd numbers"
        rnd := (self next * range) truncated.    
        ^ rnd + start.
    ] ifFalse:[
        bytesNeeded := (range highBit + 7) // 8.
        rnd := LargeInteger digitBytes:(self nextBytes:bytesNeeded).      
        rnd := rnd bitXor:(seed < (modulus//2) ifTrue:[0] ifFalse:[1]). "do not alternately return even and odd numbers"
        ^ start + (rnd \\ range).
    ].

    "
     |r|
     r := self new.
     Transcript showCR:(r nextIntegerBetween:1 and:10).
     Transcript showCR:(r nextIntegerBetween:1 and:10).
     Transcript showCR:(r nextIntegerBetween:1 and:10).
     Transcript showCR:(r nextIntegerBetween:1 and:10).
    "

    "
     |r|
     r := self new.
     Transcript showCR:(r nextIntegerBetween:1 and:1000000).
     Transcript showCR:(r nextIntegerBetween:1 and:1000000).
     Transcript showCR:(r nextIntegerBetween:1 and:1000000).
     Transcript showCR:(r nextIntegerBetween:1 and:1000000).
    "

    "
     |r bag|
     r := self new.
     bag := Bag new.
     1000000 timesRepeat:[
         bag add:(r nextIntegerBetween:-1 and:1).
     ].
     Transcript showCR:bag sortedCounts.
    "

    "
     |r bag|
     r := self new.
     bag := Bag new.
     1000000 timesRepeat:[
         bag add:(r nextIntegerBetween:1 and:3).
     ].
     Transcript showCR:bag sortedCounts.
     TestCase assert:(bag standardDeviation closeTo:(((3 squared - 1)/12) sqrt)).
    "

    "
     |r bag|
     r := self new.
     bag := Bag new.
     1000000 timesRepeat:[
         bag add:(r nextIntegerBetween:1 and:32).
     ].
     Transcript showCR:bag sortedCounts.
     TestCase assert:(bag standardDeviation closeTo:(((32 squared - 1)/12) sqrt)).
    "

    "
     |r bag|
     r := self new.
     bag := Bag new.
     100000000 timesRepeat:[
         bag add:(r nextIntegerBetween:1 and:400000).
     ].
     Transcript showCR:bag sortedCounts.
     TestCase assert:(bag standardDeviation closeTo:(((400000 squared - 1)/12) sqrt)).
    "

    "
     |r|
     
     r := self new.
     100000000 timesRepeat:[
         self assert:((r nextIntegerBetween:1 and:3) between:1 and:3).
     ].
    "
!

nextLettersOrDigits:count
    "get the next count printable letters or digits [0-9A-Za-z]."

    |res cnt "{ Class:SmallInteger }"|

    cnt := count.
    res := String uninitializedNew:cnt.

    1 to:cnt do:[:i|
        self step.
        res 
            at:i 
            put:('1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' at:(seed \\ 62 + 1)).
    ].

    ^ res

    "
      Random new nextLettersOrDigits:40
    "
! !

!Random methodsFor:'blocked methods'!

contents
    "blocked from use - contents makes no sense for random generators"

    self shouldNotImplement
!

nextPut: value
    "blocked from use - it makes no sense for randoms"

    self shouldNotImplement
! !

!Random methodsFor:'initialization'!

initialize
    self setSeed
! !

!Random methodsFor:'private'!

addEntropy:entropyBytes
    "add some entropy - ignored here"

    ^ self
!

seed
    ^ seed
!

setSeed
    "set the initial seed value based on the current time and processId.
     These numbers implement a maximum period generator which passes
     the spectral test for randomness for dimensions 2 3 4 5 6 and
     the product does not overflow  2 raisedTo:29.

     Use both time and processId for seed, to make different processes
     return different Random numbers"

    |newSeed|

    RandomSalt isNil ifTrue:[
        RandomSalt := 1.
    ] ifFalse:[
        RandomSalt := RandomSalt + 1.
    ].
    newSeed := RandomSalt + (Time millisecondClockValue bitXor:OperatingSystem getProcessId).
    self setSeed:newSeed.

    "Modified: / 29-05-2007 / 12:07:37 / cg"
!

setSeed:seedValue
    "set the initial seed and intialite the PRNG parameters.
     These numbers implement a maximum period generator which passes
     the spectral test for randomness for dimensions 2 3 4 5 6 and
     the product does not overflow  2 raisedTo:29.

     These numbers are carefully choosen, so don't change them, 
     unless you know what you are doing!!"

    modulus := 244944 " 244957 " .
    multiplier := 1597.
    increment := 51749.
    seed := seedValue \\ modulus.

    self step.

    "Modified: / 12-11-1999 / 17:50:52 / stefan"
    "Created: / 26-05-2007 / 21:25:10 / cg"
!

step
    "compute the next random integer"

    seed := (seed * multiplier + increment) \\ modulus

    "Created: 1.4.1997 / 22:40:45 / cg"
    "Modified: 1.4.1997 / 22:43:01 / cg"
! !

!Random methodsFor:'testing'!

atEnd
    "instances of Random can always give more numbers"

    ^ false
!

isReadable
    ^ true
!

isWritable
    "return true, if writing is supported by the receiver.
     Random Generators never are"

    ^ false

    "Created: 1.4.1997 / 22:38:27 / cg"
! !

!Random class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

