"
 COPYRIGHT.
 This is a Manchester Goodie protected by copyright.
 These conditions are imposed on the whole Goodie, and on any significant
 part of it which is separately transmitted or stored:
	* You must ensure that every copy includes this notice, and that
	  source and author(s) of the material are acknowledged.
	* These conditions must be imposed on anyone who receives a copy.
	* The material shall not be used for commercial gain without the prior
	  written consent of the author(s).
 Further information on the copyright conditions may be obtained by
 sending electronic mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: copyright
 or by writing to The Smalltalk Goodies Library Manager, Dept of
 Computer Science, The University, Manchester M13 9PL, UK

 (C) Copyright 1992 University of Manchester
 For more information about the Manchester Goodies Library (from which 
 this file was distributed) send e-mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: help 
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Dictionary subclass:#OrderedDictionary
	instanceVariableNames:'order'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

!OrderedDictionary class methodsFor:'documentation'!

copyright
"
 COPYRIGHT.
 This is a Manchester Goodie protected by copyright.
 These conditions are imposed on the whole Goodie, and on any significant
 part of it which is separately transmitted or stored:
	* You must ensure that every copy includes this notice, and that
	  source and author(s) of the material are acknowledged.
	* These conditions must be imposed on anyone who receives a copy.
	* The material shall not be used for commercial gain without the prior
	  written consent of the author(s).
 Further information on the copyright conditions may be obtained by
 sending electronic mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: copyright
 or by writing to The Smalltalk Goodies Library Manager, Dept of
 Computer Science, The University, Manchester M13 9PL, UK

 (C) Copyright 1992 University of Manchester
 For more information about the Manchester Goodies Library (from which 
 this file was distributed) send e-mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: help 
"
!

documentation
"
    I am a subclass of Dictionary whose elements (associations) are ordered in a
    similar fashion to OrderedCollection.
    That is, while being filled via #at:put: messages (or similar Dictionary protocol),
    the order in which associations are added, is remembered and accessible via the #atIndex:
    or #order messages. 
    Therefore, this combines fast access via hashing with a defined order when enumerating.
    
    [instance variables:]
        order <OrderedCollection>       Ordered collection of keys reflecting the order of
                                        associations in the dictionary.

    [complexity:]
        access by index: O(1)
        access by key: O(1)
        searching: O(n)
        insertion: mostly O(1)
        removal: mostly O(N) (because order will have O(n) behavior)
        
    [author:]
        Ifor Wyn Williams <ifor@uk.ac.man.cs>
        Changed by: exept

    [see also:]
        OrderedCollection Dictionary
        OrderedSet
"
!

examples
"
    |o|

    o := OrderedDictionary new.

    o at:'one'   put:1.
    o at:'two'   put:2.
    o at:'three' put:3.
    o at:'four'  put:4.
    o at:'five'  put:5.
    o at:'six'   put:6.
    o at:'seven' put:7.
    o at:'eight' put:8.
    o at:'nine'  put:9.
    o at:'zero'  put:0.

    o at:'eight'.
    o atIndex:1.   
    o atIndex:5.    
    o atIndex:10.  

    o from:3 to:6 do:[:each | Transcript showCR:each ].

    o collect:[:eachAssoc | eachAssoc key -> eachAssoc value squared]. 
    o associations.  
    o order.         
    o reverse.    

    o atIndex:1.  
    o atIndex:5. 
    o atIndex:10. 
"
!

info
"
	NAME            OrderedDictionary
	AUTHOR          Ifor Wyn Williams <ifor@uk.ac.man.cs>
	CONTRIBUTOR     Ifor Wyn Williams <ifor@uk.ac.man.cs>
	FUNCTION        An ordered dictionary
	ST-VERSIONS     2.3-5, 4.0
	PREREQUISITES   
	CONFLICTS       
	DISTRIBUTION    global
	VERSION         1.2
	DATE            28.3.90
	SUMMARY         A dictionary that behaves like a SequencableCollection
			(except that associations cannot be removed). 
"
! !

!OrderedDictionary class methodsFor:'instance creation'!

new:anInteger
    ^ (super new:anInteger) initializeOrder:anInteger
! !

!OrderedDictionary methodsFor:'accessing'!

