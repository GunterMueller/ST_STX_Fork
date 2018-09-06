"{ Package: 'stx:libjava' }"

!

!(Java classForName:'java.util.Map') methodsFor:'* instance *'!

at:aKey
    "return the element indexed by aKey - report an error if none found"

    ^ self at:aKey ifAbsent:[self errorKeyNotFound:aKey]
! !
!(Java classForName:'java.util.Map') methodsFor:'* instance *'!

at:key ifAbsent:exceptionBlock
    "return the element indexed by aKey -
     return result of exceptionBlock if no element is stored under aKey"      

    (self containsKey: key) ifTrue:[ ^ self get: key ].
    ^ exceptionBlock value
! !
!(Java classForName:'java.util.Map') methodsFor:'* instance *'!

do:aBlock
    "perform the block for all values in the collection.

     See also:
        #associationsDo:   (which passes key-value associations)
        #keysAndValuesDo:  (which passes keys & values separately)
        #keysDo:           (which passes keys only)

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this." 

    self values do: aBlock 
! !
!(Java classForName:'java.util.Map') methodsFor:'* instance *'!

keysAndValuesDo:aTwoArgBlock
    "evaluate the argument, aBlock for every element in the collection,
     passing both key and element as arguments.

     See also:
        #associationsDo:       (which passes keys->value pairs)
        #do:                   (which only passes values)
        #keysDo:               (which only passes keys)

     This is much like #associationsDo:, but aBlock gets the
     key and value as two separate arguments."

    self keySet do:[:each | 
        aTwoArgBlock value: each value: (self get: each).
    ].
! !
