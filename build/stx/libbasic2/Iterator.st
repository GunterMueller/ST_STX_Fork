"
 COPYRIGHT.
 The above file is a Manchester Goodie protected by copyright.
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
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Collection subclass:#Iterator
	instanceVariableNames:'block'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

Iterator comment:'An Iterator is a read-only collection that evaluates a block to yield the elements
 of the collection.'
!

!Iterator class methodsFor:'documentation'!

copyright
"
 COPYRIGHT.
 The above file is a Manchester Goodie protected by copyright.
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
    Occasionally you may have a block that when evaluated can be
    treated as a collection -- i.e. it takes another block as parameter,
    then applies that to a sequence of values.

    This goodie wraps the block into an object -- an iterator -- which is
    part of the collection hierarchy, and therefore inherits a variety of
    useful collection-related methods.

    [info:]
	NAME            Iterator
	AUTHOR          miw@cs.man.ac.uk (Mario Wolczko)
	FUNCTION        a wrapper for blocks that iterate over collections
	ST-VERSION      4.0 4.1
	PREREQUISITES   
	CONFLICTS
	DISTRIBUTION    world
	VERSION         1
	DATE    18 Jun 1991
	SUMMARY

    [organisation:]
	Dept. of Computer Science   Internet:      mario@cs.man.ac.uk
	The University              uucp:        uknet!!!!man.cs!!!!mario
	Manchester M13 9PL          JANET:         mario@uk.ac.man.cs
	U.K.                        Tel: +44-61-275 6146  (FAX: 6236)
	______the mushroom project___________________________________

    [author:]
	Mario Wolczko miw@cs.man.ac.uk
"

!

examples
"
 an iterator, simulating the collection of all classes in the system:
									[exBegin]
     |i b|

     b := [:whatToDo |
	       Smalltalk allClassesDo:[:cls | 
		  whatToDo value:cls
	       ] 
	  ].

     i := Iterator on:b.
     i do:[:cls |
	Transcript showCR:cls name
     ].
									[exEnd]
 much like above, one that simulates the collection of all methodNames starting with 'a':
									[exBegin]
     |i b|

     b := [:whatToDo |
	       Smalltalk allClassesDo:[:cls |
		  cls methodDictionary keysAndValuesDo:[:nm :mthd |
		    (nm startsWith:$a) ifTrue:[
		       whatToDo value:nm
		     ]
		  ]
	       ] 
	  ].

     i := Iterator on:b.
     i do:[:nm |
	Transcript showCR:nm
     ].
									[exEnd]
 an iterator, simulating a collection of 100 random values:
									[exBegin]
     |i b|

     b := [:whatToDo |
	       |rnd|

	       rnd := Random new.
	       1 to:100 do:[:i | 
		  whatToDo value:(rnd next)
	       ] 
	  ].

     i := Iterator on:b.
     i do:[:j |
	j printNL
     ].
									[exEnd]
 an iterator, simulating a collection of the lines
 in a file:
									[exBegin]
     |i b|

     b := [:whatToDo |
	       |s line|

	       s := 'smalltalk.rc' asFilename readStream.
	       [s atEnd] whileFalse:[
		  line := s nextLine.
		  whatToDo value:line.
	       ].
	       s close
	  ].

     i := Iterator on:b.
     i do:[:j |
	j printNL
     ].
									[exEnd]
"
! !

!Iterator class methodsFor:'instance creation'!

on: aBlock
    ^ self new block: aBlock

    "
     |i b|

     b := [:whatToDo | 
               1 to:10 do:[:i | 
                  whatToDo value:i
               ] 
          ].

     i := Iterator on:b.
     i do:[:j |
        Transcript showCR:j
     ].
    "

    "
     an iterator, simulating a collection of 100 random values:

     |i b|

     b := [:whatToDo |
               |rnd|

               rnd := Random new.
               1 to:100 do:[:i | 
                  whatToDo value:(rnd next)
               ] 
          ].

     i := Iterator on:b.
     i do:[:j |
        j printNL
     ].
    "

    "Modified: 9.5.1996 / 14:26:49 / cg"
!

on:collection msg:oneArgSelector
    ^ self new block: [ :aBlock | collection perform:oneArgSelector with: aBlock]

    "
    |i|

     i := Iterator on:#(1 2 3 4 5 6 7) msg:#reverseDo:.
     i do:[:j |
        Transcript showCR:j
     ].
    "

    "Modified: 9.5.1996 / 14:21:40 / cg"
! !

!Iterator methodsFor:'accessing'!

identityIndexOf: anElement 
    "Answer the identity index of anElement within the receiver.  
     If the receiver does not contain anElement, answer 0."

    ^self identityIndexOf: anElement ifAbsent: [0]
!

identityIndexOf: anElement ifAbsent: exceptionBlock 
    "Answer the identity index of anElement within the receiver.  
     If the receiver does not contain anElement, answer the result 
     of evaluating the exceptionBlock."

    | index |
    index := 1.
    self do: [ :el | el == anElement ifTrue: [^index].  index := index + 1].
    ^exceptionBlock value
!

indexOf: anElement 
    "Answer the index of anElement within the receiver.  If the receiver does
    not contain anElement, answer 0."

    ^self indexOf: anElement ifAbsent: [0]
!

indexOf: anElement ifAbsent: exceptionBlock 
    "Answer the index of anElement within the receiver. If the receiver does
     not contain anElement, answer the result of evaluating the exceptionBlock."

    | index |

    index := 1.
    self do: [ :el | el = anElement ifTrue: [^index].  index := index + 1].
    ^ exceptionBlock value
! !

!Iterator methodsFor:'adding & removing'!