after:anAssociation 
    "Return the association after anAssociation in the order. 
     If anAssociation is the last association in the order, return nil.
     If anAssociation is not found, invoke an error notifier"

    |sz "{ Class:SmallInteger }"|

    sz := order size.
    1 to:sz do:[:index | 
        (self associationAt:(order at:index)) = anAssociation ifTrue:[
            index == sz ifTrue:[^ nil].
            ^ self associationAt:(order at:index + 1)
        ]
    ].
    ^ self errorNotFound:anAssociation.
!

associations
    "Return an OrderedCollection containing the receiver's associations."

    ^ order collect: [:key | self associationAt: key ].
!

at:aKey ifAbsent:default update:aBlock 
    "update the element stored under aKey with the result from 
     evaluating aBlock with the previous stored value as argument, or with default,
     if there was no such key initially."

    ^ self at:aKey put:(aBlock value:(self at:aKey ifAbsent:default)).

    "
     |d|

     d := OrderedDictionary new.
     d at:'one'  ifAbsent:0 update:[:val | val + 1].
     d at:'two'  ifAbsent:0 update:[:val | val + 1].
     d at:'three' ifAbsent:0  update:[:val | val + 1].
     d at:'one' ifAbsent:0  update:[:val | val + 1].
     d at:'two' ifAbsent:0  update:[:val | val + 1].
     d
    "
!

at:aKey ifAbsentPut:valueBlock
    ^ self at:aKey ifAbsent:[self at:aKey put:valueBlock value]
!

at:key put:anObject 
    "Set the value at key to be anObject. 
     If key is not found, create a new entry for key and set its value to anObject. 
     If key is already present, the order remains unchanged.
     Return anObject."

    (self includesKey: key) ifFalse:[order add: key].
    ^ super at:key put:anObject
!

at:aKey put:aValue ifPresent:aBlock
    |v|

    v := self at:aKey ifAbsent:[^ self at:aKey put:aValue].
    ^ aBlock value:v.

    "
     |d|

     d := OrderedDictionary new.
     d at:'foo' put:1234 ifPresent:[:v| self error: 'duplicate: ', v printString ].
     d at:'foo' put:1234 ifPresent:[:v| self halt:'duplicate: ', v printString. 5555 ].
    "













    "
     |d|

     d := Dictionary new.
     d at:'foo' put:1234 ifPresent:[:v| self error: 'duplicate: ', v printString ].
     d at:'foo' put:1234 ifPresent:[:v| self halt:'duplicate; ', v printString. 5555 ].
    "
!

atAll:indexCollection put: anObject 
    "Put anObject into the value field of every association specified by indexCollection,
     which is typically an interval."

    indexCollection do:[:index | self at:(order at: index) put:anObject]
!

atAllPut: anObject 
    "Put anObject into the value field of every association in the dictionary"

    order do:[:key | super at: key put:anObject]
!

atIndex:index
    "return an element at a given index"

    ^ self at:(order at:index)

    "Created: 28.9.1995 / 13:49:39 / stefan"
!

atIndex:index ifAbsent:aBlock
    "return an element at a given index"

    ^ self at:(order at:index ifAbsent:[^ aBlock value])
!

atIndex:index put:anAssociation
    "put an association to a given index. remove the old association at this index"
    |key|

    key := anAssociation key.
    (super includesKey:key) ifTrue:[
        ^ self error:'duplicate key'.
    ].
    super removeKey:(order at:index) ifAbsent:[].
    order at:index put:key.
    super at:key put:anAssociation value.
    ^ anAssociation.

    "Created: 28.9.1995 / 16:30:15 / stefan"
!

before:anAssociation 
    "Return the association before anAssociation in the order. 
     If anAssociation is the first association in the order, return nil.
     If anAssociation is not found, invoke an error notifier"
    
    |sz "{ Class:SmallInteger }"|

    sz := order size.
    1 to:sz do:[:index | 
        (self associationAt:(order at:index)) = anAssociation ifTrue:[
            index == 1 ifTrue:[^ nil].
            ^ self associationAt:(order at:index - 1)
        ]
    ].
    ^ self errorNotFound:anAssociation.
!

first
    "Return the first association of the receiver.  
     Provide an error notification if the receiver contains no elements."

    ^ self associationAt: (order first)

    "
        OrderedDictionary new first
    "
