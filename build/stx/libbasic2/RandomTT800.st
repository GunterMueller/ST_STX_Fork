"{ Package: 'stx:libbasic2' }"

Object subclass:#RandomTT800
	instanceVariableNames:'k x mag01'
	classVariableNames:'M N'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

RandomTT800 comment:'A pseudo-random number generator; see below for references.
This generator is much slower than Squeak''s Random class.
It automatically seeds itself based on the millisecond clock.

Using the generator:

        randy := RandomTT800 new.
        randy seed: anInteger. "optional; never use zero"
        aRandom := randy next.

Example (InspectIt):

        | r |
        r := RandomTT800 new.
        (1 to: 50) collect: [ :n | r next ].

===================================================================

Originally a C-program for TT800 : July 8th 1996 Version
by M. Matsumoto, email: matumoto@math.keio.ac.jp

Generates one pseudorandom number with double precision which is uniformly distributed on [0,1]-interval for each call.  One may choose any initial 25 seeds except all zeros.

See: ACM Transactions on Modelling and Computer Simulation,
Vol. 4, No. 3, 1994, pages 254-266.

ABSTRACT 

The twisted GFSR generators proposed in a previous article have a defect in k-distribution for k larger than the order of recurrence. In this follow up article, we introduce and analyze a new TGFSR variant having better k-distribution property. We provide an efficient algorithm to obtain the order of equidistribution, together with a tight upper bound on the order. We discuss a method to search for generators attaining this bound, and we list some of these such generators. The upper bound turns out to be (sometimes far) less than the maximum order of equidistribution for a generator of that period length, but far more than that for a GFSR with a working are of the same size.

Previous paper:
                
ACM Transactions on Modeling and Computer Simulation 
Volume 2 , Issue 3 (1992) Pages 179-194 
Twisted GFSR generators 
Makoto Matsumoto, and Yoshiharu Kurita 

ABSTRACT 

The generalized feed back shift register (GFSR) algorithm suggested by Lewis and Payne is a widely used pseudorandom number generator, but has the following serious drawbacks: (1) an initialization scheme to assure higher order equidistribution is involved and is time consuming; (2) each bit of the
generated words constitutes an m-sequence based on a primitive trinomials, which shows poor randomness with respect to weight distribution; (3) a large working area is necessary; (4) the period of sequence is far shorter than the theoretical upper bound. This paper presents the twisted GFSR (TGFSR) algorithm, a slightly but essentially modified version of the GFSR, which solves all the above problems without loss of merit. Some practical TGFSR generators were implemented and passed strict empirical tests. These new generators are most suitable for simulation of a large distributive system, which requires a number of mutually independent pseudorandom number generators with compact size.
'
!

!RandomTT800 class methodsFor:'documentation'!