add: anObject
    "raises an error: Iterators are read-only"

    self shouldNotImplement
!

remove: oldObject ifAbsent: anExceptionBlock 
    "Iterators are read-only."
    
    self shouldNotImplement
!

removeIdentical: oldObject ifAbsent: anExceptionBlock 
    "Iterators are read-only."

    self shouldNotImplement
! !

!Iterator methodsFor:'converting'!

asOrderedCollection
    "Answer a new instance of OrderedCollection whose elements are the elements of
    the receiver.  The order in which elements are added depends on the order in
    which the receiver enumerates its elements.  In the case of unordered collections,
    the ordering is not necessarily the same for multiple requests for the conversion."

    | anOrderedCollection |

    anOrderedCollection := OrderedCollection new.
    self do: [:each | anOrderedCollection add:each].
    ^anOrderedCollection
!

asSet
    "return a Set with the receiver collection's elements.
     Notice: this is redefined in Set, where it returns the receiver. 
     Use asNewSet, if you intent to modify the returned collection."

    ^ self addAllTo:(Set new)

    "Created: / 17-08-2016 / 16:02:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Iterator methodsFor:'enumerating'!

collect:aBlock
    "for each element in the receiver, evaluate the argument, aBlock
     and return a new collection with the results"

    |newCollection|

    newCollection := self speciesForCollecting new.
    self do:[:element | newCollection add:(aBlock value:element)].
    ^ newCollection

    "
     #(1 2 3 4) asSet collect:[:n | n * 2]  
    "

    "Created: / 17-06-2016 / 17:12:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

collect:aBlock as:aClass
    "Reimplemented here as Iterator does not support #size"

    |newCollection|

    newCollection := aClass new.
    self do:[:el |
        newCollection add:(aBlock value:el).
    ].
    ^ newCollection

    "
     #(one two three four five six) collect:[:element | element asUppercase] as:OrderedCollection
     'abcdef' collect:[:char | char digitValue] as:ByteArray
    "

    "Created: / 21-10-2013 / 16:07:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

collectWithIndex:aTwoArgBlock
    "for each element in the receiver and a running index, 
     evaluate the argument, aTwoArgBlock.
     Return a new collection with the results"

    |newCollection runIndex|

    newCollection := self speciesForCollecting new.
    runIndex := 1.
    self do:[:element | 
        newCollection add:(aTwoArgBlock value:element value:runIndex).
        runIndex := runIndex + 1.
    ].
    ^ newCollection

    "
     #(1 2 3 4) collectWithIndex:[:n :i | n * 2 + i]  
     #(1 2 3 4) collectWithIndex:[:n :i | i -> (n * 2)]  
    "

    "Created: / 17-06-2016 / 17:12:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

detectLast:aBlock ifNone:anExceptionValue
    "evaluate the argument, aBlock for each element in the receiver until
     the block returns true; in this case return the element which caused
     the true evaluation. The elements are processed in reverse order.
     If none of the evaluations returns true, return the value of anExceptionValue"

    | last |

    self do: [:each |
        (aBlock value:each) ifTrue: [last := each]
    ].
    last isNil ifTrue:[
        ^ anExceptionValue value.
    ].
    ^ last

    "
     (Iterator on:[:whatToDo| #(1 2 3 4) do:whatToDo]) detectLast:[:n | n odd] ifNone:['sorry']    
     (Iterator on:[:whatToDo| #(2 4 6 8) do:whatToDo]) detectLast:[:n | n odd] ifNone:['sorry']    
    "
!

do: aBlock
    block value: aBlock
!

findFirst: aBlock ifNone:exceptionalValue
    "Answer the index of the first element of the receiver
    for which aBlock evaluates as true."

    | index |

    index := 1.
    self do: [ :el | (aBlock value: el) ifTrue: [^index].  index := index + 1].
    ^exceptionalValue value
!

findLast: aBlock
    "Answer the index of the last element of the receiver
     for which aBlock evaluates as true."

    | index last |
    index := 1.
    last := 0.
    self do: [ :el | (aBlock value: el) ifTrue: [last := index].  index := index + 1].
    ^last
!

keysAndValuesDo: aBlock  
    "Evaluate aBlock with each of the receiver's key/value pairs
    (e.g. indexes and elements) as the arguments."

    | index |

    index := 1.
    self do: [:el | aBlock value: index value: el.  index := index + 1]
!

reverseDo:aBlock
    "evaluate the argument, aBlock for each element in reverse order."

    "it could be defined in terms of do: - but very inefficient.
     Better force programmer to define a better version ..."

    ^ self shouldNotImplement
! !


!Iterator methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifTrue:[
        aGCOrStream nextPutAll:'Iterator('.
        block displayOn:aGCOrStream.
        aGCOrStream nextPutAll:')'.
        ^ self
    ].
    ^ super displayOn:aGCOrStream.

    "Modified: / 06-10-2006 / 14:35:23 / cg"
!

printOn:aStream
    aStream nextPutAll:'Iterator('.
    block printOn:aStream.
    aStream nextPutAll:')'.

    "Created: / 06-10-2006 / 13:44:42 / cg"
! !

!Iterator methodsFor:'private'!

block
    ^ block 
!

block: aBlock
    block := aBlock
!

species
    "return the type of collection to be returned by collect, select etc."

    ^ OrderedCollection
! !

!Iterator methodsFor:'queries'!

isEmpty
    ^ false

    "Created: / 15-03-2007 / 16:23:48 / cg"
!

size
    self shouldNotImplement

    "Created: / 1.11.1997 / 17:29:03 / cg"
! !

!Iterator class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