!

firstKey
    "Return the first key of the receiver.  
     Raises an error if the receiver contains no elements."

    ^ order first

    "
     OrderedDictionary new first
     OrderedDictionary new firstKey

     OrderedDictionary new
        at:'foo' put:'Foo';
        at:'bar' put:'Bar';
        first

     OrderedDictionary new
        at:'foo' put:'Foo';
        at:'bar' put:'Bar';
        firstKey
    "
!

keyAt:index
    "get the key at the given index"

    ^ order at:index.

    "
     |s|

     s := OrderedDictionary new.
     s at:#a put:'aaa'; at:#b put:'bbb'; at:#c put:'ccc'; at:#d put:'ddd'; at:#a put:'aaaa'.
     s keyAt:2    
    "

    "Created: 29.9.1995 / 11:32:07 / stefan"
!

keys
    "Return a OrderedCollection containing the receiver's keys."

    ^ order copy.

    "
     |s|

     s := OrderedDictionary new.
     s at:#a put:'aaa'; at:#b put:'bbb'; at:#c put:'ccc'; at:#d put:'ddd'; at:#a put:'aaaa'.
     s keys       
    "
!

last
    "Return the last association of the receiver. 
     Provide an error notification if the receiver contains no elements."

    ^ self associationAt: (order last)

    "
        OrderedDictionary new last
    "
!

lastKey
    "Return the last key of the receiver.  
     Raises an error if the receiver contains no elements."

    ^ order last

    "
     OrderedDictionary new last
     OrderedDictionary new lastKey

     OrderedDictionary new
        at:'foo' put:'Foo';
        at:'bar' put:'Bar';
        last

     OrderedDictionary new
        at:'foo' put:'Foo';
        at:'bar' put:'Bar';
        lastKey
    "
!

order
    "returns the keys in the order of their appearance"

    ^ order

    "
     |s|

     s := OrderedDictionary new.
     s at:#a put:'aaa'; at:#b put:'bbb'; at:#c put:'ccc'; at:#d put:'ddd'; at:#a put:'aaaa'.
     s order    
    "
!

valueAt:index
    "get the value at the given index"

    ^ self at:(order at:index).

    "
     |s|

     s := OrderedDictionary new.
     s at:#a put:'aaa'; at:#b put:'bbb'; at:#c put:'ccc'; at:#d put:'ddd'; at:#a put:'aaaa'.
     s valueAt:2       
    "
!

values
    "Return a OrderedCollection containing the receiver's values."

    ^ order collect:[:key | self at:key].
! !

!OrderedDictionary methodsFor:'adding'!

add: anAssociation after: oldAssociation 
    "Add the argument, anAssociation, as an element of the dictionary. Put it 
    in the position just succeeding oldAssociation. Return anAssociation."

    | index key |

    index := self indexOfAssociation: oldAssociation 
                            ifAbsent: [^ self errorNotFound:anAssociation].
    key := anAssociation key.
    order remove:key ifAbsent:[].
    order add:key after:(order at: index).
    super at:key put:anAssociation value.
    ^ anAssociation
!

add:anAssociation before:oldAssociation 
    "Add the argument, anAssociation, as an element of the dictionary. Put it 
    in the position just preceding oldAssociation. Return anAssociation."

    | index key |

    index := self indexOfAssociation: oldAssociation 
                            ifAbsent: [^ self errorNotFound:anAssociation].
    key := anAssociation key.
    order remove:key ifAbsent:[].
    order add:key before:(order at: index).
    super at:key put:anAssociation value.
    ^ anAssociation
!

add:anAssociation beforeIndex:spot 
    "Add the argument, anAssociation, as an element of the receiver.  Put it
    in the position just preceding the indexed position spot.  Return newObject."

    |key|

    key := anAssociation key.
    order remove:key ifAbsent:[].
    order add:key beforeIndex:spot.
    super at:key put:anAssociation value.
    ^ anAssociation

    "Modified: 28.9.1995 / 14:06:53 / stefan"
!

addAll:aCollectionOfAssociations 
    "Add each element of anOrderedCollectionOfAssociations at my end. 
     We expect the argument to enumerate associations with #reverseDo:; 
     if it does not (i.e. it is another OD or a dictionary), use #addAllAssociationsFirst:.
     Returns the argument, aCollectionOfAssociations (sigh)."

    ^ self addAllLast:aCollectionOfAssociations.

    "Modified: 28.2.1997 / 15:51:23 / cg"
