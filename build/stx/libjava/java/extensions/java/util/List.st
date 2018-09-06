"{ Package: 'stx:libjava' }"

!

!(Java classForName:'java.util.List') methodsFor:'* instance *'!

at: index
    ^ self at: index ifAbsent:[ self subscriptBoundsError: index ]
! !
!(Java classForName:'java.util.List') methodsFor:'* instance *'!

at: index ifAbsent: errorBlock
    (index between: 1 and: self size) ifTrue:[
        ^ self get: index - 1
    ].
    ^ errorBlock value
! !
!(Java classForName:'java.util.List') methodsFor:'* instance *'!

at: index put: anObject
    ^ self put: index - 1 value: anObject
! !
!(Java classForName:'java.util.List') methodsFor:'* instance *'!

fifth
    ^ self get: 4
! !
!(Java classForName:'java.util.List') methodsFor:'* instance *'!

first
    ^ self get: 0
! !
!(Java classForName:'java.util.List') methodsFor:'* instance *'!

fourth
    ^ self get: 3
! !
!(Java classForName:'java.util.List') methodsFor:'* instance *'!

identityIndexOf:anElement
    "Returns the index of an element or 0, if not found.
     Compare using == (identity)"

    1 to: self size do:[:i | 
        (self get: i - 1) == anElement ifTrue:[ ^ i ].
    ].
    ^ 0
! !
!(Java classForName:'java.util.List') methodsFor:'* instance *'!

indexOf:anElement
    "Returns the index of an element or 0, if not found.
     Compare using Object#equals()"

    ^ (self perform: #'indexOf(Ljava/lang/Object;)I' with: anElement) + 1. 
! !
!(Java classForName:'java.util.List') methodsFor:'* instance *'!

last
    ^ self get: self size - 1
! !
!(Java classForName:'java.util.List') methodsFor:'* instance *'!

second
    ^ self get: 1
! !
!(Java classForName:'java.util.List') methodsFor:'* instance *'!

third
    ^ self get: 2
! !