LICENSE
"
    PLEASE READ THE FOLLOWING NOTICE AND DISCLAIMER CAREFULLY
    BEFORE DOWNLOADING THIS SOFTWARE.  BY DOWNLOADING THIS SOFTWARE
    YOU ARE AGREEING TO BE BOUND BY THESE TERMS.  IF YOU DO NOT AGREE
    TO THE TERMS, DO NOT DOWNLOAD.

    This software (Software), provided by IBM Corporation, may
    contain, or be derived from, code provided by Apple Computer,
    Inc., and is provided subject to the provisions of the Apple
    Computer, Inc. Software License for the SQUEAK Smalltalk System
    which can be viewed at http://www.squeak.org/license.html. 

    This Software is provided AS IS, and IBM Corporation
    DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, WITHOUT
    LIMITATION, ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
    PARTICULAR PURPOSE, AND NONINFRINGEMENT OF THIRD PARTY RIGHTS.
    IBM DOES NOT WARRANT THAT THE FUNCTIONS CONTAINED IN THE SOFTWARE
    WILL MEET THE USERS' REQUIREMENTS, THAT THE OPERATION OF THE
    SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE, OR THAT DEFECTS
    IN THE SOFTWARE WILL BE CORRECTED.  UNDER NO CIRCUMSTANCES SHALL
    IBM CORPORATION BE LIABLE FOR INCIDENTAL, INDIRECT OR CONSEQUENTIAL
    DAMAGES ARISING FROM OR RELATING TO USE OF THIS SOFTWARE.  The
    user of this Software agrees to indemnify and hold IBM Corporation
    harmless from any and all damages, liabilities, costs and expenses
    (including attorney's fees) incurred by IBM Corporation as a
    result of any claim, proceeding or judgment to the extent it
    arises out of or is connected in any manner with the operation,
    use, distribution or modification of the Software, or the combination
    of the Software or modified Software with other programs.
"
!

TT800OriginalCVersion
" From: http://random.mat.sbg.ac.at/ftp/pub/data/tt800.c 

/* A C-program for TT800 : July 8th 1996 Version */
/* by M. Matsumoto, email: matumoto@math.keio.ac.jp */
/* genrand() generate one pseudorandom number with double precision */
/* which is uniformly distributed on [0,1]-interval */
/* for each call.  One may choose any initial 25 seeds */
/* except all zeros. */

/* See: ACM Transactions on Modelling and Computer Simulation, */
/* Vol. 4, No. 3, 1994, pages 254-266. */

/* ABSTRACT 

The twisted GFSR generators proposed in a previous article have a defect in k-distribution for k larger than the order of recurrence. In this follow up article, we introduce and analyze a new TGFSR variant having better k-distribution property. We provide an efficient algorithm to obtain the order of equidistribution, together with a tight upper bound on the order. We discuss a method to search for generators attaining this bound, and we list some of these such generators. The upper bound turns out to be (sometimes far) less than the maximum order of equidistribution for a generator of that period length, but far more than that for a GFSR with a working are of the same size.

*/

#include <stdio.h>
#define N 25
#define M 7

double
genrand()
{
    unsigned long y;
    static int k = 0;
    static unsigned long x[N]={ /* initial 25 seeds, change as you wish */
	0x95f24dab, 0x0b685215, 0xe76ccae7, 0xaf3ec239, 0x715fad23,
	0x24a590ad, 0x69e4b5ef, 0xbf456141, 0x96bc1b7b, 0xa7bdf825,
	0xc1de75b7, 0x8858a9c9, 0x2da87693, 0xb657f9dd, 0xffdc8a9f,
	0x8121da71, 0x8b823ecb, 0x885d05f5, 0x4e20cd47, 0x5a9ad5d9,
	0x512c0c03, 0xea857ccd, 0x4cc1d30f, 0x8891a8a1, 0xa6b7aadb
    };
    static unsigned long mag01[2]={ 
        0x0, 0x8ebfd028 /* this is magic vector `a', don't change */
    };
    if (k==N) { /* generate N words at one time */
      int kk;
      for (kk=0;kk<N-M;kk++) {
	x[kk] = x[kk+M] ^ (x[kk] >> 1) ^ mag01[x[kk] % 2];
      }
      for (; kk<N;kk++) {
	x[kk] = x[kk+(M-N)] ^ (x[kk] >> 1) ^ mag01[x[kk] % 2];
      }
      k=0;
    }
    y = x[k];
    y ^= (y << 7) & 0x2b5b2500; /* s and b, magic vectors */
    y ^= (y << 15) & 0xdb8b0000; /* t and c, magic vectors */
    y &= 0xffffffff; /* you may delete this line if word size = 32 */
/* 
   the following line was added by Makoto Matsumoto in the 1996 version
   to improve lower bit's corellation.
   Delete this line to o use the code published in 1994.
*/
    y ^= (y >> 16); /* added to the 1994 version */
    k++;
    return( (double) y / (unsigned long) 0xffffffff);
}
"
!

documentation
"
    Warning: this generator should not be used for cryptographic work.

    NO WARRANTY

    Slightly adapted Squeak code for fileIn into ST/X.
    The original comment was:


    A pseudo-random number generator; see below for references.
    This generator is much slower than Squeak's Random class.
    It automatically seeds itself based on the millisecond clock.

    Using the generator:

            randy := RandomTT800 new.
            randy seed: anInteger. 'optional; never use zero'
            aRandom := randy next.

    Example (InspectIt):

            | r |
            r := RandomTT800 new.
            (1 to: 50) collect: [ :n | r next ].

    ===================================================================

    Originally a C-program for TT800 : July 8th 1996 Version
    by M. Matsumoto, email: matumoto@math.keio.ac.jp

    Generates one pseudorandom number with double precision which is uniformly distributed 
    on [0,1]-interval for each call.  One may choose any initial 25 seeds except all zeros.

    See: ACM Transactions on Modelling and Computer Simulation,
    Vol. 4, No. 3, 1994, pages 254-266.

    ABSTRACT 

    The twisted GFSR generators proposed in a previous article have a defect in k-distribution for k larger 
    than the order of recurrence. 
    In this follow up article, we introduce and analyze a new TGFSR variant having better k-distribution property. 
    We provide an efficient algorithm to obtain the order of equidistribution, together with a tight upper bound 
    on the order. 
    We discuss a method to search for generators attaining this bound, and we list some of these such generators. 
    The upper bound turns out to be (sometimes far) less than the maximum order of equidistribution for a generator 
    of that period length, but far more than that for a GFSR with a working are of the same size.

    Previous paper:

    ACM Transactions on Modeling and Computer Simulation 
    Volume 2 , Issue 3 (1992) Pages 179-194 
    Twisted GFSR generators 
    Makoto Matsumoto, and Yoshiharu Kurita 

    ABSTRACT 

    The generalized feed back shift register (GFSR) algorithm suggested by Lewis and Payne is a widely used pseudorandom number generator, but has the following serious drawbacks: (1) an initialization scheme to assure higher order equidistribution is involved and is time consuming; (2) each bit of the
    generated words constitutes an m-sequence based on a primitive trinomials, which shows poor randomness with respect to weight distribution; (3) a large working area is necessary; (4) the period of sequence is far shorter than the theoretical upper bound. This paper presents the twisted GFSR (TGFSR) algorithm, a slightly but essentially modified version of the GFSR, which solves all the above problems without loss of merit. Some practical TGFSR generators were implemented and passed strict empirical tests. These new generators are most suitable for simulation of a large distributive system, which requires a number of mutually independent pseudorandom number generators with compact size.

    [see also:]
        http://www0.cs.ucl.ac.uk/staff/d.jones/GoodPracticeRNG.pdf
        RandomGenerator - the default; uses the machine's /dev/random if available
        Random  - fast, but generates less quality random numbers
        RandomParkMiller - a good one (according to literature)
        RandomMT19973 - a better one (according to literature)
        RandomKISS - a fast, reasonably good one (according to literature)
"
!

examples
"

                                                                [exBegin]
    | r |
    r := RandomTT800 new.
    (1 to: 50) collect: [ :n | r next ].
                                                                [exEnd]
"
! !

!RandomTT800 class methodsFor:'initialization'!

initialSeeds
 	" initial 25 seeds, change as you wish. (there must be N seeds) "

	^ self originalSeeds
!

originalSeeds
    " original initial 25 seeds. DO NOT CHANGE "

    ^ #(    16r95F24DAB  16r0B685215  16rE76CCAE7  16rAF3EC239  16r715FAD23
            16r24A590AD  16r69E4B5EF  16rBF456141  16r96BC1B7B  16rA7BDF825
            16rC1DE75B7  16r8858A9C9  16r2DA87693  16rB657F9DD  16rFFDC8A9F
            16r8121DA71  16r8B823ECB  16r885D05F5  16r4E20CD47  16r5A9AD5D9
            16r512C0C03  16rEA857CCD  16r4CC1D30F  16r8891A8A1  16rA6B7AADB ) copy