!

addAllAssociations:aDictionaryOrOrderedDictionary
    "Add each association of aDictionaryOrOrderedDictionary to my end.
     We expect the argument to respond to #associationsDo:."

    ^ self addAllAssociationsLast:aDictionaryOrOrderedDictionary.

    "Created: 28.2.1997 / 15:52:02 / cg"
!

addAllAssociationsFirst:aDictionaryOrOrderedDictionary
    "Add each association of aDictionaryOrOrderedDictionary at the beginning of the 
     receiver. We expect the argument to respond to #associationsReverseDo:."

    aDictionaryOrOrderedDictionary associationsReverseDo:[:each | self addFirst:each].
    ^ aDictionaryOrOrderedDictionary

    "Created: 28.2.1997 / 15:50:14 / cg"
!

addAllAssociationsLast:aDictionaryOrOrderedDictionary
    "Add each association of aDictionaryOrOrderedDictionary at the end of the 
     receiver. We expect the argument to respond to #associationsDo:."

    aDictionaryOrOrderedDictionary associationsDo:[:each | self addLast:each].
    ^ aDictionaryOrOrderedDictionary

    "Created: 28.2.1997 / 15:48:37 / cg"
!

addFirst:anAssociation 
    "Add anAssociation to the beginning of the receiver."

    |key|

    key := anAssociation key.
    order remove:key ifAbsent:[].
    order addFirst:key.
    super at:key put:anAssociation value.
    ^ anAssociation
!

