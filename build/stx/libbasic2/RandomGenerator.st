"
 COPYRIGHT (c) 2007 by eXept Software AG
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

Random subclass:#RandomGenerator
	instanceVariableNames:''
	classVariableNames:'HasOSRandom RandFile RandomDevicePathes SharedRandomGenerator'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!RandomGenerator class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2007 by eXept Software AG
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
    This is a Random number generator, 
    which uses either a OS random number generator or /dev/urandom,
    or an ST/X internal random number generator.

    Warning: this generator should not be used for cryptographic work 
    UNLESS: 
        1) you are running on linux, solaris or osx,
        2) you have a working /dev/urandom.
        3) you can trust your /dev/urandom (I don't really know if any/all of them are good)

    [author:]
        Stefan Vogel

    [see also:]
        http://www0.cs.ucl.ac.uk/staff/d.jones/GoodPracticeRNG.pdf
        Random HashRandom Rc4Stream

    [instance variables:]

    [class variables:]
        HasOSRandom     true if the operatingSystem supports random numbers
        RandFile        (if HasOSRandom is false and non-nil) the FileStream (/dev/random),
                        we get random numbers from
"
! !

!RandomGenerator class methodsFor:'initialization'!

initialize
    "want to be informed when returning from snapshot"

    ObjectMemory addDependent:self.


!

openRandFile
    "try to open a random device"

    |randDevName|

    RandFile notNil ifTrue:[
        RandFile close.
        RandFile := nil.            
    ].

    randDevName := self randPath.
    randDevName notNil ifTrue:[
        randDevName := randDevName asFilename.
        randDevName isReadable ifTrue:[
            RandFile := randDevName readStream.
        ].
    ].
! !

!RandomGenerator class methodsFor:'instance creation'!

new
    "return a new random number generator.
     Try to get system random numbers from OS (e.g. in LINUX)
     or device urandom (e.g. in Linux, OSX).
     If no system random numbers are available, fall back to
     a cryptographic secure PRNG (like RC4Random, part of the extra libcrypt package).
     As last resort fallback to the cryptographic insecure linear builtin PRNG"

    |result|

    SharedRandomGenerator notNil ifTrue:[
        "each time, we do a new, add some entropy to the SharedGenerator"
        SharedRandomGenerator addEntropy:OperatingSystem getMicrosecondTime.
        ^ SharedRandomGenerator.
    ].

    HasOSRandom isNil ifTrue:[
        "/ see if there is an OS or CPU-random generator
        [
            "fetch a random byte - and check if the OS generator works"
            result := OperatingSystem randomBytesInto:1.
        ] on:PrimitiveFailure do:[:ex| ].
        HasOSRandom := result notNil.
    ].

    HasOSRandom ifTrue:[
        "OperatingSystem knows how to get random bytes"
        SharedRandomGenerator := self basicNew.
        ^ SharedRandomGenerator.
    ].

    RandFile isNil ifTrue:[
        self openRandFile.
    ].
    RandFile notNil ifTrue:[
        SharedRandomGenerator := self basicNew.
        ^ SharedRandomGenerator.
    ].

    "/ fallback
    Rc4Cipher notNil ifTrue:[
        SharedRandomGenerator := Rc4Cipher random.
        ^ SharedRandomGenerator.
    ].

    "/ last fallback - not very good
    SharedRandomGenerator := Random sharedGenerator.
    ^ SharedRandomGenerator.
! !

!RandomGenerator class methodsFor:'adding entropy'!

addEntropy:entropyBytes
    SharedRandomGenerator notNil ifTrue:[
        SharedRandomGenerator addEntropy:entropyBytes
    ].
! !

!RandomGenerator class methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "handle image restarts and flush any device resource handles"

    (changedObject == ObjectMemory) ifTrue:[
        (something == #returnFromSnapshot) ifTrue:[
            SharedRandomGenerator notNil ifTrue:[
                SharedRandomGenerator := nil.
                HasOSRandom := RandFile := nil.
                self new. "/ opens a new sharedGenerator
            ]
        ]
    ].
! !

!RandomGenerator class methodsFor:'queries'!

randPath
    "path to a file/device that is a source or random numbers"

    |pathsOrNil|

    pathsOrNil := self randomDevicePathes.
    pathsOrNil notNil ifTrue:[
        pathsOrNil do:[:triedRandom |
            triedRandom asFilename exists ifTrue:[
                ^ triedRandom
            ]
        ].
    ].
    ^ nil.
!

randomDevicePathes
    "paths to look for OS sources of random numbers.
     Can be configured at early startup to use something special
     (i.e. a special hardware random device)
     If never set, the defaults /dev/random, /dev/urandom are used"

    RandomDevicePathes notNil ifTrue:[^ RandomDevicePathes].
    OperatingSystem isUNIXlike ifTrue:[
        ^ #( '/dev/urandom' '/dev/random' )
    ].
    ^ nil.
!

randomDevicePathes:aCollectionOfPathesOrNil
    "configurable paths to look for OS sources of random numbers.
     (can be set during early startup in an rc-file).
     If never set, the defaults /dev/random, /dev/urandom are used"

    RandomDevicePathes := aCollectionOfPathesOrNil.
! !

!RandomGenerator methodsFor:'basic reading'!

nextByte
    "get the next random byte"

    HasOSRandom == true ifTrue:[
        ^ OperatingSystem randomBytesInto:1.
    ].
    RandFile isOpen ifFalse:[
        self class openRandFile.
    ].
    ^ RandFile nextByte

    "
      RandomGenerator new nextByte
    "

    "
     Distribution should be equal:

     |r bag|
     r := RandomGenerator new.
     bag := Bag new.
     1000000 timesRepeat:[
         bag add:(r nextByte).
     ].
     bag.
     Transcript showCR:bag contents
    "

    "Created: / 11.11.1999 / 09:25:39 / stefan"
!

nextBytes:cnt
    "get the next cnt random bytes"

    HasOSRandom == true ifTrue:[
        ^ OperatingSystem randomBytesInto:(ByteArray new:cnt).
    ].
    RandFile isOpen ifFalse:[
        self class openRandFile.
    ].
    ^ RandFile nextBytes:cnt.

    "
      RandomGenerator new nextBytes:4
    "

    "Created: / 11.11.1999 / 09:25:39 / stefan"
    "Modified: / 11.11.1999 / 09:52:26 / stefan"
! !

!RandomGenerator methodsFor:'reading'!

next
    "return the next random number in the range 0..1"

    ^ self nextInteger / Float maxSmallInteger

    "
     |r|
     r := RandomGenerator new.
     Transcript showCR:r next.
     Transcript showCR:r next.
     Transcript showCR:r next.
     Transcript showCR:r next.
    "

    "Modified: / 11.11.1999 / 10:31:35 / stefan"
!

nextBoolean
    "return true or false by random"

    ^ self nextByte <= 127

    "
     |r|
     r := RandomGenerator new.
     Transcript showCR:r nextBoolean.
     Transcript showCR:r nextBoolean.
     Transcript showCR:r nextBoolean.
     Transcript showCR:r nextBoolean.
    "

    "
     Distribution should approach 50/50:

     |r bag|
     r := RandomGenerator new.
     bag := Bag new.
     1000000 timesRepeat:[
         bag add:(r nextBoolean).
     ].
     Transcript showCR:bag contents
    "

    "Created: / 11.11.1999 / 09:25:39 / stefan"
    "Modified: / 12.11.1999 / 17:22:01 / stefan"
!

nextCharacters:count
    "get the next count printable characters.
     We answer printable characters in the ascii range (codepoints 32 - 126)"

    |bytes string cnt "{ Class:SmallInteger }"|

    cnt := count.
    bytes := self nextBytes:cnt.
    string := String new:cnt.

    1 to:cnt do:[:eachIndex|
        string at:eachIndex put:(Character value:((bytes at:eachIndex) \\ 94 + 32)).
    ].

    ^ string

    "
      RandomGenerator new nextCharacters:8
    "
!

nextInteger
    "return the next integral random number,
     in the range 0 .. 16r3FFFFFFF (32-bit)
     or 0 .. 16r3FFFFFFFFFFFFFFF (64-bit)."

    |res intSize|

    intSize := SmallInteger maxBytes.

    HasOSRandom == true ifTrue:[
        ^ OperatingSystem randomBytesInto:intSize.
    ].

    res := self nextBytes:intSize.
    res at:intSize put:((res at:intSize) bitAnd:16r3F).
    ^ res asIntegerMSB:false.


    "
     |r|
     r := RandomGenerator new.
     Transcript showCR:r nextInteger.
     Transcript showCR:r nextInteger.
     Transcript showCR:r nextInteger.
     Transcript showCR:r nextInteger.
    "

    "Modified: / 11.11.1999 / 10:08:10 / stefan"
!

nextIntegerBetween:start and:stop
    "return an integral random number between start and stop"

    |rnd range bytesNeeded|

    range := stop - start + 1.
    bytesNeeded := (range highBit + 15) // 8.
    "Fetch at least 2 bytes, otherwise we get some unbalanced distributions for small ranges"
    rnd := (LargeInteger digitBytes:(self nextBytes:bytesNeeded)) compressed.
    rnd := rnd \\ range.
    ^ rnd + start

    "
     |r|
     r := self new.
     Transcript showCR:(r nextIntegerBetween:1 and:10).
     Transcript showCR:(r nextIntegerBetween:1 and:10).
     Transcript showCR:(r nextIntegerBetween:1 and:10).
     Transcript showCR:(r nextIntegerBetween:1 and:10).
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
         bag add:(r nextIntegerBetween:1 and:10).
     ].
     Transcript showCR:bag sortedCounts.
     TestCase assert:(bag standardDeviation closeTo:(((10 squared - 1)/12) sqrt)).
    "

    "Created: / 11.11.1999 / 10:28:36 / stefan"
!

nextLettersOrDigits:count
    "get the next count printable letters or digits [0-9A-Za-z]."

    |bytes string cnt "{ Class:SmallInteger }"|

    cnt := count.
    bytes := self nextBytes:cnt.
    string := String new:cnt.

    1 to:cnt do:[:eachIndex|
        string 
            at:eachIndex 
            put:('1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' at:((bytes at:eachIndex) \\ 62 + 1)).
    ].

    ^ string

    "
      RandomGenerator new nextLettersOrDigits:40
    "
! !

!RandomGenerator methodsFor:'writing'!

nextPut:something
    "change the random pool by feeding in something.
     Something should be some unpredictable, random event.
     Ignored here"


!

nextPutAll:something
    "change the random pool by feeding in something.
     Something should be some unpredictable, random event.
     Ignored here"

! !

!RandomGenerator class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


RandomGenerator initialize!
