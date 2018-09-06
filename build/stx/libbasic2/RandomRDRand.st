"{ Package: 'stx:libbasic2' }"

Object subclass:#RandomRDRand
	instanceVariableNames:'x y z c'
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!RandomRDRand class methodsFor:'documentation'!

documentation
"
    Warning: there have been discussions about the security of the intel rdgen instruction
    and whether there are NSA backdoors built into it.
    Linus Torwalds refuses to use it for /dev/urandom in the linux kernel, for that very reason.
    Be sure you know what you are doing, if you use this generator for sensitive cryptographic stuff.
    We recommend using one of the libcrypt-based generators and use this only to get additional
    entropy for the seed.

    NO WARRANTY

    This generator uses the rdgen random generator which is built into modern intel chips.
    Before using, you should check via the isSupported query.

    RandomRDGen new nextInteger

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

!RandomRDRand class methodsFor:'instance creation'!

new
    self isSupported ifFalse:[ self error:'this generator needs a cpu with rdgen instruction' ].
    ^ self basicNew 
        initialize
!

new:seed
    "seed is actualy ignored"

    self isSupported ifFalse:[ self error:'this generator needs a cpu with rdgen instruction' ].
    ^ self basicNew 
        initialize;
        seed:seed
! !

!RandomRDRand class methodsFor:'queries'!

isSupported
    "true if this architecture supports hardware random numbers"

    ^ OperatingSystem getCPUType = 'x86_64'
        and:[ (OperatingSystem getSystemInfo at:#extendedInstructions ifAbsent:#())
              includes:#aes ]

    "
     self isSupported
    "
! !

!RandomRDRand methodsFor:'initialization'!

initialize
!

seed:seed
    "/ ignored
! !

!RandomRDRand methodsFor:'random numbers'!

nextBoolean
    "generates a boolean random"

    ^ self nextInteger > 16r7FFFFFFF
!

nextInteger
    "generates the next integer in 0..FFFFFFFF.
     Notice, it may raise an illegal instruction exception on some cpu chips,
     even though the cpuid instruction says that it is available"

%{
    unsigned int r = 0;
    int cf;

    do {
#if defined(__i386__) && defined(__GNUC__) && (__GNUC__ >= 2)
        // Encoding of rdrand %eax
        asm(".byte 0x0F, 0xC7, 0xF0; adcl $0,%1" :
            "=a" (r), "=r" (cf) : "0" (r), "1" (cf) : "cc");

#else
# ifdef USE_DRAND32
        cf = _rdrand32_step(&r);
# else
        goto unsupported;
# endif
#endif
    } while (cf != 0);
    RETURN (__MKUINT(r));

unsupported: ;
%}.
    self primitiveFailed:'unsupported on this architecture'

    "
     self new nextInteger
    "
! !

!RandomRDRand class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/RandomRDRand.st,v 1.2 2014-10-02 16:23:16 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/RandomRDRand.st,v 1.2 2014-10-02 16:23:16 cg Exp $'
! !