addLast:anAssociation 
    "Add anAssociation to the end of the receiver.
     If anAssociation is already present in the dictionary,
     it will be moved to the end. (See also: #add:)"

    |key|

    key := anAssociation key.
    order remove:key ifAbsent:[].
    order add:key.
    super at:key put:anAssociation value.
    ^ anAssociation
! !

!OrderedDictionary methodsFor:'copying'!

copyEmpty
    "Return a copy of the receiver that contains no elements."

    ^ self species new: 10
!

copyFrom:startIndex to:endIndex 
    "Return a copy of the receiver that contains elements from 
     position startIndex to endIndex."
    
    |newDict|

    endIndex < startIndex ifTrue:[
        ^ self copyEmpty
    ].
    (startIndex < 1 or:[ endIndex > order size ]) ifTrue:[
        ^ self errorNotFound
    ].
    newDict := self copyEmpty:endIndex - startIndex + 1.
    startIndex to:endIndex do:[:index | 
        newDict add:(self associationAt:(order at:index))
    ].
    ^ newDict
!

copyWithout: anAssociation 
    "Return a copy of the dictionary that is 1 smaller than the receiver and 
     does not include the argument, anAssociation
     No error is reported, if elementToSkip is not in the collection."

    | newDict keyToIgnore valueToIgnore|

    newDict := self species new:order size - 1.
"/    self associationsDo:[:assoc | anAssociation = assoc ifFalse:[newDict add:assoc]].

    keyToIgnore := anAssociation key.
    valueToIgnore := anAssociation value.
    self keysAndValuesDo:[:k :v |
        (keyToIgnore = k and:[valueToIgnore = v]) ifFalse:[
            newDict at:k put:v
        ]
    ].
    ^ newDict.

    "
     |d d2|

     d := OrderedDictionary new
            at:1 put:'1';
            at:2 put:'2';
            at:3 put:'3';
            at:4 put:'4';
            at:5 put:'5';
            yourself.
     d2 := d copyWithout:(4->'4').
     d2      
    "
!

postCopy
    "have to copy the order too"

    super postCopy.
    order := order copy
! !

!OrderedDictionary methodsFor:'enumerating'!

associationsCollect: aBlock 
    "Evaluate aBlock with each of the associations of the dictionary as argument,
     and return a new (ordered) collection with the results"

    ^ order collect:[:key | (aBlock value: (self associationAt:key))].
!

associationsDo: aBlock 
    "Evaluate aBlock for each of the dictionary's associations.
     Enumerate them in the order by which they were added.

     See also:
        #keysAndValuesDo:  (which passes keys & values separately)
        #keysDo:           (which passes keys only)
        #do:               (which passes values only)"

    order do: [:key | aBlock value: (self associationAt: key)]
!

associationsDo: aBlock from: firstIndex to: secondIndex 
    "Evaluate aBlock with each of the dictionary's associations from index 
    firstIndex to index secondIndex as the argument."

    firstIndex to: secondIndex do: [:index | 
        aBlock value: (self associationAt: (order at: index))
    ]
!

associationsReverseDo: aBlock 
    "Evaluate aBlock for each of the dictionary's associations in reverse order."

    order reverseDo:[:key | aBlock value:(self associationAt:key)]

    "Created: 28.2.1997 / 15:52:31 / cg"
!

associationsSelect:aBlock 
    "Evaluate aBlock with each of the dictionary's associations as the argument.
     Collect into a new OrderedDictionary only those associations for which 
     aBlock evaluates to true. Return the new OrderedDictionary."

    |newDict|

    newDict := self species new.
    order do:[:key | 
        |assoc|

        assoc := self associationAt:key.
        (aBlock value:assoc) ifTrue: [
            newDict at:key put:assoc value.
        ]
    ].
    ^ newDict
!

collect: aBlock 
    "Evaluate aBlock with each of the values of the dictionary as argument,
     and return a new (ordered) collection with the results"

    ^ order collect:[:key | (aBlock value: (self at:key))].
!

detect: aBlock ifNone:anExceptionValue
    "evaluate the argument, aBlock for each element in the receiver until
     the block returns true; in this case return the element which caused
     the true evaluation.
     If none of the evaluations returns true, return the value of anExceptionValue"

    order do:[:key | 
        |el|
        el := self at:key.
        (aBlock value:el) ifTrue:[^ el]
    ].
    ^ anExceptionValue value
!

do: aBlock 
    "Evaluate aBlock for each of the dictionary's values.
     Enumerate them in the order by which they were added."

    order do: [:key | aBlock value: (self at: key)]
!

do: aBlock from: firstIndex to: lastIndex
    <resource: #obsolete>

    self obsoleteMethodWarning:'use #from:to:do:'.

    self from:firstIndex to:lastIndex do:aBlock.
!

findFirst:aBlock ifNone:exceptionalValue
    "Return the index of the first association in the dictionary for which aBlock
    evaluates as true. If the block does not evaluate to true, return exceptionalValue"

    |stop  "{ Class: SmallInteger }" |

    stop := order size.
    1 to:stop do:[:index | 
        (aBlock value:(self associationAt:(order at:index))) ifTrue: [^ index]
    ].
    ^ exceptionalValue value
!

findLast:aBlock 
    "Return the index of the last association in the dictionary for which aBlock
     evaluates as true. If the block does not evaluate to true, return 0"

    |start "{ Class: SmallInteger }"|

    start := order size.
    start to:1 by:-1 do: [:index | 
        (aBlock value:(self associationAt:(order at:index))) ifTrue: [^ index]
    ].
    ^ 0
!

findLast:aBlock startingAt:startIndex
    "Return the index of the last association in the dictionary for which aBlock
     evaluates as true. Start the backward search at startIndex.
     If the block does not evaluate to true, return 0"

    |start "{ Class: SmallInteger }"|

    start := startIndex.
    start to:1 by:-1 do: [:index | 
        (aBlock value:(self associationAt:(order at:index))) ifTrue: [^ index]
    ].
    ^ 0
!

findLast:aBlock startingAt:startIndex endingAt:endIndex
    "Return the index of the last association in the dictionary for which aBlock
     evaluates as true. Start the search at startIndex.
     End the search at endIndex or when an element is found.
     If the block does not evaluate to true, return 0"

    |start "{ Class: SmallInteger }" 
     end "{ Class: SmallInteger }"|

    start := startIndex.
    end := endIndex.
    start to:end by:-1 do: [:index | 
        (aBlock value:(self associationAt:(order at:index))) ifTrue: [^ index]
    ].
    ^ 0
!

from:firstIndex to:lastIndex do: aBlock
    "Evaluate aBlock with each of the dictionary's associations from index 
    firstIndex to index secondIndex as the argument."

    |start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }" |

    start := firstIndex. "/ these assignments force type checking...
    stop := lastIndex.  "/ and guarantee inline loop code below.
    order from:start to:stop do:[:key |
        aBlock value: (self at:key)
    ].
