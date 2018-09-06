"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

Collection subclass:#MappedCollection
	instanceVariableNames:'domain map'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Sequenceable'
!

!MappedCollection class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    MappedCollections represent collections of objects that are indirectly indexed by names.
    There are really two collections involved: domain and a map.  The map maps
    between external names and indices into domain, which contains the
    real association.  In order to work properly, the domain and map objects must
    be instances of a subclass of SequenceableCollection or Dictionary. 

    [author:]
        Claus Gittinger
"
!

examples
"
                                            [exBegin]
    |mapped dict|

    dict := Dictionary new
                at:'uno' put:1;
                at:'due' put:2;
                at:'tre' put:3;
                at:'quattro' put:4;
                yourself.

    mapped := MappedCollection
                    collection:#(one two three four)
                    map:dict.

    mapped at:'tre'.
    mapped select:[:each| each ~= 'two']
"
! !

!MappedCollection class methodsFor:'instance creation'!

collection:domainCollection map:mapCollection
    "return a new MappedCollection"

    ^ super new setCollection:domainCollection map:mapCollection
!

new
    "report an error; mappedCollections may not be created using new"

    self error:'use collection:map: to create a MappedCollection'
! !

!MappedCollection methodsFor:'accessing'!

at:key
    "retrieve an element"

    ^ domain at:(map at:key)

    "Modified: 2.8.1996 / 21:04:01 / cg"
!

at:key put:anObject
    "store an element"

    ^ domain at:(map at:key) put:anObject

    "Modified: 2.8.1996 / 21:04:06 / cg"
!

contents
    "return the contents as a bag"

    |contents|

    contents := Bag new.
    map do:[:key | contents add:(domain at:key)].
    ^ contents

    "Modified: 2.8.1996 / 21:04:10 / cg"
! !

!MappedCollection methodsFor:'adding & removing'!

add:anObject
    "report an error; mappedCollections cannot add elements (without a key)"

    self shouldNotImplement

    "Modified: 2.8.1996 / 21:03:57 / cg"
! !

!MappedCollection methodsFor:'copying'!

postCopy
    domain := domain copy.
    map := map copy
! !

!MappedCollection methodsFor:'enumerating'!

do:aBlock
    "evaluate the argument, aBlock for each element"

    map do:[:mapValue | aBlock value:(domain at:mapValue)].
! !

!MappedCollection methodsFor:'private'!

setCollection:domainCollection map:mapCollection
    domain := domainCollection.
    map := mapCollection
! !

!MappedCollection methodsFor:'queries'!

isFixedSize
    "return true if the receiver cannot grow"

    ^ false
!

size
    "return the number of elements in the receiver"

    ^ map size
!

species
    "return the type of collection to be returned by collect, select etc."

    ^ domain species
!

speciesForAdding
    "like species, but redefined for collections which cannot grow easily.
     Used by functions which create a growing collection 
     (see collect:with:, for example)"

    ^ domain speciesForAdding
! !

!MappedCollection class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