! !

!RandomTT800 class methodsFor:'instantiation'!

new

	^ super new
		initialize
! !

!RandomTT800 class methodsFor:'testing'!

bucketTest1
    " Answers an array with 50 elements each of which should hold an integer near the value 1000, 
      the closer the better. "

    " RandomTT800 bucketTest1 inspect "

    | a r s k |
    s := 50.
    a := Array new: s.
    a atAllPut: 0.
    r := RandomTT800 new.
    1 to: 50000 do: [ :n |
            k := (r next * s) truncated + 1.
            a at: k put: (a at: k) + 1 ].
    ^ a
!

firstInteger: s
    " Answers an array with the first 's' raw integer elements generated by the RNG using the original seeds. 
      Intended for testing only. "

    " RandomTT800 firstInteger: 50 "

    | a r |
    a := Array new: s.
    a atAllPut: 0.
    r := RandomTT800 new.
    " set the original initial 25 seeds. "
    r setSeeds: self originalSeeds.
    1 to: s do: [ :n |
            a at: n put: r nextInteger ].
    ^ a
!

theItsCompletelyBrokenTest
    " Test to see if generator is answering what it should. 
      Assumes that the initial seeds are what is given in the original version. 
      If this fails something is badly wrong; do not use this generator."

    " RandomTT800 theItsCompletelyBrokenTest "

    | okResult |
    okResult := #(
            16rBCF1F45A 16rA26BF07E 16r14AEFF49 16r6777A14E 16r880C242F 
            16rECEF7842 16r3BD9352 16r1DD55C94 16r7BC39C7 16r75E78DC2 
            16rF0CF8478 16rE2886F41 16rB63AC1A9 16r57858A58 16r16169989 
            16rD8602211 16r31818D3 16r30D51520 16r1C61F026 16rB58FA81
            16r51AF5CAC 16r609D3850 16r278BF184 16r50C1F860 16rEE6F61B4 
            16r33C2A07E 16r55EE93B7 16r40BD28C3 16r713DB4BE 16rDD9352E3 
            16r9254D8B9 16r9C02EE00 16r5F1BB40C 16rF741D0A5 16r6EE25C13 
            16r375DD95B 16rFB24339 16rF3E2C95A 16r8CAA8C6F 16r63858F2F 
            16r70369B29 16r617E2292 16r357EC977 16rC0B7E080 16r16474ADA 
            16rAFDF1588 16rA1502F9D 16rC4577788 16rE3A9893C 16r71662621 ).

    (self firstInteger: 50) = okResult ifFalse: [
            PopUpMenu notify: 'First 50 results do not match the expected results.' ].

    (self firstInteger: 1001) last = 16rD7B4E10B ifFalse: [
            PopUpMenu notify: 'Element 1001 does not match the expected result.' ].

    PopUpMenu notify: 'The expected results were obtained.'