!

keysAndValuesDetect: aBlock ifNone:exceptionBlock
    "evaluate the argument, aBlock for each key and value in the receiver,
     until the block returns true; 
     in this case return the element which caused the true evaluation.
     If none of the evaluations returns true, return the result of the
     evaluation of the exceptionBlock"

    order do:[:key | 
        |el|
        el := self at:key.
        (aBlock value:key value:el) ifTrue:[^ el]
    ].
    ^ exceptionBlock value
!

keysAndValuesDo:aBlock
    "perform the block for all keys and values in the collection.
     Enumerate them in the order by which they were added.

     See also:
        #associationsDo:   (which passes key-value associations)
        #keysDo:           (which passes keys only)
        #do:               (which passes values only)

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this."

    order do:[:key | aBlock value:key value:(self at: key)].

    "Modified: / 26.6.1999 / 10:55:30 / ps"
    "Created: / 15.10.1999 / 16:49:31 / cg"
    "Modified: / 15.10.1999 / 16:53:50 / cg"
!

keysAndValuesReverseDo:aBlock
    "perform the block for all keys and values in the collection.
     Enumerate them in the reverse order from which they were added.

     See also:
        #associationsDo:   (which passes key-value associations)
        #keysAndValuesDo:  (which passes keys & values separately)
        #do:               (which passes values only)

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this."

    order reverseDo: [:key | aBlock value:key value:(self at: key)].

    "Modified: / 26.6.1999 / 10:55:30 / ps"
    "Created: / 15.10.1999 / 16:49:31 / cg"
    "Modified: / 15.10.1999 / 16:53:50 / cg"
!

keysDo:aBlock
    "evaluate the argument, aBlock for every key in the collection.
     Enumerate them in the order by which they were added.

     See also:
        #associationsDo:   (which passes key-value associations)
        #keysAndValuesDo:  (which passes keys & values separately)
        #do:               (which passes values only)

     WARNING: do not add/remove elements while iterating over the receiver.
              Iterate over a copy to do this."

    order do:[:key | aBlock value:key].

    "Created: / 26-06-1999 / 10:53:00 / ps"
    "Modified: / 24-08-2010 / 10:14:06 / cg"
!

reverseDo: aBlock 
    "Evaluate aBlock with each of the dictionary's associations as the argument,
     starting with the last added element and taking each in sequence up to the first."

    |sz  "{ Class:SmallInteger }"|

    sz := order size.
    sz to:1 by:-1 do: [:index | 
        aBlock value:(self associationAt:(order at:index))
    ]
!

reversed
    "Return with a new OrderedDictionary with its associations in reverse order."

    ^ self copy reverse.
!

select:aBlock 
    "Evaluate aBlock with each of the dictionary's values as the argument.
     Collect into a new OrderedDictionary only those associations for which 
     aBlock evaluated to true. Return the new OrderedDictionary."

    |newColl|

    newColl := self species new.
    order do:[:key | 
        |val|

        val := self at:key.
        (aBlock value:val) ifTrue:[
            newColl at:key put:val.
        ]
    ].
    ^ newColl
! !

!OrderedDictionary methodsFor:'initialization'!

initializeOrder:count
    order := OrderedCollection new:count
! !

!OrderedDictionary methodsFor:'private'!

removeFromOrder: aKey
    <resource: #obsolete>
 
    order remove: aKey ifAbsent: []
! !

!OrderedDictionary methodsFor:'queries'!

occurrencesOfKey: aKey 
    "Return how many of the dictionary's keys are equal to aKey."

    ^ order count:[:eachKey | aKey = eachKey]

"/ cg: the original code was not very smalltalkish:
"/
"/    | count |
"/
"/    count := 0.
"/    1 to: self size do: [:index | aKey = (order at: index) ifTrue: [count := count + 1]].
"/    ^count
!

occurrencesOfValue: aValue 
    "Return how many of the dictionary's values are equal to aValue."

    ^ order count:[:eachKey | aValue = (self at:eachKey)]

"/ cg: the original code was not very smalltalkish:
"/
"/    | count |
"/
"/    count := 0.
"/    1 to: self size do: [:index | 
"/        aValue = (self at: (order at: index)) ifTrue: [count := count + 1]].
"/    ^count
! !

