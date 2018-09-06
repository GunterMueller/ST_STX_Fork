"{ Package: 'stx:libbasic2' }"

Random subclass:#RandomLaggedFibonacci
	instanceVariableNames:'values drift'
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!RandomLaggedFibonacci class methodsFor:'documentation'!

documentation
"
    The lagged Fibonacci additive generator is described in 
    TAOCP vol. 2 by Donald Knuth, with lags 83 and 258.
"
! !

!RandomLaggedFibonacci methodsFor:'accessing'!

drift
    ^ drift
!

drift:something
    drift := something.
!

next
    | answer |

    answer := self nextValue.
    self increaseDrift.
    self values at: self drift put: answer.
    ^ answer
!

nextValue
    | answer |

    answer := self smallLagValue - self largeLagValue.
    answer < 0.0 ifTrue: [answer := answer + 1.0].
    ^ answer
!

setSeed: aNumber
    super setSeed: aNumber.
    self initializeValues
!

values
    ^ values
!

values:something
    values := something.
! !

!RandomLaggedFibonacci methodsFor:'initialization'!

initialize
    super initialize.
    self drift: 1.
    self setSeed: (OperatingSystem getMicrosecondTime).
    self initializeValueStorage.
    self initializeValues
!

initializeValueStorage
    |newValues|

    newValues := Array new:self largeLag.
    self values:newValues
!

initializeValues
    |random|

    random := RandomParkMiller new.
    random seed:self seed.
    1 to:self values size do:[:eachIndex | 
        self values at:eachIndex put:random next
    ]
! !

!RandomLaggedFibonacci methodsFor:'private'!

increaseDrift
    |newDrift|

    newDrift := self drift = self largeLag 
                    ifTrue:[1] 
                    ifFalse:[self drift + 1].
    self drift:newDrift
!

indexForLag: aLag
    | answer |

    answer := self drift - aLag.
    ^ answer > 0
        ifTrue: [answer]
        ifFalse: [answer + self largeLag]
!

largeLag
    ^ 258
!

largeLagValue
    ^ self values at: self drift
!

smallLag
    ^ 83
!

smallLagValue
    | index |

    index := self indexForLag: self smallLag.
    ^ self values at: index
! !

!RandomLaggedFibonacci class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/RandomLaggedFibonacci.st,v 1.1 2009-10-04 20:05:58 cg Exp $'
! !