! !

!RandomTT800 methodsFor:'initialization'!

initialize
    N := 25.
    M := 7.

    k := 0.

    "x := self class initialSeeds.  (Done in #seed:) "
    self seed: (Random randomSeed bitAnd:16rFFFFFFFF).

    " this is magic vector `a', don't change "
    mag01 := #( 16r0 16r8EBFD028 ). 
!

seed: anInteger
    x := self class initialSeeds.

    1 to: x size do: [ :n |
            x at: n put: ((x at: n) bitXor: anInteger) ].

    k := 0.
!

setSeeds: anArray
    " Used only by class methods for testing. "

    anArray size = x size ifTrue: [
            x := anArray ]
! !

!RandomTT800 methodsFor:'random numbers'!

next
    " Answer the next random number as a float in the range [0.0,1.0) "

    ^ self nextInteger asFloat / 4.29496729500000e9  "16rFFFFFFFF asFloat"

    " Note that: 4.29496729500000e9 asTrueFraction hex 
      is: '16rFFFFFFFF' "
!

nextBoolean
    " Answer the next boolean"

    ^ self nextInteger > 16r7FFFFFFF
!

nextInteger
    " Answer the next random number in its raw integer form "

    | y kk jLast |

    " generate N words at one time "
    k = N ifTrue: [
            "for (kk=0;kk<N-M;kk++) {"
            0 to: N-M-1 by: 1 do: [ :j |
                    jLast := j.
                    kk := j+1.
                    "x[kk] = x[kk+M] ^ (x[kk] >> 1) ^ mag01[x[kk] % 2];"
                    x at: kk put: 
                            ( ((x at: kk+M) bitXor: (x at: kk) >> 1)
                                    bitXor: (mag01 at: (x at: kk) \\ 2 + 1) )
            ].
            "for (; kk<N;kk++) { "
            jLast+1 to: N-1 by: 1 do: [ :j |
                    kk := j+1.
                    "x[kk] = x[kk+(M-N)] ^ (x[kk] >> 1) ^ mag01[x[kk] % 2];"
                    x at: kk put:
                            ( ((x at: kk+M-N) bitXor: (x at: kk) >> 1)
                                    bitXor: (mag01 at: (x at: kk) \\ 2 + 1) )
                    ].
            k := 0.
            ].
    y := x at: k+1.

    "y ^= (y << 7) & 0x2b5b2500; /* s and b, magic vectors */"
    y := y bitXor: ((y << 7) bitAnd: 16r2B5B2500). " s and b, magic vectors "
    y := y bitAnd: 16rFFFFFFFF.

    "y ^= (y << 15) & 0xdb8b0000; /* t and c, magic vectors */"
    y := y bitXor: ((y << 15) bitAnd: 16rDB8B0000). " t and c, magic vectors "

    y := y bitAnd: 16rFFFFFFFF. " you may delete this line if word size = 32 "

    "The following line was added by Makoto Matsumoto in the 1996 version
    to improve lower bit's corellation.
    Delete this line to o use the code published in 1994. "
    y := y bitXor: y >> 16. "added to the 1994 version"

    k := k + 1.
    ^ y
! !

!RandomTT800 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/RandomTT800.st,v 1.10 2014-10-02 16:22:58 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/RandomTT800.st,v 1.10 2014-10-02 16:22:58 cg Exp $'
! !