!OrderedDictionary methodsFor:'removing'!

clearContents
    "remove all elements from the receiver, but do not shrink. Returns the receiver."

    super clearContents.
    order clearContents.
!

removeFirst
    |key|

    order size == 0 ifTrue:[
        "error if collection is empty"
        ^ self emptyCollectionError.
    ].
    key := order removeFirst.
    ^ super removeKey:key.
!

removeFromIndex:fromIndex toIndex:toIndex
    "Returns the receiver."

    |start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }" |

    start := fromIndex. 
    stop := toIndex. 

    order from:start to:stop do:[:key |
        super removeKey:key.
    ].
    order removeFromIndex:fromIndex toIndex:toIndex.

    "Created: 28.9.1995 / 12:04:33 / stefan"
!

removeIndex:anInteger
    self removeFromIndex:anInteger toIndex:anInteger.
!

removeKey:aKey
    order remove:aKey.
    ^ super removeKey:aKey.
!

removeKey:aKey ifAbsent:aBlock
    "remove key (and the associated value) from the receiver, 
     return the value previously stored there.
     If it was not in the collection return the result
     from evaluating aBlock."
     
    |oldValue|

    oldValue := super removeKey:aKey ifAbsent:aBlock.
    order remove:aKey ifAbsent:[].
    ^ oldValue.

    "Created: / 31-01-2011 / 22:04:01 / cg"
!

removeLast
    |key|

    order size == 0 ifTrue:[
	"error if collection is empty"

	^ self emptyCollectionError.
    ].
    key := order removeLast.
    ^ super removeKey:key.
! !

!OrderedDictionary methodsFor:'searching'!

identityIndexOfAssociation: anAssociation 
    "Return the identity index of anAssociation within the receiver. If the receiver
    does not contain anAssociation, return 0."

    ^ self identityIndexOfAssociation: anAssociation ifAbsent: [0]
!

identityIndexOfAssociation: anAssociation ifAbsent: exceptionBlock 
    "Return the identity index of anAssociation within the receiver. 
     If the receiver does not contain anAssociation, 
     return the result of evaluating the exceptionBlock."

    "/ as ST/X's dictionaries do not store the associations 
    "/ (instead, they store the keys and values in separate collections)
    "/ this will not work. You have to think about it and rewrite your code.
    self error:'this does not work in Smalltalk/X'.

    order keysAndValuesDo:[:i :key |
        (self associationAt:key) == anAssociation ifTrue: [^i]
    ].
    ^exceptionBlock value
!

identityIndexOfKey: aKey 
    "Return the identity index of aKey within the receiver. If the receiver 
    does not contain aKey, return 0."

    ^self identityIndexOfKey: aKey ifAbsent: [0]
!

identityIndexOfKey: aKey ifAbsent: exceptionBlock 
    "Return the identity index of aKey within the receiver.  If the receiver does
    not contain aKey, return the result of evaluating the exceptionBlock."

    ^ order identityIndexOf:aKey ifAbsent:exceptionBlock
!

identityIndexOfValue: aValue 
    "Return the identity index of aValue within the receiver. If the receiver 
    does not contain aValue, return 0."

    ^self identityIndexOfValue: aValue ifAbsent: [0]
!

identityIndexOfValue: aValue ifAbsent: exceptionBlock 
    "Return the identity index of aValue within the receiver. If the receiver 
    does not contain aValue, return the result of evaluating the exceptionBlock."

    order keysAndValuesDo:[:i :key | (self at:key) == aValue ifTrue: [^i]].
    ^exceptionBlock value
!

indexOfAssociation: anAssociation 
    "Return the index of anAssociation within the receiver. If the receiver does
    not contain anAssociation, return 0."

    ^self indexOfAssociation: anAssociation ifAbsent: [0]
!

indexOfAssociation: anAssociation ifAbsent: exceptionBlock 
    "Return the identity index of anAssociation within the receiver. If the receiver
    does not contain anAssociation, return the result of evaluating the exceptionBlock."

    order keysAndValuesDo:[:i :key | 
        (self associationAt:key) = anAssociation ifTrue: [^i]
    ].
    ^exceptionBlock value
!

indexOfKey: aKey 
    "Return the index of aKey within the receiver. If the receiver does 
     not contain aKey, return 0."

    ^self indexOfKey: aKey ifAbsent: [0]
!

indexOfKey: aKey ifAbsent: exceptionBlock 
    "Return the identity index of aKey within the receiver.  If the receiver does
     not contain aKey, return the result of evaluating the exceptionBlock."

    ^ order indexOf:aKey ifAbsent:exceptionBlock
!

indexOfValue: aValue 
    "Return the index of aValue within the receiver. 
     If the receiver does not contain aValue, return 0."

    ^self indexOfValue: aValue ifAbsent: [0]
!

indexOfValue: aValue ifAbsent: exceptionBlock 
    "Return the identity index of aValue within the receiver. 
     If the receiver does not contain aValue, return the result of evaluating the exceptionBlock."

    order keysAndValuesDo:[:i :key | (self at:key) = aValue ifTrue: [^i]].
    ^ exceptionBlock value
!

nextIndexOfAssociation: aAssociation from: startIndex to: stopIndex 
    "Return the next index of aAssociation within the receiver between startIndex
     and stopIndex. If the receiver does not contain aAssociation, return nil"

    |start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }"|

    start := startIndex.
    stop := stopIndex.
    start to: stop do: [:i | 
        (self associationAt: (order at: i)) = aAssociation ifTrue: [^i]].
    ^nil
!

nextIndexOfKey: aKey from: startIndex to: stopIndex 
    "Return the next index of aKey within the receiver between startIndex and 
     stopIndex.  If the receiver does not contain aKey, return nil"

    |start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }"|

    start := startIndex.
    stop := stopIndex.
    start to: stop do: [:i | 
        (order at: i) = aKey ifTrue: [^i]].
    ^nil
!

nextIndexOfValue: aValue from: startIndex to: stopIndex 
    "Return the next index of aValue within the receiver between startIndex and
     stopIndex. If the receiver does not contain aValue, return nil"

    |start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }" |

    start := startIndex. 
    stop := stopIndex.  
    start to: stop do: [:i | 
        (self at: (order at: i)) = aValue ifTrue: [^i]].
    ^nil
!

prevIndexOfAssociation: aAssociation from: startIndex to: stopIndex 
    "Return the previous index of aAssociation within the receiver between 
     startIndex  and stopIndex working backwards through the receiver. 
     If the receiver does not contain aAssociation, return nil"

    |start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }"|

    start := startIndex.
    stop := stopIndex.
    start to: stop by: -1
            do: [:i | (self associationAt: (order at: i)) = aAssociation ifTrue: [^i]].
    ^nil
!

prevIndexOfKey: aKey from: startIndex to: stopIndex 
    "Return the previous index of aKey within the receiver between startIndex and
     stopIndex working backwards through the receiver. 
     If the receiver does not contain aKey, return nil"

    |start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }"|

    start := startIndex.
    stop := stopIndex.
    start to: stop by: -1
            do: [:i | (order at: i) = aKey ifTrue: [^i]].
    ^nil
!

prevIndexOfValue:aValue from:startIndex to:stopIndex 
    "Return the previous index of aValue within the receiver between startIndex
     and stopIndex working backwards through the receiver.
     If the receiver does not contain aValue, return nil"
    
    |start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }"|

    start := startIndex.
    stop := stopIndex.
    start to:stop by:-1 do:[:i | 
        (self at:(order at:i)) = aValue ifTrue:[
            ^ i
        ]
    ].
    ^ nil
! !

!OrderedDictionary methodsFor:'sorting & reordering'!

reverse
    "Destructively reverse my order.
     WARNING: this is a destructive operation, which modifies the receiver.
              Please use reversed (with a d) for a functional version."

    order reverse
!

sort
    "Destructively sort my order.
     WARNING: this is a destructive operation, which modifies the receiver"

    order sort
!

sort:aSortBlock
    "Destructively sort my order.
     WARNING: this is a destructive operation, which modifies the receiver"

    order sort:aSortBlock
! !

!OrderedDictionary methodsFor:'testing'!

isOrdered
    "return true, if the receiver's elements are ordered.
     Re-redefined to true here, as I do have an order"

    ^ true
! !

!OrderedDictionary class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

